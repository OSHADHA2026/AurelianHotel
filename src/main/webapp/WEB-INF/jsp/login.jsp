<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Aurelian Hotel · Login</title>
    <link rel="icon" type="image/png" href="/favicon.png">

            <!-- Google Fonts: Fraunces + Manrope -->
            <link
                href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                rel="stylesheet">

            
        <%@ include file="fragments/head-assets.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/auth.css">
</head>

        <body class="au-auth au-login">
<aside class="au-auth-hero" style="background-image:url('${pageContext.request.contextPath}/images/scenes/beach.svg')"><div class="au-auth-hero-inner">
<a class="au-auth-brand" href="${pageContext.request.contextPath}/" aria-label="Aurelian Hotel home"><img src="${pageContext.request.contextPath}/favicon.png" alt=""><span>AURELIAN HOTEL</span></a>
<div class="au-auth-copy"><span class="au-eyebrow">Welcome back</span><h1>Your seaside escape is waiting</h1><p>Sign in to manage your reservations, view your stays and enjoy member benefits.</p><ul class="au-auth-points"><li><i class="ph ph-calendar-check"></i>Easy bookings</li><li><i class="ph ph-diamond"></i>Member perks</li><li><i class="ph ph-bell-ringing"></i>24/7 concierge</li></ul></div>
<div class="au-auth-foot">&copy; Aurelian Hotel &middot; Hospitality, Perfected</div></div></aside>
<main class="au-auth-main">
<a class="au-back" href="${pageContext.request.contextPath}/"><i class="ph ph-arrow-left"></i> Back to Home</a>
<div class="au-auth-card">
<h2>Sign In</h2>
<p class="subtitle">${loginSubtitle != null ? loginSubtitle : 'Welcome back, esteemed guest'}</p>
<form name="loginForm" action="${formAction != null ? formAction : '/login'}" method="post"
                        onsubmit="return validateLogin()">
                        <div class="input-group">
                            <label>Username</label>
                            <div class="input-wrapper">
                                <i class="ph ph-user"></i>
                                <input type="text" name="username" placeholder="Enter your username"
                                    value="${username}">
                            </div>
                        </div>

                        <div class="input-group">
                            <label>Password</label>
                            <div class="input-wrapper">
                                <i class="ph ph-lock"></i>
                                <input type="password" name="password" id="password" placeholder="••••••••">
                                <i class="ph ph-eye password-toggle" id="togglePassword"></i>
                            </div>
                        </div>

                        <button type="submit" class="login-btn">
                            <span>LOGIN</span>
                            <i class="ph ph-arrow-right"></i>
                        </button>
                    </form>


                    <%-- Check for success flash attribute --%>
                        <c:if test="${not empty success}">
                            <div class="success-message">
                                <i class="ph ph-check-circle"></i>
                                <span>${success}</span>
                            </div>
                        </c:if>

                        <%-- Check for error message --%>
                            <c:if test="${not empty error}">
                                <div class="error-message">
                                    <i class="ph ph-warning-circle"></i>
                                    <span>${error}</span>
                                </div>
                            </c:if>

                            
<p class="register-link">
                                New to Aurelian Hotel?
                                <a href="/register">Create account →</a>
                            </p>

                            <p class="register-link" style="margin-top: 10px;">
                                <a href="/forgot-password" style="font-weight: 500; font-size: 14px; color: var(--au-muted);">Forgot Password?</a>
                            </p>

                            
</div>
</main>

<script>
                function validateLogin() {
                    let username = document.forms["loginForm"]["username"].value.trim();
                    let password = document.forms["loginForm"]["password"].value.trim();

                    if (username === "") {
                        alert("Please enter your username");
                        return false;
                    }
                    if (password === "") {
                        alert("Please enter your password");
                        return false;
                    }
                    if (password.length < 4) {
                        alert("Password must be at least 4 characters");
                        return false;
                    }
                    return true;
                }

                // Password visibility toggle
                document.getElementById('togglePassword').addEventListener('click', function() {
                    const passwordInput = document.getElementById('password');
                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordInput.setAttribute('type', type);
                    
                    // Toggle icon
                    this.classList.toggle('ph-eye');
                    this.classList.toggle('ph-eye-slash');
                });
            </script>
        </body>

        </html>