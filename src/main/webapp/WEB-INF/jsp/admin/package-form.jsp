<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty packageDTO.id ? 'Edit' : 'Create'} Package - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/package-form.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>

<%@ include file="../fragments/navbar.jsp" %>

<div class="dashboard-container">
    <div class="main-content">
        
        <div class="page-header" style="max-width: 800px; margin: 0 auto 30px;">
            <h1 class="page-title">
                <i class="ph ${not empty packageDTO.id ? 'ph-pencil-simple-line' : 'ph-plus-circle'}" style="color: var(--secondary);"></i>
                ${not empty packageDTO.id ? 'Edit' : 'Create'} Room Package
            </h1>
        </div>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/admin/room-packages/save" method="post">
                <c:if test="${not empty packageDTO.id}">
                    <input type="hidden" name="id" value="${packageDTO.id}">
                </c:if>

                <div class="form-grid">
                    <div class="form-group full-width">
                        <label class="form-label">Package Type <span style="color: var(--danger);">*</span></label>
                        <select name="name" class="form-control" required>
                            <option value="">-- Select Package Type --</option>
                            <option value="Honeymoon Package" ${packageDTO.name == 'Honeymoon Package' ? 'selected' : ''}>Honeymoon Package</option>
                            <option value="Family Package" ${packageDTO.name == 'Family Package' ? 'selected' : ''}>Family Package</option>
                            <option value="Couple Package" ${packageDTO.name == 'Couple Package' ? 'selected' : ''}>Couple Package</option>
                            <option value="Seasonal Discount" ${packageDTO.name == 'Seasonal Discount' ? 'selected' : ''}>Seasonal Discount</option>
                            <option value="Business Package" ${packageDTO.name == 'Business Package' ? 'selected' : ''}>Business Package</option>
                            <option value="Holiday Special" ${packageDTO.name == 'Holiday Special' ? 'selected' : ''}>Holiday Special</option>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Brief details about what the package offers...">${packageDTO.description}</textarea>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Discount Percentage (%) <span style="color: var(--danger);">*</span></label>
                        <input type="number" step="0.01" name="discountPercentage" class="form-control" value="${packageDTO.discountPercentage}" placeholder="e.g. 15.0" min="0" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Minimum Guests</label>
                        <input type="number" name="minGuests" class="form-control" value="${packageDTO.minGuests == null ? 1 : packageDTO.minGuests}" min="1" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Maximum Guests</label>
                        <input type="number" name="maxGuests" class="form-control" value="${packageDTO.maxGuests}" placeholder="No limit" min="0">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Minimum Nights</label>
                        <input type="number" name="minNights" class="form-control" value="${packageDTO.minNights == null ? 1 : packageDTO.minNights}" min="1" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Applicable Room Type (Required for type-specific packages)</label>
                        <select name="applicableRoomType" class="form-control" required>
                            <option value="">-- Select Room Type --</option>
                            <option value="SINGLE" ${packageDTO.applicableRoomType == 'SINGLE' ? 'selected' : ''}>Single Room</option>
                            <option value="DOUBLE" ${packageDTO.applicableRoomType == 'DOUBLE' ? 'selected' : ''}>Double Room</option>
                            <option value="SUITE" ${packageDTO.applicableRoomType == 'SUITE' ? 'selected' : ''}>Suite</option>
                            <option value="DELUXE" ${packageDTO.applicableRoomType == 'DELUXE' ? 'selected' : ''}>Deluxe Room</option>
                            <option value="FAMILY" ${packageDTO.applicableRoomType == 'FAMILY' ? 'selected' : ''}>Family Room</option>
                            <option value="PRESIDENTIAL" ${packageDTO.applicableRoomType == 'PRESIDENTIAL' ? 'selected' : ''}>Presidential Suite</option>
                            <option value="PENTHOUSE" ${packageDTO.applicableRoomType == 'PENTHOUSE' ? 'selected' : ''}>Penthouse</option>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Provided Benefits</label>
                        <textarea name="benefits" class="form-control" rows="2" placeholder="e.g. Free Massage, Champagne, VIP Parking">${packageDTO.benefits}</textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Status</label>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <label class="toggle-switch">
                                <input type="checkbox" name="isActive" value="true" ${packageDTO.isActive != false ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                            <span style="font-size: 14px; font-weight: 500; color: var(--au-muted);">Active / Visible to guests</span>
                        </div>
                    </div>
                </div>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/admin/room-packages" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">
                        <i class="ph ph-floppy-disk"></i> Save Package
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
