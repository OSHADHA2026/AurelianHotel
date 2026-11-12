package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.Room;
import com.example.hotelmanagementweb.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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
public class RoomService {

    @Autowired
    private RoomRepository roomRepository;

    // Create a new room
    public Room createRoom(String roomNumber, String roomType, Integer capacity, BigDecimal pricePerNight,
            String description, Integer floor, String amenities, Double roomSize, MultipartFile image) throws IOException {
        // Check if room already exists
        if (roomRepository.findByRoomNumber(roomNumber).isPresent()) {
            throw new IllegalArgumentException("Room with number " + roomNumber + " already exists");
        }

        Room room = new Room(roomNumber, roomType, capacity, pricePerNight, description, floor, amenities);
        room.setRoomSize(roomSize);
        
        if (image != null && !image.isEmpty()) {
            String imagePath = saveImage(image);
            room.setImagePath(imagePath);
        }
        
        return roomRepository.save(room);
    }

    // Get all rooms
    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    // Get room by ID
    public Optional<Room> getRoomById(Long id) {
        return roomRepository.findById(id);
    }

    // Get room by room number
    public Optional<Room> getRoomByNumber(String roomNumber) {
        return roomRepository.findByRoomNumber(roomNumber);
    }

    // Update room details
    public Room updateRoom(Long id, String roomType, Integer capacity, BigDecimal pricePerNight,
            String description, String amenities, String status, Double roomSize, MultipartFile image) throws IOException {
        Optional<Room> roomOpt = roomRepository.findById(id);
        if (!roomOpt.isPresent()) {
            throw new IllegalArgumentException("Room not found");
        }

        Room room = roomOpt.get();
        if (roomType != null)
            room.setRoomType(roomType);
        if (capacity != null) {
            room.setCapacity(capacity);
            room.setMaxOccupancy(capacity);
        }
        if (pricePerNight != null)
            room.setPricePerNight(pricePerNight);
        if (description != null)
            room.setDescription(description);
        if (amenities != null)
            room.setAmenities(amenities);
        if (roomSize != null)
            room.setRoomSize(roomSize);
        if (status != null) {
            room.setStatus(status);
            room.setIsAvailable("AVAILABLE".equalsIgnoreCase(status));
        }
        if (image != null && !image.isEmpty()) {
            String imagePath = saveImage(image);
            room.setImagePath(imagePath);
        }

        return roomRepository.save(room);
    }

    private String saveImage(MultipartFile file) throws IOException {
        if (file.getSize() > 5 * 1024 * 1024) {
            throw new IllegalArgumentException("File size exceeds 5MB limit");
        }

        String contentType = file.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png") && !contentType.equals("image/webp"))) {
            throw new IllegalArgumentException("Only images (JPG, PNG, WEBP) are allowed");
        }

        String originalFileName = file.getOriginalFilename();
        String extension = originalFileName != null ? originalFileName.substring(originalFileName.lastIndexOf(".")) : ".jpg";
        String fileName = "room_" + UUID.randomUUID().toString() + extension;
        
