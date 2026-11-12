<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Enrolled Students - ${course.courseCode}" />
<c:set var="activeMenu" value="courses" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Students in <c:out value="${course.courseName}"/></h3>
                    <p class="text-muted small mb-0">Course Code: <strong><c:out value="${course.courseCode}"/></strong> &bull; Instructor: <strong><c:out value="${course.teacher != null ? course.teacher.name : 'Unassigned'}"/></strong></p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Courses
                </a>
            </div>

            <div class="content-card">
                <div class="content-card-header">
                    <h5 class="content-card-title">
                        <i class="bi bi-people-fill text-primary"></i> Registered Students List
                    </h5>
                    <span class="badge bg-primary rounded-pill"><c:out value="${enrollments.size()}"/> Enrolled</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th>Enrollment #</th>
                                <th>Student Name</th>
                                <th>Email Address</th>
                                <th>Phone</th>
                                <th>Enrollment Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${enrollments}">
                                <tr>
                                    <td><span class="badge bg-light text-secondary border">#<c:out value="${e.id}"/></span></td>
                                    <td class="fw-semibold text-dark">
                                        <a href="${pageContext.request.contextPath}/admin/students/${e.student.id}" class="text-decoration-none">
                                            <c:out value="${e.student.name}"/>
                                        </a>
                                    </td>
                                    <td><c:out value="${e.student.email}"/></td>
                                    <td><c:out value="${e.student.phone != null ? e.student.phone : '-'}"/></td>
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

                <c:if test="${empty enrollments}">
                    <div class="empty-state">
                        <i class="bi bi-people empty-state-icon"></i>
                        <h5 class="empty-state-title">No Enrolled Students</h5>
                        <p class="empty-state-text">There are currently no students enrolled in this course.</p>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

