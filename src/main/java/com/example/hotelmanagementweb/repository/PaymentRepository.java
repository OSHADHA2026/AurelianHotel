package com.example.hotelmanagementweb.repository;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    List<Payment> findByBookingOrderByPaymentDateDesc(Booking booking);

    @Query("SELECT p FROM Payment p WHERE p.booking.user.id = :userId ORDER BY p.paymentDate DESC")
    List<Payment> findByUserIdOrderByPaymentDateDesc(@Param("userId") Long userId);

    @Query("SELECT p FROM Payment p WHERE p.booking.user.id = :userId AND p.status = :status ORDER BY p.paymentDate DESC")
    List<Payment> findByUserIdAndStatusOrderByPaymentDateDesc(@Param("userId") Long userId, @Param("status") String status);

    List<Payment> findByBookingIdOrderByPaymentDateDesc(Long bookingId);

    @Query("SELECT p FROM Payment p WHERE p.status = 'COMPLETED' AND p.paymentDate >= :start AND p.paymentDate < :end ORDER BY p.paymentDate DESC")
    List<Payment> findCompletedPaymentsBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.status = 'COMPLETED' AND p.paymentDate >= :start AND p.paymentDate < :end")
    BigDecimal sumCompletedAmountBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT p FROM Payment p ORDER BY p.paymentDate DESC")
    List<Payment> findAllOrderByPaymentDateDesc();

    List<Payment> findByStatusOrderByPaymentDateDesc(String status);

    @Query("SELECT p FROM Payment p ORDER BY p.paymentDate DESC LIMIT 10")
    List<Payment> findRecentPayments();
}

