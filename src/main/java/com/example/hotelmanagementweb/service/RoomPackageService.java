package com.example.hotelmanagementweb.service;

import com.example.hotelmanagementweb.dto.DiscountResultDTO;
import com.example.hotelmanagementweb.dto.PackageValidationRequestDTO;
import com.example.hotelmanagementweb.dto.PackageValidationResultDTO;
import com.example.hotelmanagementweb.dto.RoomPackageDTO;
import com.example.hotelmanagementweb.exception.PackageNotValidException;
import com.example.hotelmanagementweb.model.RoomPackage;
import com.example.hotelmanagementweb.repository.RoomPackageRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RoomPackageService {

    private final RoomPackageRepository packageRepository;
    private final com.example.hotelmanagementweb.repository.BookingRepository bookingRepository;

    public RoomPackageService(RoomPackageRepository packageRepository, 
                            com.example.hotelmanagementweb.repository.BookingRepository bookingRepository) {
        this.packageRepository = packageRepository;
        this.bookingRepository = bookingRepository;
    }

    public List<RoomPackageDTO> getAllActivePackages() {
        return packageRepository.findByIsActiveTrue().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public List<RoomPackageDTO> getAllPackages() {
        return packageRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public Optional<RoomPackageDTO> getPackageById(Long id) {
        return packageRepository.findById(id).map(this::convertToDTO);
    }

    public RoomPackageDTO createPackage(RoomPackageDTO dto) {
        validatePackageDTO(dto);
        RoomPackage roomPackage = new RoomPackage();
        BeanUtils.copyProperties(dto, roomPackage);
        roomPackage.setId(null); // Ensure new package
        RoomPackage saved = packageRepository.save(roomPackage);
        return convertToDTO(saved);
    }

    public void updatePackageStatus(Long id, boolean isActive) {
        RoomPackage pkg = packageRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Package not found with ID: " + id));
        pkg.setIsActive(isActive);
        packageRepository.save(pkg);
    }

    public RoomPackageDTO updatePackage(Long id, RoomPackageDTO dto) {
        validatePackageDTO(dto);
        RoomPackage pkg = packageRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Package not found with ID: " + id));
        BeanUtils.copyProperties(dto, pkg, "id");
        RoomPackage updated = packageRepository.save(pkg);
        return convertToDTO(updated);
    }

    private void validatePackageDTO(RoomPackageDTO dto) {
        if (dto.getMinNights() != null && dto.getMinNights() < 0) {
            throw new IllegalArgumentException("Minimum nights cannot be negative.");
        }
        if (dto.getMinGuests() != null && dto.getMinGuests() < 0) {
            throw new IllegalArgumentException("Minimum guests cannot be negative.");
        }
        if (dto.getMaxGuests() != null && dto.getMaxGuests() < 0) {
            throw new IllegalArgumentException("Maximum guests cannot be negative.");
        }
        if (dto.getDiscountPercentage() != null && dto.getDiscountPercentage().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Discount percentage cannot be negative.");
        }
    }

    @org.springframework.transaction.annotation.Transactional
    public void deletePackage(Long id) {
        // First nullify all bookings referencing this package to avoid FK constraint issues
        bookingRepository.nullifyPackage(id);
        packageRepository.deleteById(id);
    }

    /**
     * Validates whether a package can be applied based on booking details.
     */
    public PackageValidationResultDTO validatePackageForBooking(PackageValidationRequestDTO details, Long packageId) {
        Optional<RoomPackage> optionalPackage = packageRepository.findById(packageId);

        if (optionalPackage.isEmpty() || !optionalPackage.get().getIsActive()) {
            return new PackageValidationResultDTO(false, "Package is invalid or inactive.");
        }

        RoomPackage pkg = optionalPackage.get();

        if (details.getNumberOfGuests() < pkg.getMinGuests()) {
            return new PackageValidationResultDTO(false, "Not enough guests to apply this package (Minimum: " + pkg.getMinGuests() + ").");
        }

        if (pkg.getMaxGuests() != null && details.getNumberOfGuests() > pkg.getMaxGuests()) {
            return new PackageValidationResultDTO(false, "Too many guests to apply this package (Maximum: " + pkg.getMaxGuests() + ").");
        }

        if (details.getNumberOfNights() < pkg.getMinNights()) {
            return new PackageValidationResultDTO(false, "Stay duration is too short for this package (Minimum nights: " + pkg.getMinNights() + ").");
        }

        if (pkg.getApplicableRoomType() != null && !pkg.getApplicableRoomType().isEmpty() &&
                details.getRoomType() != null && !pkg.getApplicableRoomType().equalsIgnoreCase(details.getRoomType())) {
            return new PackageValidationResultDTO(false, "This package is only applicable for room type: " + pkg.getApplicableRoomType() + ".");
        }

        return new PackageValidationResultDTO(true, "Package is valid and can be applied.");
    }

    /**
     * Applies the package discount to the given amount.
     */
    public DiscountResultDTO applyPackageDiscount(BigDecimal totalAmount, Long packageId) {
        RoomPackage pkg = packageRepository.findById(packageId)
                .orElseThrow(() -> new PackageNotValidException("Package ID " + packageId + " not found or unavailable."));

        BigDecimal discountAmount = BigDecimal.ZERO;

        if (pkg.getDiscountPercentage() != null && pkg.getDiscountPercentage().compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal percentage = pkg.getDiscountPercentage().divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP);
            discountAmount = totalAmount.multiply(percentage).setScale(2, RoundingMode.HALF_UP);
        }

        BigDecimal finalAmount = totalAmount.subtract(discountAmount);
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
            finalAmount = BigDecimal.ZERO;
        }

        return new DiscountResultDTO(totalAmount, discountAmount, finalAmount, pkg.getName());
    }

    private RoomPackageDTO convertToDTO(RoomPackage pkg) {
        RoomPackageDTO dto = new RoomPackageDTO();
        BeanUtils.copyProperties(pkg, dto);
        return dto;
    }
}
