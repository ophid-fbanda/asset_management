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

CREATE VIEW events_view AS
    SELECT
        e.id AS entity_id,
        e.event_register_id AS event_id,
        e.event_station_id AS station_id,
        s.station_name,
        e.event_admin_id AS admin_id,
        sp.full_name AS admin_name,
        e.stamp::DATE AS event_date,
        e.stamp,
        'Registration' AS event_type
    FROM asset_registrations e
    JOIN stations s ON s.id = e.event_station_id
    JOIN staff_profiles sp ON sp.id = e.event_admin_id
    UNION ALL
    SELECT
        e.id, e.event_register_id, e.event_station_id, s.station_name,
        e.event_admin_id, sp.full_name, e.stamp::DATE, e.stamp, 'Transfer'
    FROM asset_transfers e
    JOIN stations s ON s.id = e.event_station_id
    JOIN staff_profiles sp ON sp.id = e.event_admin_id
    UNION ALL
    SELECT
        e.id, e.event_register_id, e.event_station_id, s.station_name,
        e.event_admin_id, sp.full_name, e.stamp::DATE, e.stamp, 'Issuance'
    FROM asset_issuances e
    JOIN stations s ON s.id = e.event_station_id
    JOIN staff_profiles sp ON sp.id = e.event_admin_id
    UNION ALL
    SELECT
        e.id, e.event_register_id, e.event_station_id, s.station_name,
        e.event_admin_id, sp.full_name, e.stamp::DATE, e.stamp, 'Verification'
    FROM asset_verifications e
    JOIN stations s ON s.id = e.event_station_id
    JOIN staff_profiles sp ON sp.id = e.event_admin_id
    UNION ALL
    SELECT
        e.id, e.event_register_id, e.event_station_id, s.station_name,
        e.event_admin_id, sp.full_name, e.stamp::DATE, e.stamp, 'Evaluation'
    FROM asset_evaluations e
    JOIN stations s ON s.id = e.event_station_id
    JOIN staff_profiles sp ON sp.id = e.event_admin_id
    UNION ALL
    SELECT
        e.id, e.event_register_id, e.event_station_id, s.station_name,
        e.event_admin_id, sp.full_name, e.stamp::DATE, e.stamp, 'Incident'
    FROM asset_incidents e
    JOIN stations s ON s.id = e.event_station_id
    JOIN staff_profiles sp ON sp.id = e.event_admin_id
    UNION ALL
    SELECT
        e.id, e.event_register_id, e.event_station_id, s.station_name,
        e.event_admin_id, sp.full_name, e.stamp::DATE, e.stamp, 'Request'
    FROM asset_requests e
    JOIN stations s ON s.id = e.event_station_id
    JOIN staff_profiles sp ON sp.id = e.event_admin_id
    UNION ALL
    SELECT
        e.id, e.event_register_id, e.event_station_id, s.station_name,
        e.event_admin_id, sp.full_name, e.stamp::DATE, e.stamp, 'Placement'
    FROM asset_placements e
    JOIN stations s ON s.id = e.event_station_id
    JOIN staff_profiles sp ON sp.id = e.event_admin_id
    UNION ALL
    SELECT
        e.id, e.event_register_id, e.event_station_id, s.station_name,
        e.event_admin_id, sp.full_name, e.stamp::DATE, e.stamp, 'Disposal'
    FROM asset_disposals e
    JOIN stations s ON s.id = e.event_station_id
    JOIN staff_profiles sp ON sp.id = e.event_admin_id;


-- UTILITY TABLES 
-- updates 
CREATE TABLE updates(
    id SERIAL PRIMARY KEY,
    notes TEXT,
    staff_id INT NOT NULL REFERENCES staff_profiles(id),
    seen BOOLEAN NOT NULL DEFAULT FALSE,
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
