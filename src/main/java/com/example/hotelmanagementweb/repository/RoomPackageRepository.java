package com.example.hotelmanagementweb.repository;

import com.example.hotelmanagementweb.model.RoomPackage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomPackageRepository extends JpaRepository<RoomPackage, Long> {
    
    List<RoomPackage> findByIsActiveTrue();
    
}
