<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Aurelian Hotel · Profile</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/profile.css">
        <%@ include file="fragments/head-assets.jsp" %>
</head>

        <body>

            <jsp:include page="/WEB-INF/jsp/fragments/navbar.jsp" />

            <div class="wrap">

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="ph ph-check-circle"></i> ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="ph ph-warning-circle"></i> ${error}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <div class="card">
                        <h2 style="margin:0 0 10px;">You’re not signed in</h2>
                        <p style="margin:0 0 16px; color:var(--au-muted);">Please sign in to view your profile.</p>
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/login"><i class="ph ph-user"></i> Sign In</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div class="profile-header">
                            <div class="profile-avatar ${sessionScope.user.avatarColorClass}">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.profilePicture}">
                                        <img src="${pageContext.request.contextPath}/${sessionScope.user.profilePicture}" alt="Profile Picture">
                                    </c:when>
                                    <c:otherwise>
                                        ${sessionScope.user.avatarInitials}
                                    </c:otherwise>
                                </c:choose>
                                
                                <c:if test="${sessionScope.user.role == 'EMPLOYEE'}">
                                    <div class="avatar-upload-overlay" onclick="document.getElementById('profilePicInput').click()">
                                        <i class="ph ph-camera"></i>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div style="display: none;">
                                <form id="profilePicForm" action="${pageContext.request.contextPath}/profile/picture" method="post" enctype="multipart/form-data">
                                    <input type="file" id="profilePicInput" name="picture" onchange="document.getElementById('profilePicForm').submit()" accept="image/*">
                                </form>
                            </div>

                            <div class="profile-info">
                                <span class="pill" style="margin-bottom: 12px;"><i class="ph ph-shield-check"></i> ${sessionScope.user.role}</span>
                                <h1 class="name" style="font-size: 32px; margin-bottom: 8px;">Welcome, ${sessionScope.user.firstName}!</h1>
                                <c:if test="${sessionScope.user.role == 'EMPLOYEE'}">
                                    <span class="job-role-text" style="font-size: 16px; margin-bottom: 8px; display: block;">${sessionScope.user.jobRole}</span>
                                </c:if>
                                <p class="meta" style="font-size: 16px;">
                                    <span><i class="ph ph-at"></i> ${sessionScope.user.username}</span>
                                    <span><i class="ph ph-envelope-simple"></i> ${sessionScope.user.email}</span>
                                </p>
                                
                                <div style="margin-top: 24px; display: flex; gap: 12px; align-items: center;">
                                    <a href="${pageContext.request.contextPath}/logout" class="actions" style="padding: 10px 20px; font-size: 14px; border-radius: 4px; background: var(--au-surface); color: #e55353; border: 1px solid var(--au-line); font-weight: 600;">
                                        <i class="ph ph-power"></i> Logout
                                    </a>
                                    <c:if test="${sessionScope.user.role == 'EMPLOYEE' and not empty sessionScope.user.profilePicture}">
                                        <form action="${pageContext.request.contextPath}/profile/picture/remove" method="post" style="margin: 0;">
                                            <button type="submit" style="background: rgba(229, 83, 83, 0.08); border: none; color: #e55353; font-size: 13px; font-weight: 600; cursor: pointer; padding: 8px 16px; border-radius: 3px; transition: all 0.3s;">
                                                <i class="ph ph-trash"></i> Remove Picture
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <form id="updateForm" action="${pageContext.request.contextPath}/profile/update" method="post"
                            style="margin-top:20px;" autocomplete="off" onsubmit="return validateForm()">
                            <div class="grid">
                                <div class="field">
                                    <label class="k" for="firstName">First Name</label>
                                    <input type="text" id="firstName" name="firstName" class="form-control"
                                        value="${sessionScope.user.firstName}" required>
                                </div>
                                <div class="field">
                                    <label class="k" for="lastName">Last Name</label>
                                    <input type="text" id="lastName" name="lastName" class="form-control"
                                        value="${sessionScope.user.lastName}" required>
                                </div>
                                <div class="field">
                                    <div class="k">Email Address</div>
                                    <div class="v">${sessionScope.user.email} <span style="font-size:10px; color:var(--au-muted); margin-left:8px;">(Contact admin to change)</span></div>
                                </div>

                                <!-- Editable fields -->
                                <div class="field">
                                    <label class="k" for="phoneNumber">Phone Number</label>
                                    <input type="text" id="phoneNumber" name="phoneNumber" class="form-control"
                                        value="${sessionScope.user.phoneNumber}" required>
                                </div>
                                <div class="field">
                                    <label class="k" for="username">Username</label>
                                    <input type="text" id="username" name="username" class="form-control"
                                        value="${sessionScope.user.username}" required>
                                </div>
                            </div>

                            <h3 class="section-title">Change Password <span
                                    style="font-size:12px; color:#2bb3e6; font-weight:normal;">(Leave blank to keep
                                    current)</span></h3>
                            <div class="grid">
                                <div class="field">
                                    <label class="k" for="currentPassword">Current Password <span
                                            style="color:#e55353;">*</span></label>
                                    <input type="password" id="currentPassword" name="currentPassword"
                                        class="form-control" placeholder="Required to save changes" autocomplete="new-password">
                                </div>
                                <div class="field">
                                    <label class="k" for="newPassword">New Password</label>
                                    <input type="password" id="newPassword" name="newPassword" class="form-control"
                                        placeholder="Enter new password" autocomplete="new-password">
                                </div>
                                <div class="field">
                                    <label class="k" for="confirmNewPassword">Confirm New Password</label>
                                    <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-control"
                                        placeholder="Confirm your new password" autocomplete="new-password">
                                </div>
                            </div>

                            <div style="margin-top: 24px; text-align: right;">
                                <button type="submit" class="actions btn-update"
                                    style="padding: 12px 24px; border-radius: 4px; font-weight: 700;">
                                    <i class="ph ph-floppy-disk"></i> Save Changes
                                </button>
                            </div>
                        </form>

                        <h3 class="section-title" style="color:#e55353;">Danger Zone</h3>
                        <div
                            style="background: #fff5f5; border: 1px solid #ffe6e6; padding: 28px; border-radius: 6px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
                            <div style="flex: 1; min-width: 250px;">
                                <h4 style="margin: 0 0 8px; color:#c53030; font-weight: 700; font-size: 16px;">Delete Account</h4>
                                <p style="margin: 0; font-size: 14px; color: var(--au-muted); line-height: 1.6;">Once you delete your account,
                                    there is no going back. All your personal data and reservations will be permanently removed.</p>
                            </div>
                            <form action="${pageContext.request.contextPath}/profile/delete" method="post"
                                onsubmit="return confirmDelete();">
                                <button type="submit" class="actions btn-danger-solid"
                                    style="padding: 12px 24px; border-radius: 4px; font-weight: 700; background: #e55353; box-shadow: 0 8px 16px rgba(229, 83, 83, 0.2);">
                                    <i class="ph ph-user-minus"></i> Delete Account
                                </button>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
            </div>

            <script>
                function validateForm() {
                    const currentPassField = document.getElementById('currentPassword');
                    const newPassField = document.getElementById('newPassword');
                    const confirmPassField = document.getElementById('confirmNewPassword');

                    const currentPass = currentPassField.value.trim();
                    const newPass = newPassField.value.trim();
                    const confirmPass = confirmPassField.value.trim();

                    // If user is trying to change password
                    if (newPass !== "" || confirmPass !== "") {
                        if (currentPass === "") {
                            alert("Current password is required to change to a new password.");
                            currentPassField.focus();
                            return false;
                        }
                        if (newPass !== confirmPass) {
                            alert("The new passwords do not match. Please confirm your new password again.");
                            confirmPassField.focus();
                            return false;
                        }
                        if (newPass === currentPass) {
                            alert("Please enter a DIFFERENT new password. It cannot be the same as your current one.");
                            newPassField.focus();
                            return false;
                        }
                        if (newPass.length < 6) {
                            alert("For your security, new password must be at least 6 characters long.");
                            newPassField.focus();
                            return false;
                        }
                    }
                    return true;
                }

                function confirmDelete() {
                    return confirm("WARNING: Are you absolutely sure you want to delete your account? This action cannot be undone and will permanently remove your profile.");
                }
            </script>

        </body>

        </html>