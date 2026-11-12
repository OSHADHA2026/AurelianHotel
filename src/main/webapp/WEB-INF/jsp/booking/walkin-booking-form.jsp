<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Walk-in Booking · Staff · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/booking/walkin-booking-form.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>

<%@ include file="../fragments/navbar.jsp" %>

<div class="page">
    <div class="header">
        <h1><i class="ph ph-radio" style="color:#2bb3e6;"></i> Walk-in Booking</h1>
        <p>Create and manage walk-in bookings for guests at the front desk.</p>
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

    <div class="card">
        <form method="post"
              action="${pageContext.request.contextPath}/admin/walkin-bookings"
              onsubmit="return validateWalkInForm();">
            <div class="form-grid">
                <div class="group">
                    <label class="label">Guest Name <span class="required">*</span></label>
                    <input type="text" name="guestName" class="control" placeholder="Guest full name">
                </div>
                <div class="group">
                    <label class="label">Contact Details <span class="required">*</span></label>
                    <input type="text" name="contactDetails" class="control" placeholder="Phone / email">
                </div>
                <div class="group">
                    <label class="label">Room <span class="required">*</span></label>
                    <select name="roomId" class="select">
                        <option value="">Select an available room</option>
                        <c:forEach items="${availableRooms}" var="room">
                            <option value="${room.id}">
                                ${room.roomNumber} · ${room.roomType} · ${room.capacity} guests
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="group">
                    <label class="label">Check-in Date & Time <span class="required">*</span></label>
                    <input type="datetime-local" name="checkInDate" class="control" id="checkInInput">
                </div>
                <div class="group">
                    <label class="label">Check-out Date & Time <span class="required">*</span></label>
                    <input type="datetime-local" name="checkOutDate" class="control" id="checkOutInput">
                </div>
                <div class="group">
                    <label class="label">Number of Guests <span class="required">*</span></label>
                    <input type="number" name="numberOfGuests" class="control" min="1" value="1">
                </div>
                <div class="group">
                    <label class="label">Room Package (Optional) <span style="background:#2bb3e6; color:#fff; font-size:10px; padding:2px 6px; border-radius:3px; margin-left:4px;">New</span></label>
                    <select name="packageId" class="select">
                        <option value="">No Package</option>
                        <c:forEach items="${packages}" var="pkg">
                            <option value="${pkg.id}">
                                ${pkg.name}
                                <c:if test="${not empty pkg.discountPercentage and pkg.discountPercentage.doubleValue() > 0}">(-${pkg.discountPercentage}%)</c:if>
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="group" style="margin-top:18px;">
                <label class="label">Special Requests / Notes</label>
                <textarea name="specialRequests" class="textarea"
                          placeholder="Add any important notes for this walk-in booking"></textarea>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
                    <i class="ph ph-arrow-left"></i> Back to Admin
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="ph ph-check"></i> Create Walk-in Booking
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>

<script>
    function setMinDates() {
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        const nowIso = now.toISOString().slice(0, 16);
        const checkIn = document.getElementById('checkInInput');
        const checkOut = document.getElementById('checkOutInput');
        if (checkIn) checkIn.min = nowIso;
        if (checkOut) checkOut.min = nowIso;
    }

    function validateWalkInForm() {
        const guestName = document.querySelector('input[name="guestName"]').value.trim();
        const contact = document.querySelector('input[name="contactDetails"]').value.trim();
        const roomId = document.querySelector('select[name="roomId"]').value;
        const checkIn = document.getElementById('checkInInput').value;
        const checkOut = document.getElementById('checkOutInput').value;
        const guests = parseInt(document.querySelector('input[name=\"numberOfGuests\"]').value || '0', 10);

        if (!guestName || !contact || !roomId || !checkIn || !checkOut || guests <= 0) {
            alert('Please fill all required fields and ensure guests is at least 1.');
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

