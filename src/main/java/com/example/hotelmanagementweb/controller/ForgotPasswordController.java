package com.example.hotelmanagementweb.controller;

import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.service.EmailService;
import com.example.hotelmanagementweb.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;
import java.util.UUID;

@Controller
public class ForgotPasswordController {

    private final UserService userService;
    private final EmailService emailService;

    public ForgotPasswordController(UserService userService, EmailService emailService) {
        this.userService = userService;
        this.emailService = emailService;
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot-password";
    }

    @GetMapping("/forgot-password-questions")
    public String showForgotPasswordQuestionsHome() {
        return "forgot-password-questions";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, 
                                        HttpServletRequest request, 
                                        RedirectAttributes redirectAttributes) {
        System.out.println("Processing forgot password for email: " + email);
        
        try {
            Optional<User> userOpt = userService.findByEmail(email);
            if (!userOpt.isPresent()) {
                System.out.println("User not found for email: " + email);
                redirectAttributes.addFlashAttribute("error", "No account found with that email address.");
                return "redirect:/forgot-password";
            }

            User user = userOpt.get();
            String token = UUID.randomUUID().toString();
            System.out.println("Generating reset token for user: " + user.getUsername());
            userService.createPasswordResetTokenForUser(user, token);

            String appUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
            String resetUrl = appUrl + "/reset-password?token=" + token;
            
            // CSS fallback integrated into the hotel-icon wrapper
            String htmlMsg = "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "    <style>" +
                "        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #fbfaf8; margin: 0; padding: 0; }" +
                "        .container { max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 4px; overflow: hidden; box-shadow: 0 10px 30px rgba(0, 0, 0,0.1); }" +
                "        .header { background: linear-gradient(135deg, #3c3222 0%, #1b2f4b 100%); padding: 40px; text-align: center; color: white; }" +
                "        .hotel-icon { background-color: #d4af37; width: 80px; height: 80px; border-radius: 4px; margin: 0 auto 20px auto; overflow: hidden; box-shadow: 0 8px 25px rgba(0, 0, 0,0.25); }" +
                "        .hotel-icon img { height: 80px; width: 80px; border-radius: 4px; display: block; border: none; outline: none; text-decoration: none; }" +
                "        .content { padding: 40px; text-align: center; }" +
                "        .content h1 { color: #3c3222; font-size: 28px; margin-bottom: 20px; font-weight: 300; }" +
                "        .content p { color: #666666; line-height: 1.8; font-size: 16px; margin: 10px 0; }" +
                "        .button { display: inline-block; padding: 16px 36px; background-color: #d4af37; color: #ffffff !important; text-decoration: none; border-radius: 9px; font-weight: bold; margin-top: 30px; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3); }" +
                "        .footer { background-color: #f6f5f3; padding: 25px; text-align: center; font-size: 13px; color: #888888; border-top: 1px solid #eeeeee; }" +
                "        .divider { height: 2px; background: linear-gradient(to right, transparent, #d4af37, transparent); margin: 30px 0; }" +
                "    </style>" +
                "</head>" +
                "<body>" +
                "    <div class='container'>" +
                "        <div class='header'>" +
                "            <div class='hotel-icon'>" +
                "                <img src='cid:logo' alt='G' style='color:#3c3222; font-size:40px; font-weight:bold; line-height:80px; font-family:Georgia, serif;'>" +
                "            </div>" +
                "            <h2 style='margin:0; font-family: \"Montserrat\", serif; letter-spacing: 4px; text-transform: uppercase; font-size: 22px;'>Aurelian Hotel</h2>" +
                "        </div>" +
                "        <div class='content'>" +
                "            <h1>Secure Password Reset</h1>" +
                "            <p>Greetings from <strong>Aurelian Hotel</strong>,</p>" +
                "            <p>We received a request to update the password for your account. If this was you, please click the button below to proceed with the reset.</p>" +
                "            <a href='" + resetUrl + "' class='button'>RESET MY PASSWORD</a>" +
                "            <div class='divider'></div>" +
                "            <p style='font-size: 14px; color: #999;'>If you didn't request this change, you can safely ignore this email. Your password will remain unchanged.</p>" +
                "        </div>" +
                "        <div class='footer'>" +
                "            <p>&copy; 2026 <strong>Aurelian Hotel</strong> | Hospitality, Perfected</p>" +
                "            <p>123 Luxury Boulevard, Paradise City, PC 54321</p>" +
                "        </div>" +
                "    </div>" +
                "</body>" +
                "</html>";

            System.out.println("Attempting to send reset email to: " + user.getEmail());
            try {
                String logoResourcePath = "static/favicon.png";
                emailService.sendHtmlEmailWithLogo(user.getEmail(), "Password Reset Request - Aurelian Hotel", htmlMsg, logoResourcePath);
                System.out.println("Email sent successfully.");
                redirectAttributes.addFlashAttribute("success", "A password reset link has been sent to your email.");
            } catch (Exception e) {
                System.err.println("Failed to send email: " + e.getMessage());
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("success", "Password reset link generated! (Check console for HTML content).");
            }
        } catch (Exception e) {
            System.err.println("Critical error in processForgotPassword: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "An internal error occurred: " + e.getMessage());
        }

        return "redirect:/forgot-password";
    }

    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam("token") String token, Model model, RedirectAttributes redirectAttributes) {
        String result = userService.validatePasswordResetToken(token);
        if (result != null) {
            String message = result.equals("expired") ? "Your reset link has expired." : "Invalid reset link.";
            redirectAttributes.addFlashAttribute("error", message);
            return "redirect:/login";
        }

        model.addAttribute("token", token);
        return "reset-password";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(@RequestParam("token") String token,
                                       @RequestParam("password") String password,
                                       @RequestParam("confirmPassword") String confirmPassword,
                                       RedirectAttributes redirectAttributes) {
        
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match.");
            return "redirect:/reset-password?token=" + token;
        }

        String result = userService.validatePasswordResetToken(token);
        if (result != null) {
            redirectAttributes.addFlashAttribute("error", "Invalid or expired token.");
            return "redirect:/login";
        }

        Optional<User> userOpt = userService.getUserByPasswordResetToken(token);
        if (userOpt.isPresent()) {
            userService.changeUserPassword(userOpt.get(), password);
            redirectAttributes.addFlashAttribute("success", "Your password has been successfully updated.");
            return "redirect:/login";
        } else {
            redirectAttributes.addFlashAttribute("error", "Error updating password.");
            return "redirect:/login";
        }
    }
    @PostMapping("/forgot-password-questions")
    public String processForgotPasswordQuestions(@RequestParam("identifier") String identifier, 
                                                 Model model, 
                                                 RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = userService.findByUsername(identifier);
        if (!userOpt.isPresent()) {
            userOpt = userService.findByEmail(identifier);
        }

        if (!userOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "No account found with that username or email.");
            return "redirect:/forgot-password-questions";
        }

