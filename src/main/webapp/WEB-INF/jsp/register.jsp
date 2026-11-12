<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aurelian Hotel · Join</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <% if(request.getAttribute("success") != null) { %>
    <meta http-equiv="refresh" content="2;url=/login">
    <% } %>

    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    
<%@ include file="fragments/head-assets.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/auth.css">
</head>

<body class="au-auth au-register">
<aside class="au-auth-hero" style="background-image:url('${pageContext.request.contextPath}/images/scenes/cove.svg')"><div class="au-auth-hero-inner">
<a class="au-auth-brand" href="${pageContext.request.contextPath}/" aria-label="Aurelian Hotel home"><img src="${pageContext.request.contextPath}/favicon.png" alt=""><span>AURELIAN HOTEL</span></a>
<div class="au-auth-copy"><span class="au-eyebrow">Become a member</span><h1>Start your stay with us</h1><p>Create a free account to book rooms, track reservations and unlock exclusive guest benefits.</p><ul class="au-auth-points"><li><i class="ph ph-diamond"></i>VIP benefits</li><li><i class="ph ph-clock"></i>24/7 concierge</li><li><i class="ph ph-wifi-high"></i>Premium Wi-Fi</li></ul></div>
<div class="au-auth-foot">&copy; Aurelian Hotel &middot; Hospitality, Perfected</div></div></aside>
<main class="au-auth-main">
<a class="au-back" href="${pageContext.request.contextPath}/"><i class="ph ph-arrow-left"></i> Back to Home</a>
<div class="au-auth-card">
<h2>Create Account</h2>
<p class="subtitle">Join our hospitality program in just a minute.</p>
<% if(request.getAttribute("success") != null) { %>
        <div style="background: #d4edda; border-left: 4px solid #28a745; color: #155724; padding: 14px; border-radius: 3px; margin-bottom: 20px; font-size: 14px; display: flex; align-items: center; gap: 10px;">
            <i class="ph ph-check-circle"></i>
            <span>${success}</span>
        </div>
        <script>
            // Auto redirect to login after 2 seconds
            setTimeout(function() {
                window.location.href = '/login';
            }, 2000);
        </script>
        <% } %>

        <% if(request.getAttribute("error") != null) { %>
        <div style="background: #fee9e6; border-left: 4px solid #e44b4b; color: #a12b2b; padding: 14px; border-radius: 3px; margin-bottom: 20px; font-size: 14px; display: flex; align-items: center; gap: 10px;">
            <i class="ph ph-warning-circle"></i>
            <span>${error}</span>
        </div>
        <% } %>

        <form name="registerForm" id="registerForm" action="/register" method="post" onsubmit="return handleRegisterSubmit(event)">
            <div class="form-row-group">
                <div class="form-row">
                    <label>First Name</label>
                    <div class="input-affix">
                        <i class="ph ph-user"></i>
                        <input type="text" name="firstName" placeholder="Your first name" autocomplete="off" required>
                    </div>
                </div>

                <div class="form-row">
                    <label>Last Name</label>
                    <div class="input-affix">
                        <i class="ph ph-user"></i>
                        <input type="text" name="lastName" placeholder="Your last name" autocomplete="off" required>
                    </div>
                </div>
            </div>

            <div class="form-row">
                <label>Email Address</label>
                <div class="input-affix">
                    <i class="ph ph-envelope-simple"></i>
                    <input type="email" name="email" placeholder="Enter your email address" autocomplete="off" required>
                </div>
            </div>

            <div class="form-row">
                <label>Phone Number</label>
                <div class="input-affix">
                    <i class="ph ph-phone"></i>
                    <input type="tel" name="phoneNumber" placeholder="Enter your phone number" pattern="[0-9\-\+\s\(\)]*" required>
                </div>
            </div>

            <div class="form-row">
                <label>Username</label>
                <div class="input-affix">
                    <i class="ph ph-user-circle"></i>
                    <input type="text" name="username" placeholder="Choose a username" autocomplete="off" required>
                </div>
            </div>

            <div class="form-row-group">
                <div class="form-row">
                    <label>Password</label>
                    <div class="input-affix">
                        <i class="ph ph-shield-check"></i>
                        <input type="password" name="password" placeholder="Create a strong password" id="password" required>
                    </div>
                </div>

                <div class="form-row">
                    <label>Confirm Password</label>
                    <div class="input-affix">
                        <i class="ph ph-shield-check"></i>
                        <input type="password" name="passwordConfirm" placeholder="Confirm your password" id="passwordConfirm" required>
                    </div>
                </div>
            </div>


            <div class="form-row">
                <label>Security Question 1</label>
                <div class="input-affix">
                    <i class="ph ph-question"></i>
                    <select name="securityQuestion1" required>
                        <option value="" disabled selected>Select a security question</option>
                        <option value="What was the name of your first pet?">What was the name of your first pet?</option>
                        <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
                        <option value="What was the name of your elementary school?">What was the name of your elementary school?</option>
                        <option value="In what city were you born?">In what city were you born?</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <label>Answer 1</label>
                <div class="input-affix">
                    <i class="ph ph-identification-card"></i>
                    <input type="text" name="securityAnswer1" placeholder="Your answer" required>
                </div>
            </div>

            <div class="form-row">
                <label>Security Question 2</label>
                <div class="input-affix">
                    <i class="ph ph-question"></i>
                    <select name="securityQuestion2" required>
                        <option value="" disabled selected>Select a second security question</option>
                        <option value="What was your first car?">What was your first car?</option>
                        <option value="What is your favorite book?">What is your favorite book?</option>
                        <option value="What is the name of the street you grew up on?">What is the name of the street you grew up on?</option>
                        <option value="What was your childhood nickname?">What was your childhood nickname?</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <label>Answer 2</label>
                <div class="input-affix">
                    <i class="ph ph-identification-card"></i>
                    <input type="text" name="securityAnswer2" placeholder="Your answer" required>
                </div>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" name="privacyPolicy" id="privacyPolicy" value="on" required>
                <label for="privacyPolicy">
                    I agree to the <a href="#" target="_blank">Privacy Policy</a> and <a href="#" target="_blank">Terms of Service</a>
                </label>
            </div>

            <div class="register-action">
                <button type="submit" class="btn-register">
                    <span>CREATE ACCOUNT</span>
                    <i class="ph ph-arrow-right"></i>
                </button>
            </div>
        </form>
