<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Aurelian Hotel · Timeless Hospitality</title>
    <link rel="icon" type="image/png" href="/favicon.png">

                <!-- Google Fonts -->
                <link
                    href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <!-- AOS Animation Library -->
                <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/home.css">
            <%@ include file="fragments/head-assets.jsp" %>
</head>

            <body>
                <!-- Include Navbar -->
                <jsp:include page="/WEB-INF/jsp/fragments/navbar.jsp" />

                <!-- Hero Section -->
                <section class="hero">
                    <div class="au-slides" id="auSlides" aria-roledescription="carousel" aria-label="Hotel highlights">
<div class="au-slide is-active" style="background-image:url('/images/scenes/beach.svg')" data-caption="The Beach"></div>
<div class="au-slide" style="background-image:url('/images/scenes/cove.svg')" data-caption="Golden Hour"></div>
<div class="au-slide" style="background-image:url('/images/scenes/pool.svg')" data-caption="Pool Terrace"></div>
<div class="au-slide" style="background-image:url('/images/scenes/lobby.svg')" data-caption="The Lobby"></div>
<div class="au-slide" style="background-image:url('/images/scenes/facade.svg')" data-caption="The Resort"></div>
</div>
<div class="au-slide-ui"><div class="au-caption" id="auCaption">The Façade</div><div class="au-dots" id="auDots"></div><div class="au-arrows"><button type="button" id="auPrev" aria-label="Previous slide"><i class="ph ph-caret-left"></i></button><button type="button" id="auNext" aria-label="Next slide"><i class="ph ph-caret-right"></i></button></div></div>
<script>
(function(){var w=document.getElementById("auSlides");if(!w)return;var s=w.querySelectorAll(".au-slide"),d=document.getElementById("auDots"),c=document.getElementById("auCaption"),n=0,tm;
s.forEach(function(_,i){var b=document.createElement("button");b.type="button";b.setAttribute("aria-label","Go to slide "+(i+1));b.onclick=function(){go(i,true)};d.appendChild(b)});
function go(i,u){n=(i+s.length)%s.length;s.forEach(function(e,k){e.classList.toggle("is-active",k===n)});[].forEach.call(d.children,function(e,k){e.classList.toggle("on",k===n)});c.textContent=s[n].getAttribute("data-caption");if(u)rs()}
function rs(){clearInterval(tm);if(!window.matchMedia("(prefers-reduced-motion: reduce)").matches)tm=setInterval(function(){go(n+1)},6500)}
document.getElementById("auPrev").onclick=function(){go(n-1,true)};document.getElementById("auNext").onclick=function(){go(n+1,true)};
w.addEventListener("mouseenter",function(){clearInterval(tm)});w.addEventListener("mouseleave",rs);go(0);rs()})();
</script>
                    <div class="hero-overlay"></div>

                    <div class="hero-content" data-aos="fade-up">
                        <div class="hero-subtitle">WELCOME TO AURELIAN</div>
                        <h1 class="hero-title">
                            Welcome To<br>
                            <span>Aurelian Hotel</span>
                        </h1>
                        <p class="hero-description">
                            Where timeless elegance meets modern luxury. Immerse yourself in an unforgettable stay with
                            world-class amenities and exceptional service.
                        </p>
                        <div class="hero-buttons">
                            <a href="${pageContext.request.contextPath}/rooms" class="btn-primary">
                                Explore Rooms <i class="ph ph-arrow-right"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn-secondary">
                                Join Now <i class="ph ph-diamond"></i>
                            </a>
                        </div>
                    </div>