        User user = userOpt.get();
        if (user.getSecurityQuestion1() == null || user.getSecurityQuestion2() == null) {
            redirectAttributes.addFlashAttribute("error", "This account does not have security questions set up. Please use the email reset method.");
            return "redirect:/forgot-password";
        }

        model.addAttribute("username", user.getUsername());
        model.addAttribute("question1", user.getSecurityQuestion1());
        model.addAttribute("question2", user.getSecurityQuestion2());
        return "security-questions";
    }

    @PostMapping("/verify-security-questions")
    public String verifySecurityQuestions(@RequestParam("username") String username,
                                          @RequestParam("answer1") String answer1,
                                          @RequestParam("answer2") String answer2,
                                          RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = userService.findByUsername(username);
        if (!userOpt.isPresent()) {
            return "redirect:/login";
        }

        User user = userOpt.get();
        // Case-insensitive comparison for answers
        if (answer1.trim().equalsIgnoreCase(user.getSecurityAnswer1()) && 
            answer2.trim().equalsIgnoreCase(user.getSecurityAnswer2())) {
            
            // Logic successful - generate a token so they can access the reset page
            String token = UUID.randomUUID().toString();
            userService.createPasswordResetTokenForUser(user, token);
            
            return "redirect:/reset-password?token=" + token;
        } else {
            redirectAttributes.addFlashAttribute("error", "Incorrect answers to security questions.");
            return "redirect:/forgot-password-questions";
        }
    }
}
