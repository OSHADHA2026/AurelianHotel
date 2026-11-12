<%-- Shared <head> assets: theme (light/dark), icon font, navbar/footer styles, theme + currency scripts.
     Include inside <head> with: <%@ include file="fragments/head-assets.jsp" %>  (use ../ for pages in sub-folders).
     Bump ?v= below whenever these files change so browsers fetch the new version. --%>
<script>try{if(localStorage.getItem("au-theme")==="dark")document.documentElement.setAttribute("data-theme","dark")}catch(e){}</script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css?v=10">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/navbar.css?v=10">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/footer.css?v=10">
<script src="${pageContext.request.contextPath}/js/theme.js?v=10" defer></script>
<script src="${pageContext.request.contextPath}/js/currency.js?v=10" defer></script>
