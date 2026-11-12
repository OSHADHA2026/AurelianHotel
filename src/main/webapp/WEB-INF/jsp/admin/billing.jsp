<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Billing · Staff · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">
                <link
                    href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/billing.css">
            <%@ include file="../fragments/head-assets.jsp" %>
</head>

            <body>
                <%@ include file="../fragments/navbar.jsp" %>

                    <div class="page">
                        <div class="header">
                            <div>
                                <h1><i class="ph ph-receipt" style="color:#2bb3e6;"></i> Billing &amp;
                                    Payments</h1>
                                <p>Generate bills and process payments for completed stays.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary"><i
                                    class="ph ph-arrow-left"></i> Dashboard</a>
                        </div>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success"><i class="ph ph-check-circle"></i> ${success}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-error"><i class="ph ph-warning-circle"></i> ${error}</div>
                        </c:if>

                        <div class="card">
                            <h2 style="margin-bottom: 16px; font-size: 20px;">Bookings &amp; Bills</h2>
                            <c:choose>
                                <c:when test="${empty bookings}">
                                    <p class="empty">No billable bookings found yet. Stays that are currently
                                        checked-in or completed will appear here.</p>
                                </c:when>
                                <c:otherwise>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Booking ID</th>
                                                <th>Guest</th>
                                                <th>Room</th>
                                                <th>Status</th>
                                                <th>Check-out</th>
                                                <th class="num">Total</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${bookings}">
                                                <tr>
                                                    <td>#${b.id}</td>
                                                    <td>${b.guestName != null ? b.guestName : '-'}</td>
                                                    <td>${b.room != null ? b.room.roomNumber : '-'}</td>
                                                    <td>
                                                        <span
                                                            class="badge ${b.status == 'COMPLETED' ? 'completed' : 'pending'}">
                                                            ${b.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty b.actualCheckOutDateTime}">
                                                                ${fn:replace(b.actualCheckOutDateTime, 'T', ' ')}
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${fn:replace(b.checkOutDate, 'T', ' ')}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="num">
                                                        <fmt:formatNumber value="${b.billTotal}" type="currency"
                                                            currencyCode="USD" />
                                                    </td>
                                                    <td><a href="${pageContext.request.contextPath}/admin/billing/${b.id}"
                                                            class="link-bill">View bill &amp; pay <i
                                                                class="ph ph-caret-right"></i></a></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%@ include file="../fragments/footer.jsp" %>
            </body>

            </html>