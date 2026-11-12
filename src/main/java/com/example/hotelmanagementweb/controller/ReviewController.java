package com.example.hotelmanagementweb.controller;

import com.example.hotelmanagementweb.model.Review;
import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;

@Controller
@RequestMapping("/reviews")
public class ReviewController {

    private final ReviewService reviewService;

    @GetMapping("/all")
    public String showAllReviews(Model model, HttpSession session) {
        model.addAttribute("reviews", reviewService.getAllReviews());
        model.addAttribute("currentUser", session.getAttribute("user"));
        return "reviews";
    }

    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @PostMapping
    public String createReview(@RequestParam("rating") Integer rating,
                               @RequestParam("comment") String comment,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", ReviewService.MSG_LOGIN_REQUIRED);
            return "redirect:/login";
        }

        try {
            reviewService.createReview(user, rating, comment);
            redirectAttributes.addFlashAttribute("success", "Thank you for your review!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/home";
    }

    @PostMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteReview(@PathVariable("id") Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Login required"));
        }

        try {
            reviewService.deleteReview(id, user);
            return ResponseEntity.ok(Map.of("message", "Review deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(403).body(Map.of("message", e.getMessage()));
        }
    }

    @PostMapping("/edit/{id}")
    @ResponseBody
    public ResponseEntity<?> updateReview(@PathVariable("id") Long id,
                                          @RequestParam("rating") Integer rating,
                                          @RequestParam("comment") String comment,
                                          HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Login required"));
        }

        try {
            Review updatedReview = reviewService.updateReview(id, rating, comment, user);
            return ResponseEntity.ok(Map.of(
                "message", "Review updated successfully",
                "rating", updatedReview.getRating(),
                "comment", updatedReview.getComment()
            ));
        } catch (Exception e) {
            return ResponseEntity.status(403).body(Map.of("message", e.getMessage()));
        }
    }
}
