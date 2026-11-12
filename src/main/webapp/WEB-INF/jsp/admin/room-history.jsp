<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room History · Admin · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/room-history.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>
    <%@ include file="../fragments/navbar.jsp" %>

    <div class="main-content">
        <div class="header">
            <h1><i class="ph ph-clock-counter-clockwise"></i> Room Occupancy History (Audit Mode)</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/rooms/admin/management" class="btn btn-secondary">
                    <i class="ph ph-arrow-left"></i> Back to Management
                </a>
            </div>
        </div>

        <c:if test="${not isGeneralHistory}">
            <div class="room-info-card">
                <div class="room-info-content">
                    <h2>Room ${room.roomNumber} History</h2>
                    <p>${room.roomType} · Floor ${room.floor} · Max ${room.capacity} Guests</p>
                </div>
                <div class="room-badge">
                    ${fn:length(history)} Past Stays
                </div>
            </div>
        </c:if>

        <div class="history-container">
            <c:choose>
                <c:when test="${not empty history}">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Guest Name</th>
                                <c:if test="${isGeneralHistory}">
                                    <th>Room</th>
                                </c:if>
                                <th>Check-In</th>
                                <th>Check-Out</th>
                                <th>Duration</th>
                                <th>Status</th>
                                <th>Total Amount</th>
                                <th>ID Ref.</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${history}" var="booking">
                                <tr>
                                    <td>
                                        <div class="guest-name">${booking.guestName}</div>
                                        <div style="font-size: 12px; color: var(--au-muted);">User: ${booking.user.username}</div>
                                    </td>
                                    <c:if test="${isGeneralHistory}">
                                        <td><span class="room-no">Room ${booking.room.roomNumber}</span></td>
                                    </c:if>
                                    <td class="date-cell">
                                        <c:choose>
                                            <c:when test="${not empty booking.getActualCheckInFormatted()}">
                                                ${booking.actualCheckInFormatted}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--au-muted); font-size: 12px;">(Sched: ${booking.checkInFormatted})</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="date-cell">
                                        <c:choose>
                                            <c:when test="${not empty booking.getActualCheckOutFormatted()}">
                                                ${booking.actualCheckOutFormatted}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--au-muted); font-size: 12px;">(Sched: ${booking.checkOutFormatted})</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="duration-badge">${booking.stayDurationFormatted}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.status == 'COMPLETED'}"><span class="status-badge" style="background: #d4edda; color: #155724; padding: 4px 8px; border-radius: 2px; font-size: 12px; font-weight: 600;">COMPLETED</span></c:when>
                                            <c:when test="${booking.status == 'CHECKED_IN'}"><span class="status-badge" style="background: #fff3cd; color: #856404; padding: 4px 8px; border-radius: 2px; font-size: 12px; font-weight: 600;">CHECKED_IN</span></c:when>
                                            <c:when test="${booking.status == 'CONFIRMED'}"><span class="status-badge" style="background: #ebe3d7; color: var(--au-text); padding: 4px 8px; border-radius: 2px; font-size: 12px; font-weight: 600;">CONFIRMED</span></c:when>
                                            <c:when test="${booking.status == 'CANCELLED'}"><span class="status-badge" style="background: #f8d7da; color: #721c24; padding: 4px 8px; border-radius: 2px; font-size: 12px; font-weight: 600;">CANCELLED</span></c:when>
                                            <c:otherwise><span class="status-badge" style="background: #dce9f1; color: var(--au-text); padding: 4px 8px; border-radius: 2px; font-size: 12px; font-weight: 600;">${booking.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="amount">$<fmt:formatNumber value="${booking.totalAmount}" minFractionDigits="2"/></span>
                                    </td>
                                    <td style="font-family: monospace; color: var(--au-muted);">
                                        ${booking.idPassportNumber}
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/billing/${booking.id}" class="btn" style="background: #2bb3e6; color: white; padding: 6px 14px; font-size: 13px; border-radius: 2px;">
                                            <i class="ph ph-receipt"></i> Bill
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="ph ph-calendar-x"></i>
                        <p>No past occupancy records found for this criteria.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%@ include file="../fragments/footer.jsp" %>
</body>
</html>
