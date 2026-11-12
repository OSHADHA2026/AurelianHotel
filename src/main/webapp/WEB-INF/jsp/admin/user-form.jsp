<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${empty user.id ? 'Create' : 'Edit'} User · Admin · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

            <!-- Google Fonts -->
            <link
                href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/user-form.css">
        <%@ include file="../fragments/head-assets.jsp" %>
</head>

        <body>

            <%@ include file="../fragments/navbar.jsp" %>

                <div class="admin-container">
                    <div class="admin-header">
                        <h1>
                            <i class="ph ph-${empty user.id ? 'user-plus' : 'user-gear'}"></i>
                            ${empty user.id ? 'Create' : 'Edit'} User
                        </h1>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="ph ph-warning-circle"></i>
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <div class="form-section">
                        <form method="post"
                            action="${pageContext.request.contextPath}/admin/users/${empty user.id ? 'create' : 'edit/' += user.id}">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="firstName">First Name *</label>
                                    <input type="text" id="firstName" name="firstName" value="${user.firstName}"
                                        required>
                                </div>
                                <div class="form-group">
                                    <label for="lastName">Last Name *</label>
                                    <input type="text" id="lastName" name="lastName" value="${user.lastName}" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="email">Email Address *</label>
                                <input type="email" id="email" name="email" value="${user.email}" required>
                            </div>

                            <div class="form-group">
                                <label for="phoneNumber">Phone Number *</label>
                                <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}"
                                    required>
                            </div>

                            <div class="form-group">
                                <label for="username">Username *</label>
                                <input type="text" id="username" name="username" value="${user.username}" required>
                            </div>

                            <div class="form-group">
                                <label for="password">Password ${empty user.id ? '*' : ''}</label>
                                <input type="password" id="password" name="password" ${empty user.id ? 'required' : ''
                                    }>
                                <div class="password-hint">
                                    ${empty user.id ? 'Enter a password for the new user' : 'Leave blank to keep current
                                    password'}
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="role">Role *</label>
                                <select id="role" name="role" required>
                                    <option value="USER" ${user.role=='USER' ? 'selected' : '' }>Guest</option>
                                    <option value="EMPLOYEE" ${user.role=='EMPLOYEE' ? 'selected' : '' }>Staff</option>
                                    <option value="ADMIN" ${user.role=='ADMIN' ? 'selected' : '' }>Administrator
                                    </option>
                                </select>
                            </div>

                            <div class="form-group" id="jobRoleGroup"
                                style="${user.role == 'EMPLOYEE' ? '' : 'display: none;'}">
                                <label for="jobRole">Job Role (for Staff only)</label>
                                <select id="jobRole" name="jobRole">
                                    <option value="">Select Job Role</option>
                                    <option value="Manager" ${user.jobRole=='Manager' ? 'selected' : '' }>Manager
                                    </option>
                                    <option value="Receptionist" ${user.jobRole=='Receptionist' ? 'selected' : '' }>
                                        Receptionist</option>
                                    <option value="Concierge" ${user.jobRole=='Concierge' ? 'selected' : '' }>Concierge
                                    </option>
                                    <option value="Housekeeping" ${user.jobRole=='Housekeeping' ? 'selected' : '' }>
                                        Housekeeping</option>
                                    <option value="Chef" ${user.jobRole=='Chef' ? 'selected' : '' }>Chef</option>
                                    <option value="Waiter" ${user.jobRole=='Waiter' ? 'selected' : '' }>Waiter</option>
                                    <option value="Security" ${user.jobRole=='Security' ? 'selected' : '' }>Security
                                    </option>
                                    <option value="Maintenance" ${user.jobRole=='Maintenance' ? 'selected' : '' }>
                                        Maintenance</option>
                                </select>
                            </div>

                            <script>
                                document.getElementById('role').addEventListener('change', function () {
                                    const jobRoleGroup = document.getElementById('jobRoleGroup');
                                    if (this.value === 'EMPLOYEE') {
                                        jobRoleGroup.style.display = 'block';
                                    } else {
                                        jobRoleGroup.style.display = 'none';
                                    }
                                });
                            </script>

                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="ph ph-floppy-disk"></i>
                                    ${empty user.id ? 'Create User' : 'Update User'}
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                                    <i class="ph ph-x"></i>
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <%@ include file="../fragments/footer.jsp" %>

        </body>

        </html>