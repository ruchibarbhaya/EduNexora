<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Browse Available Courses" />
<c:set var="activeMenu" value="browse-courses" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Explore Curriculum Offerings</h3>
                    <p class="text-muted small mb-0">Browse verified courses taught by university faculty and register online.</p>
                </div>
            </div>

            <!-- Search Bar -->
            <div class="content-card mb-4">
                <div class="content-card-body p-3">
                    <form action="${pageContext.request.contextPath}/student/courses" method="get" class="row g-2 align-items-center">
                        <div class="col-md-10">
                            <div class="input-group">
                                <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                                <input type="text" name="search" value="<c:out value="${search}"/>" class="form-control border-start-0" 
                                       placeholder="Search courses by course code or title..." />
                            </div>
                        </div>
                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-filter"></i> Search</button>
                            <c:if test="${not empty search}">
                                <a href="${pageContext.request.contextPath}/student/courses" class="btn btn-outline-secondary" title="Clear Search">
                                    <i class="bi bi-x-circle"></i>
                                </a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Course Cards Grid -->
            <div class="row g-4 mb-4">
                <c:forEach var="course" items="${coursePage.content}">
                    <div class="col-md-6 col-lg-4">
                        <div class="content-card h-100 d-flex flex-column transition-hover">
                            <div class="content-card-header d-flex justify-content-between align-items-center">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle fw-bold">
                                    <c:out value="${course.courseCode}"/>
                                </span>
                                <span class="badge bg-light text-dark border">
                                    <i class="bi bi-clock me-1 text-muted"></i><c:out value="${course.duration}"/>
                                </span>
                            </div>
                            <div class="content-card-body flex-grow-1 d-flex flex-column">
                                <h5 class="fw-bold text-dark mb-2"><c:out value="${course.courseName}"/></h5>
                                <p class="text-muted small flex-grow-1" style="min-height: 48px;">
                                    <c:out value="${course.description != null ? course.description : 'Comprehensive curriculum designed for practical hands-on proficiency.'}"/>
                                </p>

                                <div class="border-top pt-3 mt-2">
                                    <div class="d-flex align-items-center justify-content-between mb-3">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="rounded-circle bg-purple-subtle text-purple d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                                                <i class="bi bi-person-workspace text-secondary"></i>
                                            </div>
                                            <div class="small">
                                                <div class="text-muted" style="font-size: 0.72rem;">Instructor</div>
                                                <div class="fw-semibold text-dark"><c:out value="${course.teacher.name}"/></div>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <div class="text-muted" style="font-size: 0.72rem;">Tuition</div>
                                            <div class="fw-bold text-primary fs-5">$<c:out value="${course.fees}"/></div>
                                        </div>
                                    </div>

                                    <c:choose>
                                        <c:when test="${enrolledCourseIds.contains(course.id)}">
                                            <div class="d-flex gap-2">
                                                <button class="btn btn-light border text-success w-100 fw-medium btn-sm" disabled>
                                                    <i class="bi bi-check-circle-fill me-1"></i> Already Enrolled
                                                </button>
                                                <a href="${pageContext.request.contextPath}/student/courses/${course.id}" class="btn btn-outline-secondary btn-sm" title="Course Details">
                                                    <i class="bi bi-info-circle"></i>
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/student/courses/${course.id}" class="btn btn-primary-custom w-100 justify-content-center btn-sm">
                                                <span>View & Enroll</span> <i class="bi bi-arrow-right"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty coursePage.content}">
                <div class="empty-state">
                    <i class="bi bi-journal-x empty-state-icon"></i>
                    <h5 class="empty-state-title">No Courses Available</h5>
                    <p class="empty-state-text">No courses with active instructors matched your search criteria.</p>
                </div>
            </c:if>

            <!-- Pagination -->
            <c:if test="${coursePage.totalPages > 1}">
                <div class="d-flex justify-content-between align-items-center p-3 border-top bg-white rounded">
                    <small class="text-muted">
                        Showing page <c:out value="${coursePage.number + 1}"/> of <c:out value="${coursePage.totalPages}"/> (<c:out value="${coursePage.totalElements}"/> courses)
                    </small>
                    <ul class="pagination pagination-sm m-0">
                        <li class="page-item ${coursePage.first ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${coursePage.number - 1}&search=<c:out value='${search}'/>">Previous</a>
                        </li>
                        <c:forEach begin="0" end="${coursePage.totalPages - 1}" var="p">
                            <li class="page-item ${p == coursePage.number ? 'active' : ''}">
                                <a class="page-link" href="?page=${p}&search=<c:out value='${search}'/>">${p + 1}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${coursePage.last ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${coursePage.number + 1}&search=<c:out value='${search}'/>">Next</a>
                        </li>
                    </ul>
                </div>
            </c:if>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

