<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Dashboard · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

                    <!-- Google Fonts -->
                    <link
                        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                        rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user-dashboard.css">
                <%@ include file="fragments/head-assets.jsp" %>
</head>

                <body>

                    <%@ include file="fragments/navbar.jsp" %>

                        <div class="dashboard-container">
                            <div class="dashboard-header">
                                <h1>My Dashboard</h1>
                                <p>Welcome back, ${sessionScope.user.displayName}! Manage your bookings, payments, and
                                    account details.</p>
                            </div>

                            <!-- Statistics Cards -->
                            <div class="stats-grid">
                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-icon blue">
                                            <i class="ph ph-calendar-check"></i>
                                        </div>
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${totalBookings}</div>
                                            <div class="stat-card-label">Total Bookings</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-icon green">
                                            <i class="ph ph-check-circle"></i>
                                        </div>
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${completedBookings}</div>
                                            <div class="stat-card-label">Completed</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-icon orange">
                                            <i class="ph ph-clock"></i>
                                        </div>
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${upcomingBookings.size()}</div>
                                            <div class="stat-card-label">Upcoming</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-icon purple">
                                            <i class="ph ph-currency-dollar"></i>
                                        </div>
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">
                                                <c:choose>
                                                    <c:when test="${not empty totalSpent}">
                                                        <fmt:formatNumber value="${totalSpent}" type="currency"
                                                            currencySymbol="$" maxFractionDigits="2" />
                                                    </c:when>
                                                    <c:otherwise>$0.00</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="stat-card-label">Total Spent</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${sessionScope.user.role == 'EMPLOYEE'}">
                                <div class="section"
                                    style="background: linear-gradient(135deg, #ffffff 0%, #eef7fc 100%); border-color: #d6e6f0;">
                                    <div class="section-header" style="border-bottom-color: #d6e6f0;">
                                        <h2 class="section-title">
                                            <i class="ph ph-briefcase"></i>
                                            Staff Portal
                                        </h2>
                                    </div>

                                    <div class="management-grid">
                                        <a href="${pageContext.request.contextPath}/rooms/admin/management"
                                            class="management-card">
                                            <div class="management-card-icon"
                                                style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                                                <i class="ph ph-door-open"></i>
                                            </div>
                                            <h3>Room Management</h3>
                                            <p>Manage hotel rooms, availability, pricing, and maintenance schedules.</p>
                                            <div class="management-card-arrow">
                                                <span>Manage Rooms</span>
                                                <i class="ph ph-arrow-right"></i>
                                            </div>
                                        </a>

                                        <a href="${pageContext.request.contextPath}/admin/checkin"
                                            class="management-card">
                                            <div class="management-card-icon"
                                                style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                                                <i class="ph ph-sign-in"></i>
                                            </div>
                                            <h3>Check-In</h3>
                                            <p>Perform digital check-in. Verify identity and record check-in time.</p>
                                            <div class="management-card-arrow">
                                                <span>Digital Check-In</span>
                                                <i class="ph ph-arrow-right"></i>
                                            </div>
                                        </a>

                                        <a href="${pageContext.request.contextPath}/admin/checkout"
                                            class="management-card">
                                            <div class="management-card-icon"
                                                style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                                                <i class="ph ph-sign-out"></i>
                                            </div>
                                            <h3>Check-Out</h3>
                                            <p>Register check-outs, view stay duration, and add additional charges.</p>
                                            <div class="management-card-arrow">
                                                <span>Digital Check-Out</span>
                                                <i class="ph ph-arrow-right"></i>
                                            </div>
                                        </a>

                                        <a href="${pageContext.request.contextPath}/admin/billing"
                                            class="management-card">
                                            <div class="management-card-icon"
                                                style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                                                <i class="ph ph-receipt"></i>
                                            </div>
                                            <h3>Billing &amp; Payments</h3>
                                            <p>Generate bills for stays, process payments, apply discounts and taxes.
                                            </p>
                                            <div class="management-card-arrow">
                                                <span>Billing</span>
                                                <i class="ph ph-arrow-right"></i>
                                            </div>
                                        </a>

                                        <a href="${pageContext.request.contextPath}/admin/reports"
                                            class="management-card">
                                            <div class="management-card-icon"
                                                style="background: linear-gradient(135deg, #2bb3e6 0%, #0e4d6e 100%);">
                                                <i class="ph ph-chart-line"></i>
                                            </div>
                                            <h3>Reports &amp; Dashboard</h3>
                                            <p>View daily revenue, total bookings, outstanding payments, and more.</p>
                                            <div class="management-card-arrow">
                                                <span>Reports</span>
                                                <i class="ph ph-arrow-right"></i>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        </div>

                        </div>

                        <!-- Bookings Section -->
                        <div class="section">
                            <div class="section-header">
                                <h2 class="section-title">
                                    <i class="ph ph-bed"></i>
                                    Booking History
                                </h2>
                            </div>

                            <div class="tabs">
                                <button class="tab active" onclick="showTab('all-bookings')">All Bookings</button>
                                <button class="tab" onclick="showTab('upcoming-bookings')">Upcoming</button>
                                <button class="tab" onclick="showTab('past-bookings')">Past</button>
                            </div>

                            <!-- All Bookings -->
                            <div id="all-bookings" class="tab-content active">
                                <c:choose>
                                    <c:when test="${not empty bookings}">
                                        <c:forEach var="booking" items="${bookings}">
                                            <div class="booking-card">
                                                <div class="booking-header">
                                                    <span class="booking-id">Booking #${booking.id}</span>
                                                    <span
                                                        class="status-badge ${fn:toLowerCase(booking.status)}">${booking.status}</span>
                                                </div>
                                                <div class="booking-details">
                                                    <div class="detail-item">
                                                        <span class="detail-label">Room</span>
                                                        <span class="detail-value">${booking.room.roomNumber} -
                                                            ${booking.room.roomType}</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Check-In</span>
                                                        <span class="detail-value">
                                                            <c:choose>
                                                                <c:when test="${not empty booking.checkInDate}">
                                                                    <c:out value="${fn:substring(booking.checkInDate.toString().replace('T', ' '), 0, 10)}" />
                                                                </c:when>
                                                                <c:otherwise>N/A</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Check-Out</span>
                                                        <span class="detail-value">
                                                            <c:choose>
                                                                <c:when test="${not empty booking.checkOutDate}">
                                                                    <c:out value="${fn:substring(booking.checkOutDate.toString().replace('T', ' '), 0, 10)}" />
                                                                </c:when>
                                                                <c:otherwise>N/A</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Guests</span>
                                                        <span class="detail-value">${booking.numberOfGuests}
                                                            Guest(s)</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Nights</span>
                                                        <span class="detail-value">${booking.numberOfNights}
                                                            Night(s)</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Total Amount</span>
                                                        <span class="booking-amount">
                                                            <fmt:formatNumber value="${booking.totalAmount}"
                                                                type="currency" currencySymbol="$"
                                                                maxFractionDigits="2" />
                                                        </span>
                                                    </div>
                                                </div>
                                                <c:if test="${not empty booking.specialRequests}">
                                                    <div
                                                        style="margin-top: 12px; padding-top: 12px; border-top: 1px solid #dce9f1;">
                                                        <span class="detail-label">Special Requests:</span>
                                                        <p style="margin-top: 4px; color: var(--au-text);">
                                                            ${booking.specialRequests}</p>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="ph ph-calendar-x"></i>
                                            <h3>No Bookings Yet</h3>
                                            <p>You haven't made any bookings yet. Start exploring our rooms!</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Upcoming Bookings -->
                            <div id="upcoming-bookings" class="tab-content">
                                <c:choose>
                                    <c:when test="${not empty upcomingBookings}">
                                        <c:forEach var="booking" items="${upcomingBookings}">
                                            <div class="booking-card">
                                                <div class="booking-header">
                                                    <span class="booking-id">Booking #${booking.id}</span>
                                                    <span
                                                        class="status-badge ${fn:toLowerCase(booking.status)}">${booking.status}</span>
                                                </div>
                                                <div class="booking-details">
                                                    <div class="detail-item">
                                                        <span class="detail-label">Room</span>
                                                        <span class="detail-value">${booking.room.roomNumber} -
                                                            ${booking.room.roomType}</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Check-In</span>
                                                        <span class="detail-value">
                                                            <c:choose>
                                                                <c:when test="${not empty booking.checkInDate}">
                                                                    <c:out value="${fn:substring(booking.checkInDate.toString().replace('T', ' '), 0, 10)}" />
                                                                </c:when>
                                                                <c:otherwise>N/A</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Check-Out</span>
                                                        <span class="detail-value">
                                                            <c:choose>
                                                                <c:when test="${not empty booking.checkOutDate}">
                                                                    <c:out value="${fn:substring(booking.checkOutDate.toString().replace('T', ' '), 0, 10)}" />
                                                                </c:when>
                                                                <c:otherwise>N/A</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Total Amount</span>
                                                        <span class="booking-amount">
                                                            <fmt:formatNumber value="${booking.totalAmount}"
                                                                type="currency" currencySymbol="$"
                                                                maxFractionDigits="2" />
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="ph ph-calendar-check"></i>
                                            <h3>No Upcoming Bookings</h3>
                                            <p>You don't have any upcoming bookings at the moment.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Past Bookings -->
                            <div id="past-bookings" class="tab-content">
                                <c:choose>
                                    <c:when test="${not empty pastBookings}">
                                        <c:forEach var="booking" items="${pastBookings}">
                                            <div class="booking-card">
                                                <div class="booking-header">
                                                    <span class="booking-id">Booking #${booking.id}</span>
                                                    <span
                                                        class="status-badge ${fn:toLowerCase(booking.status)}">${booking.status}</span>
                                                </div>
                                                <div class="booking-details">
                                                    <div class="detail-item">
                                                        <span class="detail-label">Room</span>
                                                        <span class="detail-value">${booking.room.roomNumber} -
                                                            ${booking.room.roomType}</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Check-In</span>
                                                        <span class="detail-value">
                                                            <c:choose>
                                                                <c:when test="${not empty booking.checkInDate}">
                                                                    <c:out value="${fn:substring(booking.checkInDate.toString().replace('T', ' '), 0, 10)}" />
                                                                </c:when>
                                                                <c:otherwise>N/A</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Check-Out</span>
                                                        <span class="detail-value">
                                                            <c:choose>
                                                                <c:when test="${not empty booking.checkOutDate}">
                                                                    <c:out value="${fn:substring(booking.checkOutDate.toString().replace('T', ' '), 0, 10)}" />
                                                                </c:when>
                                                                <c:otherwise>N/A</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Total Amount</span>
                                                        <span class="booking-amount">
                                                            <fmt:formatNumber value="${booking.totalAmount}"
                                                                type="currency" currencySymbol="$"
                                                                maxFractionDigits="2" />
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="ph ph-clock-counter-clockwise"></i>
                                            <h3>No Past Bookings</h3>
                                            <p>You don't have any past bookings yet.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Payment History Section -->
                        <div class="section">
                            <div class="section-header">
                                <h2 class="section-title">
                                    <i class="ph ph-credit-card"></i>
                                    Payment History
                                </h2>
                            </div>

                            <c:choose>
                                <c:when test="${not empty payments}">
                                    <c:forEach var="payment" items="${payments}">
                                        <div class="payment-card">
                                            <div class="payment-header">
                                                <div>
                                                    <span class="payment-id">Payment #${payment.id}</span>
                                                    <c:if test="${not empty payment.transactionId}">
                                                        <span
                                                            style="font-size: 12px; color: var(--au-muted); margin-left: 8px;">
                                                            Transaction: ${payment.transactionId}
                                                        </span>
                                                    </c:if>
                                                </div>
                                                <span
                                                    class="status-badge ${fn:toLowerCase(payment.status)}">${payment.status}</span>
                                            </div>
                                            <div class="booking-details">
                                                <div class="detail-item">
                                                    <span class="detail-label">Amount</span>
                                                    <span class="booking-amount">
                                                        <fmt:formatNumber value="${payment.amount}" type="currency"
                                                            currencySymbol="$" maxFractionDigits="2" />
                                                    </span>
                                                </div>
                                                <div class="detail-item">
                                                    <span class="detail-label">Payment Method</span>
                                                    <div class="payment-method">
                                                        <i class="ph ph-credit-card"></i>
                                                        <span>${payment.paymentMethod}</span>
                                                    </div>
                                                </div>
                                                <div class="detail-item">
                                                    <span class="detail-label">Payment Date</span>
                                                    <span class="detail-value">
                                                        <c:out value="${fn:substring(payment.paymentDate.toString().replace('T', ' '), 0, 16)}" />
                                                    </span>
                                                </div>
                                                <div class="detail-item">
                                                    <span class="detail-label">Booking Reference</span>
                                                    <span class="detail-value">#${payment.booking.id}</span>
                                                </div>
                                            </div>
                                            <c:if test="${not empty payment.notes}">
                                                <div
                                                    style="margin-top: 12px; padding-top: 12px; border-top: 1px solid #dce9f1;">
                                                    <span class="detail-label">Notes:</span>
                                                    <p style="margin-top: 4px; color: var(--au-text);">${payment.notes}</p>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="ph ph-receipt"></i>
                                        <h3>No Payment History</h3>
                                        <p>You haven't made any payments yet.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Card Details Section -->
                        <div class="section">
                            <div class="section-header">
                                <h2 class="section-title">
                                    <i class="ph ph-wallet"></i>
                                    Saved Cards
                                </h2>
                            </div>

                            <c:choose>
                                <c:when test="${not empty cards}">
                                    <c:forEach var="card" items="${cards}">
                                        <div class="card-item">
                                            <div class="card-header">
                                                <span class="card-type-badge">${card.cardType}</span>
                                                <c:if test="${card.isDefault}">
                                                    <span class="card-default-badge">Default</span>
                                                </c:if>
                                            </div>
                                            <div class="card-number">${card.maskedCardNumber}</div>
                                            <div class="card-info">
                                                <div>
                                                    <span class="detail-label">Cardholder Name</span>
                                                    <span class="detail-value">${card.cardHolderName}</span>
                                                </div>
                                                <div>
                                                    <span class="detail-label">Expires</span>
                                                    <span class="detail-value">${card.expiryDate}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="ph ph-credit-card"></i>
                                        <h3>No Saved Cards</h3>
                                        <p>You haven't saved any payment cards yet. Add a card for faster checkout!
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        </div>

                        <%@ include file="fragments/footer.jsp" %>

                            <script>
                                function showTab(tabId) {
                                    // Hide all tab contents
                                    document.querySelectorAll('.tab-content').forEach(content => {
                                        content.classList.remove('active');
                                    });

                                    // Remove active class from all tabs
                                    document.querySelectorAll('.tab').forEach(tab => {
                                        tab.classList.remove('active');
                                    });

                                    // Show selected tab content
                                    document.getElementById(tabId).classList.add('active');

                                    // Add active class to clicked tab
                                    event.target.classList.add('active');
                                }
                            </script>

                </body>

                </html>