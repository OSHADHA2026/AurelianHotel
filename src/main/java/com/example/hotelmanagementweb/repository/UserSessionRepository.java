package com.example.hotelmanagementweb.repository;

import com.example.hotelmanagementweb.model.UserSession;
import com.example.hotelmanagementweb.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserSessionRepository extends JpaRepository<UserSession, Long> {
    List<UserSession> findByUserOrderByLoginTimeDesc(User user);
    java.util.Optional<UserSession> findFirstByUserOrderByLoginTimeDesc(User user);
    @org.springframework.data.jpa.repository.Query("SELECT us FROM UserSession us JOIN FETCH us.user ORDER BY us.loginTime DESC")
    List<UserSession> findAllByOrderByLoginTimeDesc();
    List<UserSession> findByLogoutTimeIsNull();
}
