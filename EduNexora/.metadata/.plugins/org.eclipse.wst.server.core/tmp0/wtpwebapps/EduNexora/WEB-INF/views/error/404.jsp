<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Page Not Found" />
<%@ include file="../layout/header.jsp" %>

<div class="auth-wrapper">
    <div class="auth-card text-center p-4">
        <div class="mb-3">
            <span class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center" style="width: 80px; height: 80px; font-size: 2.5rem;">
                <i class="bi bi-compass"></i>
            </span>
        </div>
        <h2 class="fw-bold text-dark mb-2">404 - Page Not Found</h2>
        <p class="text-muted mb-4">
            <c:out value="${errorMessage != null ? errorMessage : 'The page or resource you are looking for does not exist or has been moved.'}"/>
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary-custom">
                <i class="bi bi-house-door-fill"></i> Return Home
            </a>
            <a href="javascript:history.back()" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Go Back
            </a>
        </div>
    </div>
</div>

<%@ include file="../layout/footer.jsp" %>

