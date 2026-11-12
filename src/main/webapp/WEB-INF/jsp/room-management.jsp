<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Management · Admin · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <script>
        let currentRoomId = null;

        function switchTab(tabId) {
            // Hide all tab content
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            // Deactivate all tab buttons
            document.querySelectorAll('.tab-button').forEach(btn => {
                btn.classList.remove('active');
            });

            // Show selected tab content
            const targetTab = document.getElementById(tabId);
            if (targetTab) {
                targetTab.classList.add('active');
            }

            // Activate corresponding tab button
            const targetBtn = document.querySelector('.tab-button[data-tab="' + tabId + '"]');
            if (targetBtn) {
                targetBtn.classList.add('active');
            }
        }

        // Add click listeners to buttons
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.tab-button').forEach(button => {
                button.addEventListener('click', function() {
                    switchTab(this.getAttribute('data-tab'));
                });
            });
            
            // Close modal when clicking outside
            const modal = document.getElementById('maintenanceModal');
            if(modal) {
                modal.addEventListener('click', function(e) {
                    if (e.target === this) closeMaintenanceModal();
                });
            }
        });

        function openMaintenanceModal(roomId, roomNumber) {
            currentRoomId = roomId;
            const modal = document.getElementById('maintenanceModal');
            const form = document.getElementById('maintenanceForm');
            const display = document.getElementById('roomNumberDisplay');
            
            if(display) display.value = roomNumber;
            
            // Set default dates
            const now = new Date();
            const tomorrow = new Date(now.getTime() + (24 * 60 * 60 * 1000));
            const formatForInput = (date) => {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                const hours = String(date.getHours()).padStart(2, '0');
                const minutes = String(date.getMinutes()).padStart(2, '0');
                return year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
            };
            
            const startInput = document.getElementById('startDate');
            const endInput = document.getElementById('endDate');
            if(startInput) startInput.value = formatForInput(now);
            if(endInput) endInput.value = formatForInput(tomorrow);
            
            // Set form action dynamically
            if(form) form.action = '${pageContext.request.contextPath}/rooms/admin/' + roomId + '/maintenance';
            if(modal) modal.classList.add('active');
        }

        function closeMaintenanceModal() {
            const modal = document.getElementById('maintenanceModal');
            if(modal) modal.classList.remove('active');
            currentRoomId = null;
        }

        function confirmDelete(roomId) {
            if (confirm('Are you sure you want to delete this room? This action cannot be undone.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/rooms/admin/delete/' + roomId;
                const csrfInput = document.createElement('input');
                csrfInput.type = 'hidden';
                csrfInput.name = '${_csrf.parameterName}';
                csrfInput.value = '${_csrf.token}';
                form.appendChild(csrfInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/room-management.css">
<%@ include file="fragments/head-assets.jsp" %>
</head>
<body>
    <%@ include file="fragments/navbar.jsp" %>

    <div class="main-content">
        <div class="header">
            <h1><i class="ph ph-door-open"></i> Room Management</h1>
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/rooms/admin/create" class="btn btn-primary">
                    <i class="ph ph-plus"></i> Add New Room
                </a>
            </c:if>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="ph ph-check-circle"></i>
                ${param.success}
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-error">
                <i class="ph ph-warning-circle"></i>
                ${param.error}
            </div>
        </c:if>

        <div class="stats-grid">
            <div class="stat-card">
                <h3><i class="ph ph-door-open"></i> Total Rooms</h3>
                <div class="number">${totalRooms}</div>
            </div>
            <div class="stat-card clickable" onclick="switchTab('available')">
                <h3><i class="ph ph-check-circle"></i> Available</h3>
                <div class="number">${availableRooms.size()}</div>
            </div>
            <div class="stat-card clickable" onclick="switchTab('maintenance')">
                <h3><i class="ph ph-wrench"></i> In Maintenance</h3>
                <div class="number">${maintenanceRooms.size()}</div>
            </div>
            <div class="stat-card">
                <h3><i class="ph ph-percent"></i> Occupancy</h3>
                <div class="number">
                    <c:choose>
                        <c:when test="${totalRooms == 0}">0%</c:when>
                        <c:otherwise><fmt:formatNumber value="${(totalRooms - availableRooms.size()) * 100 / totalRooms}" maxFractionDigits="0"/>%</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="tabs">
            <button class="tab-button active" data-tab="all-rooms">All Rooms</button>
            <button class="tab-button" data-tab="available">Available</button>
            <button class="tab-button" data-tab="maintenance">Maintenance</button>
        </div>

        <!-- All Rooms Tab -->
        <div class="tab-content active" id="all-rooms">
            <div class="rooms-table">
                <c:choose>
                    <c:when test="${not empty allRooms}">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Room No.</th>
                                    <th>Type</th>
                                    <th>Capacity</th>
                                    <th>Price/Night</th>
                                    <th>Floor</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${allRooms}" var="room">
                                    <tr>
                                        <td><span class="room-number">${room.roomNumber}</span></td>
                                        <td><span class="room-type">${room.roomType}</span></td>
                                        <td>${room.capacity} Guest<c:if test="${room.capacity > 1}">s</c:if></td>
                                        <td><span class="price">$${room.pricePerNight}</span></td>
                                        <td>Floor ${room.floor}</td>
                                        <td>
                                            <span class="status-badge status-${fn:toLowerCase(room.status)}">
                                                ${room.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <a href="${pageContext.request.contextPath}/rooms/admin/edit/${room.id}" class="btn-action btn-edit">
                                                    <i class="ph ph-pencil-simple-line"></i> Edit
                                                </a>
                                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                                    <button class="btn-action btn-delete" onclick="confirmDelete('${room.id}')">
                                                        <i class="ph ph-trash"></i> Delete
                                                    </button>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="ph ph-tray"></i>
                            <p>No rooms found. <c:if test="${sessionScope.user.role == 'ADMIN'}"><a href="${pageContext.request.contextPath}/rooms/admin/create">Create a new room</a></c:if></p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Available Rooms Tab -->
        <div class="tab-content" id="available">
            <div class="rooms-table">
                <c:choose>
                    <c:when test="${not empty availableRooms}">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Room No.</th>
                                    <th>Type</th>
                                    <th>Capacity</th>
                                    <th>Price/Night</th>
                                    <th>Floor</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${availableRooms}" var="room">
                                    <tr>
                                        <td><span class="room-number">${room.roomNumber}</span></td>
                                        <td><span class="room-type">${room.roomType}</span></td>
                                        <td>${room.capacity} Guest<c:if test="${room.capacity > 1}">s</c:if></td>
                                        <td><span class="price">$${room.pricePerNight}</span></td>
                                        <td>Floor ${room.floor}</td>
                                        <td>
                                            <span class="status-badge status-${fn:toLowerCase(room.status)}">
                                                ${room.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <a href="${pageContext.request.contextPath}/rooms/admin/edit/${room.id}" class="btn-action btn-edit">
                                                    <i class="ph ph-pencil-simple-line"></i> Edit
                                                </a>
                                                <button class="btn-action btn-status" onclick="openMaintenanceModal('${room.id}', '${room.roomNumber}')">
                                                    <i class="ph ph-wrench"></i> Maintenance
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="ph ph-tray"></i>
                            <p>No available rooms at the moment.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Maintenance Rooms Tab -->
        <div class="tab-content" id="maintenance">
            <div class="rooms-table">
                <c:choose>
                    <c:when test="${not empty maintenanceRooms}">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Room No.</th>
                                    <th>Type</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Notes</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${maintenanceRooms}" var="room">
                                    <tr>
                                        <td><span class="room-number">${room.roomNumber}</span></td>
                                        <td><span class="room-type">${room.roomType}</span></td>
                                        <td>${fn:replace(room.maintenanceStartDate, 'T', ' ')}</td>
                                        <td>${fn:replace(room.maintenanceEndDate, 'T', ' ')}</td>
                                        <td>${room.maintenanceNotes}</td>
                                        <td>
                                            <form method="POST" action="${pageContext.request.contextPath}/rooms/admin/${room.id}/complete-maintenance" style="display: inline;">
                                                <button type="submit" class="btn-action btn-edit" onclick="return confirm('Complete maintenance for Room ${room.roomNumber}?')">
                                                    <i class="ph ph-check"></i> Complete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="ph ph-tray"></i>
                            <p>No rooms in maintenance.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Maintenance Modal -->
    <div class="modal" id="maintenanceModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Schedule Maintenance</h2>
                <button class="modal-close" onclick="closeMaintenanceModal()">×</button>
            </div>
            <form id="maintenanceForm" method="POST">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="form-group">
                    <label>Room Number</label>
                    <input type="text" id="roomNumberDisplay" readonly class="form-control">
                </div>
                <div class="form-group">
                    <label>Start Date & Time</label>
                    <input type="datetime-local" id="startDate" name="startDate" required class="form-control">
                </div>
                <div class="form-group">
                    <label>End Date & Time</label>
                    <input type="datetime-local" id="endDate" name="endDate" required class="form-control">
                </div>
                <div class="form-group">
                    <label>Maintenance Notes</label>
                    <textarea id="notes" name="notes" placeholder="Enter maintenance details..." required class="form-control"></textarea>
                </div>
                <div class="modal-actions">
                    <button type="submit" class="btn-submit">Schedule Maintenance</button>
                    <button type="button" class="btn-cancel" onclick="closeMaintenanceModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Scripts moved to head for reliability -->

    <%@ include file="fragments/footer.jsp" %>
</body>
</html>