<p class="login-alt">
            Already have an account?
            <a href="/login">Sign in →</a>
        </p>
</div>
</main>

<script>
    function handleRegisterSubmit(event) {
        try {
            console.log("Form submission started...");
            
            // Get form values and validate them safely
            let form = document.forms["registerForm"];
            if (!form) {
                console.error("Form not found");
                return true; // Allow submission if form not found
            }
            
            let firstName = form["firstName"] ? form["firstName"].value.trim() : "";
            let lastName = form["lastName"] ? form["lastName"].value.trim() : "";
            let email = form["email"] ? form["email"].value.trim() : "";
            let phoneNumber = form["phoneNumber"] ? form["phoneNumber"].value.trim() : "";
            let username = form["username"] ? form["username"].value.trim() : "";
            let password = form["password"] ? form["password"].value : "";
            let passwordConfirm = form["passwordConfirm"] ? form["passwordConfirm"].value : "";
            let privacyPolicy = form["privacyPolicy"] ? form["privacyPolicy"].checked : false;

            console.log("Form Fields:", { firstName, lastName, email, username, privacyPolicy });

            // Validate first name
            if (firstName.length === 0) {
                alert("First name is required");
                if (event) event.preventDefault();
                return false;
            }
            if (firstName.length < 2) {
                alert("First name must be at least 2 characters");
                if (event) event.preventDefault();
                return false;
            }
            if (firstName.length > 50) {
                alert("First name cannot exceed 50 characters");
                if (event) event.preventDefault();
                return false;
            }

            // Validate last name
            if (lastName.length === 0) {
                alert("Last name is required");
                if (event) event.preventDefault();
                return false;
            }
            if (lastName.length < 2) {
                alert("Last name must be at least 2 characters");
                if (event) event.preventDefault();
                return false;
            }
            if (lastName.length > 50) {
                alert("Last name cannot exceed 50 characters");
                if (event) event.preventDefault();
                return false;
            }

            // Validate email
            if (email.length === 0) {
                alert("Email address is required");
                if (event) event.preventDefault();
                return false;
            }
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                alert("Please enter a valid email address");
                if (event) event.preventDefault();
                return false;
            }

            // Validate phone number
            if (phoneNumber.length === 0) {
                alert("Phone number is required");
                if (event) event.preventDefault();
                return false;
            }

            // Validate username
            if (username.length < 3) {
                alert("Username must be at least 3 characters long");
                if (event) event.preventDefault();
                return false;
            }
            if (username.length > 20) {
                alert("Username cannot exceed 20 characters");
                if (event) event.preventDefault();
                return false;
            }

            // Validate password
            if (password.length < 8) {
                alert("Password must be at least 8 characters for security");
                if (event) event.preventDefault();
                return false;
            }
            if (password.length > 30) {
                alert("Password is too long (max 30 characters)");
                if (event) event.preventDefault();
                return false;
            }

            // Validate password confirmation
            if (password !== passwordConfirm) {
                alert("Passwords do not match. Please check and try again.");
                if (event) event.preventDefault();
                return false;
            }

            // Validate privacy policy
            if (!privacyPolicy) {
                alert("You must agree to the Privacy Policy and Terms of Service to create an account");
                if (event) event.preventDefault();
                return false;
            }

            console.log("All validations passed, submitting form...");

            // Show loading message
            let btn = document.querySelector('.btn-register');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<span>Creating account...</span><i class="ph ph-spinner ph-spin"></i>';
                console.log("Submit button disabled, showing loading state");
            }

            // Allow form to submit normally - server will handle redirect
            console.log("Returning true to allow form submission");
            return true;
            
        } catch (error) {
            console.error("Error in form validation:", error);
            // If there's an error, allow the form to submit normally
            return true;
        }
    }

    function validateRegister() {
        // Keep this for compatibility, it now calls handleRegisterSubmit
        return handleRegisterSubmit();
    }
</script>
</body>
</html>