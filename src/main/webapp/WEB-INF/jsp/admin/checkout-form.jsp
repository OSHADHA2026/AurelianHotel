<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Check-Out · Staff · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/checkout-form.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page">
    <div class="header">
        <h1><i class="ph ph-sign-out" style="color:#2bb3e6;"></i> Digital Check-Out</h1>
        <p>Record check-out time, view stay duration, and add any additional charges.</p>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success"><i class="ph ph-check-circle"></i> ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error"><i class="ph ph-warning-circle"></i> ${error}</div>
    </c:if>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/admin/checkout" id="checkoutForm" onsubmit="return validateCheckOutForm();">
            <div class="form-grid">
                <div class="group">
                    <label class="label">Select Active Stay <span class="required">*</span></label>
                    <select name="bookingId" id="bookingId" class="control" onchange="updateBookingData(this)">
                        <option value="">-- Select Booking --</option>
                        <c:forEach var="b" items="${activeBookings}">
                            <option value="${b.id}" 
                                    data-room="${b.room != null ? b.room.roomNumber : 'N/A'}" 
                                    data-checkin-iso="${b.actualCheckInDateTime}"
                                    ${(booking != null && booking.id == b.id) || (param.bookingId == b.id) ? 'selected' : ''}>
                                #${b.id} - ${b.guestName} (Room ${b.room != null ? b.room.roomNumber : 'N/A'})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="group">
                    <label class="label">Room number <span class="required">*</span></label>
                    <input type="text" name="roomNumber" class="control" id="roomNumber" placeholder="Auto-populated"
                           value="${booking != null && booking.room != null ? booking.room.roomNumber : ''}" readonly>
                </div>
                <div class="group">
                    <label class="label">Check-out date and time <span class="required">*</span></label>
                    <input type="datetime-local" name="checkOutDateTime" class="control" id="checkOutDateTime" step="60" required>
                </div>
                <div class="group">
                    <label class="label">Total stay duration</label>
                    <input type="text" class="control stay-duration" id="stayDuration" readonly placeholder="Auto-calculated"
                           data-check-in-iso="${checkInDateTimeIso}">
                </div>
                <div class="group">
                    <label class="label">Additional charges (if any)</label>
                    <input type="number" name="additionalCharges" class="control" id="additionalCharges" min="0" step="0.01" placeholder="0.00" value="0">
                </div>
            </div>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary"><i class="ph ph-arrow-left"></i> Back to Dashboard</a>
                <button type="submit" class="btn btn-primary"><i class="ph ph-check"></i> Complete Check-Out</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>

<script>
    var currentCheckInIso = document.getElementById('stayDuration').getAttribute('data-check-in-iso');

    function updateBookingData(select) {
        var option = select.options[select.selectedIndex];
        if (option && option.value) {
            document.getElementById('roomNumber').value = option.getAttribute('data-room') || '';
            currentCheckInIso = option.getAttribute('data-checkin-iso') || '';
            document.getElementById('stayDuration').setAttribute('data-check-in-iso', currentCheckInIso);
            updateStayDuration();
        } else {
            document.getElementById('roomNumber').value = '';
            currentCheckInIso = '';
            document.getElementById('stayDuration').setAttribute('data-check-in-iso', '');
            document.getElementById('stayDuration').value = '';
        }
    }

    function formatDuration(hours) {
        if (hours < 0) return '';
        var d = Math.floor(hours / 24);
        var h = Math.floor(hours % 24);
        var m = Math.floor((hours * 60) % 60);
        
        var parts = [];
        if (d > 0) parts.push(d + ' day(s)');
        if (h > 0) parts.push(h + ' hour(s)');
        if (m > 0 || parts.length === 0) parts.push(m + ' minute(s)');
        
        return parts.join(' ');
    }

    function updateStayDuration() {
        var checkOutInput = document.getElementById('checkOutDateTime');
        var stayDurationInput = document.getElementById('stayDuration');
        
        if (!currentCheckInIso || !checkOutInput || !checkOutInput.value) {
            stayDurationInput.value = '';
            return;
        }
        
        var checkIn = new Date(currentCheckInIso.replace(' ', 'T'));
        var checkOut = new Date(checkOutInput.value.replace(' ', 'T'));
        
        if (isNaN(checkIn.getTime()) || isNaN(checkOut.getTime()) || checkOut <= checkIn) {
            stayDurationInput.value = 'Invalid or past check-out time';
            return;
        }
        
        var hours = (checkOut - checkIn) / (1000 * 60 * 60);
        stayDurationInput.value = formatDuration(hours);
    }

    document.addEventListener('DOMContentLoaded', function() {
        var dt = document.getElementById('checkOutDateTime');
        if (dt && !dt.value) {
            var now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            dt.value = now.toISOString().slice(0, 16);
        }
        
        var select = document.getElementById('bookingId');
        if (select.value) {
            updateBookingData(select);
        }

        if (dt) {
            dt.addEventListener('change', updateStayDuration);
            dt.addEventListener('input', updateStayDuration);
        }
    });

    function validateCheckOutForm() {
        var bookingId = document.getElementById('bookingId').value.trim();
        var roomNumber = document.getElementById('roomNumber').value.trim();
        var checkOutDt = document.getElementById('checkOutDateTime').value;
        if (!bookingId || !roomNumber || !checkOutDt) {
            alert('Please select a stay and fill all required fields.');
            return false;
        }
        return true;
    }
</script>
</body>
</html>
