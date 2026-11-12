package com.example.hotelmanagementweb.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.MessagingException;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendHtmlEmailWithLogo(String to, String subject, String htmlContent, String logoResourcePath) {
        System.out.println("--- NEW HTML EMAIL (WITH LOGO) ---");
        System.out.println("To: " + to);
        System.out.println("Subject: " + subject);
        System.out.println("-----------------");

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);
            
            // Add inline logo using ClassPathResource for better compatibility
            org.springframework.core.io.ClassPathResource res = new org.springframework.core.io.ClassPathResource(logoResourcePath);
            helper.addInline("logo", res);
            
            mailSender.send(message);
        } catch (MessagingException e) {
            System.err.println("Failed to send HTML email with logo: " + e.getMessage());
            throw new RuntimeException("Failed to send email", e);
        }
    }
}
