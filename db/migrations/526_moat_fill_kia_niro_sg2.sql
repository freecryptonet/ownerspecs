-- mig 526 — moat-fill Kia Niro SG2 (EV variant) from Kia CA OM.
--
-- Source: 25-niro-ev.pdf (Kia Canada 2025 Niro EV Owner's Manual).
-- public_link=1 (manufacturer-owned kia.ca/content/dam path).
--
-- Niro SG2 is sold as three powertrain variants on the same gen:
--   * Niro EV (single rear motor, no engine)
--   * Niro HEV / Hybrid (1.6L + electric motor)
--   * Niro PHEV (1.6L + larger plug-in battery)
-- This first pass loads the EV-spec values. HEV/PHEV-specific rows will
-- need their own OM extraction.

SET NAMES utf8mb4;

SET @gen := (SELECT id FROM generations WHERE slug='niro-sg2-suv-2023-present');

INSERT IGNORE INTO sources (citation, public_link, type, retrieved_at, notes) VALUES
  ('Kia Niro EV (SG2) 2025 Owner''s Manual', 1, 'owner_manual', NOW(),
   'Kia Canada Owner''s Manual edition for the 2025 Niro EV; ingested via on-demand convert→detect_sections pipeline.');
SET @src := (SELECT id FROM sources WHERE citation='Kia Niro EV (SG2) 2025 Owner''s Manual');

-- Fluid specs (page 10-9 "Recommended lubricants and capacities")
INSERT INTO fluid_specs (generation_id, fluid_type, capacity_l, spec_standard, notes) VALUES
  (@gen, 'reduction_gear', 2.85, 'SK ATF SP4M-1 / Kia Genuine ATF SP4M-1', 'EV variant, single rear motor. Range 2.8–2.9 L.'),
  (@gen, 'brake',          NULL, 'SAE J1704 DOT-4 LV / FMVSS 116 DOT-4 / ISO 4925 Class 6', NULL),
  (@gen, 'coolant',        14.4, 'Phosphate-based ethylene glycol coolant', 'EV variant. 14.3 L (without heat pump) / 14.5 L (with heat pump). Battery + electronics cooling.'),
  (@gen, 'ac_refrigerant', NULL, 'R-1234yf (Type B trim) / R-134a (Type A trim)', 'Charge: 850±25 g with heat pump, 750±25 g without. POE compressor lubricant 180±10 g.');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', id, @src,
       CASE fluid_type
         WHEN 'reduction_gear' THEN 529
         WHEN 'brake' THEN 529
         WHEN 'coolant' THEN 529
         WHEN 'ac_refrigerant' THEN 525
       END
FROM fluid_specs WHERE generation_id=@gen;

-- Wheel-lug torque (page 10-8)
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, 'wheel_lug', 117, 86, 'Range 107–127 N·m (79–94 lbf·ft, 11–13 kgf·m). Same torque for 17-inch wheel.');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
VALUES ('torque_specs', LAST_INSERT_ID(), @src, 528);

-- Tire pressures (single 17" OE size on EV)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'normal', 36.0, 250, '215/55 R17'),
  (@gen, 'rear',  'normal', 36.0, 250, '215/55 R17');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'tire_pressures', id, @src, 528 FROM tire_pressures WHERE generation_id=@gen;

-- Service intervals (page 9-7 onwards "Normal maintenance schedule")
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'brake_fluid_inspect',  8000,  13000,  12, 'Inspect brake fluid every 13,000 km / 8,000 mi or 12 months.'),
  (@gen, 'brake_fluid_change',  48000,  78000,  48, 'Replace brake fluid every 78,000 km / 48,000 mi or 48 months.'),
  (@gen, 'coolant_first_change', 120000, 195000, 120, 'First coolant replacement at 195,000 km / 120,000 mi or 120 months.'),
  (@gen, 'coolant_subsequent',    24000,  39000,  24, 'Subsequent coolant replacements every 39,000 km / 24,000 mi or 24 months.');
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'service_intervals', id, @src, 477 FROM service_intervals WHERE generation_id=@gen;
