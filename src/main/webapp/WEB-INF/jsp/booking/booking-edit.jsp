<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Booking · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/booking/booking-edit.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>

<%@ include file="../fragments/navbar.jsp" %>

<div class="page">
    <div class="page-header">
        <h1><i class="ph ph-pen" style="color:#2bb3e6;"></i> Modify Reservation #${booking.id}</h1>
        <p>Update guest details, stay dates, number of guests, or special requests.</p>
    </div>

    <div class="card">
        <div class="summary">
            <p>
                <strong>Room:</strong> ${booking.room.roomNumber} · ${booking.room.roomType}<br/>
                <strong>Current stay:</strong>
                <c:choose>
                    <c:when test="${not empty booking.checkInDate}">
                        <c:out value="${fn:substring(booking.checkInDate.toString().replace('T', ' '), 0, 16)}" />
                    </c:when>
                    <c:otherwise>N/A</c:otherwise>
                </c:choose> –
                <c:choose>
                    <c:when test="${not empty booking.checkOutDate}">
                        <c:out value="${fn:substring(booking.checkOutDate.toString().replace('T', ' '), 0, 16)}" />
                    </c:when>
                    <c:otherwise>N/A</c:otherwise>
                </c:choose>
                · <strong>${booking.numberOfGuests}</strong> guest(s)
            </p>
        </div>

        <form method="post"
              action="${pageContext.request.contextPath}/reservations/${booking.id}/edit"
              onsubmit="return validateEditForm();">
            <div class="form-grid">
                <div class="form-group">
                    <label class="label">Guest Name <span style="color:#e55353;">*</span></label>
                    <input type="text" name="guestName" class="control" required
                           value="${booking.guestName != null ? booking.guestName : ''}"
                           placeholder="Full name">
                </div>
                <div class="form-group">
                    <label class="label">Contact Details <span style="color:#e55353;">*</span></label>
                    <input type="text" name="contactDetails" class="control" required
                           value="${booking.contactDetails != null ? booking.contactDetails : ''}"
                           placeholder="Email or phone">
                </div>
            </div>
            <div class="form-grid">
                <div class="form-group">
                    <label class="label">Check-in Date & Time</label>
                    <input type="datetime-local" name="checkInDate" class="control" id="checkInInput"
                           value="${not empty booking.checkInDate ? fn:substring(booking.checkInDate.toString(), 0, 16) : ''}">
                </div>
                <div class="form-group">
                    <label class="label">Check-out Date & Time</label>
                    <input type="datetime-local" name="checkOutDate" class="control" id="checkOutInput"
                           value="${not empty booking.checkOutDate ? fn:substring(booking.checkOutDate.toString(), 0, 16) : ''}">
                </div>
                <div class="form-group">
                    <label class="label">Number of Guests</label>
                    <input type="number" name="numberOfGuests" min="1" class="control"
                           value="${booking.numberOfGuests}">
                </div>
            </div>

            <div class="form-group" style="margin-top:18px;">
                <label class="label">Special Requests</label>
                <textarea name="specialRequests" class="textarea"><c:out value="${booking.specialRequests}" /></textarea>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/reservations/${booking.id}" class="btn btn-secondary">
                    <i class="ph ph-arrow-left"></i> Back to Reservation
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="ph ph-floppy-disk"></i> Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>

<script>
    function setMinDates() {
        const today = new Date().toISOString().split('T')[0];
        const checkIn = document.getElementById('checkInInput');
        const checkOut = document.getElementById('checkOutInput');
        if (checkIn && !checkIn.value) checkIn.min = today;
        if (checkOut && !checkOut.value) checkOut.min = today;
    }

    function validateEditForm() {
        const guestName = document.querySelector('input[name="guestName"]').value.trim();
        const contact = document.querySelector('input[name="contactDetails"]').value.trim();
        const checkIn = document.getElementById('checkInInput').value;
        const checkOut = document.getElementById('checkOutInput').value;
        const guestsValue = document.querySelector('input[name="numberOfGuests"]').value;
        const guests = parseInt(guestsValue || '0', 10);

        if (!guestName || !contact) {
            alert('Guest name and contact details are required.');
            return false;
        }
        if (!checkIn || !checkOut || guests <= 0) {
            alert('Please provide valid dates and a positive number of guests.');
            return false;
        }
        const checkInDate = new Date(checkIn);
        const checkOutDate = new Date(checkOut);
        if (checkOutDate <= checkInDate) {
            alert('Check-out date must be after check-in date.');
            return false;
        }
        return true;
    }

    document.addEventListener('DOMContentLoaded', setMinDates);
</script>

</body>
</html>

