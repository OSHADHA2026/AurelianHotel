package com.example.hotelmanagementweb.controller;

import com.example.hotelmanagementweb.dto.BookingTrendDto;
import com.example.hotelmanagementweb.dto.PaymentDto;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.service.BookingService;
import com.example.hotelmanagementweb.service.PaymentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/manager/dashboard")
public class ManagerDashboardController {

    private final BookingService bookingService;
    private final PaymentService paymentService;

    public ManagerDashboardController(BookingService bookingService, PaymentService paymentService) {
        this.bookingService = bookingService;
        this.paymentService = paymentService;
    }

    private boolean isManager(HttpSession session) {
        User user = (User) session.getAttribute("user");
        // Allowing both ADMIN and any role named MANAGER (for future-proofing)
        return user != null && ("ADMIN".equals(user.getRole()) || "MANAGER".equals(user.getRole()));
    }

    @GetMapping("/trends")
    public ResponseEntity<List<BookingTrendDto>> getBookingTrends(HttpSession session) {
        if (!isManager(session)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        
        List<BookingTrendDto> trends = bookingService.getBookingTrends();
        return ResponseEntity.ok(trends);
    }

    @GetMapping("/recent-payments")
    public ResponseEntity<List<PaymentDto>> getRecentPayments(HttpSession session) {
        if (!isManager(session)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        
        return ResponseEntity.ok(paymentService.getRecentPayments());
    }
}
