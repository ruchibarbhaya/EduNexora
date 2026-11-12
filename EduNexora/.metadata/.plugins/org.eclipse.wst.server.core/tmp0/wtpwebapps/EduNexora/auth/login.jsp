<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="Sign In" />

        <%-- Handle direct URL parameters when accessing /auth/login.jsp directly --%>
            <c:if test="${empty errorMessage && not empty param.error}">
                <c:set var="errorMessage"
                    value="Invalid credentials or incorrect role selected. Please check and try again."
                    scope="request" />
            </c:if>
            <c:if test="${empty successMessage && not empty param.logout}">
                <c:set var="successMessage" value="You have been logged out successfully." scope="request" />
            </c:if>
            <c:if test="${empty successMessage && not empty param.registered}">
                <c:set var="successMessage" value="Registration successful! You can now log in with your credentials."
                    scope="request" />
            </c:if>

            <%@ include file="../layout/header.jsp" %>

                <div class="auth-wrapper">
                    <div class="auth-card">
                        <div class="auth-header">
                            <a href="${pageContext.request.contextPath}/" class="auth-logo mb-2">
                                <i class="bi bi-mortarboard-fill"></i>
                                <span>EduNexora</span>
                            </a>
                            <p class="text-white-50 small mb-0">Sign in to your Course Management Account</p>
                        </div>

                        <div class="auth-body">
                            <%@ include file="../layout/alerts.jsp" %>

                                <form action="${pageContext.request.contextPath}/login" method="post"
                                    class="protect-double-submit">
                                    <c:if test="${not empty _csrf}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    </c:if>

                                    <label class="form-label small fw-semibold text-muted text-uppercase mb-2">Select
                                        Your Role</label>
                                    <div class="role-selector">
                                        <div class="role-option">
                                            <input type="radio" id="roleStudent" name="role" value="STUDENT" checked>
                                            <label for="roleStudent"><i class="bi bi-backpack me-1"></i> Student</label>
                                        </div>
                                        <div class="role-option">
                                            <input type="radio" id="roleTeacher" name="role" value="TEACHER">
                                            <label for="roleTeacher"><i class="bi bi-person-workspace me-1"></i>
                                                Teacher</label>
                                        </div>
                                        <div class="role-option">
                                            <input type="radio" id="roleAdmin" name="role" value="ADMIN">
                                            <label for="roleAdmin"><i class="bi bi-shield-lock me-1"></i> Admin</label>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="username" class="form-label small fw-semibold">Email or
                                            Username</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-end-0 text-muted"><i
                                                    class="bi bi-person"></i></span>
                                            <input type="text" id="username" name="username"
                                                class="form-control border-start-0"
                                                placeholder="e.g. user@edunexora.com or admin" required autofocus
                                                autocomplete="username" />
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="password" class="form-label small fw-semibold">Password</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-end-0 text-muted"><i
                                                    class="bi bi-lock"></i></span>
                                            <input type="password" id="password" name="password"
                                                class="form-control border-start-0 border-end-0"
                                                placeholder="Enter your password" required
                                                autocomplete="current-password" />
                                            <button class="btn btn-outline-secondary toggle-password border-start-0"
                                                type="button" data-target="password"
                                                aria-label="Toggle password visibility">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="remember-me"
                                                name="remember-me">
                                            <label class="form-check-label small text-muted" for="remember-me">
                                                Remember me for 14 days
                                            </label>
                                        </div>
                                    </div>

                                    <button type="submit"
                                        class="btn btn-primary-custom w-100 justify-content-center py-2 mb-3">
                                        <span class="spinner-border spinner-border-sm me-2 d-none" role="status"
                                            aria-hidden="true"></span>
                                        <i class="bi bi-box-arrow-in-right"></i>
                                        <span>Sign In</span>
                                    </button>

                                    <div class="text-center pt-2 border-top">
                                        <p class="small text-muted mb-0">
                                            New student?
                                            <a href="${pageContext.request.contextPath}/auth/register.jsp"
                                                class="fw-semibold text-primary text-decoration-none">
                                                Create a Student Account
                                            </a>
                                        </p>
                                    </div>
                                </form>
                        </div>
                    </div>
                </div>

                <%@ include file="../layout/footer.jsp" %>