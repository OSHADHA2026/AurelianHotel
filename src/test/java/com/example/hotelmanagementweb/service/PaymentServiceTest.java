package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.Payment;
import com.example.hotelmanagementweb.repository.BookingRepository;
import com.example.hotelmanagementweb.repository.PaymentRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.mock.web.MockMultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class PaymentServiceTest {

    private PaymentService paymentService;

    @Mock
    private PaymentRepository paymentRepository;
    
    @Mock
    private BookingRepository bookingRepository;

    @Mock
    private NotificationService notificationService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        paymentService = new PaymentService(paymentRepository, bookingRepository, notificationService);
    }

    @Test
    void testUploadReceipt_Success() throws IOException {
        Long paymentId = 1L;
        Payment payment = new Payment();
        payment.setId(paymentId);
        payment.setStatus("COMPLETED");

        MockMultipartFile file = new MockMultipartFile(
                "file", "receipt.jpg", "image/jpeg", "test data".getBytes());

        when(paymentRepository.findById(paymentId)).thenReturn(Optional.of(payment));
        when(paymentRepository.save(any(Payment.class))).thenAnswer(i -> i.getArguments()[0]);

        Payment result = paymentService.uploadReceipt(paymentId, file);

        assertNotNull(result.getReceiptPath());
        assertTrue(result.getReceiptPath().contains("receipt_1_"));
        assertEquals("PENDING_VERIFICATION", result.getStatus());
        
        // Clean up created test file if it was actually created
        try {
            Path path = Paths.get(result.getReceiptPath());
            Files.deleteIfExists(path);
        } catch (Exception ignored) {}
        
        verify(paymentRepository, times(1)).save(payment);
    }
    
    @Test
    void testUploadReceipt_InvalidSize() {
        Long paymentId = 1L;
        Payment payment = new Payment();
        
        // More than 5MB
        byte[] largeContent = new byte[6 * 1024 * 1024];
        MockMultipartFile file = new MockMultipartFile(
                "file", "large.png", "image/png", largeContent);

        when(paymentRepository.findById(paymentId)).thenReturn(Optional.of(payment));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            paymentService.uploadReceipt(paymentId, file);
        });

        assertEquals("File size exceeds 5MB limit", exception.getMessage());
    }

    @Test
    void testUploadReceipt_InvalidType() {
        Long paymentId = 1L;
        Payment payment = new Payment();
        
        MockMultipartFile file = new MockMultipartFile(
                "file", "danger.exe", "application/x-msdownload", "bad content".getBytes());

        when(paymentRepository.findById(paymentId)).thenReturn(Optional.of(payment));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            paymentService.uploadReceipt(paymentId, file);
        });

        assertEquals("Only images (JPG, PNG) or PDf files are allowed", exception.getMessage());
    }
}
