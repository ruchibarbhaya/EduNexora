<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="isEdit" value="${teacherForm.id != null}" />
<c:set var="pageTitle" value="${isEdit ? 'Edit Teacher' : 'Add New Teacher'}" />
<c:set var="activeMenu" value="teachers" />
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
                    <p class="text-muted small mb-0"><c:out value="${isEdit ? 'Update instructor details and credentials.' : 'Register a new faculty instructor.'}"/></p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Teachers
                </a>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <div class="content-card">
                        <div class="content-card-body p-4">
                            <form:form modelAttribute="teacherForm" 
                                       action="${isEdit ? pageContext.request.contextPath.concat('/admin/teachers/').concat(teacherForm.id).concat('/edit') : pageContext.request.contextPath.concat('/admin/teachers/new')}" 
                                       method="post" cssClass="protect-double-submit">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <form:hidden path="id" />

                                <div class="mb-3">
                                    <label for="name" class="form-label small fw-semibold">Full Name <span class="text-danger">*</span></label>
                                    <form:input path="name" id="name" cssClass="form-control" placeholder="e.g. Dr. Jane Smith" required="required" />
                                    <form:errors path="name" cssClass="text-danger small mt-1 d-block" />
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label small fw-semibold">Email Address <span class="text-danger">*</span></label>
                                        <form:input path="email" id="email" type="email" cssClass="form-control" placeholder="e.g. jsmith@edunexora.com" required="required" />
                                        <form:errors path="email" cssClass="text-danger small mt-1 d-block" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="phone" class="form-label small fw-semibold">Phone Number <span class="text-danger">*</span></label>
                                        <form:input path="phone" id="phone" cssClass="form-control" placeholder="e.g. 9876543210" required="required" />
                                        <form:errors path="phone" cssClass="text-danger small mt-1 d-block" />
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="department" class="form-label small fw-semibold">Department <span class="text-danger">*</span></label>
                                    <form:input path="department" id="department" cssClass="form-control" placeholder="e.g. Computer Science" required="required" />
                                    <form:errors path="department" cssClass="text-danger small mt-1 d-block" />
                                </div>

                                <div class="mb-4">
                                    <label for="password" class="form-label small fw-semibold">
                                        Password 
                                        <c:if test="${isEdit}"><span class="text-muted fw-normal">(Leave blank to keep existing password)</span></c:if>
                                        <c:if test="${not isEdit}"><span class="text-muted fw-normal">(Defaults to 'Password@123' if blank)</span></c:if>
                                    </label>
                                    <div class="input-group">
                                        <form:password path="password" id="teacherPassword" cssClass="form-control border-end-0" placeholder="${isEdit ? '••••••••' : 'Enter initial password'}" />
                                        <button class="btn btn-outline-secondary toggle-password border-start-0" type="button" data-target="teacherPassword" aria-label="Toggle password visibility">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                    <form:errors path="password" cssClass="text-danger small mt-1 d-block" />
                                </div>

                                <div class="d-flex justify-content-end gap-2 border-top pt-3">
                                    <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-light border">Cancel</a>
                                    <button type="submit" class="btn btn-primary-custom">
                                        <span class="spinner-border spinner-border-sm me-2 d-none" role="status" aria-hidden="true"></span>
                                        <i class="bi bi-check-circle-fill"></i>
                                        <span><c:out value="${isEdit ? 'Save Changes' : 'Create Teacher'}"/></span>
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

