package assem.repository;

import assem.exchange.commons.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Repository
public class AuditRepository {

    public static final class AuditDef {
        public final String key;
        public final String label;
        public final String description;

        AuditDef(String key, String label, String description) {
            this.key = key;
            this.label = label;
            this.description = description;
        }

        Map<String, Object> asMap() {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("key", key);
            map.put("label", label);
            map.put("description", description);
            return map;
        }
    }

    private static final List<AuditDef> CATALOG = List.of(
            new AuditDef(
                    "delays",
                    "Delays",
                    "Open processes stuck more than 1 day without a state change (including awaiting acceptance)."
            ),
            new AuditDef(
                    "verifications",
                    "Verifications",
                    "Active assets aged 6+ months never verified, or last verified more than 6 months ago."
            ),
            new AuditDef(
                    "completeness",
                    "Completeness",
                    "Active assets missing an asset number."
            ),
            new AuditDef(
                    "placements",
                    "Placements",
                    "Active assets with no approved placement (location unconfirmed), or non-Office placements older than 3 months."
            ),
            new AuditDef(
                    "custody",
                    "Custody",
                    "Custodians who own assets whose current station is not their home station."
            ),
            new AuditDef(
                    "utilization",
                    "Utilization",
                    "Assets still New more than 3 months after arriving at the current station."
            ),
            new AuditDef(
                    "damages",
                    "Damages",
                    "Damaged assets still at level-4 stations more than 7 days after being marked damaged."
            )
    );

    private static final Set<String> KEYS = Set.of(
            "delays", "verifications", "completeness", "placements", "custody", "utilization", "damages"
    );

    // System Automation (profile 3) — bulk-held assets are not findings until issued.
    private static final String EXEMPT_SYSTEM_CUSTODY = " AND assets_view.custodian_id <> 3 ";

    // Auditor scope: always station_code LIKE prefix — never level exact-match.
    private static final String ASSET_SCOPE = """
            JOIN stations ON stations.id = assets_view.station_id
            JOIN stations scope ON scope.id = :stationId
              AND stations.station_code LIKE scope.station_code || '%'
            """;

    private static final String EVENT_SCOPE = """
            JOIN stations ON stations.id = events_view.station_id
            JOIN stations scope ON scope.id = :stationId
              AND stations.station_code LIKE scope.station_code || '%'
            """;

    @Autowired
    private BaseRepo base;

    public List<Map<String, Object>> catalog() {
        return CATALOG.stream().map(AuditDef::asMap).toList();
    }

    public boolean isKnown(String key) {
        return KEYS.contains(key);
    }

    public Result<List<Map<String, Object>>> run(String key, int stationId) {
        return switch (key) {
            case "delays" -> delays(stationId);
            case "verifications" -> verifications(stationId);
            case "completeness" -> completeness(stationId);
            case "placements" -> placements(stationId);
            case "custody" -> custody(stationId);
            case "utilization" -> utilization(stationId);
            case "damages" -> damages(stationId);
            default -> Result.error("Unknown audit.");
        };
    }

    // Open events whose current state is older than 1 day (accountability gap starts immediately).
    private Result<List<Map<String, Object>>> delays(int stationId) {
        return base.fetch("""
                SELECT events_view.event_type,
                       events_view.entity_id,
                       events_view.event_id,
                       events_view.station_name,
                       events_view.admin_name,
                       events_view.details,
                       COALESCE(latest.approval_name, 'Pending') AS current_state,
                       to_char(events_view.stamp, 'DD/MM/YYYY') AS created_date,
                       to_char(COALESCE(latest.approval_stamp, events_view.stamp), 'DD/MM/YYYY') AS state_since,
                       (CURRENT_DATE - COALESCE(latest.approval_stamp, events_view.stamp)::date) AS days_stuck
                FROM events_view
                """ + EVENT_SCOPE + """
                LEFT JOIN LATERAL (
                    SELECT t2.name AS approval_name,
                           t1.approval_type_id,
                           t1.stamp AS approval_stamp
                    FROM event_approvals t1
                    JOIN approval_types t2 ON t2.id = t1.approval_type_id
                    WHERE t1.event_register_id = events_view.event_id
                    ORDER BY t1.stamp DESC
                    LIMIT 1
                ) AS latest ON TRUE
                WHERE (
                        latest.approval_type_id IS NULL
                        OR latest.approval_type_id = 40
                        OR (
                            latest.approval_type_id = 50
                            AND events_view.event_type IN ('Transfer', 'Issuance')
                        )
                      )
                  AND (CURRENT_DATE - COALESCE(latest.approval_stamp, events_view.stamp)::date) > 1
                ORDER BY days_stuck DESC, events_view.stamp
                """, Map.of("stationId", stationId));
    }

