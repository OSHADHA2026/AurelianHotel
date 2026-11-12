package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.Payment;
import com.example.hotelmanagementweb.model.Notification;
import com.example.hotelmanagementweb.repository.BookingRepository;
import com.example.hotelmanagementweb.repository.PaymentRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final BookingRepository bookingRepository;
    private final NotificationService notificationService;

    public PaymentService(PaymentRepository paymentRepository, BookingRepository bookingRepository, NotificationService notificationService) {
        this.paymentRepository = paymentRepository;
        this.bookingRepository = bookingRepository;
        this.notificationService = notificationService;
    }

    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByBooking(Long bookingId) {
        return paymentRepository.findByBookingIdOrderByPaymentDateDesc(bookingId);
    }

    @Transactional(readOnly = true)
    public BigDecimal getTotalPaidForBooking(Long bookingId) {
        List<Payment> payments = paymentRepository.findByBookingIdOrderByPaymentDateDesc(bookingId);
        return payments.stream()
                .filter(p -> "COMPLETED".equals(p.getStatus()))
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Transactional(readOnly = true)
    public Optional<Payment> getPaymentById(Long paymentId) {
        return paymentRepository.findById(paymentId);
    }

    /** Process a payment (staff): create or record payment with method and transaction reference. */
    @Transactional
    public Payment processPayment(Long bookingId,
                                  BigDecimal amount,
                                  String paymentMethod,
                                  String transactionReference,
                                  String status) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Payment amount must be positive");
        }
        String method = normalizePaymentMethod(paymentMethod);
        String st = status != null && !status.isEmpty() ? status.toUpperCase() : "COMPLETED";
        if (!List.of("COMPLETED", "PENDING", "FAILED").contains(st)) {
            st = "COMPLETED";
        }

        Payment payment = new Payment();
        payment.setBooking(booking);
        payment.setAmount(amount);
        payment.setPaymentMethod(method);
        payment.setStatus(st);
        payment.setTransactionId(transactionReference != null ? transactionReference.trim() : null);
        payment.setPaymentDate(LocalDateTime.now());
        Payment savedPayment = paymentRepository.save(payment);

        if ("COMPLETED".equals(st)) {
            String message = String.format("Payment of $%s confirmed for your stay at Room %s.", amount, booking.getRoom().getRoomNumber());
            notificationService.createNotification(booking.getUser(), message, Notification.NotificationType.PAYMENT, "/reservations/" + booking.getId());
        }

        return savedPayment;
    }

    @Transactional
    public Payment updatePaymentStatus(Long paymentId, String status) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found"));
        String st = status != null ? status.toUpperCase() : payment.getStatus();
        if (!List.of("COMPLETED", "PENDING", "FAILED", "REFUNDED", "PENDING_VERIFICATION", "VERIFIED").contains(st)) {
            throw new IllegalArgumentException("Invalid payment status");
        }
        payment.setStatus(st);
        return paymentRepository.save(payment);
    }

    @Transactional(readOnly = true)
    public List<Payment> getAllPaymentsOrderByDateDesc() {
        return paymentRepository.findAllOrderByPaymentDateDesc();
    }

    private String normalizePaymentMethod(String method) {
        if (method == null || method.isEmpty()) return "CASH";
        String m = method.toUpperCase().replace(" ", "_");
        if (m.contains("CARD")) return "CARD";
        if (m.contains("ONLINE") || m.contains("TRANSFER")) return "ONLINE_TRANSFER";
        return "CASH";
    }

    @Transactional(readOnly = true)
    public List<com.example.hotelmanagementweb.dto.PaymentDto> getRecentPayments() {
        return paymentRepository.findRecentPayments().stream()
                .map(p -> new com.example.hotelmanagementweb.dto.PaymentDto(
                        p.getId(),
                        p.getBooking().getId(),
                        p.getBooking().getGuestName() != null ? p.getBooking().getGuestName() : p.getBooking().getUser().getFirstName() + " " + p.getBooking().getUser().getLastName(),
                        p.getAmount(),
                        p.getPaymentMethod(),
                        p.getStatus(),
                        p.getPaymentDate()))
                .toList();
    }

    /**
     * Uploads and saves a receipt for a payment.
     * US5.2/US5.3: Receipt Upload & Verification
     */
    @Transactional
    public Payment uploadReceipt(Long paymentId, MultipartFile file) throws IOException {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found"));

        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File must not be empty");
        }

        // 5MB limit
        if (file.getSize() > 5 * 1024 * 1024) {
            throw new IllegalArgumentException("File size exceeds 5MB limit");
        }

        // Validation for images or PDFs
        String contentType = file.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png") && !contentType.equals("application/pdf"))) {
            throw new IllegalArgumentException("Only images (JPG, PNG) or PDf files are allowed");
        }

        String originalFileName = file.getOriginalFilename();
        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String fileName = "receipt_" + paymentId + "_" + UUID.randomUUID().toString() + extension;
        
        Path uploadPath = Paths.get("receipts");
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        // Update payment with file path (normalize for JS/Web) and status
        payment.setReceiptPath(filePath.toString().replace("\\", "/"));
        payment.setStatus("PENDING_VERIFICATION");
        
        return paymentRepository.save(payment);
    }

    /**
     * Process a payment with a slip upload (guest side).
     */
    @Transactional
    public Payment processPaymentWithSlip(Long bookingId, BigDecimal amount, MultipartFile file) throws IOException {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Payment amount must be positive");
        }

        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Payment slip is required");
        }

        // Create transaction reference
        String transactionReference = "SLIP-" + System.currentTimeMillis();

        // Create the payment record
        Payment payment = new Payment();
        payment.setBooking(booking);
        payment.setAmount(amount);
        payment.setPaymentMethod("SLIP");
        payment.setStatus("PENDING_VERIFICATION");
        payment.setTransactionId(transactionReference);
        payment.setPaymentDate(LocalDateTime.now());
        
        // Save first to get ID
        payment = paymentRepository.save(payment);

        // Trigger notification for slip upload
        String msg = String.format("Your payment slip for $%s has been uploaded and is pending verification.", amount);
        notificationService.createNotification(booking.getUser(), msg, Notification.NotificationType.PAYMENT, "/reservations/" + booking.getId());

        // Now upload the receipt
        return uploadReceipt(payment.getId(), file);
    }
    /**
     * Get all payments pending verification (with slip uploaded).
     */
    @Transactional(readOnly = true)
    public List<Payment> getPendingVerifications() {
        return paymentRepository.findByStatusOrderByPaymentDateDesc("PENDING_VERIFICATION");
    }
}
