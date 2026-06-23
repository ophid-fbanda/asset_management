package assem.controllers;

import assem.exchange.commons.Result;
import assem.repository.ApprovalsRepository;
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

    @Autowired
    private ApprovalsRepository managementRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    @GetMapping("/supervisory/pending/{station}")
    public ResponseEntity<?> supervisoryPending(@PathVariable int station, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = managementRepository.supervisoryPending(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/supervisory/history/{station}")
    public ResponseEntity<?> supervisoryHistory(@PathVariable int station, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = managementRepository.supervisoryHistory(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/management/pending/{station}")
    public ResponseEntity<?> managementPending(@PathVariable int station, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = managementRepository.managementPending(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/management/history/{station}")
    public ResponseEntity<?> managementHistory(@PathVariable int station, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = managementRepository.managementHistory(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/{eventId}/details")
    public ResponseEntity<?> eventApprovals(@PathVariable int eventId, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = managementRepository.getEventApprovals(eventId);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }
}
