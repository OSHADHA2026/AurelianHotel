package com.example.hotelmanagementweb.dto;

import java.math.BigDecimal;

public class BookingTrendDto {
    private Integer month;
    private Integer year;
    private Long bookingCount;
    private BigDecimal totalRevenue;
    private Double occupancyPercentage;

    public BookingTrendDto(Integer year, Integer month, Long bookingCount, BigDecimal totalRevenue) {
        this.year = year;
        this.month = month;
        this.bookingCount = bookingCount;
        this.totalRevenue = totalRevenue != null ? totalRevenue : BigDecimal.ZERO;
    }

    // Getters and Setters
    public Integer getMonth() {
        return month;
    }

    public void setMonth(Integer month) {
        this.month = month;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public Long getBookingCount() {
        return bookingCount;
    }

    public void setBookingCount(Long bookingCount) {
        this.bookingCount = bookingCount;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public Double getOccupancyPercentage() {
        return occupancyPercentage;
    }

    public void setOccupancyPercentage(Double occupancyPercentage) {
        this.occupancyPercentage = occupancyPercentage;
    }
}
