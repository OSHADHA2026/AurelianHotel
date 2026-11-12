<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error - Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/error.css">
<%@ include file="fragments/head-assets.jsp" %>
</head>
<body>
    <div class="error-container">
        <h1>Oops! Something went wrong.</h1>
        <p>URL: ${url}</p>
        <p>Message: ${exception.message}</p>
        <h3>Stack Trace:</h3>
        <pre><c:out value="${exception}"/></pre>
    </div>
</body>
</html>
