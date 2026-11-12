package com.example.hotelmanagementweb.dto;

import com.example.hotelmanagementweb.model.Notification;

public class NotificationDto {
    public Long id;
    public String message;
    public String type;
    public boolean read;
    public String createdAt;
    public String link;

    public NotificationDto(Notification n) {
        this.id = n.getId();
        this.message = n.getMessage();
        this.type = n.getType().name();
        this.read = n.isRead();
        this.createdAt = n.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
        this.link = n.getLink();
    }

    // Getters
    public Long getId() { return id; }
    public String getMessage() { return message; }
    public String getType() { return type; }
    public boolean isRead() { return read; }
    public String getCreatedAt() { return createdAt; }
    public String getLink() { return link; }
}
