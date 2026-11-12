package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.Payment;
import com.example.hotelmanagementweb.repository.BookingRepository;
import com.example.hotelmanagementweb.repository.PaymentRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class ReportingService {

    private final PaymentRepository paymentRepository;
    private final BookingRepository bookingRepository;
    private final PaymentService paymentService;

    public ReportingService(PaymentRepository paymentRepository,
                            BookingRepository bookingRepository,
                            PaymentService paymentService) {
        this.paymentRepository = paymentRepository;
        this.bookingRepository = bookingRepository;
        this.paymentService = paymentService;
    }

    /** Revenue for a single day (completed payments on that day). */
    @Transactional(readOnly = true)
    public BigDecimal getDailyRevenue(LocalDate date) {
        LocalDateTime start = date.atStartOfDay();
        LocalDateTime end = date.plusDays(1).atStartOfDay();
        BigDecimal sum = paymentRepository.sumCompletedAmountBetween(start, end);
        return sum != null ? sum : BigDecimal.ZERO;
    }

    /** Revenue for a month (completed payments in that month). */
    @Transactional(readOnly = true)
    public BigDecimal getMonthlyRevenue(int year, int month) {
        LocalDateTime start = LocalDate.of(year, month, 1).atStartOfDay();
        LocalDateTime end = start.plusMonths(1);
        BigDecimal sum = paymentRepository.sumCompletedAmountBetween(start, end);
        return sum != null ? sum : BigDecimal.ZERO;
    }

    /** Current month revenue. */
    @Transactional(readOnly = true)
    public BigDecimal getCurrentMonthRevenue() {
        LocalDate now = LocalDate.now();
        return getMonthlyRevenue(now.getYear(), now.getMonthValue());
    }

    /** Today's revenue. */
    @Transactional(readOnly = true)
    public BigDecimal getTodayRevenue() {
        return getDailyRevenue(LocalDate.now());
    }

    /** Total number of bookings (all time). */
    @Transactional(readOnly = true)
    public long getTotalBookingsCount() {
        return bookingRepository.count();
    }

    /** Completed bookings count. */
    @Transactional(readOnly = true)
    public long getCompletedBookingsCount() {
        return bookingRepository.findByStatusOrderByCreatedAtDesc("COMPLETED").size();
    }

    /** Outstanding amount: sum over completed bookings of (bill total - total paid). */
    @Transactional(readOnly = true)
    public BigDecimal getOutstandingPaymentsAmount() {
        List<Booking> completed = bookingRepository.findCompletedBookingsOrderByUpdatedDesc();
        BigDecimal total = BigDecimal.ZERO;
        for (Booking b : completed) {
            BigDecimal billTotal = b.getBillTotal();
            BigDecimal paid = paymentService.getTotalPaidForBooking(b.getId());
            BigDecimal due = billTotal.subtract(paid);
            if (due.compareTo(BigDecimal.ZERO) > 0) {
                total = total.add(due);
            }
        }
        return total;
    }

    /** Recent payments for reports/dashboard. */
    @Transactional(readOnly = true)
    public List<Payment> getRecentPayments(int limit) {
        List<Payment> all = paymentRepository.findAllOrderByPaymentDateDesc();
        return all.size() <= limit ? all : all.subList(0, limit);
    }
}
