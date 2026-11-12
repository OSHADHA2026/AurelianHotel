package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.CardDetails;
import com.example.hotelmanagementweb.model.Payment;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.repository.BookingRepository;
import com.example.hotelmanagementweb.repository.CardDetailsRepository;
import com.example.hotelmanagementweb.repository.PaymentRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class DashboardService {

    private final BookingRepository bookingRepository;
    private final PaymentRepository paymentRepository;
    private final CardDetailsRepository cardDetailsRepository;

    public DashboardService(BookingRepository bookingRepository,
                            PaymentRepository paymentRepository,
                            CardDetailsRepository cardDetailsRepository) {
        this.bookingRepository = bookingRepository;
        this.paymentRepository = paymentRepository;
        this.cardDetailsRepository = cardDetailsRepository;
    }

    // Get all bookings for a user
    @Transactional(readOnly = true)
    public List<Booking> getUserBookings(User user) {
        return bookingRepository.findByUserOrderByCreatedAtDesc(user);
    }

    // Get all bookings for a user ID
    @Transactional(readOnly = true)
    public List<Booking> getUserBookings(Long userId) {
        return bookingRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    // Get upcoming bookings
    @Transactional(readOnly = true)
    public List<Booking> getUpcomingBookings(Long userId) {
        return bookingRepository.findUpcomingBookingsByUserId(userId);
    }

    // Get past bookings
    @Transactional(readOnly = true)
    public List<Booking> getPastBookings(Long userId) {
        return bookingRepository.findPastBookingsByUserId(userId);
    }

    // Get all payments for a user
    @Transactional(readOnly = true)
    public List<Payment> getUserPayments(Long userId) {
        return paymentRepository.findByUserIdOrderByPaymentDateDesc(userId);
    }

    // Get payments by status
    @Transactional(readOnly = true)
    public List<Payment> getUserPaymentsByStatus(Long userId, String status) {
        return paymentRepository.findByUserIdAndStatusOrderByPaymentDateDesc(userId, status);
    }

    // Get all card details for a user
    @Transactional(readOnly = true)
    public List<CardDetails> getUserCards(Long userId) {
        return cardDetailsRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
    }

    // Get default card for a user
    @Transactional(readOnly = true)
    public Optional<CardDetails> getDefaultCard(Long userId) {
        return cardDetailsRepository.findByUserIdAndIsDefaultTrue(userId);
    }

    // Calculate total spent by user
    @Transactional(readOnly = true)
    public BigDecimal getTotalSpent(Long userId) {
        List<Payment> completedPayments = paymentRepository.findByUserIdAndStatusOrderByPaymentDateDesc(userId, "COMPLETED");
        return completedPayments.stream()
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Count total bookings
    @Transactional(readOnly = true)
    public long getTotalBookingsCount(Long userId) {
        return bookingRepository.findByUserIdOrderByCreatedAtDesc(userId).size();
    }

    // Count completed bookings
    @Transactional(readOnly = true)
    public long getCompletedBookingsCount(Long userId) {
        return bookingRepository.findByUserAndStatusOrderByCreatedAtDesc(
                new User() {{ setId(userId); }}, "COMPLETED").size();
    }

    // --- GLOBAL METHODS FOR STAFF ---
    
    @Transactional(readOnly = true)
    public List<Booking> getAllBookings() {
        return bookingRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Booking> getGlobalUpcomingBookings() {
        return bookingRepository.findByStatusOrderByCreatedAtDesc("CONFIRMED");
    }

    @Transactional(readOnly = true)
    public BigDecimal getGlobalTotalRevenue() {
        return bookingRepository.findBookingsWithCompletedPayments().stream()
                .map(Booking::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}

