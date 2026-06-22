-- Active: 1778676347520@@127.0.0.1@14577@assem
-- roles
INSERT INTO role_types (id, name) VALUES
    (10, 'General User'),
    (20, 'Assets Administrator'),
    (30, 'Auctions Administrator'),
    (40, 'Supervisor'),
    (50, 'Manager'),
    (60, 'Auditor'),
    (70, 'Users Administrator'),
    (80, 'System Administrator');

-- assets
INSERT INTO asset_types (name) VALUES
    ('Laptop'),
    ('Cellphone');

-- brands
INSERT INTO brand_types (name) VALUES
    ('HP'),
    ('Samsung'),
    ('Lenovo'),
    ('Dell'),
    ('Honor');

-- models
INSERT INTO model_types (name) VALUES
    ('ProBook 450 G12'),
    ('Galaxy Book Pro'),
    ('Samsung Galaxy S23'),
    ('Honor 100'),
    ('ThinkPad T490'),
    ('Latitude 5490');

-- acquisitions
INSERT INTO acquisition_types (name) VALUES
    ('Purchase'),
    ('Grant'),
    ('Donation'),
    ('Other');

-- references
INSERT INTO reference_types (name) VALUES
    ('Invoice'),
    ('Receipt'),
    ('Goods Received Voucher'),
    ('Other');

-- conditions
INSERT INTO condition_types (name) VALUES
    ('New'),
    ('Good'),
    ('Fair'),
    ('Poor'),
    ('Damaged'),
    ('Other');

-- evaluations
INSERT INTO evaluation_types (name) VALUES
    ('Depreciated'),
    ('Market Value'),
    ('Correction Value'),
    ('Impairment'),
    ('Other');

-- verifications
INSERT INTO verification_types (name) VALUES
    ('Routine Verification'),
    ('Adhoc Verification'),
    ('Pre-Transfer/Issuance Verification'),
    ('Disposal Verification'),
    ('Other');

-- incidents
INSERT INTO incident_types (name) VALUES
    ('Theft'),
    ('Missing'),
    ('Damage'),
    ('Malfunction'),
    ('Misuse'),
    ('Other');

-- issuances
INSERT INTO issuance_types (id, name) VALUES
    (1, 'Keep'),
    (2, 'Use');

-- placements
INSERT INTO placement_types (name) VALUES
    ('Office'),
    ('Field'),
    ('Lent Out'),
    ('Sent for Repair/Service'),
    ('Other');

-- approvals
INSERT INTO approval_types (id, name) VALUES
    (10, 'User Acceptance'),
    (11, 'User Declined'),
    (40, 'Supervisor Approval'),
    (41, 'Supervisor Rejection'),
    (50, 'Manager Approval'),
    (51, 'Manager Rejection');

-- disposals
INSERT INTO disposal_types (name) VALUES
    ('Sale'),
    ('Donation'),
    ('Auction'),
    ('Incidental'),
    ('Other');

-- stations
INSERT INTO stations (hierarchy_code, station_name, latitude, longitude) VALUES
    ('00', 'Central Office', -15.3875, 28.3228),
    ('00-01', 'Bulawayo Office', -13.1339, 32.6387),
    ('00-02', 'Matabeleland South Office', -17.8252, 25.8580),
    ('00-03', 'Chitungwiza Office', -13.6300, 32.6400);

-- asset_brands
-- asset_type: 1 Laptop, 2 Cellphone
-- brand_type: 1 HP, 2 Samsung, 3 Lenovo, 4 Dell, 5 Honor
INSERT INTO asset_brands (asset_type_id, brand_type_id) VALUES
    (1, 1), -- HP Laptop
    (1, 2), -- Samsung Laptop
    (1, 3), -- Lenovo Laptop
    (1, 4), -- Dell Laptop
    (2, 2), -- Samsung Cellphone
    (2, 5); -- Honor Cellphone

-- asset_models
-- asset_brand ids follow insert order above
-- model_type: 1 ProBook, 2 Galaxy Book, 3 Galaxy S23, 4 Honor 100, 5 ThinkPad, 6 Latitude
INSERT INTO asset_models (asset_brand_id, model_type_id) VALUES
    (1, 1), -- HP Laptop + ProBook 450 G12
    (2, 2), -- Samsung Laptop + Galaxy Book Pro
    (3, 5), -- Lenovo Laptop + ThinkPad T490
    (4, 6), -- Dell Laptop + Latitude 5490
    (5, 3), -- Samsung Cellphone + Galaxy S23
    (6, 4); -- Honor Cellphone + Honor 100

-- programs
INSERT INTO programs (program_code, program_name) VALUES
    ('TASQC', 'TASQC'),
    ('MNCH', 'MNCH'),
    ('SHIFT', 'SHIFT'),
    ('BOOST', 'BOOST'),
    ('NEOTREE', 'NEOTREE');

-- suppliers
INSERT INTO suppliers (supplier_name) VALUES
    ('Liquid');

-- staff
INSERT INTO staff_profiles (id, full_name, staff_email, staff_phone) VALUES
    (1, 'Administrator', 'admin', '+260970000001'),
    (2, 'Manager', 'man', '+260970000002'),
    (3, 'Supervisor', 'sup', '+260970000003'),
    (4, 'User', 'user', '+260970000004'),
    (5, 'Asset Administrator', 'assets', '+260970000005');

-- staff_accounts
INSERT INTO staff_accounts (staff_profile_id, secret_key) select id, encode(digest(staff_email || staff_phone, 'sha256'), 'hex') from staff_profiles;

-- staff_roles
INSERT INTO staff_roles (staff_profile_id, role_type_id, role_station_id) VALUES
    (1, 10, 1),
    (1, 20, 1),
    (1, 30, 1),
    (1, 40, 1),
    (1, 50, 1),
    (1, 60, 1),
    (1, 70, 1),
    (1, 80, 1),
    (2, 40, 1),
    (3, 50, 1),
    (4, 10, 1),
    (3, 20, 1);