<svg class="au-wave" viewBox="0 0 1600 140" preserveAspectRatio="none" aria-hidden="true"><path d="M0,140 L0,89 L16,89 L32,99 L48,87 L64,86 L80,97 L96,80 L112,87 L128,96 L144,83 L160,103 L176,97 L192,95 L208,96 L224,103 L240,96 L256,76 L272,71 L288,57 L304,66 L320,59 L336,48 L352,68 L368,57 L384,65 L400,79 L416,62 L432,77 L448,73 L464,63 L480,50 L496,56 L512,53 L528,76 L544,72 L560,87 L576,99 L592,97 L608,113 L624,99 L640,110 L656,96 L672,98 L688,82 L704,78 L720,94 L736,96 L752,87 L768,95 L784,87 L800,98 L816,77 L832,85 L848,59 L864,55 L880,57 L896,56 L912,53 L928,54 L944,64 L960,74 L976,76 L992,76 L1008,75 L1024,72 L1040,68 L1056,67 L1072,62 L1088,80 L1104,76 L1120,90 L1136,98 L1152,101 L1168,111 L1184,110 L1200,102 L1216,99 L1232,105 L1248,94 L1264,79 L1280,79 L1296,71 L1312,82 L1328,82 L1344,72 L1360,75 L1376,89 L1392,86 L1408,72 L1424,64 L1440,57 L1456,55 L1472,55 L1488,52 L1504,45 L1520,52 L1536,66 L1552,81 L1568,75 L1584,77 L1600,86 L1600,140 Z" fill="#fff"/><circle cx="1345" cy="50" r="5" fill="#fff"/><circle cx="602" cy="59" r="5" fill="#fff"/><circle cx="1389" cy="36" r="2" fill="#fff"/><circle cx="965" cy="36" r="3" fill="#fff"/><circle cx="1271" cy="21" r="5" fill="#fff"/><circle cx="140" cy="27" r="4" fill="#fff"/><circle cx="284" cy="29" r="5" fill="#fff"/><circle cx="820" cy="45" r="2" fill="#fff"/><circle cx="360" cy="42" r="5" fill="#fff"/><circle cx="1145" cy="31" r="3" fill="#fff"/><circle cx="901" cy="49" r="4" fill="#fff"/><circle cx="1466" cy="40" r="4" fill="#fff"/><circle cx="1418" cy="38" r="3" fill="#fff"/><circle cx="329" cy="19" r="3" fill="#fff"/><circle cx="329" cy="28" r="3" fill="#fff"/><circle cx="44" cy="45" r="3" fill="#fff"/><circle cx="558" cy="32" r="2" fill="#fff"/><circle cx="318" cy="40" r="4" fill="#fff"/><circle cx="1268" cy="50" r="4" fill="#fff"/><circle cx="277" cy="58" r="2" fill="#fff"/><circle cx="955" cy="57" r="5" fill="#fff"/><circle cx="835" cy="39" r="5" fill="#fff"/><circle cx="232" cy="44" r="5" fill="#fff"/><circle cx="147" cy="26" r="2" fill="#fff"/><circle cx="447" cy="42" r="3" fill="#fff"/><circle cx="245" cy="35" r="2" fill="#fff"/></svg>


                    <!--<div class="scroll-indicator">
        <span>SCROLL</span>
        <i class="ph ph-caret-down"></i>
    </div>-->
                </section>

                <!-- Booking Widget -->
                <!--<div class="booking-widget" data-aos="fade-up" data-aos-delay="200">
    <div class="widget-container">
        <div class="widget-field">
            <label><i class="ph ph-calendar-blank" style="color: #2bb3e6; margin-right: 5px;"></i> CHECK-IN</label>
            <input type="datetime-local" class="widget-input" id="homeCheckIn">
        </div>
        <div class="widget-field">
            <label><i class="ph ph-calendar-blank" style="color: #2bb3e6; margin-right: 5px;"></i> CHECK-OUT</label>
            <input type="datetime-local" class="widget-input" id="homeCheckOut">
        </div>
        <div class="widget-field">
            <label><i class="ph ph-users" style="color: #2bb3e6; margin-right: 5px;"></i> GUESTS</label>
            <select class="widget-input">
                <option>1 Guest</option>
                <option>2 Guests</option>
                <option>3 Guests</option>
                <option>4+ Guests</option>
            </select>
        </div>
        <div class="widget-field">
            <label><i class="ph ph-tag" style="color: #2bb3e6; margin-right: 5px;"></i> PROMO CODE</label>
            <input type="text" class="widget-input" placeholder="Enter code">
        </div>
        <button class="widget-btn" onclick="window.location.href='${pageContext.request.contextPath}/rooms'">
            <i class="ph ph-magnifying-glass"></i> Check
        </button>
    </div>
