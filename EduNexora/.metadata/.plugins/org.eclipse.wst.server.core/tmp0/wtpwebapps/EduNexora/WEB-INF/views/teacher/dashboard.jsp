<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty Dashboard" />
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
                    <h3 class="fw-bold text-dark mb-1">Faculty Instruction Portal</h3>
                    <p class="text-muted small mb-0">Overview of your assigned curriculum, classroom enrollments, and student registrations.</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/teacher/courses" class="btn btn-primary-custom btn-sm">
                        <i class="bi bi-collection-play-fill"></i> My Courses
                    </a>
                    <a href="${pageContext.request.contextPath}/teacher/students" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-people"></i> Enrolled Students
                    </a>
                </div>
            </div>

            <!-- Stats Overview Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="stat-card">
                        <div class="stat-info">
                            <div class="stat-title">Assigned Teaching Courses</div>
                            <div class="stat-value"><c:out value="${assignedCoursesCount != null ? assignedCoursesCount : 0}" /></div>
                        </div>
                        <div class="stat-icon purple"><i class="bi bi-book-half"></i></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="stat-card">
                        <div class="stat-info">
                            <div class="stat-title">Active Enrolled Students</div>
                            <div class="stat-value"><c:out value="${totalEnrolledStudents != null ? totalEnrolledStudents : 0}" /></div>
                        </div>
                        <div class="stat-icon green"><i class="bi bi-people-fill"></i></div>
                    </div>
                </div>
            </div>

            <!-- Recent Registrations Card -->
            <div class="content-card">
                <div class="content-card-header">
                    <h5 class="content-card-title">
                        <i class="bi bi-clock-history text-primary"></i> Recent Course Registrations
                    </h5>
                    <a href="${pageContext.request.contextPath}/teacher/students" class="btn btn-outline-primary btn-sm">
                        View All
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th>Enrollment #</th>
                                <th>Student Name</th>
                                <th>Email Address</th>
                                <th>Course</th>
                                <th>Registration Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${recentEnrollments}">
                                <tr>
                                    <td><span class="badge bg-light text-secondary border">#<c:out value="${e.id}"/></span></td>
                                    <td class="fw-semibold text-dark"><c:out value="${e.student.name}"/></td>
                                    <td><c:out value="${e.student.email}"/></td>
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

                <c:if test="${empty recentEnrollments}">
                    <div class="empty-state">
                        <i class="bi bi-people empty-state-icon"></i>
                        <h5 class="empty-state-title">No Recent Enrollments</h5>
                        <p class="empty-state-text">There are currently no recent student enrollments in your assigned courses.</p>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../layout/footer.jsp" %>
    </div>
</div>
