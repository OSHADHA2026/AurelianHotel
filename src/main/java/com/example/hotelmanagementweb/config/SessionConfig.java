package com.example.hotelmanagementweb.config;

import com.example.hotelmanagementweb.model.UserSession;
import com.example.hotelmanagementweb.repository.UserSessionRepository;
import com.example.hotelmanagementweb.service.UserSessionService;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.List;

@Configuration
public class SessionConfig {

    public SessionConfig(UserSessionService userSessionService) {
    }

    @Bean
    public ServletListenerRegistrationBean<CustomSessionListener> customSessionListenerRegistration(UserSessionService userSessionService) {
        ServletListenerRegistrationBean<CustomSessionListener> bean = new ServletListenerRegistrationBean<>();
        bean.setListener(new CustomSessionListener(userSessionService));
        return bean;
    }

    public static class CustomSessionListener implements HttpSessionListener {
        private static final Logger logger = LoggerFactory.getLogger(CustomSessionListener.class);
        private final UserSessionService userSessionService;

        public CustomSessionListener(UserSessionService userSessionService) {
            this.userSessionService = userSessionService;
        }

        @Override
        public void sessionDestroyed(HttpSessionEvent se) {
            Long userSessionId = (Long) se.getSession().getAttribute("userSessionId");
            if (userSessionId != null && userSessionService != null) {
                logger.info("Session {} destroyed. Recording logout time for session entry {}.", se.getSession().getId(), userSessionId);
                userSessionService.recordLogout(userSessionId);
            }
        }
    }

    @Component
    public static class SessionStartupCleanup {
        private static final Logger logger = LoggerFactory.getLogger(SessionStartupCleanup.class);
        private final UserSessionRepository userSessionRepository;
        private final UserSessionService userSessionService;

        public SessionStartupCleanup(UserSessionRepository userSessionRepository, UserSessionService userSessionService) {
            this.userSessionRepository = userSessionRepository;
            this.userSessionService = userSessionService;
        }

        @EventListener(ApplicationReadyEvent.class)
        public void cleanupStuckSessions() {
            logger.info("Server started. Hunting for stuck 'Active' sessions from previous runs...");
            List<UserSession> activeSessions = userSessionRepository.findByLogoutTimeIsNull();
            if (!activeSessions.isEmpty()) {
                logger.info("Found {} stuck sessions. Marking them as ended at server startup time.", activeSessions.size());
                for (UserSession session : activeSessions) {
                    userSessionService.recordLogout(session.getId());
                }
            }
        }
    }
}
