package assem.controllers;

import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.repository.AuditRepository;
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
@RequestMapping("/api/audit")
public class AuditController {

    private static final int AUDITOR_ROLE_TYPE_ID = 60;

    @Autowired
    private AuditRepository auditRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    private ResponseEntity<?> denyUnlessAuditor(HttpSession session) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(AUDITOR_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("Auditor role required.");
        }
        return null;
    }

    private ResponseEntity<?> denyUnlessAuditorStation(HttpSession session, int stationId) {
        ResponseEntity<?> denied = denyUnlessAuditor(session);
        if (denied != null) return denied;
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(AUDITOR_ROLE_TYPE_ID, stationId)) {
            return ResponseEntity.status(403).body("Auditor role required for this station.");
        }
        return null;
    }

    @GetMapping("/catalog")
    public ResponseEntity<?> catalog(HttpSession session) {
        ResponseEntity<?> denied = denyUnlessAuditor(session);
        if (denied != null) return denied;
        return ResponseEntity.ok(auditRepository.catalog());
    }

    @GetMapping("/{key}/{stationId}")
    public ResponseEntity<?> run(
            @PathVariable String key,
            @PathVariable int stationId,
            HttpSession session
    ) {
        ResponseEntity<?> denied = denyUnlessAuditorStation(session, stationId);
        if (denied != null) return denied;

        if (!auditRepository.isKnown(key)) {
            return ResponseEntity.badRequest().body("Unknown audit.");
        }

        Result<List<Map<String, Object>>> result = auditRepository.run(key, stationId);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }
}
