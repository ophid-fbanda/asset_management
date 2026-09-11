-- event_date: business date on each event table; stamp remains record time.

ALTER TABLE asset_registrations RENAME COLUMN reference_date TO event_date;

ALTER TABLE asset_transfers ADD COLUMN event_date date;
UPDATE asset_transfers SET event_date = stamp::date;
ALTER TABLE asset_transfers ALTER COLUMN event_date SET NOT NULL;

ALTER TABLE asset_issuances ADD COLUMN event_date date;
UPDATE asset_issuances SET event_date = stamp::date;
ALTER TABLE asset_issuances ALTER COLUMN event_date SET NOT NULL;

ALTER TABLE asset_verifications ADD COLUMN event_date date;
UPDATE asset_verifications SET event_date = stamp::date;
ALTER TABLE asset_verifications ALTER COLUMN event_date SET NOT NULL;

ALTER TABLE asset_evaluations ADD COLUMN event_date date;
UPDATE asset_evaluations SET event_date = stamp::date;
ALTER TABLE asset_evaluations ALTER COLUMN event_date SET NOT NULL;

ALTER TABLE asset_placements ADD COLUMN event_date date;
UPDATE asset_placements SET event_date = stamp::date;
ALTER TABLE asset_placements ALTER COLUMN event_date SET NOT NULL;

ALTER TABLE asset_disposals ADD COLUMN event_date date;
UPDATE asset_disposals SET event_date = stamp::date;
ALTER TABLE asset_disposals ALTER COLUMN event_date SET NOT NULL;

ALTER TABLE asset_incidents ADD COLUMN event_date date;
UPDATE asset_incidents SET event_date = stamp::date;
ALTER TABLE asset_incidents ALTER COLUMN event_date SET NOT NULL;

ALTER TABLE asset_requests ADD COLUMN event_date date;
UPDATE asset_requests SET event_date = stamp::date;
ALTER TABLE asset_requests ALTER COLUMN event_date SET NOT NULL;
