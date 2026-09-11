package assem.repository;

import assem.exchange.commons.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Repository
public class ReportsRepository {

    // One report id each; scope (personal / station / global) is chosen from the caller's roles.
    private static final Map<String, String> CURRENT_REPORTS = new LinkedHashMap<>();

    static {
        CURRENT_REPORTS.put("assets", null);
        CURRENT_REPORTS.put("new-assets", "new");
        CURRENT_REPORTS.put("good-assets", "good");
        CURRENT_REPORTS.put("fair-assets", "fair");
        CURRENT_REPORTS.put("poor-assets", "poor");
        CURRENT_REPORTS.put("damaged-assets", "damaged");
    }

    private static final Set<String> PERIODIC_REPORTS = Set.of(
            "procured",
            "incidents",
            "damaged",
            "disposed",
            "auctioned"
    );

    @Autowired
    private BaseRepo base;

    public boolean isKnownCurrent(String reportId) {
        return CURRENT_REPORTS.containsKey(reportId);
    }

    public boolean isKnownPeriodic(String reportId) {
        return PERIODIC_REPORTS.contains(reportId);
    }

    public Result<List<Map<String, Object>>> runCurrentPersonal(String reportId, int profileId) {
        if (!isKnownCurrent(reportId)) {
            return Result.error("Unknown report.");
        }
        return fetchAssets(personalScope(CURRENT_REPORTS.get(reportId)), Map.of("profileId", profileId));
    }

    public Result<List<Map<String, Object>>> runCurrentGlobal(String reportId) {
        if (!isKnownCurrent(reportId)) {
            return Result.error("Unknown report.");
        }
        return fetchAssets(globalScope(CURRENT_REPORTS.get(reportId)), Map.of());
    }

    public Result<List<Map<String, Object>>> runCurrentStationScoped(
            String reportId,
            List<Integer> stationIds,
            boolean cascade
    ) {
        if (!isKnownCurrent(reportId)) {
            return Result.error("Unknown report.");
        }
        if (stationIds == null || stationIds.isEmpty()) {
            return Result.error("No stations in scope.");
        }
        return fetchAssets(
                stationScope(CURRENT_REPORTS.get(reportId), cascade),
                Map.of("stationIds", stationIds)
        );
    }

    public Result<List<Map<String, Object>>> runPeriodicPersonal(
            String reportId,
            int profileId,
            LocalDate from,
            LocalDate to
    ) {
        return runPeriodic(reportId, "personal", profileId, null, false, from, to);
    }

    public Result<List<Map<String, Object>>> runPeriodicGlobal(
            String reportId,
            LocalDate from,
            LocalDate to
    ) {
        return runPeriodic(reportId, "global", 0, null, false, from, to);
    }

    public Result<List<Map<String, Object>>> runPeriodicStationScoped(
            String reportId,
            List<Integer> stationIds,
            boolean cascade,
            LocalDate from,
            LocalDate to
    ) {
        if (stationIds == null || stationIds.isEmpty()) {
            return Result.error("No stations in scope.");
        }
        return runPeriodic(reportId, "station", 0, stationIds, cascade, from, to);
    }

    private Result<List<Map<String, Object>>> runPeriodic(
            String reportId,
            String mode,
            int profileId,
            List<Integer> stationIds,
            boolean cascade,
            LocalDate from,
            LocalDate to
    ) {
        if (!isKnownPeriodic(reportId)) {
            return Result.error("Unknown report.");
        }
        if (from == null || to == null) {
            return Result.error("Period from and to are required.");
        }
        if (to.isBefore(from)) {
            return Result.error("Period to must be on or after from.");
        }

        Map<String, Object> params = new HashMap<>();
        params.put("from", Date.valueOf(from));
        params.put("to", Date.valueOf(to));
        if ("personal".equals(mode)) {
            params.put("profileId", profileId);
        }
        if ("station".equals(mode)) {
            params.put("stationIds", stationIds);
        }

        return switch (reportId) {
            case "procured" -> base.fetch(procuredSql(mode, cascade), params);
            case "incidents" -> base.fetch(incidentsSql(mode, cascade), params);
            case "damaged" -> base.fetch(damagedSql(mode, cascade), params);
            case "disposed" -> base.fetch(disposalsSql(mode, cascade, false), params);
            case "auctioned" -> base.fetch(disposalsSql(mode, cascade, true), params);
            default -> Result.error("Unknown report.");
        };
    }

