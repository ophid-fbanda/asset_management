DROP VIEW IF EXISTS public.events_view;
CREATE VIEW public.events_view AS
 SELECT events.entity_id,
    events.event_id,
    events.station_id,
    events.admin_id,
    events.event_date,
    events.stamp,
    events.event_type,
    events.details,
    stations.station_name,
    staff_profiles.full_name AS admin_name,
    COALESCE(event_approvals.supervisor_status, 1) AS supervisor_status,
    COALESCE(event_approvals.manager_status, 1) AS manager_status,
    CASE
        WHEN (event_approvals.manager_status = 2) THEN 'Manager Approved'::character varying
        WHEN (event_approvals.manager_status = 3) THEN 'Manager Rejected'::character varying
        WHEN (event_approvals.supervisor_status = 2) THEN 'Supervisor Approved'::character varying
        WHEN (event_approvals.supervisor_status = 3) THEN 'Supervisor Rejected'::character varying
        ELSE 'Pending'::character varying
    END AS latest_approval,
    CASE
        WHEN (event_approvals.manager_status = 2) THEN 50
        WHEN (event_approvals.manager_status = 3) THEN 51
        WHEN (event_approvals.supervisor_status = 2) THEN 40
        WHEN (event_approvals.supervisor_status = 3) THEN 41
        ELSE 0
    END AS latest_approval_type_id,
    CASE
        WHEN (event_approvals.manager_status <> 1) THEN event_approvals.manager_notes
        WHEN (event_approvals.supervisor_status <> 1) THEN event_approvals.supervisor_notes
        ELSE NULL::text
    END AS latest_approval_notes,
    CASE
        WHEN (event_approvals.manager_status <> 1) THEN event_approvals.manager_id
        WHEN (event_approvals.supervisor_status <> 1) THEN event_approvals.supervisor_id
        ELSE NULL::integer
    END AS latest_approver_id,
    staff_profiles2.full_name AS latest_approver_name,
    CASE
        WHEN (event_approvals.manager_status <> 1) THEN event_approvals.manager_at
        WHEN (event_approvals.supervisor_status <> 1) THEN event_approvals.supervisor_at
        ELSE NULL::timestamp without time zone
    END AS latest_approval_stamp
   FROM (((((( SELECT asset_registrations.id AS entity_id,
            asset_registrations.event_register_id AS event_id,
            asset_registrations.event_station_id AS station_id,
            asset_registrations.event_admin_id AS admin_id,
            asset_registrations.event_date,
            asset_registrations.stamp,
            'Registration'::text AS event_type,
            ((((('Registration of '::text || (( SELECT count(*) AS count
                   FROM public.registered_assets
                  WHERE (registered_assets.asset_registration_id = asset_registrations.id)))::text) || ' item(s) from '::text) || (suppliers.supplier_name)::text) || ' via '::text) || (acquisition_types.name)::text) AS details
           FROM ((public.asset_registrations
             JOIN public.suppliers ON ((suppliers.id = asset_registrations.supplier_id)))
             JOIN public.acquisition_types ON ((acquisition_types.id = asset_registrations.acquisition_type_id)))
        UNION ALL
         SELECT asset_transfers.id,
            asset_transfers.event_register_id,
            asset_transfers.event_station_id,
            asset_transfers.event_admin_id,
            asset_transfers.event_date,
            asset_transfers.stamp,
            'Transfer'::text,
            ((('Transfer of '::text || (( SELECT count(*) AS count
                   FROM public.asset_transfer_items
                  WHERE (asset_transfer_items.asset_transfer_id = asset_transfers.id)))::text) || ' item(s) to '::text) || (receiving_station.station_name)::text)
           FROM (public.asset_transfers
             JOIN public.stations receiving_station ON ((receiving_station.id = asset_transfers.receiving_station_id)))
        UNION ALL
         SELECT asset_issuances.id,
            asset_issuances.event_register_id,
            asset_issuances.event_station_id,
            asset_issuances.event_admin_id,
            asset_issuances.event_date,
            asset_issuances.stamp,
            'Issuance'::text,
            ((('Issuance of '::text || (( SELECT count(*) AS count
                   FROM public.asset_issuance_items
                  WHERE (asset_issuance_items.asset_issuance_id = asset_issuances.id)))::text) || ' item(s) to '::text) || (receiving_staff.full_name)::text)
           FROM (public.asset_issuances
             JOIN public.staff_profiles receiving_staff ON ((receiving_staff.id = asset_issuances.receiving_staff_id)))
        UNION ALL
         SELECT asset_verifications.id,
            asset_verifications.event_register_id,
            asset_verifications.event_station_id,
            asset_verifications.event_admin_id,
            asset_verifications.event_date,
            asset_verifications.stamp,
            'Verification'::text,
            ((((((('Condition update of '::text || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text) || ' to '::text) || (condition_types.name)::text) || ' via '::text) || (verification_types.name)::text)
           FROM ((((((public.asset_verifications
             JOIN public.registered_assets ON ((registered_assets.id = asset_verifications.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.condition_types ON ((condition_types.id = asset_verifications.verified_condition_type_id)))
             JOIN public.verification_types ON ((verification_types.id = asset_verifications.verification_type_id)))
        UNION ALL
         SELECT asset_evaluations.id,
            asset_evaluations.event_register_id,
            asset_evaluations.event_station_id,
            asset_evaluations.event_admin_id,
            asset_evaluations.event_date,
            asset_evaluations.stamp,
            'Evaluation'::text,
            ((((((('Value update of '::text || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text) || ' to '::text) || (asset_evaluations.evaluated_value)::text) || ' as '::text) || (evaluation_types.name)::text)
           FROM (((((public.asset_evaluations
             JOIN public.registered_assets ON ((registered_assets.id = asset_evaluations.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.evaluation_types ON ((evaluation_types.id = asset_evaluations.evaluation_type_id)))
        UNION ALL
         SELECT asset_incidents.id,
            asset_incidents.event_register_id,
            asset_incidents.event_station_id,
            asset_incidents.event_admin_id,
            asset_incidents.event_date,
            asset_incidents.stamp,
            'Incident'::text,
            (((((incident_types.name)::text || ' of '::text) || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text)
           FROM (((((public.asset_incidents
             JOIN public.registered_assets ON ((registered_assets.id = asset_incidents.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.incident_types ON ((incident_types.id = asset_incidents.incident_type_id)))
        UNION ALL
         SELECT asset_requests.id,
            asset_requests.event_register_id,
            asset_requests.event_station_id,
            asset_requests.event_admin_id,
            asset_requests.event_date,
            asset_requests.stamp,
            'Request'::text,
            ((('Asset request for '::text || (( SELECT count(*) AS count
                   FROM public.asset_request_items
                  WHERE (asset_request_items.asset_request_id = asset_requests.id)))::text) || ' type(s) under '::text) || (programs.program_name)::text)
           FROM (public.asset_requests
             JOIN public.programs ON ((programs.id = asset_requests.request_program_id)))
        UNION ALL
         SELECT asset_placements.id,
            asset_placements.event_register_id,
            asset_placements.event_station_id,
            asset_placements.event_admin_id,
            asset_placements.event_date,
            asset_placements.stamp,
            'Placement'::text,
            ((((('Placement change of '::text || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text) || ' to '::text) || (placement_types.name)::text)
           FROM (((((public.asset_placements
             JOIN public.registered_assets ON ((registered_assets.id = asset_placements.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.placement_types ON ((placement_types.id = asset_placements.placement_type_id)))
        UNION ALL
         SELECT asset_disposals.id,
            asset_disposals.event_register_id,
            asset_disposals.event_station_id,
            asset_disposals.event_admin_id,
            asset_disposals.event_date,
            asset_disposals.stamp,
            'Disposal'::text,
            ((((('Disposal of '::text || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text) || ' via '::text) || (disposal_types.name)::text)
           FROM (((((public.asset_disposals
             JOIN public.registered_assets ON ((registered_assets.id = asset_disposals.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.disposal_types ON ((disposal_types.id = asset_disposals.disposal_type_id)))) events
     JOIN public.stations ON ((stations.id = events.station_id)))
     JOIN public.staff_profiles ON ((staff_profiles.id = events.admin_id)))
     LEFT JOIN public.event_approvals ON ((event_approvals.event_register_id = events.event_id)))
     LEFT JOIN public.staff_profiles staff_profiles2 ON ((staff_profiles2.id = CASE
        WHEN (event_approvals.manager_status <> 1) THEN event_approvals.manager_id
        WHEN (event_approvals.supervisor_status <> 1) THEN event_approvals.supervisor_id
        ELSE NULL::integer
    END)));
