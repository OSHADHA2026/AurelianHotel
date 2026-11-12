<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Sessions · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/employee-sessions.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>

<body>

    <%@ include file="../fragments/navbar.jsp" %>

    <div class="dashboard-container">
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
            <span class="separator">/</span>
            <span style="color: var(--text-secondary);">Employee Sessions</span>
        </nav>

        <header class="header-section">
            <div>
                <h1>Login Tracking</h1>
                <p>System-wide activity logs for employees and administrators.</p>
            </div>
        </header>

        <div class="card">
            <div class="table-container">
                <c:choose>
                    <c:when test="${not empty sessions}">
                        <table>
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Role</th>
                                    <th>Login Time</th>
                                    <th>Logout Time</th>
                                    <th>Duration</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="userSession" items="${sessions}">
                                    <tr>
                                        <td>
                                            <span class="employee-name">${userSession.user.displayName}</span>
                                            <span class="employee-username">@${userSession.user.username}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty userSession.user.role}">
                                                    <c:set var="userRole" value="${fn:toUpperCase(userSession.user.role)}" />
                                                    <c:choose>
                                                        <c:when test="${fn:contains(userRole, 'ADMIN')}">
                                                            <span class="role-tag tag-admin">ADMIN</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="role-tag tag-employee">STAFF</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="role-tag tag-employee">STAFF</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:parseDate value="${userSession.loginTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedLogin" type="both" />
                                            <fmt:formatDate value="${parsedLogin}" pattern="MMM dd, HH:mm" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty userSession.logoutTime}">
                                                    <fmt:parseDate value="${userSession.logoutTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedLogout" type="both" />
                                                    <fmt:formatDate value="${parsedLogout}" pattern="MMM dd, HH:mm" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-active">
                                                        <span class="pulse-indicator"></span>
                                                        Active
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${not empty userSession.durationMinutes}">
                                                <span class="duration-text">
                                                    <c:choose>
                                                        <c:when test="${userSession.durationMinutes >= 60}">
                                                            <c:set var="hours" value="${(userSession.durationMinutes - (userSession.durationMinutes % 60)) / 60}" />
                                                            <fmt:formatNumber value="${hours}" pattern="#" />h 
                                                            ${userSession.durationMinutes % 60}m
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${userSession.durationMinutes}m
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="ph ph-tray"></i>
                            <p>No activity logs found yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

</body>
</html>