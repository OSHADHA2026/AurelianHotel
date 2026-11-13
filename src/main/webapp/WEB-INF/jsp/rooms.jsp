<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Luxury Rooms & Suites · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

                <!-- Google Fonts -->
                <link
                    href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&family=Open+Sans:wght@300;400;500;600;700;800&family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <!-- AOS Animation -->
                <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
                <!-- Swiper Slider -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/page-hero.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/rooms.css">
            <%@ include file="fragments/head-assets.jsp" %>
</head>

            <body class="au-rooms">
                <div class="bg-pattern"></div>

                <!-- Floating Particles -->
                <div class="particles" id="particles"></div>

                <!-- Include Navbar -->
                <jsp:include page="/WEB-INF/jsp/fragments/navbar.jsp" />

                <div class="main-content">
                    <!-- Hero Banner with Video -->
                    <div class="hero-banner au-page-hero">
                        <img class="hero-video-bg" src="${pageContext.request.contextPath}/images/scenes/beach.svg" alt="">
                        <div class="hero-overlay"></div>
                        <div class="hero-content">
                            <h1>Rooms &amp; Offers</h1>
                            <p>Browse our rooms and suites, check live availability and book your stay in minutes</p>
                            <div class="hero-decoration">
                                <span class="line"></span>
                                <i class="ph ph-diamond"></i>
                                <span class="line"></span>
                            </div>
                        </div>
                    </div>

                    <!-- Statistics with Animation -->
                    <div class="stats-banner" data-aos="fade-up" data-aos-duration="800" data-aos-delay="200">
                        <div class="stat-card" data-aos="zoom-in" data-aos-delay="300">
                            <div class="stat-icon"><i class="ph ph-door-open"></i></div>
                            <div class="stat-number">${totalRooms}</div>
                            <div class="stat-label">Total Rooms</div>
                            <div class="stat-trend"><i class="ph ph-arrow-up"></i> +2</div>
                        </div>
                        <div class="stat-card" data-aos="zoom-in" data-aos-delay="400">
                            <div class="stat-icon"><i class="ph ph-check-circle"></i></div>
                            <div class="stat-number">${totalAvailable}</div>
                            <div class="stat-label">Available Now</div>
                            <div class="stat-trend" style="background: rgba(40, 167, 69, 0.1); color: #28a745;">
                                <i class="ph ph-circle"></i> Ready
                            </div>
                        </div>
                        <div class="stat-card" data-aos="zoom-in" data-aos-delay="500">
                            <div class="stat-icon"><i class="ph ph-users"></i></div>
                            <div class="stat-number">${totalRooms - totalAvailable}</div>
                            <div class="stat-label">Currently Occupied</div>
                            <div class="stat-trend" style="background: rgba(220, 53, 69, 0.1); color: #dc3545;">
                                <i class="ph ph-circle"></i> Busy
                            </div>
                        </div>
                        <div class="stat-card" data-aos="zoom-in" data-aos-delay="600">
                            <div class="stat-icon"><i class="ph ph-star"></i></div>
                            <div class="stat-number">${totalAvailable > 0 ? 'Book Now' : 'Full'}</div>
                            <div class="stat-label">Availability Status</div>
                            <div class="stat-trend" style="background: rgba(43, 179, 230, 0.1); color: #2bb3e6;">
                                <i class="ph ph-calendar-check"></i> ${totalAvailable > 0 ? 'Available' : 'Check
                                Later'}
                            </div>
                        </div>
                    </div>

                    <!-- ===== PACKAGES SHOWCASE SECTION ===== -->
                    <c:if test="${not empty activePackages}">
                    <div class="packages-section" data-aos="fade-up" data-aos-duration="800" data-aos-delay="300">
                        <div class="packages-section-header">
                            <div class="section-tag">
                                <i class="ph ph-gift"></i>
                                Exclusive Offers
                            </div>
                            <h2>Special Packages &amp; Deals</h2>
                            <p>Take advantage of our curated packages to elevate your stay with exclusive perks and savings.</p>
                        </div>

                        <div class="packages-grid">
                            <c:forEach var="pkg" items="${activePackages}" varStatus="status">
                            <div class="package-card" data-aos="zoom-in" data-aos-delay="${300 + status.index * 100}">

                                <!-- Card Top: Dark gradient with discount badge -->
                                <div class="package-card-top">
                                    <c:choose>
                                        <c:when test="${not empty pkg.discountPercentage and pkg.discountPercentage > 0}">
                                            <div class="package-discount-badge">
                                                <i class="ph ph-tag"></i>
                                                ${pkg.discountPercentage}% OFF
                                            </div>
                                        </c:when>
                                        <c:when test="${not empty pkg.fixedDiscountAmount and pkg.fixedDiscountAmount > 0}">
                                            <div class="package-discount-badge">
                                                <i class="ph ph-tag"></i>
                                                $${pkg.fixedDiscountAmount} OFF
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="package-discount-badge">
                                                <i class="ph ph-star"></i>
                                                Special Package
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="package-name">${pkg.name}</div>

                                    <c:if test="${not empty pkg.applicableRoomType}">
                                        <div class="package-room-type">
                                            <i class="ph ph-bed"></i>
                                            ${pkg.applicableRoomType} Room
                                        </div>
                                    </c:if>
                                    <c:if test="${empty pkg.applicableRoomType}">
                                        <div class="package-room-type">
                                            <i class="ph ph-buildings"></i>
                                            All Room Types
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Card Body -->
                                <div class="package-card-body">
                                    <c:if test="${not empty pkg.description}">
                                        <p class="package-description">${pkg.description}</p>
                                    </c:if>

                                    <!-- Requirements badges -->
                                    <div class="package-requirements">
                                        <c:if test="${not empty pkg.minNights and pkg.minNights > 0}">
                                            <span class="package-req-badge">
                                                <i class="ph ph-moon"></i>
                                                Min ${pkg.minNights} Night${pkg.minNights > 1 ? 's' : ''}
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty pkg.minGuests and pkg.minGuests > 0}">
                                            <span class="package-req-badge">
                                                <i class="ph ph-users"></i>
                                                Min ${pkg.minGuests} Guest${pkg.minGuests > 1 ? 's' : ''}
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty pkg.maxGuests}">
                                            <span class="package-req-badge">
                                                <i class="ph ph-user-check"></i>
                                                Up to ${pkg.maxGuests} Guests
                                            </span>
                                        </c:if>
                                    </div>

                                    <!-- Benefits list -->
                                    <c:if test="${not empty pkg.benefits}">
                                        <div class="package-benefits">
                                            <div class="package-benefits-title">
                                                <i class="ph ph-sparkle"></i>
                                                What's Included
                                            </div>
                                            <c:forTokens var="benefit" items="${pkg.benefits}" delims=",">
                                                <div class="package-benefit-item">
                                                    <i class="ph ph-check-circle"></i>
                                                    <span>${fn:trim(benefit)}</span>
                                                </div>
                                            </c:forTokens>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Card Footer -->
                                <div class="package-card-footer">
                                    <span class="package-apply-hint">
                                        <i class="ph ph-info"></i>
                                        Applied during booking
                                    </span>
                                    <a href="${pageContext.request.contextPath}/reservations?pkg=${pkg.id}" class="package-cta">
                                        Book Now <i class="ph ph-arrow-right"></i>
                                    </a>
                                </div>

                            </div>
                            </c:forEach>
                        </div>
                    </div>
                    </c:if>
                    <!-- ===== END PACKAGES SECTION ===== -->

                    <form id="room-filters" class="filter-section" method="GET" data-aos="fade-up" data-aos-delay="300">
                        <div class="filter-group">
                            <label><i class="ph ph-bed"></i> Room Type</label>
                            <select id="roomType" name="type">
                                <option value="">All Types</option>
                                <option value="SINGLE" ${selectedType=='SINGLE' ? 'selected' : '' }>Single Room</option>
                                <option value="DOUBLE" ${selectedType=='DOUBLE' ? 'selected' : '' }>Double Room</option>
                                <option value="SUITE" ${selectedType=='SUITE' ? 'selected' : '' }>Suite</option>
                                <option value="DELUXE" ${selectedType=='DELUXE' ? 'selected' : '' }>Deluxe Room</option>
                                <option value="FAMILY" ${selectedType=='FAMILY' ? 'selected' : '' }>Family Room</option>
                                <option value="PENTHOUSE" ${selectedType=='PENTHOUSE' ? 'selected' : '' }>Penthouse Room</option>
                                <option value="PRESIDENTIAL" ${selectedType=='PRESIDENTIAL' ? 'selected' : '' }>Presidential Suite</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label><i class="ph ph-users"></i> Capacity</label>
                            <select id="capacity" name="capacity">
                                <option value="">Any Capacity</option>
                                <option value="1" ${selectedCapacity==1 ? 'selected' : '' }>1 Guest</option>
                                <option value="2" ${selectedCapacity==2 ? 'selected' : '' }>2 Guests</option>
                                <option value="3" ${selectedCapacity==3 ? 'selected' : '' }>3 Guests</option>
                                <option value="4" ${selectedCapacity==4 ? 'selected' : '' }>4+ Guests</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label><i class="ph ph-currency-dollar"></i> Price Range</label>
                            <select id="priceRange" name="price">
                                <option value="">Any Price</option>
                                <option value="0-100" ${selectedPrice=='0-100' ? 'selected' : '' }>$0 - $100</option>
                                <option value="101-200" ${selectedPrice=='101-200' ? 'selected' : '' }>$101 - $200
                                </option>
                                <option value="201-300" ${selectedPrice=='201-300' ? 'selected' : '' }>$201 - $300
                                </option>
                                <option value="301+" ${selectedPrice=='301+' ? 'selected' : '' }>$301+</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label><i class="ph ph-calendar-check"></i> Availability</label>
                            <select id="availableOnly" name="availableOnly">
                                <option value="false" ${!availableOnly ? 'selected' : '' }>All Rooms</option>
                                <option value="true" ${availableOnly ? 'selected' : '' }>Available Now</option>
                            </select>
                        </div>
                        <div class="filter-buttons">
                            <button type="submit" class="btn-filter">
                                <i class="ph ph-magnifying-glass"></i> Find Rooms
                            </button>
                            <a href="${pageContext.request.contextPath}/rooms#room-filters" class="btn-filter btn-clear">
                                <i class="ph ph-arrow-clockwise"></i> Reset
                            </a>
                        </div>
                    </form>

                    <!-- Rooms Grid -->
                    <div id="rooms-container">
                    <c:choose>
                        <c:when test="${not empty rooms}">
                            <div class="rooms-grid">
                                <c:forEach items="${rooms}" var="room" varStatus="status">
                                    <div class="room-card" data-aos="fade-up"
                                        data-aos-delay="${100 * (status.index % 4)}">
                                        <div class="room-image">
                                            <img src="<c:choose><c:when test="${not empty room.imagePath}">${pageContext.request.contextPath}/${room.imagePath}</c:when><c:otherwise>${pageContext.request.contextPath}/images/rooms/room-${room.id}.jpg</c:otherwise></c:choose>"
                                                alt="Room ${room.roomNumber}"
                                                onerror="this.onerror=null; this.src='https://via.placeholder.com/600x400?text=Grand+Hotel+-+Room+${room.roomNumber}'">
                                            <div class="room-overlay"></div>
                                            <span class="room-badge ${room.isAvailable ? 'available' : 'occupied'}">
                                                <i class="ph ${room.isAvailable ? 'ph-check' : 'ph-x'}"></i>
                                                ${room.isAvailable ? 'Available' : 'Occupied'}
                                            </span>
                                        </div>

                                        <div class="room-content">
                                            <div class="room-header">
                                                <div class="room-number">Room ${room.roomNumber}</div>
                                                <div class="room-type">
                                                    <i class="ph ph-tag"></i> ${room.roomType}
                                                </div>
                                            </div>

                                            <div class="room-features">
                                                <div class="feature">
                                                    <i class="ph ph-ruler"></i>
                                                    <span>Area</span>
                                                    <span class="feature-value">${room.area} m²</span>
                                                </div>
                                                <div class="feature">
                                                    <i class="ph ph-users"></i>
                                                    <span>Capacity</span>
                                                    <span class="feature-value">${room.capacity} Guests</span>
                                                </div>
                                                <div class="feature">
                                                    <i class="ph ph-stack"></i>
                                                    <span>Floor</span>
                                                    <span class="feature-value">${room.floor}</span>
                                                </div>
                                            </div>

                                            <p class="room-description">${room.description}</p>

                                            <div class="amenities-section">
                                                <div class="amenities-title">
                                                    <i class="ph ph-bell-ringing"></i>
                                                    Premium Amenities
                                                </div>
                                                <div class="amenities-grid">
                                                    <c:if test="${room.hasWifi}">
                                                        <div class="amenity-item">
                                                            <i class="ph ph-wifi-high"></i> High-Speed WiFi
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${room.hasAC}">
                                                        <div class="amenity-item">
                                                            <i class="ph ph-snowflake"></i> Climate Control
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${room.hasTV}">
                                                        <div class="amenity-item">
                                                            <i class="ph ph-television"></i> Smart TV
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${room.hasMinibar}">
                                                        <div class="amenity-item">
                                                            <i class="ph ph-champagne"></i> Mini Bar
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${room.hasSafe}">
                                                        <div class="amenity-item">
                                                            <i class="ph ph-shield-check"></i> Digital Safe
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${room.hasJacuzzi}">
                                                        <div class="amenity-item">
                                                            <i class="ph ph-waves"></i> Jacuzzi
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="room-footer">
                                                <div class="price-section">
                                                    <div>
                                                        <span class="price-old">$${room.pricePerNight + 50}</span>
                                                        <span class="price-amount">$${room.pricePerNight}</span>
                                                    </div>
                                                    <span class="price-label">per night + taxes</span>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${room.isAvailable}">
                                                        <a href="${pageContext.request.contextPath}/reservations?roomId=${room.id}"
                                                            class="btn-book">
                                                            <i class="ph ph-calendar-plus"></i> Book Now
                                                            <i class="ph ph-arrow-right"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn-book" disabled>
                                                            <i class="ph ph-clock"></i> Unavailable
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state" data-aos="zoom-in">
                                <i class="ph ph-door"></i>
                                <h3>No Rooms Available</h3>
                                <p>We couldn't find any rooms matching your criteria. Please try different filters
                                    or check back later.</p>
                                <a href="${pageContext.request.contextPath}/rooms" class="btn-reset">
                                    <i class="ph ph-arrow-clockwise"></i> Reset Filters
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    </div>
                </div>

                <!-- Quick View Modal -->
                <div class="modal" id="quickViewModal">
                    <div class="modal-content">
                        <button class="modal-close" onclick="closeModal()">
                            <i class="ph ph-x"></i>
                        </button>
                        <div class="modal-body" id="modalBody">
                            <!-- Dynamic content loaded via JavaScript -->
                        </div>
                    </div>
                </div>

                <!-- Scripts -->
                <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

                <script>
                    // Initialize AOS
                    AOS.init({
                        duration: 800,
                        easing: 'ease-in-out',
                        once: true,
                        offset: 100
                    });

                    // Create floating particles
                    function createParticles() {
                        const particlesContainer = document.getElementById('particles');
                        const particleCount = 30;

                        for (let i = 0; i < particleCount; i++) {
                            const particle = document.createElement('div');
                            particle.className = 'particle';

                            // Random position
                            const left = Math.random() * 100;
                            const top = Math.random() * 100;

                            // Random size
                            const size = Math.random() * 3 + 1;

                            // Random animation delay
                            const delay = Math.random() * 20;

                            particle.style.cssText = `
                    left: ${left}%;
                    top: ${top}%;
                    width: ${size}px;
                    height: ${size}px;
                    animation-delay: -${delay}s;
                    opacity: ${Math.random() * 0.3 + 0.1};
                `;

                            particlesContainer.appendChild(particle);
                        }
                    }

                    // Modal functions
                    function openQuickView(roomId) {
                        const modal = document.getElementById('quickViewModal');
                        const modalBody = document.getElementById('modalBody');

                        // Load room details via AJAX
                        fetch('${pageContext.request.contextPath}/rooms/' + roomId + '/details')
                            .then(response => response.text())
                            .then(html => {
                                modalBody.innerHTML = html;
                                modal.style.display = 'block';
                                document.body.style.overflow = 'hidden';
                            });
                    }

                    function closeModal() {
                        document.getElementById('quickViewModal').style.display = 'none';
                        document.body.style.overflow = 'auto';
                    }

                    // Close modal with Escape key
                    document.addEventListener('keydown', function (e) {
                        if (e.key === 'Escape') {
                            closeModal();
                        }
                    });

                    // Click outside to close
                    window.onclick = function (event) {
                        const modal = document.getElementById('quickViewModal');
                        if (event.target === modal) {
                            closeModal();
                        }
                    };

                    // Initialize particles
                    createParticles();

                    // Add hover effect for room cards
                    document.querySelectorAll('.room-card').forEach(card => {
                        card.addEventListener('mousemove', function (e) {
                            const rect = this.getBoundingClientRect();
                            const x = e.clientX - rect.left;
                            const y = e.clientY - rect.top;

                            const centerX = rect.width / 2;
                            const centerY = rect.height / 2;

                            const angleX = (y - centerY) / 20;
                            const angleY = (centerX - x) / 20;

                            this.style.transform = `perspective(1000px) rotateX(${angleX}deg) rotateY(${angleY}deg) translateY(-10px) scale(1.02)`;
                        });

                        card.addEventListener('mouseleave', function () {
                            this.style.transform = '';
                        });
                    });

                    // Animate numbers
                    function animateNumbers() {
                        document.querySelectorAll('.stat-number').forEach(stat => {
                            const value = stat.innerText;
                            const parsed = parseInt(value);
                            if (!isNaN(parsed)) {
                                let start = 0;
                                let end = parsed;
                                let duration = 2000;
                                let increment = end / (duration / 16);

                                let timer = setInterval(() => {
                                    start += increment;
                                    if (start >= end) {
                                        stat.innerText = end;
                                        clearInterval(timer);
                                    } else {
                                        stat.innerText = Math.floor(start);
                                    }
                                }, 16);
                            }
                        });
                    }

                    // Run animation when stats are visible
                    const observer = new IntersectionObserver((entries) => {
                        entries.forEach(entry => {
                            if (entry.isIntersecting) {
                                animateNumbers();
                                observer.disconnect();
                            }
                        });
                    });

                    observer.observe(document.querySelector('.stats-banner'));

                    // Filter form enhancements
                    const urlParams = new URLSearchParams(window.location.search);
                    const typeVal = urlParams.get('type');
                    const capVal = urlParams.get('capacity');
                    const priceVal = urlParams.get('price');
                    if (typeVal) document.getElementById('roomType').value = typeVal;
                    if (capVal) document.getElementById('capacity').value = capVal;
                    if (priceVal) document.getElementById('priceRange').value = priceVal;

                    document.querySelectorAll('.filter-group select').forEach(select => {
                        select.addEventListener('change', function () {
                            this.style.borderColor = '#2bb3e6';
                        });
                    });

                    // AJAX Filtering
                    document.getElementById('room-filters').addEventListener('submit', function(e) {
                        e.preventDefault();
                        
                        const form = this;
                        const formData = new FormData(form);
                        const searchParams = new URLSearchParams(formData);
                        const url = window.location.pathname + '?' + searchParams.toString();
                        
                        // Add loading state
                        const container = document.getElementById('rooms-container');
                        container.style.opacity = '0.5';
                        container.style.pointerEvents = 'none';
                        
                        fetch(url)
                            .then(response => response.text())
                            .then(html => {
                                const parser = new DOMParser();
                                const doc = parser.parseFromString(html, 'text/html');
                                const newContainer = doc.getElementById('rooms-container');
                                
                                if (newContainer) {
                                    container.innerHTML = newContainer.innerHTML;
                                }
                                
                                container.style.opacity = '1';
                                container.style.pointerEvents = 'auto';
                                
                                // Update URL without refresh
                                window.history.pushState({}, '', url);
                                
                                // Re-initialize AOS for new elements
                                if (window.AOS) {
                                    AOS.refreshHard();
                                }
                                
                                // Re-initialize number animations if any
                                if (typeof animateNumbers === 'function') {
                                    animateNumbers();
                                }
                            })
                            .catch(error => {
                                console.error('Error filtering rooms:', error);
                                container.style.opacity = '1';
                                container.style.pointerEvents = 'auto';
                            });
                    });

                    // Handle reset button via AJAX too
                    document.querySelector('.btn-clear').addEventListener('click', function(e) {
                        e.preventDefault();
                        const url = this.getAttribute('href').split('#')[0];
                        
                        const container = document.getElementById('rooms-container');
                        container.style.opacity = '0.5';
                        
                        fetch(url)
                            .then(response => response.text())
                            .then(html => {
                                const parser = new DOMParser();
                                const doc = parser.parseFromString(html, 'text/html');
                                const newContainer = doc.getElementById('rooms-container');
                                
                                if (newContainer) {
                                    container.innerHTML = newContainer.innerHTML;
                                }
                                
                                container.style.opacity = '1';
                                
                                // Reset form fields
                                document.getElementById('room-filters').reset();
                                
                                window.history.pushState({}, '', url);
                                if (window.AOS) AOS.refreshHard();
                                if (typeof animateNumbers === 'function') animateNumbers();
                            });
                    });
                </script>

                <!-- Include Footer -->
                <jsp:include page="/WEB-INF/jsp/fragments/footer.jsp" />
            </body>

            </html>