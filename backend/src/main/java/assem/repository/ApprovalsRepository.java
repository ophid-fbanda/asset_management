package assem.repository;

import assem.exchange.commons.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ApprovalsRepository {

    @Autowired
    private BaseRepo base;

    private static final int SUPERVISORY_APPROVAL_TYPE_ID  = 40;
    private static final int SUPERVISORY_REJECTION_TYPE_ID = 41;
    private static final int MANAGEMENT_APPROVAL_TYPE_ID   = 50;
    private static final int MANAGEMENT_REJECTION_TYPE_ID  = 51;

    // Events under the selected station's hierarchy with no approval yet — role 40.
    // Incidents are also read from asset_incidents so pending rows still appear when
    // the live events_view definition has not been refreshed to include Incident.
    public Result<List<Map<String, Object>>> supervisoryPending(int stationId) {
        return base.fetch("""
                SELECT event_type,
                       entity_id,
                       event_id,
                       latest_approval_type_id,
                       latest_approval,
                       event_date,
                       captured,
                       station_name,
                       admin_name,
                       details
                FROM (
                    SELECT events_view.event_type,
                           events_view.entity_id,
                           events_view.event_id,
                           events_view.latest_approval_type_id,
                           events_view.latest_approval,
                           to_char(events_view.event_date, 'DD/MM/YYYY')    AS event_date,
                           to_char(events_view.stamp, 'DD/MM/YYYY HH24:MI') AS captured,
                           events_view.station_name,
                           events_view.admin_name,
                           events_view.details,
                           events_view.stamp
                    FROM events_view
                    JOIN stations ON stations.id = events_view.station_id
                    JOIN stations scope ON scope.id = :stationId
                      AND (
                          (scope.level IN (1, 2) AND stations.id = scope.id)
                          OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                              AND stations.station_code LIKE scope.station_code || '%')
                      )
                    WHERE events_view.latest_approval_type_id = 0

                    UNION ALL

                    SELECT 'Incident'::text,
                           asset_incidents.id,
                           asset_incidents.event_register_id,
                           0,
                           'Pending'::text,
                           to_char(asset_incidents.stamp, 'DD/MM/YYYY'),
                           to_char(asset_incidents.stamp, 'DD/MM/YYYY HH24:MI'),
                           stations.station_name,
                           staff_profiles.full_name,
                           (incident_types.name || ' of ' || asset_types.name || ' '
                               || COALESCE(registered_assets.asset_number, registered_assets.serial_number)),
                           asset_incidents.stamp
                    FROM asset_incidents
                    JOIN incident_types ON incident_types.id = asset_incidents.incident_type_id
                    JOIN stations ON stations.id = asset_incidents.event_station_id
                    JOIN stations scope ON scope.id = :stationId
                      AND (
                          (scope.level IN (1, 2) AND stations.id = scope.id)
                          OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                              AND stations.station_code LIKE scope.station_code || '%')
                      )
                    JOIN staff_profiles ON staff_profiles.id = asset_incidents.event_admin_id
                    JOIN registered_assets ON registered_assets.id = asset_incidents.registered_asset_id
                    JOIN asset_models ON asset_models.id = registered_assets.asset_model_id
                    JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                    JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                    WHERE NOT EXISTS (
                          SELECT 1
                          FROM event_approvals
                          WHERE event_approvals.event_register_id = asset_incidents.event_register_id
                      )
                      AND NOT EXISTS (
                          SELECT 1
                          FROM events_view
                          WHERE events_view.event_id = asset_incidents.event_register_id
                            AND events_view.event_type = 'Incident'
                      )
                ) AS pending
                ORDER BY stamp DESC
                """, Map.of("stationId", stationId));
    }

    // Events under the hierarchy that passed through supervisory — history for role 40, current year.
    public Result<List<Map<String, Object>>> supervisoryHistory(int stationId) {
        return base.fetch("""
                SELECT events_view.event_type,
                       events_view.entity_id,
                       events_view.event_id,
                       to_char(events_view.event_date, 'DD/MM/YYYY')    AS event_date,
                       to_char(events_view.stamp, 'DD/MM/YYYY HH24:MI') AS captured,
                       events_view.station_name,
                       events_view.admin_name,
                       events_view.details,
                       events_view.latest_approval_type_id,
                       events_view.latest_approval
                FROM events_view
                JOIN stations ON stations.id = events_view.station_id
                JOIN stations scope ON scope.id = :stationId
                  AND (
                      (scope.level IN (1, 2) AND stations.id = scope.id)
                      OR ((scope.level IS NULL OR scope.level NOT IN (1, 2))
                          AND stations.station_code LIKE scope.station_code || '%')
                  )
                WHERE events_view.latest_approval_type_id IN (:supApproval, :supRejection, :mgtApproval, :mgtRejection)
                  AND EXTRACT(YEAR FROM events_view.latest_approval_stamp) = EXTRACT(YEAR FROM CURRENT_DATE)
                  AND NOT (
                      events_view.event_type = 'Disposal'
                      AND EXISTS (
                          SELECT 1 FROM asset_incidents
                          WHERE asset_incidents.event_register_id = events_view.event_id
                      )
                  )
                ORDER BY events_view.latest_approval_stamp DESC
                """, Map.of(
                "stationId",    stationId,
                "supApproval",  SUPERVISORY_APPROVAL_TYPE_ID,
                "supRejection", SUPERVISORY_REJECTION_TYPE_ID,
                "mgtApproval",  MANAGEMENT_APPROVAL_TYPE_ID,
                "mgtRejection", MANAGEMENT_REJECTION_TYPE_ID
        ));
    }

    // Events under the hierarchy approved by supervisory, awaiting management — role 50.
    public Result<List<Map<String, Object>>> managementPending(int stationId) {
        return base.fetch("""
                SELECT events_view.event_type,
                       events_view.entity_id,
                       events_view.event_id,
                       events_view.latest_approval_type_id,
                       to_char(events_view.event_date, 'DD/MM/YYYY')            AS event_date,
                       to_char(events_view.stamp, 'DD/MM/YYYY HH24:MI')         AS captured,
                       events_view.station_name,
                       events_view.admin_name,
                       events_view.details,
                       events_view.latest_approval
                FROM events_view
                JOIN stations ON stations.id = events_view.station_id
                JOIN stations scope ON stations.station_code LIKE scope.station_code || '%'
                WHERE scope.id = :stationId
                  AND events_view.latest_approval_type_id = :approvalTypeId
                ORDER BY events_view.stamp DESC
                """, Map.of("stationId", stationId, "approvalTypeId", SUPERVISORY_APPROVAL_TYPE_ID));
    }

    // Events under the hierarchy fully decided by management — history for role 50, current year.
    public Result<List<Map<String, Object>>> managementHistory(int stationId) {
        return base.fetch("""
                SELECT events_view.event_type,
                       events_view.entity_id,
                       events_view.event_id,
                       to_char(events_view.event_date, 'DD/MM/YYYY')    AS event_date,
                       to_char(events_view.stamp, 'DD/MM/YYYY HH24:MI') AS captured,
                       events_view.station_name,
                       events_view.admin_name,
                       events_view.details,
                       events_view.latest_approval_type_id,
                       events_view.latest_approval
                FROM events_view
                JOIN stations ON stations.id = events_view.station_id
                JOIN stations scope ON stations.station_code LIKE scope.station_code || '%'
                WHERE scope.id = :stationId
                  AND events_view.latest_approval_type_id IN (:approvalTypeId, :rejectionTypeId)
                  AND EXTRACT(YEAR FROM events_view.latest_approval_stamp) = EXTRACT(YEAR FROM CURRENT_DATE)
                  AND NOT (
                      events_view.event_type = 'Disposal'
                      AND EXISTS (
                          SELECT 1 FROM asset_incidents
                          WHERE asset_incidents.event_register_id = events_view.event_id
                      )
                  )
                ORDER BY events_view.latest_approval_stamp DESC
                """, Map.of("stationId", stationId, "approvalTypeId", MANAGEMENT_APPROVAL_TYPE_ID, "rejectionTypeId", MANAGEMENT_REJECTION_TYPE_ID));
    }

    // Insert (or update on conflict) an approval record for an event.
    public Result<Boolean> insertApproval(int eventId, int approvalTypeId, String notes, int adminId) {
        return base.execute("""
                INSERT INTO event_approvals (event_register_id, approval_type_id, approval_notes, event_admin_id)
                VALUES (:eventId, :approvalTypeId, :notes, :adminId)
                ON CONFLICT (event_register_id, approval_type_id) DO UPDATE
                  SET approval_notes = EXCLUDED.approval_notes,
                      event_admin_id = EXCLUDED.event_admin_id,
                      stamp          = CURRENT_TIMESTAMP
                """, Map.of(
                "eventId", eventId,
                "approvalTypeId", approvalTypeId,
                "notes", notes == null ? "" : notes,
                "adminId", adminId
        ));
    }

    // All approval records for a single event, ordered oldest to newest.
    public Result<List<Map<String, Object>>> getEventApprovals(int eventId) {
        return base.fetch("""
                SELECT
                    event_approvals.approval_type_id,
                    approval_types.name                                  AS approval,
                    staff_profiles.full_name                             AS approved_by,
                    event_approvals.approval_notes                       AS notes,
                    to_char(event_approvals.stamp, 'DD/MM/YYYY HH24:MI') AS stamp
                FROM event_approvals
                JOIN approval_types  ON approval_types.id  = event_approvals.approval_type_id
                JOIN staff_profiles  ON staff_profiles.id  = event_approvals.event_admin_id
                WHERE event_approvals.event_register_id = :eventId
                ORDER BY event_approvals.stamp ASC
                """, Map.of("eventId", eventId));
    }

}
