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

    @GetMapping("/supervisory/pending/{station}")
    public ResponseEntity<?> supervisoryPending(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(403).body("Forbidden");
        if (!profile.hasRole(SUPERVISORY_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized for this station.");
        }
        Result<List<Map<String, Object>>> result = managementRepository.supervisoryPending(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/supervisory/history/{station}")
    public ResponseEntity<?> supervisoryHistory(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(403).body("Forbidden");
        if (!profile.hasRole(SUPERVISORY_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized for this station.");
        }
        Result<List<Map<String, Object>>> result = managementRepository.supervisoryHistory(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/management/pending/{station}")
    public ResponseEntity<?> managementPending(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(403).body("Forbidden");
        if (!profile.hasRole(MANAGEMENT_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized for this station.");
        }
        Result<List<Map<String, Object>>> result = managementRepository.managementPending(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/management/history/{station}")
    public ResponseEntity<?> managementHistory(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(403).body("Forbidden");
        if (!profile.hasRole(MANAGEMENT_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized for this station.");
        }
        Result<List<Map<String, Object>>> result = managementRepository.managementHistory(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }
}
