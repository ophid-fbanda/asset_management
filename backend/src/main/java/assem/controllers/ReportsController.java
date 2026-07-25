package assem.controllers;

import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.exchange.profiles.ProfileRole;
import assem.repository.ReportsRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reports")
public class ReportsController {

    private static final int GENERAL_USER_ROLE_TYPE_ID = 10;
    private static final int ASSETS_ADMIN_ROLE_TYPE_ID = 20;
    private static final int SUPERVISOR_ROLE_TYPE_ID = 40;
    private static final int MANAGER_ROLE_TYPE_ID = 50;

    @Autowired
    private ReportsRepository reportsRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    @GetMapping("/current/{reportId}")
    public ResponseEntity<?> current(
            @PathVariable String reportId,
            @RequestParam(defaultValue = "true") boolean cascade,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        if (!reportsRepository.isKnownCurrent(reportId)) {
            return ResponseEntity.badRequest().body("Unknown report.");
        }

        ProfileExchange profile = checks.getProfile(session);
        Result<List<Map<String, Object>>> result = runByRole(
                profile,
                cascade,
                () -> reportsRepository.runCurrentPersonal(reportId, profile.getProfileId()),
                () -> reportsRepository.runCurrentGlobal(reportId),
                (stationIds, useCascade) ->
                        reportsRepository.runCurrentStationScoped(reportId, stationIds, useCascade)
        );
        if (result == null) {
            return ResponseEntity.status(403).body("No role available to run this report.");
        }
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/periodic/{reportId}")
    public ResponseEntity<?> periodic(
            @PathVariable String reportId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
            @RequestParam(defaultValue = "true") boolean cascade,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        if (!reportsRepository.isKnownPeriodic(reportId)) {
            return ResponseEntity.badRequest().body("Unknown report.");
        }

        ProfileExchange profile = checks.getProfile(session);
        Result<List<Map<String, Object>>> result = runByRole(
                profile,
                cascade,
                () -> reportsRepository.runPeriodicPersonal(reportId, profile.getProfileId(), from, to),
                () -> reportsRepository.runPeriodicGlobal(reportId, from, to),
                (stationIds, useCascade) ->
                        reportsRepository.runPeriodicStationScoped(reportId, stationIds, useCascade, from, to)
        );
        if (result == null) {
            return ResponseEntity.status(403).body("No role available to run this report.");
        }
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/profile/options/assets")
    public ResponseEntity<?> profileAssetOptions(HttpSession session) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }

        ProfileExchange profile = checks.getProfile(session);
        boolean privileged = profile.hasRole(ASSETS_ADMIN_ROLE_TYPE_ID)
                || profile.hasRole(SUPERVISOR_ROLE_TYPE_ID)
                || profile.hasRole(MANAGER_ROLE_TYPE_ID);

        if (!privileged && !profile.hasRole(GENERAL_USER_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("No role available to run this report.");
        }

        List<Integer> stationIds = null;
        if (privileged && !profile.hasRole(MANAGER_ROLE_TYPE_ID)) {
            stationIds = profile.getRoles().stream()
                    .filter(role -> role.getRoleTypeId() == ASSETS_ADMIN_ROLE_TYPE_ID
                            || role.getRoleTypeId() == SUPERVISOR_ROLE_TYPE_ID)
                    .map(ProfileRole::getStationId)
                    .distinct()
                    .toList();
        }

        Result<List<Map<String, Object>>> result = reportsRepository.profileAssetOptions(
                profile.getProfileId(),
                privileged,
                stationIds
        );
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/profile/asset/{assetId}")
    public ResponseEntity<?> profileAsset(
            @PathVariable int assetId,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }

        ProfileExchange profile = checks.getProfile(session);
        boolean privileged = profile.hasRole(ASSETS_ADMIN_ROLE_TYPE_ID)
                || profile.hasRole(SUPERVISOR_ROLE_TYPE_ID)
                || profile.hasRole(MANAGER_ROLE_TYPE_ID);

        if (!privileged && !profile.hasRole(GENERAL_USER_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("No role available to run this report.");
        }

        Result<Map<String, Object>> result = reportsRepository.assetProfileJourneyById(
                assetId,
                profile.getProfileId(),
                privileged
        );
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/profile/staff/{staffId}")
    public ResponseEntity<?> profileStaff(
            @PathVariable int staffId,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }

        ProfileExchange profile = checks.getProfile(session);
        boolean privileged = profile.hasRole(ASSETS_ADMIN_ROLE_TYPE_ID)
                || profile.hasRole(SUPERVISOR_ROLE_TYPE_ID)
                || profile.hasRole(MANAGER_ROLE_TYPE_ID);

        if (!privileged && !profile.hasRole(GENERAL_USER_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("No role available to run this report.");
        }
        if (!privileged && profile.getProfileId() != staffId) {
            return ResponseEntity.status(403).body("You can only view your own assets.");
        }

        Result<Map<String, Object>> result = reportsRepository.staffCurrentAssets(staffId);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/profile/station/{stationId}")
    public ResponseEntity<?> profileStation(
            @PathVariable int stationId,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }

        ProfileExchange profile = checks.getProfile(session);
        boolean privileged = profile.hasRole(ASSETS_ADMIN_ROLE_TYPE_ID)
                || profile.hasRole(SUPERVISOR_ROLE_TYPE_ID)
                || profile.hasRole(MANAGER_ROLE_TYPE_ID);

        // Station profiles are for assets admin / supervisor / manager only.
        if (!privileged) {
            return ResponseEntity.status(403).body("Station profile reports require an administrative role.");
        }

        if (!profile.hasRole(MANAGER_ROLE_TYPE_ID)) {
            List<Integer> scopeIds = profile.getRoles().stream()
                    .filter(role -> role.getRoleTypeId() == ASSETS_ADMIN_ROLE_TYPE_ID
                            || role.getRoleTypeId() == SUPERVISOR_ROLE_TYPE_ID)
                    .map(ProfileRole::getStationId)
                    .distinct()
                    .toList();
            if (!reportsRepository.stationUnderScopes(stationId, scopeIds)) {
                return ResponseEntity.status(403).body("Station is outside your scope.");
            }
        }

        Result<Map<String, Object>> result = reportsRepository.stationCurrentAssets(stationId);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    // 50 global > 20/40 station > 10 personal.
    private Result<List<Map<String, Object>>> runByRole(
            ProfileExchange profile,
            boolean cascade,
            java.util.function.Supplier<Result<List<Map<String, Object>>>> personal,
            java.util.function.Supplier<Result<List<Map<String, Object>>>> global,
            java.util.function.BiFunction<List<Integer>, Boolean, Result<List<Map<String, Object>>>> station
    ) {
        if (profile.hasRole(MANAGER_ROLE_TYPE_ID)) {
            return global.get();
        }
        if (profile.hasRole(ASSETS_ADMIN_ROLE_TYPE_ID) || profile.hasRole(SUPERVISOR_ROLE_TYPE_ID)) {
            List<Integer> stationIds = profile.getRoles().stream()
                    .filter(role -> role.getRoleTypeId() == ASSETS_ADMIN_ROLE_TYPE_ID
                            || role.getRoleTypeId() == SUPERVISOR_ROLE_TYPE_ID)
                    .map(ProfileRole::getStationId)
                    .distinct()
                    .toList();
            if (stationIds.isEmpty()) {
                return Result.error("No station scope for this report.");
            }
            return station.apply(stationIds, cascade);
        }
        if (profile.hasRole(GENERAL_USER_ROLE_TYPE_ID)) {
            return personal.get();
        }
        return null;
    }
}