</div>-->

                <!-- Welcome Section -->
                <section class="section" id="welcome">
                    <div class="welcome-grid">
                        <div class="welcome-content" data-aos="fade-right">
                            <div class="section-subtitle">WELCOME TO AURELIAN HOTEL</div>
                            <h2 class="section-title">Where Quiet Luxury Feels Like Home</h2>
                            <p class="section-description" style="margin-bottom: 30px;">
                                Nestled in the heart of the city, Aurelian Hotel offers an unparalleled experience of
                                luxury and sophistication. With over 50 years of excellence in hospitality, we take
                                pride in creating memorable moments for our distinguished guests.
                            </p>

                            <div class="welcome-stats">
                                <div class="stat-item">
                                    <div class="stat-number">124</div>
                                    <div class="stat-label">Luxury Rooms</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">5</div>
                                    <div class="stat-label">Restaurants</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">500+</div>
                                    <div class="stat-label">Happy Guests</div>
                                </div>
                            </div>
                        </div>

                        <div class="welcome-image" data-aos="fade-left">
                            <img src="${pageContext.request.contextPath}/images/scenes/lobby.svg"
                                alt="Aurelian Hotel Lobby">
                        </div>
                    </div>
                </section>

                <!-- Rooms Preview -->
                <section class="section" id="rooms" style="background: var(--au-surface);">
                    <div class="section-header" data-aos="fade-up">
                        <div class="section-subtitle">LUXURY ACCOMMODATIONS</div>
                        <h2 class="section-title">Our Premium Rooms</h2>
                        <p class="section-description">
                            Choose from our selection of elegantly designed rooms and suites, each offering a unique
                            experience of comfort and luxury.
                        </p>
                    </div>

                    <div class="rooms-grid">
                        <c:forEach items="${featuredRooms}" var="room" varStatus="status">
                            <!-- Room ${status.index + 1} -->
                            <c:set var="roomImageUrl">
                                <c:choose>
                                    <c:when test="${not empty room.imagePath}">${pageContext.request.contextPath}/${room.imagePath}</c:when>
                                    <c:otherwise>${pageContext.request.contextPath}/images/rooms/room-${room.id}.jpg</c:otherwise>
                                </c:choose>
                            </c:set>
                            <div class="room-card" data-aos="fade-up" data-aos-delay="${status.index * 100}">
                                <div class="room-image" style="background-image: url('${roomImageUrl}')">
                                    <div class="room-badge">${room.status == 'AVAILABLE' ? 'LUXURY' : room.status}</div>
                                </div>
                                <div class="room-details">
                                    <div class="room-category">${room.roomType}</div>
                                    <h3 class="room-name">${room.roomNumber} - ${room.roomType}</h3>
                                    <div class="room-features">
                                        <span><i class="ph ph-user"></i> ${room.capacity} Guests</span>
                                        <span><i class="ph ph-bed"></i> ${fn:contains(room.roomType, 'King') ? 'King Bed' : 'Queen Bed'}</span>
                                        <span><i class="ph ph-ruler"></i> ${room.roomSize}m²</span>
                                    </div>
                                    <div class="room-price">
                                        $${room.pricePerNight} <span>/ night</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/reservations?roomId=${room.id}"
                                        class="btn-room">
                                        Book Now <i class="ph ph-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty featuredRooms}">
                            <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--au-muted);">
                                <p>No rooms currently available for display.</p>
                            </div>
                        </c:if>
                    </div>

                    <div style="text-align: center; margin-top: 50px;">
                        <a href="${pageContext.request.contextPath}/rooms" class="btn-primary"
                            style="padding: 15px 40px;">
                            View All Rooms <i class="ph ph-arrow-right"></i>
                        </a>
                    </div>
                </section>

                <!-- Amenities Section -->
                <section class="section" id="amenities">
                    <div class="section-header" data-aos="fade-up">
                        <div class="section-subtitle">WORLD-CLASS FACILITIES</div>
                        <h2 class="section-title">Premium Amenities</h2>
                        <p class="section-description">
                            Indulge in our extensive range of luxury amenities designed for your comfort and pleasure.
                        </p>
                    </div>

                    <div class="amenities-grid">
                        <div class="amenity-item" data-aos="fade-up">
                            <div class="amenity-icon"><i class="ph ph-swimming-pool"></i></div>
                            <h3 class="amenity-title">Infinity Pool</h3>
                            <p class="amenity-description">Rooftop pool with panoramic city views</p>
                        </div>
                        <div class="amenity-item" data-aos="fade-up" data-aos-delay="50">
                            <div class="amenity-icon"><i class="ph ph-flower-lotus"></i></div>
                            <h3 class="amenity-title">Luxury Spa</h3>
                            <p class="amenity-description">Traditional treatments and wellness therapies</p>
                        </div>
                        <div class="amenity-item" data-aos="fade-up" data-aos-delay="100">
                            <div class="amenity-icon"><i class="ph ph-fork-knife"></i></div>
                            <h3 class="amenity-title">Fine Dining</h3>
                            <p class="amenity-description">5 restaurants with Michelin-starred chefs</p>
                        </div>
                        <div class="amenity-item" data-aos="fade-up" data-aos-delay="150">
                            <div class="amenity-icon"><i class="ph ph-barbell"></i></div>
                            <h3 class="amenity-title">Fitness Center</h3>
                            <p class="amenity-description">State-of-the-art equipment</p>
                        </div>
                    </div>
                </section>

                <!-- Testimonials -->
                <section class="testimonials">
                    <div class="testimonials-container">
                        <div class="section-header" data-aos="fade-up" style="color: white;">
                            <div class="section-subtitle">GUEST EXPERIENCES</div>
                            <h2 class="section-title" style="color: white;">What Our Guests Say</h2>
                        </div>
                        <div class="testimonials-slider-container">
                            <div class="testimonials-track" id="reviewsTrack">
                                <c:forEach var="review" items="${reviews}">
                                    <div class="slider-card-wrapper">
                                        <div class="testimonial-card" data-aos="fade-up" id="review-card-${review.id}">
                                            <c:if test="${currentUser != null && currentUser.id == review.user.id}">
                                                <button class="edit-review-btn" data-id="${review.id}"
                                                        data-rating="${review.rating}"
                                                        data-comment="${fn:escapeXml(review.comment)}"
                                                        onclick="prepareEditModal(this)">
                                                    <i class="ph ph-pencil-simple-line"></i>
                                                </button>
                                            </c:if>
                                            <c:if test="${currentUser != null && (currentUser.role == 'ADMIN' || currentUser.id == review.user.id)}">
                                                <button class="delete-review-btn" onclick="deleteReview('${review.id}')">
                                                    <i class="ph ph-trash"></i>
                                                </button>
                                            </c:if>
                                            <div class="testimonial-rating" id="rating-display-${review.id}">
                                                <c:forEach begin="1" end="${review.rating}">
                                                    <i class="ph ph-star"></i>
                                                </c:forEach>
                                                <c:forEach begin="${review.rating + 1}" end="5">
                                                    <i class="ph ph-star" style="opacity: 0.3;"></i>
                                                </c:forEach>
                                            </div>
                                            <p class="testimonial-text" id="comment-display-${review.id}">"${review.comment}"
                                            </p>
                                            <div class="testimonial-author">
                                                <div class="author-avatar">${review.user.username.substring(0,1).toUpperCase()}
                                                </div>
                                                <div class="author-info">
                                                    <h4>${review.user.username}</h4>
                                                    <p>${review.createdAt.toLocalDate()}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Slider Controls -->
                        <div class="slider-controls">
                            <button class="slider-btn" id="prevBtn" onclick="moveSlider(-1)">
                                <i class="ph ph-caret-left"></i>
                            </button>
                            <button class="slider-btn" id="nextBtn" onclick="moveSlider(1)">
                                <i class="ph ph-caret-right"></i>
                            </button>
                        </div>

                        <!-- View All Button -->
                        <div class="view-all-reviews-wrapper">
                            <a href="/reviews/all" class="btn-view-all">
                                View All Reviews <i class="ph ph-arrow-square-out"></i>
                            </a>
                        </div>

                        <!-- Review Form -->
                        <c:choose>
