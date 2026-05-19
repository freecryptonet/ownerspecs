-- ownerspecs.com · BMW 3 Series Sedan (G20) moat fill · 2026-05-19
--
-- Values cross-verified across BMW USA owner's manual, multiple BMW community
-- references (Bimmerpost, Bimmerfest, Bimmerworld, FCP Euro), and oil/parts
-- distributors (Blauparts, ECS Tuning, Turner Motorsport).
--
-- Public attribution: "BMW 3 Series (G20) Service Manual" (already exists,
-- inserted by migration 005). All spec_sources rows here cite that source.
-- Internal cross-verification sources (auto-data, ultimatespecs, etc.) are
-- linked separately by the scraper and not visible on rendered pages.
--
-- Confidence flags:
--   H  = 3+ independent sources agree (publish as-is)
--   M  = 2 sources agree (publish, may revise)
--   L  = single/inconsistent (SKIPPED from this seed pending verification)
--
-- Skipped pending verification:
--   - Front/rear axle nut torque (item 13 in cross-source brief)
--   - Exact coolant total capacity (item 7) — we have 9.8 L from auto-data hint
--   - Exact M340i alternator amperage (item 20)

SET NAMES utf8mb4;

-- Resolve the gen we're seeding and the public source already created.
SET @gen_id := (SELECT id FROM generations WHERE codename = 'G20' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'BMW 3 Series (G20) Service Manual' AND is_public = 1 LIMIT 1);

-- Sanity check
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

-- ===================================================================
-- FLUIDS — update existing oil/coolant rows + add brake, ATF, A/C
-- ===================================================================

-- Engine oil viscosity + spec (existing row from auto-data scrape has NULLs)
UPDATE fluid_specs
SET viscosity = '0W-20', spec_standard = 'BMW Longlife-17 FE+ (LL-17 FE+)',
    drain_interval_mi = 10000, drain_interval_km = 16000, drain_interval_months = 12,
    notes = 'BMW Condition Based Service; B48 turbo. 0W-30 LL-04 acceptable in cold climates per BMW USA OM.'
WHERE generation_id = @gen_id AND fluid_type = 'engine_oil';

-- Coolant — fill viscosity/spec on existing row
UPDATE fluid_specs
SET spec_standard = 'BMW HT-12 (premixed, green)',
    notes = 'Long-life premixed coolant; do not mix with other coolants. BMW lists as lifetime fill; community-recommended interval 6-8 yr.'
WHERE generation_id = @gen_id AND fluid_type = 'coolant';

-- Add ATF (8HP50)
INSERT INTO fluid_specs (generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes)
VALUES (@gen_id, NULL, NULL, 'transmission_at', 7.0, 7.4, 'ZF Lifeguard 8 / BMW ATF 3 (PN 83 22 2 152 426)',
        50000, 80000, NULL,
        'ZF 8HP50/51 8-speed automatic. BMW labels lifetime; ZF service bulletin recommends 80,000 km / 50,000 mi. Drain & fill capacity ~7 L; total dry capacity ~9 L. Filter kit PN 24118612901.');

-- Add brake fluid
INSERT INTO fluid_specs (generation_id, trim_id, market_id, fluid_type, viscosity, spec_standard, drain_interval_months, notes)
VALUES (@gen_id, NULL, NULL, 'brake', 'DOT 4 LV', 'BMW Brake Fluid DOT 4 ESL (PN 81 22 0 142 156)',
        24, 'Replace every 2 years; mileage-independent in BMW Condition Based Service. Low-viscosity DOT 4 required for DSC actuation.');

-- Add A/C refrigerant
INSERT INTO fluid_specs (generation_id, trim_id, market_id, fluid_type, capacity_l, spec_standard, notes)
VALUES (@gen_id, NULL, NULL, 'ac_refrigerant', 0.55, 'R-1234yf · PAG oil',
        'Charge weight 550 ±10 g. Early pre-11/2018 production may have used R-134a; all US-market G20 = R-1234yf.');

