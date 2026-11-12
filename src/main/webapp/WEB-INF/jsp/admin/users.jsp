<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management · Admin · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/users.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>

<%@ include file="../fragments/navbar.jsp" %>

<div class="admin-container">
    <div class="admin-header">
        <h1><i class="ph ph-users-three"></i> User Management</h1>
        <p>Manage guest, staff, and administrator accounts</p>
    </div>

    <!-- Statistics -->
    <div class="stats-bar">
        <div class="stat-box">
            <div class="stat-box-value">${totalUsers}</div>
            <div class="stat-box-label">Total Users</div>
        </div>
        <div class="stat-box">
            <div class="stat-box-value">${guestCount}</div>
            <div class="stat-box-label">Guests</div>
        </div>
        <div class="stat-box">
            <div class="stat-box-value">${staffCount}</div>
            <div class="stat-box-label">Staff</div>
        </div>
        <div class="stat-box">
            <div class="stat-box-value">${adminCount}</div>
            <div class="stat-box-label">Administrators</div>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">
            <i class="ph ph-check-circle"></i>
            <span>${success}</span>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-error">
            <i class="ph ph-warning-circle"></i>
            <span>${error}</span>
        </div>
    </c:if>

    <!-- User Management Section -->
    <div class="admin-section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="ph ph-list-bullets"></i>
                All Users
            </h2>
            <div class="filters">
                <form method="get" action="${pageContext.request.contextPath}/admin/users" style="display: flex; gap: 12px; flex-wrap: wrap; align-items: center;">
                    <div class="filter-group">
                        <select name="role" class="filter-select" onchange="this.form.submit()">
                            <option value="ALL" ${selectedRole == 'ALL' ? 'selected' : ''}>All Roles</option>
                            <option value="USER" ${selectedRole == 'USER' ? 'selected' : ''}>Guests</option>
                            <option value="EMPLOYEE" ${selectedRole == 'EMPLOYEE' ? 'selected' : ''}>Staff</option>
                            <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Administrators</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <input type="text" name="search" class="filter-input" placeholder="Search users..." value="${searchTerm}">
                    </div>
                    <div class="filter-group">
                        <button type="submit" class="btn-primary">
                            <i class="ph ph-magnifying-glass"></i>
                            Search
                        </button>
                    </div>
                </form>
                <button type="button" class="btn-primary btn-staff" onclick="openStaffModal()">
                    <i class="ph ph-user-focus"></i>
                    Create Staff Account
                </button>
                <a href="${pageContext.request.contextPath}/admin/users/create" class="btn-primary">
                    <i class="ph ph-plus"></i>
                    Add New User
                </a>
            </div>
        </div>

        <table class="users-table">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Job Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty users}">
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>
                                    <div class="user-info">
                                        <div class="user-avatar ${user.avatarColorClass}">
                                            ${user.avatarInitials}
                                        </div>
                                        <div class="user-details">
                                            <div class="user-name">${user.displayName}</div>
                                            <div class="user-email">${user.email}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>${user.username}</td>
                                <td>${user.email}</td>
                                <td>${user.phoneNumber}</td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users/role/${user.id}" style="display: inline;">
                                        <select name="role" class="role-select" onchange="if(confirm('Change role to ' + this.value + '?')) this.form.submit();">
                                            <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>Guest</option>
                                            <option value="EMPLOYEE" ${user.role == 'EMPLOYEE' ? 'selected' : ''}>Staff</option>
                                            <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                        </select>
                                    </form>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.role == 'EMPLOYEE'}">
                                            <span class="role-badge employee" style="background: #eef7fc; color: var(--au-text); border: 1px solid var(--au-line);">
                                                ${empty user.jobRole ? 'Not Assigned' : user.jobRole}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--au-muted); font-style: italic;">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/admin/users/edit/${user.id}" class="btn-icon btn-edit">
                                            <i class="ph ph-pencil-simple-line"></i>
                                            Edit
                                        </a>
                                        <c:if test="${user.id != sessionScope.user.id}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/users/delete/${user.id}" 
                                                  onsubmit="return confirm('Are you sure you want to delete this user? This action cannot be undone.');" 
                                                  style="display: inline;">
                                                <button type="submit" class="btn-icon btn-delete">
                                                    <i class="ph ph-trash"></i>
                                                    Delete
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 40px; color: var(--au-muted);">
                                <i class="ph ph-users" style="font-size: 48px; margin-bottom: 16px; opacity: 0.3;"></i>
                                <p>No users found</p>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- Staff Creation Modal -->
<div id="staffModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 class="modal-title"><i class="ph ph-user-plus"></i> Create Staff Account</h2>
            <span class="close-modal" onclick="closeStaffModal()">&times;</span>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/admin/users/create">
            <input type="hidden" name="role" value="EMPLOYEE">
            
            <div class="form-grid">
                <div>
                    <label class="modal-label">First Name *</label>
                    <input type="text" name="firstName" class="modal-input" required>
                </div>
                <div>
                    <label class="modal-label">Last Name *</label>
                    <input type="text" name="lastName" class="modal-input" required>
                </div>
                <div class="form-full">
                    <label class="modal-label">Email Address *</label>
                    <input type="email" name="email" class="modal-input" required>
                </div>
                <div class="form-full">
                    <label class="modal-label">Phone Number *</label>
                    <input type="tel" name="phoneNumber" class="modal-input" required>
                </div>
                <div class="form-full">
                    <label class="modal-label">Job Role *</label>
                    <select name="jobRole" class="modal-input" required>
                        <option value="">Select Job Role</option>
                        <option value="Manager">Manager</option>
                        <option value="Receptionist">Receptionist</option>
                        <option value="Concierge">Concierge</option>
                        <option value="Housekeeping">Housekeeping</option>
                        <option value="Chef">Chef</option>
                        <option value="Waiter">Waiter</option>
                        <option value="Security">Security</option>
                        <option value="Maintenance">Maintenance</option>
                    </select>
                </div>
                <div>
                    <label class="modal-label">Username *</label>
                    <input type="text" name="username" class="modal-input" required>
                </div>
                <div>
                    <label class="modal-label">Password *</label>
                    <input type="password" name="password" class="modal-input" required>
                </div>
            </div>

            <div style="display: flex; gap: 12px; margin-top: 24px;">
                <button type="submit" class="btn-primary" style="flex: 1; justify-content: center;">
                    <i class="ph ph-check"></i> Create Account
                </button>
                <button type="button" class="btn-primary btn-secondary" onclick="closeStaffModal()" style="flex: 1; justify-content: center; background: #eef7fc; color: var(--au-muted);">
                    Cancel
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openStaffModal() {
        document.getElementById('staffModal').style.display = 'flex';
    }

    function closeStaffModal() {
        document.getElementById('staffModal').style.display = 'none';
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        let modal = document.getElementById('staffModal');
        if (event.target == modal) {
            closeStaffModal();
        }
    }
</script>

<%@ include file="../fragments/footer.jsp" %>

</body>
</html>