    // Filter registrations by period first — do not drive from assets_view (laterals on every asset).
    private String procuredSql(String mode, boolean cascade) {
        return """
                SELECT registered_assets.id AS entity_id,
                       asset_types.name AS asset_type,
                       brand_types.name AS brand,
                       model_types.name AS model,
                       registered_assets.asset_number,
                       registered_assets.serial_number,
                       condition_types.name AS condition,
                       registered_assets.acquisition_value AS current_value,
                       COALESCE(latest_custodian.full_name, reg_admin.full_name) AS custodian,
                       reg_station.station_name AS procured_station,
                       COALESCE(latest_location.station_name, reg_station.station_name) AS current_station,
                       to_char(asset_registrations.reference_date, 'DD/MM/YYYY') AS procured_date
                FROM registered_assets
                JOIN asset_registrations
                  ON asset_registrations.id = registered_assets.asset_registration_id
                JOIN event_approvals reg_approval
                  ON reg_approval.event_register_id = asset_registrations.event_register_id
                 AND reg_approval.approval_type_id = 50
                JOIN stations AS reg_station ON reg_station.id = asset_registrations.event_station_id
                JOIN staff_profiles AS reg_admin ON reg_admin.id = asset_registrations.event_admin_id
                JOIN condition_types ON condition_types.id = registered_assets.condition_type_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN model_types ON model_types.id = asset_models.model_type_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN brand_types ON brand_types.id = asset_brands.brand_type_id
                JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                LEFT JOIN LATERAL (
                    SELECT staff_profiles.id AS staff_id,
                           staff_profiles.full_name
                    FROM asset_issuance_items
                    JOIN asset_issuances ON asset_issuances.id = asset_issuance_items.asset_issuance_id
                    JOIN event_approvals
                      ON event_approvals.event_register_id = asset_issuances.event_register_id
                     AND event_approvals.approval_type_id = 10
                    JOIN staff_profiles ON staff_profiles.id = asset_issuances.receiving_staff_id
                    WHERE asset_issuance_items.registered_asset_id = registered_assets.id
                    ORDER BY asset_issuances.stamp DESC
                    LIMIT 1
                ) latest_custodian ON TRUE
                LEFT JOIN LATERAL (
                    SELECT stations.station_name
                    FROM asset_transfer_items
                    JOIN asset_transfers ON asset_transfers.id = asset_transfer_items.asset_transfer_id
                    JOIN event_approvals
                      ON event_approvals.event_register_id = asset_transfers.event_register_id
                     AND event_approvals.approval_type_id = 10
                    JOIN stations ON stations.id = asset_transfers.receiving_station_id
                    WHERE asset_transfer_items.registered_asset_id = registered_assets.id
                    ORDER BY asset_transfers.stamp DESC
                    LIMIT 1
                ) latest_location ON TRUE
                WHERE asset_registrations.reference_date BETWEEN :from AND :to
                  AND NOT EXISTS (
                      SELECT 1
                      FROM asset_disposals
                      JOIN event_approvals
                        ON event_approvals.event_register_id = asset_disposals.event_register_id
                       AND event_approvals.approval_type_id = 50
                      WHERE asset_disposals.registered_asset_id = registered_assets.id
                  )
                """
                + ("personal".equals(mode)
                    ? " AND COALESCE(latest_custodian.staff_id, asset_registrations.event_admin_id) = :profileId\n"
                    : "")
                + stationFilter(mode, "asset_registrations.event_station_id", cascade)
                + """
                ORDER BY asset_registrations.reference_date DESC, asset_types.name
                """;
    }

