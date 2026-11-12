<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports &amp; Dashboard · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin/reports.css">
<%@ include file="../fragments/head-assets.jsp" %>
</head>
<body>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page">
    <div class="header">
        <div>
            <h1><i class="ph ph-chart-line" style="color:#2bb3e6;"></i> Reports &amp; Dashboard</h1>
            <p>Daily and monthly revenue, bookings, and outstanding payments.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary"><i class="ph ph-arrow-left"></i> Dashboard</a>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-error"><i class="ph ph-warning-circle"></i> ${error}</div></c:if>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-card-icon" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                <i class="ph ph-sun"></i>
            </div>
            <div class="stat-card-value"><fmt:formatNumber value="${dailyRevenue}" type="currency" currencyCode="USD"/></div>
            <div class="stat-card-label">Daily revenue (today)</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon" style="background: linear-gradient(135deg, #2bb3e6 0%, #0e4d6e 100%);">
                <i class="ph ph-calendar-blank"></i>
            </div>
            <div class="stat-card-value"><fmt:formatNumber value="${monthlyRevenue}" type="currency" currencyCode="USD"/></div>
            <div class="stat-card-label">Monthly revenue</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon" style="background: linear-gradient(135deg, #2bb3e6 0%, #1590c4 100%);">
                <i class="ph ph-bed"></i>
            </div>
            <div class="stat-card-value">${totalBookings}</div>
            <div class="stat-card-label">Total bookings</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                <i class="ph ph-warning"></i>
            </div>
            <div class="stat-card-value"><fmt:formatNumber value="${outstandingPayments}" type="currency" currencyCode="USD"/></div>
            <div class="stat-card-label">Outstanding payments</div>
        </div>
    </div>

    <div class="card">
        <h2><i class="ph ph-list-bullets" style="color:#2bb3e6;"></i> Recent payments</h2>
        <c:choose>
            <c:when test="${empty recentPayments}">
                <p style="color:var(--au-muted);">No payments recorded yet.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Booking</th>
                            <th>Method</th>
                            <th class="num">Amount</th>
                            <th>Reference</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${recentPayments}">
                            <tr>
                                <td><fmt:formatDate value="${p.paymentDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                                <td><a href="${pageContext.request.contextPath}/admin/billing/${p.booking.id}">#${p.booking.id}</a></td>
                                <td>${p.paymentMethod}</td>
                                <td class="num"><fmt:formatNumber value="${p.amount}" type="currency" currencyCode="USD"/></td>
                                <td>${p.transactionId != null ? p.transactionId : '-'}</td>
                                <td><span class="badge ${fn:toLowerCase(p.status)}">${p.status}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <p style="font-size: 14px; color: var(--au-muted);">Completed stays: <strong>${completedBookings}</strong></p>
</div>

<%@ include file="../fragments/footer.jsp" %>
</body>
</html>
