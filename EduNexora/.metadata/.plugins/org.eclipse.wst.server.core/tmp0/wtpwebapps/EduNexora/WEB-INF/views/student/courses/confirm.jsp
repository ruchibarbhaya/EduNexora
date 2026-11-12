<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Confirm Enrollment - ${course.courseCode}" />
<c:set var="activeMenu" value="browse-courses" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Confirm Course Registration</h3>
                    <p class="text-muted small mb-0">Please review your course enrollment details before submitting.</p>
                </div>
                <a href="${pageContext.request.contextPath}/student/courses/${course.id}" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Cancel & Back
                </a>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-7">
                    <div class="content-card">
                        <div class="content-card-header bg-light">
                            <h5 class="content-card-title">
                                <i class="bi bi-shield-check text-primary"></i> Enrollment Summary
                            </h5>
                        </div>
                        <div class="content-card-body p-4">
                            <div class="mb-4">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle fw-bold mb-2">
                                    <c:out value="${course.courseCode}"/>
                                </span>
                                <h4 class="fw-bold text-dark mb-2"><c:out value="${course.courseName}"/></h4>
                                <p class="text-muted small mb-0"><c:out value="${course.description}"/></p>
                            </div>

                            <div class="table-responsive mb-4">
                                <table class="table table-bordered mb-0">
                                    <tbody>
                                        <tr>
                                            <th class="bg-light text-muted w-40">Assigned Instructor</th>
                                            <td class="fw-semibold text-dark"><c:out value="${course.teacher.name}"/> (<c:out value="${course.teacher.department}"/>)</td>
                                        </tr>
                                        <tr>
                                            <th class="bg-light text-muted">Course Duration</th>
                                            <td><c:out value="${course.duration}"/></td>
                                        </tr>
                                        <tr>
                                            <th class="bg-light text-muted">Tuition Fee</th>
                                            <td class="fw-bold text-primary fs-5">$<c:out value="${course.fees}"/></td>
                                        </tr>
                                        <tr>
                                            <th class="bg-light text-muted">Enrollment Status</th>
                                            <td><span class="badge-active">ACTIVE (Upon Confirmation)</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <form action="${pageContext.request.contextPath}/student/enrollments" method="post" class="protect-double-submit">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="courseId" value="${course.id}" />

                                <div class="alert alert-info small mb-4">
                                    <i class="bi bi-info-circle-fill me-1"></i> By clicking <strong>Confirm & Complete Enrollment</strong>, your enrollment record will be officially registered in the course roster.
                                </div>

                                <div class="d-flex justify-content-end gap-3">
                                    <a href="${pageContext.request.contextPath}/student/courses/${course.id}" class="btn btn-light border">
                                        Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary-custom px-4 py-2">
                                        <span class="spinner-border spinner-border-sm me-2 d-none" role="status" aria-hidden="true"></span>
                                        <i class="bi bi-check-circle-fill"></i>
                                        <span>Confirm & Complete Enrollment</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