    private String incidentsSql(String mode, boolean cascade) {
        return """
                SELECT asset_incidents.id AS entity_id,
                       asset_incidents.event_register_id AS event_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       incident_types.name AS incident_type,
                       stations.station_name,
                       staff_profiles.full_name AS reported_by,
                       assets_view.custodian,
                       to_char(asset_incidents.stamp, 'DD/MM/YYYY') AS reported_date
                FROM asset_incidents
                JOIN incident_types ON incident_types.id = asset_incidents.incident_type_id
                JOIN stations ON stations.id = asset_incidents.event_station_id
                JOIN staff_profiles ON staff_profiles.id = asset_incidents.event_admin_id
                JOIN assets_view ON assets_view.asset_id = asset_incidents.registered_asset_id
                WHERE asset_incidents.stamp::date BETWEEN :from AND :to
                """
                + ("personal".equals(mode)
                    ? " AND (asset_incidents.event_admin_id = :profileId OR assets_view.custodian_id = :profileId)\n"
                    : "")
                + stationFilter(mode, "asset_incidents.event_station_id", cascade)
                + """
                ORDER BY asset_incidents.stamp DESC
                """;
    }

    private String damagedSql(String mode, boolean cascade) {
        return """
                SELECT asset_verifications.id AS entity_id,
                       asset_verifications.event_register_id AS event_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition AS current_condition,
                       condition_types.name AS verified_condition,
                       stations.station_name,
                       staff_profiles.full_name AS verified_by,
                       assets_view.custodian,
                       to_char(asset_verifications.stamp, 'DD/MM/YYYY') AS damaged_date
                FROM asset_verifications
                JOIN condition_types ON condition_types.id = asset_verifications.verified_condition_type_id
                JOIN event_approvals
                  ON event_approvals.event_register_id = asset_verifications.event_register_id
                 AND event_approvals.approval_type_id = 50
                JOIN stations ON stations.id = asset_verifications.event_station_id
                JOIN staff_profiles ON staff_profiles.id = asset_verifications.event_admin_id
                JOIN assets_view ON assets_view.asset_id = asset_verifications.registered_asset_id
                WHERE lower(condition_types.name) = 'damaged'
                  AND asset_verifications.stamp::date BETWEEN :from AND :to
                """
                + personalCustodian(mode)
                + stationFilter(mode, "asset_verifications.event_station_id", cascade)
                + """
                ORDER BY asset_verifications.stamp DESC
                """;
    }

    private String disposalsSql(String mode, boolean cascade, boolean auctionOnly) {
        return """
                SELECT asset_disposals.id AS entity_id,
                       asset_disposals.event_register_id AS event_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       disposal_types.name AS disposal_type,
                       stations.station_name,
                       staff_profiles.full_name AS disposed_by,
                       to_char(asset_disposals.stamp, 'DD/MM/YYYY') AS disposed_date
                FROM asset_disposals
                JOIN disposal_types ON disposal_types.id = asset_disposals.disposal_type_id
                JOIN event_approvals
                  ON event_approvals.event_register_id = asset_disposals.event_register_id
                 AND event_approvals.approval_type_id = 50
                JOIN stations ON stations.id = asset_disposals.event_station_id
                JOIN staff_profiles ON staff_profiles.id = asset_disposals.event_admin_id
                JOIN assets_view ON assets_view.asset_id = asset_disposals.registered_asset_id
                WHERE asset_disposals.stamp::date BETWEEN :from AND :to
                """
                + (auctionOnly ? " AND lower(disposal_types.name) = 'auction'\n" : "")
                + ("personal".equals(mode) ? " AND asset_disposals.event_admin_id = :profileId\n" : "")
                + stationFilter(mode, "asset_disposals.event_station_id", cascade)
                + """
                ORDER BY asset_disposals.stamp DESC
                """;
    }

    private String personalCustodian(String mode) {
        if (!"personal".equals(mode)) return "";
        return " AND assets_view.custodian_id = :profileId\n";
    }

    private String stationFilter(String mode, String stationIdExpr, boolean cascade) {
        if (!"station".equals(mode)) return "";
        String match = cascade
                ? "event_station.station_code LIKE scope.station_code || '%'"
                : "event_station.id = scope.id";
        return """
                  AND EXISTS (
                      SELECT 1
                      FROM stations event_station
                      JOIN stations scope ON scope.id IN (:stationIds)
                      WHERE event_station.id = """ + stationIdExpr + """
                        AND """ + match + """
                  )
                """;
    }

