package assem.controllers;

import assem.exchange.profiles.ProfileExchange;
import jakarta.servlet.http.HttpSession;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;

public final class ControllerCheck {

    

    private ControllerCheck() {}

    public static ControllerCheck instance() {
        return new ControllerCheck();
    }

    public boolean hasErrors(BindingResult bindingResult) {
        return bindingResult.hasErrors();
    }

    public String getBindingErrors(BindingResult bindingResult) {
        return bindingResult
                .getAllErrors()
                .stream()
                .map(ObjectError::getDefaultMessage)
                .findFirst()
                .orElse("Validation failed");
    }


    // Authentication Checks

    public boolean isAuthenticated(HttpSession session) {
        return session != null && session.getAttribute("profile") instanceof ProfileExchange;
    }

    public ProfileExchange getProfile(HttpSession session) {
        if (!isAuthenticated(session)) {
            return null;
        }
        return (ProfileExchange) session.getAttribute("profile");
    }
}
