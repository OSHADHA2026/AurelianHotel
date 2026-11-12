package com.example.hotelmanagementweb.repository;

import com.example.hotelmanagementweb.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findAllByOrderByCreatedAtDesc();
    List<Review> findTop10ByOrderByCreatedAtDesc();
    List<Review> findAllByUserIdOrderByCreatedAtDesc(Long userId);

    boolean existsByUserId(Long userId);
}
