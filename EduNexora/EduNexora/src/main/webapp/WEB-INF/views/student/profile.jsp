<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Profile Settings" />
<c:set var="activeMenu" value="profile" />
<%@ include file="../layout/header.jsp" %>

<div class="dashboard-layout">
    <%@ include file="../layout/sidebar.jsp" %>
    <div class="main-wrapper">
        <%@ include file="../layout/topbar.jsp" %>
        <main class="content-body">
            <%@ include file="../layout/alerts.jsp" %>

            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Profile & Account Settings</h3>
                    <p class="text-muted small mb-0">Update your contact details and security credentials.</p>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <div class="content-card">
                        <div class="content-card-body p-4">
                            <form action="${pageContext.request.contextPath}/student/profile" method="post" class="protect-double-submit">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <div class="mb-3">
                                    <label for="name" class="form-label small fw-semibold">Full Name <span class="text-danger">*</span></label>
                                    <input type="text" id="name" name="name" value="<c:out value="${student.name}"/>" class="form-control" required />
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label small fw-semibold">Email Address</label>
                                        <input type="email" id="email" value="<c:out value="${student.email}"/>" class="form-control bg-light" readonly disabled />
                                        <small class="text-muted">Email address cannot be modified.</small>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="phone" class="form-label small fw-semibold">Phone Number</label>
                                        <input type="text" id="phone" name="phone" value="<c:out value="${student.phone}"/>" class="form-control" placeholder="e.g. 9876543210" />
                                    </div>
                                </div>

                                <hr class="my-4" />
                                <h5 class="fw-bold text-dark mb-3"><i class="bi bi-shield-lock text-primary"></i> Change Password</h5>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="newPassword" class="form-label small fw-semibold">New Password</label>
                                        <div class="input-group">
                                            <input type="password" id="newPassword" name="newPassword" class="form-control border-end-0" placeholder="Leave blank to keep current" />
                                            <button class="btn btn-outline-secondary toggle-password border-start-0" type="button" data-target="newPassword" aria-label="Toggle password visibility">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="confirmPassword" class="form-label small fw-semibold">Confirm New Password</label>
                                        <div class="input-group">
                                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control border-end-0" placeholder="Repeat new password" />
                                            <button class="btn btn-outline-secondary toggle-password border-start-0" type="button" data-target="confirmPassword" aria-label="Toggle password visibility">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-3">
                                    <button type="submit" class="btn btn-primary-custom">
                                        <span class="spinner-border spinner-border-sm me-2 d-none" role="status" aria-hidden="true"></span>
                                        <i class="bi bi-check-circle-fill"></i>
                                        <span>Save Profile Changes</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <%@ include file="../layout/footer.jsp" %>
    </div>
</div>

