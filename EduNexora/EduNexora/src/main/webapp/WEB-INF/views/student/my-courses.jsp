<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Enrolled Courses" />
<c:set var="activeMenu" value="my-courses" />
<%@ include file="../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
                <div>
                    <h3 class="fw-bold text-dark mb-1">My Enrolled Courses</h3>
                    <p class="text-muted small mb-0">Review your active course registrations, past enrollments, and academic schedule.</p>
                </div>
                <a href="${pageContext.request.contextPath}/student/courses" class="btn btn-primary-custom">
                    <i class="bi bi-search"></i> Browse More Courses
                </a>
            </div>

            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th>Enrollment #</th>
                                <th>Code</th>
                                <th>Course Title</th>
                                <th>Instructor</th>
                                <th>Duration</th>
                                <th>Tuition Fee</th>
                                <th>Registration Date</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${enrollments}">
                                <tr>
                                    <td><span class="badge bg-light text-secondary border">#<c:out value="${e.id}"/></span></td>
                                    <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle"><c:out value="${e.course.courseCode}"/></span></td>
                                    <td class="fw-semibold text-dark"><c:out value="${e.course.courseName}"/></td>
                                    <td><c:out value="${e.course.teacher != null ? e.course.teacher.name : 'Unassigned'}"/></td>
                                    <td><c:out value="${e.course.duration}"/></td>
                                    <td class="fw-bold text-dark">$<c:out value="${e.course.fees}"/></td>
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
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/student/courses/${e.course.id}" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-eye"></i> Course Page
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty enrollments}">
                    <div class="empty-state">
                        <i class="bi bi-mortarboard empty-state-icon"></i>
                        <h5 class="empty-state-title">No Course Enrollments Found</h5>
                        <p class="empty-state-text">You are not currently enrolled in any courses. Explore our available course catalog and start learning today!</p>
                        <a href="${pageContext.request.contextPath}/student/courses" class="btn btn-primary-custom btn-sm">
                            <i class="bi bi-compass-fill"></i> Browse Courses Catalog
                        </a>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../layout/footer.jsp" %>
    </div>
</div>