    private Result<List<Map<String, Object>>> verifications(int stationId) {
        return base.fetch("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.station_name,
                       assets_view.custodian,
                       to_char(asset_registrations.stamp, 'DD/MM/YYYY') AS registered_date,
                       CASE
                           WHEN latest_verification.stamp IS NULL THEN 'Never verified'
                           ELSE to_char(latest_verification.stamp, 'DD/MM/YYYY')
                       END AS last_verified,
                       CASE
                           WHEN latest_verification.stamp IS NULL
                               THEN (CURRENT_DATE - asset_registrations.stamp::date)
                           ELSE (CURRENT_DATE - latest_verification.stamp::date)
                       END AS days_since_verification
                FROM assets_view
                """ + ASSET_SCOPE + """
                JOIN registered_assets ON registered_assets.id = assets_view.asset_id
                JOIN asset_registrations ON asset_registrations.id = registered_assets.asset_registration_id
                LEFT JOIN LATERAL (
                    SELECT t1.stamp
                    FROM asset_verifications t1
                    JOIN event_approvals t2
                      ON t2.event_register_id = t1.event_register_id
                     AND t2.approval_type_id = 50
                    WHERE t1.registered_asset_id = assets_view.asset_id
                    ORDER BY t1.stamp DESC
                    LIMIT 1
                ) AS latest_verification ON TRUE
                WHERE assets_view.disposed = false
                """ + EXEMPT_SYSTEM_CUSTODY + """
                  AND asset_registrations.stamp <= (CURRENT_TIMESTAMP - INTERVAL '6 months')
                  AND (
                        latest_verification.stamp IS NULL
                        OR latest_verification.stamp <= (CURRENT_TIMESTAMP - INTERVAL '6 months')
                      )
                ORDER BY days_since_verification DESC, assets_view.asset_type
                """, Map.of("stationId", stationId));
    }

    private Result<List<Map<String, Object>>> completeness(int stationId) {
        return base.fetch("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.station_name,
                       assets_view.custodian,
                       'Missing asset number' AS issue
                FROM assets_view
                """ + ASSET_SCOPE + """
                WHERE assets_view.disposed = false
                """ + EXEMPT_SYSTEM_CUSTODY + """
                  AND (
                        assets_view.asset_number IS NULL
                        OR btrim(assets_view.asset_number) = ''
                      )
                ORDER BY assets_view.station_name, assets_view.asset_type
                """, Map.of("stationId", stationId));
    }

    // Placement confirms where the asset is for audit visits.
    // No approved placement = location unconfirmed (auditor may waste a trip to office).
    // Permanent / base placement = Office (id 1); non-Office older than 90 days is also a finding.
    private Result<List<Map<String, Object>>> placements(int stationId) {
        return base.fetch("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.station_name,
                       assets_view.custodian,
                       CASE
                           WHEN placement.stamp IS NULL THEN 'Placement not known'
                           ELSE 'Placement not updated'
                       END AS issue,
                       COALESCE(placement.placement_type, '') AS placement_type,
                       CASE
                           WHEN placement.stamp IS NULL THEN ''
                           ELSE to_char(placement.stamp, 'DD/MM/YYYY')
                       END AS placement_date,
                       CASE
                           WHEN placement.stamp IS NULL
                               THEN (CURRENT_DATE - asset_registrations.stamp::date)
                           ELSE (CURRENT_DATE - placement.stamp::date)
                       END AS days_in_placement
                FROM assets_view
                """ + ASSET_SCOPE + """
                JOIN registered_assets ON registered_assets.id = assets_view.asset_id
                JOIN asset_registrations ON asset_registrations.id = registered_assets.asset_registration_id
                LEFT JOIN LATERAL (
                    SELECT t3.name AS placement_type,
                           t1.placement_type_id,
                           t1.stamp
                    FROM asset_placements t1
                    JOIN event_approvals t2
                      ON t2.event_register_id = t1.event_register_id
                     AND t2.approval_type_id = 50
                    JOIN placement_types t3 ON t3.id = t1.placement_type_id
                    WHERE t1.registered_asset_id = assets_view.asset_id
                    ORDER BY t1.stamp DESC
                    LIMIT 1
                ) AS placement ON TRUE
                WHERE assets_view.disposed = false
                """ + EXEMPT_SYSTEM_CUSTODY + """
                  AND (
                        placement.stamp IS NULL
                        OR (
                            placement.placement_type_id <> 1
                            AND (CURRENT_DATE - placement.stamp::date) > 90
                          )
                      )
                ORDER BY days_in_placement DESC, assets_view.station_name
                """, Map.of("stationId", stationId));
    }

    private Result<List<Map<String, Object>>> custody(int stationId) {
        return base.fetch("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.custodian,
                       home_station.station_name AS home_station,
                       assets_view.station_name AS asset_station
                FROM assets_view
                """ + ASSET_SCOPE + """
                JOIN staff_roles
                  ON staff_roles.staff_profile_id = assets_view.custodian_id
                 AND staff_roles.role_type_id = 10
                JOIN stations AS home_station ON home_station.id = staff_roles.role_station_id
                WHERE assets_view.disposed = false
                """ + EXEMPT_SYSTEM_CUSTODY + """
                  AND assets_view.custodian_id IS NOT NULL
                  AND assets_view.station_id <> staff_roles.role_station_id
                ORDER BY assets_view.custodian, assets_view.station_name
                """, Map.of("stationId", stationId));
    }

