package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.Room;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.model.Notification;
import com.example.hotelmanagementweb.repository.BookingRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.scheduling.annotation.Scheduled;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import com.example.hotelmanagementweb.dto.DiscountResultDTO;
import com.example.hotelmanagementweb.dto.PackageValidationRequestDTO;
import com.example.hotelmanagementweb.dto.PackageValidationResultDTO;
import com.example.hotelmanagementweb.model.RoomPackage;
import com.example.hotelmanagementweb.repository.RoomPackageRepository;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final RoomService roomService;
    private final NotificationService notificationService;
    private final PaymentService paymentService;
    private final RoomPackageService packageService;
    private final RoomPackageRepository packageRepository;

    public BookingService(BookingRepository bookingRepository, 
                          RoomService roomService, 
                          NotificationService notificationService,
                          PaymentService paymentService,
                          RoomPackageService packageService,
                          RoomPackageRepository packageRepository) {
        this.bookingRepository = bookingRepository;
        this.roomService = roomService;
        this.notificationService = notificationService;
        this.paymentService = paymentService;
        this.packageService = packageService;
        this.packageRepository = packageRepository;
    }

    @Transactional(readOnly = true)
    public Optional<Booking> findById(Long id) {
        return bookingRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public List<Booking> findByUser(User user) {
        return bookingRepository.findByUserOrderByCreatedAtDesc(user);
    }

    @Transactional(readOnly = true)
    public List<Booking> findByUserId(Long userId) {
        return bookingRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    @Transactional(readOnly = true)
    public List<Booking> searchBookings(String search, String statusFilter, String sortBy, String sortDir) {
        // Normalise the search term:
        //   • Trim whitespace
        //   • Strip a leading '#' so users can search "#6" or "6" interchangeably
        String searchTerm = (search != null && !search.trim().isEmpty()) ? search.trim() : null;
        if (searchTerm != null && searchTerm.startsWith("#")) {
            searchTerm = searchTerm.substring(1).trim();
            if (searchTerm.isEmpty()) searchTerm = null;
        }

        // Normalise status filter — treat blank as "all"
        String statusTerm = (statusFilter != null && !statusFilter.trim().isEmpty()) ? statusFilter.trim() : null;

        // Fetch filtered results from DB
        java.util.List<Booking> results = bookingRepository.searchBookings(searchTerm, statusTerm);

        // Sort in-memory using Java Comparators (avoids Hibernate 6 HQL Sort incompatibilities)
        java.util.Comparator<Booking> comparator;
        String sortField = (sortBy != null) ? sortBy.trim().toLowerCase() : "";
        switch (sortField) {
            case "date":
                comparator = java.util.Comparator.comparing(
                    Booking::getCheckInDate,
                    java.util.Comparator.nullsLast(java.util.Comparator.naturalOrder()));
                break;
            case "id":
                comparator = java.util.Comparator.comparing(
                    Booking::getId,
                    java.util.Comparator.nullsLast(java.util.Comparator.naturalOrder()));
                break;
            default:
                // Default: sort by creation date
                comparator = java.util.Comparator.comparing(
                    Booking::getCreatedAt,
                    java.util.Comparator.nullsLast(java.util.Comparator.naturalOrder()));
                break;
        }

        // Apply direction — default to DESC (newest first)
        if ("ASC".equalsIgnoreCase(sortDir)) {
            results.sort(comparator);
        } else {
            results.sort(comparator.reversed());
        }

        return results;
    }


    @Transactional(readOnly = true)
    public boolean isRoomOccupiedNow(Long roomId) {
        return bookingRepository.countActiveBookingsNow(roomId, LocalDateTime.now()) > 0;
    }

    @Transactional(readOnly = true)
    public List<Booking> findByStatus(String status) {
        return bookingRepository.findByStatusOrderByCreatedAtDesc(status);
    }

    @Transactional(readOnly = true)
    public List<Booking> getRoomHistory(Long roomId) {
        return bookingRepository.findRoomHistory(roomId);
    }

    @Transactional(readOnly = true)
    public List<Booking> getAllRoomHistory() {
        return bookingRepository.findAllRoomHistory();
    }

    @Transactional(readOnly = true)
    public BigDecimal getTotalRevenue() {
        BigDecimal revenue = bookingRepository.getTotalRevenue();
        return revenue != null ? revenue : BigDecimal.ZERO;
    }

    @Transactional(readOnly = true)
    public BigDecimal getTotalSpentByUser(Long userId) {
        BigDecimal spent = bookingRepository.getTotalSpentByUser(userId);
        return spent != null ? spent : BigDecimal.ZERO;
    }

    @Transactional
    public Booking createBooking(User user,
            Long roomId,
            LocalDateTime checkInDate,
            LocalDateTime checkOutDate,
            Integer numberOfGuests,
            String guestName,
            String contactDetails,
            String specialRequests,
            Long packageId) {

        validateDates(checkInDate, checkOutDate);

        Room room = roomService.getRoomById(roomId)
                .orElseThrow(() -> new IllegalArgumentException("Selected room not found"));

        if (numberOfGuests == null || numberOfGuests <= 0) {
            throw new IllegalArgumentException("Number of guests must be at least 1");
        }
        if (room.getCapacity() != null && numberOfGuests > room.getCapacity()) {
            throw new IllegalArgumentException("Number of guests exceeds room capacity");
        }

        if (!roomService.isRoomAvailable(roomId)) {
            throw new IllegalStateException("Selected room is not available");
        }

        long nights = java.time.temporal.ChronoUnit.DAYS.between(checkInDate.toLocalDate(), checkOutDate.toLocalDate());
        if (nights == 0 && checkOutDate.isAfter(checkInDate)) {
            nights = 1; // Minimum 1 night charge for same-day or < 24h stay
        }

        BigDecimal pricePerNight = room.getPricePerNight();
        if (pricePerNight == null) {
            pricePerNight = BigDecimal.ZERO;
        }
        BigDecimal totalAmount = pricePerNight.multiply(BigDecimal.valueOf(nights));
        
        RoomPackage roomPackage = null;
        BigDecimal discountAmount = BigDecimal.ZERO;
        
        if (packageId != null) {
            PackageValidationRequestDTO req = new PackageValidationRequestDTO();
            req.setNumberOfGuests(numberOfGuests);
            req.setNumberOfNights((int) nights);
            req.setRoomType(room.getRoomType());

            PackageValidationResultDTO validation = packageService.validatePackageForBooking(req, packageId);
            if (!validation.isValid()) {
                throw new IllegalArgumentException(validation.getMessage());
            }

            DiscountResultDTO discount = packageService.applyPackageDiscount(totalAmount, packageId);
            totalAmount = discount.getFinalAmount();
            discountAmount = discount.getDiscountAmount();
            roomPackage = packageRepository.findById(packageId).orElse(null);
        }

        Booking booking = new Booking();
        booking.setUser(user);
        booking.setRoom(room);
        booking.setRoomPackage(roomPackage);
        booking.setPackageDiscountAmount(discountAmount != null ? discountAmount : BigDecimal.ZERO);
        booking.setDiscountAmount(BigDecimal.ZERO);
        booking.setCheckInDate(checkInDate);
        booking.setCheckOutDate(checkOutDate);
        booking.setNumberOfGuests(numberOfGuests);
        booking.setTotalAmount(totalAmount);
        booking.setStatus("CONFIRMED");
        booking.setGuestName(guestName != null ? guestName.trim() : null);
        booking.setContactDetails(contactDetails != null ? contactDetails.trim() : null);
        booking.setSpecialRequests(specialRequests != null ? specialRequests.trim() : null);

        // Mark room as reserved for the duration
        roomService.allocateRoom(roomId);

        Booking savedBooking = bookingRepository.save(booking);
        
        // Trigger notification
        String message = "Your booking for Room " + room.getRoomNumber() + " has been confirmed for " + 
                         savedBooking.getCheckInFormatted() + ". See you soon!";
        notificationService.createNotification(user, message, Notification.NotificationType.BOOKING, "/reservations/" + savedBooking.getId());

        return savedBooking;
    }

    @Transactional
    public Booking updateReservation(Long bookingId,
            LocalDateTime checkInDate,
            LocalDateTime checkOutDate,
            Integer numberOfGuests,
            String guestName,
            String contactDetails,
            String specialRequests) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Reservation not found"));

        if ("CANCELLED".equals(booking.getStatus()) || "COMPLETED".equals(booking.getStatus())) {
            throw new IllegalStateException("Cannot modify a " + booking.getStatus().toLowerCase() + " reservation");
        }

        validateDates(checkInDate, checkOutDate);

        Room room = booking.getRoom();

        if (numberOfGuests == null || numberOfGuests <= 0) {
            throw new IllegalArgumentException("Number of guests must be at least 1");
        }
        if (room.getCapacity() != null && numberOfGuests > room.getCapacity()) {
            throw new IllegalArgumentException("Number of guests exceeds room capacity");
        }

        long nights = java.time.temporal.ChronoUnit.DAYS.between(checkInDate.toLocalDate(), checkOutDate.toLocalDate());
        if (nights == 0 && checkOutDate.isAfter(checkInDate)) {
            nights = 1; // Minimum 1 night charge for stays < 24h
        }

        BigDecimal pricePerNight = room.getPricePerNight();
        if (pricePerNight == null) {
            pricePerNight = BigDecimal.ZERO;
        }
        BigDecimal totalAmount = pricePerNight.multiply(BigDecimal.valueOf(nights));

        booking.setCheckInDate(checkInDate);
        booking.setCheckOutDate(checkOutDate);
        booking.setNumberOfGuests(numberOfGuests);
        booking.setTotalAmount(totalAmount);
        if (guestName != null) {
            booking.setGuestName(guestName.trim());
        }
        if (contactDetails != null) {
            booking.setContactDetails(contactDetails.trim());
        }
        booking.setSpecialRequests(specialRequests != null ? specialRequests.trim() : null);

        return bookingRepository.save(booking);
    }

    @Transactional
    public void cancelBooking(Long bookingId) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));

        booking.setStatus("CANCELLED");
        bookingRepository.save(booking);

        if (booking.getRoom() != null && booking.getRoom().getId() != null) {
            roomService.releaseRoom(booking.getRoom().getId());
        }
    }

    /**
     * Performs digital check-in for a guest. Booking must be CONFIRMED or PENDING.
     * Records identity (ID/Passport), actual check-in time, and optional special
     * requests.
     */
    @Transactional
    public Booking performCheckIn(Long bookingId,
            String idPassportNumber,
            LocalDateTime checkInDateTime,
            String specialRequests) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));

        if ("CANCELLED".equals(booking.getStatus())) {
            throw new IllegalStateException("Cannot check in a cancelled booking");
        }
        if ("CHECKED_IN".equals(booking.getStatus())) {
            throw new IllegalStateException("This booking is already checked in");
        }
        if ("COMPLETED".equals(booking.getStatus())) {
            throw new IllegalStateException("Cannot check in a completed booking");
        }

        if (idPassportNumber == null || idPassportNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("ID/Passport number is required for identity verification");
        }
        if (checkInDateTime == null) {
            throw new IllegalArgumentException("Check-in date and time are required");
        }

        booking.setIdPassportNumber(idPassportNumber.trim());
        booking.setActualCheckInDateTime(checkInDateTime);
        if (specialRequests != null && !specialRequests.trim().isEmpty()) {
            booking.setSpecialRequests(specialRequests.trim());
        }
        booking.setStatus("CHECKED_IN");
        
        // Update room status to OCCUPIED when guest checks in
        if (booking.getRoom() != null && booking.getRoom().getId() != null) {
            roomService.markRoomOccupied(booking.getRoom().getId());
        }
        
        return bookingRepository.save(booking);
    }

    /**
     * Performs digital check-out. Booking must be CHECKED_IN.
     * Sets check-out time, applies additional charges to total, and releases the
     * room.
     */
    @Transactional
    public Booking performCheckOut(Long bookingId,
            LocalDateTime checkOutDateTime,
            BigDecimal additionalCharges) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));

        if (!"CHECKED_IN".equals(booking.getStatus())) {
            throw new IllegalStateException(
                    "Only checked-in bookings can be checked out. Current status: " + booking.getStatus());
        }
        if (booking.getActualCheckInDateTime() == null) {
            throw new IllegalStateException("Booking has no check-in time recorded");
        }
        if (checkOutDateTime == null) {
            throw new IllegalArgumentException("Check-out date and time are required");
        }
        if (checkOutDateTime.isBefore(booking.getActualCheckInDateTime())) {
            throw new IllegalArgumentException("Check-out time must be after check-in time");
        }

        booking.setActualCheckOutDateTime(checkOutDateTime);
        if (additionalCharges != null && additionalCharges.compareTo(BigDecimal.ZERO) > 0) {
            booking.setAdditionalCharges(additionalCharges);
            BigDecimal total = booking.getTotalAmount() != null ? booking.getTotalAmount() : BigDecimal.ZERO;
            booking.setTotalAmount(total.add(additionalCharges));
        } else {
            booking.setAdditionalCharges(BigDecimal.ZERO);
        }
        booking.setStatus("COMPLETED");

        if (booking.getRoom() != null && booking.getRoom().getId() != null) {
            roomService.releaseRoom(booking.getRoom().getId());
        }
        return bookingRepository.save(booking);
    }

    private void validateDates(LocalDateTime checkInDate, LocalDateTime checkOutDate) {
        if (checkInDate == null || checkOutDate == null) {
            throw new IllegalArgumentException("Check-in and check-out dates are required");
        }

        LocalDateTime now = LocalDateTime.now();
        if (checkInDate.isBefore(now.minusMinutes(5))) {
            throw new IllegalArgumentException("Check-in date cannot be in the past");
        }
        if (!checkOutDate.isAfter(checkInDate)) {
            throw new IllegalArgumentException("Check-out date must be after check-in date");
        }
    }

    @Transactional(readOnly = true)
    public List<com.example.hotelmanagementweb.dto.BookingTrendDto> getBookingTrends() {
        List<com.example.hotelmanagementweb.dto.BookingTrendDto> trends = bookingRepository.findBookingTrends();
        long totalRooms = roomService.getAllRooms().size();
        
        if (totalRooms > 0) {
            for (com.example.hotelmanagementweb.dto.BookingTrendDto dto : trends) {
                // Calculate simplified occupancy trend: bookings relative to total capacity
                // Using a 30-day average multiplier for a rough monthly capacity estimate
                // Total Capacity per month = totalRooms * 30 nights
                // Occupancy = bookingCount / (totalRooms * 30) * 100
                // Since our records are aggregated at check-in, we treat each record as a potential room-night occupancy point
                // Note: A more precise logic would sum up individual night records.
                double monthlyCapacity = (double) totalRooms * 30.0;
                double rate = (dto.getBookingCount() / monthlyCapacity) * 100.0;
                dto.setOccupancyPercentage(Math.min(100.0, rate * 10.0)); // Adjusting scale for demo purposes
            }
        }
        return trends;
    }

    /**
     * Extends the guest's stay by updating the check-out date and calculating additional charges.
     * US4.5: Late Check-out / Stay Extension
     * Now includes a fixed extension fee and creates a separate payment record (bill).
     */
    @Transactional
    public Booking extendStay(Long bookingId, LocalDateTime newCheckOutDate) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found"));

        if (!"CONFIRMED".equals(booking.getStatus()) && !"CHECKED_IN".equals(booking.getStatus())) {
            throw new IllegalStateException("Only confirmed or checked-in bookings can be extended. Current status: " + booking.getStatus());
        }

        LocalDateTime currentCheckOutDate = booking.getCheckOutDate();
        if (newCheckOutDate == null || !newCheckOutDate.isAfter(currentCheckOutDate)) {
            throw new IllegalArgumentException("New check-out date (" + newCheckOutDate + ") must be after the current check-out date (" + currentCheckOutDate + ")");
        }

        // 1. Validation: Check roomAvailability before confirming
        long overlapping = bookingRepository.countOverlappingBookings(
                booking.getRoom().getId(), 
                bookingId, 
                currentCheckOutDate, 
                newCheckOutDate
        );
        
        if (overlapping > 0) {
            throw new IllegalStateException("The room is already booked by another guest for the requested extension period.");
        }

        // 2. Logic: Automated fare calculation (Charge per additional night).
        long extraNights = java.time.temporal.ChronoUnit.DAYS.between(currentCheckOutDate.toLocalDate(), newCheckOutDate.toLocalDate());
        
        BigDecimal pricePerNight = booking.getRoom().getPricePerNight();
        if (pricePerNight == null) pricePerNight = BigDecimal.ZERO;
        
        // Only charge daily rate if extending to a new day (extraNights > 0)
        BigDecimal additionalFare = pricePerNight.multiply(BigDecimal.valueOf(Math.max(0, extraNights)));
        
        // 3. Extension Fee: Add a flat $10.00 convenience fee for the transaction
        BigDecimal extensionFee = new BigDecimal("10.00");
        BigDecimal totalExtensionCost = additionalFare.add(extensionFee);

        // 4. Update Booking Entity
        BigDecimal currentTotal = booking.getTotalAmount() != null ? booking.getTotalAmount() : BigDecimal.ZERO;
        BigDecimal currentAdditional = booking.getAdditionalCharges() != null ? booking.getAdditionalCharges() : BigDecimal.ZERO;
        
        booking.setTotalAmount(currentTotal.add(totalExtensionCost));
        booking.setAdditionalCharges(currentAdditional.add(totalExtensionCost));
        booking.setCheckOutDate(newCheckOutDate);
        
        Booking savedBooking = bookingRepository.save(booking);

        // 5. Create a Bill (Payment record) for this extension
        paymentService.processPayment(
            bookingId, 
            totalExtensionCost, 
            "STAY_EXTENSION", 
            "EXT-" + System.currentTimeMillis(), 
            "PENDING" // Set to Pending so guest can pay for it later or at checkout
        );

        return savedBooking;
    }

    /**
     * US4.6: Automated Room Status Update.
     * Periodically checks for bookings that have passed their check-out time
     * and automatically releases the room.
     * 1. If CHECKED_IN: Performs auto check-out (Status -> COMPLETED).
     * 2. If CONFIRMED or PENDING: Performs auto-release (Status -> CANCELLED or EXPIRED).
     */
    @Scheduled(fixedRate = 30000) // Increased frequency to 30s
    public void autoReleaseExpiredRooms() {
        // No @Transactional on the whole method to ensure each booking update is independent
        List<String> statusesToCheck = java.util.Arrays.asList("CHECKED_IN", "CONFIRMED", "PENDING", "RESERVED");
        LocalDateTime now = LocalDateTime.now();
        
        for (String status : statusesToCheck) {
            try {
                // Fetch bookings for this status. Fetching is done outside transactional loop
                List<Booking> bookings = bookingRepository.findByStatusOrderByCreatedAtDesc(status);
                for (Booking booking : bookings) {
                    if (booking.getCheckOutDate() != null && booking.getCheckOutDate().isBefore(now)) {
                        // Use a dedicated method or handle transactionally to avoid batch failures
                        processExpiredBooking(booking, status, now);
                    }
                }
            } catch (Exception e) {
                // Outer loop error
                System.err.println("Scheduler error for status " + status + ": " + e.getMessage());
            }
        }
    }

    @Transactional
    public void processExpiredBooking(Booking booking, String status, LocalDateTime now) {
        try {
            if ("CHECKED_IN".equals(status)) {
                // Keep rooms checked in so staff can perform manual check-out with charges
                return;
            } else {
                // Auto release for reserved rooms that were never checked in or stayed pending
                booking.setStatus("CANCELLED");
                if (booking.getRoom() != null && booking.getRoom().getId() != null) {
                    roomService.releaseRoom(booking.getRoom().getId());
                }
                bookingRepository.save(booking);
            }
        } catch (Exception e) {
            System.err.println("Failed to auto-release booking #" + booking.getId() + ": " + e.getMessage());
        }
    }
}
