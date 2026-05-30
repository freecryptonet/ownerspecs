-- mig 523 — moat-fill Kia EV9 MV from Kia CA Owner's Manual.
--
-- Source: 25-ev9.pdf (Kia Canada 2025 EV9 Owner's Manual). All values
-- come from the OM's chapter 10 "Specifications & Consumer Information",
-- which is published verbatim by Kia Canada at the manufacturer-owned
-- domain (`kia.ca/content/dam/marketing/documents/en/owners/2025/25-ev9.pdf`).
-- public_link=1 — manufacturer-owned.
--
-- EV9 is BEV-only; no engine-specific rows. Reduction-gear fluid is split
-- by drivetrain (2WD = rear-motor only, AWD = front + rear motors).

SET NAMES utf8mb4;

SET @gen := (SELECT id FROM generations WHERE slug='ev9-mv-suv-2023-present');

-- 1. Source row for this OM edition
INSERT IGNORE INTO sources (citation, public_link, notes)
VALUES ('Kia EV9 (MV) 2025 Owner''s Manual', 1,
        'Kia Canada Owner''s Manual edition for the 2025 EV9; ingested via the on-demand convert→detect_sections pipeline.');
SET @src := (SELECT id FROM sources WHERE citation='Kia EV9 (MV) 2025 Owner''s Manual');

-- 2. Fluid specs — OM ch.10 page 10-10 "Recommended lubricants and capacities"
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, spec_standard, notes) VALUES
  (@gen, 'reduction_gear_rear', 4.15, 'SK ATF SP4M-1 / Kia Genuine ATF SP4M-1', 'Range 4.1–4.2 L (4.3–4.4 US qt). Applies to both 2WD and AWD rear motor.'),
  (@gen, 'reduction_gear_front', 3.25, 'SK ATF SP4M-1 / Kia Genuine ATF SP4M-1', 'AWD only. Range 3.2–3.3 L (3.4–3.5 US qt).'),
  (@gen, 'brake', NULL, 'SAE J1704 DOT-4 LV / FMVSS 116 DOT-4 / ISO 4925 Class 6', NULL),
  (@gen, 'coolant', 20.7, 'Phosphate-based ethylene glycol coolant', 'Range 20.5 L (2WD) – 20.9 L (AWD). For battery + power electronics cooling.'),
  (@gen, 'ac_refrigerant', NULL, 'R-1234yf', '1300±25 g with heat pump, 1125±25 g without. POE compressor lubricant 245–275 g.');

-- 2a. Cite the source for every fluid spec row inserted above
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', id, @src,
       CASE fluid_type
         WHEN 'reduction_gear_rear' THEN 592
         WHEN 'reduction_gear_front' THEN 592
         WHEN 'brake' THEN 592
         WHEN 'coolant' THEN 592
         WHEN 'ac_refrigerant' THEN 587
       END
FROM fluid_specs WHERE generation_id=@gen AND id > (SELECT IFNULL(MAX(id),0) - 5 FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen) sub);

-- 3. Wheel-lug-nut torque — OM ch.10 page 10-9
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, 'wheel_lug', 117, 86, 'Range 107–127 N·m (79–94 lbf·ft, 11–13 kgf·m). Applies to all wheel sizes (19/20/21).');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
VALUES ('torque_specs', LAST_INSERT_ID(), @src, 591);

-- 4. Tire pressures — OM ch.10 page 10-9. All three tire sizes use 260 kPa.
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'normal', 38.0, 260, '255/60 R19'),
  (@gen, 'rear',  'normal', 38.0, 260, '255/60 R19'),
  (@gen, 'front', 'normal', 38.0, 260, '275/50 R20'),
  (@gen, 'rear',  'normal', 38.0, 260, '275/50 R20'),
  (@gen, 'front', 'normal', 38.0, 260, '285/45 R21'),
  (@gen, 'rear',  'normal', 38.0, 260, '285/45 R21');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'tire_pressures', id, @src, 591 FROM tire_pressures WHERE generation_id=@gen;

-- 5. Service intervals — OM ch.9 maintenance schedule.
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'coolant_first_change', 120000, 195000, 120, 'First coolant replacement at 195,000 km / 120,000 mi or 120 months, whichever first.'),
  (@gen, 'coolant_subsequent',    24000,  39000,  24, 'Subsequent coolant replacements every 39,000 km / 24,000 mi or 24 months.'),
  (@gen, 'brake_fluid_change',    24000,  39000,  24, 'Inspect brake fluid level and condition. Refer to authorized Kia dealer.'),
  (@gen, 'air_filter_climate',    15000,  24000,  12, 'Replace climate control air filter.'),
  (@gen, 'wiper_blade_inspect',   12000,  19000,  12, 'Inspect/replace front and rear wiper blades as needed.');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', id, @src, 533 FROM service_intervals WHERE generation_id=@gen;