    private Result<List<Map<String, Object>>> utilization(int stationId) {
        return base.fetch("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.station_name,
                       assets_view.custodian,
                       to_char(COALESCE(arrival.stamp, asset_registrations.stamp), 'DD/MM/YYYY') AS arrived_date,
                       (CURRENT_DATE - COALESCE(arrival.stamp, asset_registrations.stamp)::date) AS days_as_new
                FROM assets_view
                """ + ASSET_SCOPE + """
                JOIN registered_assets ON registered_assets.id = assets_view.asset_id
                JOIN asset_registrations ON asset_registrations.id = registered_assets.asset_registration_id
                LEFT JOIN LATERAL (
                    SELECT t1.stamp
                    FROM asset_transfer_items t2
                    JOIN asset_transfers t1 ON t1.id = t2.asset_transfer_id
                    JOIN event_approvals t3
                      ON t3.event_register_id = t1.event_register_id
                     AND t3.approval_type_id = 10
                    WHERE t2.registered_asset_id = assets_view.asset_id
                    ORDER BY t1.stamp DESC
                    LIMIT 1
                ) AS arrival ON TRUE
                WHERE assets_view.disposed = false
                """ + EXEMPT_SYSTEM_CUSTODY + """
                  AND lower(assets_view.condition) = 'new'
                  AND (CURRENT_DATE - COALESCE(arrival.stamp, asset_registrations.stamp)::date) > 90
                ORDER BY days_as_new DESC, assets_view.station_name
                """, Map.of("stationId", stationId));
    }

    private Result<List<Map<String, Object>>> damages(int stationId) {
        return base.fetch("""
                SELECT assets_view.asset_id AS entity_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.station_name,
                       assets_view.custodian,
                       stations.level AS station_level,
                       to_char(
                           COALESCE(damaged_at.stamp, asset_registrations.stamp),
                           'DD/MM/YYYY'
                       ) AS damaged_since,
                       (CURRENT_DATE - COALESCE(damaged_at.stamp, asset_registrations.stamp)::date) AS days_damaged
                FROM assets_view
                """ + ASSET_SCOPE + """
                JOIN registered_assets ON registered_assets.id = assets_view.asset_id
                JOIN asset_registrations ON asset_registrations.id = registered_assets.asset_registration_id
                LEFT JOIN LATERAL (
                    SELECT t1.stamp
                    FROM asset_verifications t1
                    JOIN event_approvals t2
                      ON t2.event_register_id = t1.event_register_id
                     AND t2.approval_type_id = 50
                    JOIN condition_types t3
                      ON t3.id = t1.verified_condition_type_id
                     AND lower(t3.name) = 'damaged'
                    WHERE t1.registered_asset_id = assets_view.asset_id
                    ORDER BY t1.stamp DESC
                    LIMIT 1
                ) AS damaged_at ON TRUE
                WHERE assets_view.disposed = false
                """ + EXEMPT_SYSTEM_CUSTODY + """
                  AND lower(assets_view.condition) = 'damaged'
                  AND stations.level = 4
                  AND (CURRENT_DATE - COALESCE(damaged_at.stamp, asset_registrations.stamp)::date) > 7
                ORDER BY days_damaged DESC, assets_view.station_name
                """, Map.of("stationId", stationId));
    }
}
