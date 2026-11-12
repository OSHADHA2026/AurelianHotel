package com.example.hotelmanagementweb.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.example.hotelmanagementweb.dto.BookingTrendDto;
import com.example.hotelmanagementweb.model.Room;
import com.example.hotelmanagementweb.repository.BookingRepository;

class BookingServiceTest {

    @Mock
    private BookingRepository bookingRepository;

    @Mock
    private RoomService roomService;

    @Mock
    private NotificationService notificationService;

    @InjectMocks
    private BookingService bookingService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testGetBookingTrends_Success() {
        // Arrange: Prepare mock data
        BookingTrendDto trendDto = new BookingTrendDto(2025, 3, 10L, new BigDecimal("1000.00"));
        when(bookingRepository.findBookingTrends()).thenReturn(Collections.singletonList(trendDto));
        
        Room dummyRoom = new Room();
        when(roomService.getAllRooms()).thenReturn(Collections.nCopies(5, dummyRoom)); // Total 5 rooms

        // Act: Execute service method
        List<BookingTrendDto> result = bookingService.getBookingTrends();

        // Assert: Verify expectations
        assertNotNull(result, "Result should not be null");
        assertFalse(result.isEmpty(), "Result should not be empty");
        BookingTrendDto firstDto = result.get(0);
        assertEquals(2025, firstDto.getYear());
        assertEquals(3, firstDto.getMonth());
        assertEquals(10L, firstDto.getBookingCount());
        
        // Capacity = 5 rooms * 30 days = 150 room-nights
        // Rate = (10 / 150) * 100 = 6.67%
        // Scaled Rate for demo (rate * 10) = 66.67%
        assertNotNull(firstDto.getOccupancyPercentage());
        assertTrue(firstDto.getOccupancyPercentage() > 0);
    }
}
