package com.example.hotelmanagementweb.controller;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.CardDetails;
import com.example.hotelmanagementweb.model.Room;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.repository.CardDetailsRepository;
import com.example.hotelmanagementweb.service.BookingService;
import com.example.hotelmanagementweb.service.PaymentService;
import com.example.hotelmanagementweb.service.RoomService;
import com.example.hotelmanagementweb.service.RoomPackageService;
import jakarta.servlet.http.HttpSession;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping
public class BookingController {

    private final BookingService bookingService;
    private final RoomService roomService;
    private final PaymentService paymentService;
    private final CardDetailsRepository cardDetailsRepository;
    private final RoomPackageService packageService;

    public BookingController(BookingService bookingService, RoomService roomService,
            PaymentService paymentService, CardDetailsRepository cardDetailsRepository,
            RoomPackageService packageService) {
        this.bookingService = bookingService;
        this.roomService = roomService;
        this.paymentService = paymentService;
        this.cardDetailsRepository = cardDetailsRepository;
        this.packageService = packageService;
    }

    // Show booking form for online booking
    @GetMapping("/reservations")
    public String showBookingForm(@RequestParam(value = "roomId", required = false) Long roomId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("user") == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to create a booking.");
            return "redirect:/login";
        }

        List<Room> availableRooms = roomService.getAvailableRooms();
        model.addAttribute("availableRooms", availableRooms);
        model.addAttribute("selectedRoomId", roomId);
        model.addAttribute("packages", packageService.getAllActivePackages());