    private String personalScope(String condition) {
        String sql = """
                FROM assets_view
                WHERE assets_view.disposed = false
                  AND assets_view.custodian_id = :profileId
                """;
        return withCondition(sql, condition);
    }

    private String globalScope(String condition) {
        String sql = """
                FROM assets_view
                WHERE assets_view.disposed = false
                """;
        return withCondition(sql, condition);
    }

    private String stationScope(String condition, boolean cascade) {
        String match = cascade
                ? "stations.station_code LIKE scope.station_code || '%'"
                : "stations.id = scope.id";
        String sql = """
                FROM assets_view
                JOIN stations ON stations.id = assets_view.station_id
                WHERE assets_view.disposed = false
                  AND EXISTS (
                      SELECT 1
                      FROM stations scope
                      WHERE scope.id IN (:stationIds)
                        AND """ + match + """
                  )
                """;
        return withCondition(sql, condition);
    }

    private String withCondition(String sql, String condition) {
        if (condition == null) return sql;
        return sql + " AND lower(assets_view.condition) = '" + condition + "'\n";
    }

    private Result<List<Map<String, Object>>> fetchAssets(String fromWhere, Map<String, Object> params) {
        return base.fetch("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.current_value,
                       assets_view.custodian,
                       assets_view.station_name
                """ + fromWhere + """
                ORDER BY assets_view.station_name, assets_view.asset_type, assets_view.brand, assets_view.model
                """, params);
    }

    /**
     * Asset profile journey by serial or asset number.
     * privileged=false: custodian only; no people names; registration + receipt only.
     * privileged=true: full lifecycle with actors and approvals through disposal.
     */
    // Searchable asset picker options, scoped by the caller's authority.
    public Result<List<Map<String, Object>>> profileAssetOptions(
            int profileId,
            boolean privileged,
            List<Integer> stationIds
    ) {
        if (!privileged) {
            return base.fetch("""
                    SELECT assets_view.asset_id AS id,
                           (
                             COALESCE(assets_view.asset_number, assets_view.serial_number)
                             || ' — '
                             || assets_view.asset_type
                             || ' '
                             || assets_view.brand
                             || ' '
                             || assets_view.model
                           ) AS label
                    FROM assets_view
                    WHERE assets_view.disposed = false
                      AND assets_view.custodian_id = :profileId
                    ORDER BY assets_view.asset_type, assets_view.brand, assets_view.model
                    """, Map.of("profileId", profileId));
        }
        if (stationIds != null && !stationIds.isEmpty()) {
            return base.fetch("""
                    SELECT assets_view.asset_id AS id,
                           (
                             COALESCE(assets_view.asset_number, assets_view.serial_number)
                             || ' — '
                             || assets_view.asset_type
                             || ' '
                             || assets_view.brand
                             || ' '
                             || assets_view.model
                           ) AS label
                    FROM assets_view
                    JOIN stations ON stations.id = assets_view.station_id
                    WHERE assets_view.disposed = false
                      AND EXISTS (
                          SELECT 1
                          FROM stations scope
                          WHERE scope.id IN (:stationIds)
                            AND stations.station_code LIKE scope.station_code || '%'
                      )
                    ORDER BY assets_view.asset_type, assets_view.brand, assets_view.model
                    """, Map.of("stationIds", stationIds));
        }
        return base.fetch("""
                SELECT assets_view.asset_id AS id,
                       (
                         COALESCE(assets_view.asset_number, assets_view.serial_number)
                         || ' — '
                         || assets_view.asset_type
                         || ' '
                         || assets_view.brand
                         || ' '
                         || assets_view.model
                       ) AS label
                FROM assets_view
                WHERE assets_view.disposed = false
                ORDER BY assets_view.asset_type, assets_view.brand, assets_view.model
                """, Map.of());
    }

    public Result<Map<String, Object>> assetProfileJourneyById(
            int assetId,
            int profileId,
            boolean privileged
    ) {
        Result<Map<String, Object>> assetResult = base.fetchOne("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.current_value,
                       assets_view.custodian_id,
                       assets_view.custodian,
                       assets_view.station_name,
                       assets_view.disposed
                FROM assets_view
                WHERE assets_view.asset_id = :assetId
                """, Map.of("assetId", assetId));
        if (!assetResult.isOk()) {
            return Result.error(assetResult.getMessage());
        }
        if (assetResult.getData() == null) {
            return Result.ok(emptyProfile());
        }

        Map<String, Object> asset = new LinkedHashMap<>(assetResult.getData());
        Integer custodianId = asset.get("custodian_id") == null
                ? null
                : ((Number) asset.get("custodian_id")).intValue();

        if (!privileged) {
            if (custodianId == null || custodianId != profileId) {
                return Result.ok(emptyProfile());
            }
            asset.remove("custodian_id");
            asset.put("custodian", "You");
            Result<List<Map<String, Object>>> limited = personalAssetJourney(assetId, profileId);
            if (!limited.isOk()) {
                return Result.error(limited.getMessage());
            }
            Map<String, Object> payload = new LinkedHashMap<>();
            payload.put("asset", asset);
            payload.put("journey", limited.getData());
            return Result.ok(payload);
        }

        asset.remove("custodian_id");
        Result<List<Map<String, Object>>> full = fullAssetJourney(assetId);
        if (!full.isOk()) {
            return Result.error(full.getMessage());
        }
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("asset", asset);
        payload.put("journey", full.getData());
        return Result.ok(payload);
    }

