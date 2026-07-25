package assem.controllers;

import assem.exchange.assets.IncidentExchange;
import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.repository.ApprovalsRepository;
import assem.repository.AssetRepository;
import assem.utils.FileUtil;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/api/home")
public class HomeController {

    private static final int USER_ACCEPTANCE_TYPE_ID = 10;
    private static final int USER_DECLINED_TYPE_ID = 11;
    private static final int ASSET_ADMIN_ROLE_TYPE_ID = 20;
    private static final int SUPERVISORY_ROLE_TYPE_ID = 40;
    private static final int MANAGEMENT_ROLE_TYPE_ID = 50;
    private static final Set<Integer> DASHBOARD_STATION_ROLES = Set.of(
            ASSET_ADMIN_ROLE_TYPE_ID,
            SUPERVISORY_ROLE_TYPE_ID,
            MANAGEMENT_ROLE_TYPE_ID
    );
    private static final Set<Integer> ASSIGNMENT_RESPONSES = Set.of(
            USER_ACCEPTANCE_TYPE_ID,
            USER_DECLINED_TYPE_ID
    );

    @Autowired
    private AssetRepository assetRepository;

    @Autowired
    private ApprovalsRepository approvalsRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    // scope=mine | station  — station requires stationId + roleTypeId (20/40/50).
    @GetMapping("/dashboard")
    public ResponseEntity<?> getDashboard(
            @RequestParam String scope,
            @RequestParam(required = false) Integer stationId,
            @RequestParam(required = false) Integer roleTypeId,
            HttpSession session
    ) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");

        if ("mine".equals(scope)) {
            Result<Map<String, Object>> result = assetRepository.getDashboardCustody(profile.getProfileId());
            if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
            return ResponseEntity.ok(result.getData());
        }

        if ("station".equals(scope)) {
            if (stationId == null || roleTypeId == null) {
                return ResponseEntity.badRequest().body("Station and role are required.");
            }
            if (!DASHBOARD_STATION_ROLES.contains(roleTypeId) || !profile.hasRole(roleTypeId, stationId)) {
                return ResponseEntity.status(403).body("You are not authorized for that station scope.");
            }
            boolean managerScope = roleTypeId == MANAGEMENT_ROLE_TYPE_ID;
            Result<Map<String, Object>> result = assetRepository.getDashboardStation(stationId, managerScope);
            if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
            return ResponseEntity.ok(result.getData());
        }

        return ResponseEntity.badRequest().body("Unknown dashboard scope.");
    }

    @GetMapping("/assets")
    public ResponseEntity<?> getAssets(HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = assetRepository.getHomeAssets(profile.getProfileId());
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/assignments")
    public ResponseEntity<?> getAssignments(HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = assetRepository.getPendingAssignments(profile.getProfileId());
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok(result.getData());
    }

    @PostMapping("/assignments/respond")
    public ResponseEntity<?> respondToAssignment(@RequestBody Map<String, Object> body, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");

        if (body.get("eventId") == null || body.get("approvalTypeId") == null) {
            return ResponseEntity.badRequest().body("Event and response are required.");
        }
        int eventId = ((Number) body.get("eventId")).intValue();
        int approvalTypeId = ((Number) body.get("approvalTypeId")).intValue();
        String notes = (String) body.getOrDefault("notes", "");

        if (!ASSIGNMENT_RESPONSES.contains(approvalTypeId)) {
            return ResponseEntity.badRequest().body("Response must be accept or decline.");
        }
        if (!assetRepository.canRespondToAssignment(eventId, profile.getProfileId())) {
            return ResponseEntity.status(403).body("This assignment is not awaiting your confirmation.");
        }

        Result<Boolean> result = approvalsRepository.insertApproval(
                eventId, approvalTypeId, notes, profile.getProfileId());
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok(true);
    }

    @GetMapping("/incidents")
    public ResponseEntity<?> getIncidents(HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");
        Result<List<Map<String, Object>>> result = assetRepository.getHomeIncidents(profile.getProfileId());
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok(result.getData());
    }

    @PostMapping(value = "/incident", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> createIncident(
            @Valid @ModelAttribute IncidentExchange incident,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (checks.hasErrors(bindingResult)) return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");

        if (!assetRepository.isCustodian(incident.getRegisteredAssetId(), profile.getProfileId())) {
            return ResponseEntity.status(403).body("You can only report incidents on assets in your custody.");
        }

        incident.setEventAdminId(profile.getProfileId());
        incident.setIncidentAssetImagePath(FileUtil.instance().save(incident.getIncidentAssetImage()));
        incident.setIncidentPoliceReportPath(FileUtil.instance().save(incident.getIncidentPoliceReport()));

        Result<Boolean> result = assetRepository.createIncident(incident);
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok().build();
    }
}
