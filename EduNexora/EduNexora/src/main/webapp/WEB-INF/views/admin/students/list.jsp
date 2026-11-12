<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Students Directory" />
<c:set var="activeMenu" value="students" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Students Directory</h3>
                    <p class="text-muted small mb-0">Browse registered students and view their academic course enrollments.</p>
                </div>
            </div>

            <!-- Search Card -->
            <div class="content-card mb-4">
                <div class="content-card-body p-3">
                    <form action="${pageContext.request.contextPath}/admin/students" method="get" class="row g-2 align-items-center">
                        <div class="col-md-10">
                            <div class="input-group">
                                <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                                <input type="text" name="search" value="<c:out value="${search}"/>" class="form-control border-start-0" 
                                       placeholder="Search students by name or email address..." />
                            </div>
                        </div>
                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-filter"></i> Search</button>
                            <c:if test="${not empty search}">
                                <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline-secondary" title="Clear Filter">
                                    <i class="bi bi-x-circle"></i>
                                </a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Students Table -->
            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Student Name</th>
                                <th>Email Address</th>
                                <th>Phone Number</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="student" items="${studentPage.content}">
                                <tr>
                                    <td><span class="badge bg-light text-secondary border">#<c:out value="${student.id}"/></span></td>
                                    <td class="fw-semibold text-dark"><c:out value="${student.name}"/></td>
                                    <td><c:out value="${student.email}"/></td>
                                    <td><c:out value="${student.phone != null ? student.phone : '-'}"/></td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/admin/students/${student.id}" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-eye"></i> View Enrollments
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty studentPage.content}">
                    <div class="empty-state">
                        <i class="bi bi-people empty-state-icon"></i>
                        <h5 class="empty-state-title">No Students Found</h5>
                        <p class="empty-state-text">No registered students matched your search criteria.</p>
                    </div>
                </c:if>

                <!-- Pagination -->
                <c:if test="${studentPage.totalPages > 1}">
                    <div class="d-flex justify-content-between align-items-center p-3 border-top">
                        <small class="text-muted">
                            Showing page <c:out value="${studentPage.number + 1}"/> of <c:out value="${studentPage.totalPages}"/> (<c:out value="${studentPage.totalElements}"/> students)
                        </small>
                        <ul class="pagination pagination-sm m-0">
                            <li class="page-item ${studentPage.first ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${studentPage.number - 1}&search=<c:out value='${search}'/>">Previous</a>
                            </li>
                            <c:forEach begin="0" end="${studentPage.totalPages - 1}" var="p">
                                <li class="page-item ${p == studentPage.number ? 'active' : ''}">
                                    <a class="page-link" href="?page=${p}&search=<c:out value='${search}'/>">${p + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${studentPage.last ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${studentPage.number + 1}&search=<c:out value='${search}'/>">Next</a>
                            </li>
                        </ul>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

