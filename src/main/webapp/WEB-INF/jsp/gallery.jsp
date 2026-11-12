<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gallery · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/gallery.css">
<%@ include file="fragments/head-assets.jsp" %>
</head>
<body>
<!-- Include Navbar -->
<jsp:include page="/WEB-INF/jsp/fragments/navbar.jsp" />

<!-- Simple Header -->
<div class="page-header">
    <h1>Hotel Gallery</h1>
    <p>Take a visual tour of our beautiful property</p>
</div>

<!-- Main Content -->
<div class="main-content">
    <!-- Simple Filter -->
    <div class="filter-container">
        <span class="filter-btn active" onclick="filterGallery('all')">All</span>
        <span class="filter-btn" onclick="filterGallery('rooms')">Rooms</span>
        <span class="filter-btn" onclick="filterGallery('dining')">Dining</span>
        <span class="filter-btn" onclick="filterGallery('spa')">Spa</span>
        <span class="filter-btn" onclick="filterGallery('exterior')">Exterior</span>
    </div>

    <!-- Gallery Grid -->
    <div class="gallery-grid" id="gallery">
        <!-- Rooms -->
        <div class="gallery-item" data-category="rooms" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/suite.svg" alt="Presidential Suite">
            <div class="gallery-overlay">
                <h3>Presidential Suite</h3>
                <p>Luxury living with city views</p>
            </div>
        </div>

        <div class="gallery-item" data-category="rooms" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/suite.svg" alt="Deluxe Room">
            <div class="gallery-overlay">
                <h3>Deluxe King Room</h3>
                <p>Comfort and elegance</p>
            </div>
        </div>

        <div class="gallery-item" data-category="rooms" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/lobby.svg" alt="Executive Suite">
            <div class="gallery-overlay">
                <h3>Executive Suite</h3>
                <p>Perfect for business travelers</p>
            </div>
        </div>

        <!-- Dining -->
        <!-- Dining - 3 Working Images -->
        <div class="gallery-item" data-category="dining" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/lounge.svg" alt="Sky Lounge">
            <div class="gallery-overlay">
                <h3>Sky Lounge</h3>
                <p>Rooftop bar with panoramic city views</p>
            </div>
        </div>

        <div class="gallery-item" data-category="dining" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/dining.svg" alt="Wine Bar">
            <div class="gallery-overlay">
                <h3>Wine Cellar</h3>
                <p>Extensive collection of fine wines</p>
            </div>
        </div>

        <div class="gallery-item" data-category="dining" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/dining.svg" alt="Fine Dining Restaurant">
            <div class="gallery-overlay">
                <h3>Main Restaurant</h3>
                <p>Elegant fine dining experience</p>
            </div>
        </div>

        <!-- Spa -->
        <div class="gallery-item" data-category="spa" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/spa.svg" alt="Massage Therapy">
            <div class="gallery-overlay">
                <h3>Massage Room</h3>
                <p>Professional treatments</p>
            </div>
        </div>

        <div class="gallery-item" data-category="spa" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/pool.svg" alt="Relaxation Area">
            <div class="gallery-overlay">
                <h3>Relaxation Lounge</h3>
                <p>Peaceful retreat</p>
            </div>
        </div>

        <div class="gallery-item" data-category="spa" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/spa.svg" alt="Spa Ambiance">
            <div class="gallery-overlay">
                <h3>Spa Ambiance</h3>
                <p>Calming atmosphere</p>
            </div>
        </div>


        <!-- Exterior -->

        <div class="gallery-item" data-category="exterior" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/facade.svg" alt="Luxury Hotel Exterior">
            <div class="gallery-overlay">
                <h3>Hotel Entrance</h3>
                <p>Grand entrance with fountain and palm trees</p>
            </div>
        </div>

        <div class="gallery-item" data-category="exterior" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/facade.svg" alt="Hotel Building">
            <div class="gallery-overlay">
                <h3>Main Building</h3>
                <p>Elegant architecture with modern design</p>
            </div>
        </div>

        <div class="gallery-item" data-category="exterior" onclick="openLightbox(this)">
            <img src="${pageContext.request.contextPath}/images/scenes/garden.svg" alt="Hotel Garden">
            <div class="gallery-overlay">
                <h3>Garden Terrace</h3>
                <p>Beautiful landscaped gardens with seating</p>
            </div>
        </div>
    </div>
</div>

<!-- Simple Lightbox -->
<div class="lightbox" id="lightbox" onclick="closeLightbox()">
    <span class="lightbox-close">&times;</span>
    <img id="lightbox-img" src="" alt="">
    <div class="lightbox-caption" id="lightbox-caption"></div>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/jsp/fragments/footer.jsp" />

<!-- Simple JavaScript -->
<script>
    // Filter gallery
    function filterGallery(category) {
        const items = document.querySelectorAll('.gallery-item');
        const buttons = document.querySelectorAll('.filter-btn');

        // Update active button
        buttons.forEach(btn => {
            btn.classList.remove('active');
            if(btn.textContent.toLowerCase().includes(category) ||
                (category === 'all' && btn.textContent === 'All')) {
                btn.classList.add('active');
            }
        });

        // Filter items
        items.forEach(item => {
            if(category === 'all' || item.dataset.category === category) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    }

    // Lightbox functions
    function openLightbox(element) {
        const lightbox = document.getElementById('lightbox');
        const img = lightbox.querySelector('#lightbox-img');
        const caption = lightbox.querySelector('#lightbox-caption');
        const overlay = element.querySelector('.gallery-overlay');

        img.src = element.querySelector('img').src;
        caption.textContent = overlay ? overlay.querySelector('h3').textContent : '';

        lightbox.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeLightbox() {
        const lightbox = document.getElementById('lightbox');
        lightbox.classList.remove('active');
        document.body.style.overflow = 'auto';
    }

    // Close lightbox with ESC key
    document.addEventListener('keydown', function(e) {
        if(e.key === 'Escape') {
            closeLightbox();
        }
    });
</script>
</body>
</html>