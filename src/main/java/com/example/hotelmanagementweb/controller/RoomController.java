package com.example.hotelmanagementweb.controller;

import com.example.hotelmanagementweb.model.Room;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.service.RoomService;
import com.example.hotelmanagementweb.service.BookingService;
import com.example.hotelmanagementweb.service.RoomPackageService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.io.IOException;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/rooms")
public class RoomController {

    @Autowired
    private RoomService roomService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private RoomPackageService packageService;

    private boolean isStaff(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && ("ADMIN".equals(user.getRole()) || "EMPLOYEE".equals(user.getRole()));
    }

    // Display all rooms for users
    @GetMapping
    public String getAllRooms(
            @RequestParam(value = "type", required = false) String type,
            @RequestParam(value = "capacity", required = false) Integer capacity,
            @RequestParam(value = "price", required = false) String priceRange,
            @RequestParam(value = "availableOnly", required = false, defaultValue = "false") boolean availableOnly,
            Model model) {

        List<Room> rooms = roomService.getAllRooms();

        // Apply filters
        if (type != null && !type.trim().isEmpty()) {
            rooms = rooms.stream().filter(r -> r.getRoomType().equalsIgnoreCase(type)).toList();
        }
        if (capacity != null) {
            rooms = rooms.stream().filter(r -> r.getCapacity() >= capacity).toList();
        }
        if (priceRange != null && !priceRange.trim().isEmpty()) {
            if (priceRange.equals("0-100")) {
                rooms = rooms.stream().filter(r -> r.getPricePerNight().compareTo(new BigDecimal("100")) <= 0).toList();
            } else if (priceRange.equals("101-200")) {
                rooms = rooms.stream().filter(r -> r.getPricePerNight().compareTo(new BigDecimal("100")) > 0
                        && r.getPricePerNight().compareTo(new BigDecimal("200")) <= 0).toList();
            } else if (priceRange.equals("201-300")) {
                rooms = rooms.stream().filter(r -> r.getPricePerNight().compareTo(new BigDecimal("200")) > 0
                        && r.getPricePerNight().compareTo(new BigDecimal("300")) <= 0).toList();
            } else if (priceRange.equals("301+")) {
                rooms = rooms.stream().filter(r -> r.getPricePerNight().compareTo(new BigDecimal("300")) > 0).toList();
            }
        }
        
        // Filter by availability if requested
        if (availableOnly) {
            rooms = rooms.stream().filter(Room::getIsAvailable).toList();
        }

        // Dynamically check occupancy for each room based on active bookings
        for (Room room : rooms) {
            if (bookingService.isRoomOccupiedNow(room.getId())) {
                room.setIsAvailable(false);
                room.setStatus("OCCUPIED");
            }
        }

        List<Room> totalAvailableRoomsCount = rooms.stream().filter(Room::getIsAvailable).toList();

        model.addAttribute("rooms", rooms);
        model.addAttribute("totalRooms", roomService.getAllRooms().size());
        model.addAttribute("totalAvailable", totalAvailableRoomsCount.size());
        model.addAttribute("activePackages", packageService.getAllActivePackages());
        
        // Pass filter values back to maintain state
        model.addAttribute("selectedType", type);
        model.addAttribute("selectedCapacity", capacity);
        model.addAttribute("selectedPrice", priceRange);
        model.addAttribute("availableOnly", availableOnly);

        return "rooms";
    }

    // Admin: Show room management page
    @GetMapping("/admin/management")
    public String roomManagementPage(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        List<Room> allRooms = roomService.getAllRooms();
        List<Room> maintenanceRooms = roomService.getRoomsInMaintenance();
        List<Room> availableRooms = roomService.getAvailableRooms();

        // Update statuses dynamically before displaying
        for (Room room : allRooms) {
            if (bookingService.isRoomOccupiedNow(room.getId())) {
                room.setIsAvailable(false);
                room.setStatus("OCCUPIED");
            }
        }
        // Re-filter availableRooms based on dynamic status
        availableRooms = allRooms.stream().filter(Room::getIsAvailable).toList();

        model.addAttribute("allRooms", allRooms);
        model.addAttribute("maintenanceRooms", maintenanceRooms);
        model.addAttribute("availableRooms", availableRooms);
        model.addAttribute("totalRooms", allRooms.size());

        return "room-management";
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    // Admin: Show create room form
    @GetMapping("/admin/create")
    public String showCreateRoomForm(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admins only.");
            return "redirect:/rooms/admin/management";
        }
        model.addAttribute("room", new Room());
        return "room-form";
    }

