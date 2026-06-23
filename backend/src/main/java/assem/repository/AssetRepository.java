package assem.repository;

import assem.exchange.assets.Asset;
import assem.exchange.assets.Registration;
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
                    to_char(asset_registrations.reference_date, 'DD/mm/YYYY') AS reference_date,
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
                WHERE asset_registrations.event_station_id = :station
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
                    reference_date,
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
                    :referenceDate,
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

    // Full registration metadata for the document template.
    public Result<Map<String, Object>> getRegistrationDetails(int registrationId) {
        return base.fetchOne("""
                SELECT
                    asset_registrations.event_register_id,
                    asset_registrations.reference_attachment,
                    to_char(asset_registrations.reference_date, 'DD/MM/YYYY') AS reference_date,
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

    // Compensating cleanup: children first (FK), then the parent row.
    private void revert(int registrationId) {
        Map<String, Object> key = Map.of("id", registrationId);
        base.execute("DELETE FROM registered_assets WHERE asset_registration_id = :id", key);
        base.execute("DELETE FROM asset_registrations WHERE id = :id", key);
    }
}
