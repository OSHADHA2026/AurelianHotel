<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest Reviews · Aurelian Hotel</title>
    <link rel="icon" type="image/png" href="/favicon.png">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/reviews.css">
<%@ include file="fragments/head-assets.jsp" %>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/fragments/navbar.jsp" />

    <header class="hero-mini">
        <div data-aos="fade-up">
            <h1 class="hero-title">Guest Stories</h1>
            <p style="color: #2bb3e6; letter-spacing: 4px; text-transform: uppercase; font-weight: 600;">Authentic Experiences at Aurelian Hotel</p>
        </div>
    </header>

    <main class="section">
        <div class="filter-container" data-aos="fade-up">
            <button class="filter-btn active" data-type="all" onclick="filterReviews('all', this)">
                <i class="ph ph-squares-four"></i> All Stories
            </button>
            <c:if test="${currentUser != null}">
                <button class="filter-btn" data-type="mine" onclick="filterReviews('mine', this)">
                    <i class="ph ph-user-circle"></i> My Reviews
                </button>
            </c:if>
            
            <div class="dropdown-filter">
                <select id="starFilter" onchange="handleDropdownChange(this)" class="filter-select">
                    <option value="all">Filter by Rating</option>
                    <option value="r-5">★★★★★ (5 Stars)</option>
                    <option value="r-4">★★★★ (4 Stars)</option>
                    <option value="r-3">★★★ (3 Stars)</option>
                    <option value="r-2">★★ (2 Stars)</option>
                    <option value="r-1">★ (1 Star)</option>
                </select>
                <i class="ph ph-caret-down select-icon"></i>
            </div>
        </div>

        <div class="reviews-grid" id="reviewsGrid">
            <c:forEach var="review" items="${reviews}">
                <div class="testimonial-card" 
                     data-aos="fade-up" 
                     data-user-id="${review.user.id}" 
                     data-rating="${review.rating}" 
                     id="review-card-${review.id}">
                    
                    <c:if test="${currentUser != null && (currentUser.id == review.user.id || currentUser.role == 'ADMIN')}">
                        <div class="actions">
                            <c:if test="${currentUser.id == review.user.id}">
                                <button class="action-btn edit-btn" 
                                        data-id="${review.id}"
                                        data-rating="${review.rating}"
                                        data-comment="${fn:escapeXml(review.comment)}"
                                        onclick="prepareEditModal(this)">
                                    <i class="ph ph-pencil-simple-line"></i>
                                </button>
                            </c:if>
                            <button class="action-btn delete-btn" onclick="deleteReview('${review.id}')">
                                <i class="ph ph-trash"></i>
                            </button>
                        </div>
                    </c:if>

                    <div class="testimonial-rating" id="rating-display-${review.id}">
                        <c:forEach begin="1" end="${review.rating}">
                            <i class="ph ph-star"></i>
                        </c:forEach>
                        <c:forEach begin="${review.rating + 1}" end="5">
                            <i class="ph ph-star" style="opacity: 0.3;"></i>
                        </c:forEach>
                    </div>
                    <p class="testimonial-text" id="comment-display-${review.id}">"${review.comment}"</p>
                    <div class="testimonial-author">
                        <div class="author-avatar">${review.user.getAvatarInitials()}</div>
                        <div class="author-info">
                            <h4>${review.user.username}</h4>
                            <p>${review.createdAt.toLocalDate()}</p>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <div id="noResults" style="display: none; text-align: center; padding: 120px 20px; background: var(--au-surface); border-radius: 9px; border: 1px dashed #dce9f1; margin-top: 40px;">
            <div style="width: 80px; height: 80px; background: var(--au-soft); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 25px;">
                <i class="ph ph-chat-circle-slash" style="font-size: 32px; color: #cdd6df;"></i>
            </div>
            <h3 style="font-family: 'Montserrat', serif; font-size: 24px; color: var(--au-text); margin-bottom: 10px;">No Reviews Found</h3>
            <p style="color: var(--au-muted); font-size: 16px; max-width: 400px; margin: 0 auto 30px;">We couldn't find any reviews matching your current filter. Try selecting a different star rating or view all stories.</p>
            <button onclick="filterReviews('all', document.querySelector('.filter-btn[data-type=\'all\']'))" 
                    style="padding: 12px 30px; background: #2bb3e6; color: white; border: none; border-radius: 50px; font-weight: 600; cursor: pointer; transition: all 0.3s;">
                Show All Reviews
            </button>
        </div>
    </main>

    <!-- Edit Review Modal -->
    <div id="editReviewModal" class="review-modal">
        <div class="modal-content">
            <span style="position: absolute; top: 20px; right: 25px; cursor: pointer; font-size: 24px;" onclick="closeEditModal()">&times;</span>
            <h3 style="margin-bottom: 25px; font-family: 'Montserrat', serif; text-align: center;">Modify Your Review</h3>
            <form id="editReviewForm">
                <input type="hidden" id="editReviewId">
                <div class="star-rating">
                    <input type="radio" id="edit-star5" name="editRating" value="5" /><label for="edit-star5"><i class="ph ph-star"></i></label>
                    <input type="radio" id="edit-star4" name="editRating" value="4" /><label for="edit-star4"><i class="ph ph-star"></i></label>
                    <input type="radio" id="edit-star3" name="editRating" value="3" /><label for="edit-star3"><i class="ph ph-star"></i></label>
                    <input type="radio" id="edit-star2" name="editRating" value="2" /><label for="edit-star2"><i class="ph ph-star"></i></label>
                    <input type="radio" id="edit-star1" name="editRating" value="1" /><label for="edit-star1"><i class="ph ph-star"></i></label>
                </div>
                <textarea id="editComment" class="review-textarea" rows="5" required></textarea>
                <button type="submit" class="btn-submit">SAVE CHANGES</button>
            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/jsp/fragments/footer.jsp" />

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({ duration: 1000, once: true });

        const currentUserId = '${currentUser != null ? currentUser.id : ""}';

        function handleDropdownChange(select) {
            const val = select.value;
            // Deactivate other buttons
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            filterReviews(val, null);
        }

        function filterReviews(type, btn) {
            // Update active button if provided
            if (btn) {
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                // Reset dropdown if button was clicked
                document.getElementById('starFilter').value = 'all';
            }

            const cards = document.querySelectorAll('.testimonial-card');
            let count = 0;

            cards.forEach(card => {
                let show = false;
                if (type === 'all') {
                    show = true;
                } else if (type === 'mine') {
                    show = card.getAttribute('data-user-id') === currentUserId;
                } else if (type.startsWith('r-')) {
                    const rating = type.split('-')[1];
                    show = card.getAttribute('data-rating') === rating;
                }

                if (show) {
                    card.style.display = 'flex';
                    count++;
                } else {
                    card.style.display = 'none';
                }
            });

            document.getElementById('noResults').style.display = count === 0 ? 'block' : 'none';
        }

        async function deleteReview(id) {
            if (!confirm('Are you sure you want to delete this review?')) return;

            try {
                const response = await fetch('/reviews/delete/' + id, { method: 'POST' });
                if (response.ok) {
                    const element = document.getElementById('review-card-' + id);
                    element.style.opacity = '0';
                    element.style.transform = 'scale(0.8)';
                    setTimeout(() => element.remove(), 400);
                }
            } catch (error) {
                alert('An error occurred.');
            }
        }

        function prepareEditModal(button) {
            const id = button.getAttribute('data-id');
            const rating = button.getAttribute('data-rating');
            const comment = button.getAttribute('data-comment');
            
            document.getElementById('editReviewId').value = id;
            document.getElementById('editComment').value = comment;
            const star = document.getElementById('edit-star' + rating);
            if (star) star.checked = true;
            
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
                const response = await fetch('/reviews/edit/' + id, { method: 'POST', body: formData });
                const result = await response.json();

                if (response.ok) {
                    // Update UI
                    document.getElementById('comment-display-' + id).innerText = '"' + result.comment + '"';
                    const ratingDisplay = document.getElementById('rating-display-' + id);
                    ratingDisplay.innerHTML = '';
                    for (let i = 1; i <= 5; i++) {
                        const icon = document.createElement('i');
                        icon.className = i <= result.rating ? 'ph ph-star' : 'ph ph-star';
                        if (i > result.rating) icon.style.opacity = '0.3';
                        ratingDisplay.appendChild(icon);
                    }
                    
                    const card = document.getElementById('review-card-' + id);
                    card.setAttribute('data-rating', result.rating);
                    const editBtn = card.querySelector('.edit-btn');
                    editBtn.setAttribute('data-rating', result.rating);
                    editBtn.setAttribute('data-comment', result.comment);

                    closeEditModal();
                }
            } catch (error) {
                alert('An error occurred.');
            }
        };

        window.onclick = function(event) {
            if (event.target == document.getElementById('editReviewModal')) closeEditModal();
        }
    </script>
</body>
</html>
