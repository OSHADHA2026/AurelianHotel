package com.example.hotelmanagementweb.controller;

import com.example.hotelmanagementweb.model.Payment;
import com.example.hotelmanagementweb.service.PaymentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/payments")
public class PaymentRestController {

    private final PaymentService paymentService;

    public PaymentRestController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    private boolean isStaff(HttpSession session) {
        com.example.hotelmanagementweb.model.User user = (com.example.hotelmanagementweb.model.User) session.getAttribute("user");
        return user != null && ("ADMIN".equals(user.getRole()) || "EMPLOYEE".equals(user.getRole()));
    }

    /**
     * Upload receipt for a payment.
     * US5.2/US5.3: Receipt Upload & Verification
     */
    @PostMapping("/{id}/upload-receipt")
    public ResponseEntity<Map<String, Object>> uploadReceipt(
            @PathVariable("id") Long id,
            @RequestParam("file") MultipartFile file,
            HttpSession session) {
        if (!isStaff(session)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        Map<String, Object> response = new HashMap<>();
        try {
            Payment payment = paymentService.uploadReceipt(id, file);
            response.put("success", true);
            response.put("message", "Receipt uploaded successfully. Status set to PENDING_VERIFICATION.");
            response.put("paymentId", payment.getId());
            response.put("status", payment.getStatus());
            response.put("path", payment.getReceiptPath());
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "Internal server error during file upload: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * View/Retrieve uploaded slip/receipt for Finance Staff.
     */
    @GetMapping(value = {"/{id}/receipt", "/{id}/slip"})
    public ResponseEntity<Resource> viewReceipt(@PathVariable("id") Long id, HttpSession session) {
        if (!isStaff(session)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        
        Payment payment = paymentService.getPaymentById(id)
                .orElse(null);
        
        if (payment == null || payment.getReceiptPath() == null) {
            return ResponseEntity.notFound().build();
        }

        try {
            Path filePath = Paths.get(payment.getReceiptPath());
            Resource resource = new UrlResource(filePath.toUri());
            
            if (resource.exists()) {
                String contentType = Files.probeContentType(filePath);
                if (contentType == null) {
                    contentType = "application/octet-stream";
                }
                return ResponseEntity.ok()
                        .contentType(MediaType.parseMediaType(contentType))
                        .header("Content-Disposition", "inline; filename=\"" + filePath.getFileName().toString() + "\"")
                        .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
