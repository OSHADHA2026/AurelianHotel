<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice #${booking.id} · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/invoice.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>
    <div class="no-print" style="max-width: 800px; margin: 0 auto 20px; display: flex; justify-content: space-between;">
        <a href="${pageContext.request.contextPath}/admin/billing/${booking.id}" class="btn btn-back"><i class="ph ph-arrow-left"></i> Back to Detail</a>
        <button onclick="window.print()" class="btn btn-print"><i class="ph ph-printer"></i> Print Invoice</button>
    </div>

    <div class="invoice-box">
        <div class="header">
            <div class="hotel-info">
                <h1>Aurelian Hotel</h1>
                <p>123 Luxury Avenue<br>Metropolis, NY 10001<br>T: +1 (234) 567-8900<br>E: stays@aurelianhotel.com</p>
            </div>
            <div class="invoice-title">
                <h2>INVOICE</h2>
                <p>#INV-${booking.id}<br>Date: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMM dd, yyyy" /></p>
                <div class="payment-status ${amountDue <= 0 ? 'status-paid' : 'status-unpaid'}">
                    ${amountDue <= 0 ? 'COMPLETELY PAID' : 'OUTSTANDING BALANCE'}
                </div>
            </div>
        </div>

        <div class="details-grid">
            <div class="details">
                <h3>Billed To</h3>
                <p><strong>${booking.guestName}</strong><br>
                ${booking.contactDetails != null ? booking.contactDetails : booking.user.email}<br>
                Booking ID: #${booking.id}</p>
            </div>
            <div class="details">
                <h3>Stay Details</h3>
                <p>Room: ${booking.room.roomNumber} (${booking.room.roomType})<br>
                Check-In: <c:out value="${not empty booking.checkInDate ? fn:replace(booking.checkInDate, 'T', ' ') : 'N/A'}" /><br>
                Check-Out: <c:out value="${not empty booking.checkOutDate ? fn:replace(booking.checkOutDate, 'T', ' ') : 'N/A'}" /><br>
                Total Stays: ${booking.numberOfNights} Night(s)
                <c:if test="${not empty booking.roomPackage}">
                    <br>Package: ${booking.roomPackage.name}
                </c:if>
                </p>
            </div>
        </div>

        <table class="table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th>Rate</th>
                    <th>Quantity</th>
                    <th style="text-align: right;">Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        Accommodation · Room ${booking.room.roomNumber}
                        <c:if test="${not empty booking.roomPackage}">
                            <div style="font-size: 11px; color: var(--au-muted); margin-top: 4px;">
                                Applied Package: <strong>${booking.roomPackage.name}</strong><br>
                                ${booking.roomPackage.description}
                            </div>
                        </c:if>
                    </td>
                    <td><fmt:formatNumber value="${booking.room.pricePerNight}" type="currency" currencyCode="USD"/></td>
                    <td>${booking.numberOfNights} Nights</td>
                    <td style="text-align: right;"><fmt:formatNumber value="${booking.roomCharges}" type="currency" currencyCode="USD"/></td>
                </tr>
                <c:if test="${booking.additionalCharges > 0}">
                <tr>
                    <td>Additional Services</td>
                    <td>-</td>
                    <td>1</td>
                    <td style="text-align: right;"><fmt:formatNumber value="${booking.additionalCharges}" type="currency" currencyCode="USD"/></td>
                </tr>
                </c:if>
            </tbody>
        </table>

        <table class="totals">
            <tr>
                <td>Subtotal</td>
                <td style="text-align: right;"><fmt:formatNumber value="${booking.subtotal}" type="currency" currencyCode="USD"/></td>
            </tr>
            <tr>
                <td>Tax (${booking.taxAmount > 0 ? 'Applied' : '0%'})</td>
                <td style="text-align: right;"><fmt:formatNumber value="${booking.taxAmount}" type="currency" currencyCode="USD"/></td>
            </tr>
            <c:if test="${booking.packageDiscountAmount > 0}">
            <tr>
                <td>Package Discount (${booking.roomPackage.name})</td>
                <td style="text-align: right;">- <fmt:formatNumber value="${booking.packageDiscountAmount}" type="currency" currencyCode="USD"/></td>
            </tr>
            </c:if>
            <c:if test="${booking.discountAmount > 0}">
            <tr>
                <td>Manual Discount</td>
                <td style="text-align: right;">- <fmt:formatNumber value="${booking.discountAmount}" type="currency" currencyCode="USD"/></td>
            </tr>
            </c:if>
            <tr class="grand-total">
                <td>Total Amount</td>
                <td style="text-align: right;"><fmt:formatNumber value="${booking.billTotal}" type="currency" currencyCode="USD"/></td>
            </tr>
            <tr>
                <td>Amount Paid</td>
                <td style="text-align: right;"><fmt:formatNumber value="${totalPaid}" type="currency" currencyCode="USD"/></td>
            </tr>
            <tr style="border-top: 1px solid #eee; font-weight: bold;">
                <td>Balance Due</td>
                <td style="text-align: right;" class="${amountDue > 0 ? 'text-danger' : 'text-success'}">
                    <fmt:formatNumber value="${amountDue}" type="currency" currencyCode="USD"/>
                </td>
            </tr>
        </table>

        <c:if test="${not empty payments}">
            <div style="margin-top: 40px;">
                <h3 style="font-size: 13px; color: var(--au-muted); text-transform: uppercase; border-bottom: 1px solid #eee; padding-bottom: 5px; margin-bottom: 10px;">Payment History</h3>
                <table class="table" style="font-size: 12px;">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Method</th>
                            <th>Reference</th>
                            <th style="text-align: right;">Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${payments}">
                        <tr>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty p.paymentDate}">
                                                                        <c:out value="${fn:substring(p.paymentDate.toString().replace('T', ' '), 0, 16)}" />
                                                                    </c:when>
                                                                    <c:otherwise>Date N/A</c:otherwise>
                                                                </c:choose>
                                                            </td>
                            <td>${p.paymentMethod}</td>
                            <td>${p.transactionId != null ? p.transactionId : '-'}</td>
                            <td style="text-align: right;"><fmt:formatNumber value="${p.amount}" type="currency" currencyCode="USD"/></td>
                            <td>${p.status}</td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <div class="footer">
            <p>Thank you for staying at Aurelian Hotel. We hope to see you again soon!</p>
            <p>&copy; 2026 Aurelian Hotel Metropolis. All rights reserved.</p>
        </div>
    </div>
</body>
</html>
