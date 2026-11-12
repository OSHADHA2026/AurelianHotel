<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Check-In · Staff · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/checkin-form.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page">
    <div class="header">
        <h1><i class="ph ph-sign-in" style="color:#2bb3e6;"></i> Digital Check-In</h1>
        <p>Verify guest identity and record check-in for a reservation.</p>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success"><i class="ph ph-check-circle"></i> ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error"><i class="ph ph-warning-circle"></i> ${error}</div>
    </c:if>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/admin/checkin" id="checkinForm" onsubmit="return validateCheckInForm();">
            <div class="form-grid">
                <div class="group">
                    <label class="label">Select Reservation <span class="required">*</span></label>
                    <select name="bookingId" id="bookingId" class="control" onchange="updateBookingData(this)">
                        <option value="">-- Select Booking --</option>
                        <c:forEach var="b" items="${confirmedBookings}">
                            <option value="${b.id}" 
                                    data-name="${b.guestName}" 
                                    data-room="${b.room != null ? b.room.roomNumber : 'N/A'}" 
                                    data-requests="${b.specialRequests}"
                                    ${(booking != null && booking.id == b.id) || (param.bookingId == b.id) ? 'selected' : ''}>
                                #${b.id} - ${b.guestName} (Room ${b.room != null ? b.room.roomNumber : 'N/A'})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="group">
                    <label class="label">Guest name <span class="required">*</span></label>
                    <input type="text" name="guestName" class="control" id="guestName" placeholder="Auto-populated"
                           value="${booking != null ? booking.guestName : ''}" readonly>
                </div>
                <div class="group">
                    <label class="label">ID / Passport number <span class="required">*</span></label>
                    <input type="text" name="idPassportNumber" class="control" id="idPassportNumber" placeholder="For identity verification" required>
                </div>
                <div class="group">
                    <label class="label">Room number <span class="required">*</span></label>
                    <input type="text" name="roomNumber" class="control" id="roomNumber" placeholder="Auto-populated"
                           value="${booking != null && booking.room != null ? booking.room.roomNumber : ''}" readonly>
                </div>
                <div class="group">
                    <label class="label">Check-in date and time <span class="required">*</span></label>
                    <input type="datetime-local" name="checkInDateTime" class="control" id="checkInDateTime" step="60" required>
                </div>
            </div>
            <div class="group" style="margin-top:18px;">
                <label class="label">Special requests (optional)</label>
                <textarea name="specialRequests" class="textarea" id="specialRequests" placeholder="Any special requests or notes">${booking != null ? booking.specialRequests : ''}</textarea>
            </div>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary"><i class="ph ph-arrow-left"></i> Back to Dashboard</a>
                <button type="submit" class="btn btn-primary"><i class="ph ph-check"></i> Complete Check-In</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var dt = document.getElementById('checkInDateTime');
        if (dt && !dt.value) {
            var now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            dt.value = now.toISOString().slice(0, 16);
        }
        
        // If a booking was pre-selected (via URL), trigger the data update
        var select = document.getElementById('bookingId');
        if (select.value) {
            updateBookingData(select);
        }
    });

    function updateBookingData(select) {
        var option = select.options[select.selectedIndex];
        if (option && option.value) {
            document.getElementById('guestName').value = option.getAttribute('data-name') || '';
            document.getElementById('roomNumber').value = option.getAttribute('data-room') || '';
            document.getElementById('specialRequests').value = option.getAttribute('data-requests') || '';
        } else {
            document.getElementById('guestName').value = '';
            document.getElementById('roomNumber').value = '';
            document.getElementById('specialRequests').value = '';
        }
    }

    function validateCheckInForm() {
        var bookingId = document.getElementById('bookingId').value.trim();
        var guestName = document.getElementById('guestName').value.trim();
        var idPassport = document.getElementById('idPassportNumber').value.trim();
        var roomNumber = document.getElementById('roomNumber').value.trim();
        var checkInDt = document.getElementById('checkInDateTime').value;
        if (!bookingId || !guestName || !idPassport || !roomNumber || !checkInDt) {
            alert('Please select a reservation and fill all required fields.');
            return false;
        }
        return true;
    }
</script>
</body>
</html>
