package com.example.hotelmanagementweb.controller;

import com.example.hotelmanagementweb.dto.RoomPackageDTO;
import com.example.hotelmanagementweb.service.RoomPackageService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/packages")
public class RoomPackageController {

    private final RoomPackageService packageService;

    public RoomPackageController(RoomPackageService packageService) {
        this.packageService = packageService;
    }

    /**
     * GET /api/packages -> List all active packages
     */
    @GetMapping
    public ResponseEntity<List<RoomPackageDTO>> getActivePackages() {
        return ResponseEntity.ok(packageService.getAllActivePackages());
    }

    /**
     * GET /api/packages/{id} -> Get a package's details
     */
    @GetMapping("/{id}")
    public ResponseEntity<RoomPackageDTO> getPackageById(@PathVariable Long id) {
        return packageService.getPackageById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * POST /api/packages -> Create a new package (Admin)
     */
    @PostMapping
    public ResponseEntity<RoomPackageDTO> createPackage(@RequestBody RoomPackageDTO packageDTO) {
        RoomPackageDTO saved = packageService.createPackage(packageDTO);
        return ResponseEntity.status(201).body(saved);
    }

    /**
     * PUT /api/packages/{id}/status -> Activate or deactivate a package
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<Void> updatePackageStatus(
            @PathVariable Long id,
            @RequestParam boolean isActive) {
        try {
            packageService.updatePackageStatus(id, isActive);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
