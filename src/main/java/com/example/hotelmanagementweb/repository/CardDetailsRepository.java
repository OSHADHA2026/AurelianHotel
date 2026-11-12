package com.example.hotelmanagementweb.repository;

import com.example.hotelmanagementweb.model.CardDetails;
import com.example.hotelmanagementweb.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CardDetailsRepository extends JpaRepository<CardDetails, Long> {

    // Find all cards by user
    List<CardDetails> findByUserOrderByIsDefaultDescCreatedAtDesc(User user);

    // Find all cards by user ID
    List<CardDetails> findByUserIdOrderByIsDefaultDescCreatedAtDesc(Long userId);

    // Find default card for user
    Optional<CardDetails> findByUserAndIsDefaultTrue(User user);

    // Find default card for user ID
    Optional<CardDetails> findByUserIdAndIsDefaultTrue(Long userId);
}

