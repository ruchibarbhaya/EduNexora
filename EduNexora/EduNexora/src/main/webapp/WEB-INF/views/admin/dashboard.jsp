<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Dashboard" />
<c:set var="activeMenu" value="dashboard" />
<%@ include file="../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Administrator Overview</h3>
                    <p class="text-muted small mb-0">System performance, enrollment statistics, and course management metrics.</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/admin/courses/new" class="btn btn-primary-custom btn-sm">
                        <i class="bi bi-plus-circle-fill"></i> New Course
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/teachers/new" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-person-plus-fill"></i> Add Teacher
                    </a>
                </div>
            </div>

            <!-- Stats Overview Cards -->
            <div class="row g-4 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-info">
                            <div class="stat-title">Total Students</div>
                            <div class="stat-value"><c:out value="${totalStudents != null ? totalStudents : 0}" /></div>
                        </div>
                        <div class="stat-icon blue"><i class="bi bi-people-fill"></i></div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-info">
                            <div class="stat-title">Faculty / Teachers</div>
                            <div class="stat-value"><c:out value="${totalTeachers != null ? totalTeachers : 0}" /></div>
                        </div>
                        <div class="stat-icon purple"><i class="bi bi-person-workspace"></i></div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-info">
                            <div class="stat-title">Active Courses</div>
                            <div class="stat-value"><c:out value="${totalCourses != null ? totalCourses : 0}" /></div>
                        </div>
                        <div class="stat-icon green"><i class="bi bi-book-half"></i></div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-info">
                            <div class="stat-title">Total Enrollments</div>
                            <div class="stat-value"><c:out value="${totalEnrollments != null ? totalEnrollments : 0}" /></div>
                        </div>
                        <div class="stat-icon amber"><i class="bi bi-journal-check"></i></div>
                    </div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="row g-4 mb-4">
                <div class="col-lg-7">
                    <div class="content-card h-100">
                        <div class="content-card-header">
                            <h5 class="content-card-title"><i class="bi bi-bar-chart-fill text-primary"></i> Course Popularity (Active Enrollments)</h5>
                        </div>
                        <div class="content-card-body">
                            <canvas id="coursePopularityChart" style="max-height: 300px;"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="content-card h-100">
                        <div class="content-card-header">
                            <h5 class="content-card-title"><i class="bi bi-graph-up-arrow text-secondary"></i> Daily Enrollment Trend</h5>
                        </div>
                        <div class="content-card-body">
                            <canvas id="enrollmentTrendChart" style="max-height: 300px;"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <%@ include file="../layout/footer.jsp" %>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    // 1. Course Popularity Bar Chart
    const courseLabels = ${chartCourseLabels};
    const courseData = ${chartCourseData};
    const ctxBar = document.getElementById('coursePopularityChart');
    if (ctxBar && courseLabels.length > 0) {
        new Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: courseLabels,
                datasets: [{
                    label: 'Enrolled Students',
                    data: courseData,
                    backgroundColor: 'rgba(37, 99, 235, 0.85)',
                    borderColor: 'rgb(37, 99, 235)',
                    borderWidth: 1,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 1 } }
                }
            }
        });
    }

    // 2. Enrollment Trend Line Chart
    const trendLabels = ${chartTrendLabels};
    const trendData = ${chartTrendData};
    const ctxLine = document.getElementById('enrollmentTrendChart');
    if (ctxLine && trendLabels.length > 0) {
        new Chart(ctxLine, {
            type: 'line',
            data: {
                labels: trendLabels,
                datasets: [{
                    label: 'Registrations',
                    data: trendData,
                    borderColor: 'rgb(124, 58, 237)',
                    backgroundColor: 'rgba(124, 58, 237, 0.1)',
                    fill: true,
                    tension: 0.35,
                    borderWidth: 2,
                    pointRadius: 4,
                    pointBackgroundColor: 'rgb(124, 58, 237)'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 1 } }
                }
            }
        });
    }
});
</script>
