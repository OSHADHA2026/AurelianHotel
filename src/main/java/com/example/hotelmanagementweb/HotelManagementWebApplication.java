package com.example.hotelmanagementweb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class HotelManagementWebApplication {

    public static void main(String[] args) {
        SpringApplication.run(HotelManagementWebApplication.class, args);
    }

}
