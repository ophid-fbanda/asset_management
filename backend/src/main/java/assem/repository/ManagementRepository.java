package assem.repository;

import assem.exchange.commons.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ManagementRepository {

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
                       to_char(events_view.event_date, 'DD/MM/YYYY') AS event_date,
                       events_view.station_name,
                       events_view.admin_name
                FROM events_view
                WHERE events_view.station_id = :stationId
                  AND events_view.latest_approval IS NULL
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

}
