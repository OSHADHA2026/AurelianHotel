package com.example.hotelmanagementweb.controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.model.Booking;
import com.example.hotelmanagementweb.service.UserService;
import com.example.hotelmanagementweb.service.UserSessionService;
import com.example.hotelmanagementweb.service.PaymentService;
import com.example.hotelmanagementweb.service.BookingService;
import com.example.hotelmanagementweb.service.RoomPackageService;
import com.example.hotelmanagementweb.dto.RoomPackageDTO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserService userService;
    private final UserSessionService userSessionService;
    private final PaymentService paymentService;
    private final BookingService bookingService;
    private final RoomPackageService packageService;

    public AdminController(UserService userService, 
                          UserSessionService userSessionService,
                          PaymentService paymentService,
                          BookingService bookingService,
                          RoomPackageService packageService) {
        this.userService = userService;
        this.userSessionService = userSessionService;
        this.paymentService = paymentService;
        this.bookingService = bookingService;
        this.packageService = packageService;
    }

    // Check if user is admin
    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    // Check if user is staff (admin or employee)
    private boolean isStaff(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && ("ADMIN".equals(user.getRole()) || "EMPLOYEE".equals(user.getRole()));
    }

    // Admin login page
    @GetMapping
    public String showAdminLoginPage(HttpSession session, Model model) {
        if (isAdmin(session)) {
            return "redirect:/admin/dashboard";
        }
        model.addAttribute("formAction", "/admin");
        model.addAttribute("loginSubtitle", "Welcome back, Administrator");
        return "login";
    }

    @PostMapping
    public String doAdminLogin(@RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<User> userOpt = userService.authenticate(username, password);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (!"ADMIN".equals(user.getRole())) {
                redirectAttributes.addFlashAttribute("error", "Access denied. Admin privileges required.");
                redirectAttributes.addFlashAttribute("username", username);
                return "redirect:/admin";
            }
            session.setAttribute("user", user);
            
            // Record login
            Long userSessionId = userSessionService.recordLogin(user);
            session.setAttribute("userSessionId", userSessionId);

            redirectAttributes.addFlashAttribute("success",
                    "Admin login successful. Welcome, " + user.getFirstName() + "!");
            return "redirect:/admin/dashboard";
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid username or password");
            redirectAttributes.addFlashAttribute("username", username);
            return "redirect:/admin";
        }
    }

    // Admin Dashboard - Main admin page
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model, RedirectAttributes redirectAttributes,
                                @RequestParam(value = "search", required = false) String search,
                                @RequestParam(value = "statusFilter", required = false) String statusFilter,
                                @RequestParam(value = "sortBy", required = false) String sortBy,
                                @RequestParam(value = "sortDir", required = false) String sortDir) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff privileges required.");
            return "redirect:/login";
        }

        // Get GLOBAL dashboard data for staff
        model.addAttribute("bookings", bookingService.findByStatus("CONFIRMED"));
        model.addAttribute("activeStays", bookingService.findByStatus("CHECKED_IN"));
        model.addAttribute("upcomingBookings", bookingService.findByStatus("CONFIRMED"));
        model.addAttribute("pastBookings", bookingService.getAllRoomHistory());
        
        // System wide counts
        model.addAttribute("totalBookings", bookingService.findByStatus("CONFIRMED").size() + 
                                           bookingService.findByStatus("CHECKED_IN").size());
        model.addAttribute("completedBookings", bookingService.findByStatus("COMPLETED").size());
        
        // Stats
        model.addAttribute("totalUsers", userService.getTotalUsers());
        model.addAttribute("guestCount", userService.countUsersByRole("USER"));
        model.addAttribute("staffCount", userService.countUsersByRole("EMPLOYEE"));
        model.addAttribute("adminCount", userService.countUsersByRole("ADMIN"));
        model.addAttribute("pendingVerifications", paymentService.getPendingVerifications());
        model.addAttribute("allStaff", userService.getUsersByRole("EMPLOYEE"));
        
        // Revenue/Spending data
        model.addAttribute("totalRevenue", bookingService.getTotalRevenue());
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null) {
            model.addAttribute("totalSpent", bookingService.getTotalSpentByUser(currentUser.getId()));
        } else {
            model.addAttribute("totalSpent", java.math.BigDecimal.ZERO);
        }

        // Booking Management Data — with search, status filter, and sort
        List<Booking> allBookings = bookingService.searchBookings(search, statusFilter, sortBy, sortDir);
        model.addAttribute("allBookings", allBookings);
        model.addAttribute("search", search);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);

        return "admin/dashboard";
    }

    @GetMapping("/salary-calculator")
    public String salaryCalculator(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied.");
            return "redirect:/login";
        }
        model.addAttribute("allStaff", userService.getUsersByRole("EMPLOYEE"));
        return "admin/salary-calculator";
    }

    // Admin dashboard - User Management
    @GetMapping("/users")
    public String adminUsersPage(HttpSession session, Model model, RedirectAttributes redirectAttributes,
            @RequestParam(value = "role", required = false) String role,
            @RequestParam(value = "search", required = false) String search) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admin privileges required.");
            return "redirect:/home";
        }

        List<User> users;
        if (role != null && !role.isEmpty() && !role.equals("ALL")) {
            users = userService.getUsersByRole(role);
        } else {
            users = userService.getAllUsers();
        }

        // Filter by search term if provided
        if (search != null && !search.trim().isEmpty()) {
            String searchLower = search.toLowerCase();
            users = users.stream()
                    .filter(u -> u.getUsername().toLowerCase().contains(searchLower) ||
                            u.getEmail().toLowerCase().contains(searchLower) ||
                            u.getFirstName().toLowerCase().contains(searchLower) ||
                            u.getLastName().toLowerCase().contains(searchLower))
                    .collect(Collectors.toList());
        }

        model.addAttribute("users", users);
        model.addAttribute("totalUsers", userService.getTotalUsers());
        model.addAttribute("guestCount", userService.countUsersByRole("USER"));
        model.addAttribute("staffCount", userService.countUsersByRole("EMPLOYEE"));
        model.addAttribute("adminCount", userService.countUsersByRole("ADMIN"));
        model.addAttribute("selectedRole", role != null ? role : "ALL");
        model.addAttribute("searchTerm", search != null ? search : "");

        return "admin/users";
    }

    // Show create user form
    @GetMapping("/users/create")
    public String showCreateUserForm(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admin privileges required.");
            return "redirect:/home";
        }
        model.addAttribute("user", new User());
        return "admin/user-form";
    }

    // Create new user
    @PostMapping("/users/create")
    public String createUser(HttpSession session,
            @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("email") String email,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("role") String role,
            @RequestParam(value = "jobRole", required = false) String jobRole,
            RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admin privileges required.");
            return "redirect:/home";
        }

        try {
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPhoneNumber(phoneNumber);
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);
            user.setJobRole(jobRole);

            userService.createUser(user);
            redirectAttributes.addFlashAttribute("success", "User created successfully!");
            return "redirect:/admin/users";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/users/create";
        }
    }

    // Show edit user form
    @GetMapping("/users/edit/{id}")
    public String showEditUserForm(HttpSession session, @PathVariable("id") Long id, Model model,
            RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admin privileges required.");
            return "redirect:/home";
        }

        Optional<User> userOpt = userService.findById(id);
        if (!userOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "User not found.");
            return "redirect:/admin/users";
        }

        model.addAttribute("user", userOpt.get());
        return "admin/user-form";
    }

    // Update user
    @PostMapping("/users/edit/{id}")
    public String updateUser(HttpSession session,
            @PathVariable("id") Long id,
            @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("email") String email,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam("username") String username,
            @RequestParam(value = "password", required = false) String password,
            @RequestParam("role") String role,
            @RequestParam(value = "jobRole", required = false) String jobRole,
            RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admin privileges required.");
            return "redirect:/home";
        }

        try {
            Optional<User> userOpt = userService.findById(id);
            if (!userOpt.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "User not found.");
                return "redirect:/admin/users";
            }

            User user = userOpt.get();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPhoneNumber(phoneNumber);
            user.setUsername(username);
            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(password);
            }
            user.setRole(role);
            user.setJobRole(jobRole);

            userService.updateUser(user);
            redirectAttributes.addFlashAttribute("success", "User updated successfully!");
            return "redirect:/admin/users";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/users/edit/" + id;
        }
    }

    // Delete user
    @PostMapping("/users/delete/{id}")
    public String deleteUser(HttpSession session,
            @PathVariable("id") Long id,
            RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admin privileges required.");
            return "redirect:/home";
        }

        // Prevent admin from deleting themselves
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null && currentUser.getId().equals(id)) {
            redirectAttributes.addFlashAttribute("error", "You cannot delete your own account.");
            return "redirect:/admin/users";
        }

        try {
            userService.deleteUser(id);
            redirectAttributes.addFlashAttribute("success", "User deleted successfully!");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }

        return "redirect:/admin/users";
    }

    // Update user role only
    @PostMapping("/users/role/{id}")
    public String updateUserRole(HttpSession session,
            @PathVariable("id") Long id,
            @RequestParam("role") String role,
            RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admin privileges required.");
            return "redirect:/home";
        }

        // Prevent admin from changing their own role
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null && currentUser.getId().equals(id) && !"ADMIN".equals(role)) {
            redirectAttributes.addFlashAttribute("error", "You cannot change your own role from ADMIN.");
            return "redirect:/admin/users";
        }

        try {
            userService.updateUserRole(id, role);
            redirectAttributes.addFlashAttribute("success", "User role updated successfully!");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }

        return "redirect:/admin/users";
    }

    @GetMapping("/employee-sessions")
    public String employeeSessions(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admin privileges required.");
            return "redirect:/home";
        }

        model.addAttribute("sessions", userSessionService.getAllSessions());
        return "admin/employee-sessions";
    }

    @GetMapping("/trends")
    public String viewTrends(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Admins only.");
            return "redirect:/home";
        }
        return "admin/trends";
    }

    // ==============================================
    // PACKAGE MANAGEMENT (Admin/Staff)
    // ==============================================
    @GetMapping("/room-packages")
    public String viewPackages(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        System.out.println(">>> ENTERING viewPackages /admin/room-packages");
        if (!isStaff(session)) {
            System.out.println("User is not staff, redirecting to /home");
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        try {
            List<RoomPackageDTO> pkgs = packageService.getAllPackages();
            System.out.println("Found " + pkgs.size() + " packages.");
            model.addAttribute("packages", pkgs);
        } catch (Exception e) {
            System.err.println("Error fetching packages: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return "admin/room-packages";
    }

    @GetMapping("/room-packages/new")
    public String showCreatePackageForm(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        model.addAttribute("packageDTO", new RoomPackageDTO());
        return "admin/package-form";
    }

    @GetMapping("/room-packages/{id}/edit")
    public String showEditPackageForm(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        Optional<RoomPackageDTO> dto = packageService.getPackageById(id);
        if (dto.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Package not found");
            return "redirect:/admin/room-packages";
        }
        model.addAttribute("packageDTO", dto.get());
        return "admin/package-form";
    }

    @PostMapping("/room-packages/save")
    public String savePackage(RoomPackageDTO packageDTO, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff only.");
            return "redirect:/home";
        }
        
        // If checkbox is unchecked, it won't be in the request, so isActive will be null.
        if (packageDTO.getIsActive() == null) {
            packageDTO.setIsActive(false);
        }
        if (packageDTO.getId() == null) {
            packageService.createPackage(packageDTO);
            redirectAttributes.addFlashAttribute("success", "Package created successfully");
        } else {
            packageService.updatePackage(packageDTO.getId(), packageDTO);
            redirectAttributes.addFlashAttribute("success", "Package updated successfully");
        }
        return "redirect:/admin/room-packages";
    }

    @GetMapping("/room-packages/{id}/delete")
    public String deletePackage(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isStaff(session)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Staff privileges required.");
            return "redirect:/home";
        }
        packageService.deletePackage(id);
        redirectAttributes.addFlashAttribute("success", "Package deleted successfully");
        return "redirect:/admin/room-packages";
    }
}