<c:when test="${currentUser == null}">
<div style="text-align: center; margin-top: 40px;">
                                <p style="color: rgba(255, 255, 255,0.6);">Please <a href="/login"
                                        style="color: #2bb3e6; text-decoration: none; font-weight: 600;">login</a> to
                                    leave a review.</p>
                            </div>
</c:when>
<c:when test="${canReview}">
<div class="review-form-container" data-aos="fade-up">
                                <h3
                                    style="text-align: center; margin-bottom: 20px; font-family: 'Montserrat', serif;">
                                    Share Your Experience</h3>
                                <form action="/reviews" method="POST">
                                    <div class="star-rating">
                                        <input type="radio" id="star5" name="rating" value="5" required /><label
                                            for="star5" title="5 stars"><i class="ph ph-star"></i></label>
                                        <input type="radio" id="star4" name="rating" value="4" /><label for="star4"
                                            title="4 stars"><i class="ph ph-star"></i></label>
                                        <input type="radio" id="star3" name="rating" value="3" /><label for="star3"
                                            title="3 stars"><i class="ph ph-star"></i></label>
                                        <input type="radio" id="star2" name="rating" value="2" /><label for="star2"
                                            title="2 stars"><i class="ph ph-star"></i></label>
                                        <input type="radio" id="star1" name="rating" value="1" /><label for="star1"
                                            title="1 star"><i class="ph ph-star"></i></label>
                                    </div>
                                    <textarea name="comment" class="review-textarea" placeholder="Describe your stay..."
                                        required></textarea>
                                    <button type="submit" class="btn-primary"
                                        style="width: 100%; justify-content: center;">SUBMIT REVIEW</button>
                                </form>
                            </div>
