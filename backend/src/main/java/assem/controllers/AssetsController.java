package assem.controllers;

import assem.exchange.assets.DisposalExchange;
import assem.exchange.assets.EvaluationExchange;
import assem.exchange.assets.PlacementExchange;
import assem.exchange.assets.IssuanceExchange;
import assem.exchange.assets.Registration;
import assem.exchange.assets.TransferExchange;
import assem.exchange.assets.VerificationExchange;
import assem.exchange.assets.RequestExchange;
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
import org.springframework.web.bind.annotation.RequestBody;
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

    @GetMapping("/station/{station}")
    public ResponseEntity<?> getStationAssets(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(403).body("Forbidden");
        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to view this station.");
        }
        Result<List<Map<String, Object>>> result = assetRepository.getStationAssets(station);
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok(result.getData());
    }

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

    @GetMapping("/requests/{station}")
    public ResponseEntity<?> getRequests(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to view this station.");
        }

        Result<List<Map<String, Object>>> result = assetRepository.getRequests(station);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/changes/{station}")
    public ResponseEntity<?> getStationChanges(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to view this station.");
        }

        Result<List<Map<String, Object>>> result = assetRepository.getStationChanges(station);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/incidents/{station}")
    public ResponseEntity<?> getStationIncidents(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to view this station.");
        }

        Result<List<Map<String, Object>>> result = assetRepository.getStationIncidents(station);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/incoming/{station}")
    public ResponseEntity<?> getIncomingTransfers(@PathVariable int station, HttpSession session) {
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, station)) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to view this station.");
        }

        Result<List<Map<String, Object>>> result = assetRepository.getIncomingTransfers(station);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/incident/{id}")
    public ResponseEntity<?> getIncident(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<Map<String, Object>> details = assetRepository.getIncidentDetails(id);
        if (!details.isOk()) return ResponseEntity.badRequest().body(details.getMessage());
        int eventRegisterId = ((Number) details.getData().get("event_register_id")).intValue();
        Result<List<Map<String, Object>>> approvals = approvalsRepository.getEventApprovals(eventRegisterId);
        if (!approvals.isOk()) return ResponseEntity.badRequest().body(approvals.getMessage());
        return ResponseEntity.ok(Map.of("details", details.getData(), "approvals", approvals.getData()));
    }

    @GetMapping("/registration/{id}")
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

    @GetMapping("/request/{id}")
    public ResponseEntity<?> getRequest(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<Map<String, Object>> details = assetRepository.getRequestDetails(id);
        if (!details.isOk()) return ResponseEntity.badRequest().body(details.getMessage());
        Result<List<Map<String, Object>>> list = assetRepository.getRequestItems(id);
        if (!list.isOk()) return ResponseEntity.badRequest().body(list.getMessage());
        int eventRegisterId = ((Number) details.getData().get("event_register_id")).intValue();
        Result<List<Map<String, Object>>> approvals = approvalsRepository.getEventApprovals(eventRegisterId);
        if (!approvals.isOk()) return ResponseEntity.badRequest().body(approvals.getMessage());
        return ResponseEntity.ok(Map.of("details", details.getData(), "list", list.getData(), "approvals", approvals.getData()));
    }

    @PostMapping("/request")
    public ResponseEntity<?> createRequest(
            @Valid @RequestBody RequestExchange request,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (checks.hasErrors(bindingResult)) return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");
        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, request.getEventStationId())) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to submit requisitions for this station.");
        }
        request.setEventAdminId(profile.getProfileId());
        Result<Boolean> result = assetRepository.createRequest(request);
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/placement/{id}")
    public ResponseEntity<?> getPlacement(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<Map<String, Object>> details = assetRepository.getPlacementDetails(id);
        if (!details.isOk()) return ResponseEntity.badRequest().body(details.getMessage());
        int eventRegisterId = ((Number) details.getData().get("event_register_id")).intValue();
        Result<List<Map<String, Object>>> approvals = approvalsRepository.getEventApprovals(eventRegisterId);
        if (!approvals.isOk()) return ResponseEntity.badRequest().body(approvals.getMessage());
        return ResponseEntity.ok(Map.of("details", details.getData(), "approvals", approvals.getData()));
    }

    @GetMapping("/disposal/{id}")
    public ResponseEntity<?> getDisposal(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<Map<String, Object>> details = assetRepository.getDisposalDetails(id);
        if (!details.isOk()) return ResponseEntity.badRequest().body(details.getMessage());
        int eventRegisterId = ((Number) details.getData().get("event_register_id")).intValue();
        Result<List<Map<String, Object>>> approvals = approvalsRepository.getEventApprovals(eventRegisterId);
        if (!approvals.isOk()) return ResponseEntity.badRequest().body(approvals.getMessage());
        return ResponseEntity.ok(Map.of("details", details.getData(), "approvals", approvals.getData()));
    }

    @PostMapping("/disposal")
    public ResponseEntity<?> createDisposal(
            @Valid @RequestBody DisposalExchange disposal,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (checks.hasErrors(bindingResult)) return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");
        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, disposal.getEventStationId())) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to submit disposals for this station.");
        }
        disposal.setEventAdminId(profile.getProfileId());
        Result<Boolean> result = assetRepository.createDisposal(disposal);
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/placement")
    public ResponseEntity<?> createPlacement(
            @Valid @RequestBody PlacementExchange placement,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (checks.hasErrors(bindingResult)) return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");
        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, placement.getEventStationId())) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to submit placements for this station.");
        }
        placement.setEventAdminId(profile.getProfileId());
        Result<Boolean> result = assetRepository.createPlacement(placement);
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/evaluation/{id}")
    public ResponseEntity<?> getEvaluation(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<Map<String, Object>> details = assetRepository.getEvaluationDetails(id);
        if (!details.isOk()) return ResponseEntity.badRequest().body(details.getMessage());
        int eventRegisterId = ((Number) details.getData().get("event_register_id")).intValue();
        Result<List<Map<String, Object>>> approvals = approvalsRepository.getEventApprovals(eventRegisterId);
        if (!approvals.isOk()) return ResponseEntity.badRequest().body(approvals.getMessage());
        return ResponseEntity.ok(Map.of("details", details.getData(), "approvals", approvals.getData()));
    }

    @PostMapping("/evaluation")
    public ResponseEntity<?> createEvaluation(
            @Valid @RequestBody EvaluationExchange evaluation,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (checks.hasErrors(bindingResult)) return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");
        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, evaluation.getEventStationId())) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to submit evaluations for this station.");
        }
        evaluation.setEventAdminId(profile.getProfileId());
        Result<Boolean> result = assetRepository.createEvaluation(evaluation);
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/verification/{id}")
    public ResponseEntity<?> getVerification(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<Map<String, Object>> details = assetRepository.getVerificationDetails(id);
        if (!details.isOk()) return ResponseEntity.badRequest().body(details.getMessage());
        int eventRegisterId = ((Number) details.getData().get("event_register_id")).intValue();
        Result<List<Map<String, Object>>> approvals = approvalsRepository.getEventApprovals(eventRegisterId);
        if (!approvals.isOk()) return ResponseEntity.badRequest().body(approvals.getMessage());
        return ResponseEntity.ok(Map.of("details", details.getData(), "approvals", approvals.getData()));
    }

    @PostMapping("/verification")
    public ResponseEntity<?> createVerification(
            @Valid @RequestBody VerificationExchange verification,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (checks.hasErrors(bindingResult)) return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");
        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, verification.getEventStationId())) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to submit verifications for this station.");
        }
        verification.setEventAdminId(profile.getProfileId());
        Result<Boolean> result = assetRepository.createVerification(verification);
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/issuance/{id}")
    public ResponseEntity<?> getIssuance(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<Map<String, Object>> details = assetRepository.getIssuanceDetails(id);
        if (!details.isOk()) return ResponseEntity.badRequest().body(details.getMessage());
        Result<List<Map<String, Object>>> list = assetRepository.getIssuanceAssets(id);
        if (!list.isOk()) return ResponseEntity.badRequest().body(list.getMessage());
        int eventRegisterId = ((Number) details.getData().get("event_register_id")).intValue();
        Result<List<Map<String, Object>>> approvals = approvalsRepository.getEventApprovals(eventRegisterId);
        if (!approvals.isOk()) return ResponseEntity.badRequest().body(approvals.getMessage());
        return ResponseEntity.ok(Map.of("details", details.getData(), "list", list.getData(), "approvals", approvals.getData()));
    }

    @PostMapping("/issuance")
    public ResponseEntity<?> createIssuance(
            @Valid @RequestBody IssuanceExchange issuance,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (checks.hasErrors(bindingResult)) return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");
        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, issuance.getEventStationId())) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to issue assets from this station.");
        }
        issuance.setEventAdminId(profile.getProfileId());
        Result<Boolean> result = assetRepository.createIssuance(issuance);
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/transfer/{id}")
    public ResponseEntity<?> getTransfer(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) return ResponseEntity.status(401).body("Unauthorized");
        Result<Map<String, Object>> details = assetRepository.getTransferDetails(id);
        if (!details.isOk()) return ResponseEntity.badRequest().body(details.getMessage());
        Result<List<Map<String, Object>>> list = assetRepository.getTransferAssets(id);
        if (!list.isOk()) return ResponseEntity.badRequest().body(list.getMessage());
        int eventRegisterId = ((Number) details.getData().get("event_register_id")).intValue();
        Result<List<Map<String, Object>>> approvals = approvalsRepository.getEventApprovals(eventRegisterId);
        if (!approvals.isOk()) return ResponseEntity.badRequest().body(approvals.getMessage());
        return ResponseEntity.ok(Map.of("details", details.getData(), "list", list.getData(), "approvals", approvals.getData()));
    }

    @PostMapping("/transfer")
    public ResponseEntity<?> createTransfer(
            @Valid @RequestBody TransferExchange transfer,
            BindingResult bindingResult,
            HttpSession session
    ) {
        if (checks.hasErrors(bindingResult)) {
            return ResponseEntity.badRequest().body(checks.getBindingErrors(bindingResult));
        }

        ProfileExchange profile = checks.getProfile(session);
        if (profile == null) return ResponseEntity.status(401).body("Unauthorized");

        if (!profile.hasRole(ASSET_ADMIN_ROLE_TYPE_ID, transfer.getEventStationId())) {
            session.invalidate();
            return ResponseEntity.status(403).body("You are not authorized to transfer assets from this station.");
        }

        transfer.setEventAdminId(profile.getProfileId());

        Result<Boolean> result = assetRepository.createTransfer(transfer);
        if (!result.isOk()) return ResponseEntity.badRequest().body(result.getMessage());

        return ResponseEntity.ok().build();
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
