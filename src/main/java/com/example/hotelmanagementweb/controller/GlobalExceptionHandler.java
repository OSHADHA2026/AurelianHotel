package com.example.hotelmanagementweb.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

/**
 * Last-resort handler: logs the full stack trace and shows the shared error page.
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(Throwable.class)
    public ModelAndView handleAllExceptions(Throwable ex) {
        log.error("Unhandled exception: {}", ex.getMessage(), ex);

        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", ex);
        mav.addObject("url", "GlobalError");
        mav.setViewName("error");
        return mav;
    }
}
