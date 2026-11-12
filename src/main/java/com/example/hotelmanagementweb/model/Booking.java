package com.example.hotelmanagementweb.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "bookings")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "package_id")
    private RoomPackage roomPackage;

    @Column(nullable = false)
    private LocalDateTime checkInDate;

    @Column(nullable = false)
    private LocalDateTime checkOutDate;

    @Column(nullable = false)
    private Integer numberOfGuests;

    @Column(nullable = false)
    private BigDecimal totalAmount;

    @Column(nullable = false, length = 50)
    private String status; // PENDING, CONFIRMED, CANCELLED, COMPLETED

    @Column(name = "guest_name", length = 200)
    private String guestName;

    @Column(name = "contact_details", length = 255)
    private String contactDetails;

    @Column(length = 500)
    private String specialRequests;

    /** ID or Passport number for identity verification at check-in */
    @Column(name = "id_passport_number", length = 100)
    private String idPassportNumber;

    /** Actual check-in date and time (when guest was digitally checked in) */
    @Column(name = "actual_check_in_datetime")
    private LocalDateTime actualCheckInDateTime;

    /** Actual check-out date and time (when guest was digitally checked out) */
    @Column(name = "actual_check_out_datetime")
    private LocalDateTime actualCheckOutDateTime;

    /** Additional charges applied at check-out (e.g. minibar, damages) */
    @Column(name = "additional_charges", precision = 10, scale = 2)
    private BigDecimal additionalCharges;

    /** Tax amount applied to the bill */
    @Column(name = "tax_amount", precision = 10, scale = 2)
    private BigDecimal taxAmount;

    /** Manual discount amount applied to the bill */
    @Column(name = "discount_amount", precision = 10, scale = 2)
    private BigDecimal discountAmount;

    /** Discount amount automatically applied via a Room Package */
    @Column(name = "package_discount_amount", precision = 10, scale = 2)
    private BigDecimal packageDiscountAmount;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (status == null) {
            status = "PENDING";
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    @PostLoad
    protected void onPostLoad() {
        // Migration logic for old bookings: if there is a package but packageDiscountAmount is empty,
        // it means the package discount was previously stored in discountAmount.
        if (roomPackage != null && (packageDiscountAmount == null || packageDiscountAmount.compareTo(BigDecimal.ZERO) == 0)
                && (discountAmount != null && discountAmount.compareTo(BigDecimal.ZERO) > 0)) {
            packageDiscountAmount = discountAmount;
            discountAmount = BigDecimal.ZERO;
        }
    }

    public Booking() {
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public RoomPackage getRoomPackage() {
        return roomPackage;
    }

    public void setRoomPackage(RoomPackage roomPackage) {
        this.roomPackage = roomPackage;
    }

    public LocalDateTime getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(LocalDateTime checkInDate) {
        this.checkInDate = checkInDate;
    }

    public LocalDateTime getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(LocalDateTime checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public Integer getNumberOfGuests() {
        return numberOfGuests;
    }

    public void setNumberOfGuests(Integer numberOfGuests) {
        this.numberOfGuests = numberOfGuests;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getContactDetails() {
        return contactDetails;
    }

    public void setContactDetails(String contactDetails) {
        this.contactDetails = contactDetails;
    }

    public String getSpecialRequests() {
        return specialRequests;
    }

    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }

    public String getIdPassportNumber() {
        return idPassportNumber;
    }

    public void setIdPassportNumber(String idPassportNumber) {
        this.idPassportNumber = idPassportNumber;
    }

    public LocalDateTime getActualCheckInDateTime() {
        return actualCheckInDateTime;
    }

    public void setActualCheckInDateTime(LocalDateTime actualCheckInDateTime) {
        this.actualCheckInDateTime = actualCheckInDateTime;
    }

    public LocalDateTime getActualCheckOutDateTime() {
        return actualCheckOutDateTime;
    }

    public void setActualCheckOutDateTime(LocalDateTime actualCheckOutDateTime) {
        this.actualCheckOutDateTime = actualCheckOutDateTime;
    }

    public BigDecimal getAdditionalCharges() {
        return additionalCharges;
    }

    public void setAdditionalCharges(BigDecimal additionalCharges) {
        this.additionalCharges = additionalCharges;
    }

    public BigDecimal getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getPackageDiscountAmount() {
        return packageDiscountAmount;
    }

    public void setPackageDiscountAmount(BigDecimal packageDiscountAmount) {
        this.packageDiscountAmount = packageDiscountAmount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Helper method to calculate number of nights (reservation dates)
    @Transient
    public long getNumberOfNights() {
        if (checkInDate != null && checkOutDate != null) {
            return java.time.temporal.ChronoUnit.DAYS.between(checkInDate.toLocalDate(), checkOutDate.toLocalDate());
        }
        return 0;
    }

    @Transient
    public String getCheckInFormatted() {
        if (checkInDate == null) return "";
        return checkInDate.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }

    @Transient
    public String getCheckOutFormatted() {
        if (checkOutDate == null) return "";
        return checkOutDate.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }

    @Transient
    public String getActualCheckInFormatted() {
        if (actualCheckInDateTime == null) return "";
        return actualCheckInDateTime.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }

    @Transient
    public String getActualCheckOutFormatted() {
        if (actualCheckOutDateTime == null) return "";
        return actualCheckOutDateTime.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }

    /** Stay duration in hours between actual check-in and check-out; 0 if either is null. */
    @Transient
    public long getStayDurationHours() {
        if (actualCheckInDateTime != null && actualCheckOutDateTime != null) {
            return java.time.temporal.ChronoUnit.HOURS.between(actualCheckInDateTime, actualCheckOutDateTime);
        }
        return 0;
    }

    /** Human-readable stay duration (e.g. "2 days 5 hours"). */
    @Transient
    public String getStayDurationFormatted() {
        if (actualCheckInDateTime == null || actualCheckOutDateTime == null) {
            return "";
        }
        long hours = java.time.temporal.ChronoUnit.HOURS.between(actualCheckInDateTime, actualCheckOutDateTime);
        long days = hours / 24;
        long remainderHours = hours % 24;
        if (days > 0 && remainderHours > 0) {
            return days + " day(s) " + remainderHours + " hour(s)";
        }
        if (days > 0) {
            return days + " day(s)";
        }
        return remainderHours + " hour(s)";
    }

    /** Room charges (base from reservation; totalAmount may already include additional from check-out). */
    @Transient
    public BigDecimal getRoomCharges() {
        BigDecimal netTotal = totalAmount != null ? totalAmount : BigDecimal.ZERO;
        BigDecimal manualDiscount = discountAmount != null ? discountAmount : BigDecimal.ZERO;
        BigDecimal packageDiscount = packageDiscountAmount != null ? packageDiscountAmount : BigDecimal.ZERO;
        BigDecimal add = additionalCharges != null ? additionalCharges : BigDecimal.ZERO;
        // Gross Room Charges = Net Total + All Discounts - Additional Charges
        return netTotal.add(manualDiscount).add(packageDiscount).subtract(add);
    }

    /** Subtotal before tax and discount: room + additional charges (= totalAmount). */
    @Transient
    public BigDecimal getSubtotal() {
        BigDecimal netTotal = (totalAmount != null ? totalAmount : BigDecimal.ZERO);
        BigDecimal manualDiscount = (discountAmount != null ? discountAmount : BigDecimal.ZERO);
        BigDecimal packageDiscount = (packageDiscountAmount != null ? packageDiscountAmount : BigDecimal.ZERO);
        // Subtotal = Net Total + Both Discounts
        return netTotal.add(manualDiscount).add(packageDiscount);
    }

    /** Total bill amount: subtotal - discount + tax. */
    @Transient
    public BigDecimal getBillTotal() {
        BigDecimal netTotal = totalAmount != null ? totalAmount : BigDecimal.ZERO;
        BigDecimal tax = (taxAmount != null ? taxAmount : BigDecimal.ZERO);
        return netTotal.add(tax);
    }
}

