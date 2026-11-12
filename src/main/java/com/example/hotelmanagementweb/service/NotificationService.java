package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.Notification;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.repository.NotificationRepository;
import com.example.hotelmanagementweb.repository.BookingRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final BookingRepository bookingRepository;

    public NotificationService(NotificationRepository notificationRepository, BookingRepository bookingRepository) {
        this.notificationRepository = notificationRepository;
        this.bookingRepository = bookingRepository;
    }

    @Transactional
    public void createNotification(User user, String message, Notification.NotificationType type, String link) {
        Notification notification = new Notification(user, message, type, link);
        notificationRepository.save(notification);
    }

    @Transactional(readOnly = true)
    public List<Notification> getNotificationsForUser(User user) {
        return notificationRepository.findByUserOrderByCreatedAtDesc(user);
    }

    @Transactional(readOnly = true)
    public long getUnreadCount(User user) {
        return notificationRepository.countByUserAndIsReadFalse(user);
    }

    @Transactional
    public void markAsRead(Long notificationId) {
        notificationRepository.findById(notificationId).ifPresent(n -> {
            n.setRead(true);
            notificationRepository.save(n);
        });
    }

    @Transactional
    public void markAllAsRead(User user) {
        List<Notification> unread = notificationRepository.findByUserOrderByCreatedAtDesc(user)
                .stream().filter(n -> !n.isRead()).collect(java.util.stream.Collectors.toList());
        unread.forEach(n -> n.setRead(true));
        notificationRepository.saveAll(unread);
    }

    /**
     * Scheduled task to send checkout reminders.
     * Runs every morning at 8:00 AM (or as configured).
     * For now, runs every hour for demonstration purposes.
     */
    @Scheduled(cron = "0 0 * * * *")
    @Transactional
    public void sendCheckoutReminders() {
        LocalDate today = LocalDate.now();
        List<Booking> checkoutsToday = bookingRepository.findAll().stream()
                .filter(b -> b.getStatus().equals("CHECKED_IN") && 
                        b.getCheckOutDate() != null &&
                        b.getCheckOutDate().toLocalDate().equals(today))
                .collect(java.util.stream.Collectors.toList());

        for (Booking booking : checkoutsToday) {
            String message = "Reminder: Your checkout for Room " + booking.getRoom().getRoomNumber() + 
                             " is scheduled for today (" + today + ").";
            // Check if reminder already sent today to avoid duplicates
            createNotification(booking.getUser(), message, Notification.NotificationType.REMINDER, "/reservations/" + booking.getId());
        }
    }
}
