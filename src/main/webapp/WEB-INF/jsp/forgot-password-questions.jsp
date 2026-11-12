<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aurelian Hotel · Security Reset</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Google Fonts: Fraunces + Manrope -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/forgot-password-questions.css">
<%@ include file="fragments/head-assets.jsp" %>
</head>

<body>
    <div class="hotel-bg"></div>
    <div class="overlay"></div>

    <div class="login-container">
        <div class="login-card">
            <div class="hotel-icon">
                <i class="ph ph-user-gear"></i>
            </div>
            <h2>Identity</h2>
            <p class="subtitle">Enter your username or email to view your security questions.</p>

            <form action="/forgot-password-questions" method="post">
                <div class="input-group">
                    <label>Username or Email</label>
                    <div class="input-wrapper">
                        <i class="ph ph-identification-card"></i>
                        <input type="text" name="identifier" placeholder="Enter identifier" required>
                    </div>
                </div>

                <button type="submit" class="login-btn">
                    <span>FIND ACCOUNT</span>
                    <i class="ph ph-magnifying-glass"></i>
                </button>
            </form>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="ph ph-warning-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <p class="back-link">
                <a href="/forgot-password">Use email reset instead →</a>
            </p>
        </div>
    </div>
</body>

</html>
