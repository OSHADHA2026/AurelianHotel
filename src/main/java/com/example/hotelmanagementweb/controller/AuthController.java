package com.example.hotelmanagementweb.controller;

import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.service.DashboardService;
import com.example.hotelmanagementweb.service.UserService;
import com.example.hotelmanagementweb.service.UserSessionService;
import com.example.hotelmanagementweb.service.RoomService;
import com.example.hotelmanagementweb.service.ReviewService;
import com.example.hotelmanagementweb.model.Room;
import com.example.hotelmanagementweb.model.Review;
import java.util.stream.Collectors;
import java.util.List;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.*;
import java.util.UUID;

@Controller
public class AuthController {

    private final UserService userService;
    private final DashboardService dashboardService;
    private final UserSessionService userSessionService;
    private final RoomService roomService;
    private final ReviewService reviewService;

    public AuthController(UserService userService, DashboardService dashboardService, UserSessionService userSessionService, RoomService roomService, ReviewService reviewService) {
        this.userService = userService;
        this.dashboardService = dashboardService;
        this.userSessionService = userSessionService;
        this.roomService = roomService;
        this.reviewService = reviewService;
    }

    // Home page as the first page
    @GetMapping({ "/", "/home" })
    public String home(Model model, HttpSession session) {
        Object user = session.getAttribute("user");
        model.addAttribute("currentUser", user);
        
        // Fetch up to 3 available rooms to display on the home page
        List<Room> featuredRooms = roomService.getAvailableRooms().stream()
                .limit(3)
                .collect(Collectors.toList());
        model.addAttribute("featuredRooms", featuredRooms);
        
        // Fetch up to 10 reviews for the testimonial section
        List<Review> reviews = reviewService.getFeaturedReviews(10);
        model.addAttribute("reviews", reviews);

        // Review eligibility: only guests with a completed stay of 1+ nights, one review each
        if (user instanceof User reviewer) {
            String blockReason = reviewService.getReviewBlockReason(reviewer);
            model.addAttribute("canReview", blockReason == null);
            model.addAttribute("reviewNotice", blockReason);
        }
        
        return "home";
    }

