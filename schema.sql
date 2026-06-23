-- LOOK UP TABLES

--roles
CREATE TABLE role_types(
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);


--assets
CREATE TABLE asset_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

--brands
CREATE TABLE brand_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- models
CREATE TABLE model_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);


--acquisitions
CREATE TABLE acquisition_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

--references
CREATE TABLE reference_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- conditions
CREATE TABLE condition_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- evaluations
CREATE TABLE evaluation_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- verifications
CREATE TABLE verification_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- incidents
CREATE TABLE incident_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- issuances
CREATE TABLE issuance_types(
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

--placements
CREATE TABLE placement_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);


--approvals
CREATE TABLE approval_types(
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

--disposals
CREATE TABLE disposal_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);





-- COMPOSITE LOOKUPS
--stations 
CREATE TABLE stations(
    id SERIAL PRIMARY KEY,
    station_code VARCHAR(255) NOT NULL UNIQUE,
    station_name VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8)
);

-- asset_brands
CREATE TABLE asset_brands(
    id SERIAL PRIMARY KEY,
    asset_type_id INT NOT NULL REFERENCES asset_types(id),
    brand_type_id INT NOT NULL REFERENCES brand_types(id),
    UNIQUE(asset_type_id, brand_type_id)
);

-- asset_models
CREATE TABLE asset_models(
    id SERIAL PRIMARY KEY,
    asset_brand_id INT NOT NULL REFERENCES asset_brands(id),
    model_type_id INT NOT NULL REFERENCES model_types(id),
    UNIQUE(asset_brand_id, model_type_id)
);


-- MAIN ENTITIES
--staff
CREATE TABLE staff_profiles(
    id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    staff_email VARCHAR(255) NOT NULL UNIQUE,
    staff_phone VARCHAR(255) NOT NULL UNIQUE
);

--accounts 
CREATE TABLE staff_accounts(
    id SERIAL PRIMARY KEY,
    staff_profile_id INT NOT NULL REFERENCES staff_profiles(id) UNIQUE,
    secret_key text NOT NULL
);

--roles
CREATE TABLE staff_roles(
    id SERIAL PRIMARY KEY,
    staff_profile_id INT NOT NULL REFERENCES staff_profiles(id),
    role_type_id INT NOT NULL REFERENCES role_types(id),
    role_station_id INT NOT NULL REFERENCES stations(id),
    UNIQUE(staff_profile_id, role_type_id, role_station_id)
);

-- programs
CREATE TABLE programs(
    id SERIAL PRIMARY KEY,
    program_code VARCHAR(255) NOT NULL UNIQUE,
    program_name VARCHAR(255) NOT NULL
);

--suppliers
CREATE TABLE suppliers(
    id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL UNIQUE
);


-- EVENTS TABLES

--event register 
CREATE TABLE event_register(
    id SERIAL PRIMARY KEY
);

