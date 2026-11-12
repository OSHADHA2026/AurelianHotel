package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.repository.BookingRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class BillingService {

    private final BookingRepository bookingRepository;

    public BillingService(BookingRepository bookingRepository) {
        this.bookingRepository = bookingRepository;
    }

    @Transactional(readOnly = true)
    public List<Booking> getCompletedBookingsForBilling() {
        return bookingRepository.findForBilling();
    }

    @Transactional(readOnly = true)
    public Optional<Booking> getBookingForBill(Long bookingId) {
        return bookingRepository.findById(bookingId);
    }

    /** Apply or update discount for a booking. Recalculates total amount stored. */
    @Transactional
    public Booking applyDiscount(Long bookingId, BigDecimal discountAmount) {
        Booking b = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));
        if (discountAmount == null || discountAmount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Discount must be zero or positive");
        }
        BigDecimal sub = b.getSubtotal();
        BigDecimal packageDisc = b.getPackageDiscountAmount() != null ? b.getPackageDiscountAmount() : BigDecimal.ZERO;
        
        if (discountAmount.compareTo(sub.subtract(packageDisc)) > 0) {
            throw new IllegalArgumentException("Manual discount cannot exceed amount after package discount");
        }
        b.setDiscountAmount(discountAmount);
        
        // Recalculate net total amount: Gross Subtotal - Package Discount - New Manual Discount
        b.setTotalAmount(sub.subtract(packageDisc).subtract(discountAmount));
        
        return bookingRepository.save(b);
    }

    /** Apply or update tax for a booking. */
    @Transactional
    public Booking applyTax(Long bookingId, BigDecimal taxAmount) {
        Booking b = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));
        if (taxAmount == null || taxAmount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Tax must be zero or positive");
        }
        b.setTaxAmount(taxAmount);
        return bookingRepository.save(b);
    }
}
