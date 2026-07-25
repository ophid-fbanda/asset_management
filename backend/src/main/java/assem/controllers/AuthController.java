package assem.controllers;

import assem.exchange.auth.StaffProfileRequest;
import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.service.AuthService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;

import org.springframework.web.bind.annotation.GetMapping;

import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestBody;

import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")

public class AuthController {

    @Autowired
    AuthService authService;

    private final ControllerCheck checks = ControllerCheck.instance();


    @PostMapping("/login")

    public ResponseEntity<?> login(

            @Valid @RequestBody StaffProfileRequest login,
            BindingResult bindingResult,
            HttpSession session

    ) {

        if (checks.hasErrors(bindingResult)) {
            return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        }


        Result<?> result = authService.login(login);

        if (!result.isOk()) {

            return ResponseEntity.status(401).body(result.getMessage());

        }

        ProfileExchange profile = (ProfileExchange) result.getData();
        session.setAttribute("profile", profile);
        return ResponseEntity.ok(profile);
    }



    @GetMapping("/refresh")
    public ResponseEntity<?> reauthenticate(HttpSession session) {

        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        return ResponseEntity.ok(checks.getProfile(session));
    }



    @PostMapping("/logout")

    public ResponseEntity<?> logout(HttpSession session) {
        session.invalidate();
        return ResponseEntity.ok().build();
    }

    @PostMapping("/password")
    public ResponseEntity<?> changePassword(
            @RequestBody Map<String, Object> body,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        ProfileExchange profile = checks.getProfile(session);
        String currentPassword = body != null && body.get("currentPassword") != null
                ? String.valueOf(body.get("currentPassword"))
                : null;
        String newPassword = body != null && body.get("newPassword") != null
                ? String.valueOf(body.get("newPassword"))
                : null;

        Result<Boolean> result = authService.changePassword(
                profile.getProfileId(),
                currentPassword,
                newPassword
        );
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(true);
    }

    @PostMapping("/contact")
    public ResponseEntity<?> updateContact(
            @RequestBody Map<String, Object> body,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        ProfileExchange profile = checks.getProfile(session);
        String email = body != null && body.get("email") != null
                ? String.valueOf(body.get("email"))
                : null;
        String phone = body != null && body.get("phone") != null
                ? String.valueOf(body.get("phone"))
                : null;

        Result<ProfileExchange> result = authService.updateContact(
                profile.getProfileId(),
                email,
                phone
        );
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        session.setAttribute("profile", result.getData());
        return ResponseEntity.ok(result.getData());
    }

}


