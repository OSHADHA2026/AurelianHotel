package com.example.hotelmanagementweb.dto;

public class PackageValidationResultDTO {

    private boolean isValid;
    private String message;

    public PackageValidationResultDTO(boolean isValid, String message) {
        this.isValid = isValid;
        this.message = message;
    }

    public boolean isValid() {
        return isValid;
    }

    public void setValid(boolean valid) {
        isValid = valid;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