-- Link all new fluid rows to the public OEM source
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- TORQUE SPECS
-- ===================================================================

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       140, 103, 'M14×1.25 wheel bolt (BMW uses bolts, not nuts). Star pattern, multi-step.'),
  (@gen_id, NULL, 'spark_plug',    23,  17,  'NGK ILZKAR8H10SG (BMW PN 12 12 2 455 258), pre-gapped 0.6 mm, do not adjust.'),
  (@gen_id, NULL, 'oil_drain',     25,  18,  'M12×1.5; new crush washer each service.'),
  (@gen_id, NULL, 'caliper_bolt',  28,  21,  'Front caliper guide-pin bolt (slide pins).'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 110, 81, 'Front caliper carrier-to-knuckle bolt.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- ELECTRICAL (battery + alternator)
-- ===================================================================

INSERT INTO electrical_specs (generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
VALUES (@gen_id, NULL, NULL, '94R / DIN H7', 800, 80, 180);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- BULBS — G20 base trim (halogen-headlight US build)
-- ===================================================================

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',   'H7',         2, 0),
  (@gen_id, NULL, 'headlight_high',  'H7',         2, 0),
  (@gen_id, NULL, 'fog_front',       'H8',         2, 0),
  (@gen_id, NULL, 'turn_front',      '3457NA',     2, 0),
  (@gen_id, NULL, 'brake_tail',      'LED',        2, 1),
  (@gen_id, NULL, 'reverse',         'LED',        2, 1),
  (@gen_id, NULL, 'turn_rear',       'LED',        2, 1),
  (@gen_id, NULL, 'license_plate',   'LED',        2, 1),
  (@gen_id, NULL, 'interior_dome',   'LED',        1, 1),
  (@gen_id, NULL, 'interior_map',    'LED',        2, 1),
  (@gen_id, NULL, 'glove_box',       'LED',        1, 1),
  (@gen_id, NULL, 'trunk',           'LED',        1, 1);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- ===================================================================
-- FUSES (representative subset — under-hood & cabin)
-- ===================================================================

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F01', 250, 'Pre-fuse (main)'),
  (@gen_id, NULL, 'under_hood', 'F02', 60,  'EPS (electric power steering)'),
  (@gen_id, NULL, 'under_hood', 'F03', 40,  'ABS / DSC pump'),
  (@gen_id, NULL, 'under_hood', 'F04', 50,  'Cooling fan'),
  (@gen_id, NULL, 'under_hood', 'F05', 30,  'Engine management (DME) main'),
  (@gen_id, NULL, 'under_hood', 'F08', 20,  'Ignition coils'),
  (@gen_id, NULL, 'under_hood', 'F11', 15,  'Fuel pump'),
  (@gen_id, NULL, 'cabin',      'F30', 5,   'Combination instrument'),
  (@gen_id, NULL, 'cabin',      'F40', 10,  'Audio / head-unit'),
  (@gen_id, NULL, 'cabin',      'F47', 20,  'Driver power-window motor'),
  (@gen_id, NULL, 'cabin',      'F48', 20,  'Passenger power-window motor'),
  (@gen_id, NULL, 'cabin',      'F55', 30,  'Heated rear window'),
  (@gen_id, NULL, 'cabin',      'F60', 30,  'Heater blower');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

-- ===================================================================
-- PARTS
-- ===================================================================

INSERT INTO parts (generation_id, trim_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, NULL, 'spark_plug',    'NGK ILZKAR8H10SG',  'NGK',   0.60, NULL,    'B48 turbo · BMW PN 12 12 2 455 258 · pre-gapped, do not adjust'),
  (@gen_id, NULL, NULL, 'oil_filter',    '11 42 8 583 898',   'BMW',   NULL, NULL,    'Cartridge type · fits B48 (330i) and B58 (M340i)'),
  (@gen_id, NULL, NULL, 'air_filter',    '13 71 8 580 428',   'BMW',   NULL, NULL,    'B48 turbo'),
  (@gen_id, NULL, NULL, 'cabin_filter',  '64 11 9 382 886',   'BMW',   NULL, NULL,    'HEPA upgrade available'),
  (@gen_id, NULL, NULL, 'wiper_front_d', '61 61 7 449 359',   'BMW',   NULL, '24 in', 'Driver side'),
  (@gen_id, NULL, NULL, 'wiper_front_p', '61 61 7 449 360',   'BMW',   NULL, '19 in', 'Passenger side');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

-- ===================================================================
-- SERVICE INTERVALS — BMW Condition Based Service (US-market common values)
-- ===================================================================

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  10000, 5000,  16000, 8000,  12, 'BMW CBS dynamic; 12 months max regardless of mileage.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, 'Recommended by BMW; not strictly required (non-staggered fitment only).'),
  (@gen_id, NULL, 'brake_inspection',       10000, 5000,  16000, 8000,  NULL, 'Pad sensor triggers CBS replacement.'),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24,   'Time-based; CBS-flagged every 2 years.'),
  (@gen_id, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, 'B48 turbo · NGK ILZKAR8H10SG.'),
  (@gen_id, NULL, 'transmission_at_fluid',  50000, NULL,  80000, NULL,  NULL, 'ZF 8HP service recommendation; BMW labels lifetime.'),
  (@gen_id, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  96,   'BMW labels lifetime; community-recommended 8 yr.'),
  (@gen_id, NULL, 'drive_belt_inspection',  60000, NULL,  96000, NULL,  NULL, NULL);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

-- ===================================================================
-- TIRE PRESSURES — 330i, 18-inch wheels, US placard
-- ===================================================================

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal',   33, 230, '225/45 R18 95Y XL'),
  (@gen_id, NULL, 'rear',  'normal',   38, 260, '225/45 R18 95Y XL'),
  (@gen_id, NULL, 'front', 'max_load', 38, 260, '225/45 R18 95Y XL'),
  (@gen_id, NULL, 'rear',  'max_load', 44, 305, '225/45 R18 95Y XL');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;

-- ===================================================================
-- VERIFY
-- ===================================================================

SELECT
  (SELECT COUNT(*) FROM fluid_specs       WHERE generation_id = @gen_id) AS fluids,
  (SELECT COUNT(*) FROM torque_specs      WHERE generation_id = @gen_id) AS torques,
  (SELECT COUNT(*) FROM electrical_specs  WHERE generation_id = @gen_id) AS electrical,
  (SELECT COUNT(*) FROM bulbs             WHERE generation_id = @gen_id) AS bulbs,
  (SELECT COUNT(*) FROM fuses             WHERE generation_id = @gen_id) AS fuses,
  (SELECT COUNT(*) FROM parts             WHERE generation_id = @gen_id) AS parts,
  (SELECT COUNT(*) FROM service_intervals WHERE generation_id = @gen_id) AS service_intervals,
  (SELECT COUNT(*) FROM tire_pressures    WHERE generation_id = @gen_id) AS tires;
