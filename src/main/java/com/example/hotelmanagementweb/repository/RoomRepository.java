package com.example.hotelmanagementweb.repository;

import com.example.hotelmanagementweb.model.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {

    // Find room by room number
    Optional<Room> findByRoomNumber(String roomNumber);

    // Find all available rooms
    List<Room> findByIsAvailableTrue();

    // Find rooms by type
    List<Room> findByRoomType(String roomType);

    // Find rooms by status
    List<Room> findByStatus(String status);

    // Find available rooms by type
    @Query("SELECT r FROM Room r WHERE r.isAvailable = true AND r.status = 'AVAILABLE' AND r.roomType = :roomType")
    List<Room> findAvailableRoomsByType(@Param("roomType") String roomType);

    // Find rooms on specific floor
    List<Room> findByFloor(Integer floor);

    // Find rooms in maintenance
    @Query("SELECT r FROM Room r WHERE r.status = 'MAINTENANCE'")
    List<Room> findRoomsInMaintenance();

    // Check availability by room number
    @Query("SELECT r FROM Room r WHERE r.roomNumber = :roomNumber AND r.isAvailable = true")
    Optional<Room> findAvailableRoomByNumber(@Param("roomNumber") String roomNumber);

    // Count available rooms by type
    @Query("SELECT COUNT(r) FROM Room r WHERE r.roomType = :roomType AND r.isAvailable = true AND r.status = 'AVAILABLE'")
    Long countAvailableByType(@Param("roomType") String roomType);

    // Count total rooms
    Long countByRoomType(String roomType);
}