        Path uploadPath = Paths.get("room-images");
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return filePath.toString().replace("\\", "/");
    }

    // Update room pricing
    public Room updateRoomPrice(Long id, BigDecimal newPrice) {
        Optional<Room> roomOpt = roomRepository.findById(id);
        if (!roomOpt.isPresent()) {
            throw new IllegalArgumentException("Room not found");
        }

        Room room = roomOpt.get();
        room.setPricePerNight(newPrice);
        return roomRepository.save(room);
    }

    // Get all available rooms
    public List<Room> getAvailableRooms() {
        return roomRepository.findByIsAvailableTrue();
    }

    // Get available rooms by type
    public List<Room> getAvailableRoomsByType(String roomType) {
        return roomRepository.findAvailableRoomsByType(roomType);
    }

    // Get rooms by room type
    public List<Room> getRoomsByType(String roomType) {
        return roomRepository.findByRoomType(roomType);
    }

    // Get rooms by status
    public List<Room> getRoomsByStatus(String status) {
        return roomRepository.findByStatus(status);
    }

    // Mark room as available
    public Room markRoomAvailable(Long id) {
        Optional<Room> roomOpt = roomRepository.findById(id);
        if (!roomOpt.isPresent()) {
            throw new IllegalArgumentException("Room not found");
        }

        Room room = roomOpt.get();
        room.setIsAvailable(true);
        room.setStatus("AVAILABLE");
        room.setMaintenanceStartDate(null);
        room.setMaintenanceEndDate(null);
        room.setMaintenanceNotes(null);
        return roomRepository.save(room);
    }

    // Mark room as occupied
    public Room markRoomOccupied(Long id) {
        Optional<Room> roomOpt = roomRepository.findById(id);
        if (!roomOpt.isPresent()) {
            throw new IllegalArgumentException("Room not found");
        }

        Room room = roomOpt.get();
        room.setIsAvailable(false);
        room.setStatus("OCCUPIED");
        return roomRepository.save(room);
    }

    // Schedule maintenance for room
    public Room scheduleMaintenance(Long id, LocalDateTime startDate, LocalDateTime endDate, String notes) {
        Optional<Room> roomOpt = roomRepository.findById(id);
        if (!roomOpt.isPresent()) {
            throw new IllegalArgumentException("Room not found");
        }

        Room room = roomOpt.get();
        room.setStatus("MAINTENANCE");
        room.setIsAvailable(false);
        room.setMaintenanceStartDate(startDate);
        room.setMaintenanceEndDate(endDate);
        room.setMaintenanceNotes(notes);
        return roomRepository.save(room);
    }

    // Complete maintenance
    public Room completeMaintenance(Long id) {
        Optional<Room> roomOpt = roomRepository.findById(id);
        if (!roomOpt.isPresent()) {
            throw new IllegalArgumentException("Room not found");
        }

        Room room = roomOpt.get();
        room.setStatus("AVAILABLE");
        room.setIsAvailable(true);
        room.setMaintenanceStartDate(null);
        room.setMaintenanceEndDate(null);
        room.setMaintenanceNotes(null);
        return roomRepository.save(room);
    }

    // Get rooms in maintenance
    public List<Room> getRoomsInMaintenance() {
        return roomRepository.findRoomsInMaintenance();
    }

    // Get rooms on specific floor
    public List<Room> getRoomsByFloor(Integer floor) {
        return roomRepository.findByFloor(floor);
    }

    // Check if room is available
    public boolean isRoomAvailable(Long id) {
        Optional<Room> room = roomRepository.findById(id);
        return room.isPresent() && room.get().getIsAvailable();
    }

    // Count available rooms by type
    public Long countAvailableByType(String roomType) {
        return roomRepository.countAvailableByType(roomType);
    }

    // Count total rooms by type
    public Long countRoomsByType(String roomType) {
        return roomRepository.countByRoomType(roomType);
    }

    // Allocate/Reserve a room
    public Room allocateRoom(Long id) {
        Optional<Room> roomOpt = roomRepository.findById(id);
        if (!roomOpt.isPresent()) {
            throw new IllegalArgumentException("Room not found");
        }

        Room room = roomOpt.get();
        if (!room.getIsAvailable()) {
            throw new IllegalStateException("Room is not available for allocation");
        }

        room.setStatus("RESERVED");
        room.setIsAvailable(false);
        return roomRepository.save(room);
    }

    // Release/Deallocate a room
    public Room releaseRoom(Long id) {
        Optional<Room> roomOpt = roomRepository.findById(id);
        if (!roomOpt.isPresent()) {
            throw new IllegalArgumentException("Room not found");
        }

        Room room = roomOpt.get();
        room.setStatus("AVAILABLE");
        room.setIsAvailable(true);
        return roomRepository.save(room);
    }

    // Delete a room
    public void deleteRoom(Long id) {
        Optional<Room> roomOpt = roomRepository.findById(id);
        if (!roomOpt.isPresent()) {
            throw new IllegalArgumentException("Room not found");
        }

        Room room = roomOpt.get();
        if ("RESERVED".equals(room.getStatus()) || "OCCUPIED".equals(room.getStatus())) {
            throw new IllegalArgumentException("Cannot delete a room that is currently reserved or occupied.");
        }

        try {
            roomRepository.deleteById(id);
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            throw new IllegalArgumentException(
                    "Cannot delete room. It has existing reservations or dependencies. Consider making it unavailable instead.");
        }
    }
}
