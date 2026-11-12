<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Courses Management" />
<c:set var="activeMenu" value="courses" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-3">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Courses Catalog</h3>
                    <p class="text-muted small mb-0">Create, edit, assign instructors, and review enrolled students.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/courses/new" class="btn btn-primary-custom">
                    <i class="bi bi-plus-circle-fill"></i> Add New Course
                </a>
            </div>

            <!-- Filter & Search Card -->
            <div class="content-card mb-4">
                <div class="content-card-body p-3">
                    <form action="${pageContext.request.contextPath}/admin/courses" method="get" class="row g-2 align-items-center">
                        <div class="col-md-6 col-lg-7">
                            <div class="input-group">
                                <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                                <input type="text" name="search" value="<c:out value="${search}"/>" class="form-control border-start-0" 
                                       placeholder="Search by course code or title..." />
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3">
                            <select name="teacherId" class="form-select">
                                <option value="">-- All Teachers --</option>
                                <c:forEach var="t" items="${teachers}">
                                    <option value="${t.id}" ${t.id == selectedTeacherId ? 'selected' : ''}>
                                        <c:out value="${t.name}"/> (<c:out value="${t.department}"/>)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2 col-lg-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-funnel-fill"></i> Filter</button>
                            <c:if test="${not empty search || not empty selectedTeacherId}">
                                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-secondary" title="Reset Filters">
                                    <i class="bi bi-x-circle"></i>
                                </a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Courses Table -->
            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Course Title</th>
                                <th>Duration</th>
                                <th>Tuition Fee</th>
                                <th>Assigned Teacher</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="course" items="${coursePage.content}">
                                <tr>
                                    <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle"><c:out value="${course.courseCode}"/></span></td>
                                    <td>
                                        <div class="fw-semibold text-dark"><c:out value="${course.courseName}"/></div>
                                        <small class="text-muted text-truncate d-inline-block" style="max-width: 280px;"><c:out value="${course.description}"/></small>
                                    </td>
                                    <td><i class="bi bi-clock me-1 text-muted"></i><c:out value="${course.duration}"/></td>
                                    <td class="fw-bold text-dark">$<c:out value="${course.fees}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${course.teacher != null}">
                                                <div class="d-flex align-items-center gap-1">
                                                    <i class="bi bi-person-check-fill text-success"></i>
                                                    <span class="fw-medium"><c:out value="${course.teacher.name}"/></span>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle">Unassigned</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-inline-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/courses/${course.id}/students" class="btn btn-outline-info btn-sm" title="View Enrolled Students">
                                                <i class="bi bi-people"></i> Students
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/courses/${course.id}/edit" class="btn btn-outline-primary btn-sm" title="Edit Course">
                                                <i class="bi bi-pencil-square"></i> Edit
                                            </a>
                                            <form action="${pageContext.request.contextPath}/admin/courses/${course.id}/delete" method="post" class="d-inline">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <button type="submit" class="btn btn-outline-danger btn-sm" data-bs-confirm="Are you sure you want to delete course '<c:out value="${course.courseName}"/>'? This cannot be undone.">
                                                    <i class="bi bi-trash"></i> Delete
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty coursePage.content}">
                    <div class="empty-state">
                        <i class="bi bi-journal-x empty-state-icon"></i>
                        <h5 class="empty-state-title">No Courses Found</h5>
                        <p class="empty-state-text">No courses matched your current filter criteria. Try adjusting the search query or teacher filter.</p>
                        <a href="${pageContext.request.contextPath}/admin/courses/new" class="btn btn-primary-custom btn-sm">
                            <i class="bi bi-plus-circle-fill"></i> Add First Course
                        </a>
                    </div>
                </c:if>

                <!-- Pagination -->
                <c:if test="${coursePage.totalPages > 1}">
                    <div class="d-flex justify-content-between align-items-center p-3 border-top">
                        <small class="text-muted">
                            Showing page <c:out value="${coursePage.number + 1}"/> of <c:out value="${coursePage.totalPages}"/> (<c:out value="${coursePage.totalElements}"/> courses)
                        </small>
                        <ul class="pagination pagination-sm m-0">
                            <li class="page-item ${coursePage.first ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${coursePage.number - 1}&search=<c:out value='${search}'/>&teacherId=<c:out value='${selectedTeacherId}'/>">Previous</a>
                            </li>
                            <c:forEach begin="0" end="${coursePage.totalPages - 1}" var="p">
                                <li class="page-item ${p == coursePage.number ? 'active' : ''}">
                                    <a class="page-link" href="?page=${p}&search=<c:out value='${search}'/>&teacherId=<c:out value='${selectedTeacherId}'/>">${p + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${coursePage.last ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${coursePage.number + 1}&search=<c:out value='${search}'/>&teacherId=<c:out value='${selectedTeacherId}'/>">Next</a>
                            </li>
                        </ul>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

