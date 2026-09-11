package assem.repository;

import assem.exchange.assets.Asset;
import assem.exchange.assets.DisposalExchange;
import assem.exchange.assets.EvaluationExchange;
import assem.exchange.assets.IncidentExchange;
import assem.exchange.assets.IssuanceExchange;
import assem.exchange.assets.IssuanceItemExchange;
import assem.exchange.assets.PlacementExchange;
import assem.exchange.assets.Registration;
import assem.exchange.assets.RequestExchange;
import assem.exchange.assets.RequestItemExchange;
import assem.exchange.assets.TransferExchange;
import assem.exchange.assets.TransferItemExchange;
import assem.exchange.assets.VerificationExchange;
import assem.exchange.commons.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class AssetRepository {

    @Autowired
    private BaseRepo base;

    // Registrations for a single station, shaped for the list view. The hidden
    // entity_id/event_id ride along for row actions. approval_status is the most
    // recent approval on the event, or 'Pending' when none has been recorded yet.
    public Result<List<Map<String, Object>>> getRegistrations(int station) {
        return base.fetch("""
                SELECT
                    asset_registrations.id AS entity_id,
                    asset_registrations.event_register_id AS event_id,
                    to_char(asset_registrations.stamp, 'DD/mm/YYYY') AS registration_date,
                    programs.program_name AS program,
                    acquisition_types.name AS acquisition_type,
                    reference_types.name AS reference_type,
                    suppliers.supplier_name AS supplier_name,
                    to_char(asset_registrations.event_date, 'DD/mm/YYYY') AS event_date,
                    stations.station_name AS station,
                    staff_profiles.full_name AS registered_by,
                    asset_count.total AS quantity,
                    COALESCE(latest_approval.name, 'Pending') AS status,
                    COALESCE(latest_approval.id, 0) AS status_id

                FROM asset_registrations
                JOIN programs ON programs.id = asset_registrations.program_id
                JOIN acquisition_types ON acquisition_types.id = asset_registrations.acquisition_type_id
                JOIN reference_types ON reference_types.id = asset_registrations.reference_type_id
                JOIN suppliers ON suppliers.id = asset_registrations.supplier_id
                JOIN stations ON stations.id = asset_registrations.event_station_id
                JOIN stations scope ON scope.id = :station
                  AND (
                      (scope.level IN (1, 2) AND stations.id = scope.id)
                      OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                          AND stations.station_code LIKE scope.station_code || '%')
                  )
                JOIN staff_profiles ON staff_profiles.id = asset_registrations.event_admin_id
                JOIN LATERAL (
                    SELECT COUNT(*) AS total
                    FROM registered_assets
                    WHERE registered_assets.asset_registration_id = asset_registrations.id
                ) AS asset_count ON TRUE
                LEFT JOIN LATERAL (
                    SELECT approval_types.id, approval_types.name
                    FROM event_approvals
                    JOIN approval_types ON approval_types.id = event_approvals.approval_type_id
                    WHERE event_approvals.event_register_id = asset_registrations.event_register_id
                    ORDER BY event_approvals.stamp DESC
                    LIMIT 1
                ) AS latest_approval ON TRUE
                ORDER BY asset_registrations.stamp DESC
                """, Map.of("station", station));
    }

    // Assets belonging to a single registration, shaped for the template line-item table.
    public Result<List<Map<String, Object>>> getRegistrationAssets(int registrationId) {
        return base.fetch("""
                SELECT
                    registered_assets.asset_number,
                    registered_assets.serial_number,
                    asset_types.name      AS asset_type,
                    brand_types.name      AS brand,
                    model_types.name      AS model,
                    condition_types.name  AS condition,
                    registered_assets.acquisition_value AS value
                FROM registered_assets
                JOIN asset_models  ON asset_models.id  = registered_assets.asset_model_id
                JOIN asset_brands  ON asset_brands.id  = asset_models.asset_brand_id
                JOIN asset_types   ON asset_types.id   = asset_brands.asset_type_id
                JOIN brand_types   ON brand_types.id   = asset_brands.brand_type_id
                JOIN model_types   ON model_types.id   = asset_models.model_type_id
                JOIN condition_types ON condition_types.id = registered_assets.condition_type_id
                WHERE registered_assets.asset_registration_id = :registrationId
                ORDER BY registered_assets.id
                """, Map.of("registrationId", registrationId));
    }

    // Get-or-create by the unique supplier_name. The no-op DO UPDATE forces
    // RETURNING to yield the row even when the supplier already exists (plain
    // DO NOTHING returns nothing on conflict). Returns the id, or null on failure.
    public Integer resolveSupplierId(String supplierName) {
        Result<Map<String, Object>> result = base.fetchOne("""
                INSERT INTO suppliers (supplier_name)
                VALUES (:supplierName)
                ON CONFLICT (supplier_name) DO UPDATE SET supplier_name = EXCLUDED.supplier_name
                RETURNING id
                """, Map.of("supplierName", supplierName));

        if (!result.isOk() || result.getData() == null) {
            return null;
        }
        return ((Number) result.getData().get("id")).intValue();
    }

    // Persists the registration: supplier, the registration's event_register row,
    // the parent row, then every staged asset. The assets reference the parent id,
    // so on any asset failure we undo by deleting the children and the parent.
    public Result<Boolean> createRegistration(Registration dto) {
        Integer supplierId = resolveSupplierId(dto.getSupplierName());
        if (supplierId == null) {
            return Result.error("Could not resolve the supplier.");
        }
        dto.setSupplierId(supplierId);

        Integer eventId = base.createEventId();
        if (eventId == null) {
            return Result.error("Could not start the registration.");
        }
        dto.setEventId(eventId);

        Result<Map<String, Object>> registration = base.fetchOne("""
                INSERT INTO asset_registrations (
                    program_id,
                    acquisition_type_id,
                    reference_attachment,
                    reference_type_id,
                    event_date,
                    supplier_id,
                    notes,
                    event_register_id,
                    event_station_id,
                    event_admin_id
                ) VALUES (
                    :programId,
                    :acquisitionTypeId,
                    :referenceAttachmentPath,
                    :referenceTypeId,
                    :eventDate,
                    :supplierId,
                    :notes,
                    :eventId,
                    :eventStationId,
                    :eventAdminId
                )
                RETURNING id
                """, dto);
        if (!registration.isOk() || registration.getData() == null) {
            return Result.error("Could not save the registration.");
        }
        int registrationId = ((Number) registration.getData().get("id")).intValue();

        Result<Boolean> assets = createAssets(registrationId, dto.getAssets());
        if (!assets.isOk()) {
            revert(registrationId);
            return assets;
        }

        return Result.ok(true);
    }

    // Inserts every staged asset against the parent and stamps its asset_number.
    // Returns the first failure (the caller reverts) or ok once all are saved.
    private Result<Boolean> createAssets(int registrationId, List<Asset> assets) {
        for (Asset asset : assets) {
            asset.setAssetRegistrationId(registrationId);

            Result<Map<String, Object>> inserted = base.fetchOne("""
                    INSERT INTO registered_assets (
                        asset_registration_id,
                        asset_model_id,
                        serial_number,
                        condition_type_id,
                        acquisition_value
                    ) VALUES (
                        :assetRegistrationId,
                        :assetModelId,
                        :serialNumber,
                        :conditionTypeId,
                        :acquisitionValue
                    )
                    RETURNING id
                    """, asset);
            if (!inserted.isOk() || inserted.getData() == null) {
                return Result.error("Could not save one of the assets.");
            }
            int assetId = ((Number) inserted.getData().get("id")).intValue();

            Result<Boolean> numbered = updateAssetNumber(assetId);
            if (!numbered.isOk() || !numbered.getData()) {
                return Result.error("Could not number one of the assets.");
            }
        }

        return Result.ok(true);
    }

    // Stamps asset_number as SGAN/program_code/asset_type/id. The SGAN prefix
    // (system-generated asset number) keeps these from colliding with legacy
    // numbers carried over from older systems. The program comes from the parent
    // registration; the asset type is walked from the asset's model
    // (model -> brand -> type), so the method only needs the new asset's id.
    public Result<Boolean> updateAssetNumber(int assetId) {
        return base.execute("""
                UPDATE registered_assets ra
                SET asset_number = 'SGAN/' || p.program_code || '/' || t.name || '/' || ra.id
                FROM asset_registrations r,
                     programs p,
                     asset_models am,
                     asset_brands ab,
                     asset_types t
                WHERE ra.id = :id
                  AND r.id = ra.asset_registration_id
                  AND p.id = r.program_id
                  AND am.id = ra.asset_model_id
                  AND ab.id = am.asset_brand_id
                  AND t.id = ab.asset_type_id
                """, Map.of("id", assetId));
    }

    // All assets currently at a station (or under it in the station_code hierarchy).
    public Result<List<Map<String, Object>>> getStationAssets(int stationId) {
        return base.fetch("""
                SELECT assets_view.asset_id,
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
                  AND (
                      (scope.level IN (1, 2) AND stations.id = scope.id)
                      OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                          AND stations.station_code LIKE scope.station_code || '%')
                  )
                WHERE assets_view.disposed = false
                ORDER BY assets_view.asset_type, assets_view.brand, assets_view.model
                """, Map.of("stationId", stationId));
    }

    // Home → Dashboard: custody snapshot for the signed-in profile.
    public Result<Map<String, Object>> getDashboardCustody(int profileId) {
        return dashboardSnapshot("""
                FROM assets_view
                WHERE assets_view.custodian_id = :profileId
                """, Map.of("profileId", profileId));
    }

    // Home → Dashboard: station snapshot. Manager always uses station_code starts-with;
    // admin/supervisor use = when scope.level is 1 or 2, otherwise starts-with.
    public Result<Map<String, Object>> getDashboardStation(int stationId, boolean managerScope) {
        String stationScope = managerScope
                ? """
                FROM assets_view
                JOIN stations ON stations.id = assets_view.station_id
                JOIN stations scope ON scope.id = :stationId
                  AND stations.station_code LIKE scope.station_code || '%'
                WHERE TRUE
                """
                : """
                FROM assets_view
                JOIN stations ON stations.id = assets_view.station_id
                JOIN stations scope ON scope.id = :stationId
                  AND (
                      (scope.level IN (1, 2) AND stations.id = scope.id)
                      OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                          AND stations.station_code LIKE scope.station_code || '%')
                  )
                WHERE TRUE
                """;
        return dashboardSnapshot(stationScope, Map.of("stationId", stationId));
    }

    private Result<Map<String, Object>> dashboardSnapshot(String fromWhere, Map<String, Object> params) {
        Result<Map<String, Object>> summary = base.fetchOne("""
                SELECT
                    COUNT(*) FILTER (WHERE assets_view.disposed = false) AS total_assets,
                    COUNT(*) FILTER (
                        WHERE assets_view.disposed = false
                          AND lower(assets_view.condition) = 'damaged'
                    ) AS damaged_assets,
                    COALESCE(SUM(assets_view.current_value) FILTER (WHERE assets_view.disposed = false), 0) AS total_value
                """ + fromWhere, params);
        if (!summary.isOk()) return Result.error(summary.getMessage());

        String active = fromWhere + """
                  AND assets_view.disposed = false
                """;

        Result<List<Map<String, Object>>> byType = base.fetch("""
                SELECT
                    assets_view.asset_type,
                    COUNT(*) AS quantity,
                    COALESCE(SUM(assets_view.current_value), 0) AS total_value
                """ + active + """
                GROUP BY assets_view.asset_type
                ORDER BY quantity DESC, assets_view.asset_type
                """, params);
        if (!byType.isOk()) return Result.error(byType.getMessage());

        Result<List<Map<String, Object>>> byStation = base.fetch("""
                SELECT
                    assets_view.station_name AS station,
                    COUNT(*) AS quantity,
                    COALESCE(SUM(assets_view.current_value), 0) AS total_value
                """ + active + """
                GROUP BY assets_view.station_name
                ORDER BY quantity DESC, assets_view.station_name
                """, params);
        if (!byStation.isOk()) return Result.error(byStation.getMessage());

        Result<List<Map<String, Object>>> byCondition = base.fetch("""
                SELECT
                    assets_view.condition,
                    COUNT(*) AS quantity,
                    COALESCE(SUM(assets_view.current_value), 0) AS total_value
                """ + active + """
                GROUP BY assets_view.condition
                ORDER BY quantity DESC, assets_view.condition
                """, params);
        if (!byCondition.isOk()) return Result.error(byCondition.getMessage());

        Result<List<Map<String, Object>>> byTypeCondition = base.fetch("""
                SELECT
                    assets_view.asset_type,
                    assets_view.condition,
                    COUNT(*) AS quantity,
                    COALESCE(SUM(assets_view.current_value), 0) AS total_value
                """ + active + """
                GROUP BY assets_view.asset_type, assets_view.condition
                ORDER BY assets_view.asset_type, assets_view.condition
                """, params);
        if (!byTypeCondition.isOk()) return Result.error(byTypeCondition.getMessage());

        Map<String, Object> payload = new java.util.LinkedHashMap<>();
        payload.put("summary", summary.getData() != null ? summary.getData() : Map.of(
                "total_assets", 0,
                "damaged_assets", 0,
                "total_value", 0
        ));
        payload.put("by_type", byType.getData() != null ? byType.getData() : List.of());
        payload.put("by_station", byStation.getData() != null ? byStation.getData() : List.of());
        payload.put("by_condition", byCondition.getData() != null ? byCondition.getData() : List.of());
        payload.put("by_type_condition", byTypeCondition.getData() != null ? byTypeCondition.getData() : List.of());
        return Result.ok(payload);
    }

    // Home → Assets: custody after recipient acceptance (assets_view uses approval 10).
    public Result<List<Map<String, Object>>> getHomeAssets(int profileId) {
        return base.fetch("""
                SELECT assets_view.asset_id,
                       assets_view.asset_type,
                       assets_view.brand,
                       assets_view.model,
                       assets_view.asset_number,
                       assets_view.serial_number,
                       assets_view.condition,
                       assets_view.current_value,
                       assets_view.station_id,
                       assets_view.station_name
                FROM assets_view
                WHERE assets_view.custodian_id = :profileId
                  AND assets_view.disposed   = false
                ORDER BY assets_view.asset_type, assets_view.brand, assets_view.model
                """, Map.of("profileId", profileId));
    }

    // Home → Assignments: issuances to this staff, manager-approved (50), awaiting accept/decline (10/11).
    public Result<List<Map<String, Object>>> getPendingAssignments(int profileId) {
        return base.fetch("""
                SELECT
                    asset_issuances.id AS entity_id,
                    asset_issuances.event_register_id AS event_id,
                    to_char(asset_issuances.event_date, 'DD/MM/YYYY') AS issued_date,
                    stations.station_name AS station,
                    staff_profiles.full_name AS issued_by,
                    issuance_types.name AS issuance_type,
                    item_count.total AS quantity,
                    'Awaiting acceptance' AS status,
                    50 AS latest_approval_type_id
                FROM asset_issuances
                JOIN stations ON stations.id = asset_issuances.event_station_id
                JOIN staff_profiles ON staff_profiles.id = asset_issuances.event_admin_id
                JOIN issuance_types ON issuance_types.id = asset_issuances.issuance_type_id
                JOIN LATERAL (
                    SELECT COUNT(*) AS total
                    FROM asset_issuance_items
                    WHERE asset_issuance_items.asset_issuance_id = asset_issuances.id
                ) AS item_count ON TRUE
                WHERE asset_issuances.receiving_staff_id = :profileId
                  AND EXISTS (
                      SELECT 1 FROM event_approvals
                      WHERE event_approvals.event_register_id = asset_issuances.event_register_id
                        AND event_approvals.approval_type_id = 50
                  )
                  AND NOT EXISTS (
                      SELECT 1 FROM event_approvals
                      WHERE event_approvals.event_register_id = asset_issuances.event_register_id
                        AND event_approvals.approval_type_id IN (10, 11, 51)
                  )
                ORDER BY asset_issuances.stamp DESC
                """, Map.of("profileId", profileId));
    }

    // True when this profile is the issuance recipient and the event is awaiting their 10/11.
    public boolean canRespondToAssignment(int eventId, int profileId) {
        Result<Map<String, Object>> row = base.fetchOne("""
                SELECT asset_issuances.id
                FROM asset_issuances
                WHERE asset_issuances.event_register_id = :eventId
                  AND asset_issuances.receiving_staff_id = :profileId
                  AND EXISTS (
                      SELECT 1 FROM event_approvals
                      WHERE event_approvals.event_register_id = asset_issuances.event_register_id
                        AND event_approvals.approval_type_id = 50
                  )
                  AND NOT EXISTS (
                      SELECT 1 FROM event_approvals
                      WHERE event_approvals.event_register_id = asset_issuances.event_register_id
                        AND event_approvals.approval_type_id IN (10, 11, 51)
                  )
                """, Map.of("eventId", eventId, "profileId", profileId));
        return row.isOk() && row.getData() != null;
    }

    // Asset-admin → Incoming: transfers into this station scope, manager-approved, awaiting accept/decline.
    public Result<List<Map<String, Object>>> getIncomingTransfers(int stationId) {
        return base.fetch("""
                SELECT
                    asset_transfers.id AS entity_id,
                    asset_transfers.event_register_id AS event_id,
                    to_char(asset_transfers.event_date, 'DD/MM/YYYY') AS transfer_date,
                    from_station.station_name AS from_station,
                    to_station.station_name AS to_station,
                    staff_profiles.full_name AS transferred_by,
                    item_count.total AS quantity,
                    'Awaiting acceptance' AS status,
                    50 AS latest_approval_type_id
                FROM asset_transfers
                JOIN stations AS from_station ON from_station.id = asset_transfers.event_station_id
                JOIN stations AS to_station ON to_station.id = asset_transfers.receiving_station_id
                JOIN stations scope ON scope.id = :stationId
                  AND (
                      (scope.level IN (1, 2) AND to_station.id = scope.id)
                      OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                          AND to_station.station_code LIKE scope.station_code || '%')
                  )
                JOIN staff_profiles ON staff_profiles.id = asset_transfers.event_admin_id
                JOIN LATERAL (
                    SELECT COUNT(*) AS total
                    FROM asset_transfer_items
                    WHERE asset_transfer_items.asset_transfer_id = asset_transfers.id
                ) AS item_count ON TRUE
                WHERE EXISTS (
                      SELECT 1 FROM event_approvals
                      WHERE event_approvals.event_register_id = asset_transfers.event_register_id
                        AND event_approvals.approval_type_id = 50
                  )
                  AND NOT EXISTS (
                      SELECT 1 FROM event_approvals
                      WHERE event_approvals.event_register_id = asset_transfers.event_register_id
                        AND event_approvals.approval_type_id IN (10, 11, 51)
                  )
                ORDER BY asset_transfers.stamp DESC
                """, Map.of("stationId", stationId));
    }

    // True when this profile administers the receiving station (same hierarchy rules) and awaits 10/11.
    public boolean canRespondToIncomingTransfer(int eventId, int profileId) {
        Result<Map<String, Object>> row = base.fetchOne("""
                SELECT asset_transfers.id
                FROM asset_transfers
                JOIN stations AS to_station ON to_station.id = asset_transfers.receiving_station_id
                JOIN staff_roles ON staff_roles.staff_profile_id = :profileId
                  AND staff_roles.role_type_id = 20
                JOIN stations scope ON scope.id = staff_roles.role_station_id
                  AND (
                      (scope.level IN (1, 2) AND to_station.id = scope.id)
                      OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                          AND to_station.station_code LIKE scope.station_code || '%')
                  )
                WHERE asset_transfers.event_register_id = :eventId
                  AND EXISTS (
                      SELECT 1 FROM event_approvals
                      WHERE event_approvals.event_register_id = asset_transfers.event_register_id
                        AND event_approvals.approval_type_id = 50
                  )
                  AND NOT EXISTS (
                      SELECT 1 FROM event_approvals
                      WHERE event_approvals.event_register_id = asset_transfers.event_register_id
                        AND event_approvals.approval_type_id IN (10, 11, 51)
                  )
                """, Map.of("eventId", eventId, "profileId", profileId));
        return row.isOk() && row.getData() != null;
    }

    public boolean isCustodian(int assetId, int profileId) {
        Result<Map<String, Object>> row = base.fetchOne("""
                SELECT assets_view.asset_id
                FROM assets_view
                WHERE assets_view.asset_id = :assetId
                  AND assets_view.custodian_id = :profileId
                  AND assets_view.disposed = false
                """, Map.of("assetId", assetId, "profileId", profileId));
        return row.isOk() && row.getData() != null;
    }

    // Incidents submitted by the signed-in staff member (Home → Incidents).
    public Result<List<Map<String, Object>>> getHomeIncidents(int profileId) {
        return base.fetch("""
                SELECT
                    asset_incidents.id AS entity_id,
                    asset_incidents.event_register_id AS event_id,
                    to_char(asset_incidents.event_date, 'DD/MM/YYYY') AS incident_date,
                    (incident_types.name || ' of ' || asset_types.name || ' '
                        || COALESCE(registered_assets.asset_number, registered_assets.serial_number)) AS details,
                    stations.station_name AS station,
                    COALESCE(latest_approval.name, 'Pending') AS status,
                    COALESCE(latest_approval.id, 0) AS status_id
                FROM asset_incidents
                JOIN incident_types ON incident_types.id = asset_incidents.incident_type_id
                JOIN stations ON stations.id = asset_incidents.event_station_id
                JOIN registered_assets ON registered_assets.id = asset_incidents.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                LEFT JOIN LATERAL (
                    SELECT approval_types.id, approval_types.name
                    FROM event_approvals
                    JOIN approval_types ON approval_types.id = event_approvals.approval_type_id
                    WHERE event_approvals.event_register_id = asset_incidents.event_register_id
                    ORDER BY event_approvals.stamp DESC
                    LIMIT 1
                ) AS latest_approval ON TRUE
                WHERE asset_incidents.event_admin_id = :profileId
                ORDER BY asset_incidents.stamp DESC
                """, Map.of("profileId", profileId));
    }

    // Station change log: union of transfer / issuance / evaluation / verification /
    // disposal events (from events_view), with current approval status.
    // Disposals composed from a lost/stolen/missing incident share that incident's
    // event_id — hide them here so the Incidents list owns that story.
    public Result<List<Map<String, Object>>> getStationChanges(int station) {
        return base.fetch("""
                SELECT
                    events_view.entity_id,
                    events_view.event_id,
                    to_char(events_view.event_date, 'DD/MM/YYYY') AS change_date,
                    events_view.event_type,
                    events_view.details,
                    events_view.admin_name AS submitted_by,
                    COALESCE(events_view.latest_approval, 'Pending') AS status,
                    COALESCE(events_view.latest_approval_type_id, 0) AS status_id
                FROM events_view
                JOIN stations ON stations.id = events_view.station_id
                JOIN stations scope ON scope.id = :station
                  AND (
                      (scope.level IN (1, 2) AND stations.id = scope.id)
                      OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                          AND stations.station_code LIKE scope.station_code || '%')
                  )
                WHERE events_view.event_type IN (
                      'Transfer',
                      'Issuance',
                      'Evaluation',
                      'Verification',
                      'Disposal'
                  )
                  AND NOT (
                      events_view.event_type = 'Disposal'
                      AND EXISTS (
                          SELECT 1
                          FROM asset_incidents
                          WHERE asset_incidents.event_register_id = events_view.event_id
                      )
                  )
                ORDER BY events_view.stamp DESC
                """, Map.of("station", station));
    }

    // Station incidents list, with current approval status.
    public Result<List<Map<String, Object>>> getStationIncidents(int station) {
        return base.fetch("""
                SELECT
                    asset_incidents.id AS entity_id,
                    asset_incidents.event_register_id AS event_id,
                    to_char(asset_incidents.event_date, 'DD/MM/YYYY') AS incident_date,
                    (incident_types.name || ' of ' || asset_types.name || ' '
                        || COALESCE(registered_assets.asset_number, registered_assets.serial_number)) AS details,
                    staff_profiles.full_name AS submitted_by,
                    COALESCE(latest_approval.name, 'Pending') AS status,
                    COALESCE(latest_approval.id, 0) AS status_id
                FROM asset_incidents
                JOIN incident_types ON incident_types.id = asset_incidents.incident_type_id
                JOIN staff_profiles ON staff_profiles.id = asset_incidents.event_admin_id
                JOIN stations ON stations.id = asset_incidents.event_station_id
                JOIN stations scope ON scope.id = :station
                  AND (
                      (scope.level IN (1, 2) AND stations.id = scope.id)
                      OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                          AND stations.station_code LIKE scope.station_code || '%')
                  )
                JOIN registered_assets ON registered_assets.id = asset_incidents.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                LEFT JOIN LATERAL (
                    SELECT approval_types.id, approval_types.name
                    FROM event_approvals
                    JOIN approval_types ON approval_types.id = event_approvals.approval_type_id
                    WHERE event_approvals.event_register_id = asset_incidents.event_register_id
                    ORDER BY event_approvals.stamp DESC
                    LIMIT 1
                ) AS latest_approval ON TRUE
                ORDER BY asset_incidents.stamp DESC
                """, Map.of("station", station));
    }

    // Requisitions for a single station, shaped for the list view.
    public Result<List<Map<String, Object>>> getRequests(int station) {
        return base.fetch("""
                SELECT
                    asset_requests.id AS entity_id,
                    asset_requests.event_register_id AS event_id,
                    to_char(asset_requests.event_date, 'DD/mm/YYYY') AS request_date,
                    programs.program_name AS program,
                    stations.station_name AS station,
                    staff_profiles.full_name AS requested_by,
                    item_count.total AS quantity,
                    COALESCE(latest_approval.name, 'Pending') AS status,
                    COALESCE(latest_approval.id, 0) AS status_id
                FROM asset_requests
                JOIN programs ON programs.id = asset_requests.request_program_id
                JOIN stations ON stations.id = asset_requests.event_station_id
                JOIN stations scope ON scope.id = :station
                  AND (
                      (scope.level IN (1, 2) AND stations.id = scope.id)
                      OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                          AND stations.station_code LIKE scope.station_code || '%')
                  )
                JOIN staff_profiles ON staff_profiles.id = asset_requests.event_admin_id
                JOIN LATERAL (
                    SELECT COUNT(*) AS total
                    FROM asset_request_items
                    WHERE asset_request_items.asset_request_id = asset_requests.id
                ) AS item_count ON TRUE
                LEFT JOIN LATERAL (
                    SELECT approval_types.id, approval_types.name
                    FROM event_approvals
                    JOIN approval_types ON approval_types.id = event_approvals.approval_type_id
                    WHERE event_approvals.event_register_id = asset_requests.event_register_id
                    ORDER BY event_approvals.stamp DESC
                    LIMIT 1
                ) AS latest_approval ON TRUE
                ORDER BY asset_requests.stamp DESC
                """, Map.of("station", station));
    }

    public Result<Map<String, Object>> getRequestDetails(int requestId) {
        return base.fetchOne("""
                SELECT
                    asset_requests.event_register_id,
                    asset_requests.event_notes AS notes,
                    to_char(asset_requests.event_date, 'DD/MM/YYYY') AS request_date,
                    programs.program_name AS program
                FROM asset_requests
                JOIN programs ON programs.id = asset_requests.request_program_id
                WHERE asset_requests.id = :requestId
                """, Map.of("requestId", requestId));
    }

    public Result<List<Map<String, Object>>> getRequestItems(int requestId) {
        return base.fetch("""
                SELECT
                    asset_types.name AS asset_type,
                    asset_request_items.requested_quantity AS quantity
                FROM asset_request_items
                JOIN asset_types ON asset_types.id = asset_request_items.requested_asset_type_id
                WHERE asset_request_items.asset_request_id = :requestId
                ORDER BY asset_types.name
                """, Map.of("requestId", requestId));
    }

    public Result<Boolean> createRequest(RequestExchange dto) {
        Integer eventId = base.createEventId();
        if (eventId == null) {
            return Result.error("Could not start the requisition.");
        }
        dto.setEventId(eventId);

        Result<Map<String, Object>> request = base.fetchOne("""
                INSERT INTO asset_requests (
                    event_notes,
                    event_register_id,
                    request_program_id,
                    event_station_id,
                    event_admin_id,
                    event_date
                ) VALUES (
                    :notes,
                    :eventId,
                    :requestProgramId,
                    :eventStationId,
                    :eventAdminId,
                    :eventDate
                )
                RETURNING id
                """, dto);
        if (!request.isOk() || request.getData() == null) {
            return Result.error("Could not save the requisition.");
        }
        int requestId = ((Number) request.getData().get("id")).intValue();

        Result<Boolean> items = createRequestItems(requestId, dto.getItems());
        if (!items.isOk()) {
            revertRequest(requestId);
            return items;
        }
        return Result.ok(true);
    }

    private Result<Boolean> createRequestItems(int requestId, List<RequestItemExchange> items) {
        for (RequestItemExchange item : items) {
            item.setAssetRequestId(requestId);
            Result<Boolean> inserted = base.execute("""
                    INSERT INTO asset_request_items (
                        asset_request_id,
                        requested_asset_type_id,
                        requested_quantity
                    ) VALUES (
                        :assetRequestId,
                        :requestedAssetTypeId,
                        :requestedQuantity
                    )
                    """, item);
            if (!inserted.isOk()) {
                return Result.error("Could not save one of the requisition line items.");
            }
        }
        return Result.ok(true);
    }

    private void revertRequest(int requestId) {
        Map<String, Object> key = Map.of("id", requestId);
        base.execute("DELETE FROM asset_request_items WHERE asset_request_id = :id", key);
        base.execute("DELETE FROM asset_requests WHERE id = :id", key);
    }

    // Full registration metadata for the document template.
    public Result<Map<String, Object>> getRegistrationDetails(int registrationId) {
        return base.fetchOne("""
                SELECT
                    asset_registrations.event_register_id,
                    asset_registrations.reference_attachment,
                    to_char(asset_registrations.event_date, 'DD/MM/YYYY') AS event_date,
                    asset_registrations.notes,
                    reference_types.name   AS reference_type,
                    programs.program_name  AS program,
                    suppliers.supplier_name AS supplier,
                    acquisition_types.name AS acquisition_type
                FROM asset_registrations
                JOIN reference_types   ON reference_types.id   = asset_registrations.reference_type_id
                JOIN programs          ON programs.id           = asset_registrations.program_id
                JOIN suppliers         ON suppliers.id          = asset_registrations.supplier_id
                JOIN acquisition_types ON acquisition_types.id  = asset_registrations.acquisition_type_id
                WHERE asset_registrations.id = :registrationId
                """, Map.of("registrationId", registrationId));
    }

    // Transfer metadata for the document template.
    public Result<Map<String, Object>> getTransferDetails(int transferId) {
        return base.fetchOne("""
                SELECT
                    asset_transfers.event_register_id,
                    asset_transfers.notes,
                    to_char(asset_transfers.event_date, 'DD/MM/YYYY') AS transfer_date,
                    from_station.station_name                     AS from_station,
                    to_station.station_name                       AS to_station,
                    staff_profiles.full_name                      AS submitted_by
                FROM asset_transfers
                JOIN stations AS from_station ON from_station.id = asset_transfers.event_station_id
                JOIN stations AS to_station   ON to_station.id   = asset_transfers.receiving_station_id
                JOIN staff_profiles           ON staff_profiles.id = asset_transfers.event_admin_id
                WHERE asset_transfers.id = :transferId
                """, Map.of("transferId", transferId));
    }

    // Assets included in a single transfer, shaped for the template table.
    public Result<List<Map<String, Object>>> getTransferAssets(int transferId) {
        return base.fetch("""
                SELECT
                    registered_assets.asset_number,
                    registered_assets.serial_number,
                    asset_types.name     AS asset_type,
                    brand_types.name     AS brand,
                    model_types.name     AS model,
                    condition_types.name AS condition
                FROM asset_transfer_items
                JOIN registered_assets  ON registered_assets.id  = asset_transfer_items.registered_asset_id
                JOIN asset_models       ON asset_models.id        = registered_assets.asset_model_id
                JOIN asset_brands       ON asset_brands.id        = asset_models.asset_brand_id
                JOIN asset_types        ON asset_types.id         = asset_brands.asset_type_id
                JOIN brand_types        ON brand_types.id         = asset_brands.brand_type_id
                JOIN model_types        ON model_types.id         = asset_models.model_type_id
                JOIN condition_types    ON condition_types.id     = registered_assets.condition_type_id
                WHERE asset_transfer_items.asset_transfer_id = :transferId
                ORDER BY registered_assets.id
                """, Map.of("transferId", transferId));
    }

    // Persists the transfer: creates an event_register entry, inserts the parent
    // asset_transfers row, then loops over each item inserting into asset_transfer_items.
    // On any failure the items and parent are deleted before returning the error.
    public Result<Boolean> createTransfer(TransferExchange dto) {
        List<Integer> assetIds = dto.getItems().stream()
                .map(TransferItemExchange::getRegisteredAssetId)
                .toList();

        Result<String> pending = hasPendingTransfer(assetIds);
        if (!pending.isOk()) return Result.error("Could not check for pending transfers.");
        if (pending.getData() != null) return Result.error(pending.getData() + " already has a pending transfer.");

        Integer eventId = base.createEventId();
        if (eventId == null) {
            return Result.error("Could not start the transfer.");
        }
        dto.setEventId(eventId);

        Result<Map<String, Object>> transfer = base.fetchOne("""
                INSERT INTO asset_transfers (
                    receiving_station_id,
                    notes,
                    event_register_id,
                    event_station_id,
                    event_admin_id,
                    event_date
                ) VALUES (
                    :receivingStationId,
                    :notes,
                    :eventId,
                    :eventStationId,
                    :eventAdminId,
                    :eventDate
                )
                RETURNING id
                """, dto);
        if (!transfer.isOk() || transfer.getData() == null) {
            return Result.error("Could not save the transfer.");
        }
        int transferId = ((Number) transfer.getData().get("id")).intValue();

        Result<Boolean> items = createTransferItems(transferId, dto.getItems());
        if (!items.isOk()) {
            revertTransfer(transferId);
            return items;
        }

        return Result.ok(true);
    }

    // Inserts each transfer item linked to the parent transfer id.
    private Result<Boolean> createTransferItems(int transferId, List<TransferItemExchange> items) {
        for (TransferItemExchange item : items) {
            item.setAssetTransferId(transferId);

            Result<Boolean> inserted = base.execute("""
                    INSERT INTO asset_transfer_items (
                        asset_transfer_id,
                        registered_asset_id
                    ) VALUES (
                        :assetTransferId,
                        :registeredAssetId
                    )
                    """, item);
            if (!inserted.isOk()) {
                return Result.error("Could not save one of the transfer items.");
            }
        }
        return Result.ok(true);
    }


    // -------------------------------------------------------------------------
    // Pending event guards
    //
    // hasPendingTransfer / hasPendingIssuance use pendingBatch (asset is in an
    // items table that joins to a parent for event_register_id).
    // The remaining four use pendingDirect (registered_asset_id and
    // event_register_id live on the same event table row).
    // Both helpers return null (asset free) or a "Brand Type (ref)" string for
    // the first locked asset found. LIMIT 1 stops the scan immediately.
    // Direct events close on 41/50/51. Transfer/issuance stay locked until
    // acceptance 10 or decline 11 (manager 50 alone is not enough).
    // Table names are internal constants — string interpolation is safe.
    // -------------------------------------------------------------------------

    // Returns the first locked asset's "Brand Type (ref)" string, or null if the
    // asset IDs are all free. Works for event tables that carry both
    // registered_asset_id and event_register_id on the same row.
    private Result<String> hasPendingEvent(String table, List<Integer> assetIds) {
        String sql = """
                SELECT brand_types.name || ' ' || asset_types.name || ' ('
                       || COALESCE(registered_assets.asset_number, registered_assets.serial_number) || ')' AS ref
                FROM %1$s
                JOIN registered_assets ON registered_assets.id = %1$s.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types  ON asset_types.id  = asset_brands.asset_type_id
                JOIN brand_types  ON brand_types.id  = asset_brands.brand_type_id
                LEFT JOIN LATERAL (
                    SELECT event_approvals.approval_type_id
                    FROM event_approvals
                    WHERE event_approvals.event_register_id = %1$s.event_register_id
                    ORDER BY event_approvals.stamp DESC
                    LIMIT 1
                ) AS t1 ON TRUE
                WHERE %1$s.registered_asset_id IN (:assetIds)
                AND (t1.approval_type_id IS NULL OR t1.approval_type_id NOT IN (41, 50, 51))
                LIMIT 1
                """.formatted(table);
        Result<Map<String, Object>> row = base.fetchOne(sql, Map.of("assetIds", assetIds));
        if (!row.isOk()) return Result.error(row.getMessage());
        return Result.ok(row.getData() != null ? row.getData().get("ref").toString() : null);
    }

    // Transfer and issuance keep their items in a separate table that joins to
    // the parent for event_register_id, so they carry their SQL directly.
    public Result<String> hasPendingTransfer(List<Integer> assetIds) {
        Result<Map<String, Object>> row = base.fetchOne("""
                SELECT brand_types.name || ' ' || asset_types.name || ' ('
                       || COALESCE(registered_assets.asset_number, registered_assets.serial_number) || ')' AS ref
                FROM asset_transfer_items
                JOIN asset_transfers    ON asset_transfers.id   = asset_transfer_items.asset_transfer_id
                JOIN registered_assets  ON registered_assets.id = asset_transfer_items.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types  ON asset_types.id  = asset_brands.asset_type_id
                JOIN brand_types  ON brand_types.id  = asset_brands.brand_type_id
                LEFT JOIN LATERAL (
                    SELECT event_approvals.approval_type_id
                    FROM event_approvals
                    WHERE event_approvals.event_register_id = asset_transfers.event_register_id
                    ORDER BY event_approvals.stamp DESC
                    LIMIT 1
                ) AS t1 ON TRUE
                WHERE asset_transfer_items.registered_asset_id IN (:assetIds)
                AND (t1.approval_type_id IS NULL OR t1.approval_type_id NOT IN (10, 11, 41, 51))
                LIMIT 1
                """, Map.of("assetIds", assetIds));
        if (!row.isOk()) return Result.error(row.getMessage());
        return Result.ok(row.getData() != null ? row.getData().get("ref").toString() : null);
    }

    public Result<String> hasPendingIssuance(List<Integer> assetIds) {
        Result<Map<String, Object>> row = base.fetchOne("""
                SELECT brand_types.name || ' ' || asset_types.name || ' ('
                       || COALESCE(registered_assets.asset_number, registered_assets.serial_number) || ')' AS ref
                FROM asset_issuance_items
                JOIN asset_issuances    ON asset_issuances.id   = asset_issuance_items.asset_issuance_id
                JOIN registered_assets  ON registered_assets.id = asset_issuance_items.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types  ON asset_types.id  = asset_brands.asset_type_id
                JOIN brand_types  ON brand_types.id  = asset_brands.brand_type_id
                LEFT JOIN LATERAL (
                    SELECT event_approvals.approval_type_id
                    FROM event_approvals
                    WHERE event_approvals.event_register_id = asset_issuances.event_register_id
                    ORDER BY event_approvals.stamp DESC
                    LIMIT 1
                ) AS t1 ON TRUE
                WHERE asset_issuance_items.registered_asset_id IN (:assetIds)
                AND (t1.approval_type_id IS NULL OR t1.approval_type_id NOT IN (10, 11, 41, 51))
                LIMIT 1
                """, Map.of("assetIds", assetIds));
        if (!row.isOk()) return Result.error(row.getMessage());
        return Result.ok(row.getData() != null ? row.getData().get("ref").toString() : null);
    }

    public Result<String> hasPendingVerification(List<Integer> assetIds) {
        return hasPendingEvent("asset_verifications", assetIds);
    }

    public Result<String> hasPendingEvaluation(List<Integer> assetIds) {
        return hasPendingEvent("asset_evaluations", assetIds);
    }

    public Result<String> hasPendingPlacement(List<Integer> assetIds) {
        return hasPendingEvent("asset_placements", assetIds);
    }

    public Result<String> hasPendingDisposal(List<Integer> assetIds) {
        return hasPendingEvent("asset_disposals", assetIds);
    }

    // Disposal is terminal: refuse if the asset is locked by any open change event.
    // Returns a ready-to-show error message, or null when the asset is free.
    private Result<String> hasAnyPendingChange(List<Integer> assetIds) {
        Result<String> transfer = hasPendingTransfer(assetIds);
        if (!transfer.isOk()) return Result.error("Could not check for pending transfers.");
        if (transfer.getData() != null) {
            return Result.ok(transfer.getData() + " already has a pending transfer.");
        }

        Result<String> issuance = hasPendingIssuance(assetIds);
        if (!issuance.isOk()) return Result.error("Could not check for pending issuances.");
        if (issuance.getData() != null) {
            return Result.ok(issuance.getData() + " already has a pending issuance.");
        }

        Result<String> verification = hasPendingVerification(assetIds);
        if (!verification.isOk()) return Result.error("Could not check for pending verifications.");
        if (verification.getData() != null) {
            return Result.ok(verification.getData() + " already has a pending verification.");
        }

        Result<String> evaluation = hasPendingEvaluation(assetIds);
        if (!evaluation.isOk()) return Result.error("Could not check for pending evaluations.");
        if (evaluation.getData() != null) {
            return Result.ok(evaluation.getData() + " already has a pending evaluation.");
        }

        Result<String> placement = hasPendingPlacement(assetIds);
        if (!placement.isOk()) return Result.error("Could not check for pending placements.");
        if (placement.getData() != null) {
            return Result.ok(placement.getData() + " already has a pending placement.");
        }

        Result<String> disposal = hasPendingDisposal(assetIds);
        if (!disposal.isOk()) return Result.error("Could not check for pending disposals.");
        if (disposal.getData() != null) {
            return Result.ok(disposal.getData() + " already has a pending disposal.");
        }

        return Result.ok(null);
    }

    // Compensating cleanup for registration: children first (FK), then the parent row.
    private void revert(int registrationId) {
        Map<String, Object> key = Map.of("id", registrationId);
        base.execute("DELETE FROM registered_assets WHERE asset_registration_id = :id", key);
        base.execute("DELETE FROM asset_registrations WHERE id = :id", key);
    }

    // Compensating cleanup for transfer: items first (FK), then the parent row.
    private void revertTransfer(int transferId) {
        Map<String, Object> key = Map.of("id", transferId);
        base.execute("DELETE FROM asset_transfer_items WHERE asset_transfer_id = :id", key);
        base.execute("DELETE FROM asset_transfers WHERE id = :id", key);
    }

    // -------------------------------------------------------------------------
    // Issuance
    // -------------------------------------------------------------------------

    public Result<Map<String, Object>> getIssuanceDetails(int issuanceId) {
        return base.fetchOne("""
                SELECT
                    asset_issuances.event_register_id,
                    asset_issuances.notes,
                    to_char(asset_issuances.event_date, 'DD/MM/YYYY') AS issuance_date,
                    receiving_staff.full_name                     AS recipient,
                    issuance_types.name                           AS issuance_type,
                    stations.station_name                         AS station,
                    staff_profiles.full_name                      AS submitted_by
                FROM asset_issuances
                JOIN staff_profiles AS receiving_staff ON receiving_staff.id  = asset_issuances.receiving_staff_id
                JOIN issuance_types                    ON issuance_types.id   = asset_issuances.issuance_type_id
                JOIN stations                          ON stations.id         = asset_issuances.event_station_id
                JOIN staff_profiles                    ON staff_profiles.id   = asset_issuances.event_admin_id
                WHERE asset_issuances.id = :issuanceId
                """, Map.of("issuanceId", issuanceId));
    }

    public Result<List<Map<String, Object>>> getIssuanceAssets(int issuanceId) {
        return base.fetch("""
                SELECT
                    registered_assets.asset_number,
                    registered_assets.serial_number,
                    asset_types.name     AS asset_type,
                    brand_types.name     AS brand,
                    model_types.name     AS model,
                    condition_types.name AS condition
                FROM asset_issuance_items
                JOIN registered_assets ON registered_assets.id = asset_issuance_items.registered_asset_id
                JOIN asset_models      ON asset_models.id      = registered_assets.asset_model_id
                JOIN asset_brands      ON asset_brands.id      = asset_models.asset_brand_id
                JOIN asset_types       ON asset_types.id       = asset_brands.asset_type_id
                JOIN brand_types       ON brand_types.id       = asset_brands.brand_type_id
                JOIN model_types       ON model_types.id       = asset_models.model_type_id
                JOIN condition_types   ON condition_types.id   = registered_assets.condition_type_id
                WHERE asset_issuance_items.asset_issuance_id = :issuanceId
                ORDER BY registered_assets.id
                """, Map.of("issuanceId", issuanceId));
    }

    public Result<Boolean> createIssuance(IssuanceExchange dto) {
        List<Integer> assetIds = dto.getItems().stream()
                .map(IssuanceItemExchange::getRegisteredAssetId)
                .toList();

        Result<String> pending = hasPendingIssuance(assetIds);
        if (!pending.isOk()) return Result.error("Could not check for pending issuances.");
        if (pending.getData() != null) return Result.error(pending.getData() + " already has a pending issuance.");

        Integer eventId = base.createEventId();
        if (eventId == null) return Result.error("Could not start the issuance.");
        dto.setEventId(eventId);

        Result<Map<String, Object>> issuance = base.fetchOne("""
                INSERT INTO asset_issuances (
                    receiving_staff_id,
                    issuance_type_id,
                    notes,
                    event_register_id,
                    event_station_id,
                    event_admin_id,
                    event_date
                ) VALUES (
                    :receivingStaffId,
                    :issuanceTypeId,
                    :notes,
                    :eventId,
                    :eventStationId,
                    :eventAdminId,
                    :eventDate
                )
                RETURNING id
                """, dto);
        if (!issuance.isOk() || issuance.getData() == null) return Result.error("Could not save the issuance.");
        int issuanceId = ((Number) issuance.getData().get("id")).intValue();

        Result<Boolean> items = createIssuanceItems(issuanceId, dto.getItems());
        if (!items.isOk()) {
            revertIssuance(issuanceId);
            return items;
        }
        return Result.ok(true);
    }

    private Result<Boolean> createIssuanceItems(int issuanceId, List<IssuanceItemExchange> items) {
        for (IssuanceItemExchange item : items) {
            item.setAssetIssuanceId(issuanceId);
            Result<Boolean> inserted = base.execute("""
                    INSERT INTO asset_issuance_items (
                        asset_issuance_id,
                        registered_asset_id
                    ) VALUES (
                        :assetIssuanceId,
                        :registeredAssetId
                    )
                    """, item);
            if (!inserted.isOk()) return Result.error("Could not save one of the issuance items.");
        }
        return Result.ok(true);
    }

    private void revertIssuance(int issuanceId) {
        Map<String, Object> key = Map.of("id", issuanceId);
        base.execute("DELETE FROM asset_issuance_items WHERE asset_issuance_id = :id", key);
        base.execute("DELETE FROM asset_issuances WHERE id = :id", key);
    }

    // -------------------------------------------------------------------------
    // Verification / Evaluation / Placement
    // -------------------------------------------------------------------------

    public Result<Map<String, Object>> getVerificationDetails(int verificationId) {
        return base.fetchOne("""
                SELECT
                    asset_verifications.event_register_id,
                    asset_verifications.event_notes AS notes,
                    to_char(asset_verifications.event_date, 'DD/MM/YYYY') AS verification_date,
                    verification_types.name AS verification_type,
                    condition_types.name AS verified_condition,
                    stations.station_name AS station,
                    staff_profiles.full_name AS submitted_by,
                    registered_assets.asset_number,
                    registered_assets.serial_number,
                    asset_types.name AS asset_type,
                    brand_types.name AS brand,
                    model_types.name AS model
                FROM asset_verifications
                JOIN verification_types ON verification_types.id = asset_verifications.verification_type_id
                JOIN condition_types ON condition_types.id = asset_verifications.verified_condition_type_id
                JOIN stations ON stations.id = asset_verifications.event_station_id
                JOIN staff_profiles ON staff_profiles.id = asset_verifications.event_admin_id
                JOIN registered_assets ON registered_assets.id = asset_verifications.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                JOIN brand_types ON brand_types.id = asset_brands.brand_type_id
                JOIN model_types ON model_types.id = asset_models.model_type_id
                WHERE asset_verifications.id = :verificationId
                """, Map.of("verificationId", verificationId));
    }

    public Result<Boolean> createVerification(VerificationExchange dto) {
        Result<String> pending = hasPendingVerification(List.of(dto.getRegisteredAssetId()));
        if (!pending.isOk()) return Result.error("Could not check for pending verifications.");
        if (pending.getData() != null) return Result.error(pending.getData() + " already has a pending verification.");

        Integer eventId = base.createEventId();
        if (eventId == null) return Result.error("Could not start the verification.");
        dto.setEventId(eventId);

        Result<Boolean> inserted = base.execute("""
                INSERT INTO asset_verifications (
                    registered_asset_id,
                    verification_type_id,
                    verified_condition_type_id,
                    event_notes,
                    event_register_id,
                    event_station_id,
                    event_admin_id,
                    event_date
                ) VALUES (
                    :registeredAssetId,
                    :verificationTypeId,
                    :verifiedConditionTypeId,
                    :eventNotes,
                    :eventId,
                    :eventStationId,
                    :eventAdminId,
                    :eventDate
                )
                """, dto);
        if (!inserted.isOk()) return Result.error("Could not save the verification.");
        return Result.ok(true);
    }

    public Result<Map<String, Object>> getEvaluationDetails(int evaluationId) {
        return base.fetchOne("""
                SELECT
                    asset_evaluations.event_register_id,
                    asset_evaluations.event_notes AS notes,
                    to_char(asset_evaluations.event_date, 'DD/MM/YYYY') AS evaluation_date,
                    asset_evaluations.evaluated_value,
                    evaluation_types.name AS evaluation_type,
                    stations.station_name AS station,
                    staff_profiles.full_name AS submitted_by,
                    registered_assets.asset_number,
                    registered_assets.serial_number,
                    asset_types.name AS asset_type,
                    brand_types.name AS brand,
                    model_types.name AS model
                FROM asset_evaluations
                JOIN evaluation_types ON evaluation_types.id = asset_evaluations.evaluation_type_id
                JOIN stations ON stations.id = asset_evaluations.event_station_id
                JOIN staff_profiles ON staff_profiles.id = asset_evaluations.event_admin_id
                JOIN registered_assets ON registered_assets.id = asset_evaluations.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                JOIN brand_types ON brand_types.id = asset_brands.brand_type_id
                JOIN model_types ON model_types.id = asset_models.model_type_id
                WHERE asset_evaluations.id = :evaluationId
                """, Map.of("evaluationId", evaluationId));
    }

    public Result<Boolean> createEvaluation(EvaluationExchange dto) {
        Result<String> pending = hasPendingEvaluation(List.of(dto.getRegisteredAssetId()));
        if (!pending.isOk()) return Result.error("Could not check for pending evaluations.");
        if (pending.getData() != null) return Result.error(pending.getData() + " already has a pending evaluation.");

        Integer eventId = base.createEventId();
        if (eventId == null) return Result.error("Could not start the evaluation.");
        dto.setEventId(eventId);

        Result<Boolean> inserted = base.execute("""
                INSERT INTO asset_evaluations (
                    registered_asset_id,
                    evaluation_type_id,
                    evaluated_value,
                    event_notes,
                    event_register_id,
                    event_station_id,
                    event_admin_id,
                    event_date
                ) VALUES (
                    :registeredAssetId,
                    :evaluationTypeId,
                    :evaluatedValue,
                    :eventNotes,
                    :eventId,
                    :eventStationId,
                    :eventAdminId,
                    :eventDate
                )
                """, dto);
        if (!inserted.isOk()) return Result.error("Could not save the evaluation.");
        return Result.ok(true);
    }

    public Result<Map<String, Object>> getPlacementDetails(int placementId) {
        return base.fetchOne("""
                SELECT
                    asset_placements.event_register_id,
                    asset_placements.event_notes AS notes,
                    to_char(asset_placements.event_date, 'DD/MM/YYYY') AS placement_date,
                    placement_types.name AS placement_type,
                    stations.station_name AS station,
                    staff_profiles.full_name AS submitted_by,
                    registered_assets.asset_number,
                    registered_assets.serial_number,
                    asset_types.name AS asset_type,
                    brand_types.name AS brand,
                    model_types.name AS model
                FROM asset_placements
                JOIN placement_types ON placement_types.id = asset_placements.placement_type_id
                JOIN stations ON stations.id = asset_placements.event_station_id
                JOIN staff_profiles ON staff_profiles.id = asset_placements.event_admin_id
                JOIN registered_assets ON registered_assets.id = asset_placements.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                JOIN brand_types ON brand_types.id = asset_brands.brand_type_id
                JOIN model_types ON model_types.id = asset_models.model_type_id
                WHERE asset_placements.id = :placementId
                """, Map.of("placementId", placementId));
    }

    public Result<Boolean> createPlacement(PlacementExchange dto) {
        Result<String> pending = hasPendingPlacement(List.of(dto.getRegisteredAssetId()));
        if (!pending.isOk()) return Result.error("Could not check for pending placements.");
        if (pending.getData() != null) return Result.error(pending.getData() + " already has a pending placement.");

        Integer eventId = base.createEventId();
        if (eventId == null) return Result.error("Could not start the placement.");
        dto.setEventId(eventId);

        Result<Boolean> inserted = base.execute("""
                INSERT INTO asset_placements (
                    registered_asset_id,
                    placement_type_id,
                    event_notes,
                    event_register_id,
                    event_station_id,
                    event_admin_id,
                    event_date
                ) VALUES (
                    :registeredAssetId,
                    :placementTypeId,
                    :eventNotes,
                    :eventId,
                    :eventStationId,
                    :eventAdminId,
                    :eventDate
                )
                """, dto);
        if (!inserted.isOk()) return Result.error("Could not save the placement.");
        return Result.ok(true);
    }

    public Result<Map<String, Object>> getDisposalDetails(int disposalId) {
        return base.fetchOne("""
                SELECT
                    asset_disposals.event_register_id,
                    asset_disposals.event_notes AS notes,
                    to_char(asset_disposals.event_date, 'DD/MM/YYYY') AS disposal_date,
                    disposal_types.name AS disposal_type,
                    stations.station_name AS station,
                    staff_profiles.full_name AS submitted_by,
                    registered_assets.asset_number,
                    registered_assets.serial_number,
                    asset_types.name AS asset_type,
                    brand_types.name AS brand,
                    model_types.name AS model
                FROM asset_disposals
                JOIN disposal_types ON disposal_types.id = asset_disposals.disposal_type_id
                JOIN stations ON stations.id = asset_disposals.event_station_id
                JOIN staff_profiles ON staff_profiles.id = asset_disposals.event_admin_id
                JOIN registered_assets ON registered_assets.id = asset_disposals.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                JOIN brand_types ON brand_types.id = asset_brands.brand_type_id
                JOIN model_types ON model_types.id = asset_models.model_type_id
                WHERE asset_disposals.id = :disposalId
                """, Map.of("disposalId", disposalId));
    }

    public Result<Boolean> createDisposal(DisposalExchange dto) {
        Result<String> pending = hasAnyPendingChange(List.of(dto.getRegisteredAssetId()));
        if (!pending.isOk()) return Result.error(pending.getMessage());
        if (pending.getData() != null) return Result.error(pending.getData());

        Integer eventId = base.createEventId();
        if (eventId == null) return Result.error("Could not start the disposal.");
        dto.setEventId(eventId);

        Result<Boolean> inserted = base.execute("""
                INSERT INTO asset_disposals (
                    registered_asset_id,
                    disposal_type_id,
                    event_notes,
                    event_register_id,
                    event_station_id,
                    event_admin_id,
                    event_date
                ) VALUES (
                    :registeredAssetId,
                    :disposalTypeId,
                    :eventNotes,
                    :eventId,
                    :eventStationId,
                    :eventAdminId,
                    :eventDate
                )
                """, dto);
        if (!inserted.isOk()) return Result.error("Could not save the disposal.");
        return Result.ok(true);
    }

    // Get-or-create disposal_types by name (used when composing a disposal from an incident).
    public Integer resolveDisposalTypeId(String name) {
        Result<Map<String, Object>> result = base.fetchOne("""
                INSERT INTO disposal_types (name)
                VALUES (:name)
                ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
                RETURNING id
                """, Map.of("name", name));
        if (!result.isOk() || result.getData() == null) return null;
        return ((Number) result.getData().get("id")).intValue();
    }

    // After manager approval (50) of a Theft / Missing / Lost incident: insert a disposal
    // on the same already-approved event_register_id. Disposal type name = incident type.
    // Idempotent when the disposal row already exists for that event.
    public Result<Boolean> createDisposalFromApprovedIncident(int eventId) {
        Result<Map<String, Object>> incident = base.fetchOne("""
                SELECT
                    asset_incidents.registered_asset_id,
                    asset_incidents.event_station_id,
                    asset_incidents.event_admin_id,
                    asset_incidents.event_notes,
                    asset_incidents.event_date,
                    incident_types.name AS incident_type
                FROM asset_incidents
                JOIN incident_types ON incident_types.id = asset_incidents.incident_type_id
                WHERE asset_incidents.event_register_id = :eventId
                  AND lower(incident_types.name) IN ('theft', 'missing', 'lost')
                """, Map.of("eventId", eventId));
        if (!incident.isOk()) return Result.error("Could not check incident for disposal.");
        if (incident.getData() == null) return Result.ok(false);

        Result<Map<String, Object>> existing = base.fetchOne("""
                SELECT id FROM asset_disposals WHERE event_register_id = :eventId
                """, Map.of("eventId", eventId));
        if (!existing.isOk()) return Result.error("Could not check for existing disposal.");
        if (existing.getData() != null) return Result.ok(true);

        Map<String, Object> row = incident.getData();
        String incidentType = row.get("incident_type").toString();
        Integer disposalTypeId = resolveDisposalTypeId(incidentType);
        if (disposalTypeId == null) return Result.error("Could not resolve disposal type.");

        Result<Boolean> inserted = base.execute("""
                INSERT INTO asset_disposals (
                    registered_asset_id,
                    disposal_type_id,
                    event_notes,
                    event_register_id,
                    event_station_id,
                    event_admin_id,
                    event_date
                ) VALUES (
                    :registeredAssetId,
                    :disposalTypeId,
                    :eventNotes,
                    :eventId,
                    :eventStationId,
                    :eventAdminId,
                    :eventDate
                )
                """, Map.of(
                "registeredAssetId", ((Number) row.get("registered_asset_id")).intValue(),
                "disposalTypeId", disposalTypeId,
                "eventNotes", row.get("event_notes") != null ? row.get("event_notes").toString() : "",
                "eventId", eventId,
                "eventStationId", ((Number) row.get("event_station_id")).intValue(),
                "eventAdminId", ((Number) row.get("event_admin_id")).intValue(),
                "eventDate", row.get("event_date")
        ));
        if (!inserted.isOk()) return Result.error("Could not compose disposal from incident.");
        return Result.ok(true);
    }

    public Result<Map<String, Object>> getIncidentDetails(int incidentId) {
        return base.fetchOne("""
                SELECT
                    asset_incidents.event_register_id,
                    asset_incidents.event_notes AS notes,
                    to_char(asset_incidents.event_date, 'DD/MM/YYYY') AS incident_date,
                    incident_types.name AS incident_type,
                    stations.station_name AS station,
                    staff_profiles.full_name AS submitted_by,
                    asset_incidents.incident_asset_image AS asset_image,
                    asset_incidents.incident_police_report AS police_report,
                    registered_assets.asset_number,
                    registered_assets.serial_number,
                    asset_types.name AS asset_type,
                    brand_types.name AS brand,
                    model_types.name AS model
                FROM asset_incidents
                JOIN incident_types ON incident_types.id = asset_incidents.incident_type_id
                JOIN stations ON stations.id = asset_incidents.event_station_id
                JOIN staff_profiles ON staff_profiles.id = asset_incidents.event_admin_id
                JOIN registered_assets ON registered_assets.id = asset_incidents.registered_asset_id
                JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                JOIN brand_types ON brand_types.id = asset_brands.brand_type_id
                JOIN model_types ON model_types.id = asset_models.model_type_id
                WHERE asset_incidents.id = :incidentId
                """, Map.of("incidentId", incidentId));
    }

    // Incidents are a timeline — a pending damage report must not block a later theft report.
    public Result<Boolean> createIncident(IncidentExchange dto) {
        Integer eventId = base.createEventId();
        if (eventId == null) return Result.error("Could not start the incident.");
        dto.setEventId(eventId);

        Result<Boolean> inserted = base.execute("""
                INSERT INTO asset_incidents (
                    registered_asset_id,
                    incident_type_id,
                    event_notes,
                    incident_asset_image,
                    incident_police_report,
                    event_register_id,
                    event_station_id,
                    event_admin_id,
                    event_date
                ) VALUES (
                    :registeredAssetId,
                    :incidentTypeId,
                    :eventNotes,
                    :incidentAssetImagePath,
                    :incidentPoliceReportPath,
                    :eventId,
                    :eventStationId,
                    :eventAdminId,
                    :eventDate
                )
                """, dto);
        if (!inserted.isOk()) return Result.error("Could not save the incident.");
        return Result.ok(true);
    }
}