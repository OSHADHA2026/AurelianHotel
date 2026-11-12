<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${empty room.id ? 'Add' : 'Edit'} Room · Admin · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

                <!-- Google Fonts -->
                <link
                    href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/room-form.css">
            <%@ include file="fragments/head-assets.jsp" %>
</head>

            <body>
                <%@ include file="fragments/navbar.jsp" %>

                    <div class="main-content">
                        <div class="header">
                            <h1>
                                <c:choose>
                                    <c:when test="${empty room.id}">
                                        <i class="ph ph-plus-circle"></i> Add New Room
                                    </c:when>
                                    <c:otherwise>
                                        <i class="ph ph-pencil-simple-line"></i> Edit Room
                                    </c:otherwise>
                                </c:choose>
                            </h1>
                            <div class="breadcrumb">
                                <a href="${pageContext.request.contextPath}/rooms/admin/management">Room Management</a>
                                <span> / ${empty room.id ? 'Add Room' : 'Edit Room'}</span>
                            </div>
                        </div>

                        <c:if test="${param.error != null}">
                            <div class="alert alert-error">
                                <i class="ph ph-warning-circle"></i>
                                ${param.error}
                            </div>
                        </c:if>

                        <div class="form-card">
                            <form id="roomForm" method="POST" enctype="multipart/form-data" action="<c:choose><c:when test="${empty room.id}">${pageContext.request.contextPath}/rooms/admin/create</c:when><c:otherwise>${pageContext.request.contextPath}/rooms/admin/update/${room.id}</c:otherwise></c:choose>">
                                <input type="hidden" name="amenities" id="amenitiesValue" value="${room.amenities != null ? room.amenities : ''}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                <!-- Basic Information -->
                                <div class="form-section">
                                    <h2><i class="ph ph-info"></i> Basic Information</h2>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="floor">Floor <span class="required">*</span></label>
                                            <select id="floor" name="floor" required onchange="updateRoomNumbers()">
                                                <option value="">Select Floor</option>
                                                <c:forEach var="f" begin="1" end="15">
                                                    <option value="${f}" <c:if test="${room.floor == f}">selected</c:if>
                                                        >Floor ${f}</option>
                                                </c:forEach>
                                            </select>
                                            <p class="form-hint">Which floor is this room on?</p>
                                        </div>

                                        <div class="form-group">
                                            <label for="roomNumber">Room Number <span class="required">*</span></label>
                                            <select id="roomNumber" name="roomNumber" required
                                                data-current="${room.roomNumber}">
                                                <option value="">Select Floor First</option>
                                                <c:if test="${not empty room.roomNumber}">
                                                    <option value="${room.roomNumber}" selected>${room.roomNumber}
                                                    </option>
                                                </c:if>
                                            </select>
                                            <p class="form-hint">Unique room identifier</p>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="roomType">Room Type <span class="required">*</span></label>
                                            <select id="roomType" name="roomType" required>
                                                <option value="">Select room type...</option>
                                                <option value="SINGLE" <c:if test="${room.roomType == 'SINGLE'}">selected</c:if>>Single Room</option>
                                                <option value="DOUBLE" <c:if test="${room.roomType == 'DOUBLE'}">selected</c:if>>Double Room</option>
                                                <option value="SUITE" <c:if test="${room.roomType == 'SUITE'}">selected</c:if>>Suite</option>
                                                <option value="DELUXE" <c:if test="${room.roomType == 'DELUXE'}">selected</c:if>>Deluxe Room</option>
                                                <option value="FAMILY" <c:if test="${room.roomType == 'FAMILY'}">selected</c:if>>Family Room</option>
                                                <option value="PENTHOUSE" <c:if test="${room.roomType == 'PENTHOUSE'}">selected</c:if>>Penthouse</option>
                                                <option value="PRESIDENTIAL" <c:if test="${room.roomType == 'PRESIDENTIAL'}">selected</c:if>>Presidential Suite</option>
                                            </select>
                                            <p class="form-hint">Category of the room</p>
                                        </div>

                                        <div class="form-group">
                                            <label for="capacity">Capacity <span class="required">*</span></label>
                                            <input type="number" id="capacity" name="capacity"
                                                value="${room.capacity != null ? room.capacity : ''}"
                                                placeholder="Number of guests" min="1" max="10" required>
                                            <p class="form-hint">Maximum number of guests</p>
                                        </div>
                                        <div class="form-group">
                                            <label for="roomSize">Room Area (m²) <span class="required">*</span></label>
                                            <input type="number" id="roomSize" name="roomSize" value="${room.roomSize}" placeholder="e.g. 25.0" step="0.1" min="0" required>
                                            <p class="form-hint">Total area of the room in square meters</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Pricing Information -->
                                <div class="form-section">
                                    <h2><i class="ph ph-currency-dollar"></i> Pricing</h2>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="pricePerNight">Price per Night <span
                                                    class="required">*</span></label>
                                            <input type="number" id="pricePerNight" name="pricePerNight"
                                                value="${room.pricePerNight != null ? room.pricePerNight : ''}"
                                                placeholder="0.00" step="0.01" min="0" required>
                                            <p class="form-hint">Room rate in USD</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Operational Information (Only for Edit) -->
                                <c:if test="${not empty room.id}">
                                    <div class="form-section">
                                        <h2><i class="ph ph-gear"></i> Operational Status</h2>

                                        <div class="form-row">
                                            <div class="form-group">
                                                <label for="status">Room Status <span class="required">*</span></label>
                                                <select id="status" name="status" required>
                                                    <option value="AVAILABLE" <c:if
                                                        test="${room.status == 'AVAILABLE'}">selected
                                </c:if>>Available</option>
                                <!-- <option value="OCCUPIED" <c:if test="${room.status == 'OCCUPIED'}">selected</c:if>>Occupied</option> -->
                                <option value="MAINTENANCE" <c:if test="${room.status == 'MAINTENANCE'}">selected</c:if>
                                    >Maintenance</option>
                                <option value="RESERVED" <c:if test="${room.status == 'RESERVED'}">selected</c:if>
                                    >Reserved</option>
                                </select>
                                <p class="form-hint">Current operational status of the room</p>
                        </div>
                    </div>
                    </div>
                    </c:if>
                    
                    <!-- Room Image -->
                    <div class="form-section">
                        <h2><i class="ph ph-image"></i> Room Image</h2>
                        <div class="form-group">
                            <label for="image">Upload Room Image</label>
                            <input type="file" id="image" name="image" accept="image/*" class="form-control">
                            <p class="form-hint">Upload a high-quality image of the room (max 5MB, JPG/PNG/WEBP)</p>
                            
                            <c:if test="${not empty room.imagePath}">
                                <div style="margin-top: 16px;">
                                    <p style="font-size: 13px; font-weight: 600; margin-bottom: 8px;">Current Image:</p>
                                    <img src="${pageContext.request.contextPath}/${room.imagePath}" alt="Room Image" style="max-width: 250px; border-radius: 4px; border: 1px solid #f2f9fd; box-shadow: 0 4px 12px rgba(0, 0, 0,0.1);">
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Room Details -->
                    <div class="form-section">
                        <h2><i class="ph ph-text-align-left"></i> Room Details</h2>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description"
                                placeholder="Describe the room features, layout, and amenities..."><c:out value="${room.description}" /></textarea>
                            <p class="form-hint">Detailed description of the room for guests</p>
                        </div>
                    </div>

                    <!-- Amenities -->
                    <div class="form-section">
                        <h2><i class="ph ph-wifi-high"></i> Amenities</h2>

                        <div class="amenities-grid">
                            <label class="amenity-checkbox">
                                <input type="checkbox" class="amenity-cb" value="WiFi" <c:if
                                    test="${not empty room.amenities && fn:contains(room.amenities, 'WiFi')}">checked
                                </c:if>>
                                <span><i class="ph ph-wifi-high"></i> WiFi</span>
                            </label>
                            <label class="amenity-checkbox">
                                <input type="checkbox" class="amenity-cb" value="AC" <c:if
                                    test="${not empty room.amenities && fn:contains(room.amenities, 'AC')}">checked
                                </c:if>>
                                <span><i class="ph ph-snowflake"></i> Air Conditioning</span>
                            </label>
                            <label class="amenity-checkbox">
                                <input type="checkbox" class="amenity-cb" value="TV" <c:if
                                    test="${not empty room.amenities && fn:contains(room.amenities, 'TV')}">checked
                                </c:if>>
                                <span><i class="ph ph-television"></i> TV</span>
                            </label>
                            <label class="amenity-checkbox">
                                <input type="checkbox" class="amenity-cb" value="Mini Bar" <c:if
                                    test="${not empty room.amenities && fn:contains(room.amenities, 'Mini Bar')}">checked
                                </c:if>>
                                <span><i class="ph ph-wine"></i> Mini Bar</span>
                            </label>
                            <label class="amenity-checkbox">
                                <input type="checkbox" class="amenity-cb" value="Bathroom" <c:if
                                    test="${not empty room.amenities && fn:contains(room.amenities, 'Bathroom')}">checked
                                </c:if>>
                                <span><i class="ph ph-bathtub"></i> Bathroom</span>
                            </label>
                            <label class="amenity-checkbox">
                                <input type="checkbox" class="amenity-cb" value="Safe" <c:if
                                    test="${not empty room.amenities && fn:contains(room.amenities, 'Safe')}">checked
                                </c:if>>
                                <span><i class="ph ph-lock"></i> Safe</span>
                            </label>
                            <label class="amenity-checkbox">
                                <input type="checkbox" class="amenity-cb" value="Balcony" <c:if
                                    test="${not empty room.amenities && fn:contains(room.amenities, 'Balcony')}">checked
                                </c:if>>
                                <span><i class="ph ph-door-open"></i> Balcony</span>
                            </label>
                            <label class="amenity-checkbox">
                                <input type="checkbox" class="amenity-cb" value="Kitchenette" <c:if
                                    test="${not empty room.amenities && fn:contains(room.amenities, 'Kitchenette')}">checked
                                </c:if>>
                                <span><i class="ph ph-fork-knife"></i> Kitchenette</span>
                            </label>
                        </div>
                        <p class="form-hint" style="margin-top: 16px;">Select all amenities available in
                            this room</p>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="ph ph-floppy-disk"></i>
                            <c:choose>
                                <c:when test="${empty room.id}">Create Room</c:when>
                                <c:otherwise>Update Room</c:otherwise>
                            </c:choose>
                        </button>
                        <a href="${pageContext.request.contextPath}/rooms/admin/management" class="btn btn-secondary">
                            <i class="ph ph-x"></i> Cancel
                        </a>
                    </div>
                    </form>
                    </div>
                    </div>

                    <script>
                        function updateRoomNumbers() {
                            var floorSelect = document.getElementById('floor');
                            var roomSelect = document.getElementById('roomNumber');
                            var floor = floorSelect.value;
                            var currentRoom = roomSelect.getAttribute('data-current');

                            if (!floor) {
                                roomSelect.innerHTML = '<option value="">Select Floor First</option>';
                                return;
                            }

                            roomSelect.innerHTML = '<option value="">Loading...</option>';

                            fetch('${pageContext.request.contextPath}/rooms/api/taken-rooms/' + floor)
                                .then(response => response.json())
                                .then(takenRooms => {
                                    roomSelect.innerHTML = '<option value="">Select Room</option>';

                                    // Generate potential rooms: RM + floor + (101-110 pattern)
                                    for (var i = 1; i <= 10; i++) {
                                        var roomNum = 'RM' + (parseInt(floor) * 100 + i);

                                        // Only add if not already taken OR if it's the current room being edited
                                        if (!takenRooms.includes(roomNum) || roomNum === currentRoom) {
                                            var option = document.createElement('option');
                                            option.value = roomNum;
                                            option.text = roomNum;
                                            if (roomNum === currentRoom) {
                                                option.selected = true;
                                            }
                                            roomSelect.appendChild(option);
                                        }
                                    }

                                    if (roomSelect.options.length === 1) {
                                        var option = document.createElement('option');
                                        option.text = "No rooms available on this floor";
                                        option.disabled = true;
                                        roomSelect.appendChild(option);
                                    }
                                })
                                .catch(error => {
                                    console.error('Error fetching taken rooms:', error);
                                    roomSelect.innerHTML = '<option value="">Error loading rooms</option>';
                                });
                        }

                        function updateAmenitiesHidden() {
                            var selected = Array.from(document.querySelectorAll('.amenity-cb:checked')).map(function (cb) { return cb.value; }).join(', ');
                            document.getElementById('amenitiesValue').value = selected;
                        }
                        document.querySelectorAll('.amenity-cb').forEach(function (cb) {
                            cb.addEventListener('change', updateAmenitiesHidden);
                        });
                        document.getElementById('roomForm').addEventListener('submit', function () {
                            updateAmenitiesHidden();
                        });

                        // Initialize room numbers if floor is already selected
                        document.addEventListener('DOMContentLoaded', function () {
                            if (document.getElementById('floor').value) {
                                updateRoomNumbers();
                            }
                        });
                    </script>

                    <%@ include file="fragments/footer.jsp" %>
            </body>

            </html>