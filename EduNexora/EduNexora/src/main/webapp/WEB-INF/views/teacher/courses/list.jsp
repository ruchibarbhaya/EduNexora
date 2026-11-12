<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Assigned Courses" />
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
                    <h3 class="fw-bold text-dark mb-1">My Assigned Courses</h3>
                    <p class="text-muted small mb-0">Curriculum units and lecture courses allocated to your teaching schedule.</p>
                </div>
            </div>

            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th>Duration</th>
                                <th>Tuition Fee</th>
                                <th>Active Students</th>
                                <th class="text-end">Roster</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="course" items="${courses}">
                                <tr>
                                    <td><span class="badge bg-light text-secondary border">#<c:out value="${course.id}"/></span></td>
                                    <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle fw-bold"><c:out value="${course.courseCode}"/></span></td>
                                    <td>
                                        <div class="fw-semibold text-dark"><c:out value="${course.courseName}"/></div>
                                        <small class="text-muted text-truncate d-inline-block" style="max-width: 320px;"><c:out value="${course.description}"/></small>
                                    </td>
                                    <td><i class="bi bi-clock me-1 text-muted"></i><c:out value="${course.duration}"/></td>
                                    <td class="fw-bold text-dark">$<c:out value="${course.fees}"/></td>
                                    <td>
                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                            <i class="bi bi-people-fill me-1"></i><c:out value="${enrolledCounts.get(course.id)}"/> Enrolled
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/teacher/courses/${course.id}" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-people"></i> View Students
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty courses}">
                    <div class="empty-state">
                        <i class="bi bi-book empty-state-icon"></i>
                        <h5 class="empty-state-title">No Courses Assigned</h5>
                        <p class="empty-state-text">You currently do not have any courses assigned by the administrator.</p>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

