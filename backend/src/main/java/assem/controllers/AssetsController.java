package assem.controllers;

import assem.exchange.assets.Registration;
import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.repository.ApprovalsRepository;
import assem.repository.AssetRepository;
import assem.utils.FileUtil;
import org.springframework.beans.factory.annotation.Autowired;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/assets")
public class AssetsController {

    // role_types.id of the asset-admin role; a registration is only accepted for
    // a station the signed-in profile actually administers.
    private static final int ASSET_ADMIN_ROLE_TYPE_ID = 20;

    @Autowired
    private AssetRepository assetRepository;

    @Autowired
    private ApprovalsRepository approvalsRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    @GetMapping("/registrations/{station}")
    public ResponseEntity<?> getRegistrations(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        // The station would never appear in their dropdown without the role, so a
        // request for one they don't administer means the client was tampered with:
        // drop the session and force a fresh login.
        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to view this station.");
        }

        Result<List<Map<String, Object>>> result = assetRepository.getRegistrations(station);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/registrations/{id}")
    public ResponseEntity<?> getRegistration(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<Map<String, Object>> details = assetRepository.getRegistrationDetails(id);
        if (!details.isOk()) return ResponseEntity.badRequest().body(details.getMessage());
        Result<List<Map<String, Object>>> list = assetRepository.getRegistrationAssets(id);
        if (!list.isOk()) return ResponseEntity.badRequest().body(list.getMessage());
        int eventRegisterId = ((Number) details.getData().get("event_register_id")).intValue();
        Result<List<Map<String, Object>>> approvals = approvalsRepository.getEventApprovals(eventRegisterId);
        if (!approvals.isOk()) return ResponseEntity.badRequest().body(approvals.getMessage());
        return ResponseEntity.ok(Map.of("details", details.getData(), "list", list.getData(), "approvals", approvals.getData()));
    }

    @PostMapping(value = "/registration", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> createRegistration(
            @Valid @ModelAttribute Registration registration,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (checks.hasErrors(bindingResult)) {
            return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        }

        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, registration.getEventStationId())) {
            return ResponseEntity.status(403).body("You are not authorized to register assets at this station.");
        }

        registration.setEventAdminId(profile.getProfileId());
        registration.setReferenceAttachmentPath(FileUtil.instance().save(registration.getReferenceAttachment()));
        if (registration.getReferenceAttachmentPath() == null) {
            return ResponseEntity.badRequest().body("The reference attachment could not be stored.");
        }

        Result<Boolean> result = assetRepository.createRegistration(registration);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok().build();
    }
}
