package com.example.hotelmanagementweb.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PaymentDto {
    private Long id;
    private Long bookingId;
    private String guestName;
    private BigDecimal amount;
    private String method;
    private String status;
    private LocalDateTime date;

    public PaymentDto(Long id, Long bookingId, String guestName, BigDecimal amount, String method, String status, LocalDateTime date) {
        this.id = id;
        this.bookingId = bookingId;
        this.guestName = guestName;
        this.amount = amount;
        this.method = method;
        this.status = status;
        this.date = date;
    }

    // Getters
    public Long getId() { return id; }
    public Long getBookingId() { return bookingId; }
    public String getGuestName() { return guestName; }
    public BigDecimal getAmount() { return amount; }
    public String getMethod() { return method; }
    public String getStatus() { return status; }
    public LocalDateTime getDate() { return date; }
}
