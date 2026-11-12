<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="sidebar-overlay"></div>
<aside class="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/" class="brand-logo">
            <span class="logo-icon"><i class="bi bi-mortarboard-fill"></i></span>
            <span>EduNexora</span>
        </a>
    </div>

    <div class="sidebar-nav">
        <!-- ADMIN NAVIGATION -->
        <sec:authorize access="hasRole('ADMIN')">
            <div class="nav-category">Main Menu</div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link-custom ${activeMenu == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
            <div class="nav-category">Academic Management</div>
            <a href="${pageContext.request.contextPath}/admin/teachers" class="nav-link-custom ${activeMenu == 'teachers' ? 'active' : ''}">
                <i class="bi bi-person-workspace"></i>
                <span>Teachers</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/courses" class="nav-link-custom ${activeMenu == 'courses' ? 'active' : ''}">
                <i class="bi bi-book-half"></i>
                <span>Courses</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/students" class="nav-link-custom ${activeMenu == 'students' ? 'active' : ''}">
                <i class="bi bi-people-fill"></i>
                <span>Students</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/enrollments" class="nav-link-custom ${activeMenu == 'enrollments' ? 'active' : ''}">
                <i class="bi bi-journal-check"></i>
                <span>Enrollments</span>
            </a>
        </sec:authorize>

        <!-- TEACHER NAVIGATION -->
        <sec:authorize access="hasRole('TEACHER')">
            <div class="nav-category">Faculty Portal</div>
            <a href="${pageContext.request.contextPath}/teacher/dashboard" class="nav-link-custom ${activeMenu == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/teacher/courses" class="nav-link-custom ${activeMenu == 'courses' ? 'active' : ''}">
                <i class="bi bi-collection-play-fill"></i>
                <span>My Courses</span>
            </a>
            <a href="${pageContext.request.contextPath}/teacher/students" class="nav-link-custom ${activeMenu == 'students' ? 'active' : ''}">
                <i class="bi bi-person-lines-fill"></i>
                <span>Registered Students</span>
            </a>
        </sec:authorize>

        <!-- STUDENT NAVIGATION -->
        <sec:authorize access="hasRole('STUDENT')">
            <div class="nav-category">Student Portal</div>
            <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link-custom ${activeMenu == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/courses" class="nav-link-custom ${activeMenu == 'browse-courses' ? 'active' : ''}">
                <i class="bi bi-compass-fill"></i>
                <span>Browse Courses</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/my-courses" class="nav-link-custom ${activeMenu == 'my-courses' ? 'active' : ''}">
                <i class="bi bi-bookmark-check-fill"></i>
                <span>My Enrollments</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/profile" class="nav-link-custom ${activeMenu == 'profile' ? 'active' : ''}">
                <i class="bi bi-person-circle"></i>
                <span>Profile Settings</span>
            </a>
        </sec:authorize>
    </div>

    <div class="sidebar-footer">
        <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit" class="btn btn-outline-danger w-100 btn-sm d-flex align-items-center justify-content-center gap-2 py-2">
                <i class="bi bi-box-arrow-right"></i>
                <span>Sign Out</span>
            </button>
        </form>
    </div>
</aside>

