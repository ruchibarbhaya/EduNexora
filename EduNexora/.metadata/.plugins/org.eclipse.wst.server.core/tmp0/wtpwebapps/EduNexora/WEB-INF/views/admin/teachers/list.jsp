<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty & Teachers" />
<c:set var="activeMenu" value="teachers" />
<%@ include file="../../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-3">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Faculty & Teachers</h3>
                    <p class="text-muted small mb-0">Manage instructors, departments, and course assignments.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/teachers/new" class="btn btn-primary-custom">
                    <i class="bi bi-person-plus-fill"></i> Add New Teacher
                </a>
            </div>

            <!-- Filter / Search Card -->
            <div class="content-card mb-4">
                <div class="content-card-body p-3">
                    <form action="${pageContext.request.contextPath}/admin/teachers" method="get" class="row g-2 align-items-center">
                        <div class="col-md-9 col-lg-10">
                            <div class="input-group">
                                <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                                <input type="text" name="search" value="<c:out value="${search}"/>" class="form-control border-start-0" 
                                       placeholder="Search by instructor name, email or department..." />
                            </div>
                        </div>
                        <div class="col-md-3 col-lg-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-filter"></i> Search</button>
                            <c:if test="${not empty search}">
                                <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-outline-secondary" title="Clear Filter">
                                    <i class="bi bi-x-circle"></i>
                                </a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Teachers Table -->
            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Name</th>
                                <th>Email Address</th>
                                <th>Phone</th>
                                <th>Department</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="teacher" items="${teacherPage.content}">
                                <tr>
                                    <td><span class="badge bg-light text-secondary border">#<c:out value="${teacher.id}"/></span></td>
                                    <td class="fw-semibold text-dark"><c:out value="${teacher.name}"/></td>
                                    <td><c:out value="${teacher.email}"/></td>
                                    <td><c:out value="${teacher.phone != null ? teacher.phone : '-'}"/></td>
                                    <td><span class="badge bg-purple-subtle text-dark border"><c:out value="${teacher.department}"/></span></td>
                                    <td class="text-end">
                                        <div class="d-inline-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/teachers/${teacher.id}/edit" class="btn btn-outline-primary btn-sm" title="Edit Teacher">
                                                <i class="bi bi-pencil-square"></i> Edit
                                            </a>
                                            <form action="${pageContext.request.contextPath}/admin/teachers/${teacher.id}/delete" method="post" class="d-inline">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <button type="submit" class="btn btn-outline-danger btn-sm" data-bs-confirm="Are you sure you want to delete instructor '<c:out value="${teacher.name}"/>'? This action cannot be undone.">
                                                    <i class="bi bi-trash"></i> Delete
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty teacherPage.content}">
                    <div class="empty-state">
                        <i class="bi bi-person-x empty-state-icon"></i>
                        <h5 class="empty-state-title">No Teachers Found</h5>
                        <p class="empty-state-text">No instructors matched your search criteria. Try modifying your filter or create a new instructor.</p>
                        <a href="${pageContext.request.contextPath}/admin/teachers/new" class="btn btn-primary-custom btn-sm">
                            <i class="bi bi-person-plus-fill"></i> Add First Teacher
                        </a>
                    </div>
                </c:if>

                <!-- Pagination -->
                <c:if test="${teacherPage.totalPages > 1}">
                    <div class="d-flex justify-content-between align-items-center p-3 border-top">
                        <small class="text-muted">
                            Showing page <c:out value="${teacherPage.number + 1}"/> of <c:out value="${teacherPage.totalPages}"/> (<c:out value="${teacherPage.totalElements}"/> instructors)
                        </small>
                        <ul class="pagination pagination-sm m-0">
                            <li class="page-item ${teacherPage.first ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${teacherPage.number - 1}&search=<c:out value='${search}'/>">Previous</a>
                            </li>
                            <c:forEach begin="0" end="${teacherPage.totalPages - 1}" var="p">
                                <li class="page-item ${p == teacherPage.number ? 'active' : ''}">
                                    <a class="page-link" href="?page=${p}&search=<c:out value='${search}'/>">${p + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${teacherPage.last ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${teacherPage.number + 1}&search=<c:out value='${search}'/>">Next</a>
                            </li>
                        </ul>
                    </div>
                </c:if>
            </div>
        </main>
        <%@ include file="../../layout/footer.jsp" %>
    </div>
</div>

