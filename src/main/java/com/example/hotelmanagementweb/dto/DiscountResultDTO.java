package com.example.hotelmanagementweb.dto;

import java.math.BigDecimal;

public class DiscountResultDTO {

    private BigDecimal originalAmount;
    private BigDecimal discountAmount;
    private BigDecimal finalAmount;
    private String appliedPackageName;

    public DiscountResultDTO(BigDecimal originalAmount, BigDecimal discountAmount, BigDecimal finalAmount, String appliedPackageName) {
        this.originalAmount = originalAmount;
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
        this.appliedPackageName = appliedPackageName;
    }

    public BigDecimal getOriginalAmount() {
        return originalAmount;
    }

    public void setOriginalAmount(BigDecimal originalAmount) {
        this.originalAmount = originalAmount;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getAppliedPackageName() {
        return appliedPackageName;
    }

    public void setAppliedPackageName(String appliedPackageName) {
        this.appliedPackageName = appliedPackageName;
    }
}