-- asset registration 
CREATE TABLE asset_registrations(
    id SERIAL PRIMARY KEY,
    program_id INT NOT NULL REFERENCES programs(id),
    acquisition_type_id INT NOT NULL REFERENCES acquisition_types(id),
    reference_attachment VARCHAR(255) NOT NULL,
    reference_type_id INT NOT NULL REFERENCES reference_types(id),
    reference_date DATE NOT NULL,
    supplier_id INT NOT NULL REFERENCES suppliers(id),
    notes TEXT,
    event_register_id INT NOT NULL REFERENCES event_register(id) UNIQUE,
    event_station_id INT NOT NULL REFERENCES stations(id),
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--assets
CREATE TABLE registered_assets(
    id SERIAL PRIMARY KEY,
    asset_registration_id INT NOT NULL REFERENCES asset_registrations(id),
    asset_model_id INT NOT NULL REFERENCES asset_models(id),
    serial_number VARCHAR(255) NOT NULL UNIQUE,
    asset_number VARCHAR(255) UNIQUE,
    condition_type_id INT NOT NULL REFERENCES condition_types(id),
    acquisition_value DECIMAL(10, 2) NOT NULL CHECK(acquisition_value > 0)
);


-- transfers 
CREATE TABLE asset_transfers(
    id SERIAL PRIMARY KEY,
    receiving_station_id INT NOT NULL REFERENCES stations(id),
    notes TEXT,
    event_register_id INT NOT NULL REFERENCES event_register(id) UNIQUE,
    event_station_id INT NOT NULL REFERENCES stations(id),
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    check(event_station_id != receiving_station_id)
);

-- transfer items
CREATE TABLE asset_transfer_items(
    id SERIAL PRIMARY KEY,
    asset_transfer_id INT NOT NULL REFERENCES asset_transfers(id),
    registered_asset_id INT NOT NULL REFERENCES registered_assets(id),
    UNIQUE(asset_transfer_id, registered_asset_id)
);

--issuances
CREATE TABLE asset_issuances(
    id SERIAL PRIMARY KEY,
    receiving_staff_id INT NOT NULL REFERENCES staff_profiles(id),
    notes TEXT,
    event_register_id INT NOT NULL REFERENCES event_register(id) UNIQUE,
    event_station_id INT NOT NULL REFERENCES stations(id),
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--issuance items
CREATE TABLE asset_issuance_items(
    id SERIAL PRIMARY KEY,
    registered_asset_id INT NOT NULL REFERENCES registered_assets(id),
    asset_issuance_id INT NOT NULL REFERENCES asset_issuances(id),
    issued_asset_type_id INT NOT NULL REFERENCES asset_types(id),
    UNIQUE(asset_issuance_id, registered_asset_id)
);

-- verifications
CREATE TABLE asset_verifications(
    id SERIAL PRIMARY KEY,
    registered_asset_id INT NOT NULL REFERENCES registered_assets(id),
    verification_type_id INT NOT NULL REFERENCES verification_types(id),
    verified_condition_type_id INT NOT NULL REFERENCES condition_types(id),
    event_notes TEXT,
    event_register_id INT NOT NULL REFERENCES event_register(id) UNIQUE,
    event_station_id INT NOT NULL REFERENCES stations(id),
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- evaluations
CREATE TABLE asset_evaluations(
    id SERIAL PRIMARY KEY,
    registered_asset_id INT NOT NULL REFERENCES registered_assets(id),
    evaluation_type_id INT NOT NULL REFERENCES evaluation_types(id),
    evaluated_value DECIMAL(10, 2) NOT NULL CHECK(evaluated_value > 0),
    event_notes TEXT,
    event_register_id INT NOT NULL REFERENCES event_register(id) UNIQUE,
    event_station_id INT NOT NULL REFERENCES stations(id),
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- incidents
CREATE TABLE asset_incidents(
    id SERIAL PRIMARY KEY,
    registered_asset_id INT NOT NULL REFERENCES registered_assets(id),
    incident_type_id INT NOT NULL REFERENCES incident_types(id),
    event_notes TEXT,
    incident_asset_image VARCHAR(255),
    incident_police_report VARCHAR(255),
    event_register_id INT NOT NULL REFERENCES event_register(id) UNIQUE,
    event_station_id INT NOT NULL REFERENCES stations(id),
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- requests
CREATE TABLE asset_requests(
    id SERIAL PRIMARY KEY,
    event_notes TEXT,
    event_register_id INT NOT NULL REFERENCES event_register(id) UNIQUE,
    request_program_id INT NOT NULL REFERENCES programs(id),
    event_station_id INT NOT NULL REFERENCES stations(id),
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- request items
CREATE TABLE asset_request_items(
    id SERIAL PRIMARY KEY,
    asset_request_id INT NOT NULL REFERENCES asset_requests(id),
    requested_asset_type_id INT NOT NULL REFERENCES asset_types(id),
    requested_quantity INT NOT NULL CHECK(requested_quantity > 0),
    UNIQUE(asset_request_id, requested_asset_type_id)
);

--placements
CREATE TABLE asset_placements(
    id SERIAL PRIMARY KEY,
    registered_asset_id INT NOT NULL REFERENCES registered_assets(id),
    placement_type_id INT NOT NULL REFERENCES placement_types(id),
    event_notes TEXT,
    event_register_id INT NOT NULL REFERENCES event_register(id) UNIQUE,
    event_station_id INT NOT NULL REFERENCES stations(id),
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--disposals
CREATE TABLE asset_disposals(
    id SERIAL PRIMARY KEY,
    registered_asset_id INT NOT NULL REFERENCES registered_assets(id),
    disposal_type_id INT NOT NULL REFERENCES disposal_types(id),
    event_notes TEXT,
    event_register_id INT NOT NULL REFERENCES event_register(id) UNIQUE,
    event_station_id INT NOT NULL REFERENCES stations(id),
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);




--event approvals
CREATE TABLE event_approvals(
    id SERIAL PRIMARY KEY,
    event_register_id INT NOT NULL REFERENCES event_register(id),
    approval_type_id INT NOT NULL REFERENCES approval_types(id),
    approval_notes TEXT,
    event_admin_id INT NOT NULL REFERENCES staff_profiles(id),
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(event_register_id, approval_type_id)
);


-- VIEWS

DROP VIEW IF EXISTS events_view;
CREATE VIEW events_view AS
    SELECT
        events.*,
        stations.station_name,
        staff_profiles.full_name AS admin_name,
        COALESCE(approval_types.name, 'Pending') AS latest_approval,
        COALESCE(event_approvals.approval_type_id, 0) AS latest_approval_type_id,
        event_approvals.approval_notes AS latest_approval_notes,
        event_approvals.event_admin_id AS latest_approver_id,
        staff_profiles2.full_name AS latest_approver_name,
        event_approvals.stamp AS latest_approval_stamp
    FROM (
        -- Registration
        SELECT
            asset_registrations.id AS entity_id,
            asset_registrations.event_register_id AS event_id,
            asset_registrations.event_station_id AS station_id,
            asset_registrations.event_admin_id AS admin_id,
            asset_registrations.stamp::DATE AS event_date,
            asset_registrations.stamp,
            'Registration' AS event_type,
            'Registration of '
                || (SELECT COUNT(*) FROM registered_assets WHERE registered_assets.asset_registration_id = asset_registrations.id)::TEXT
                || ' item(s) from '
                || suppliers.supplier_name
                || ' via '
                || acquisition_types.name AS details
        FROM asset_registrations
        JOIN suppliers         ON suppliers.id          = asset_registrations.supplier_id
        JOIN acquisition_types ON acquisition_types.id  = asset_registrations.acquisition_type_id

        UNION ALL

        -- Transfer
        SELECT
            asset_transfers.id,
            asset_transfers.event_register_id,
            asset_transfers.event_station_id,
            asset_transfers.event_admin_id,
            asset_transfers.stamp::DATE,
            asset_transfers.stamp,
            'Transfer',
            'Transfer of '
                || (SELECT COUNT(*) FROM asset_transfer_items WHERE asset_transfer_items.asset_transfer_id = asset_transfers.id)::TEXT
                || ' item(s) to '
                || receiving_station.station_name
        FROM asset_transfers
        JOIN stations AS receiving_station ON receiving_station.id = asset_transfers.receiving_station_id

        UNION ALL

        -- Issuance
        SELECT
            asset_issuances.id,
            asset_issuances.event_register_id,
            asset_issuances.event_station_id,
            asset_issuances.event_admin_id,
            asset_issuances.stamp::DATE,
            asset_issuances.stamp,
            'Issuance',
            'Issuance of '
                || (SELECT COUNT(*) FROM asset_issuance_items WHERE asset_issuance_items.asset_issuance_id = asset_issuances.id)::TEXT
                || ' item(s) to '
                || receiving_staff.full_name
        FROM asset_issuances
        JOIN staff_profiles AS receiving_staff ON receiving_staff.id = asset_issuances.receiving_staff_id

        UNION ALL

        -- Verification
        SELECT
            asset_verifications.id,
            asset_verifications.event_register_id,
            asset_verifications.event_station_id,
            asset_verifications.event_admin_id,
            asset_verifications.stamp::DATE,
            asset_verifications.stamp,
            'Verification',
            'Condition update of '
                || asset_types.name
                || ' '
                || COALESCE(registered_assets.asset_number, registered_assets.serial_number)
                || ' to '
                || condition_types.name
                || ' via '
                || verification_types.name
        FROM asset_verifications
        JOIN registered_assets  ON registered_assets.id  = asset_verifications.registered_asset_id
        JOIN asset_models       ON asset_models.id        = registered_assets.asset_model_id
        JOIN asset_brands       ON asset_brands.id        = asset_models.asset_brand_id
        JOIN asset_types        ON asset_types.id         = asset_brands.asset_type_id
        JOIN condition_types    ON condition_types.id     = asset_verifications.verified_condition_type_id
        JOIN verification_types ON verification_types.id  = asset_verifications.verification_type_id

        UNION ALL

        -- Evaluation
        SELECT
            asset_evaluations.id,
            asset_evaluations.event_register_id,
            asset_evaluations.event_station_id,
            asset_evaluations.event_admin_id,
            asset_evaluations.stamp::DATE,
            asset_evaluations.stamp,
            'Evaluation',
            'Value update of '
                || asset_types.name
                || ' '
                || COALESCE(registered_assets.asset_number, registered_assets.serial_number)
                || ' to '
                || asset_evaluations.evaluated_value::TEXT
                || ' as '
                || evaluation_types.name
        FROM asset_evaluations
        JOIN registered_assets ON registered_assets.id = asset_evaluations.registered_asset_id
        JOIN asset_models      ON asset_models.id       = registered_assets.asset_model_id
        JOIN asset_brands      ON asset_brands.id       = asset_models.asset_brand_id
        JOIN asset_types       ON asset_types.id        = asset_brands.asset_type_id
        JOIN evaluation_types  ON evaluation_types.id  = asset_evaluations.evaluation_type_id

        UNION ALL

        -- Incident
        SELECT
            asset_incidents.id,
            asset_incidents.event_register_id,
            asset_incidents.event_station_id,
            asset_incidents.event_admin_id,
            asset_incidents.stamp::DATE,
            asset_incidents.stamp,
            'Incident',
            incident_types.name
                || ' of '
                || asset_types.name
                || ' '
                || COALESCE(registered_assets.asset_number, registered_assets.serial_number)
        FROM asset_incidents
        JOIN registered_assets ON registered_assets.id = asset_incidents.registered_asset_id
        JOIN asset_models      ON asset_models.id       = registered_assets.asset_model_id
        JOIN asset_brands      ON asset_brands.id       = asset_models.asset_brand_id
        JOIN asset_types       ON asset_types.id        = asset_brands.asset_type_id
        JOIN incident_types    ON incident_types.id    = asset_incidents.incident_type_id

        UNION ALL

        -- Request
        SELECT
            asset_requests.id,
            asset_requests.event_register_id,
            asset_requests.event_station_id,
            asset_requests.event_admin_id,
            asset_requests.stamp::DATE,
            asset_requests.stamp,
            'Request',
            'Asset request for '
                || (SELECT COUNT(*) FROM asset_request_items WHERE asset_request_items.asset_request_id = asset_requests.id)::TEXT
                || ' type(s) under '
                || programs.program_name
        FROM asset_requests
        JOIN programs ON programs.id = asset_requests.request_program_id

        UNION ALL

        -- Placement
        SELECT
            asset_placements.id,
            asset_placements.event_register_id,
            asset_placements.event_station_id,
            asset_placements.event_admin_id,
            asset_placements.stamp::DATE,
            asset_placements.stamp,
            'Placement',
            'Placement change of '
                || asset_types.name
                || ' '
                || COALESCE(registered_assets.asset_number, registered_assets.serial_number)
                || ' to '
                || placement_types.name
        FROM asset_placements
        JOIN registered_assets ON registered_assets.id = asset_placements.registered_asset_id
        JOIN asset_models      ON asset_models.id       = registered_assets.asset_model_id
        JOIN asset_brands      ON asset_brands.id       = asset_models.asset_brand_id
        JOIN asset_types       ON asset_types.id        = asset_brands.asset_type_id
        JOIN placement_types   ON placement_types.id   = asset_placements.placement_type_id

        UNION ALL

        -- Disposal
        SELECT
            asset_disposals.id,
            asset_disposals.event_register_id,
            asset_disposals.event_station_id,
            asset_disposals.event_admin_id,
            asset_disposals.stamp::DATE,
            asset_disposals.stamp,
            'Disposal',
            'Disposal of '
                || asset_types.name
                || ' '
                || COALESCE(registered_assets.asset_number, registered_assets.serial_number)
                || ' via '
                || disposal_types.name
        FROM asset_disposals
        JOIN registered_assets ON registered_assets.id = asset_disposals.registered_asset_id
        JOIN asset_models      ON asset_models.id       = registered_assets.asset_model_id
        JOIN asset_brands      ON asset_brands.id       = asset_models.asset_brand_id
        JOIN asset_types       ON asset_types.id        = asset_brands.asset_type_id
        JOIN disposal_types    ON disposal_types.id    = asset_disposals.disposal_type_id
    ) AS events
    JOIN stations ON stations.id = events.station_id
    JOIN staff_profiles ON staff_profiles.id = events.admin_id
    LEFT JOIN LATERAL (
        SELECT * FROM event_approvals AS t1
        WHERE t1.event_register_id = events.event_id
        ORDER BY t1.stamp DESC
        LIMIT 1
    ) event_approvals ON true
    LEFT JOIN approval_types ON approval_types.id = event_approvals.approval_type_id
    LEFT JOIN staff_profiles AS staff_profiles2 ON staff_profiles2.id = event_approvals.event_admin_id;


-- UTILITY TABLES 
-- ASSETS VIEW
-- Canonical current state of every registered asset.
-- Each attribute COALESCEs the latest fully-approved (management = 50) event
-- result with the value recorded at registration time.

DROP VIEW IF EXISTS view_assets;
CREATE VIEW view_assets AS
    SELECT
        registered_assets.id                                                        AS asset_id,
        asset_types.name                                                            AS asset_type,
        brand_types.name                                                            AS brand,
        model_types.name                                                            AS model,
        registered_assets.asset_number,
        registered_assets.serial_number,
        COALESCE(latest_condition.name,
                 reg_condition.name)                                                AS condition,
        COALESCE(latest_value.evaluated_value,
                 registered_assets.acquisition_value)                              AS current_value,
        latest_custodian.full_name                                                  AS custodian,
        COALESCE(latest_location.receiving_station_id,
                 asset_registrations.event_station_id)                             AS station_id,
        COALESCE(latest_location.station_name,
                 reg_station.station_name)                                         AS station_name
    FROM registered_assets
    JOIN asset_registrations
        ON asset_registrations.id      = registered_assets.asset_registration_id
    JOIN asset_models
        ON asset_models.id             = registered_assets.asset_model_id
    JOIN model_types
        ON model_types.id              = asset_models.model_type_id
    JOIN asset_brands
        ON asset_brands.id             = asset_models.asset_brand_id
    JOIN brand_types
        ON brand_types.id              = asset_brands.brand_type_id
    JOIN asset_types
        ON asset_types.id              = asset_brands.asset_type_id
    JOIN condition_types reg_condition
        ON reg_condition.id            = registered_assets.condition_type_id
    JOIN stations reg_station
        ON reg_station.id              = asset_registrations.event_station_id

    -- Current location: latest management-approved transfer destination
    LEFT JOIN LATERAL (
        SELECT asset_transfers.receiving_station_id,
               stations.station_name
        FROM asset_transfer_items
        JOIN asset_transfers
            ON asset_transfers.id                = asset_transfer_items.asset_transfer_id
        JOIN event_approvals
            ON event_approvals.event_register_id = asset_transfers.event_register_id
           AND event_approvals.approval_type_id  = 50
        JOIN stations
            ON stations.id                       = asset_transfers.receiving_station_id
        WHERE asset_transfer_items.registered_asset_id = registered_assets.id
        ORDER BY asset_transfers.stamp DESC
        LIMIT 1
    ) latest_location ON true

    -- Current condition: latest management-approved verification result
    LEFT JOIN LATERAL (
        SELECT condition_types.name
        FROM asset_verifications
        JOIN event_approvals
            ON event_approvals.event_register_id = asset_verifications.event_register_id
           AND event_approvals.approval_type_id  = 50
        JOIN condition_types
            ON condition_types.id                = asset_verifications.verified_condition_type_id
        WHERE asset_verifications.registered_asset_id = registered_assets.id
        ORDER BY asset_verifications.stamp DESC
        LIMIT 1
    ) latest_condition ON true

    -- Current value: latest management-approved evaluation
    LEFT JOIN LATERAL (
        SELECT asset_evaluations.evaluated_value
        FROM asset_evaluations
        JOIN event_approvals
            ON event_approvals.event_register_id = asset_evaluations.event_register_id
           AND event_approvals.approval_type_id  = 50
        WHERE asset_evaluations.registered_asset_id = registered_assets.id
        ORDER BY asset_evaluations.stamp DESC
        LIMIT 1
    ) latest_value ON true

    -- Current custodian: latest management-approved issuance recipient
    LEFT JOIN LATERAL (
        SELECT staff_profiles.full_name
        FROM asset_issuance_items
        JOIN asset_issuances
            ON asset_issuances.id                = asset_issuance_items.asset_issuance_id
        JOIN event_approvals
            ON event_approvals.event_register_id = asset_issuances.event_register_id
           AND event_approvals.approval_type_id  = 50
        JOIN staff_profiles
            ON staff_profiles.id                 = asset_issuances.receiving_staff_id
        WHERE asset_issuance_items.registered_asset_id = registered_assets.id
        ORDER BY asset_issuances.stamp DESC
        LIMIT 1
    ) latest_custodian ON true;


-- updates 
CREATE TABLE updates(
    id SERIAL PRIMARY KEY,
    notes TEXT,
    staff_id INT NOT NULL REFERENCES staff_profiles(id),
    seen BOOLEAN NOT NULL DEFAULT FALSE,
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
