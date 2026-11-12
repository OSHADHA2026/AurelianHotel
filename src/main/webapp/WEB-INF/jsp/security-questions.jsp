<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aurelian Hotel · Verify Answers</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Google Fonts: Fraunces + Manrope -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/security-questions.css">
<%@ include file="fragments/head-assets.jsp" %>
</head>

<body>
    <div class="hotel-bg"></div>
    <div class="overlay"></div>

    <div class="login-container">
        <div class="login-card">
            <div class="hotel-icon">
                <i class="ph ph-lock-open"></i>
            </div>
            <h2>Verify Identity</h2>
            <p class="subtitle">Please provide the correct answers to your security questions for <strong>@${username}</strong>.</p>

            <form action="/verify-security-questions" method="post">
                <input type="hidden" name="username" value="${username}">
                
                <div class="question-block">
                    <span class="question-text">${question1}</span>
                    <div class="input-wrapper">
                        <i class="ph ph-chat-circle-dots"></i>
                        <input type="text" name="answer1" placeholder="Type your answer..." required autocomplete="off">
                    </div>
                </div>

                <div class="question-block">
                    <span class="question-text">${question2}</span>
                    <div class="input-wrapper">
                        <i class="ph ph-chat-circle-dots"></i>
                        <input type="text" name="answer2" placeholder="Type your answer..." required autocomplete="off">
                    </div>
                </div>

                <button type="submit" class="login-btn">
                    <span>VERIFY & RESET</span>
                    <i class="ph ph-check"></i>
                </button>
            </form>

            <c:if test="${not empty error}">
                <div style="background: #fee9e6; border-left: 4px solid #e44b4b; color: #a12b2b; padding: 14px; border-radius: 3px; margin-top: 20px; font-size: 14px; display: flex; align-items: center; gap: 10px;">
                    <i class="ph ph-warning-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

        </div>
    </div>
</body>

</html>