    // Show login page
    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    // Handle login form submission
    @PostMapping("/login")
    public String doLogin(@RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<User> userOpt = userService.authenticate(username, password);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // navbar/footer expect sessionScope.user
            session.setAttribute("user", user);
            
            // Record login
            Long userSessionId = userSessionService.recordLogin(user);
            session.setAttribute("userSessionId", userSessionId);

            redirectAttributes.addFlashAttribute("success", "Login successful. Welcome, " + user.getFirstName() + "!");
            return "redirect:/home";
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid username or password");
            redirectAttributes.addFlashAttribute("username", username);
            return "redirect:/login";
        }
    }

    // Logout
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        Long userSessionId = (Long) session.getAttribute("userSessionId");
        if (userSessionId != null) {
            userSessionService.recordLogout(userSessionId);
        }
        
        session.invalidate();
        redirectAttributes.addFlashAttribute("success", "You have been logged out successfully.");
        return "redirect:/login";
    }

    // Show register page
    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }

    // Staff login page
    @GetMapping("/staff")
    public String showStaffLoginPage(Model model) {
        model.addAttribute("formAction", "/staff");
        model.addAttribute("loginSubtitle", "Welcome back, Staff member");
        return "login";
    }

    // Handle staff login form submission
    @PostMapping("/staff")
    public String doStaffLogin(@RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<User> userOpt = userService.authenticate(username, password);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (!"EMPLOYEE".equals(user.getRole())) {
                redirectAttributes.addFlashAttribute("error", "Access denied. Staff privileges required.");
                redirectAttributes.addFlashAttribute("username", username);
                return "redirect:/staff";
            }
            session.setAttribute("user", user);
            
            // Record login
            Long userSessionId = userSessionService.recordLogin(user);
            session.setAttribute("userSessionId", userSessionId);

            redirectAttributes.addFlashAttribute("success",
                    "Staff login successful. Welcome, " + user.getFirstName() + "!");
            // Adjust destination if there is a specific staff dashboard, otherwise
            // home/dashboard
            return "redirect:/home";
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid username or password");
            redirectAttributes.addFlashAttribute("username", username);
            return "redirect:/staff";
        }
    }

    // Handle register form submission
    @PostMapping("/register")
    public String doRegister(@RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("email") String email,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("securityQuestion1") String secQ1,
            @RequestParam("securityAnswer1") String secA1,
            @RequestParam("securityQuestion2") String secQ2,
            @RequestParam("securityAnswer2") String secA2,
            RedirectAttributes redirectAttributes) {
        try {
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPhoneNumber(phoneNumber);
            user.setUsername(username);
            user.setPassword(password);
            user.setRole("USER");
            user.setSecurityQuestion1(secQ1);
            user.setSecurityAnswer1(secA1);
            user.setSecurityQuestion2(secQ2);
            user.setSecurityAnswer2(secA2);

            userService.register(user);

            redirectAttributes.addFlashAttribute("success", "Registration successful! You can now log in.");
            return "redirect:/login";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/register";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error",
                    "An unexpected error occurred while registering. Please try again.");
            return "redirect:/register";
        }
    }

    @GetMapping("/gallery")
    public String galleryPage() {
        return "gallery";
    }

    @GetMapping("/contact")
    public String ContactPage() {
        return "contact";
    }

    @GetMapping("/profile")
    public String profilePage() {
        return "profile";
    }

    @GetMapping("/dashboard")
    public String dashboardPage(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to access your dashboard");
            return "redirect:/login";
        }

        // Get user dashboard data (bookings, payments, cards)
        model.addAttribute("bookings", dashboardService.getUserBookings(user.getId()));
        model.addAttribute("upcomingBookings", dashboardService.getUpcomingBookings(user.getId()));
        model.addAttribute("pastBookings", dashboardService.getPastBookings(user.getId()));
        model.addAttribute("payments", dashboardService.getUserPayments(user.getId()));
        model.addAttribute("cards", dashboardService.getUserCards(user.getId()));
        model.addAttribute("totalSpent", dashboardService.getTotalSpent(user.getId()));
        model.addAttribute("totalBookings", dashboardService.getTotalBookingsCount(user.getId()));
        model.addAttribute("completedBookings", dashboardService.getCompletedBookingsCount(user.getId()));

        // If admin or staff, redirect to management dashboard
        if ("ADMIN".equals(user.getRole()) || "EMPLOYEE".equals(user.getRole())) {
            return "redirect:/admin/dashboard";
        }

        return "user-dashboard";
    }

    @PostMapping("/profile/update")
    public String updateProfile(
            @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam("username") String username,
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam(value = "newPassword", required = false) String newPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            Optional<User> userOpt = userService.findById(user.getId());
            if (!userOpt.isPresent()) {
                return "redirect:/login";
            }

            User freshUser = userOpt.get();

            // Only require and verify current password if the user wants to set a new
            // password
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (currentPassword == null || currentPassword.isEmpty()
                        || !freshUser.getPassword().equals(currentPassword)) {
                    redirectAttributes.addFlashAttribute("error",
                            "Incorrect current password. Current password is required to set a new password.");
                    return "redirect:/profile";
                }
                freshUser.setPassword(newPassword.trim());
            }

            freshUser.setFirstName(firstName);
            freshUser.setLastName(lastName);
            freshUser.setPhoneNumber(phoneNumber);
            freshUser.setUsername(username);
            User updatedUser = userService.updateUser(freshUser);
            session.setAttribute("user", updatedUser); // Update in session too

            redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");

        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "An unexpected error occurred while updating the profile.");
        }

        return "redirect:/profile";
    }

    @PostMapping("/profile/delete")
    public String deleteAccount(HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            userService.deleteUser(user.getId());
            session.invalidate();
            redirectAttributes.addFlashAttribute("success", "Your account has been deleted permanently.");
            return "redirect:/home";
        } catch (org.springframework.dao.DataIntegrityViolationException ex) {
            redirectAttributes.addFlashAttribute("error",
                    "Cannot delete account due to existing historical reservations or dependencies. Contact admin for assistance.");
            return "redirect:/profile";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "An error occurred while deleting your account.");
            return "redirect:/profile";
        }
    }

    @PostMapping("/profile/picture")
    public String updateProfilePicture(@RequestParam("picture") MultipartFile file,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        
        // Only allow staff to update profile picture as per request
        if (!"EMPLOYEE".equals(user.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Only staff profiles can have custom pictures.");
            return "redirect:/profile";
        }

        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Please select a file to upload.");
            return "redirect:/profile";
        }

        try {
            String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            Path uploadPath = Paths.get("uploads/profile-pictures");
            
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            Path filePath = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            // Update user record
            Optional<User> userOpt = userService.findById(user.getId());
            if (userOpt.isPresent()) {
                User freshUser = userOpt.get();
                // Delete old picture if it exists
                if (freshUser.getProfilePicture() != null) {
                    try {
                        Files.deleteIfExists(Paths.get(freshUser.getProfilePicture()));
                    } catch (IOException e) {
                        // Ignore
                    }
                }
                freshUser.setProfilePicture("uploads/profile-pictures/" + fileName);
                User updatedUser = userService.updateUser(freshUser);
                session.setAttribute("user", updatedUser);
                redirectAttributes.addFlashAttribute("success", "Profile picture updated successfully!");
            }
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Failed to upload picture: " + e.getMessage());
        }

        return "redirect:/profile";
    }

    @PostMapping("/profile/picture/remove")
    public String removeProfilePicture(HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        try {
            Optional<User> userOpt = userService.findById(user.getId());
            if (userOpt.isPresent()) {
                User freshUser = userOpt.get();
                if (freshUser.getProfilePicture() != null) {
                    try {
                        Files.deleteIfExists(Paths.get(freshUser.getProfilePicture()));
                    } catch (IOException e) {
                        // Ignore
                    }
                    freshUser.setProfilePicture(null);
                    User updatedUser = userService.updateUser(freshUser);
                    session.setAttribute("user", updatedUser);
                    redirectAttributes.addFlashAttribute("success", "Profile picture removed.");
                }
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "An error occurred.");
        }

        return "redirect:/profile";
    }
}