</c:when>
<c:otherwise>
<div class="review-notice" data-aos="fade-up">
<i class="ph ph-moon-stars"></i>
<h3>Share Your Experience</h3>
<p>${reviewNotice}</p>
</div>
</c:otherwise>
</c:choose>
                    </div>
                </section>

                <!-- Edit Review Modal -->
                <div id="editReviewModal" class="review-modal">
                    <div class="modal-content">
                        <span class="close-modal" onclick="closeEditModal()">&times;</span>
                        <h3
                            style="color: white; margin-bottom: 25px; font-family: 'Montserrat', serif; text-align: center;">
                            Modify Your Review</h3>
                        <form id="editReviewForm">
                            <input type="hidden" id="editReviewId">
                            <div class="star-rating" style="margin-bottom: 30px;">
                                <input type="radio" id="edit-star5" name="editRating" value="5" /><label
                                    for="edit-star5" title="5 stars"><i class="ph ph-star"></i></label>
                                <input type="radio" id="edit-star4" name="editRating" value="4" /><label
                                    for="edit-star4" title="4 stars"><i class="ph ph-star"></i></label>
                                <input type="radio" id="edit-star3" name="editRating" value="3" /><label
                                    for="edit-star3" title="3 stars"><i class="ph ph-star"></i></label>
                                <input type="radio" id="edit-star2" name="editRating" value="2" /><label
                                    for="edit-star2" title="2 stars"><i class="ph ph-star"></i></label>
                                <input type="radio" id="edit-star1" name="editRating" value="1" /><label
                                    for="edit-star1" title="1 star"><i class="ph ph-star"></i></label>
                            </div>
                            <textarea id="editComment" class="review-textarea" rows="5" required></textarea>
                            <button type="submit" class="btn-primary" style="width: 100%; justify-content: center;">SAVE
                                CHANGES</button>
                        </form>
                    </div>
                </div>

                <!-- CTA Section -->
                <section class="cta-section">
                    <div class="section-header" data-aos="fade-up">
                        <h2 class="cta-title">Your Room Is Waiting</h2>
                        <p class="cta-description">Join our VIP program and get 20% off your first stay.</p>
                        <a href="${pageContext.request.contextPath}/register" class="cta-button">
                            Become a Member <i class="ph ph-arrow-right"></i>
                        </a>
                    </div>
                </section>

                <!-- Include Footer -->
                <jsp:include page="/WEB-INF/jsp/fragments/footer.jsp" />

                <!-- Scripts -->
                <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
                <script>
                    AOS.init({ duration: 1000, once: true, offset: 100 });

                    // Re-Re-Recreated Slider Logic (Hyper-Robust)
                    let currentLogicalIndex = 0;

                    function updateMiddleCard() {
                        const cards = document.querySelectorAll('.slider-card-wrapper');
                        const visibleCards = window.innerWidth > 992 ? 3 : (window.innerWidth > 768 ? 2 : 1);
                        
                        cards.forEach((c, idx) => {
                            c.classList.remove('active-middle');
                            
                            let isMiddle = false;
                            if (visibleCards === 3) {
                                isMiddle = (idx === currentLogicalIndex + 1);
                            } else if (visibleCards === 1) {
                                isMiddle = (idx === currentLogicalIndex);
                            } else {
                                // 2 cards: highlight the first one or both? Let's do first.
                                isMiddle = (idx === currentLogicalIndex);
                            }
                            
                            if (isMiddle) c.classList.add('active-middle');
                        });
                    }

                    function moveSlider(direction) {
                        const container = document.querySelector('.testimonials-slider-container');
                        const card = document.querySelector('.slider-card-wrapper');
                        const cards = document.querySelectorAll('.slider-card-wrapper');
                        
                        if (!container || !card) return;
                        
                        const visibleCards = window.innerWidth > 992 ? 3 : (window.innerWidth > 768 ? 2 : 1);
                        const maxIndex = Math.max(0, cards.length - visibleCards);
                        
                        let nextIndex = currentLogicalIndex + direction;
                        if (nextIndex < 0) nextIndex = 0;
                        if (nextIndex > maxIndex) nextIndex = maxIndex;
                        
                        if (nextIndex === currentLogicalIndex) return;
                        
                        currentLogicalIndex = nextIndex;
                        
                        const cardWidth = card.offsetWidth;
                        const gap = 30;
                        const shift = currentLogicalIndex * (cardWidth + gap);
                        
                        // Scroll to precise position
                        container.scrollTo({
                            left: shift,
                            behavior: 'smooth'
                        });
                        
                        updateMiddleCard();
                        
                        // Update button visibility
                        setTimeout(() => {
                            const prevBtn = document.getElementById('prevBtn');
                            const nextBtn = document.getElementById('nextBtn');
                            if (prevBtn) prevBtn.style.opacity = currentLogicalIndex === 0 ? '0.3' : '1';
                            if (nextBtn) nextBtn.style.opacity = currentLogicalIndex >= maxIndex ? '0.3' : '1';
                        }, 400);
                    }

                    // Initialization & Scaling
                    function initSlider() {
                        const container = document.querySelector('.testimonials-slider-container');
                        const track = document.getElementById('reviewsTrack');
                        const cards = document.querySelectorAll('.slider-card-wrapper');
                        
                        if (!container || !track || !cards.length) return;
                        
                        const containerWidth = container.offsetWidth;
                        const visibleCards = window.innerWidth > 992 ? 3 : (window.innerWidth > 768 ? 2 : 1);
                        const gap = 30;
                        
                        const cardWidth = (containerWidth - (gap * (visibleCards - 1))) / visibleCards;
                        
                        cards.forEach(c => {
                            c.style.minWidth = cardWidth + 'px';
                            c.style.flex = `0 0 ${cardWidth}px`;
                        });
                        
                        container.style.overflowX = 'hidden';
                        container.style.display = 'block';
                        
                        updateMiddleCard();
                    }

                    window.addEventListener('resize', initSlider);
                    window.addEventListener('load', initSlider);
                    setTimeout(initSlider, 500);
                    setTimeout(initSlider, 2000);

                    // Set initial values for home booking widget
                    const now = new Date();
                    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
                    document.getElementById('homeCheckIn').value = now.toISOString().slice(0, 16);

                    const tomorrow = new Date(now);
                    tomorrow.setDate(tomorrow.getDate() + 3);
                    document.getElementById('homeCheckOut').value = tomorrow.toISOString().slice(0, 16);

                    async function deleteReview(id) {
                        if (!confirm('Are you sure you want to delete this review?')) return;

                        try {
                            const response = await fetch('/reviews/delete/' + id, { method: 'POST' });
                            const result = await response.json();

                            if (response.ok) {
                                const element = document.getElementById('review-card-' + id);
                                element.style.opacity = '0';
                                element.style.transform = 'scale(0.8)';
                                setTimeout(() => element.remove(), 400);
                            } else {
                                alert(result.message || 'Error deleting review');
                            }
                        } catch (error) {
                            alert('An error occurred. Please try again.');
                        }
                    }

                    function prepareEditModal(button) {
                        const id = button.getAttribute('data-id');
                        const rating = button.getAttribute('data-rating');
                        const comment = button.getAttribute('data-comment');
                        openEditModal(id, rating, comment);
                    }

                    function openEditModal(id, rating, comment) {
                        document.getElementById('editReviewId').value = id;
                        document.getElementById('editComment').value = comment;
                        if (document.getElementById('edit-star' + rating)) {
                            document.getElementById('edit-star' + rating).checked = true;
                        }
                        document.getElementById('editReviewModal').style.display = 'flex';
                    }

                    function closeEditModal() {
                        document.getElementById('editReviewModal').style.display = 'none';
                    }

                    document.getElementById('editReviewForm').onsubmit = async function (e) {
                        e.preventDefault();
                        const id = document.getElementById('editReviewId').value;
                        const rating = document.querySelector('input[name="editRating"]:checked').value;
                        const comment = document.getElementById('editComment').value;

                        const formData = new FormData();
                        formData.append('rating', rating);
                        formData.append('comment', comment);

                        try {
                            const response = await fetch('/reviews/edit/' + id, {
                                method: 'POST',
                                body: formData
                            });
                            const result = await response.json();

                            if (response.ok) {
                                // Update the UI instantly
                                document.getElementById('comment-display-' + id).innerText = '"' + result.comment + '"';

                                const ratingDisplay = document.getElementById('rating-display-' + id);
                                ratingDisplay.innerHTML = '';
                                for (let i = 1; i <= 5; i++) {
                                    const icon = document.createElement('i');
                                    if (i <= result.rating) {
                                        icon.className = 'ph ph-star';
                                    } else {
                                        icon.className = 'ph ph-star';
                                        icon.style.opacity = '0.3';
                                    }
                                    ratingDisplay.appendChild(icon);
                                }

                                // Update the button data attributes for future edits
                                const editBtn = document.querySelector(`#review-card-${id} .edit-review-btn`);
                                if (editBtn) {
                                    editBtn.setAttribute('data-rating', result.rating);
                                    editBtn.setAttribute('data-comment', result.comment);
                                }

                                closeEditModal();
                            } else {
                                alert(result.message || 'Error updating review');
                            }
                        } catch (error) {
                            alert('An error occurred. Please try again.');
                        }
                    };

                    // Close modal when clicking outside
                    window.onclick = function (event) {
                        if (event.target == document.getElementById('editReviewModal')) {
                            closeEditModal();
                        }
                    }
                </script>
            </body>

            </html>