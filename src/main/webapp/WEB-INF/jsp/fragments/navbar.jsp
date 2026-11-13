<%-- Removed redundant page directive to prevent collation errors when included --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    // Get the current URI to determine active page
    // Use the original browser URL (the JSP view path is not meaningful for menu highlighting)
    String currentUri = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
    if (currentUri == null) currentUri = (String) request.getAttribute("javax.servlet.forward.request_uri");
    if (currentUri == null) currentUri = request.getRequestURI();
    String ctx = request.getContextPath();
    if (ctx != null && !ctx.isEmpty() && currentUri.startsWith(ctx)) currentUri = currentUri.substring(ctx.length());
    if (currentUri.isEmpty()) currentUri = "/";
    pageContext.setAttribute("currentUri", currentUri);
%>


<!-- Playfair Display for Brand Name Consistency -->
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">


<nav class="navbar" id="navbar">
    <div class="nav-container">
        <div class="nav-left">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <img src="${pageContext.request.contextPath}/favicon.png" alt="Aurelian Hotel Logo" style="height: 50px; width: 50px; object-fit: contain; border-radius: 10px;">
                <span>AURELIAN HOTEL</span>
            </a>

            <div class="mobile-toggle" onclick="toggleMenu()">
                <i class="ph ph-list"></i>
            </div>
        </div>

        <div class="nav-menu" id="navMenu">
            <!-- Public Navigation -->
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/"
                   class="nav-link ${fn:contains(currentUri, '/home') || currentUri == '/' ? 'active' : ''}">
                    <i class="ph ph-house"></i>
                    <span>Home</span>
                </a>
            </div>

            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/rooms"
                   class="nav-link ${fn:contains(currentUri, '/rooms') ? 'active' : ''}">
                    <i class="ph ph-bed"></i>
                    <span>Rooms & Offers</span>
                </a>
            </div>

            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/reservations"
                   class="nav-link ${fn:contains(currentUri, '/reservations') ? 'active' : ''}">
                    <i class="ph ph-calendar-check"></i>
                    <span>Reservations</span>
                </a>
            </div>

            <!-- Private Navigation (only when logged in) -->
            <c:if test="${not empty sessionScope.user}">

                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/my-bookings"
                       class="nav-link ${fn:contains(currentUri, '/my-bookings') ? 'active' : ''}">
                        <i class="ph ph-clock"></i>
                        <span>My Bookings</span>
                    </a>
                </div>

                <!-- Dashboard (for all logged-in users) -->
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard"
                       class="nav-link ${fn:contains(currentUri, '/dashboard') ? 'active' : ''}">
                        <i class="ph ph-chart-pie"></i>
                        <span>Dashboard</span>
                    </a>
                </div>





            </c:if>

            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/gallery"
                   class="nav-link ${fn:contains(currentUri, '/gallery') ? 'active' : ''}">
                    <i class="ph ph-images"></i>
                    <span>Gallery</span>
                </a>
            </div>

            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/contact"
                   class="nav-link ${fn:contains(currentUri, '/contact') ? 'active' : ''}">
                    <i class="ph ph-phone"></i>
                    <span>Contact</span>
                </a>
            </div>
        </div>

        <div class="nav-right">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <!-- Notification Bell & Board -->
                    <div class="notif-area" style="position: relative; margin-left: 25px; margin-right: 15px;">
                        <div class="notification-bell" id="notifBtn">
                            <i class="ph ph-bell"></i>
                            <div class="notification-badge" id="notifBadge" style="display: none;">0</div>
                        </div>

                        <div class="notif-box" id="notifBox">
                            <div class="notif-head">
                                <h3>Notifications</h3>
                                <a href="javascript:void(0)" class="mark-all-read" onclick="markAllAsRead()">Mark all as read</a>
                            </div>
                            <div class="notif-body" id="notifList">
                                <!-- Notifications will be loaded here -->
                            </div>
                            <div class="notification-footer">
                                <a href="javascript:void(0)" style="color: #2bb3e6; text-decoration: none;">View All Notifications</a>
                            </div>
                        </div>
                    </div>

                    <!-- User is logged in -->
                    <a href="${pageContext.request.contextPath}/profile" class="user-profile" aria-label="My profile" title="${sessionScope.user.displayName}">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.profilePicture}">
                                <div class="avatar" title="${sessionScope.user.displayName}" style="padding:0; overflow:hidden;">
                                    <img src="${pageContext.request.contextPath}/${sessionScope.user.profilePicture}"
                                         alt="${sessionScope.user.displayName}"
                                         style="width:100%; height:100%; object-fit:cover; border-radius:50%; display:block;">
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="avatar ${sessionScope.user.avatarColorClass}" title="${sessionScope.user.displayName}">
                                    ${sessionScope.user.avatarInitials}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </a>
                </c:when>
                <c:otherwise>
                    <!-- User is not logged in -->
                    <div class="auth-buttons">
                        <a href="${pageContext.request.contextPath}/login" class="btn-signin">
                            <i class="ph ph-user"></i>
                            Sign In
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn-register">
                            <i class="ph ph-user-plus"></i>
                            Register
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<script>
    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        const navbar = document.getElementById('navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // Mobile menu toggle
    function toggleMenu() {
        const menu = document.getElementById('navMenu');
        menu.classList.toggle('show');
    }

    // Notification handling
    const notifBtn = document.getElementById('notifBtn');
    const notifBox = document.getElementById('notifBox');
    const notifBadge = document.getElementById('notifBadge');
    const notifList = document.getElementById('notifList');

    if (notifBtn) {
        notifBtn.onclick = function(e) {
            e.stopPropagation();
            notifBox.classList.toggle('show');
            if (notifBox.classList.contains('show')) {
                loadNotifications();
            }
        };
    }

    document.addEventListener('click', function(e) {
        if (notifBox && !notifBox.contains(e.target) && !notifBtn.contains(e.target)) {
            notifBox.classList.remove('show');
        }
    });

    function updateUnreadCount() {
        if (!notifBadge) return;
        fetch('${pageContext.request.contextPath}/api/notifications/unread-count')
            .then(res => res.json())
            .then(count => {
                if (count > 0) {
                    notifBadge.innerText = count;
                    notifBadge.style.display = 'flex';
                } else {
                    notifBadge.style.display = 'none';
                }
            })
            .catch(err => console.error('Error updating count:', err));
    }

    function loadNotifications() {
        if (!notifList) return;
        fetch('${pageContext.request.contextPath}/api/notifications')
            .then(res => {
                if (!res.ok) throw new Error('Failed to fetch');
                return res.json();
            })
            .then(notifications => {
                if (!notifications || notifications.length === 0) {
                    notifList.innerHTML = '<div class="notif-none"><i class="ph ph-bell-slash"></i><p>No notifications yet</p></div>';
                    return;
                }

                notifList.innerHTML = '';
                notifications.forEach(n => {
                    const entry = document.createElement('a');
                    const targetLink = n.link ? '${pageContext.request.contextPath}' + n.link : null;
                    entry.href = 'javascript:void(0)'; // Prevent immediate navigation
                    entry.className = 'notif-entry' + (n.read ? '' : ' unread');
                    entry.style.display = 'flex';
                    
                    entry.onclick = function(e) { 
                        e.preventDefault();
                        if (!n.read) {
                            n.read = true;
                            markAsRead(n.id, entry); 
                        }
                        if (targetLink) {
                            // Small delay to ensure fetch is initiated before navigation
                            setTimeout(() => { window.location.href = targetLink; }, 150);
                        }
                    };

                    let iconClass = 'icon-system';
                    let iconType = 'ph-info';
                    if (n.type === 'BOOKING') { iconClass = 'icon-booking'; iconType = 'ph-calendar-check'; }
                    else if (n.type === 'PAYMENT') { iconClass = 'icon-payment'; iconType = 'ph-credit-card'; }
                    else if (n.type === 'REMINDER') { iconClass = 'icon-reminder'; iconType = 'ph-bell'; }

                    const timeStr = n.createdAt || 'Just now';
                    const messageStr = n.message || 'Notification';

                    // Brute force display with simple strings to avoid template literal issues
                    entry.innerHTML = 
                        '<div class="notif-icon ' + iconClass + '" style="display:flex !important; background: #eef7fc !important; width:45px !important; height:45px !important; align-items:center !important; justify-content:center !important; border-radius:3px !important;">' +
                            '<i class="ph ' + iconType + '" style="color:#3ba4d5 !important; font-size:18px !important; visibility:visible !important;"></i>' +
                        '</div>' +
                        '<div class="notif-txt" style="display:flex !important; flex-direction:column !important; flex:1 !important; margin-left:12px !important;">' +
                            '<b class="notif-msg" style="display:block !important; color:var(--au-text) !important; font-size:14px !important; margin-bottom:4px !important; visibility:visible !important;">' + messageStr + '</b>' +
                            '<small class="notif-time" style="display:block !important; color:var(--au-muted) !important; font-size:12px !important; visibility:visible !important;">' + timeStr + '</small>' +
                        '</div>';
                    notifList.appendChild(entry);
                });
            })
            .catch(err => {
                console.error('Error loading:', err);
                notifList.innerHTML = '<div class="notif-none"><p>Failed to load notifications</p></div>';
            });
    }

    function markAsRead(id, element) {
        if (element) {
            element.classList.remove('unread');
            element.style.borderLeft = 'none';
            element.style.background = '#ffffff';
        }
        const url = '${pageContext.request.contextPath}/api/notifications/' + id + '/read';
        fetch(url, { method: 'POST' })
            .then(() => updateUnreadCount())
            .catch(err => console.error('Error marking read:', err));
    }

    function markAllAsRead() {
        fetch('${pageContext.request.contextPath}/api/notifications/read-all', { method: 'POST' })
            .then(() => {
                loadNotifications();
                updateUnreadCount();
            })
            .catch(err => console.error('Error marking all read:', err));
    }

    // Initial check
    updateUnreadCount();
    // Refresh every minute
    setInterval(updateUnreadCount, 60000);
</script>