<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Enrollment Record #${enrollment.id}" />
<c:set var="activeMenu" value="enrollments" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Enrollment Details</h3>
                    <p class="text-muted small mb-0">Record #<strong><c:out value="${enrollment.id}"/></strong> &bull; Registration Date: <c:out value="${enrollment.enrollmentDate}"/></p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/admin/enrollments" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Back to Enrollments
                    </a>
                    <c:if test="${enrollment.status == 'ACTIVE'}">
                        <form action="${pageContext.request.contextPath}/admin/enrollments/${enrollment.id}/cancel" method="post" class="d-inline">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="btn btn-danger" data-bs-confirm="Are you sure you want to cancel this enrollment record?">
                                <i class="bi bi-x-circle"></i> Cancel Enrollment
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-6">
                    <div class="content-card h-100">
                        <div class="content-card-header">
                            <h5 class="content-card-title"><i class="bi bi-person-circle text-primary"></i> Student Information</h5>
                        </div>
                        <div class="content-card-body">
                            <dl class="row mb-0">
                                <dt class="col-sm-4 text-muted">Full Name</dt>
                                <dd class="col-sm-8 fw-semibold text-dark"><c:out value="${enrollment.student.name}"/></dd>

                                <dt class="col-sm-4 text-muted">Email Address</dt>
                                <dd class="col-sm-8"><c:out value="${enrollment.student.email}"/></dd>

                                <dt class="col-sm-4 text-muted">Phone Number</dt>
                                <dd class="col-sm-8"><c:out value="${enrollment.student.phone != null ? enrollment.student.phone : 'N/A'}"/></dd>

                                <dt class="col-sm-4 text-muted">Member Since</dt>
                                <dd class="col-sm-8"><c:out value="${enrollment.student.createdAt}"/></dd>
                            </dl>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="content-card h-100">
                        <div class="content-card-header">
                            <h5 class="content-card-title"><i class="bi bi-book-half text-secondary"></i> Course Information</h5>
                        </div>
                        <div class="content-card-body">
                            <dl class="row mb-0">
                                <dt class="col-sm-4 text-muted">Course Title</dt>
                                <dd class="col-sm-8 fw-semibold text-dark"><c:out value="${enrollment.course.courseName}"/></dd>

                                <dt class="col-sm-4 text-muted">Course Code</dt>
                                <dd class="col-sm-8"><span class="badge bg-primary-subtle text-primary border border-primary-subtle"><c:out value="${enrollment.course.courseCode}"/></span></dd>

                                <dt class="col-sm-4 text-muted">Instructor</dt>
                                <dd class="col-sm-8"><c:out value="${enrollment.course.teacher != null ? enrollment.course.teacher.name : 'Unassigned'}"/></dd>

                                <dt class="col-sm-4 text-muted">Duration</dt>
                                <dd class="col-sm-8"><c:out value="${enrollment.course.duration}"/></dd>

                                <dt class="col-sm-4 text-muted">Tuition Fee</dt>
                                <dd class="col-sm-8 fw-bold text-dark">$<c:out value="${enrollment.course.fees}"/></dd>

                                <dt class="col-sm-4 text-muted">Current Status</dt>
                                <dd class="col-sm-8">
                                    <c:choose>
                                        <c:when test="${enrollment.status == 'ACTIVE'}">
                                            <span class="badge-active"><i class="bi bi-check-circle me-1"></i> ACTIVE</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-cancelled"><i class="bi bi-x-circle me-1"></i> CANCELLED</span>
                                        </c:otherwise>
                                    </c:choose>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

