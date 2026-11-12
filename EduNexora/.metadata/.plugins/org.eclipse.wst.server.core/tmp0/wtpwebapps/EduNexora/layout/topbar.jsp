<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="topbar">
    <div class="d-flex align-items-center gap-3">
        <button type="button" class="btn btn-light d-lg-none border" id="sidebarToggle" aria-label="Toggle Navigation">
            <i class="bi bi-list fs-5"></i>
        </button>
        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 rounded-pill fw-medium">
            <sec:authorize access="hasRole('ADMIN')"><i class="bi bi-shield-lock me-1"></i> Admin Console</sec:authorize>
            <sec:authorize access="hasRole('TEACHER')"><i class="bi bi-mortarboard me-1"></i> Instructor Portal</sec:authorize>
            <sec:authorize access="hasRole('STUDENT')"><i class="bi bi-backpack me-1"></i> Student Portal</sec:authorize>
        </span>
    </div>

    <div class="d-flex align-items-center gap-3">
        <div class="d-flex align-items-center gap-2">
            <div class="rounded-circle bg-light border d-flex align-items-center justify-content-center text-primary fw-bold" style="width: 40px; height: 40px;">
                <i class="bi bi-person-fill"></i>
            </div>
            <div class="d-none d-sm-block text-start">
                <div class="fw-semibold text-dark small">
                    <sec:authentication property="principal.displayName" var="userDisplayName" />
                    <c:out value="${userDisplayName != null ? userDisplayName : 'User'}" />
                </div>
                <div class="text-muted" style="font-size: 0.75rem;">
                    <sec:authorize access="hasRole('ADMIN')">Administrator</sec:authorize>
                    <sec:authorize access="hasRole('TEACHER')">Faculty</sec:authorize>
                    <sec:authorize access="hasRole('STUDENT')">Student</sec:authorize>
                </div>
            </div>
        </div>
    </div>
</header>

