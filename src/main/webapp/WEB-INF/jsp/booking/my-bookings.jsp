<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reservations · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/booking/my-bookings.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>

<%@ include file="../fragments/navbar.jsp" %>

<div class="container">
    <div class="header">
        <h1><i class="ph ph-calendar-check" style="color:#2bb3e6;"></i> My Reservations</h1>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/reservations">
                <i class="ph ph-plus-circle"></i> Create reservation
            </a>
        </div>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">
            <i class="ph ph-check-circle"></i>
            ${success}
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">
            <i class="ph ph-warning-circle"></i>
            ${error}
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty bookings}">
            <c:forEach items="${bookings}" var="booking">
                <div class="booking-card">
                    <div class="booking-header">
                        <a href="${pageContext.request.contextPath}/reservations/${booking.id}" class="booking-id" style="text-decoration:none;color:var(--au-muted);">Reservation #${booking.id}</a>
                        <span class="status-badge ${fn:toLowerCase(booking.status)}">${booking.status}</span>
                    </div>
                    <div class="details-grid">
                        <div>
                            <div class="detail-label">Room</div>
                            <div class="detail-value">
                                ${booking.room.roomNumber} · ${booking.room.roomType}
                            </div>
                        </div>
                        <div>
                            <div class="detail-label">Check-in</div>
                            <div class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty booking.checkInDate}">
                                        <c:out value="${fn:substring(booking.checkInDate.toString().replace('T', ' '), 0, 10)}" />
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div>
                            <div class="detail-label">Check-out</div>
                            <div class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty booking.checkOutDate}">
                                        <c:out value="${fn:substring(booking.checkOutDate.toString().replace('T', ' '), 0, 10)}" />
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div>
                            <div class="detail-label">Guests</div>
                            <div class="detail-value">${booking.numberOfGuests}</div>
                        </div>
                        <div>
                            <div class="detail-label">Total Amount</div>
                            <div class="detail-value amount">
                                <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="$" maxFractionDigits="2"/>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty booking.specialRequests}">
                        <div style="margin-top: 10px; font-size: 13px; color:var(--au-text);">
                            <span style="font-weight:600;">Notes:</span>
                            <span>${booking.specialRequests}</span>
                        </div>
                    </c:if>

                    <div class="actions">
                        <a href="${pageContext.request.contextPath}/reservations/${booking.id}" class="btn-sm btn-outline">
                            <i class="ph ph-eye"></i> View
                        </a>
                        
                        <c:if test="${booking.status != 'CANCELLED' && booking.status != 'COMPLETED'}">
                            <%-- Calculate if modification is allowed (Staff OR within 24h) --%>
                            <c:set var="isStaffMember" value="${user.role == 'ADMIN' || user.role == 'EMPLOYEE'}" />
                            <c:set var="isRecent" value="${booking.createdAt.plusHours(24).isAfter(now)}" />
                            
                            <c:choose>
                                <c:when test="${isStaffMember || isRecent}">
                                    <a href="${pageContext.request.contextPath}/reservations/${booking.id}/edit" class="btn-sm btn-outline">
                                        <i class="ph ph-pen"></i> Modify
                                    </a>
                                    <c:if test="${!isStaffMember}">
                                        <span style="font-size: 11px; color: var(--au-muted); margin-left: 5px;">(24h window open)</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-size: 11px; color: #e55353; font-weight: 500; margin-left: 5px;">(Modification closed)</span>
                                </c:otherwise>
                            </c:choose>

                            <%-- Only Staff and Admin can cancel reservations --%>
                            <c:if test="${isStaffMember}">
                                <form method="post"
                                      action="${pageContext.request.contextPath}/reservations/${booking.id}/cancel"
                                      onsubmit="return confirm('Are you sure you want to cancel this reservation?');" style="display:inline;">
                                    <button type="submit" class="btn-sm btn-danger">
                                        <i class="ph ph-x-circle"></i> Cancel
                                    </button>
                                </form>
                            </c:if>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <i class="ph ph-calendar-x"></i>
                <h3>No reservations yet</h3>
                <p>Create your first reservation to get started.</p>
                <div style="margin-top:16px;">
                    <a href="${pageContext.request.contextPath}/reservations"
                       style="padding:10px 20px;border-radius:999px;border:none;background:#2bb3e6;color:#fff;font-weight:600;text-decoration:none;">
                        <i class="ph ph-plus-circle"></i> Create reservation
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="../fragments/footer.jsp" %>

</body>
</html>

