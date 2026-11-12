package com.example.hotelmanagementweb.controller;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.service.BillingService;
import com.example.hotelmanagementweb.service.PaymentService;
import com.example.hotelmanagementweb.service.ReportingService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class BillingController {

    private final BillingService billingService;
    private final PaymentService paymentService;
    private final ReportingService reportingService;

    public BillingController(BillingService billingService,
            PaymentService paymentService,
            ReportingService reportingService) {
        this.billingService = billingService;
        this.paymentService = paymentService;
        this.reportingService = reportingService;
    }

    private boolean isStaff(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && ("ADMIN".equals(user.getRole()) || "EMPLOYEE".equals(user.getRole()));
    }

    /** List completed bookings for billing. */
    @GetMapping("/billing")
    public String billingList(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        List<Booking> bookings = billingService.getCompletedBookingsForBilling();
        System.out.println("DEBUG: Found " + bookings.size() + " bookings for billing page.");
        model.addAttribute("bookings", bookings);
        return "admin/billing";
    }

    /** View bill for a booking and manage payments. */
    @GetMapping("/billing/{bookingId}")
    public String billDetail(@PathVariable("bookingId") Long bookingId,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        Optional<Booking> opt = billingService.getBookingForBill(bookingId);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Booking not found.");
            return "redirect:/admin/billing";
        }
        Booking booking = opt.get();
        BigDecimal totalPaid = paymentService.getTotalPaidForBooking(bookingId);
        BigDecimal amountDue = booking.getBillTotal().subtract(totalPaid);
        model.addAttribute("booking", booking);
        model.addAttribute("payments", paymentService.getPaymentsByBooking(bookingId));
        model.addAttribute("totalPaid", totalPaid);
        model.addAttribute("amountDue", amountDue);
        model.addAttribute("amountDueForForm", amountDue.compareTo(BigDecimal.ZERO) > 0 ? amountDue : null);
        return "admin/bill-detail";
    }

    /** Apply discount to a booking. */
    @PostMapping("/billing/{bookingId}/discount")
    public String applyDiscount(@PathVariable("bookingId") Long bookingId,
            @RequestParam("discountAmount") BigDecimal discountAmount,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            billingService.applyDiscount(bookingId, discountAmount);
            redirectAttributes.addFlashAttribute("success", "Discount applied.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/billing/" + bookingId;
    }

    /** Apply tax to a booking. */
    @PostMapping("/billing/{bookingId}/tax")
    public String applyTax(@PathVariable("bookingId") Long bookingId,
            @RequestParam("taxAmount") BigDecimal taxAmount,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            billingService.applyTax(bookingId, taxAmount);
            redirectAttributes.addFlashAttribute("success", "Tax applied.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/billing/" + bookingId;
    }

    /** Process a payment. */
    @PostMapping("/billing/{bookingId}/payment")
    public String processPayment(@PathVariable("bookingId") Long bookingId,
            @RequestParam("amount") BigDecimal amount,
            @RequestParam("paymentMethod") String paymentMethod,
            @RequestParam(value = "transactionReference", required = false) String transactionReference,
            @RequestParam(value = "status", defaultValue = "COMPLETED") String status,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            paymentService.processPayment(bookingId, amount, paymentMethod, transactionReference, status);
            redirectAttributes.addFlashAttribute("success", "Payment recorded successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/billing/" + bookingId;
    }

    /** Update payment status. */
    @PostMapping("/billing/payment/{paymentId}/status")
    public String updatePaymentStatus(@PathVariable("paymentId") Long paymentId,
            @RequestParam("status") String status,
            @RequestParam("bookingId") Long bookingId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            paymentService.updatePaymentStatus(paymentId, status);
            redirectAttributes.addFlashAttribute("success", "Payment status updated.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/billing/" + bookingId;
    }

    /** Reports & dashboard. */
    @GetMapping("/reports")
    public String reports(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        model.addAttribute("dailyRevenue", reportingService.getTodayRevenue());
        model.addAttribute("monthlyRevenue", reportingService.getCurrentMonthRevenue());
        model.addAttribute("totalBookings", reportingService.getTotalBookingsCount());
        model.addAttribute("completedBookings", reportingService.getCompletedBookingsCount());
        model.addAttribute("outstandingPayments", reportingService.getOutstandingPaymentsAmount());
        model.addAttribute("recentPayments", reportingService.getRecentPayments(15));
        return "admin/reports";
    }
    /** Generate and preview formal invoice. */
    @GetMapping("/billing/{bookingId}/invoice")
    public String viewInvoice(@PathVariable("bookingId") Long bookingId,
                             HttpSession session,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        Optional<Booking> opt = billingService.getBookingForBill(bookingId);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Booking not found.");
            return "redirect:/admin/billing";
        }
        Booking booking = opt.get();
        BigDecimal totalPaid = paymentService.getTotalPaidForBooking(bookingId);
        BigDecimal amountDue = booking.getBillTotal().subtract(totalPaid);
        model.addAttribute("booking", booking);
        model.addAttribute("payments", paymentService.getPaymentsByBooking(bookingId));
        model.addAttribute("totalPaid", totalPaid);
        model.addAttribute("amountDue", amountDue);
        return "admin/invoice";
    }
}