    private Map<String, Object> emptyProfile() {
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("asset", null);
        payload.put("journey", List.of());
        return payload;
    }

    private Result<List<Map<String, Object>>> personalAssetJourney(int assetId, int profileId) {
        return base.fetch("""
                SELECT step.sort_key AS entity_id,
                       step.event_type,
                       to_char(step.stamp, 'DD/MM/YYYY') AS event_date,
                       step.station_name,
                       step.details,
                       ''::text AS recorded_by,
                       ''::text AS supervisor_approved_by,
                       ''::text AS manager_approved_by,
                       ''::text AS accepted_by
                FROM (
                    SELECT 1 AS sort_key,
                           'Registration'::text AS event_type,
                           asset_registrations.stamp,
                           stations.station_name,
                           'Asset registered into the system'::text AS details
                    FROM registered_assets
                    JOIN asset_registrations ON asset_registrations.id = registered_assets.asset_registration_id
                    JOIN stations ON stations.id = asset_registrations.event_station_id
                    WHERE registered_assets.id = :assetId

                    UNION ALL

                    SELECT 2,
                           'Issuance'::text,
                           asset_issuances.stamp,
                           stations.station_name,
                           'Received into your custody'::text
                    FROM asset_issuance_items
                    JOIN asset_issuances ON asset_issuances.id = asset_issuance_items.asset_issuance_id
                    JOIN stations ON stations.id = asset_issuances.event_station_id
                    JOIN event_approvals
                      ON event_approvals.event_register_id = asset_issuances.event_register_id
                     AND event_approvals.approval_type_id = 10
                    WHERE asset_issuance_items.registered_asset_id = :assetId
                      AND asset_issuances.receiving_staff_id = :profileId
                ) AS step
                ORDER BY step.sort_key, step.stamp
                """, Map.of("assetId", assetId, "profileId", profileId));
    }

