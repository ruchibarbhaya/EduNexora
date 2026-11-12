<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Profile - ${student.name}" />
<c:set var="activeMenu" value="students" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Student Record</h3>
                    <p class="text-muted small mb-0">View profile information and academic course registrations.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Students
                </a>
            </div>

            <!-- Profile Summary Card -->
            <div class="content-card mb-4">
                <div class="content-card-body p-4">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center fw-bold fs-3" style="width: 64px; height: 64px;">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <div>
                            <h4 class="fw-bold text-dark mb-1"><c:out value="${student.name}"/></h4>
                            <div class="d-flex flex-wrap gap-3 text-muted small">
                                <span><i class="bi bi-envelope me-1"></i> <c:out value="${student.email}"/></span>
                                <span><i class="bi bi-telephone me-1"></i> <c:out value="${student.phone != null ? student.phone : 'N/A'}"/></span>
                                <span><i class="bi bi-calendar-event me-1"></i> Member Since: <c:out value="${student.createdAt}"/></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Enrolled Courses Card -->
            <div class="content-card">
                <div class="content-card-header">
                    <h5 class="content-card-title">
                        <i class="bi bi-book-half text-primary"></i> Registered Courses
                    </h5>
                    <span class="badge bg-primary rounded-pill"><c:out value="${student.enrollments.size()}"/> Courses</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th>Enrollment #</th>
                                <th>Course Code</th>
                                <th>Course Title</th>
                                <th>Instructor</th>
                                <th>Tuition Fee</th>
                                <th>Enrollment Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${student.enrollments}">
                                <tr>
                                    <td><span class="badge bg-light text-secondary border">#<c:out value="${e.id}"/></span></td>
                                    <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle"><c:out value="${e.course.courseCode}"/></span></td>
                                    <td class="fw-semibold text-dark"><c:out value="${e.course.courseName}"/></td>
                                    <td><c:out value="${e.course.teacher != null ? e.course.teacher.name : 'Unassigned'}"/></td>
                                    <td>$<c:out value="${e.course.fees}"/></td>
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

                <c:if test="${empty student.enrollments}">
                    <div class="empty-state">
                        <i class="bi bi-journal-x empty-state-icon"></i>
                        <h5 class="empty-state-title">No Course Enrollments</h5>
                        <p class="empty-state-text">This student has not yet enrolled in any academic courses.</p>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

