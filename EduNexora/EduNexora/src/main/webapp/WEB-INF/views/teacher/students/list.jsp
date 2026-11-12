<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty Students Directory" />
<c:set var="activeMenu" value="students" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Registered Students Directory</h3>
                    <p class="text-muted small mb-0">Roster of students enrolled across all of your assigned teaching courses.</p>
                </div>
            </div>

            <!-- Filter & Search Card -->
            <div class="content-card mb-4">
                <div class="content-card-body p-3">
                    <form action="${pageContext.request.contextPath}/teacher/students" method="get" class="row g-2 align-items-center">
                        <div class="col-md-5 col-lg-5">
                            <div class="input-group">
                                <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                                <input type="text" name="search" value="<c:out value="${search}"/>" class="form-control border-start-0" 
                                       placeholder="Search student by name, email, or phone..." />
                            </div>
                        </div>
                        <div class="col-md-3 col-lg-3">
                            <select name="courseId" class="form-select">
                                <option value="">-- All My Courses --</option>
                                <c:forEach var="c" items="${courses}">
                                    <option value="${c.id}" ${c.id == selectedCourseId ? 'selected' : ''}>
                                        <c:out value="${c.courseCode}"/> - <c:out value="${c.courseName}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2 col-lg-2">
                            <select name="status" class="form-select">
                                <option value="">-- All Statuses --</option>
                                <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                            </select>
                        </div>
                        <div class="col-md-2 col-lg-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-funnel-fill"></i> Filter</button>
                            <c:if test="${not empty search || not empty selectedCourseId || not empty selectedStatus}">
                                <a href="${pageContext.request.contextPath}/teacher/students" class="btn btn-outline-secondary" title="Clear Filters">
                                    <i class="bi bi-x-circle"></i>
                                </a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Students Table -->
            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th>Student #</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Course</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${enrollmentPage.content}">
                                <tr>
                                    <td><span class="badge bg-light text-secondary border">#<c:out value="${e.student.id}"/></span></td>
                                    <td class="fw-semibold text-dark"><c:out value="${e.student.name}"/></td>
                                    <td><c:out value="${e.student.email}"/></td>
                                    <td><c:out value="${e.student.phone != null ? e.student.phone : '-'}"/></td>
                                    <td>
                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle me-1"><c:out value="${e.course.courseCode}"/></span>
                                        <c:out value="${e.course.courseName}"/>
                                    </td>
                                    <td><c:out value="${e.enrollmentDate}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${e.status == 'ACTIVE'}">
                                                <span class="badge-active"><i class="bi bi-check-circle me-1"></i> ACTIVE</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-cancelled"><i class="bi bi-x-circle me-1"></i> CANCELLED</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty enrollmentPage.content}">
                    <div class="empty-state">
                        <i class="bi bi-people empty-state-icon"></i>
                        <h5 class="empty-state-title">No Students Found</h5>
                        <p class="empty-state-text">No registered students found matching your selected search or filter criteria.</p>
                    </div>
                </c:if>

                <!-- Pagination -->
                <c:if test="${enrollmentPage.totalPages > 1}">
                    <div class="d-flex justify-content-between align-items-center p-3 border-top">
                        <small class="text-muted">
                            Showing page <c:out value="${enrollmentPage.number + 1}"/> of <c:out value="${enrollmentPage.totalPages}"/> (<c:out value="${enrollmentPage.totalElements}"/> students)
                        </small>
                        <ul class="pagination pagination-sm m-0">
                            <li class="page-item ${enrollmentPage.first ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${enrollmentPage.number - 1}&search=<c:out value='${search}'/>&courseId=<c:out value='${selectedCourseId}'/>&status=<c:out value='${selectedStatus}'/>">Previous</a>
                            </li>
                            <c:forEach begin="0" end="${enrollmentPage.totalPages - 1}" var="p">
                                <li class="page-item ${p == enrollmentPage.number ? 'active' : ''}">
                                    <a class="page-link" href="?page=${p}&search=<c:out value='${search}'/>&courseId=<c:out value='${selectedCourseId}'/>&status=<c:out value='${selectedStatus}'/>">${p + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${enrollmentPage.last ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${enrollmentPage.number + 1}&search=<c:out value='${search}'/>&courseId=<c:out value='${selectedCourseId}'/>&status=<c:out value='${selectedStatus}'/>">Next</a>
                            </li>
                        </ul>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

