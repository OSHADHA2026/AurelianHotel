<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation #${reservation.id} · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/booking/reservation-details.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>

<%@ include file="../fragments/navbar.jsp" %>

<div class="page">
    <a href="${pageContext.request.contextPath}/my-bookings" class="back-link">
        <i class="ph ph-arrow-left"></i> Back to My Reservations
    </a>

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

    <div class="header-row">
        <div>
            <h1>Reservation #${reservation.id}</h1>
            <span class="ref">Created: 
                <c:choose>
                    <c:when test="${not empty reservation.createdAt}">
                        ${fn:replace(reservation.createdAt, 'T', ' ')}
                    </c:when>
                    <c:otherwise>N/A</c:otherwise>
                </c:choose>
            </span>
        </div>
        <span class="status-badge ${fn:toLowerCase(reservation.status)}">${reservation.status}</span>
    </div>

    <div class="card">
        <div class="card-title"><i class="ph ph-user" style="color:#2bb3e6;"></i> Guest details</div>
        <div class="detail-grid">
            <div class="detail-item">
                <label>Guest name</label>
                <div class="value">${not empty reservation.guestName ? reservation.guestName : '—'}</div>
            </div>
            <div class="detail-item">
                <label>Contact</label>
                <div class="value">${not empty reservation.contactDetails ? reservation.contactDetails : '—'}</div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-title"><i class="ph ph-bed" style="color:#2bb3e6;"></i> Room selection</div>
        <div class="detail-grid">
            <div class="detail-item">
                <label>Room number</label>
                <div class="value">${reservation.room.roomNumber}</div>
            </div>
            <div class="detail-item">
                <label>Room type</label>
                <div class="value">${reservation.room.roomType}</div>
            </div>
            <div class="detail-item">
                <label>Guests</label>
                <div class="value">${reservation.numberOfGuests}</div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-title"><i class="ph ph-calendar-blank" style="color:#2bb3e6;"></i> Reservation dates</div>
        <div class="detail-grid">
            <div class="detail-item">
                <label>Check-in</label>
                <div class="value">
                    <c:choose>
                        <c:when test="${not empty reservation.checkInDate}">
                            ${fn:replace(reservation.checkInDate, 'T', ' ')}
                        </c:when>
                        <c:otherwise>N/A</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detail-item">
                <label>Check-out</label>
                <div class="value">
                    <c:choose>
                        <c:when test="${not empty reservation.checkOutDate}">
                            ${fn:replace(reservation.checkOutDate, 'T', ' ')}
                        </c:when>
                        <c:otherwise>N/A</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detail-item">
                <label>Nights</label>
                <div class="value">${reservation.numberOfNights}</div>
            </div>
            <div class="detail-item">
                <label>Total amount</label>
                <div class="value amount">
                    <fmt:formatNumber value="${reservation.totalAmount}" type="currency" currencySymbol="$" maxFractionDigits="2"/>
                </div>
            </div>
            <c:if test="${not empty reservation.roomPackage}">
            <div class="detail-item">
                <label>Applied Package</label>
                <div class="value" style="color: #2bb3e6; font-weight: bold;">
                    <i class="ph ph-gift"></i> ${reservation.roomPackage.name}
                </div>
            </div>
            <div class="detail-item">
                <label>Package Discount</label>
                <div class="value amount" style="color: #2e8b57;">
                    - <fmt:formatNumber value="${reservation.packageDiscountAmount}" type="currency" currencySymbol="$" maxFractionDigits="2"/>
                </div>
            </div>
            <c:if test="${reservation.discountAmount > 0}">
            <div class="detail-item">
                <label>Manual Discount</label>
                <div class="value amount" style="color: #5aacd2;">
                    - <fmt:formatNumber value="${reservation.discountAmount}" type="currency" currencySymbol="$" maxFractionDigits="2"/>
                </div>
            </div>
            </c:if>
            </c:if>
        </div>
    </div>

    <c:if test="${not empty reservation.specialRequests}">
        <div class="card">
            <div class="card-title"><i class="ph ph-chat-circle-dots" style="color:#2bb3e6;"></i> Special requests</div>
            <div class="special-requests">${reservation.specialRequests}</div>
        </div>
    </c:if>

    <%-- Staff only extension section --%>
    <c:if test="${(sessionScope.user.role == 'ADMIN' || sessionScope.user.role == 'EMPLOYEE') && (reservation.status == 'CONFIRMED' || reservation.status == 'CHECKED_IN')}">
        <div class="card" style="border: 2px solid #2bb3e6; background: #fffcf5;">
            <div class="card-title" style="color: #1590c4;"><i class="ph ph-user-gear"></i> Staff Action: Extend Stay</div>
            <p style="font-size: 13px; color: var(--au-muted); margin-bottom: 16px;">
                As a staff member, you can extend the guest's checkout date. 
                <strong>Daily Rate:</strong> <fmt:formatNumber value="${reservation.room.pricePerNight}" type="currency" currencySymbol="$"/> 
                (extra nights) + <strong>Staff Service Fee:</strong> $10.00.
            </p>
            <form action="${pageContext.request.contextPath}/reservations/${reservation.id}/extend" method="post" style="display: flex; align-items: flex-end; gap: 12px; flex-wrap: wrap;">
                <div class="detail-item" style="flex: 1; min-width: 200px;">
                    <label for="newCheckOutDate">New Check-out Date & Time</label>
                    <c:set var="isoDate" value="${fn:substring(reservation.checkOutDate, 0, 16)}"/>
                    <input type="datetime-local" id="newCheckOutDate" name="newCheckOutDate" 
                           value="${isoDate}" 
                           min="${isoDate}"
                           style="width: 100%; padding: 10px; border: 1px solid #2bb3e6; border-radius: 2px; font-family: inherit; font-size: 14px;" required>
                </div>
                <button type="submit" class="btn btn-primary" style="height: 42px;">
                    <i class="ph ph-calendar-plus"></i> Process Extension
                </button>
            </form>
        </div>
    </c:if>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/my-bookings" class="btn btn-outline">
            <i class="ph ph-list-bullets"></i> All Reservations
        </a>
        <c:if test="${reservation.status != 'CANCELLED' && reservation.status != 'COMPLETED'}">
            <c:choose>
                <c:when test="${canModify}">
                    <a href="${pageContext.request.contextPath}/reservations/${reservation.id}/edit" class="btn btn-primary">
                        <i class="ph ph-pen"></i> Modify reservation
                    </a>
                    <span style="font-size: 12px; color: var(--au-muted); margin-left: 10px;">
                        <i class="ph ph-info"></i> Modifications allowed within 24 hours of booking
                    </span>
                </c:when>
                <c:otherwise>
                    <span style="font-size: 13px; color: #e55353; font-weight: 500;">
                        <i class="ph ph-clock-counter-clockwise"></i> Modification window closed (24 hours passed). Please contact support.
                    </span>
                </c:otherwise>
            </c:choose>
            
            <%-- Only Staff and Admin can cancel reservations --%>
            <c:if test="${sessionScope.user.role == 'ADMIN' || sessionScope.user.role == 'EMPLOYEE'}">
                <form method="post" action="${pageContext.request.contextPath}/reservations/${reservation.id}/cancel"
                      onsubmit="return confirm('Are you sure you want to cancel this reservation?');" style="display:inline;">
                    <button type="submit" class="btn btn-danger">
                        <i class="ph ph-x-circle"></i> Cancel reservation
                    </button>
                </form>
            </c:if>
        </c:if>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>

</body>
</html>
