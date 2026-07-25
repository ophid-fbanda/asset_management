-- Transfer location + issuance custodian take effect only after User Acceptance (10).
-- Apply against the live DB (CREATE OR REPLACE VIEW).

CREATE OR REPLACE VIEW public.assets_view AS
 SELECT registered_assets.id AS asset_id,
    asset_types.name AS asset_type,
    brand_types.name AS brand,
    model_types.name AS model,
    registered_assets.asset_number,
    registered_assets.serial_number,
    COALESCE(latest_condition.name, reg_condition.name) AS condition,
    COALESCE(latest_value.evaluated_value, registered_assets.acquisition_value) AS current_value,
    COALESCE(latest_custodian.staff_id, asset_registrations.event_admin_id) AS custodian_id,
    COALESCE(latest_custodian.full_name, reg_admin.full_name) AS custodian,
    COALESCE(latest_location.receiving_station_id, asset_registrations.event_station_id) AS station_id,
    COALESCE(latest_location.station_name, reg_station.station_name) AS station_name,
    (EXISTS ( SELECT 1
           FROM (public.asset_disposals
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_disposals.event_register_id) AND (event_approvals.approval_type_id = 50))))
          WHERE (asset_disposals.registered_asset_id = registered_assets.id))) AS disposed
   FROM ((((((((((((((public.registered_assets
     JOIN public.asset_registrations ON ((asset_registrations.id = registered_assets.asset_registration_id)))
     JOIN public.event_approvals reg_approval ON (((reg_approval.event_register_id = asset_registrations.event_register_id) AND (reg_approval.approval_type_id = 50))))
     JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
     JOIN public.model_types ON ((model_types.id = asset_models.model_type_id)))
     JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
     JOIN public.brand_types ON ((brand_types.id = asset_brands.brand_type_id)))
     JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
     JOIN public.condition_types reg_condition ON ((reg_condition.id = registered_assets.condition_type_id)))
     JOIN public.stations reg_station ON ((reg_station.id = asset_registrations.event_station_id)))
     JOIN public.staff_profiles reg_admin ON ((reg_admin.id = asset_registrations.event_admin_id)))
     LEFT JOIN LATERAL ( SELECT asset_transfers.receiving_station_id,
            stations.station_name
           FROM (((public.asset_transfer_items
             JOIN public.asset_transfers ON ((asset_transfers.id = asset_transfer_items.asset_transfer_id)))
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_transfers.event_register_id) AND (event_approvals.approval_type_id = 10))))
             JOIN public.stations ON ((stations.id = asset_transfers.receiving_station_id)))
          WHERE (asset_transfer_items.registered_asset_id = registered_assets.id)
          ORDER BY asset_transfers.stamp DESC
         LIMIT 1) latest_location ON (true))
     LEFT JOIN LATERAL ( SELECT condition_types.name
           FROM ((public.asset_verifications
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_verifications.event_register_id) AND (event_approvals.approval_type_id = 50))))
             JOIN public.condition_types ON ((condition_types.id = asset_verifications.verified_condition_type_id)))
          WHERE (asset_verifications.registered_asset_id = registered_assets.id)
          ORDER BY asset_verifications.stamp DESC
         LIMIT 1) latest_condition ON (true))
     LEFT JOIN LATERAL ( SELECT asset_evaluations.evaluated_value
           FROM (public.asset_evaluations
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_evaluations.event_register_id) AND (event_approvals.approval_type_id = 50))))
          WHERE (asset_evaluations.registered_asset_id = registered_assets.id)
          ORDER BY asset_evaluations.stamp DESC
         LIMIT 1) latest_value ON (true))
     LEFT JOIN LATERAL ( SELECT staff_profiles.id AS staff_id,
            staff_profiles.full_name
           FROM (((public.asset_issuance_items
             JOIN public.asset_issuances ON ((asset_issuances.id = asset_issuance_items.asset_issuance_id)))
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_issuances.event_register_id) AND (event_approvals.approval_type_id = 10))))
             JOIN public.staff_profiles ON ((staff_profiles.id = asset_issuances.receiving_staff_id)))
          WHERE (asset_issuance_items.registered_asset_id = registered_assets.id)
          ORDER BY asset_issuances.stamp DESC
         LIMIT 1) latest_custodian ON (true));

ALTER VIEW public.assets_view OWNER TO postgres;
