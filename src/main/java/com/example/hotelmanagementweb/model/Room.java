package com.example.hotelmanagementweb.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "rooms")
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String roomNumber;

    @Column(nullable = false)
    private String roomType; // SINGLE, DOUBLE, SUITE, DELUXE, PRESIDENTIAL

    @Column(nullable = false)
    private Integer capacity; // Number of guests

    @Column(nullable = false)
    private BigDecimal pricePerNight;

    @Column(length = 500)
    private String description;

    @Column(nullable = false)
    private String status; // AVAILABLE, OCCUPIED, MAINTENANCE, RESERVED

    @Column(nullable = false)
    private Boolean isAvailable;

    @Column(nullable = false)
    private Integer floor;

    @Column(name = "max_occupancy", nullable = false)
    private Integer maxOccupancy;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    private String bedType;
    private Double roomSize;
    private String view;
    private LocalDateTime lastMaintenanceDate;
    private LocalDateTime nextMaintenanceDate;

    private String amenities;

    private LocalDateTime maintenanceStartDate;
    private LocalDateTime maintenanceEndDate;

    @Column(length = 500)
    private String maintenanceNotes;

    private String imagePath;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public Room() {
    }

    public Room(String roomNumber, String roomType, Integer capacity, BigDecimal pricePerNight,
            String description, Integer floor, String amenities) {
        this.roomNumber = roomNumber;
        this.roomType = roomType;
        this.capacity = capacity;
        this.maxOccupancy = capacity; // Default to capacity
        this.pricePerNight = pricePerNight;
        this.description = description;
        this.floor = floor;
        this.amenities = amenities;
        this.status = "AVAILABLE";
        this.isAvailable = true;
        this.isActive = true; // Default to true
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public BigDecimal getPricePerNight() {
        return pricePerNight;
    }

    public void setPricePerNight(BigDecimal pricePerNight) {
        this.pricePerNight = pricePerNight;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Boolean getIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(Boolean available) {
        isAvailable = available;
    }

    public Integer getFloor() {
        return floor;
    }

    public void setFloor(Integer floor) {
        this.floor = floor;
    }

    public String getAmenities() {
        return amenities;
    }

    public void setAmenities(String amenities) {
        this.amenities = amenities;
    }

    public Integer getMaxOccupancy() {
        return maxOccupancy;
    }

    public void setMaxOccupancy(Integer maxOccupancy) {
        this.maxOccupancy = maxOccupancy;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean active) {
        isActive = active;
    }

    public String getBedType() {
        return bedType;
    }

    public void setBedType(String bedType) {
        this.bedType = bedType;
    }

    public Double getRoomSize() {
        return roomSize;
    }

    public void setRoomSize(Double roomSize) {
        this.roomSize = roomSize;
    }

    public String getView() {
        return view;
    }

    public void setView(String view) {
        this.view = view;
    }

    public LocalDateTime getLastMaintenanceDate() {
        return lastMaintenanceDate;
    }

    public void setLastMaintenanceDate(LocalDateTime lastMaintenanceDate) {
        this.lastMaintenanceDate = lastMaintenanceDate;
    }

    public LocalDateTime getNextMaintenanceDate() {
        return nextMaintenanceDate;
    }

    public void setNextMaintenanceDate(LocalDateTime nextMaintenanceDate) {
        this.nextMaintenanceDate = nextMaintenanceDate;
    }

    public LocalDateTime getMaintenanceStartDate() {
        return maintenanceStartDate;
    }

    public void setMaintenanceStartDate(LocalDateTime maintenanceStartDate) {
        this.maintenanceStartDate = maintenanceStartDate;
    }

    public LocalDateTime getMaintenanceEndDate() {
        return maintenanceEndDate;
    }

    public void setMaintenanceEndDate(LocalDateTime maintenanceEndDate) {
        this.maintenanceEndDate = maintenanceEndDate;
    }

    public String getMaintenanceNotes() {
        return maintenanceNotes;
    }

    public void setMaintenanceNotes(String maintenanceNotes) {
        this.maintenanceNotes = maintenanceNotes;
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

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    // Helper methods for JSP compatibility
    public Double getArea() {
        return roomSize != null ? roomSize : 0.0;
    }

    public boolean isHasWifi() {
        return amenities != null && amenities.contains("WiFi");
    }

    public boolean isHasAC() {
        return amenities != null && amenities.contains("AC");
    }

    public boolean isHasTV() {
        return amenities != null && amenities.contains("TV");
    }

    public boolean isHasMinibar() {
        return amenities != null && amenities.contains("Mini Bar");
    }

    public boolean isHasSafe() {
        return amenities != null && amenities.contains("Safe");
    }

    public boolean isHasJacuzzi() {
        return amenities != null && (amenities.contains("Jacuzzi") || amenities.contains("Bathroom"));
    }
}
