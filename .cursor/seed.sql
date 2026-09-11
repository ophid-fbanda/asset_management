-- Auto-generated demo seed for the asset_management (assem) database.
-- Source: data rows from schema.sql, adapted to the canonical asset_management.sql schema.
-- Excludes removed table approval_statuses and the restructured event_approvals table.
-- asset_transfers rows are patched with a business event_date derived from their stamp.

SET session_replication_role = replica;  -- bypass FK ordering during bulk load

COPY public.acquisition_types (id, name) FROM stdin;
1	Purchase
2	Grant
3	Donation
4	Other
\.

COPY public.approval_types (id, name) FROM stdin;
11	User Declined
10	User Accepted
40	Supervisor Approved
41	Supervisor Rejected
51	Manager Rejected
50	Manager Approved
\.

COPY public.asset_brands (id, asset_type_id, brand_type_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	2	2
6	2	5
\.

COPY public.asset_disposals (id, registered_asset_id, disposal_type_id, event_notes, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.

COPY public.asset_evaluations (id, registered_asset_id, evaluation_type_id, evaluated_value, event_notes, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.

COPY public.asset_incidents (id, registered_asset_id, incident_type_id, event_notes, incident_asset_image, incident_police_report, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.

COPY public.asset_issuance_items (id, registered_asset_id, asset_issuance_id) FROM stdin;
\.

COPY public.asset_issuances (id, receiving_staff_id, notes, event_register_id, event_station_id, event_admin_id, stamp, issuance_type_id) FROM stdin;
\.

COPY public.asset_models (id, asset_brand_id, model_type_id) FROM stdin;
1	1	1
2	2	2
3	3	5
4	4	6
5	5	3
6	6	4
\.

COPY public.asset_placements (id, registered_asset_id, placement_type_id, event_notes, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.

COPY public.asset_registrations (id, acquisition_type_id, reference_attachment, reference_type_id, supplier_id, notes, event_register_id, event_station_id, event_admin_id, stamp, event_date, program_id) FROM stdin;
4	1	1781464926308_36497.pdf	1	1	uhjn	4	1	1	2026-06-14 21:22:06.337747	2026-06-14	1
5	1	1781467723637_46862.pdf	1	1	5	5	1	1	2026-06-14 22:08:43.6571	2026-06-01	2
6	1	1781901935339_25995.pdf	1	1	trt	6	1	1	2026-06-19 22:45:35.373453	2026-06-19	1
7	1	1781906380860_16127.pdf	1	1	kkkkkkkkkkkk	7	1	1	2026-06-19 23:59:40.939248	2026-06-02	1
8	1	1782115030330_34764.pdf	1	1	hvb	8	1	1	2026-06-22 09:57:10.393709	2026-06-23	3
\.

COPY public.asset_request_items (id, asset_request_id, requested_asset_type_id, requested_quantity) FROM stdin;
\.

COPY public.asset_requests (id, event_notes, event_register_id, request_program_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.

COPY public.asset_transfer_items (id, asset_transfer_id, registered_asset_id) FROM stdin;
5	3	7
6	4	6
\.

COPY public.asset_transfers (id, receiving_station_id, notes, event_register_id, event_station_id, event_admin_id, stamp, event_date) FROM stdin;
3	2	lkl	11	1	1	2026-06-23 19:10:01.85868	2026-06-23
4	2	sd	12	1	1	2026-06-24 13:37:42.336822	2026-06-24
\.

COPY public.asset_types (id, name) FROM stdin;
1	Laptop
2	Cellphone
\.

COPY public.asset_verifications (id, registered_asset_id, verification_type_id, verified_condition_type_id, event_notes, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.

COPY public.brand_types (id, name) FROM stdin;
1	HP
2	Samsung
3	Lenovo
4	Dell
5	Honor
\.

COPY public.condition_types (id, name) FROM stdin;
1	New
2	Good
3	Fair
4	Poor
5	Damaged
6	Other
\.

COPY public.disposal_types (id, name) FROM stdin;
1	Sale
2	Donation
3	Auction
4	Incidental
5	Other
\.

COPY public.evaluation_types (id, name) FROM stdin;
1	Depreciated
2	Market Value
3	Correction Value
4	Impairment
5	Other
\.

COPY public.event_register (id) FROM stdin;
1
2
3
4
5
6
7
8
9
10
11
12
\.

COPY public.incident_types (id, name) FROM stdin;
1	Theft
2	Missing
3	Damage
4	Malfunction
5	Misuse
6	Other
\.

COPY public.issuance_types (id, name) FROM stdin;
1	Keep
2	Use
\.

COPY public.model_types (id, name) FROM stdin;
1	ProBook 450 G12
2	Galaxy Book Pro
3	Samsung Galaxy S23
4	Honor 100
5	ThinkPad T490
6	Latitude 5490
\.

COPY public.placement_types (id, name) FROM stdin;
1	Office
2	Field
3	Lent Out
4	Sent for Repair/Service
5	Other
\.

COPY public.programs (id, program_code, program_name) FROM stdin;
1	TASQC	TASQC
2	MNCH	MNCH
3	SHIFT	SHIFT
4	BOOST	BOOST
5	NEOTREE	NEOTREE
\.

COPY public.reference_types (id, name) FROM stdin;
1	Invoice
2	Receipt
3	Goods Received Voucher
4	Other
\.

COPY public.registered_assets (id, asset_registration_id, asset_model_id, serial_number, asset_number, condition_type_id, acquisition_value) FROM stdin;
4	4	1	8989	SGAN/TASQC/Laptop/4	1	89.00
5	5	1	55555	SGAN/MNCH/Laptop/5	1	55.00
6	6	1	676767	SGAN/TASQC/Laptop/6	1	6.00
7	6	6	SGSN-1-260619224519034	SGAN/TASQC/Cellphone/7	2	90.00
8	7	1	44444	SGAN/TASQC/Laptop/8	1	7.00
9	7	5	ppppp	SGAN/TASQC/Cellphone/9	1	78.00
10	8	1	7676767676	SGAN/SHIFT/Laptop/10	1	56.00
\.

COPY public.role_types (id, name) FROM stdin;
10	General User
20	Assets Administrator
30	Auctions Administrator
40	Supervisor
50	Manager
60	Auditor
70	Users Administrator
80	System Administrator
\.

COPY public.staff_accounts (id, staff_profile_id, secret_key) FROM stdin;
1	1	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
2	2	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
3	3	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
4	4	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
5	5	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
\.

COPY public.staff_profiles (id, full_name, staff_email, staff_phone) FROM stdin;
1	Administrator	admin	+260970000001
2	Manager	man	+260970000002
3	Supervisor	sup	+260970000003
4	User	user	+260970000004
5	Asset Administrator	assets	+260970000005
\.

COPY public.staff_roles (id, staff_profile_id, role_type_id, role_station_id) FROM stdin;
1	1	10	1
2	1	20	1
3	1	30	1
4	1	40	1
5	1	50	1
6	1	60	1
7	1	70	1
8	1	80	1
9	2	40	1
10	3	50	1
11	4	10	1
12	3	20	1
\.

COPY public.stations (id, station_code, station_name, latitude, longitude) FROM stdin;
1	00	Central Office	-15.38750000	28.32280000
2	00-01	Bulawayo Office	-13.13390000	32.63870000
3	00-02	Matabeleland South Office	-17.82520000	25.85800000
4	00-03	Chitungwiza Office	-13.63000000	32.64000000
\.

COPY public.suppliers (id, supplier_name) FROM stdin;
1	Liquid
\.

COPY public.updates (id, notes, staff_id, seen, stamp) FROM stdin;
\.

COPY public.verification_types (id, name) FROM stdin;
1	Routine Verification
2	Adhoc Verification
3	Pre-Transfer/Issuance Verification
4	Disposal Verification
5	Other
\.

COPY public.event_approvals (id, event_register_id, approval_type_id, approval_notes, event_admin_id, stamp) FROM stdin;
1	5	40	yes	1	2026-06-23 06:37:25.045009
2	6	40	cool	1	2026-06-23 06:27:51.836498
3	6	50	This is acceptable	1	2026-06-23 09:41:22.302554
4	7	41	negtive	1	2026-06-23 06:33:38.682221
5	8	40	cooler	1	2026-06-23 06:28:11.697636
6	8	50	Go ahead	1	2026-06-23 08:01:44.716563
7	11	40	test	1	2026-06-24 20:10:13.649147
8	11	50	test	1	2026-06-24 20:10:48.032347
\.

-- Restore sequence values
SELECT pg_catalog.setval('public.acquisition_types_id_seq', 4, true);
SELECT pg_catalog.setval('public.asset_brands_id_seq', 6, true);
SELECT pg_catalog.setval('public.asset_disposals_id_seq', 1, false);
SELECT pg_catalog.setval('public.asset_evaluations_id_seq', 1, false);
SELECT pg_catalog.setval('public.asset_incidents_id_seq', 1, false);
SELECT pg_catalog.setval('public.asset_issuance_items_id_seq', 1, false);
SELECT pg_catalog.setval('public.asset_issuances_id_seq', 1, false);
SELECT pg_catalog.setval('public.asset_models_id_seq', 6, true);
SELECT pg_catalog.setval('public.asset_placements_id_seq', 1, false);
SELECT pg_catalog.setval('public.asset_registrations_id_seq', 8, true);
SELECT pg_catalog.setval('public.asset_request_items_id_seq', 1, false);
SELECT pg_catalog.setval('public.asset_requests_id_seq', 1, false);
SELECT pg_catalog.setval('public.asset_transfer_items_id_seq', 6, true);
SELECT pg_catalog.setval('public.asset_transfers_id_seq', 4, true);
SELECT pg_catalog.setval('public.asset_types_id_seq', 2, true);
SELECT pg_catalog.setval('public.asset_verifications_id_seq', 1, false);
SELECT pg_catalog.setval('public.brand_types_id_seq', 5, true);
SELECT pg_catalog.setval('public.condition_types_id_seq', 6, true);
SELECT pg_catalog.setval('public.disposal_types_id_seq', 5, true);
SELECT pg_catalog.setval('public.evaluation_types_id_seq', 5, true);
SELECT pg_catalog.setval('public.event_register_id_seq', 12, true);
SELECT pg_catalog.setval('public.incident_types_id_seq', 6, true);
SELECT pg_catalog.setval('public.model_types_id_seq', 6, true);
SELECT pg_catalog.setval('public.placement_types_id_seq', 5, true);
SELECT pg_catalog.setval('public.programs_id_seq', 5, true);
SELECT pg_catalog.setval('public.reference_types_id_seq', 4, true);
SELECT pg_catalog.setval('public.registered_assets_id_seq', 10, true);
SELECT pg_catalog.setval('public.staff_accounts_id_seq', 5, true);
SELECT pg_catalog.setval('public.staff_roles_id_seq', 12, true);
SELECT pg_catalog.setval('public.stations_id_seq', 4, true);
SELECT pg_catalog.setval('public.suppliers_id_seq', 9, true);
SELECT pg_catalog.setval('public.updates_id_seq', 1, false);
SELECT pg_catalog.setval('public.verification_types_id_seq', 5, true);
SELECT pg_catalog.setval('public.event_approvals_id_seq', 8, true);

SET session_replication_role = DEFAULT;
