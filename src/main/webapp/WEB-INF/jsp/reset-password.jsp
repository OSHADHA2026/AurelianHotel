<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aurelian Hotel · Reset Password</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Google Fonts: Fraunces + Manrope -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/reset-password.css">
<%@ include file="fragments/head-assets.jsp" %>
</head>

<body>
    <div class="hotel-bg"></div>
    <div class="overlay"></div>

    <div class="login-container">
        <div class="login-card">
            <div class="hotel-icon">
                <i class="ph ph-shield-check"></i>
            </div>
            <h2>Secure Reset</h2>
            <p class="subtitle">Please enter your new password below to secure your account.</p>

            <form action="/reset-password" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="token" value="${token}">
                
                <div class="input-group">
                    <label>New Password</label>
                    <div class="input-wrapper">
                        <i class="ph ph-lock"></i>
                        <input type="password" name="password" id="password" placeholder="••••••••" required>
                    </div>
                </div>

                <div class="input-group">
                    <label>Confirm Password</label>
                    <div class="input-wrapper">
                        <i class="ph ph-checks"></i>
                        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="login-btn">
                    <span>UPDATE PASSWORD</span>
                    <i class="ph ph-floppy-disk"></i>
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

        </div>
    </div>

    <script>
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;

            if (password !== confirmPassword) {
                alert("Passwords do not match.");
                return false;
            }
            if (password.length < 4) {
                alert("Password must be at least 4 characters long.");
                return false;
            }
            return true;
        }
    </script>
</body>

</html>
