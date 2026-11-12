<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${course.courseName}" />
<c:set var="activeMenu" value="browse-courses" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
                <div>
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle fw-bold mb-1"><c:out value="${course.courseCode}"/></span>
                    <h3 class="fw-bold text-dark mb-1"><c:out value="${course.courseName}"/></h3>
                </div>
                <a href="${pageContext.request.contextPath}/student/courses" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Catalog
                </a>
            </div>

            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="content-card mb-4">
                        <div class="content-card-header">
                            <h5 class="content-card-title"><i class="bi bi-info-circle text-primary"></i> Course Overview & Curriculum</h5>
                        </div>
                        <div class="content-card-body">
                            <p class="text-secondary leading-relaxed fs-6">
                                <c:out value="${course.description != null ? course.description : 'Detailed curriculum and syllabus will be provided upon enrollment.'}"/>
                            </p>
                        </div>
                    </div>

                    <div class="content-card">
                        <div class="content-card-header">
                            <h5 class="content-card-title"><i class="bi bi-person-badge text-secondary"></i> Instructor Information</h5>
                        </div>
                        <div class="content-card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="rounded-circle bg-purple-subtle text-secondary d-flex align-items-center justify-content-center fw-bold fs-3" style="width: 56px; height: 56px;">
                                    <i class="bi bi-mortarboard-fill"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold text-dark mb-1"><c:out value="${course.teacher.name}"/></h5>
                                    <div class="text-muted small">
                                        <span><i class="bi bi-building me-1"></i> Department of <c:out value="${course.teacher.department}"/></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="content-card">
                        <div class="content-card-header">
                            <h5 class="content-card-title"><i class="bi bi-card-checklist text-primary"></i> Registration Details</h5>
                        </div>
                        <div class="content-card-body">
                            <div class="d-flex justify-content-between align-items-center mb-3 pb-3 border-bottom">
                                <span class="text-muted"><i class="bi bi-clock me-1"></i> Course Duration</span>
                                <span class="fw-semibold text-dark"><c:out value="${course.duration}"/></span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                                <span class="text-muted"><i class="bi bi-cash-coin me-1"></i> Total Tuition</span>
                                <span class="fw-bold text-primary fs-4">$<c:out value="${course.fees}"/></span>
                            </div>

                            <c:choose>
                                <c:when test="${isEnrolled}">
                                    <div class="alert alert-success d-flex align-items-center mb-3">
                                        <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                                        <div>You are currently actively enrolled in this course.</div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/student/my-courses" class="btn btn-outline-primary w-100">
                                        <i class="bi bi-journal-bookmark"></i> View In My Courses
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/student/courses/${course.id}/enroll" class="btn btn-primary-custom w-100 justify-content-center py-2">
                                        <i class="bi bi-check-circle-fill"></i> Enroll Now
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

