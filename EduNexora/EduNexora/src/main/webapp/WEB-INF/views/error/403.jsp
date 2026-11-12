<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Access Denied" />
<%@ include file="../layout/header.jsp" %>

<div class="auth-wrapper">
    <div class="auth-card text-center p-4">
        <div class="mb-3">
            <span class="rounded-circle bg-danger-subtle text-danger d-inline-flex align-items-center justify-content-center" style="width: 80px; height: 80px; font-size: 2.5rem;">
                <i class="bi bi-shield-x"></i>
            </span>
        </div>
        <h2 class="fw-bold text-dark mb-2">403 - Access Denied</h2>
        <p class="text-muted mb-4">
            You do not have the required permissions or role to access this protected resource.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary-custom">
                <i class="bi bi-house-door-fill"></i> Return to Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/auth/login.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-box-arrow-in-right"></i> Sign In with Different Account
            </a>
        </div>
    </div>
</div>

<%@ include file="../layout/footer.jsp" %>

