package assem.controllers;

import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.exchange.profiles.ProfileRole;
import assem.exchange.profiles.StaffCreateExchange;
import assem.repository.UsersRepository;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UsersController {

    private static final int USERS_ADMIN_ROLE_TYPE_ID = 70;

    @Autowired
    private UsersRepository usersRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    @GetMapping("/staff")
    public ResponseEntity<?> staff(HttpSession session) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(USERS_ADMIN_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("Users administrator role required.");
        }

        Result<List<Map<String, Object>>> result = usersRepository.getStaff();
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    @PostMapping("/staff")
    public ResponseEntity<?> createStaff(
            @Valid @RequestBody StaffCreateExchange staff,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(USERS_ADMIN_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("Users administrator role required.");
        }
        if (checks.hasErrors(bindingResult)) {
            return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        }

        Result<Boolean> result = usersRepository.createStaff(staff);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(true);
    }

    @GetMapping("/staff/{entityId}")
    public ResponseEntity<?> staffById(@PathVariable int entityId, HttpSession session) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(USERS_ADMIN_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("Users administrator role required.");
        }

        Result<Map<String, Object>> result = usersRepository.getStaffById(entityId);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    @PostMapping("/staff/{entityId}/password")
    public ResponseEntity<?> resetPassword(
            @PathVariable int entityId,
            @RequestBody Map<String, Object> body,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(USERS_ADMIN_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("Users administrator role required.");
        }

        Object raw = body != null ? body.get("password") : null;
        if (!(raw instanceof String) || ((String) raw).isBlank()) {
            return ResponseEntity.badRequest().body("Password is required.");
        }

        Result<Boolean> result = usersRepository.resetPassword(entityId, (String) raw);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(true);
    }

    @PostMapping("/staff/{entityId}/home-station")
    public ResponseEntity<?> updateHomeStation(
            @PathVariable int entityId,
            @RequestBody Map<String, Object> body,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(USERS_ADMIN_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("Users administrator role required.");
        }

        Object raw = body != null ? body.get("stationId") : null;
        if (!(raw instanceof Number)) {
            return ResponseEntity.badRequest().body("Home station is required.");
        }

        Result<Boolean> result = usersRepository.updateHomeStation(entityId, ((Number) raw).intValue());
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(true);
    }

    @PostMapping("/staff/{entityId}/roles")
    public ResponseEntity<?> addRole(
            @PathVariable int entityId,
            @RequestBody ProfileRole role,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(USERS_ADMIN_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("Users administrator role required.");
        }

        Result<Boolean> result = usersRepository.addRole(entityId, role);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(true);
    }

    @PostMapping("/roles/remove")
    public ResponseEntity<?> removeRole(@RequestBody ProfileRole role, HttpSession session) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(USERS_ADMIN_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("Users administrator role required.");
        }

        Result<Boolean> result = usersRepository.removeRole(role);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        if (Boolean.FALSE.equals(result.getData())) {
            return ResponseEntity.badRequest().body("Role assignment not found.");
        }
        return ResponseEntity.ok(true);
    }
}
