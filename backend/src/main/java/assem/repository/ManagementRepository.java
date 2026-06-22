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

    // All events at the station that have not yet received any approval.
    public Result<List<Map<String, Object>>> pending(int stationId) {
        return base.fetch("""
                SELECT me.event_type,
                       me.entity_id,
                       me.event_register_id,
                       to_char(me.stamp, 'DD/MM/YYYY') AS event_date,
                       sp.full_name                     AS submitted_by
                FROM view_management_events me
                JOIN staff_profiles sp ON sp.id = me.event_admin_id
                WHERE me.event_station_id = :stationId
                  AND NOT EXISTS (
                      SELECT 1 FROM event_approvals ea
                      WHERE ea.event_register_id = me.event_register_id
                  )
                ORDER BY me.stamp DESC
                """, Map.of("stationId", stationId));
    }

    // All events at the station that received an approval this calendar month.
    // Takes the most recent approval per event when multiple approval types exist.
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