    @PostMapping("/admin/create")
    public String createRoom(HttpSession session,
            @RequestParam("roomNumber") String roomNumber,
            @RequestParam("roomType") String roomType,
            @RequestParam("capacity") Integer capacity,
            @RequestParam("pricePerNight") BigDecimal pricePerNight,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("floor") Integer floor,
            @RequestParam(value = "amenities", required = false) String amenities,
            @RequestParam(value = "roomSize", required = false) Double roomSize,
            @RequestParam(value = "image", required = false) MultipartFile image,
            RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admins only.");
            return "redirect:/rooms/admin/management";
        }
        try {
            roomService.createRoom(roomNumber, roomType, capacity, pricePerNight,
                    description != null ? description : "", floor, amenities != null ? amenities : "", roomSize, image);
            return "redirect:/rooms/admin/management?success=Room+created+successfully.+It+now+appears+on+Rooms+%26+Availability.";
        } catch (IllegalArgumentException e) {
            return "redirect:/rooms/admin/create?error=" + e.getMessage().replace(" ", "+");
        } catch (IOException e) {
            return "redirect:/rooms/admin/create?error=Image+upload+failed:+" + e.getMessage().replace(" ", "+");
        }
    }

    // Admin: Show edit room form
    @GetMapping("/admin/edit/{id}")
    public String showEditRoomForm(HttpSession session, @PathVariable("id") Long id, Model model,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        Optional<Room> room = roomService.getRoomById(id);
        if (!room.isPresent()) {
            return "redirect:/rooms/admin/management";
        }

        model.addAttribute("room", room.get());
        return "room-form";
    }

    @PostMapping("/admin/update/{id}")
    public String updateRoom(HttpSession session,
            @PathVariable("id") Long id,
            @RequestParam("roomType") String roomType,
            @RequestParam("capacity") Integer capacity,
            @RequestParam("pricePerNight") BigDecimal pricePerNight,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "amenities", required = false) String amenities,
            @RequestParam("status") String status,
            @RequestParam(value = "roomSize", required = false) Double roomSize,
            @RequestParam(value = "image", required = false) MultipartFile image,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            roomService.updateRoom(id, roomType, capacity, pricePerNight, description != null ? description : "",
                    amenities != null ? amenities : "", status, roomSize, image);
            return "redirect:/rooms/admin/management?success=Room updated successfully";
        } catch (IllegalArgumentException e) {
            return "redirect:/rooms/admin/edit/" + id + "?error=" + e.getMessage().replace(" ", "+");
        } catch (IOException e) {
            return "redirect:/rooms/admin/edit/" + id + "?error=Image+upload+failed:+" + e.getMessage().replace(" ", "+");
        }
    }

    // Admin: Update room price
    @PostMapping("/admin/update-price/{id}")
    public String updateRoomPrice(HttpSession session,
            @PathVariable("id") Long id,
            @RequestParam("newPrice") BigDecimal newPrice,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            roomService.updateRoomPrice(id, newPrice);
            return "redirect:/rooms/admin/management?success=Price+updated+successfully";
        } catch (IllegalArgumentException e) {
            return "redirect:/rooms/admin/management?error=" + e.getMessage().replace(" ", "+");
        }
    }

    // Admin: Mark room as available
    @PostMapping("/admin/{id}/available")
    public String markAvailable(HttpSession session, @PathVariable("id") Long id,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            roomService.markRoomAvailable(id);
            return "redirect:/rooms/admin/management?success=Room+marked+as+available";
        } catch (IllegalArgumentException e) {
            return "redirect:/rooms/admin/management?error=" + e.getMessage().replace(" ", "+");
        }
    }

    // Admin: Mark room as occupied
    @PostMapping("/admin/{id}/occupied")
    public String markOccupied(HttpSession session, @PathVariable("id") Long id,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            roomService.markRoomOccupied(id);
            return "redirect:/rooms/admin/management?success=Room+marked+as+occupied";
        } catch (IllegalArgumentException e) {
            return "redirect:/rooms/admin/management?error=" + e.getMessage().replace(" ", "+");
        }
    }

    // Admin: Schedule maintenance
    @PostMapping("/admin/{id}/maintenance")
    public String scheduleMaintenance(HttpSession session,
            @PathVariable("id") Long id,
            @RequestParam("startDate") String startDate,
            @RequestParam("endDate") String endDate,
            @RequestParam("notes") String notes,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        
        if (startDate == null || startDate.trim().isEmpty() || endDate == null || endDate.trim().isEmpty()) {
            return "redirect:/rooms/admin/management?error=Start+and+End+dates+are+required+for+maintenance.";
        }

        try {
            LocalDateTime start;
            LocalDateTime end;
            try {
                // Try standard ISO parsing first (yyyy-MM-ddTHH:mm:ss)
                start = LocalDateTime.parse(startDate);
                end = LocalDateTime.parse(endDate);
            } catch (Exception e) {
                // Fallback for browser formats (yyyy-MM-ddTHH:mm or yyyy-MM-dd HH:mm)
                DateTimeFormatter browserFormat = DateTimeFormatter.ofPattern("[yyyy-MM-dd'T'HH:mm][yyyy-MM-dd HH:mm][yyyy-MM-dd'T'HH:mm:ss]");
                start = LocalDateTime.parse(startDate, browserFormat);
                end = LocalDateTime.parse(endDate, browserFormat);
            }

            roomService.scheduleMaintenance(id, start, end, notes);
            return "redirect:/rooms/admin/management?success=Maintenance+scheduled+successfully";
        } catch (Exception e) {
            String msg = e.getMessage() != null ? e.getMessage() : "Invalid date format";
            return "redirect:/rooms/admin/management?error=Date+Error:+" + msg.replace(" ", "+");
        }
    }

    // Admin: Complete maintenance
    @PostMapping("/admin/{id}/complete-maintenance")
    public String completeMaintenance(HttpSession session, @PathVariable("id") Long id,
            RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            roomService.completeMaintenance(id);
            return "redirect:/rooms/admin/management?success=Maintenance+completed+successfully";
        } catch (IllegalArgumentException e) {
            return "redirect:/rooms/admin/management?error=" + e.getMessage().replace(" ", "+");
        }
    }

    // Admin: Delete room
    @PostMapping("/admin/{id}/delete")
    public String deleteRoom(HttpSession session, @PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admins only.");
            return "redirect:/rooms/admin/management";
        }
        try {
            roomService.deleteRoom(id);
            return "redirect:/rooms/admin/management?success=Room+deleted+successfully";
        } catch (IllegalArgumentException e) {
            return "redirect:/rooms/admin/management?error=" + e.getMessage().replace(" ", "+");
        } catch (Exception e) {
            return "redirect:/rooms/admin/management?error=An+unexpected+error+occurred";
        }
    }

    // API: Get available rooms by type (JSON)
    @GetMapping("/api/available/{roomType}")
    @ResponseBody
    public List<Room> getAvailableRoomsByType(@PathVariable("roomType") String roomType) {
        return roomService.getAvailableRoomsByType(roomType);
    }

    // API: Get rooms by status (JSON)
    @GetMapping("/api/status/{status}")
    @ResponseBody
    public List<Room> getRoomsByStatus(@PathVariable("status") String status) {
        return roomService.getRoomsByStatus(status);
    }

    // API: Get room details (JSON)
    @GetMapping("/api/{id}")
    @ResponseBody
    public Optional<Room> getRoomDetailsApi(@PathVariable("id") Long id) {
        return roomService.getRoomById(id);
    }

    // API: Get room numbers already taken on a floor
    @GetMapping("/api/taken-rooms/{floor}")
    @ResponseBody
    public List<String> getTakenRoomsByFloor(@PathVariable("floor") Integer floor) {
        return roomService.getRoomsByFloor(floor).stream()
                .map(Room::getRoomNumber)
                .toList();
    }

    // API: Check room availability
    @GetMapping("/api/{id}/availability")
    @ResponseBody
    public boolean checkAvailability(@PathVariable("id") Long id) {
        return roomService.isRoomAvailable(id);
    }

    // API: Allocate room
    @PostMapping("/api/{id}/allocate")
    @ResponseBody
    public Room allocateRoomApi(@PathVariable("id") Long id) {
        return roomService.allocateRoom(id);
    }

    // API: Release room
    @PostMapping("/api/{id}/release")
    @ResponseBody
    public Room releaseRoomApi(@PathVariable("id") Long id) {
        return roomService.releaseRoom(id);
    }

    // ADMIN/STAFF: View Room History (all rooms)
    @GetMapping("/admin/history")
    public String getAllRoomHistory(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        model.addAttribute("history", bookingService.getAllRoomHistory());
        model.addAttribute("isGeneralHistory", true);
        return "admin/room-history";
    }

    // ADMIN/STAFF: View Specific Room History
    @GetMapping("/admin/history/{id}")
    public String getRoomHistory(@PathVariable("id") Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        Optional<Room> room = roomService.getRoomById(id);
        if (!room.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Room not found.");
            return "redirect:/rooms/admin/management";
        }
        model.addAttribute("room", room.get());
        model.addAttribute("history", bookingService.getRoomHistory(id));
        model.addAttribute("isGeneralHistory", false);
        return "admin/room-history";
    }

    // Display room details (must be after /admin/* to avoid matching "admin" as id)
    @GetMapping("/{id}")
    public String getRoomDetails(@PathVariable("id") Long id, Model model) {
        Optional<Room> room = roomService.getRoomById(id);
        if (!room.isPresent()) {
            return "redirect:/rooms";
        }
        model.addAttribute("room", room.get());
        return "room-details";
    }
}
