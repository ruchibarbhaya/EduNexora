<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="pageTitle" value="Student Registration" />

<%-- Automatically instantiate DTO bean if accessing /auth/register.jsp directly without controller --%>
<c:if test="${empty registrationDto}">
    <jsp:useBean id="registrationDto" class="com.cms.dto.StudentRegistrationDto" scope="request" />
</c:if>

<%@ include file="../layout/header.jsp" %>

<div class="auth-wrapper">
    <div class="auth-card" style="max-width: 520px;">
        <div class="auth-header">
            <a href="${pageContext.request.contextPath}/" class="auth-logo mb-2">
                <i class="bi bi-mortarboard-fill"></i>
                <span>EduNexora</span>
            </a>
            <p class="text-white-50 small mb-0">Create your new Student Account</p>
        </div>

        <div class="auth-body">
            <%@ include file="../layout/alerts.jsp" %>

            <form:form modelAttribute="registrationDto" action="${pageContext.request.contextPath}/register" method="post" cssClass="protect-double-submit">
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>

                <div class="mb-3">
                    <label for="fullName" class="form-label small fw-semibold">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-person"></i></span>
                        <form:input path="fullName" id="fullName" cssClass="form-control border-start-0" placeholder="e.g. Alice Smith" required="required" />
                    </div>
                    <form:errors path="fullName" cssClass="text-danger small mt-1 d-block" />
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label small fw-semibold">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-envelope"></i></span>
                        <form:input path="email" id="email" type="email" cssClass="form-control border-start-0" placeholder="e.g. alice@example.com" required="required" />
                    </div>
                    <form:errors path="email" cssClass="text-danger small mt-1 d-block" />
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label small fw-semibold">Phone Number</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-telephone"></i></span>
                        <form:input path="phone" id="phone" cssClass="form-control border-start-0" placeholder="e.g. 9876543210" required="required" />
                    </div>
                    <form:errors path="phone" cssClass="text-danger small mt-1 d-block" />
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="password" class="form-label small fw-semibold">Password</label>
                        <div class="input-group">
                            <form:password path="password" id="regPassword" cssClass="form-control border-end-0" placeholder="Min. 6 characters" required="required" />
                            <button class="btn btn-outline-secondary toggle-password border-start-0" type="button" data-target="regPassword" aria-label="Toggle password visibility">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <form:errors path="password" cssClass="text-danger small mt-1 d-block" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="confirmPassword" class="form-label small fw-semibold">Confirm Password</label>
                        <div class="input-group">
                            <form:password path="confirmPassword" id="regConfirmPassword" cssClass="form-control border-end-0" placeholder="Repeat password" required="required" />
                            <button class="btn btn-outline-secondary toggle-password border-start-0" type="button" data-target="regConfirmPassword" aria-label="Toggle password visibility">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <form:errors path="confirmPassword" cssClass="text-danger small mt-1 d-block" />
                    </div>
                </div>

                <button type="submit" class="btn btn-primary-custom w-100 justify-content-center py-2 mb-3 mt-2">
                    <span class="spinner-border spinner-border-sm me-2 d-none" role="status" aria-hidden="true"></span>
                    <i class="bi bi-person-plus-fill"></i>
                    <span>Complete Registration</span>
                </button>

                <div class="text-center pt-2 border-top">
                    <p class="small text-muted mb-0">
                        Already have an account? 
                        <a href="${pageContext.request.contextPath}/auth/login.jsp" class="fw-semibold text-primary text-decoration-none">
                            Sign In Here
                        </a>
                    </p>
                </div>
            </form:form>
        </div>
    </div>
</div>

<%@ include file="../layout/footer.jsp" %>

