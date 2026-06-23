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

    private static final int SUPERVISORY_APPROVAL_TYPE_ID = 40;
    private static final int MANAGEMENT_APPROVAL_TYPE_ID  = 50;

    // Events at the station with no approval yet — visible to role 40 (supervisory).
    public Result<List<Map<String, Object>>> supervisoryPending(int stationId) {
        return base.fetch("""
                SELECT events_view.event_type,
                       events_view.entity_id,
                       events_view.event_id,
                       events_view.latest_approval_type_id,
                       to_char(events_view.event_date, 'DD/MM/YYYY')      AS event_date,
                       to_char(events_view.stamp, 'DD/MM/YYYY HH24:MI')   AS captured,
                       events_view.station_name,
                       events_view.admin_name,
                       events_view.details
                FROM events_view
                WHERE events_view.station_id = :stationId
                  AND events_view.latest_approval_type_id = 0
                ORDER BY events_view.stamp DESC
                """, Map.of("stationId", stationId));
    }

    // Events at the station approved by supervisory (type 40) — history for role 40.
    public Result<List<Map<String, Object>>> supervisoryHistory(int stationId) {
        return base.fetch("""
                SELECT events_view.event_type,
                       events_view.entity_id,
                       events_view.event_id,
                       to_char(events_view.event_date, 'DD/MM/YYYY')          AS event_date,
                       events_view.station_name,
                       events_view.admin_name,
                       events_view.latest_approval,
                       events_view.latest_approver_name,
                       to_char(events_view.latest_approval_stamp, 'DD/MM/YYYY') AS approval_date
                FROM events_view
                WHERE events_view.station_id = :stationId
                  AND events_view.latest_approval_type_id = :approvalTypeId
                ORDER BY events_view.latest_approval_stamp DESC
                """, Map.of("stationId", stationId, "approvalTypeId", SUPERVISORY_APPROVAL_TYPE_ID));
    }

    // Events at the station approved by supervisory, awaiting management — visible to role 50.
    public Result<List<Map<String, Object>>> managementPending(int stationId) {
        return base.fetch("""
                SELECT events_view.event_type,
                       events_view.entity_id,
                       events_view.event_id,
                       to_char(events_view.event_date, 'DD/MM/YYYY')          AS event_date,
                       events_view.station_name,
                       events_view.admin_name,
                       events_view.latest_approval,
                       events_view.latest_approver_name,
                       to_char(events_view.latest_approval_stamp, 'DD/MM/YYYY') AS approval_date
                FROM events_view
                WHERE events_view.station_id = :stationId
                  AND events_view.latest_approval_type_id = :approvalTypeId
                ORDER BY events_view.stamp DESC
                """, Map.of("stationId", stationId, "approvalTypeId", SUPERVISORY_APPROVAL_TYPE_ID));
    }

    // Events at the station fully approved by management (type 50) — history for role 50.
    public Result<List<Map<String, Object>>> managementHistory(int stationId) {
        return base.fetch("""
                SELECT events_view.event_type,
                       events_view.entity_id,
                       events_view.event_id,
                       to_char(events_view.event_date, 'DD/MM/YYYY')          AS event_date,
                       events_view.station_name,
                       events_view.admin_name,
                       events_view.latest_approval,
                       events_view.latest_approver_name,
                       to_char(events_view.latest_approval_stamp, 'DD/MM/YYYY') AS approval_date
                FROM events_view
                WHERE events_view.station_id = :stationId
                  AND events_view.latest_approval_type_id = :approvalTypeId
                ORDER BY events_view.latest_approval_stamp DESC
                """, Map.of("stationId", stationId, "approvalTypeId", MANAGEMENT_APPROVAL_TYPE_ID));
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
                    approval_types.name                               AS approval,
                    staff_profiles.full_name                          AS approved_by,
                    event_approvals.approval_notes                    AS notes,
                    to_char(event_approvals.stamp, 'DD/MM/YYYY HH24:MI') AS stamp
                FROM event_approvals
                JOIN approval_types  ON approval_types.id  = event_approvals.approval_type_id
                JOIN staff_profiles  ON staff_profiles.id  = event_approvals.event_admin_id
                WHERE event_approvals.event_register_id = :eventId
                ORDER BY event_approvals.stamp ASC
                """, Map.of("eventId", eventId));
    }

}
