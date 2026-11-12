package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.model.User;
import com.example.hotelmanagementweb.model.UserSession;
import com.example.hotelmanagementweb.repository.UserSessionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class UserSessionService {

    private final UserSessionRepository userSessionRepository;

    public UserSessionService(UserSessionRepository userSessionRepository) {
        this.userSessionRepository = userSessionRepository;
    }

    @Transactional
    public Long recordLogin(User user) {
        // Only track for Admin and Staff (EMPLOYEE)
        if (user == null || (!"ADMIN".equals(user.getRole()) && !"EMPLOYEE".equals(user.getRole()))) {
            return null;
        }

        UserSession session = userSessionRepository.findFirstByUserOrderByLoginTimeDesc(user)
                .orElse(new UserSession(user, LocalDateTime.now()));
        
        session.setLoginTime(LocalDateTime.now());
        session.setLogoutTime(null);
        // We don't reset duration here, we'll add to it in recordLogout
        
        UserSession saved = userSessionRepository.save(session);
        return saved.getId();
    }

    @Transactional
    public void recordLogout(Long sessionId) {
        if (sessionId == null) return;
        
        Optional<UserSession> sessionOpt = userSessionRepository.findById(sessionId);
        if (sessionOpt.isPresent()) {
            UserSession session = sessionOpt.get();
            if (session.getLogoutTime() == null) {
                LocalDateTime logoutTime = LocalDateTime.now();
                session.setLogoutTime(logoutTime);
                
                // Calculate current session duration in minutes
                long currentSessionMinutes = Duration.between(session.getLoginTime(), logoutTime).toMinutes();
                
                // Add to cumulative duration
                long totalMinutes = (session.getDurationMinutes() != null ? session.getDurationMinutes() : 0) + currentSessionMinutes;
                session.setDurationMinutes(totalMinutes);
                
                userSessionRepository.save(session);
            }
        }
    }

    public List<UserSession> getAllSessions() {
        return userSessionRepository.findAllByOrderByLoginTimeDesc().stream()
                .filter(us -> us.getUser() != null && 
                             ("ADMIN".equals(us.getUser().getRole()) || "EMPLOYEE".equals(us.getUser().getRole())))
                .toList();
    }

    public List<UserSession> getSessionsByUser(User user) {
        return userSessionRepository.findByUserOrderByLoginTimeDesc(user);
    }
}
