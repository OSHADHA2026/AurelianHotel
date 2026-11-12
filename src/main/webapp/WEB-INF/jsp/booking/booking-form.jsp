<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Create Reservation · Aurelian Hotel</title>
            <link rel="icon" type="image/png" href="/favicon.png">

            <link
                href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/page-hero.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/booking/booking-form.css">
        <%@ include file="../fragments/head-assets.jsp" %>
</head>

        <body class="au-reserve">

            <%@ include file="../fragments/navbar.jsp" %>

                <section class="au-page-hero" style="background-image:url('${pageContext.request.contextPath}/images/scenes/cove.svg')"><div class="au-page-hero-inner"><span class="au-eyebrow">Reservation</span><h1>Reserve Your Stay</h1><p>Enter guest details, select a room and choose your dates &mdash; we will confirm everything by email.</p></div></section>

                <div class="page-container">
                    <div class="page-header">
                        <h1><i class="ph ph-calendar-plus" style="color:#2bb3e6;"></i> Create Reservation</h1>
                        <p>Enter guest details, select a room, and choose your reservation dates.</p>
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

                    <aside class="au-reserve-aside">
<div class="au-aside-card"><h4>Your stay includes</h4><ul class="au-aside-list"><li><i class="ph ph-envelope-simple"></i><span><b>Email confirmation</b>Sent to your contact details</span></li><li><i class="ph ph-bell-ringing"></i><span><b>24/7 concierge</b>Always here to help</span></li><li><i class="ph ph-wifi-high"></i><span><b>Premium Wi-Fi</b>Fast connection in every room</span></li><li><i class="ph ph-diamond"></i><span><b>Member benefits</b>Exclusive packages and offers</span></li></ul></div>
<div class="au-aside-card au-aside-help"><h4>Need help booking?</h4><p>Our reservations team is happy to assist you with your stay.</p><a href="tel:+15550142290"><i class="ph ph-phone"></i> +1 (555) 014-2290</a></div>
</aside>

                    <div class="card">
                        <form method="post" action="${pageContext.request.contextPath}/reservations" id="bookingForm"
                            enctype="multipart/form-data" onsubmit="return handleFormSubmit(event);">
                            <input type="hidden" name="paymentMethod" id="hiddenPaymentMethod" value="CARD">
                            <input type="hidden" name="cardNumber" id="hiddenCardNumber">
                            <input type="hidden" name="cardExpiry" id="hiddenCardExpiry">
                            <!-- Section 1: Guest Information -->
                            <div class="form-section">
                                <h3 class="section-title"><i class="ph ph-user-circle"></i> Guest Information</h3>
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label class="form-label">Full Name <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <i class="ph ph-user"></i>
                                            <input type="text" name="guestName" class="form-control" placeholder="Enter guest's full name" style="padding-left: 36px;">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Contact Details <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <i class="ph ph-envelope-simple"></i>
                                            <input type="text" name="contactDetails" class="form-control" placeholder="Email or phone number" style="padding-left: 36px;">
                                        </div>
                                        <span class="help-text">Used to send the booking confirmation.</span>
                                    </div>
                                </div>
                            </div>
                            
                            <hr class="section-divider">

                            <!-- Section 2: Stay Details -->
                            <div class="form-section">
                                <h3 class="section-title"><i class="ph ph-bed"></i> Stay Details</h3>
                                <div class="form-grid">
                                    <div class="form-group" style="grid-column: 1 / -1;">
                                        <label class="form-label">Selected Room <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <i class="ph ph-door-open" style="z-index: 1;"></i>
                                            <c:choose>
                                                <c:when test="${not empty availableRooms}">
                                                    <select name="roomId" class="form-select" style="padding-left: 36px;">
                                                        <option value="">Choose a room from available options</option>
                                                        <c:forEach items="${availableRooms}" var="room">
                                                            <option value="${room.id}" 
                                                                    data-room-type="${room.roomType}"
                                                                    <c:if test="${selectedRoomId != null && selectedRoomId == room.id}">selected</c:if>>
                                                                ${room.roomNumber} · ${room.roomType} · ${room.capacity} guests
                                                                · $${room.pricePerNight} / night
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </c:when>
                                                <c:otherwise>
                                                    <select class="form-select" disabled style="padding-left: 36px;">
                                                        <option>No rooms available</option>
                                                    </select>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Check-in Date & Time <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <i class="ph ph-calendar-blank"></i>
                                            <input type="datetime-local" name="checkInDate" class="form-control" id="checkInInput" style="padding-left: 36px;">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Check-out Date & Time <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <i class="ph ph-calendar-check"></i>
                                            <input type="datetime-local" name="checkOutDate" class="form-control" id="checkOutInput" style="padding-left: 36px;">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Number of Guests <span class="required">*</span></label>
                                        <div class="input-with-icon">
                                            <i class="ph ph-users"></i>
                                            <input type="number" name="numberOfGuests" min="1" class="form-control" value="1" style="padding-left: 36px;">
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Room Package (Optional) <span class="badge" style="background:#2bb3e6; color:#fff; font-size:10px; padding:2px 6px; border-radius:3px;">New</span></label>
                                        <div class="input-with-icon">
                                            <i class="ph ph-gift" style="z-index: 1;"></i>
                                            <select name="packageId" class="form-select" style="padding-left: 36px;">
                                                <option value="">No Package</option>
                                                <c:forEach items="${packages}" var="pkg">
                                                    <option value="${pkg.id}" data-applicable-room-type="${pkg.applicableRoomType}">
                                                        ${pkg.name} 
                                                        <c:if test="${pkg.discountPercentage > 0}">(-${pkg.discountPercentage}%)</c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-top: 24px;">
                                <label class="form-label">Special Requests (Optional)</label>
                                <textarea name="specialRequests" class="form-textarea"
                                    placeholder="Add any special requests (e.g., late check-in, high floor)..."></textarea>
                            </div>

                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/rooms" class="btn btn-secondary">
                                    <i class="ph ph-arrow-left"></i> Back to Rooms
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="ph ph-check"></i> Confirm Booking
                                </button>
                            </div>
                        
                    </div>
                </div>

                <div class="modal-overlay" id="paymentModal">
                    <div class="modal" style="max-height: 90vh; overflow-y: auto;">
                        <span class="modal-close" onclick="closePaymentModal()">&times;</span>
                        <h2 style="color: #2bb3e6;"><i class="ph ph-shield-check"></i> Secure Payment Details</h2>

                        <div id="paymentSuccessMessage"
                            style="display: none; background: #d4edda; color: #155724; padding: 14px; border-radius: 4px; margin-bottom: 20px; text-align: center; font-weight: 500; align-items: center; justify-content: center; gap: 8px;">
                            <i class="ph ph-check-circle" style="font-size: 18px;"></i> Payment successful! Confirming
                            booking...
                        </div>

                        <div id="paymentFormBody">
                            <h3 style="font-size: 15px; margin-bottom: 12px; color: var(--au-muted);">Billing Information</h3>
                            <div class="form-group" style="margin-bottom: 12px;">
                                <label class="form-label">Email Address</label>
                                <input type="email" id="paymentEmail" class="form-control"
                                    value="${sessionScope.user.email}" readonly style="background-color: var(--au-soft);">
                            </div>
                            <div class="form-group" style="margin-bottom: 12px;">
                                <label class="form-label">Phone Number</label>
                                <input type="text" id="paymentPhone" class="form-control"
                                    value="${sessionScope.user.phoneNumber}" readonly
                                    style="background-color: var(--au-soft);">
                            </div>
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label class="form-label">Billing Address <span class="required">*</span></label>
                                <input type="text" id="paymentAddress" class="form-control"
                                    placeholder="123 Main St, City, Country">
                                <span class="help-text" id="addressError" style="color: #e55353; display: none;">Billing
                                    address is required.</span>
                            </div>

                            <div style="margin-bottom: 20px;">
                                <label class="form-label" style="display: block; margin-bottom: 10px;">Select Payment Method <span class="required">*</span></label>
                                <div style="display: flex; gap: 20px;">
                                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 14px;">
                                        <input type="radio" name="payMethodSelection" value="CARD" checked onclick="togglePaymentMethod('CARD')">
                                        Card Payment
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 14px;">
                                        <input type="radio" name="payMethodSelection" value="SLIP" onclick="togglePaymentMethod('SLIP')">
                                        Upload Payment Slip
                                    </label>
                                </div>
                            </div>

                            <!-- Card Details Section -->
                            <div id="cardPaymentSection">
                                <h3 style="font-size: 15px; margin-bottom: 12px; color: var(--au-muted);">Card Information</h3>
                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label class="form-label">Card Number</label>
                                    <input type="text" id="cardNumber" class="form-control"
                                        placeholder="1234 5678 1234 5678" maxlength="19" autocomplete="cc-number" inputmode="numeric">
                                    <small id="cardNumberError" style="color:#e55353; display:none; font-size:12px; margin-top:4px;"></small>
                                </div>
                                <div style="display: flex; gap: 16px; margin-bottom: 24px;">
                                    <div class="form-group" style="flex: 1;">
                                        <label class="form-label">Expiry Date</label>
                                        <input type="text" id="cardExpiry" class="form-control" placeholder="MM/YY"
                                            maxlength="5" autocomplete="cc-exp" inputmode="numeric">
                                        <small id="cardExpiryError" style="color:#e55353; display:none; font-size:12px; margin-top:4px;"></small>
                                    </div>
                                    <div class="form-group" style="flex: 1;">
                                        <label class="form-label">CVV</label>
                                        <input type="password" id="cardCvv" class="form-control" placeholder="123"
                                            maxlength="4" autocomplete="cc-csc" inputmode="numeric">
                                        <small id="cardCvvError" style="color:#e55353; display:none; font-size:12px; margin-top:4px;"></small>
                                    </div>
                                </div>
                                
                                <div style="background: var(--au-surface); border: 1px solid var(--au-line); border-radius: 4px; padding: 16px; margin-bottom: 24px; display: flex; align-items: flex-start; gap: 12px; transition: all 0.3s; cursor: pointer;" 
                                     onmouseover="this.style.borderColor='#2bb3e6'; this.style.background='#fdfaf4';" 
                                     onmouseout="this.style.borderColor='#e3e9ee'; this.style.background='#ffffff';"
                                     onclick="document.getElementById('saveCard').click();">
                                    <input type="checkbox" name="saveCard" id="saveCard" value="true" 
                                           style="width: 20px; height: 20px; margin-top: 2px; accent-color: #2bb3e6; cursor: pointer;"
                                           onclick="event.stopPropagation();">
                                    <div style="flex: 1;">
                                        <span style="display: block; font-size: 14px; font-weight: 700; color: var(--au-text);">Save card for future use</span>
                                        <span style="display: block; font-size: 12px; color: var(--au-muted); margin-top: 3px; line-height: 1.4;">Your details will be securely saved in your dashboard for faster checkout next time.</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Slip Upload Section -->
                            <div id="slipUploadSection" style="display: none;">
                                <h3 style="font-size: 15px; margin-bottom: 12px; color: var(--au-muted);">Payment Slip Upload</h3>
                                <div class="form-group" style="margin-bottom: 24px;">
                                    <label class="form-label">Upload your bank deposit slip (JPG, PNG, PDF) <span class="required">*</span></label>
                                    <input type="file" name="paymentSlip" id="paymentSlip" class="form-control" accept=".jpg,.jpeg,.png,.pdf">
                                    <span class="help-text">Please ensure the transaction details (date, amount, reference) are clearly visible.</span>
                                </div>
                            </div>

                            <button type="button" class="btn btn-primary" id="payNowBtn"
                                style="width: 100%; justify-content: center;" onclick="processPayment()">
                                Confirm & Pay
                            </button>
                        </div>
                    </div>
                </div>
            </form>

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

                        function validateBookingForm() {
                            const guestName = document.querySelector('input[name="guestName"]').value.trim();
                            const contact = document.querySelector('input[name="contactDetails"]').value.trim();
                            const roomId = document.querySelector('select[name="roomId"]').value;
                            const checkIn = document.getElementById('checkInInput').value;
                            const checkOut = document.getElementById('checkOutInput').value;
                            const guests = parseInt(document.querySelector('input[name="numberOfGuests"]').value || '0', 10);

                            if (!guestName || !contact || !roomId || !checkIn || !checkOut || guests <= 0) {
                                alert('Please fill in all required fields and ensure number of guests is at least 1.');
                                return false;
                            }

                            const checkInDate = new Date(checkIn);
                            const checkOutDate = new Date(checkOut);
                            const today = new Date();
                            today.setHours(0, 0, 0, 0);

                            if (checkInDate < today) {
                                alert('Check-in date cannot be in the past.');
                                return false;
                            }
                            if (checkOutDate <= checkInDate) {
                                alert('Check-out date must be after check-in date.');
                                return false;
                            }
                            return true;
                        }

                        function handleFormSubmit(event) {
                            event.preventDefault();
                            if (validateBookingForm()) {
                                document.getElementById('paymentModal').style.display = 'flex';
                            }
                            return false;
                        }

                        function closePaymentModal() {
                            document.getElementById('paymentModal').style.display = 'none';
                            document.getElementById('cardNumber').value = '';
                            document.getElementById('cardExpiry').value = '';
                            document.getElementById('cardCvv').value = '';
                        }

                        function togglePaymentMethod(method) {
                            const cardSection = document.getElementById('cardPaymentSection');
                            const slipSection = document.getElementById('slipUploadSection');
                            const hiddenMethod = document.getElementById('hiddenPaymentMethod');
                            const payBtn = document.getElementById('payNowBtn');

                            hiddenMethod.value = method;

                            if (method === 'CARD') {
                                cardSection.style.display = 'block';
                                slipSection.style.display = 'none';
                                payBtn.innerText = 'Pay Now';
                            } else {
                                cardSection.style.display = 'none';
                                slipSection.style.display = 'block';
                                payBtn.innerText = 'Submit Slip';
                            }
                        }

                        function processPayment() {
                            const paymentMethod = document.getElementById('hiddenPaymentMethod').value;
                            const address = document.getElementById('paymentAddress').value.trim();
                            const addressError = document.getElementById('addressError');
                            const successMsg = document.getElementById('paymentSuccessMessage');
                            const bookingForm = document.getElementById('bookingForm');

                            let isValid = true;

                            if (!address) {
                                addressError.style.display = 'block';
                                isValid = false;
                            } else {
                                addressError.style.display = 'none';
                            }

                            if (!isValid) return;

                            if (paymentMethod === 'CARD') {
                                const cardNumber = document.getElementById('cardNumber').value.replace(/\s+/g, '');
                                const cardExpiry = document.getElementById('cardExpiry').value.trim();
                                const cardCvv = document.getElementById('cardCvv').value.trim();

                                // Clear all inline errors first
                                ['cardNumberError','cardExpiryError','cardCvvError'].forEach(id => {
                                    const el = document.getElementById(id);
                                    if (el) { el.style.display = 'none'; el.textContent = ''; }
                                });
                                ['cardNumber','cardExpiry','cardCvv'].forEach(id => {
                                    const el = document.getElementById(id);
                                    if (el) el.style.borderColor = '';
                                });

                                let cardValid = true;

                                // --- Card Number: exactly 16 digits ---
                                if (!/^\d{16}$/.test(cardNumber)) {
                                    const err = document.getElementById('cardNumberError');
                                    err.textContent = 'Card number must be exactly 16 digits.';
                                    err.style.display = 'block';
                                    document.getElementById('cardNumber').style.borderColor = '#e55353';
                                    cardValid = false;
                                }

                                // --- Expiry Date: MM/YY format, valid month, future date ---
                                const expiryPattern = /^(0[1-9]|1[0-2])\/([0-9]{2})$/;
                                if (!expiryPattern.test(cardExpiry)) {
                                    const err = document.getElementById('cardExpiryError');
                                    err.textContent = 'Enter expiry in MM/YY format (e.g. 08/27).';
                                    err.style.display = 'block';
                                    document.getElementById('cardExpiry').style.borderColor = '#e55353';
                                    cardValid = false;
                                } else {
                                    const parts = cardExpiry.split('/');
                                    const expMonth = parseInt(parts[0], 10);
                                    const expYear = parseInt('20' + parts[1], 10);
                                    const now = new Date();
                                    const currentYear = now.getFullYear();
                                    const currentMonth = now.getMonth() + 1; // 1-indexed
                                    const isExpired = (expYear < currentYear) || (expYear === currentYear && expMonth < currentMonth);
                                    if (isExpired) {
                                        const err = document.getElementById('cardExpiryError');
                                        err.textContent = 'Your card has expired. Please use a valid card.';
                                        err.style.display = 'block';
                                        document.getElementById('cardExpiry').style.borderColor = '#e55353';
                                        cardValid = false;
                                    }
                                }

                                // --- CVV: 3 or 4 digits only ---
                                if (!/^\d{3,4}$/.test(cardCvv)) {
                                    const err = document.getElementById('cardCvvError');
                                    err.textContent = 'CVV must be 3 or 4 digits.';
                                    err.style.display = 'block';
                                    document.getElementById('cardCvv').style.borderColor = '#e55353';
                                    cardValid = false;
                                }

                                if (cardValid) {
                                    document.getElementById('hiddenCardNumber').value = cardNumber;
                                    document.getElementById('hiddenCardExpiry').value = cardExpiry;
                                    completePaymentProcess();
                                }
                            } else {
                                // Slip Upload
                                const slipFile = document.getElementById('paymentSlip').files[0];
                                if (!slipFile) {
                                    alert('Please upload a copy of your payment slip.');
                                    return;
                                }
                                completePaymentProcess();
                            }
                        }

                        function completePaymentProcess() {
                            document.getElementById('paymentFormBody').style.display = 'none';
                            const successMsg = document.getElementById('paymentSuccessMessage');
                            successMsg.style.display = 'flex';
                            successMsg.innerText = "Processing payment... Please wait.";

                            // Wait 1.5 seconds before submitting
                            setTimeout(function () {
                                document.getElementById('bookingForm').submit();
                            }, 1500);
                        }

                        // Auto-format card number with spaces + digits only
                        document.getElementById('cardNumber').addEventListener('input', function (e) {
                            let value = e.target.value.replace(/\D/g, ''); // strip non-digits
                            let formatted = '';
                            for (let i = 0; i < value.length; i++) {
                                if (i > 0 && i % 4 === 0) formatted += ' ';
                                formatted += value[i];
                            }
                            e.target.value = formatted;
                            // Clear error on user input
                            const err = document.getElementById('cardNumberError');
                            if (err) { err.style.display = 'none'; }
                            e.target.style.borderColor = '';
                        });

                        // Expiry: auto-format MM/YY, digits only, block invalid months
                        document.getElementById('cardExpiry').addEventListener('input', function (e) {
                            let value = e.target.value.replace(/\D/g, ''); // strip non-digits
                            if (value.length > 4) value = value.slice(0, 4);
                            // First two chars = month (01-12)
                            if (value.length >= 2) {
                                let month = parseInt(value.slice(0, 2), 10);
                                if (month > 12) month = 12;
                                if (month < 1 && value.length === 2) month = 1;
                                value = String(month).padStart(2, '0') + value.slice(2);
                                e.target.value = value.slice(0, 2) + (value.length > 2 ? '/' + value.slice(2) : '');
                            } else {
                                e.target.value = value;
                            }
                            // Clear error on user input
                            const err = document.getElementById('cardExpiryError');
                            if (err) { err.style.display = 'none'; }
                            e.target.style.borderColor = '';
                        });

                        // CVV: digits only, 3-4 chars
                        document.getElementById('cardCvv').addEventListener('input', function (e) {
                            e.target.value = e.target.value.replace(/\D/g, '').slice(0, 4);
                            // Clear error on user input
                            const err = document.getElementById('cardCvvError');
                            if (err) { err.style.display = 'none'; }
                            e.target.style.borderColor = '';
                        });

                        // Block non-numeric keystrokes on CVV (also blocks paste of letters)
                        document.getElementById('cardCvv').addEventListener('keypress', function (e) {
                            if (!/[0-9]/.test(e.key)) e.preventDefault();
                        });

                        function filterPackages() {
                            const roomSelect = document.querySelector('select[name="roomId"]');
                            const packageSelect = document.querySelector('select[name="packageId"]');
                            const selectedRoom = roomSelect.options[roomSelect.selectedIndex];
                            const selectedRoomType = selectedRoom ? selectedRoom.getAttribute('data-room-type') : '';
                            
                            // Reset package selection if current one is not applicable
                            let stillValid = false;
                            
                            for (let i = 0; i < packageSelect.options.length; i++) {
                                const option = packageSelect.options[i];
                                const applicableType = option.getAttribute('data-applicable-room-type');
                                
                                if (!applicableType || applicableType === "" || applicableType.toLowerCase() === selectedRoomType.toLowerCase()) {
                                    option.style.display = 'block';
                                    if (packageSelect.value === option.value && option.value !== "") {
                                        stillValid = true;
                                    }
                                } else {
                                    option.style.display = 'none';
                                }
                            }
                            
                            if (!stillValid && packageSelect.value !== "") {
                                packageSelect.value = "";
                            }
                        }

                        document.addEventListener('DOMContentLoaded', function() {
                            setMinDates();
                            const roomSelect = document.querySelector('select[name="roomId"]');
                            if (roomSelect) {
                                roomSelect.addEventListener('change', filterPackages);
                                filterPackages(); // Run once on load
                            }
                        });
                    </script>

        </body>

        </html>