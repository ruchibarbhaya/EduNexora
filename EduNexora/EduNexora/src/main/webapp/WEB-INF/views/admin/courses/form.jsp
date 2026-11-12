<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="isEdit" value="${courseForm.id != null}" />
<c:set var="pageTitle" value="${isEdit ? 'Edit Course' : 'Create New Course'}" />
<c:set var="activeMenu" value="courses" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1"><c:out value="${pageTitle}"/></h3>
                    <p class="text-muted small mb-0"><c:out value="${isEdit ? 'Update course specifications and assigned teacher.' : 'Add a new curriculum course to the catalog.'}"/></p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Courses
                </a>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <div class="content-card">
                        <div class="content-card-body p-4">
                            <form:form modelAttribute="courseForm" 
                                       action="${isEdit ? pageContext.request.contextPath.concat('/admin/courses/').concat(courseForm.id).concat('/edit') : pageContext.request.contextPath.concat('/admin/courses/new')}" 
                                       method="post" cssClass="protect-double-submit">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <form:hidden path="id" />

                                <div class="row">
                                    <div class="col-md-8 mb-3">
                                        <label for="courseName" class="form-label small fw-semibold">Course Title <span class="text-danger">*</span></label>
                                        <form:input path="courseName" id="courseName" cssClass="form-control" placeholder="e.g. Full Stack Java & Spring Boot" required="required" />
                                        <form:errors path="courseName" cssClass="text-danger small mt-1 d-block" />
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="courseCode" class="form-label small fw-semibold">Course Code <span class="text-danger">*</span></label>
                                        <form:input path="courseCode" id="courseCode" cssClass="form-control text-uppercase" placeholder="e.g. CS101" required="required" />
                                        <form:errors path="courseCode" cssClass="text-danger small mt-1 d-block" />
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label small fw-semibold">Course Description</label>
                                    <form:textarea path="description" id="description" cssClass="form-control" rows="4" placeholder="Provide syllabus summary and learning objectives..." />
                                    <form:errors path="description" cssClass="text-danger small mt-1 d-block" />
                                </div>

                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label for="duration" class="form-label small fw-semibold">Duration <span class="text-danger">*</span></label>
                                        <form:input path="duration" id="duration" cssClass="form-control" placeholder="e.g. 12 Weeks" required="required" />
                                        <form:errors path="duration" cssClass="text-danger small mt-1 d-block" />
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="fees" class="form-label small fw-semibold">Tuition Fee ($) <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text">$</span>
                                            <form:input path="fees" id="fees" type="number" step="0.01" min="0" cssClass="form-control" placeholder="499.00" required="required" />
                                        </div>
                                        <form:errors path="fees" cssClass="text-danger small mt-1 d-block" />
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="teacherId" class="form-label small fw-semibold">Assigned Teacher</label>
                                        <form:select path="teacherId" id="teacherId" cssClass="form-select">
                                            <form:option value="" label="-- Assign Instructor --" />
                                            <c:forEach var="t" items="${teachers}">
                                                <form:option value="${t.id}" label="${t.name} (${t.department})" />
                                            </c:forEach>
                                        </form:select>
                                        <form:errors path="teacherId" cssClass="text-danger small mt-1 d-block" />
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end gap-2 border-top pt-3">
                                    <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-light border">Cancel</a>
                                    <button type="submit" class="btn btn-primary-custom">
                                        <span class="spinner-border spinner-border-sm me-2 d-none" role="status" aria-hidden="true"></span>
                                        <i class="bi bi-check-circle-fill"></i>
                                        <span><c:out value="${isEdit ? 'Save Changes' : 'Create Course'}"/></span>
                                    </button>
                                </div>
                            </form:form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

