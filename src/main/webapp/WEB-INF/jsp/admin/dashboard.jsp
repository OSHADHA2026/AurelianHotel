<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Admin Dashboard · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

                    <!-- Google Fonts -->
                    <link
                        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                        rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/dashboard.css">
                <%@ include file="../fragments/head-assets.jsp" %>
</head>

                <body>

                    <%@ include file="../fragments/navbar.jsp" %>

                        <div class="admin-container">
                            <div class="admin-header">
                                <h1><i class="ph ph-gauge"></i> Admin Dashboard</h1>
                                <p>Manage your hotel operations, users, and resources</p>
                            </div>

                            <!-- Welcome Section -->
                            <div class="welcome-section">
                                <h2>Welcome back, ${sessionScope.user.displayName}!</h2>
                                <p>You're logged in as an Administrator. Use the management tools below to oversee hotel
                                    operations, manage user accounts, and configure room settings.</p>
                            </div>

                            <!-- Statistics - User Stats -->
                            <div class="stats-grid">
                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${not empty totalBookings ? totalBookings : 0}</div>
                                            <div class="stat-card-label">Total Bookings</div>
                                        </div>
                                        <div class="stat-card-icon blue">
                                            <i class="ph ph-calendar-check"></i>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${not empty completedBookings ? completedBookings : 0}</div>
                                            <div class="stat-card-label">Completed Stays</div>
                                        </div>
                                        <div class="stat-card-icon green">
                                            <i class="ph ph-check-circle"></i>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${not empty upcomingBookings ? upcomingBookings.size() : 0}</div>
                                            <div class="stat-card-label">Upcoming Arrivals</div>
                                        </div>
                                        <div class="stat-card-icon orange">
                                            <i class="ph ph-clock"></i>
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
                                                <fmt:formatNumber value="${not empty totalRevenue ? totalRevenue : 0}" type="currency"
                                                    currencySymbol="$" maxFractionDigits="2" />
                                            </div>
                                            <div class="stat-card-label">Total Revenue</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Statistics - Admin Stats (Detailed Breakdown) -->
                            <div class="stats-grid">
                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-icon blue">
                                            <i class="ph ph-users"></i>
                                        </div>
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${not empty totalUsers ? totalUsers : 0}</div>
                                            <div class="stat-card-label">Total Platform Users</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-icon green">
                                            <i class="ph ph-user"></i>
                                        </div>
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${not empty guestCount ? guestCount : 0}</div>
                                            <div class="stat-card-label">Registered Guests</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-icon orange">
                                            <i class="ph ph-user-focus"></i>
                                        </div>
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${not empty staffCount ? staffCount : 0}</div>
                                            <div class="stat-card-label">Hotel Staff</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-card">
                                    <div class="stat-card-header">
                                        <div class="stat-card-icon red">
                                            <i class="ph ph-user-gear"></i>
                                        </div>
                                        <div class="stat-card-info">
                                            <div class="stat-card-value">${not empty adminCount ? adminCount : 0}</div>
                                            <div class="stat-card-label">Administrators</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Management Cards -->
                            <div class="management-grid">
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin/users" class="management-card">
                                        <div class="management-card-icon"
                                            style="background: linear-gradient(135deg, #2bb3e6 0%, #0e4d6e 100%);">
                                            <i class="ph ph-users-three"></i>
                                        </div>
                                        <h3>User Management</h3>
                                        <p>Manage guest, staff, and administrator accounts. Create, edit, delete users, and
                                            modify user roles and permissions.</p>
                                        <div class="management-card-arrow">
                                            <span>Manage Users</span>
                                            <i class="ph ph-arrow-right"></i>
                                        </div>
                                    </a>
                                </c:if>

                                <a href="${pageContext.request.contextPath}/rooms/admin/management"
                                    class="management-card">
                                    <div class="management-card-icon"
                                        style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                                        <i class="ph ph-door-open"></i>
                                    </div>
                                    <h3>Room Management</h3>
                                    <p>Manage hotel rooms, availability, pricing, and maintenance schedules. Create new
                                        rooms and update existing room information.</p>
                                    <div class="management-card-arrow">
                                        <span>Manage Rooms</span>
                                        <i class="ph ph-arrow-right"></i>
                                    </div>
                                </a>

                                <a href="${pageContext.request.contextPath}/admin/room-packages" class="management-card">
                                    <div class="management-card-icon"
                                        style="background: linear-gradient(135deg, #2bb3e6 0%, #1590c4 100%);">
                                        <i class="ph ph-package"></i>
                                    </div>
                                    <h3>Package Management</h3>
                                    <p>Configure room packages, discounts, and special offers. Define guest limits, 
                                       minimum stay requirements, and member benefits.</p>
                                    <div class="management-card-arrow">
                                        <span>Manage Packages</span>
                                        <i class="ph ph-arrow-right"></i>
                                    </div>
                                </a>

                                <a href="${pageContext.request.contextPath}/admin/checkin" class="management-card">
                                    <div class="management-card-icon"
                                        style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                                        <i class="ph ph-sign-in"></i>
                                    </div>
                                    <h3>Check-In</h3>
                                    <p>Perform digital check-in for guests. Verify identity (ID/Passport), record
                                        check-in time, and add special requests.</p>
                                    <div class="management-card-arrow">
                                        <span>Digital Check-In</span>
                                        <i class="ph ph-arrow-right"></i>
                                    </div>
                                </a>

                                <a href="${pageContext.request.contextPath}/admin/checkout" class="management-card">
                                    <div class="management-card-icon"
                                        style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                                        <i class="ph ph-sign-out"></i>
                                    </div>
                                    <h3>Check-Out</h3>
                                    <p>Perform digital check-out. Record check-out time, view stay duration, and add any
                                        additional charges.</p>
                                    <div class="management-card-arrow">
                                        <span>Digital Check-Out</span>
                                        <i class="ph ph-arrow-right"></i>
                                    </div>
                                </a>

                                <a href="${pageContext.request.contextPath}/admin/billing" class="management-card">
                                    <div class="management-card-icon"
                                        style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                                        <i class="ph ph-receipt"></i>
                                    </div>
                                    <h3>Billing &amp; Payments</h3>
                                    <p>Generate bills for completed stays, process payments (Cash / Card / Online),
                                        apply discounts and taxes.</p>
                                    <div class="management-card-arrow">
                                        <span>Billing</span>
                                        <i class="ph ph-arrow-right"></i>
                                    </div>
                                </a>

                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin/trends" class="management-card">
                                        <div class="management-card-icon"
                                            style="background: linear-gradient(135deg, #2bb3e6 0%, #0e4d6e 100%);">
                                            <i class="ph ph-chart-line"></i>
                                        </div>
                                        <h3>Reports &amp; Dashboard</h3>
                                        <p>View daily and monthly revenue, total bookings, outstanding payments, and
                                            financial records.</p>
                                        <div class="management-card-arrow">
                                            <span>Trends</span>
                                            <i class="ph ph-arrow-right"></i>
                                        </div>
                                    </a>
                                </c:if>

                                <a href="${pageContext.request.contextPath}/rooms/admin/history"
                                    class="management-card">
                                    <div class="management-card-icon"
                                        style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                                        <i class="ph ph-clock-counter-clockwise"></i>
                                    </div>
                                    <h3>Room History</h3>
                                    <p>Track previous usage of rooms and view past occupancy records. Audit room
                                        performance and stays.</p>
                                    <div class="management-card-arrow">
                                        <span>View History</span>
                                        <i class="ph ph-arrow-right"></i>
                                    </div>
                                </a>

                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin/employee-sessions"
                                        class="management-card">
                                        <div class="management-card-icon"
                                            style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                                            <i class="ph ph-clock-user"></i>
                                        </div>
                                        <h3>Employee Performance</h3>
                                        <p>Track employee login times, session durations, and system usage patterns to
                                            monitor productivity and performance.</p>
                                        <div class="management-card-arrow">
                                            <span>View Sessions</span>
                                            <i class="ph ph-arrow-right"></i>
                                        </div>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/admin/salary-calculator"
                                        class="management-card">
                                        <div class="management-card-icon"
                                            style="background: linear-gradient(135deg, #0e4d6e 0%, #0a2d45 100%);">
                                            <i class="ph ph-hand-coins"></i>
                                        </div>
                                        <h3>Salary Calculation</h3>
                                        <p>Calculate monthly salaries for staff members. Include basic pay, OT hours,
                                            allowances, and deductions.</p>
                                        <div class="management-card-arrow">
                                            <span>Full Calculator</span>
                                            <i class="ph ph-arrow-right"></i>
                                        </div>
                                    </a>
                                </c:if>
                            </div>

                        </div>

                        <!-- Integrated Booking Management Section -->
                        <div class="section" id="booking-management" style="margin-top: 40px; scroll-margin-top: 110px;">
                            <div class="section-header">
                                <h2 class="section-title">
                                    <i class="ph ph-list-checks" style="color: #2bb3e6;"></i>
                                    Booking Management
                                </h2>
                                <div class="section-actions" style="display: flex; gap: 15px; align-items: center;">
                                    <form action="${pageContext.request.contextPath}/admin/dashboard#booking-management" method="GET" style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
                                        <div class="search-box" style="position: relative;">
                                            <input type="text" name="search" value="${search}" placeholder="Search by name, mobile, or ID..."
                                                   style="padding: 10px 15px 10px 40px; border: 1px solid #f2f9fd; border-radius: 3px; width: 280px; font-size: 14px;">
                                            <i class="ph ph-magnifying-glass" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--au-muted);"></i>
                                        </div>
                                        <select name="statusFilter" style="padding: 10px 15px; border: 1px solid #f2f9fd; border-radius: 3px; font-size: 14px; background: var(--au-surface);">
                                            <option value="" ${empty statusFilter ? 'selected' : ''}>All Statuses</option>
                                            <option value="CONFIRMED"   ${statusFilter == 'CONFIRMED'   ? 'selected' : ''}>Confirmed</option>
                                            <option value="CHECKED_IN"  ${statusFilter == 'CHECKED_IN'  ? 'selected' : ''}>Checked In</option>
                                            <option value="COMPLETED"   ${statusFilter == 'COMPLETED'   ? 'selected' : ''}>Completed</option>
                                            <option value="CANCELLED"   ${statusFilter == 'CANCELLED'   ? 'selected' : ''}>Cancelled</option>
                                            <option value="PENDING"     ${statusFilter == 'PENDING'     ? 'selected' : ''}>Pending</option>
                                        </select>
                                        <select name="sortBy" style="padding: 10px 15px; border: 1px solid #f2f9fd; border-radius: 3px; font-size: 14px; background: var(--au-surface);">
                                            <option value="" ${empty sortBy ? 'selected' : ''}>— Sort By —</option>
                                            <option value="date" ${sortBy == 'date' ? 'selected' : ''}>Date</option>
                                            <option value="id"   ${sortBy == 'id'   ? 'selected' : ''}>Booking ID</option>
                                        </select>
                                        <select name="sortDir" style="padding: 10px 15px; border: 1px solid #f2f9fd; border-radius: 3px; font-size: 14px; background: var(--au-surface);">
                                            <option value="" ${empty sortDir ? 'selected' : ''}>— Order —</option>
                                            <option value="DESC" ${sortDir == 'DESC' ? 'selected' : ''}>Newest First</option>
                                            <option value="ASC"  ${sortDir == 'ASC'  ? 'selected' : ''}>Oldest First</option>
                                        </select>
                                        <button type="submit" class="stat-card-icon blue" style="border: none; width: 40px; height: 40px; cursor: pointer; border-radius: 3px; display: flex; align-items: center; justify-content: center; color: white;" title="Apply filters">
                                            <i class="ph ph-funnel"></i>
                                        </button>
                                        <c:if test="${not empty search or not empty statusFilter}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard#booking-management" class="stat-card-icon red" style="width: 40px; height: 40px; border-radius: 3px; display: flex; align-items: center; justify-content: center; color: white; text-decoration: none;" title="Clear filters">
                                                <i class="ph ph-x"></i>
                                            </a>
                                        </c:if>
                                    </form>
                                </div>
                            </div>

                            <div class="table-container" style="background: var(--au-surface); border-radius: 6px; box-shadow: 0 4px 20px rgba(0, 0, 0,0.05); overflow: hidden; margin-top: 20px;">
                                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <thead style="background: var(--au-surface); border-bottom: 2px solid #f2f9fd;">
                                        <tr>
                                            <th style="padding: 18px 24px; color: var(--au-text); font-weight: 700; font-size: 14px;">Booking ID</th>
                                            <th style="padding: 18px 24px; color: var(--au-text); font-weight: 700; font-size: 14px;">Guest Name</th>
                                            <th style="padding: 18px 24px; color: var(--au-text); font-weight: 700; font-size: 14px;">Room Type</th>
                                            <th style="padding: 18px 24px; color: var(--au-text); font-weight: 700; font-size: 14px;">Stay Dates</th>
                                            <th style="padding: 18px 24px; color: var(--au-text); font-weight: 700; font-size: 14px;">Total Price</th>
                                            <th style="padding: 18px 24px; color: var(--au-text); font-weight: 700; font-size: 14px;">Status</th>
                                            <th style="padding: 18px 24px; color: var(--au-text); font-weight: 700; font-size: 14px; text-align: center;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody style="color: var(--au-text); font-size: 14px;">
                                        <c:choose>
                                            <c:when test="${not empty allBookings}">
                                                <c:forEach var="booking" items="${allBookings}">
                                                    <tr style="border-bottom: 1px solid var(--au-line); transition: background 0.2s;" onmouseover="this.style.background='#fefefd'" onmouseout="this.style.background='white'">
                                                        <td style="padding: 18px 24px;">
                                                            <span style="font-weight: 700; color: #2bb3e6;">#${booking.id}</span>
                                                        </td>
                                                        <td style="padding: 18px 24px;">
                                                            <div style="font-weight: 600;">${not empty booking.guestName ? booking.guestName : 'Guest'}</div>
                                                            <div style="font-size: 12px; color: var(--au-muted);">${not empty booking.contactDetails ? booking.contactDetails : '-'}</div>
                                                        </td>
                                                        <td style="padding: 18px 24px;">
                                                            <c:choose>
                                                                <c:when test="${not empty booking.room}">
                                                                    <span style="font-weight: 600; color: var(--au-text);">Room ${booking.room.roomNumber}</span>
                                                                    <div style="font-size: 12px; color: var(--au-muted);">${booking.room.roomType}</div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Unassigned</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td style="padding: 18px 24px;">
                                                            <div style="color: var(--au-text); font-weight: 500;">${booking.checkInFormatted}</div>
                                                            <div style="font-size: 12px; color: var(--au-muted);">to ${booking.checkOutFormatted}</div>
                                                        </td>
                                                        <td style="padding: 18px 24px; font-weight: 700; color: var(--au-text);">
                                                            <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="$" />
                                                        </td>
                                                        <td style="padding: 18px 24px;">
                                                            <span class="status-badge ${fn:toLowerCase(booking.status)}" 
                                                                  style="padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; text-transform: uppercase;">
                                                                ${booking.status}
                                                            </span>
                                                        </td>
                                                        <td style="padding: 18px 24px; text-align: center;">
                                                            <div style="display: flex; gap: 8px; justify-content: center;">
                                                                <a href="${pageContext.request.contextPath}/reservations/${booking.id}" title="View Details"
                                                                   style="width: 34px; height: 34px; border-radius: 2px; background: rgba(43, 179, 230, 0.1); color: #2bb3e6; display: flex; align-items: center; justify-content: center; text-decoration: none;">
                                                                    <i class="ph ph-eye"></i>
                                                                </a>
                                                                 <c:choose>
                                                                     <c:when test="${booking.status != 'CANCELLED' && booking.status != 'COMPLETED' }">
                                                                         <a href="${pageContext.request.contextPath}/reservations/${booking.id}/edit" title="Edit Booking"
                                                                            style="width: 34px; height: 34px; border-radius: 2px; background: rgba(208, 176, 128, 0.1); color: #2bb3e6; display: flex; align-items: center; justify-content: center; text-decoration: none;">
                                                                             <i class="ph ph-pencil-simple-line"></i>
                                                                         </a>
                                                                     </c:when>
                                                                     <c:otherwise>
                                                                         <div title="Edits restricted for ${booking.status}" 
                                                                              style="width: 34px; height: 34px; border-radius: 2px; background: rgba(0, 0, 0,0.03); color: #ccc; display: flex; align-items: center; justify-content: center; cursor: not-allowed;">
                                                                             <i class="ph ph-lock" style="font-size: 12px;"></i>
                                                                         </div>
                                                                     </c:otherwise>
                                                                 </c:choose>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" style="padding: 60px; text-align: center; color: var(--au-muted);">
                                                        <i class="ph ph-magnifying-glass" style="font-size: 40px; opacity: 0.1; display: block; margin-bottom: 20px;"></i>
                                                        No bookings found matching your search criteria.
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>


                        <!-- Pending Verifications Section -->
                        <c:if test="${not empty pendingVerifications}">
                            <div class="section" id="pending-verifications"
                                style="background: #fffcfc; border: 1px solid #ffe8e8; scroll-margin-top: 110px;">
                                <div class="section-header">
                                    <h2 class="section-title">
                                        <i class="ph ph-warning" style="color: #f5576c;"></i>
                                        Action Required: Payment Verifications
                                    </h2>
                                    <span class="badge"
                                        style="background: #f5576c; color: white; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: bold;">
                                        ${pendingVerifications.size()} Slips to Review
                                    </span>
                                </div>
                                <div class="management-grid"
                                    style="grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">
                                    <c:forEach var="p" items="${pendingVerifications}">
                                        <div class="payment-card"
                                            style="border-left: 4px solid #f5576c; background: var(--au-surface); box-shadow: 0 4px 12px rgba(0, 0, 0,0.05);">
                                            <div class="payment-header">
                                                <span class="payment-id">Payment #${p.id}</span>
                                                <span class="status-badge pending">Awaiting Review</span>
                                            </div>
                                            <div style="margin: 12px 0;">
                                                <p style="margin: 0; font-weight: 700; color: var(--au-text);">
                                                     Guest: ${not empty p.booking ? p.booking.guestName : 'Unknown Guest'}
                                                 </p>
                                                 <div
                                                     style="display: flex; justify-content: space-between; font-size: 13px; color: var(--au-muted);">
                                                     <span>Booking #${not empty p.booking ? p.booking.id : 'N/A'}</span>
                                                     <span>Amount: 
                                                         <fmt:formatNumber value="${p.amount}" type="currency" currencySymbol="$" />
                                                     </span>
                                                 </div>
                                            </div>
                                            <div
                                                style="display: flex; gap: 8px; border-top: 1px solid #eef7fc; padding-top: 12px;">
                                                <a href="${pageContext.request.contextPath}/admin/billing/${not empty p.booking ? p.booking.id : ''}"
                                                    class="action-btn"
                                                    style="flex: 1; font-size: 12px; padding: 10px; background: #2bb3e6; color: white; border: none; justify-content: center;">
                                                    <i class="ph ph-checks"></i> Review & Verify
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- Quick Actions -->
                        <div class="quick-actions">
                            <h2>
                                <i class="ph ph-lightning"></i>
                                Quick Actions
                            </h2>
                            <div class="action-buttons">
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin/users/create" class="action-btn">
                                        <i class="ph ph-user-plus"></i>
                                        Create New User
                                    </a>
                                    <a href="${pageContext.request.contextPath}/rooms/admin/create" class="action-btn">
                                        <i class="ph ph-plus-circle"></i>
                                        Add New Room
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/users" class="action-btn">
                                        <i class="ph ph-list-bullets"></i>
                                        View All Users
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/rooms/admin/history" class="action-btn">
                                    <i class="ph ph-clock-counter-clockwise"></i>
                                    Room Occupancy Records
                                </a>
                                <a href="${pageContext.request.contextPath}/rooms/admin/management" class="action-btn">
                                    <i class="ph ph-bed"></i>
                                    View All Rooms
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/checkin" class="action-btn">
                                    <i class="ph ph-sign-in"></i>
                                    Check-In Guest
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/checkout" class="action-btn">
                                    <i class="ph ph-sign-out"></i>
                                    Check-Out Guest
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/billing" class="action-btn">
                                    <i class="ph ph-receipt"></i>
                                    Billing
                                </a>
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin/trends" class="action-btn">
                                        <i class="ph ph-chart-line"></i>
                                        Reports
                                    </a>
                                </c:if>
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
                                <button class="tab active" onclick="showTab('active-stays-tab')">Active Stays</button>
                                <button class="tab" onclick="showTab('confirmed-bookings')">Confirmed (Upcoming)</button>
                                <button class="tab" onclick="showTab('all-history')">All History</button>
                            </div>

                            <!-- Active Stays Tab -->
                            <div id="active-stays-tab" class="tab-content active">
                                <c:choose>
                                    <c:when test="${not empty activeStays}">
                                        <c:forEach var="booking" items="${activeStays}">
                                            <div class="booking-card">
                                                <div class="booking-header">
                                                    <span class="booking-id">Booking #${booking.id} - ${booking.guestName}</span>
                                                    <span class="status-badge ${fn:toLowerCase(booking.status)}">${booking.status}</span>
                                                </div>
                                                <div class="booking-details">
                                                    <div class="detail-item">
                                                        <span class="detail-label">Room</span>
                                                        <span class="detail-value">${booking.room.roomNumber} (${booking.room.roomType})</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Actual Check-In</span>
                                                        <span class="detail-value">${booking.getActualCheckInFormatted()}</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Remaining Nights</span>
                                                        <span class="detail-value">${booking.numberOfNights} Night(s)</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Action</span>
                                                        <a href="${pageContext.request.contextPath}/admin/checkout?bookingId=${booking.id}" class="action-btn" style="padding: 6px 12px; font-size: 12px;">
                                                            <i class="ph ph-sign-out"></i> Process Check-Out
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="ph ph-bed"></i>
                                            <h3>No Active Stays</h3>
                                            <p>There are no guests currently checked in to the hotel.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Confirmed Bookings Tab -->
                            <div id="confirmed-bookings" class="tab-content">
                                <c:choose>
                                    <c:when test="${not empty bookings}">
                                        <c:forEach var="booking" items="${bookings}">
                                            <div class="booking-card">
                                                <div class="booking-header">
                                                    <span class="booking-id">Booking #${booking.id} - ${booking.guestName}</span>
                                                    <span class="status-badge ${fn:toLowerCase(booking.status)}">${booking.status}</span>
                                                </div>
                                                <div class="booking-details">
                                                    <div class="detail-item">
                                                        <span class="detail-label">Room</span>
                                                        <span class="detail-value">${booking.room.roomNumber}</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Scheduled Check-In</span>
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
                                                        <span class="detail-label">Action</span>
                                                        <a href="${pageContext.request.contextPath}/admin/checkin?bookingId=${booking.id}" class="action-btn" style="padding: 6px 12px; font-size: 12px; background: #11998e; border-color: #11998e; color: white;">
                                                            <i class="ph ph-sign-in"></i> Process Check-In
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="ph ph-calendar-check"></i>
                                            <h3>No Upcoming Bookings</h3>
                                            <p>There are no confirmed reservations waiting for check-in.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <!-- All History Tab -->
                            <div id="all-history" class="tab-content">
                                <c:choose>
                                    <c:when test="${not empty pastBookings}">
                                        <c:forEach var="booking" items="${pastBookings}">
                                            <div class="booking-card">
                                                <div class="booking-header">
                                                    <span class="booking-id">Booking #${booking.id}</span>
                                                    <span class="status-badge ${booking.status.toLowerCase()}">${booking.status}</span>
                                                </div>
                                                <div class="booking-details">
                                                    <div class="detail-item">
                                                        <span class="detail-label">Guest</span>
                                                        <span class="detail-value">${booking.guestName}</span>
                                                    </div>
                                                    <div class="detail-item">
                                                        <span class="detail-label">Checkout Date</span>
                                                        <span class="detail-value">
                                                            <c:choose>
                                                                <c:when test="${not empty booking.actualCheckOutDateTime}">
                                                                    <c:out value="${fn:substring(booking.actualCheckOutDateTime.toString().replace('T', ' '), 0, 10)}" />
                                                                </c:when>
                                                                <c:when test="${not empty booking.checkOutDate}">
                                                                    <c:out value="${fn:substring(booking.checkOutDate.toString().replace('T', ' '), 0, 10)}" />
                                                                </c:when>
                                                                <c:otherwise>N/A</c:otherwise>
                                                            </c:choose>
                                                        </span>

                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="ph ph-clock-counter-clockwise"></i>
                                            <h3>No Past History</h3>
                                            <p>No completed stays found in the system records.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>                        </div>

                        <%@ include file="../fragments/footer.jsp" %>

                            <script>
                                function showTab(tabId) {
                                    document.querySelectorAll('.tab-content').forEach(content => {
                                        content.classList.remove('active');
                                    });

                                    document.querySelectorAll('.tab').forEach(tab => {
                                        tab.classList.remove('active');
                                    });

                                    document.getElementById(tabId).classList.add('active');
                                    
                                    if (event) {
                                        event.currentTarget.classList.add('active');
                                    }
                                }
                            </script>

                </body>

                </html>
>
