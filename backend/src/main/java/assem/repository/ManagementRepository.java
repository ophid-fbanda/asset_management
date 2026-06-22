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

    // DEAD CODE — replaced by supervisoryHistory / managementHistory above.
    // Kept temporarily so the old ManagementController still compiles; remove once
    // the controller is deleted.
    @Deprecated
    public Result<List<Map<String, Object>>> history(int stationId) {
        return base.fetch("""
                SELECT 'Registration' AS event_type,
                       ar.id          AS entity_id,
                       ar.event_register_id,
                       to_char(ar.stamp, 'DD/MM/YYYY')  AS event_date,
                       sp.full_name                      AS submitted_by,
                       apt.name                          AS approval_status,
                       to_char(ea.stamp, 'DD/MM/YYYY')  AS approved_date,
                       approver.full_name                AS approved_by
                FROM asset_registrations ar
                JOIN staff_profiles sp ON sp.id = ar.event_admin_id
                JOIN LATERAL (
                    SELECT ea2.stamp, ea2.approval_type_id, ea2.event_admin_id
                    FROM event_approvals ea2
                    WHERE ea2.event_register_id = ar.event_register_id
                    ORDER BY ea2.stamp DESC
                    LIMIT 1
                ) ea ON TRUE
                JOIN approval_types apt ON apt.id = ea.approval_type_id
                JOIN staff_profiles approver ON approver.id = ea.event_admin_id
                WHERE ar.event_station_id = :stationId
                  AND date_trunc('month', ea.stamp) = date_trunc('month', CURRENT_DATE)

                UNION ALL

                SELECT 'Transfer'     AS event_type,
                       at.id          AS entity_id,
                       at.event_register_id,
                       to_char(at.stamp, 'DD/MM/YYYY')  AS event_date,
                       sp.full_name                      AS submitted_by,
                       apt.name                          AS approval_status,
                       to_char(ea.stamp, 'DD/MM/YYYY')  AS approved_date,
                       approver.full_name                AS approved_by
                FROM asset_transfers at
                JOIN staff_profiles sp ON sp.id = at.event_admin_id
                JOIN LATERAL (
                    SELECT ea2.stamp, ea2.approval_type_id, ea2.event_admin_id
                    FROM event_approvals ea2
                    WHERE ea2.event_register_id = at.event_register_id
                    ORDER BY ea2.stamp DESC
                    LIMIT 1
                ) ea ON TRUE
                JOIN approval_types apt ON apt.id = ea.approval_type_id
                JOIN staff_profiles approver ON approver.id = ea.event_admin_id
                WHERE at.event_station_id = :stationId
                  AND date_trunc('month', ea.stamp) = date_trunc('month', CURRENT_DATE)

                UNION ALL

                SELECT 'Issuance'     AS event_type,
                       ai.id          AS entity_id,
                       ai.event_register_id,
                       to_char(ai.stamp, 'DD/MM/YYYY')  AS event_date,
                       sp.full_name                      AS submitted_by,
                       apt.name                          AS approval_status,
                       to_char(ea.stamp, 'DD/MM/YYYY')  AS approved_date,
                       approver.full_name                AS approved_by
                FROM asset_issuances ai
                JOIN staff_profiles sp ON sp.id = ai.event_admin_id
                JOIN LATERAL (
                    SELECT ea2.stamp, ea2.approval_type_id, ea2.event_admin_id
                    FROM event_approvals ea2
                    WHERE ea2.event_register_id = ai.event_register_id
                    ORDER BY ea2.stamp DESC
                    LIMIT 1
                ) ea ON TRUE
                JOIN approval_types apt ON apt.id = ea.approval_type_id
                JOIN staff_profiles approver ON approver.id = ea.event_admin_id
                WHERE ai.event_station_id = :stationId
                  AND date_trunc('month', ea.stamp) = date_trunc('month', CURRENT_DATE)

                UNION ALL

                SELECT 'Verification' AS event_type,
                       av.id          AS entity_id,
                       av.event_register_id,
                       to_char(av.stamp, 'DD/MM/YYYY')  AS event_date,
                       sp.full_name                      AS submitted_by,
                       apt.name                          AS approval_status,
                       to_char(ea.stamp, 'DD/MM/YYYY')  AS approved_date,
                       approver.full_name                AS approved_by
                FROM asset_verifications av
                JOIN staff_profiles sp ON sp.id = av.event_admin_id
                JOIN LATERAL (
                    SELECT ea2.stamp, ea2.approval_type_id, ea2.event_admin_id
                    FROM event_approvals ea2
                    WHERE ea2.event_register_id = av.event_register_id
                    ORDER BY ea2.stamp DESC
                    LIMIT 1
                ) ea ON TRUE
                JOIN approval_types apt ON apt.id = ea.approval_type_id
                JOIN staff_profiles approver ON approver.id = ea.event_admin_id
                WHERE av.event_station_id = :stationId
                  AND date_trunc('month', ea.stamp) = date_trunc('month', CURRENT_DATE)

                UNION ALL

                SELECT 'Evaluation'   AS event_type,
                       ae.id          AS entity_id,
                       ae.event_register_id,
                       to_char(ae.stamp, 'DD/MM/YYYY')  AS event_date,
                       sp.full_name                      AS submitted_by,
                       apt.name                          AS approval_status,
                       to_char(ea.stamp, 'DD/MM/YYYY')  AS approved_date,
                       approver.full_name                AS approved_by
                FROM asset_evaluations ae
                JOIN staff_profiles sp ON sp.id = ae.event_admin_id
                JOIN LATERAL (
                    SELECT ea2.stamp, ea2.approval_type_id, ea2.event_admin_id
                    FROM event_approvals ea2
                    WHERE ea2.event_register_id = ae.event_register_id
                    ORDER BY ea2.stamp DESC
                    LIMIT 1
                ) ea ON TRUE
                JOIN approval_types apt ON apt.id = ea.approval_type_id
                JOIN staff_profiles approver ON approver.id = ea.event_admin_id
                WHERE ae.event_station_id = :stationId
                  AND date_trunc('month', ea.stamp) = date_trunc('month', CURRENT_DATE)

                UNION ALL

                SELECT 'Incident'     AS event_type,
                       ai.id          AS entity_id,
                       ai.event_register_id,
                       to_char(ai.stamp, 'DD/MM/YYYY')  AS event_date,
                       sp.full_name                      AS submitted_by,
                       apt.name                          AS approval_status,
                       to_char(ea.stamp, 'DD/MM/YYYY')  AS approved_date,
                       approver.full_name                AS approved_by
                FROM asset_incidents ai
                JOIN staff_profiles sp ON sp.id = ai.event_admin_id
                JOIN LATERAL (
                    SELECT ea2.stamp, ea2.approval_type_id, ea2.event_admin_id
                    FROM event_approvals ea2
                    WHERE ea2.event_register_id = ai.event_register_id
                    ORDER BY ea2.stamp DESC
                    LIMIT 1
                ) ea ON TRUE
                JOIN approval_types apt ON apt.id = ea.approval_type_id
                JOIN staff_profiles approver ON approver.id = ea.event_admin_id
                WHERE ai.event_station_id = :stationId
                  AND date_trunc('month', ea.stamp) = date_trunc('month', CURRENT_DATE)

                UNION ALL

                SELECT 'Request'      AS event_type,
                       ar.id          AS entity_id,
                       ar.event_register_id,
                       to_char(ar.stamp, 'DD/MM/YYYY')  AS event_date,
                       sp.full_name                      AS submitted_by,
                       apt.name                          AS approval_status,
                       to_char(ea.stamp, 'DD/MM/YYYY')  AS approved_date,
                       approver.full_name                AS approved_by
                FROM asset_requests ar
                JOIN staff_profiles sp ON sp.id = ar.event_admin_id
                JOIN LATERAL (
                    SELECT ea2.stamp, ea2.approval_type_id, ea2.event_admin_id
                    FROM event_approvals ea2
                    WHERE ea2.event_register_id = ar.event_register_id
                    ORDER BY ea2.stamp DESC
                    LIMIT 1
                ) ea ON TRUE
                JOIN approval_types apt ON apt.id = ea.approval_type_id
                JOIN staff_profiles approver ON approver.id = ea.event_admin_id
                WHERE ar.event_station_id = :stationId
                  AND date_trunc('month', ea.stamp) = date_trunc('month', CURRENT_DATE)

                UNION ALL

                SELECT 'Placement'    AS event_type,
                       ap.id          AS entity_id,
                       ap.event_register_id,
                       to_char(ap.stamp, 'DD/MM/YYYY')  AS event_date,
                       sp.full_name                      AS submitted_by,
                       apt.name                          AS approval_status,
                       to_char(ea.stamp, 'DD/MM/YYYY')  AS approved_date,
                       approver.full_name                AS approved_by
                FROM asset_placements ap
                JOIN staff_profiles sp ON sp.id = ap.event_admin_id
                JOIN LATERAL (
                    SELECT ea2.stamp, ea2.approval_type_id, ea2.event_admin_id
                    FROM event_approvals ea2
                    WHERE ea2.event_register_id = ap.event_register_id
                    ORDER BY ea2.stamp DESC
                    LIMIT 1
                ) ea ON TRUE
                JOIN approval_types apt ON apt.id = ea.approval_type_id
                JOIN staff_profiles approver ON approver.id = ea.event_admin_id
                WHERE ap.event_station_id = :stationId
                  AND date_trunc('month', ea.stamp) = date_trunc('month', CURRENT_DATE)

                UNION ALL

                SELECT 'Disposal'     AS event_type,
                       ad.id          AS entity_id,
                       ad.event_register_id,
                       to_char(ad.stamp, 'DD/MM/YYYY')  AS event_date,
                       sp.full_name                      AS submitted_by,
                       apt.name                          AS approval_status,
                       to_char(ea.stamp, 'DD/MM/YYYY')  AS approved_date,
                       approver.full_name                AS approved_by
                FROM asset_disposals ad
                JOIN staff_profiles sp ON sp.id = ad.event_admin_id
                JOIN LATERAL (
                    SELECT ea2.stamp, ea2.approval_type_id, ea2.event_admin_id
                    FROM event_approvals ea2
                    WHERE ea2.event_register_id = ad.event_register_id
                    ORDER BY ea2.stamp DESC
                    LIMIT 1
                ) ea ON TRUE
                JOIN approval_types apt ON apt.id = ea.approval_type_id
                JOIN staff_profiles approver ON approver.id = ea.event_admin_id
                WHERE ad.event_station_id = :stationId
                  AND date_trunc('month', ea.stamp) = date_trunc('month', CURRENT_DATE)

                ORDER BY approved_date DESC
                """, Map.of("stationId", stationId));
    }
}
