<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Boxicons (for Brands) -->
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- AOS Animation -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <!-- Leaflet Maps -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/contact.css">
<%@ include file="fragments/head-assets.jsp" %>
</head>
<body>
<!-- Include Navbar -->
<jsp:include page="/WEB-INF/jsp/fragments/navbar.jsp" />

<!-- Page Header -->
<section class="page-header">
    <div class="page-header-content" data-aos="fade-up">
        <h1>Contact Us</h1>
        <p>We're here to make your stay exceptional. Reach out to us for any inquiries, reservations, or special requests.</p>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <i class="ph ph-caret-right" style="color: #2bb3e6;"></i>
            <span>Contact</span>
        </div>
    </div>
</section>

<!-- Main Content -->
<div class="main-content">
    <!-- Contact Cards -->
    <div class="contact-cards">
        <div class="contact-card" data-aos="fade-up">
            <div class="card-icon">
                <i class="ph ph-phone"></i>
            </div>
            <h3>Phone</h3>
            <p>Reservations</p>
            <p class="highlight">+1 (555) 014-2290</p>
            <p>Front Desk</p>
            <p class="highlight">+1 (555) 014-2291</p>
        </div>

        <div class="contact-card" data-aos="fade-up" data-aos-delay="100">
            <div class="card-icon">
                <i class="ph ph-envelope-simple"></i>
            </div>
            <h3>Email</h3>
            <p>General Inquiries</p>
            <p class="highlight">info@aurelianhotel.com</p>
            <p>Reservations</p>
            <p class="highlight">reservations@aurelianhotel.com</p>
        </div>

        <div class="contact-card" data-aos="fade-up" data-aos-delay="200">
            <div class="card-icon">
                <i class="ph ph-map-pin"></i>
            </div>
            <h3>Location</h3>
            <p>48 Alder Court</p>
            <p>Beverly Hills, CA 90210</p>
            <p class="highlight">United States</p>
        </div>

        <div class="contact-card" data-aos="fade-up" data-aos-delay="300">
            <div class="card-icon">
                <i class="ph ph-clock"></i>
            </div>
            <h3>24/7 Concierge</h3>
            <p>Front Desk</p>
            <p class="highlight">Always Open</p>
            <p>Customer Support</p>
            <p class="highlight">Round the Clock</p>
        </div>
    </div>

    <!-- Contact Grid -->
    <div class="contact-grid">
        <!-- Contact Form -->
        <div class="contact-form-container" data-aos="fade-right">
            <div class="form-header">
                <h2>Send Us a Message</h2>
                <p>We'll get back to you within 24 hours</p>
            </div>

            <div class="success-message" id="successMessage">
                <i class="ph ph-check-circle"></i> Thank you for contacting us! We'll respond shortly.
            </div>

            <form id="contactForm" onsubmit="return submitForm(event)">
                <div class="form-row">
                    <div class="form-group">
                        <label>First Name</label>
                        <div class="input-wrapper">
                            <i class="ph ph-user"></i>
                            <input type="text" placeholder="John" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Last Name</label>
                        <div class="input-wrapper">
                            <i class="ph ph-user"></i>
                            <input type="text" placeholder="Doe" required>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Email</label>
                        <div class="input-wrapper">
                            <i class="ph ph-envelope-simple"></i>
                            <input type="email" placeholder="john@example.com" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <div class="input-wrapper">
                            <i class="ph ph-phone"></i>
                            <input type="tel" placeholder="+1 (555) 014-2290">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Subject</label>
                    <div class="input-wrapper">
                        <i class="ph ph-tag"></i>
                        <select required>
                            <option value="" disabled selected>Select a subject</option>
                            <option>Room Reservation</option>
                            <option>Event Booking</option>
                            <option>Wedding Inquiry</option>
                            <option>Corporate Event</option>
                            <option>General Inquiry</option>
                            <option>Feedback</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Message</label>
                    <div class="input-wrapper">
                        <i class="ph ph-chat-circle"></i>
                        <textarea placeholder="Tell us how we can help you..." required></textarea>
                    </div>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="ph ph-paper-plane-tilt"></i>
                    Send Message
                </button>
            </form>
        </div>

        <!-- Map Section -->
        <div class="map-section" data-aos="fade-left">
            <div class="map-header">
                <h2>Find Us Here</h2>
                <p><i class="ph ph-map-pin" style="color: #2bb3e6;"></i> 48 Alder Court, Beverly Hills, CA 90210</p>
            </div>
            <div id="map"></div>
        </div>
    </div>

    <!-- Business Hours -->
    <div class="hours-section" data-aos="fade-up">
        <div class="hours-grid">
            <div>
                <div class="hours-header">
                    <h2>Business Hours</h2>
                    <p>We're always here to serve you</p>
                </div>
                <ul class="hours-list">
                    <li class="hours-item">
                        <span class="hours-day">Monday - Friday</span>
                        <span class="hours-time">24 Hours</span>
                    </li>
                    <li class="hours-item">
                        <span class="hours-day">Saturday</span>
                        <span class="hours-time">24 Hours</span>
                    </li>
                    <li class="hours-item">
                        <span class="hours-day">Sunday</span>
                        <span class="hours-time">24 Hours</span>
                    </li>
                    <li class="hours-item">
                        <span class="hours-day">Public Holidays</span>
                        <span class="hours-time">24 Hours</span>
                    </li>
                </ul>
            </div>

            <div>
                <div class="hours-header">
                    <h2>Special Services</h2>
                    <p>Dedicated assistance for special occasions</p>
                </div>
                <div class="special-note">
                    <p><i class="ph ph-champagne"></i> <strong>Wedding Consultation:</strong> Mon-Sat, 10 AM - 6 PM</p>
                </div>
                <div class="special-note" style="margin-top: 15px;">
                    <p><i class="ph ph-briefcase"></i> <strong>Corporate Events:</strong> By appointment only</p>
                </div>
                <div class="special-note" style="margin-top: 15px;">
                    <p><i class="ph ph-fork-knife"></i> <strong>Restaurant Reservations:</strong> 7 AM - 11 PM</p>
                </div>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="faq-section" data-aos="fade-up">
        <div class="faq-header">
            <h2>Frequently Asked Questions</h2>
            <p>Quick answers to common questions about contacting us</p>
        </div>

        <div class="faq-grid">
            <div class="faq-item">
                <div class="faq-question">
                    <i class="ph ph-question"></i>
                    <h3>How quickly do you respond?</h3>
                </div>
                <div class="faq-answer">
                    We typically respond to all inquiries within 2-4 hours during business hours, and within 12 hours during off-hours.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <i class="ph ph-question"></i>
                    <h3>Can I make a reservation via email?</h3>
                </div>
                <div class="faq-answer">
                    Yes, you can email reservations@aurelianhotel.com. For immediate confirmation, we recommend calling our reservation desk.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <i class="ph ph-question"></i>
                    <h3>Do you have 24/7 front desk?</h3>
                </div>
                <div class="faq-answer">
                    Yes! Our front desk is staffed 24/7/365 to assist you with any needs during your stay.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <i class="ph ph-question"></i>
                    <h3>How do I cancel a booking?</h3>
                </div>
                <div class="faq-answer">
                    You can cancel by calling our reservation line or emailing us with your booking reference number.
                </div>
            </div>
        </div>
    </div>

    <!-- Social Connect -->
    <div class="social-connect" data-aos="fade-up">
        <h2>Connect With Us</h2>
        <div class="social-links-large">
            <a href="#" class="social-link-large"><i class="bx bxl-facebook"></i></a>
            <a href="#" class="social-link-large"><i class="bx bxl-twitter"></i></a>
            <a href="#" class="social-link-large"><i class="bx bxl-instagram"></i></a>
            <a href="#" class="social-link-large"><i class="bx bxl-linkedin"></i></a>
            <a href="#" class="social-link-large"><i class="bx bxl-youtube"></i></a>
            <a href="#" class="social-link-large"><i class="bx bxl-trip-advisor"></i></a>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="/WEB-INF/jsp/fragments/footer.jsp" />

