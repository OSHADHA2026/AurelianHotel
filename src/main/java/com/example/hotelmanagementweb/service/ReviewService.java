package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.Review;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.repository.BookingRepository;
import com.example.hotelmanagementweb.repository.ReviewRepository;
import com.example.hotelmanagementweb.repository.UserRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

@Service
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final BookingRepository bookingRepository;

    public static final String MSG_NO_COMPLETED_STAY =
            "Reviews are open to guests who have completed a stay of at least one night. "
            + "Your review will unlock after your first check-out.";
    public static final String MSG_ALREADY_REVIEWED =
            "You have already shared your review. You can edit or delete it from the reviews page.";
    public static final String MSG_LOGIN_REQUIRED = "Please login to post a review.";

    public ReviewService(ReviewRepository reviewRepository, UserRepository userRepository,
                         BookingRepository bookingRepository) {
        this.reviewRepository = reviewRepository;
        this.userRepository = userRepository;
        this.bookingRepository = bookingRepository;
    }

    @PostConstruct
    public void seedData() {
        if (reviewRepository.count() >= 15) return;

        List<User> users = userRepository.findAll();
        if (users.isEmpty()) return;

        User mainUser = users.get(0);
        String[] comments = {
            "An absolute sanctuary in the heart of the city. The attention to detail is unmatched.",
            "The infinity pool at sunset is an experience everyone should have at least once.",
            "Exquisite dining and impeccable service. 5 stars isn't enough for the Aurelian Hotel.",
            "From the moment we arrived, we were treated like royalty. Simply magnificent.",
            "The perfect blend of historical charm and modern luxury. We will definitely be back!",
            "Great stay, though the breakfast queue was a bit long on Sunday morning.",
            "Average experience. The room was clean but the view wasn't what I expected for the price.",
            "The spa treatments were heavenly, but the sauna was closed for maintenance during my stay.",
            "Exceptional concierge service. They helped us book last-minute tickets to the opera.",
            "A bit noisy near the elevator, but the staff kindly moved us to a quieter room immediately.",
            "The most comfortable bed I have ever slept in! The pillow menu is a genius touch.",
            "Very disappointed with the room service delay. Took over an hour for a simple sandwich.",
            "Overpriced for what it offers. There are better luxury hotels nearby for lower rates.",
            "Wonderful venue for our anniversary. The complimentary champagne was a lovely surprise.",
            "The gym equipment is a bit dated, but the personal trainer on site was very helpful."
        };
        Integer[] ratings = {5, 5, 5, 5, 5, 4, 3, 4, 5, 4, 5, 2, 1, 5, 3};

        for (int i = (int)reviewRepository.count(); i < comments.length; i++) {
            saveReview(mainUser, ratings[i], comments[i]);
        }
    }

    public List<Review> getAllReviews() {
        return reviewRepository.findAllByOrderByCreatedAtDesc();
    }

    public List<Review> getFeaturedReviews(int limit) {
        return reviewRepository.findTop10ByOrderByCreatedAtDesc();
    }

    public List<Review> getReviewsByUser(Long userId) {
        return reviewRepository.findAllByUserIdOrderByCreatedAtDesc(userId);
    }

    /**
     * Why this user may not post a review right now, or {@code null} when they may.
     * Rules: the guest must have a completed (checked-out) stay of at least one night,
     * and may only have one review.
     */
    public String getReviewBlockReason(User user) {
        if (user == null || user.getId() == null) {
            return MSG_LOGIN_REQUIRED;
        }
        if (hasReviewed(user)) {
            return MSG_ALREADY_REVIEWED;
        }
        if (!hasCompletedOvernightStay(user)) {
            return MSG_NO_COMPLETED_STAY;
        }
        return null;
    }

    public boolean canReview(User user) {
        return getReviewBlockReason(user) == null;
    }

    public boolean hasReviewed(User user) {
        return user != null && user.getId() != null && reviewRepository.existsByUserId(user.getId());
    }

    /** True when the user has at least one COMPLETED booking that covered one or more nights. */
    public boolean hasCompletedOvernightStay(User user) {
        if (user == null || user.getId() == null) {
            return false;
        }
        return bookingRepository.findByUserIdOrderByCreatedAtDesc(user.getId()).stream()
                .filter(b -> "COMPLETED".equals(b.getStatus()))
                .anyMatch(this::isOvernightStay);
    }

    private boolean isOvernightStay(Booking booking) {
        LocalDateTime in = booking.getActualCheckInDateTime() != null
                ? booking.getActualCheckInDateTime() : booking.getCheckInDate();
        LocalDateTime out = booking.getActualCheckOutDateTime() != null
                ? booking.getActualCheckOutDateTime() : booking.getCheckOutDate();
        return in != null && out != null
                && ChronoUnit.DAYS.between(in.toLocalDate(), out.toLocalDate()) >= 1;
    }

    @Transactional
    public Review createReview(User user, Integer rating, String comment) {
        String reason = getReviewBlockReason(user);
        if (reason != null) {
            throw new IllegalStateException(reason);
        }
        return saveReview(user, rating, comment);
    }

    private Review saveReview(User user, Integer rating, String comment) {
        if (rating == null || rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5 stars.");
        }
        if (comment == null || comment.trim().isEmpty()) {
            throw new IllegalArgumentException("Comment cannot be empty.");
        }
        Review review = new Review(user, rating, comment);
        return reviewRepository.save(review);
    }

    @Transactional
    public void deleteReview(Long id, User currentUser) {
        Optional<Review> reviewOpt = reviewRepository.findById(id);
        if (!reviewOpt.isPresent()) {
            throw new IllegalArgumentException("Review not found.");
        }

        Review review = reviewOpt.get();
        
        // Authorization check
        boolean isAdmin = "ADMIN".equalsIgnoreCase(currentUser.getRole());
        boolean isOwner = review.getUser().getId().equals(currentUser.getId());
        
        if (isAdmin || isOwner) {
            reviewRepository.delete(review);
        } else {
            throw new IllegalStateException("You are not authorized to delete this review.");
        }
    }

    @Transactional
    public Review updateReview(Long id, Integer rating, String comment, User currentUser) {
        Optional<Review> reviewOpt = reviewRepository.findById(id);
        if (!reviewOpt.isPresent()) {
            throw new IllegalArgumentException("Review not found.");
        }

        Review review = reviewOpt.get();
        if (!review.getUser().getId().equals(currentUser.getId()) && !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
            throw new IllegalStateException("You are not authorized to update this review.");
        }

        if (rating != null) {
            if (rating < 1 || rating > 5) throw new IllegalArgumentException("Rating must be between 1 and 5.");
            review.setRating(rating);
        }
        if (comment != null) {
            if (comment.trim().isEmpty()) throw new IllegalArgumentException("Comment cannot be empty.");
            review.setComment(comment);
        }
        
        review.setUpdatedAt(LocalDateTime.now());
        return reviewRepository.save(review);
    }
}
