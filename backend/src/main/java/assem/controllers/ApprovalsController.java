package assem.controllers;

import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.repository.ManagementRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/approvals")
public class ApprovalsController {

    private static final int SUPERVISORY_ROLE_TYPE_ID = 40;
    private static final int MANAGEMENT_ROLE_TYPE_ID  = 50;

    @Autowired
    private ManagementRepository managementRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    @GetMapping("/pending/{station}")
    public ResponseEntity<?> pending(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        Result<List<Map<String, Object>>> result;

        if (profile.hasRole(SUPERVISORY_ROLE_TYPE_ID, station)) {
            result = managementRepository.supervisoryPending(station);
        } else if (profile.hasRole(MANAGEMENT_ROLE_TYPE_ID, station)) {
            result = managementRepository.managementPending(station);
        } else {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized for this station.");
        }

        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/history/{station}")
    public ResponseEntity<?> history(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        Result<List<Map<String, Object>>> result;

        if (profile.hasRole(SUPERVISORY_ROLE_TYPE_ID, station)) {
            result = managementRepository.supervisoryHistory(station);
        } else if (profile.hasRole(MANAGEMENT_ROLE_TYPE_ID, station)) {
            result = managementRepository.managementHistory(station);
        } else {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized for this station.");
        }

        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok(result.getData());
    }
}
