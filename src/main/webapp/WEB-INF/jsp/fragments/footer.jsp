<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<footer class="footer" id="contact">
    <div class="footer-container">
        <div>
            <div class="footer-logo">
                <img src="${pageContext.request.contextPath}/favicon.png" alt="Aurelian Hotel Logo" style="height: 44px; width: 44px; border-radius: 9px;">
                <span>AURELIAN HOTEL</span>
            </div>
            <p class="footer-about">
                Experience timeless hospitality at Aurelian Hotel. Where every moment becomes a cherished memory with world-class amenities and exceptional service.
            </p>
            <div class="social-links">
                <a href="#" class="social-link"><i class="ph ph-facebook-logo"></i></a>
                <a href="#" class="social-link"><i class="ph ph-twitter-logo"></i></a>
                <a href="#" class="social-link"><i class="ph ph-instagram-logo"></i></a>
                <a href="#" class="social-link"><i class="ph ph-linkedin-logo"></i></a>
            </div>
        </div>

        <div>
            <h3 class="footer-title">Quick Links</h3>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/"><i class="ph ph-caret-right"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/rooms"><i class="ph ph-caret-right"></i> Rooms & Availability</a></li>
                <li><a href="${pageContext.request.contextPath}/gallery"><i class="ph ph-caret-right"></i> Gallery</a></li>
                <li><a href="${pageContext.request.contextPath}/contact"><i class="ph ph-caret-right"></i> Contact</a></li>
            </ul>
        </div>

        <div>
            <h3 class="footer-title">Account</h3>
            <ul class="footer-links">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li><a href="${pageContext.request.contextPath}/profile"><i class="ph ph-caret-right"></i> Profile</a></li>
                        <li><a href="${pageContext.request.contextPath}/my-bookings"><i class="ph ph-caret-right"></i> My Bookings</a></li>
                        <li><a href="${pageContext.request.contextPath}/dashboard"><i class="ph ph-caret-right"></i> Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout"><i class="ph ph-caret-right"></i> Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/login"><i class="ph ph-caret-right"></i> Sign In</a></li>
                        <li><a href="${pageContext.request.contextPath}/register"><i class="ph ph-caret-right"></i> Register</a></li>
                    </c:otherwise>
                </c:choose>
                <li><a href="#"><i class="ph ph-caret-right"></i> FAQ</a></li>
                <li><a href="#"><i class="ph ph-caret-right"></i> Privacy Policy</a></li>
            </ul>
        </div>

        <div>
            <h3 class="footer-title">Newsletter</h3>
            <p style="color: var(--au-muted); margin-bottom: 20px;">
                Subscribe for exclusive offers and updates.
            </p>
            <form class="newsletter-form" onsubmit="return false;">
                <input type="email" class="newsletter-input" placeholder="Your email" required>
                <button type="submit" class="newsletter-btn"><i class="ph ph-paper-plane-tilt"></i></button>
            </form>
            <div style="margin-top: 30px;">
                <p style="color: var(--au-muted); margin-bottom: 10px;">
                    <i class="ph ph-phone" style="color: #2bb3e6; margin-right: 10px;"></i> +1 (555) 014-2290
                </p>
                <p style="color: var(--au-muted);">
                    <i class="ph ph-envelope-simple" style="color: #2bb3e6; margin-right: 10px;"></i> info@aurelianhotel.com
                </p>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <p>&copy; 2024 Aurelian Hotel. All rights reserved. | Timeless Hospitality</p>
    </div>
</footer>