        return "booking/booking-form";
    }

    // Handle reservation creation
    @PostMapping("/reservations")
    public String createReservation(@RequestParam(name = "roomId") Long roomId,
            @RequestParam(name = "guestName") String guestName,
            @RequestParam(name = "contactDetails") String contactDetails,
            @RequestParam(name = "checkInDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime checkInDate,
            @RequestParam(name = "checkOutDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime checkOutDate,
            @RequestParam(name = "numberOfGuests") Integer numberOfGuests,
            @RequestParam(name = "specialRequests", required = false) String specialRequests,
            @RequestParam(name = "cardNumber", required = false) String cardNumber,
            @RequestParam(name = "cardExpiry", required = false) String cardExpiry,
            @RequestParam(name = "paymentMethod", defaultValue = "CARD") String paymentMethod,
            @RequestParam(name = "paymentSlip", required = false) MultipartFile paymentSlip,
            @RequestParam(name = "packageId", required = false) Long packageId,
            @RequestParam(name = "saveCard", required = false, defaultValue = "false") boolean saveCard,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to create a reservation.");
            return "redirect:/login";
        }

        if (guestName == null || guestName.trim().isEmpty()
                || contactDetails == null || contactDetails.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Guest name and contact details are required.");
            return "redirect:/reservations";
        }

        try {
            Booking booking = bookingService.createBooking(
                    user,
                    roomId,
                    checkInDate,
                    checkOutDate,
                    numberOfGuests,
                    guestName,
                    contactDetails,
                    specialRequests,
                    packageId);

            if ("CARD".equalsIgnoreCase(paymentMethod) && cardNumber != null && !cardNumber.isEmpty() && cardExpiry != null && !cardExpiry.isEmpty()) {
                paymentService.processPayment(booking.getId(), booking.getTotalAmount(), "CARD",
                        "TXN-" + System.currentTimeMillis(), "COMPLETED");

                // Only save card details if the user explicitly allowed it
                if (saveCard) {
                    CardDetails card = new CardDetails();
                    card.setUser(user);
                    card.setCardHolderName(guestName != null ? guestName : user.getUsername());
                    card.setCardNumber(
                            cardNumber.length() >= 4 ? cardNumber.substring(cardNumber.length() - 4) : cardNumber);
                    card.setExpiryDate(cardExpiry);

                    String type = "VISA";
                    if (cardNumber.startsWith("5"))
                        type = "MASTERCARD";
                    else if (cardNumber.startsWith("3"))
                        type = "AMEX";
                    else if (cardNumber.startsWith("6"))
                        type = "DISCOVER";
                    card.setCardType(type);

                    card.setIsDefault(false);
                    cardDetailsRepository.save(card);
                }
            } else if ("SLIP".equalsIgnoreCase(paymentMethod) && paymentSlip != null && !paymentSlip.isEmpty()) {
                try {
                    paymentService.processPaymentWithSlip(booking.getId(), booking.getTotalAmount(), paymentSlip);
                } catch (IOException e) {
                    redirectAttributes.addFlashAttribute("error", "Error saving payment slip: " + e.getMessage());
                    return "redirect:/reservations/" + booking.getId();
                }
            }

            redirectAttributes.addFlashAttribute("success",
                    "Reservation created successfully! Your reservation ID is #" + booking.getId());
            return "redirect:/reservations/" + booking.getId();
        } catch (IllegalArgumentException | IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/reservations";
        }
    }

    // Reservation details page (view reservation status)
    @GetMapping("/reservations/{id}")
    public String reservationDetails(@PathVariable("id") Long id,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view reservation details.");
            return "redirect:/login";
        }

        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (!bookingOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Reservation not found.");
            return "redirect:/my-bookings";
        }

        Booking booking = bookingOpt.get();
        if (!booking.getUser().getId().equals(user.getId()) && !isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "You are not allowed to view this reservation.");
            return "redirect:/my-bookings";
        }

        model.addAttribute("reservation", booking);
        
        // Users can only modify a reservation within 24 hours of creation. Staff/Admin always allowed.
        boolean canModify = isStaff(session) || (booking.getCreatedAt() != null && booking.getCreatedAt().plusHours(24).isAfter(LocalDateTime.now()));
        model.addAttribute("canModify", canModify);
        
        return "booking/reservation-details";
    }

    // Booking history page for the logged-in user
    @GetMapping("/my-bookings")
    public String myBookings(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view your bookings.");
            return "redirect:/login";
        }

        // Strictly show ONLY this user's bookings
        List<Booking> bookings = bookingService.findByUserId(user.getId());
        
        model.addAttribute("bookings", bookings);
        model.addAttribute("now", java.time.LocalDateTime.now());
        return "booking/my-bookings";
    }

    // Administrative Booking Management (Staff/Admin only)
    @GetMapping("/admin/bookings")
    public String adminManageBookings(HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null || (!"ADMIN".equals(user.getRole()) && !"EMPLOYEE".equals(user.getRole()))) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff privileges required.");
            return "redirect:/login";
        }
        return "redirect:/admin/dashboard#booking-management";
    }

    // Show edit form for an existing booking
    @GetMapping("/reservations/{id}/edit")
    public String editBookingForm(@PathVariable("id") Long id,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to modify a booking.");
            return "redirect:/login";
        }

        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (!bookingOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Booking not found.");
            return "redirect:/my-bookings";
        }

        Booking booking = bookingOpt.get();
        if (!booking.getUser().getId().equals(user.getId()) && !isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "You are not allowed to modify this booking.");
            return "redirect:/my-bookings";
        }
        
        // Enforce 24-hour modification policy for guests
        boolean canModify = isStaff(session) || (booking.getCreatedAt() != null && booking.getCreatedAt().plusHours(24).isAfter(LocalDateTime.now()));
        
        if ("CANCELLED".equals(booking.getStatus()) || "COMPLETED".equals(booking.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "Reservations with " + booking.getStatus() + " status cannot be edited.");
            return "redirect:/reservations/" + id;
        }

        if (!canModify) {
            redirectAttributes.addFlashAttribute("error", "Modifications are only allowed within 24 hours of booking. Please contact the front desk.");
            return "redirect:/reservations/" + id;
        }

        model.addAttribute("booking", booking);
        return "booking/booking-edit";
    }

    // Handle reservation modification
    @PostMapping("/reservations/{id}/edit")
    public String updateReservation(@PathVariable("id") Long id,
            @RequestParam(name = "guestName") String guestName,
            @RequestParam(name = "contactDetails") String contactDetails,
            @RequestParam(name = "checkInDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime checkInDate,
            @RequestParam(name = "checkOutDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime checkOutDate,
            @RequestParam(name = "numberOfGuests") Integer numberOfGuests,
            @RequestParam(name = "specialRequests", required = false) String specialRequests,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to modify a reservation.");
            return "redirect:/login";
        }

        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (!bookingOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Reservation not found.");
            return "redirect:/my-bookings";
        }

        Booking booking = bookingOpt.get();
        if (!booking.getUser().getId().equals(user.getId()) && !isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "You are not allowed to modify this reservation.");
            return "redirect:/my-bookings";
        }

        // Enforce status restriction and 24-hour modification policy for guests (server-side check)
        boolean canModify = isStaff(session) || (booking.getCreatedAt() != null && booking.getCreatedAt().plusHours(24).isAfter(LocalDateTime.now()));
        
        if ("CANCELLED".equals(booking.getStatus()) || "COMPLETED".equals(booking.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "Reservations with " + booking.getStatus() + " status cannot be edited.");
            return "redirect:/reservations/" + id;
        }

        if (!canModify) {
            redirectAttributes.addFlashAttribute("error", "Modifications are only allowed within 24 hours of booking. Please contact the front desk.");
            return "redirect:/reservations/" + id;
        }

        if (guestName == null || guestName.trim().isEmpty()
                || contactDetails == null || contactDetails.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Guest name and contact details are required.");
            return "redirect:/reservations/" + id + "/edit";
        }

        try {
            bookingService.updateReservation(id, checkInDate, checkOutDate, numberOfGuests,
                    guestName, contactDetails, specialRequests);
            redirectAttributes.addFlashAttribute("success", "Reservation updated successfully.");
        } catch (IllegalArgumentException | IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/reservations/" + id + "/edit";
        }

        return "redirect:/reservations/" + id;
    }

    // Cancel reservation
    @PostMapping("/reservations/{id}/cancel")
    public String cancelReservation(@PathVariable("id") Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("user") == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to cancel a reservation.");
            return "redirect:/login";
        }

        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (!bookingOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Reservation not found.");
            return "redirect:/my-bookings";
        }

        // Allow ONLY staff/admin to cancel reservations
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "You are not allowed to cancel reservations. Please contact the front desk.");
            return "redirect:/reservations/" + id;
        }

        bookingService.cancelBooking(id);
        redirectAttributes.addFlashAttribute("success", "Reservation cancelled successfully.");
        return "redirect:/reservations/" + id;
    }

    // Walk-in booking form for staff (ADMIN/EMPLOYEE)
    @GetMapping("/admin/walkin-bookings")
    public String walkInBookingForm(HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null || (!"ADMIN".equals(user.getRole()) && !"EMPLOYEE".equals(user.getRole()))) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }

        List<Room> availableRooms = roomService.getAvailableRooms();
        model.addAttribute("availableRooms", availableRooms);
        model.addAttribute("packages", packageService.getAllActivePackages());
        return "booking/walkin-booking-form";
    }

    // Handle walk-in booking (staff creates on behalf of guest)
    @PostMapping("/admin/walkin-bookings")
    public String createWalkInBooking(@RequestParam(name = "roomId") Long roomId,
            @RequestParam(name = "guestName") String guestName,
            @RequestParam(name = "contactDetails") String contactDetails,
            @RequestParam(name = "checkInDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime checkInDate,
            @RequestParam(name = "checkOutDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime checkOutDate,
            @RequestParam(name = "numberOfGuests") Integer numberOfGuests,
            @RequestParam(name = "specialRequests", required = false) String specialRequests,
            @RequestParam(name = "packageId", required = false) Long packageId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null || (!"ADMIN".equals(user.getRole()) && !"EMPLOYEE".equals(user.getRole()))) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }

        if (guestName == null || guestName.trim().isEmpty()
                || contactDetails == null || contactDetails.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Guest name and contact details are required.");
            return "redirect:/admin/walkin-bookings";
        }

        try {
            Booking booking = bookingService.createBooking(
                    user,
                    roomId,
                    checkInDate,
                    checkOutDate,
                    numberOfGuests,
                    guestName,
                    contactDetails,
                    specialRequests,
                    packageId);

            redirectAttributes.addFlashAttribute("success",
                    "Walk-in reservation created successfully! Reservation ID #" + booking.getId());
            return "redirect:/reservations/" + booking.getId();
        } catch (IllegalArgumentException | IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/walkin-bookings";
        }
    }

    // ---- Check-In / Check-Out (staff: ADMIN or EMPLOYEE) ----
    private boolean isStaff(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && ("ADMIN".equals(user.getRole()) || "EMPLOYEE".equals(user.getRole()));
    }

    private String staffDashboardRedirect(User user) {
        return "ADMIN".equals(user.getRole()) ? "/admin/dashboard" : "/dashboard";
    }

    @GetMapping("/admin/checkin")
    public String checkInForm(@RequestParam(name = "bookingId", required = false) Long bookingId,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }

        List<Booking> confirmedBookings = bookingService.findByStatus("CONFIRMED");
        model.addAttribute("confirmedBookings", confirmedBookings);

        if (bookingId != null) {
            Optional<Booking> opt = bookingService.findById(bookingId);
            if (opt.isPresent()) {
                model.addAttribute("booking", opt.get());
            } else {
                redirectAttributes.addFlashAttribute("error", "Booking not found.");
            }
        }
        return "admin/checkin-form";
    }

    @PostMapping("/admin/checkin")
    public String processCheckIn(@RequestParam(name = "bookingId") Long bookingId,
            @RequestParam(name = "guestName") String guestName,
            @RequestParam(name = "idPassportNumber") String idPassportNumber,
            @RequestParam(name = "roomNumber") String roomNumber,
            @RequestParam(name = "checkInDateTime") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime checkInDateTime,
            @RequestParam(name = "specialRequests", required = false) String specialRequests,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        if (bookingId == null || guestName == null || guestName.trim().isEmpty()
                || idPassportNumber == null || idPassportNumber.trim().isEmpty()
                || roomNumber == null || roomNumber.trim().isEmpty() || checkInDateTime == null) {
            redirectAttributes.addFlashAttribute("error",
                    "Booking ID, guest name, ID/Passport number, room number, and check-in date & time are required.");
            return "redirect:/admin/checkin";
        }
        Optional<Booking> opt = bookingService.findById(bookingId);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Booking not found.");
            return "redirect:/admin/checkin";
        }
        Booking b = opt.get();
        if (!guestName.trim().equalsIgnoreCase(b.getGuestName() != null ? b.getGuestName().trim() : "")) {
            redirectAttributes.addFlashAttribute("error", "Guest name does not match the reservation.");
            return "redirect:/admin/checkin?bookingId=" + bookingId;
        }
        if (!roomNumber.trim().equals(b.getRoom() != null ? b.getRoom().getRoomNumber() : "")) {
            redirectAttributes.addFlashAttribute("error", "Room number does not match the reservation.");
            return "redirect:/admin/checkin?bookingId=" + bookingId;
        }
        try {
            bookingService.performCheckIn(bookingId, idPassportNumber.trim(), checkInDateTime, specialRequests);
            redirectAttributes.addFlashAttribute("success",
                    "Check-in completed successfully for Booking #" + bookingId + ".");
            return "redirect:" + staffDashboardRedirect(user);
        } catch (IllegalArgumentException | IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/checkin?bookingId=" + bookingId;
        }
    }

    @GetMapping("/admin/checkout")
    public String checkOutForm(@RequestParam(name = "bookingId", required = false) Long bookingId,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }

        List<Booking> activeBookings = bookingService.findByStatus("CHECKED_IN");
        model.addAttribute("activeBookings", activeBookings);

        if (bookingId != null) {
            Optional<Booking> opt = bookingService.findById(bookingId);
            if (opt.isPresent()) {
                Booking bk = opt.get();
                model.addAttribute("booking", bk);
                if (bk.getActualCheckInDateTime() != null) {
                    model.addAttribute("checkInDateTimeIso", bk.getActualCheckInDateTime().toString());
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Booking not found.");
            }
        }
        return "admin/checkout-form";
    }

    @PostMapping("/admin/checkout")
    public String processCheckOut(@RequestParam(name = "bookingId") Long bookingId,
            @RequestParam(name = "roomNumber") String roomNumber,
            @RequestParam(name = "checkOutDateTime") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime checkOutDateTime,
            @RequestParam(name = "additionalCharges", required = false) BigDecimal additionalCharges,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        if (bookingId == null || roomNumber == null || roomNumber.trim().isEmpty() || checkOutDateTime == null) {
            redirectAttributes.addFlashAttribute("error",
                    "Booking ID, room number, and check-out date & time are required.");
            return "redirect:/admin/checkout";
        }
        Optional<Booking> opt = bookingService.findById(bookingId);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Booking not found.");
            return "redirect:/admin/checkout";
        }
        Booking b = opt.get();
        if (!roomNumber.trim().equals(b.getRoom() != null ? b.getRoom().getRoomNumber() : "")) {
            redirectAttributes.addFlashAttribute("error", "Room number does not match the booking.");
            return "redirect:/admin/checkout?bookingId=" + bookingId;
        }
        try {
            bookingService.performCheckOut(bookingId, checkOutDateTime,
                    additionalCharges != null ? additionalCharges : BigDecimal.ZERO);
            redirectAttributes.addFlashAttribute("success", "Check-out completed successfully for Booking #" + bookingId
                    + ". Stay duration has been recorded.");
            return "redirect:" + staffDashboardRedirect(user);
        } catch (IllegalArgumentException | IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/checkout?bookingId=" + bookingId;
        }
    }

    /**
     * Handles requests to extend a guest's stay.
     * US4.5: Late Check-out / Stay Extension
     */
    @PostMapping("/reservations/{id}/extend")
    public String extendStay(@PathVariable("id") Long id,
            @RequestParam(name = "newCheckOutDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime newCheckOutDate,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to extend your stay.");
            return "redirect:/login";
        }

        Optional<Booking> bookingOpt = bookingService.findById(id);
        if (!bookingOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Reservation not found.");
            return "redirect:/my-bookings";
        }

        Booking booking = bookingOpt.get();
        // Allow the user who made the booking OR an admin/staff to extend the stay
        if (!booking.getUser().getId().equals(user.getId()) && !isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "You are not allowed to extend this stay.");
            return "redirect:/my-bookings";
        }

        try {
            bookingService.extendStay(id, newCheckOutDate);
            redirectAttributes.addFlashAttribute("success", 
                "Stay extended successfully to " + newCheckOutDate + ". Additional charges have been calculated and added to the bill.");
        } catch (IllegalArgumentException | IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }

        return "redirect:/reservations/" + id;
    }
}