    private Result<List<Map<String, Object>>> fullAssetJourney(int assetId) {
        Result<List<Map<String, Object>>> events = base.fetch("""
                SELECT step.event_id,
                       step.event_type,
                       to_char(step.stamp, 'DD/MM/YYYY') AS event_date,
                       step.stamp,
                       step.station_name,
                       step.recorded_by,
                       step.details
                FROM (
                    SELECT asset_registrations.event_register_id AS event_id,
                           'Registration'::text AS event_type,
                           asset_registrations.stamp,
                           stations.station_name,
                           staff_profiles.full_name AS recorded_by,
                           (('Registered via ' || acquisition_types.name || ' from ' || suppliers.supplier_name)) AS details
                    FROM registered_assets
                    JOIN asset_registrations ON asset_registrations.id = registered_assets.asset_registration_id
                    JOIN stations ON stations.id = asset_registrations.event_station_id
                    JOIN staff_profiles ON staff_profiles.id = asset_registrations.event_admin_id
                    JOIN suppliers ON suppliers.id = asset_registrations.supplier_id
                    JOIN acquisition_types ON acquisition_types.id = asset_registrations.acquisition_type_id
                    WHERE registered_assets.id = :assetId
                      AND EXISTS (
                          SELECT 1 FROM event_approvals
                          WHERE event_approvals.event_register_id = asset_registrations.event_register_id
                            AND event_approvals.approval_type_id = 50
                      )

                    UNION ALL

                    SELECT asset_transfers.event_register_id,
                           'Transfer'::text,
                           asset_transfers.stamp,
                           from_station.station_name,
                           staff_profiles.full_name,
                           ('Transfer to ' || to_station.station_name)
                    FROM asset_transfer_items
                    JOIN asset_transfers ON asset_transfers.id = asset_transfer_items.asset_transfer_id
                    JOIN stations AS from_station ON from_station.id = asset_transfers.event_station_id
                    JOIN stations AS to_station ON to_station.id = asset_transfers.receiving_station_id
                    JOIN staff_profiles ON staff_profiles.id = asset_transfers.event_admin_id
                    WHERE asset_transfer_items.registered_asset_id = :assetId
                      AND EXISTS (
                          SELECT 1 FROM event_approvals
                          WHERE event_approvals.event_register_id = asset_transfers.event_register_id
                            AND event_approvals.approval_type_id = 10
                      )

                    UNION ALL

                    SELECT asset_issuances.event_register_id,
                           'Issuance'::text,
                           asset_issuances.stamp,
                           stations.station_name,
                           staff_profiles.full_name,
                           ('Issued to ' || receiving_staff.full_name)
                    FROM asset_issuance_items
                    JOIN asset_issuances ON asset_issuances.id = asset_issuance_items.asset_issuance_id
                    JOIN stations ON stations.id = asset_issuances.event_station_id
                    JOIN staff_profiles ON staff_profiles.id = asset_issuances.event_admin_id
                    JOIN staff_profiles AS receiving_staff ON receiving_staff.id = asset_issuances.receiving_staff_id
                    WHERE asset_issuance_items.registered_asset_id = :assetId
                      AND EXISTS (
                          SELECT 1 FROM event_approvals
                          WHERE event_approvals.event_register_id = asset_issuances.event_register_id
                            AND event_approvals.approval_type_id = 10
                      )

                    UNION ALL

                    SELECT asset_verifications.event_register_id,
                           'Verification'::text,
                           asset_verifications.stamp,
                           stations.station_name,
                           staff_profiles.full_name,
                           ('Condition set to ' || condition_types.name || ' via ' || verification_types.name)
                    FROM asset_verifications
                    JOIN stations ON stations.id = asset_verifications.event_station_id
                    JOIN staff_profiles ON staff_profiles.id = asset_verifications.event_admin_id
                    JOIN condition_types ON condition_types.id = asset_verifications.verified_condition_type_id
                    JOIN verification_types ON verification_types.id = asset_verifications.verification_type_id
                    WHERE asset_verifications.registered_asset_id = :assetId
                      AND EXISTS (
                          SELECT 1 FROM event_approvals
                          WHERE event_approvals.event_register_id = asset_verifications.event_register_id
                            AND event_approvals.approval_type_id = 50
                      )

                    UNION ALL

                    SELECT asset_evaluations.event_register_id,
                           'Evaluation'::text,
                           asset_evaluations.stamp,
                           stations.station_name,
                           staff_profiles.full_name,
                           ('Value set to ' || asset_evaluations.evaluated_value::text || ' (' || evaluation_types.name || ')')
                    FROM asset_evaluations
                    JOIN stations ON stations.id = asset_evaluations.event_station_id
                    JOIN staff_profiles ON staff_profiles.id = asset_evaluations.event_admin_id
                    JOIN evaluation_types ON evaluation_types.id = asset_evaluations.evaluation_type_id
                    WHERE asset_evaluations.registered_asset_id = :assetId
                      AND EXISTS (
                          SELECT 1 FROM event_approvals
                          WHERE event_approvals.event_register_id = asset_evaluations.event_register_id
                            AND event_approvals.approval_type_id = 50
                      )

                    UNION ALL

                    SELECT asset_placements.event_register_id,
                           'Placement'::text,
                           asset_placements.stamp,
                           stations.station_name,
                           staff_profiles.full_name,
                           ('Placement set to ' || placement_types.name)
                    FROM asset_placements
                    JOIN stations ON stations.id = asset_placements.event_station_id
                    JOIN staff_profiles ON staff_profiles.id = asset_placements.event_admin_id
                    JOIN placement_types ON placement_types.id = asset_placements.placement_type_id
                    WHERE asset_placements.registered_asset_id = :assetId
                      AND EXISTS (
                          SELECT 1 FROM event_approvals
                          WHERE event_approvals.event_register_id = asset_placements.event_register_id
                            AND event_approvals.approval_type_id = 50
                      )

                    UNION ALL

                    SELECT asset_incidents.event_register_id,
                           'Incident'::text,
                           asset_incidents.stamp,
                           stations.station_name,
                           staff_profiles.full_name,
                           (incident_types.name || ' reported')
                    FROM asset_incidents
                    JOIN stations ON stations.id = asset_incidents.event_station_id
                    JOIN staff_profiles ON staff_profiles.id = asset_incidents.event_admin_id
                    JOIN incident_types ON incident_types.id = asset_incidents.incident_type_id
                    WHERE asset_incidents.registered_asset_id = :assetId
                      AND EXISTS (
                          SELECT 1 FROM event_approvals
                          WHERE event_approvals.event_register_id = asset_incidents.event_register_id
                            AND event_approvals.approval_type_id = 50
                      )

                    UNION ALL

                    SELECT asset_disposals.event_register_id,
                           'Disposal'::text,
                           asset_disposals.stamp,
                           stations.station_name,
                           staff_profiles.full_name,
                           ('Disposed via ' || disposal_types.name)
                    FROM asset_disposals
                    JOIN stations ON stations.id = asset_disposals.event_station_id
                    JOIN staff_profiles ON staff_profiles.id = asset_disposals.event_admin_id
                    JOIN disposal_types ON disposal_types.id = asset_disposals.disposal_type_id
                    WHERE asset_disposals.registered_asset_id = :assetId
                      AND EXISTS (
                          SELECT 1 FROM event_approvals
                          WHERE event_approvals.event_register_id = asset_disposals.event_register_id
                            AND event_approvals.approval_type_id = 50
                      )
                ) AS step
                ORDER BY step.stamp, step.event_id
                """, Map.of("assetId", assetId));
        if (!events.isOk()) {
            return events;
        }

        List<Map<String, Object>> journey = new ArrayList<>();
        for (Map<String, Object> event : events.getData()) {
            int eventId = ((Number) event.get("event_id")).intValue();
            Result<List<Map<String, Object>>> approvals = base.fetch("""
                    SELECT event_approvals.approval_type_id,
                           staff_profiles.full_name AS approved_by
                    FROM event_approvals
                    JOIN staff_profiles ON staff_profiles.id = event_approvals.event_admin_id
                    WHERE event_approvals.event_register_id = :eventId
                      AND event_approvals.approval_type_id IN (40, 50, 10)
                    ORDER BY event_approvals.stamp
                    """, Map.of("eventId", eventId));
            if (!approvals.isOk()) {
                return Result.error(approvals.getMessage());
            }

            String supervisorBy = "";
            String managerBy = "";
            String acceptedBy = "";
            for (Map<String, Object> approval : approvals.getData()) {
                int typeId = ((Number) approval.get("approval_type_id")).intValue();
                String name = approval.get("approved_by") == null ? "" : String.valueOf(approval.get("approved_by"));
                if (typeId == 40) supervisorBy = name;
                else if (typeId == 50) managerBy = name;
                else if (typeId == 10) acceptedBy = name;
            }

            journey.add(journeyRow(event, supervisorBy, managerBy, acceptedBy));
        }
        return Result.ok(journey);
    }

