<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Packages - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/room-packages.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>

<%@ include file="../fragments/navbar.jsp" %>

<div class="dashboard-container">
    <div class="main-content">
        
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

        <div class="page-header">
            <h1 class="page-title"><i class="ph ph-package" style="color: var(--secondary);"></i> Room Packages</h1>
            <a href="${pageContext.request.contextPath}/admin/room-packages/new" class="btn btn-primary">
                <i class="ph ph-plus"></i> Create New Package
            </a>
        </div>

        <div class="card">
            <c:choose>
                <c:when test="${empty packages}">
                    <div class="empty-state">
                        <i class="ph ph-package"></i>
                        <h3>No Packages Found</h3>
                        <p>There are no room packages currently active in the system.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Discount</th>
                                <th>Guests (Min-Max)</th>
                                <th>Min Nights</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${packages}" var="pkg">
                                <tr>
                                    <td>
                                        <strong><c:out value="${pkg.name}"/></strong>
                                        <div style="font-size: 13px; color: var(--au-muted); margin-top: 4px;">
                                            <c:choose>
                                                <c:when test="${not empty pkg.applicableRoomType}">${pkg.applicableRoomType} Only</c:when>
                                                <c:otherwise>All Room Types</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty pkg.discountPercentage}">
                                                <c:out value="${pkg.discountPercentage}"/>% OFF
                                            </c:when>
                                            <c:when test="${not empty pkg.fixedDiscountAmount}">
                                                $<c:out value="${pkg.fixedDiscountAmount}"/> OFF
                                            </c:when>
                                            <c:otherwise>No Discount</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:out value="${pkg.minGuests}"/> - 
                                        <c:choose>
                                            <c:when test="${not empty pkg.maxGuests}"><c:out value="${pkg.maxGuests}"/></c:when>
                                            <c:otherwise>Any</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><c:out value="${pkg.minNights}"/></td>
                                    <td>
                                        <c:set var="isPkgActive" value="${pkg.isActive}"/>
                                        <span class="status-badge ${isPkgActive ? 'status-active' : 'status-inactive'}">
                                            ${isPkgActive ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/room-packages/${pkg.id}/edit" class="btn btn-sm btn-edit" title="Edit">
                                            <i class="ph ph-pencil-simple-line"></i>
                                        </a>
                                        <c:if test="${sessionScope.user.role == 'ADMIN' || sessionScope.user.role == 'EMPLOYEE'}">
                                            <a href="${pageContext.request.contextPath}/admin/room-packages/${pkg.id}/delete" 
                                               class="btn btn-sm btn-delete" 
                                               title="Delete"
                                               onclick="return confirm('Are you sure you want to completely delete this package? This cannot be undone.');">
                                                <i class="ph ph-trash"></i>
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>
