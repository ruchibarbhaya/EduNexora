<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Dashboard" />
<c:set var="activeMenu" value="dashboard" />
<%@ include file="../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Student Learning Hub</h3>
                    <p class="text-muted small mb-0">Track your academic progress, enrolled courses, and explore curriculum offerings.</p>
                </div>
                <a href="${pageContext.request.contextPath}/student/courses" class="btn btn-primary-custom">
                    <i class="bi bi-compass-fill"></i> Explore Available Courses
                </a>
            </div>

            <!-- Stat Cards -->
            <div class="row g-4 mb-4">
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="stat-info">
                            <div class="stat-title">Active Courses</div>
                            <div class="stat-value"><c:out value="${myCoursesCount != null ? myCoursesCount : 0}" /></div>
                        </div>
                        <div class="stat-icon blue"><i class="bi bi-bookmark-check-fill"></i></div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="stat-info">
                            <div class="stat-title">Available Offerings</div>
                            <div class="stat-value"><c:out value="${availableCoursesCount != null ? availableCoursesCount : 0}" /></div>
                        </div>
                        <div class="stat-icon purple"><i class="bi bi-compass-fill"></i></div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div class="stat-info">
                            <div class="stat-title">Total Registrations</div>
                            <div class="stat-value"><c:out value="${totalEnrollmentsCount != null ? totalEnrollmentsCount : 0}" /></div>
                        </div>
                        <div class="stat-icon green"><i class="bi bi-journal-text"></i></div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity Table -->
            <div class="content-card">
                <div class="content-card-header">
                    <h5 class="content-card-title">
                        <i class="bi bi-clock-history text-primary"></i> Recent Enrollment Activity
                    </h5>
                    <a href="${pageContext.request.contextPath}/student/my-courses" class="btn btn-outline-primary btn-sm">
                        View All
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th>Course Code</th>
                                <th>Course Title</th>
                                <th>Instructor</th>
                                <th>Enrollment Date</th>
                                <th>Status</th>
                                <th class="text-end">Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${recentEnrollments}">
                                <tr>
                                    <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle"><c:out value="${e.course.courseCode}"/></span></td>
                                    <td class="fw-semibold text-dark"><c:out value="${e.course.courseName}"/></td>
                                    <td><c:out value="${e.course.teacher != null ? e.course.teacher.name : 'Unassigned'}"/></td>
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
                                        <a href="${pageContext.request.contextPath}/student/courses/${e.course.id}" class="btn btn-outline-secondary btn-sm">
                                            <i class="bi bi-arrow-right"></i> Course Page
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty recentEnrollments}">
                    <div class="empty-state">
                        <i class="bi bi-mortarboard empty-state-icon"></i>
                        <h5 class="empty-state-title">No Enrolled Courses Yet</h5>
                        <p class="empty-state-text">You are not registered in any course at the moment. Browse the course catalog and enroll today!</p>
                        <a href="${pageContext.request.contextPath}/student/courses" class="btn btn-primary-custom btn-sm">
                            <i class="bi bi-search"></i> Browse Catalog
                        </a>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../layout/footer.jsp" %>
    </div>
</div>
