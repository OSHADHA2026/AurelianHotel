<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aurelian Hotel · Forgot Password</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Google Fonts: Fraunces + Manrope -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/forgot-password.css">
<%@ include file="fragments/head-assets.jsp" %>
</head>

<body>
    <div class="hotel-bg"></div>
    <div class="overlay"></div>

    <div class="login-container">
        <div class="login-card">
            <div class="hotel-icon">
                <i class="ph ph-key"></i>
            </div>
            <h2>Forgot Password?</h2>
            <p class="subtitle">Enter your email and we'll send you a link to reset your password.</p>

            <form action="/forgot-password" method="post">
                <div class="input-group">
                    <label>Email Address</label>
                    <div class="input-wrapper">
                        <i class="ph ph-envelope-simple"></i>
                        <input type="email" name="email" placeholder="Enter your registered email" required>
                    </div>
                </div>

                <button type="submit" class="login-btn">
                    <span>SEND RESET LINK</span>
                    <i class="ph ph-paper-plane-tilt"></i>
                </button>
            </form>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="ph ph-warning-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="success-message">
                    <i class="ph ph-check-circle"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <p class="back-link">
                Remember your password?
                <a href="/login">← Back to login</a>
            </p>

            <p class="back-link" style="margin-top: 10px; font-size: 13px;">
                Unable to access email?
                <a href="/forgot-password-questions" style="color: var(--au-muted); font-weight: 500;">Use Security Questions →</a>
            </p>
        </div>
    </div>
</body>

</html>