    private Map<String, Object> journeyRow(
            Map<String, Object> event,
            String supervisorBy,
            String managerBy,
            String acceptedBy
    ) {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("entity_id", event.get("event_id"));
        row.put("event_type", event.get("event_type"));
        row.put("event_date", event.get("event_date"));
        row.put("station_name", event.get("station_name"));
        row.put("details", event.get("details"));
        row.put("recorded_by", event.get("recorded_by"));
        row.put("supervisor_approved_by", supervisorBy == null ? "" : supervisorBy);
        row.put("manager_approved_by", managerBy == null ? "" : managerBy);
        row.put("accepted_by", acceptedBy == null ? "" : acceptedBy);
        return row;
    }

    // Current active assets held by a staff member (custodian).
    public Result<Map<String, Object>> staffCurrentAssets(int staffId) {
        Result<Map<String, Object>> staffResult = base.fetchOne("""
                SELECT staff_profiles.id AS entity_id,
                       staff_profiles.full_name,
                       staff_profiles.staff_email,
                       staff_profiles.staff_phone
                FROM staff_profiles
                WHERE staff_profiles.id = :staffId
                """, Map.of("staffId", staffId));
        if (!staffResult.isOk()) {
            return Result.error(staffResult.getMessage());
        }
        if (staffResult.getData() == null) {
            Map<String, Object> empty = new LinkedHashMap<>();
            empty.put("staff", null);
            empty.put("assets", List.of());
            return Result.ok(empty);
        }

        Result<List<Map<String, Object>>> assets = base.fetch("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.current_value,
                       assets_view.station_name
                FROM assets_view
                WHERE assets_view.disposed = false
                  AND assets_view.custodian_id = :staffId
                ORDER BY assets_view.asset_type, assets_view.brand, assets_view.model
                """, Map.of("staffId", staffId));
        if (!assets.isOk()) {
            return Result.error(assets.getMessage());
        }

        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("staff", staffResult.getData());
        payload.put("assets", assets.getData());
        return Result.ok(payload);
    }

    public boolean stationUnderScopes(int stationId, List<Integer> scopeIds) {
        if (scopeIds == null || scopeIds.isEmpty()) return false;
        Result<Map<String, Object>> row = base.fetchOne("""
                SELECT stations.id
                FROM stations
                JOIN stations scope ON scope.id IN (:scopeIds)
                WHERE stations.id = :stationId
                  AND stations.station_code LIKE scope.station_code || '%'
                LIMIT 1
                """, Map.of("stationId", stationId, "scopeIds", scopeIds));
        return row.isOk() && row.getData() != null;
    }

    // Active assets under a station (station_code hierarchy / LIKE).
    public Result<Map<String, Object>> stationCurrentAssets(int stationId) {
        Result<Map<String, Object>> stationResult = base.fetchOne("""
                SELECT stations.id AS entity_id,
                       stations.station_name
                FROM stations
                WHERE stations.id = :stationId
                """, Map.of("stationId", stationId));
        if (!stationResult.isOk()) {
            return Result.error(stationResult.getMessage());
        }
        if (stationResult.getData() == null) {
            Map<String, Object> empty = new LinkedHashMap<>();
            empty.put("station", null);
            empty.put("assets", List.of());
            return Result.ok(empty);
        }

        Result<List<Map<String, Object>>> assets = base.fetch("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.current_value,
                       assets_view.custodian,
                       assets_view.station_name
                FROM assets_view
                JOIN stations ON stations.id = assets_view.station_id
                JOIN stations scope ON scope.id = :stationId
                  AND stations.station_code LIKE scope.station_code || '%'
                WHERE assets_view.disposed = false
                ORDER BY assets_view.station_name, assets_view.asset_type, assets_view.brand, assets_view.model
                """, Map.of("stationId", stationId));
        if (!assets.isOk()) {
            return Result.error(assets.getMessage());
        }

        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("station", stationResult.getData());
        payload.put("assets", assets.getData());
        return Result.ok(payload);
    }
}
