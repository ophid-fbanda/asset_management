package assem.controllers;

import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.repository.ApprovalsRepository;
import assem.repository.AssetRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/approvals")
public class ApprovalsController {

    private static final int MANAGEMENT_APPROVAL_TYPE_ID = 50;

    @Autowired
    private ApprovalsRepository approvalsRepository;

    @Autowired
    private AssetRepository assetRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    @GetMapping("/supervisory/pending/{station}")
    public ResponseEntity<?> supervisoryPending(@PathVariable int station, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = approvalsRepository.supervisoryPending(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/supervisory/history/{station}")
    public ResponseEntity<?> supervisoryHistory(@PathVariable int station, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = approvalsRepository.supervisoryHistory(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/management/pending/{station}")
    public ResponseEntity<?> managementPending(@PathVariable int station, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = approvalsRepository.managementPending(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/management/history/{station}")
    public ResponseEntity<?> managementHistory(@PathVariable int station, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = approvalsRepository.managementHistory(station);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @GetMapping("/{eventId}/details")
    public ResponseEntity<?> eventApprovals(@PathVariable int eventId, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = approvalsRepository.getEventApprovals(eventId);
        return result.isOk() ? ResponseEntity.ok(result.getData()) : ResponseEntity.badRequest().body(result.getMessage());
    }

    @PostMapping("/approve")
    public ResponseEntity<?> approve(@RequestBody Map<String, Object> body, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        ProfileExchange profile = checks.getProfile(session);
        int eventId = ((Number) body.get("eventId")).intValue();
        int approvalTypeId = ((Number) body.get("approvalTypeId")).intValue();
        String notes = (String) body.getOrDefault("notes", "");

        // Accept / decline (10 / 11): issuance recipient, or admin of the receiving transfer station.
        if (approvalTypeId == 10 || approvalTypeId == 11) {
            boolean issuance = assetRepository.canRespondToAssignment(eventId, profile.getProfileId());
            boolean transfer = assetRepository.canRespondToIncomingTransfer(eventId, profile.getProfileId());
            if (!issuance && !transfer) {
                return ResponseEntity.status(403).body("This item is not awaiting your confirmation.");
            }
        }

        Result<Boolean> result = approvalsRepository.insertApproval(eventId, approvalTypeId, notes, profile.getProfileId());
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());

        // Manager approval of Theft / Missing / Lost composes a disposal on the same event_id.
        if (approvalTypeId == MANAGEMENT_APPROVAL_TYPE_ID) {
            Result<Boolean> disposal = assetRepository.createDisposalFromApprovedIncident(eventId);
            if (!disposal.isOk()) return ResponseEntity.badRequest().body(disposal.getMessage());
        }

        return ResponseEntity.ok(true);
    }
}
