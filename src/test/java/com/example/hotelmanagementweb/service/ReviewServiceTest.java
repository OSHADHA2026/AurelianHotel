package com.example.hotelmanagementweb.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.Review;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.repository.BookingRepository;
import com.example.hotelmanagementweb.repository.ReviewRepository;
import com.example.hotelmanagementweb.repository.UserRepository;

class ReviewServiceTest {

    @Mock
    private ReviewRepository reviewRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private BookingRepository bookingRepository;

    @InjectMocks
    private ReviewService reviewService;

    private User guest;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        guest = new User();
        guest.setId(7L);
    }

    private Booking booking(String status, LocalDateTime in, LocalDateTime out) {
        Booking b = new Booking();
        b.setStatus(status);
        b.setCheckInDate(in);
        b.setCheckOutDate(out);
        return b;
    }

    private void givenBookings(Booking... bookings) {
        when(bookingRepository.findByUserIdOrderByCreatedAtDesc(7L)).thenReturn(List.of(bookings));
    }

    @Test
    void anonymousUserMustLogin() {
        assertEquals(ReviewService.MSG_LOGIN_REQUIRED, reviewService.getReviewBlockReason(null));
    }

    @Test
    void guestWithoutAnyStayCannotReview() {
        when(bookingRepository.findByUserIdOrderByCreatedAtDesc(7L)).thenReturn(Collections.emptyList());

        assertEquals(ReviewService.MSG_NO_COMPLETED_STAY, reviewService.getReviewBlockReason(guest));
        assertThrows(IllegalStateException.class, () -> reviewService.createReview(guest, 5, "Great"));
        verify(reviewRepository, never()).save(any(Review.class));
    }

    @Test
    void sameDayStayDoesNotCountAsANight() {
        LocalDateTime in = LocalDateTime.now().minusDays(3).withHour(9);
        givenBookings(booking("COMPLETED", in, in.withHour(18)));

        assertFalse(reviewService.canReview(guest));
    }

    @Test
    void stayThatIsNotCompletedDoesNotCount() {
        LocalDateTime in = LocalDateTime.now().minusDays(3);
        givenBookings(
                booking("CHECKED_IN", in, in.plusDays(2)),
                booking("CONFIRMED", in, in.plusDays(2)),
                booking("CANCELLED", in, in.plusDays(2)));

        assertFalse(reviewService.canReview(guest));
    }

    @Test
    void guestWithCompletedOvernightStayCanReviewOnce() {
        LocalDateTime in = LocalDateTime.now().minusDays(5);
        givenBookings(booking("COMPLETED", in, in.plusDays(2)));
        when(reviewRepository.existsByUserId(7L)).thenReturn(false);
        when(reviewRepository.save(any(Review.class))).thenAnswer(inv -> inv.getArgument(0));

        assertNull(reviewService.getReviewBlockReason(guest));
        Review saved = reviewService.createReview(guest, 5, "Wonderful stay");

        assertEquals(5, saved.getRating());
        verify(reviewRepository, times(1)).save(any(Review.class));
    }

    @Test
    void secondReviewIsRejected() {
        LocalDateTime in = LocalDateTime.now().minusDays(5);
        givenBookings(booking("COMPLETED", in, in.plusDays(2)));
        when(reviewRepository.existsByUserId(7L)).thenReturn(true);

        assertEquals(ReviewService.MSG_ALREADY_REVIEWED, reviewService.getReviewBlockReason(guest));
        assertThrows(IllegalStateException.class, () -> reviewService.createReview(guest, 4, "Again"));
        verify(reviewRepository, never()).save(any(Review.class));
    }
}
