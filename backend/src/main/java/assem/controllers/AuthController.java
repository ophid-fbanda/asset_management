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

}