<!-- Scripts -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<script>
    // Initialize AOS
    AOS.init({
        duration: 800,
        once: true,
        offset: 50
    });

    // Initialize Map
    var map = L.map('map').setView([34.0736, -118.4004], 15); // Beverly Hills coordinates

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(map);

    // Add custom marker
    var customIcon = L.divIcon({
        className: 'custom-marker',
        html: '<div style="background: #2bb3e6; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 3px solid white; box-shadow: 0 5px 15px rgba(0, 0, 0,0.3);"><i class="ph ph-buildings" style="color: white; font-size: 18px;"></i></div>',
        iconSize: [40, 40],
        iconAnchor: [20, 40]
    });

    L.marker([34.0736, -118.4004], { icon: customIcon }).addTo(map)
        .bindPopup('<b>Aurelian Hotel</b><br>48 Alder Court<br>Beverly Hills, CA 90210')
        .openPopup();

    // Form submission handler
    function submitForm(event) {
        event.preventDefault();

        // Show success message
        document.getElementById('successMessage').classList.add('show');

        // Reset form
        document.getElementById('contactForm').reset();

        // Hide message after 5 seconds
        setTimeout(function() {
            document.getElementById('successMessage').classList.remove('show');
        }, 5000);

        return false;
    }

    // Add animation to contact cards
    document.querySelectorAll('.contact-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-15px)';
        });
    });

    // Floating animation for contact cards
    setInterval(() => {
        document.querySelectorAll('.contact-card').forEach((card, index) => {
            setTimeout(() => {
                card.style.animation = 'none';
                setTimeout(() => {
                    card.style.animation = 'float 4s ease-in-out infinite';
                }, 100);
            }, index * 200);
        });
    }, 8000);
</script>

</body>
</html>