package com.example.hotelmanagementweb.repository;

import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {

    List<Booking> findByUserOrderByCreatedAtDesc(User user);

    @Query("SELECT b FROM Booking b WHERE b.user.id = :userId ORDER BY b.createdAt DESC")
    List<Booking> findByUserIdOrderByCreatedAtDesc(@Param("userId") Long userId);

    List<Booking> findByUserAndStatusOrderByCreatedAtDesc(User user, String status);

    @Query("SELECT b FROM Booking b WHERE b.user.id = :userId AND b.checkInDate >= CURRENT_TIMESTAMP AND b.status IN ('PENDING', 'CONFIRMED', 'CHECKED_IN') ORDER BY b.checkInDate ASC")
    List<Booking> findUpcomingBookingsByUserId(@Param("userId") Long userId);

    @Query("SELECT b FROM Booking b WHERE b.user.id = :userId AND (b.status = 'COMPLETED' OR (b.checkOutDate < CURRENT_TIMESTAMP AND b.status NOT IN ('CANCELLED'))) ORDER BY b.checkOutDate DESC")
    List<Booking> findPastBookingsByUserId(@Param("userId") Long userId);

    List<Booking> findByStatusOrderByCreatedAtDesc(String status);

    @Query("SELECT b FROM Booking b WHERE b.status IN ('CONFIRMED', 'CHECKED_IN', 'COMPLETED') ORDER BY b.updatedAt DESC")
    List<Booking> findCompletedBookingsOrderByUpdatedDesc();

    @Query("SELECT b FROM Booking b WHERE b.room.id = :roomId ORDER BY b.updatedAt DESC")
    List<Booking> findRoomHistory(@Param("roomId") Long roomId);

    @Query("SELECT b FROM Booking b ORDER BY b.updatedAt DESC")
    List<Booking> findAllRoomHistory();

    @Query("SELECT b FROM Booking b WHERE b.status IN ('CONFIRMED', 'CHECKED_IN', 'COMPLETED') ORDER BY b.updatedAt DESC")
    List<Booking> findForBilling();

    @Query("SELECT DISTINCT b FROM Booking b JOIN Payment p ON p.booking.id = b.id WHERE p.status = 'COMPLETED' ORDER BY b.updatedAt DESC")
    List<Booking> findBookingsWithCompletedPayments();

    @Query("SELECT new com.example.hotelmanagementweb.dto.BookingTrendDto(YEAR(b.checkInDate), MONTH(b.checkInDate), COUNT(b), SUM(b.totalAmount)) " +
           "FROM Booking b " +
           "WHERE b.status <> 'CANCELLED' " +
           "GROUP BY YEAR(b.checkInDate), MONTH(b.checkInDate) " +
           "ORDER BY YEAR(b.checkInDate) DESC, MONTH(b.checkInDate) DESC")
    List<com.example.hotelmanagementweb.dto.BookingTrendDto> findBookingTrends();

    @Query("SELECT COUNT(b) FROM Booking b WHERE b.room.id = :roomId AND b.id <> :bookingId AND b.status IN ('CONFIRMED', 'CHECKED_IN') AND b.checkInDate < :newCheckOutDate AND b.checkOutDate > :newCheckInDate")
    long countOverlappingBookings(@Param("roomId") Long roomId, @Param("bookingId") Long bookingId, @Param("newCheckInDate") LocalDateTime newCheckInDate, @Param("newCheckOutDate") LocalDateTime newCheckOutDate);

    @Query("SELECT COUNT(b) FROM Booking b WHERE b.room.id = :roomId AND b.status IN ('CONFIRMED', 'CHECKED_IN') AND b.checkInDate <= :now AND b.checkOutDate >= :now")
    long countActiveBookingsNow(@Param("roomId") Long roomId, @Param("now") LocalDateTime now);

    @Query("SELECT b FROM Booking b WHERE " +
           "(:search IS NULL OR :search = '' OR " +
           "LOWER(b.user.username) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(b.contactDetails) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(b.guestName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "CAST(b.id AS string) LIKE CONCAT('%', :search, '%')) " +
           "AND (:status IS NULL OR b.status = :status)")
    List<Booking> searchBookings(@Param("search") String search, @Param("status") String status);

    @Query("SELECT SUM(b.totalAmount) FROM Booking b WHERE b.status <> 'CANCELLED'")
    BigDecimal getTotalRevenue();

    @Query("SELECT SUM(b.totalAmount) FROM Booking b WHERE b.user.id = :userId AND b.status <> 'CANCELLED'")
    BigDecimal getTotalSpentByUser(@Param("userId") Long userId);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.transaction.annotation.Transactional
    @Query("UPDATE Booking b SET b.roomPackage = null WHERE b.roomPackage.id = :packageId")
    void nullifyPackage(@Param("packageId") Long packageId);
}
