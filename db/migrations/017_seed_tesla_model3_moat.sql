-- Tesla Model 3 moat fill — 2017-2023 pre-Highland (no codename)
-- BEV: no engine oil, no spark plugs, no engine air filter, no transmission
-- ATF. The moat tables look very different from an ICE car. We populate
-- coolant (battery + drive unit loops), brake fluid, gearbox fluid (single-
-- speed reducer), bulbs, fuses, tire pressures, service intervals.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE display_name = 'Model 3' AND start_year = 2017 LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Tesla Model 3 Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/tesla/model-3-sedan-2017-2023/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Alexander-93 / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:Tesla_Model_3_(2023)_1X7A1678.jpg',
  CURDATE(),
  'Tesla Model 3 (2023)',
  '3-4-front', 1280, 854
FROM generations g WHERE g.id = @gen_id;

-- ===================================================================
-- FLUIDS — EV-specific. Battery + drive unit coolant loops, brake, gearbox
-- ===================================================================
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'coolant',         12.0, 12.68, NULL,    'Tesla coolant (ethylene glycol blue G-48 type)',  NULL,         NULL,  NULL,   NULL, 'Combined battery + drive-unit + heat-pump loop. Lifetime fill per Tesla; service only on component replacement.'),
  (@gen_id, NULL, 'gearbox',         1.50, 1.59, NULL,    'Tesla reducer fluid (Dexron VI equivalent · synthetic ATF)', NULL,         150000,240000, NULL, 'Single-speed reducer (one front, one rear on AWD). Tesla labels lifetime; tracked owners change at 100k mi.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 3', 'DOT 3 (Tesla genuine)',                           NULL,         NULL,  NULL,   24,   'Test brake fluid for moisture every 2 years; replace if >2%.'),
  (@gen_id, NULL, 'ac_refrigerant',  1.10, 1.16, NULL,    'R-1234yf · POE oil',                              NULL,         NULL,  NULL,   NULL, 'Heat-pump on 2021+ MY uses larger charge (~1100 g). Pre-2021 PTC heater used ~750 g.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- TORQUE — common to most BEV service work
-- ===================================================================
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       175, 129, 'M14×1.5; star pattern. Aero wheels.'),
  (@gen_id, NULL, 'caliper_bolt',  35,  26,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 100, 74, 'Front caliper carrier-to-knuckle.'),
  (@gen_id, NULL, 'gearbox_drain', 38,  28,  'Rear drive-unit drain plug (single-speed reducer).'),
  (@gen_id, NULL, 'gearbox_fill',  38,  28,  'Rear drive-unit fill plug.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- ELECTRICAL — 12 V auxiliary battery only (HV pack is separate)
-- ===================================================================
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, '12 V AGM (Atlas 33Ah)', 280, 33, NULL);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

-- ===================================================================
-- BULBS — all LED from factory
-- ===================================================================
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED', 2, 1),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'LED', 2, 1),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'LED', 2, 1),
  (@gen_id, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'trunk',          'LED', 1, 1);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- ===================================================================
-- FUSES — Model 3 has megafuses + a pyro fuse on HV side
-- ===================================================================
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'under_hood', 'F02',  200, '12 V battery main'),
  (@gen_id, NULL, 'under_hood', 'F05',  60,  'Front DCDC converter'),
  (@gen_id, NULL, 'under_hood', 'F08',  30,  'Front headlight LH'),
  (@gen_id, NULL, 'under_hood', 'F09',  30,  'Front headlight RH'),
  (@gen_id, NULL, 'under_hood', 'F12',  40,  'Front PTC heater / heat-pump'),
  (@gen_id, NULL, 'under_hood', 'F18',  30,  'Wiper motor'),
  (@gen_id, NULL, 'under_hood', 'F26',  20,  'Front parking sensors'),
  (@gen_id, NULL, 'cabin',      'F40',  15,  'Cabin pre-conditioning'),
  (@gen_id, NULL, 'cabin',      'F42',  10,  'Central display (MCU)'),
  (@gen_id, NULL, 'cabin',      'F50',  20,  'Driver door module'),
  (@gen_id, NULL, 'cabin',      'F51',  20,  'Passenger door module'),
  (@gen_id, NULL, 'rear',       'F70',  40,  'Rear PTC / HV pyro charge module');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

-- ===================================================================
-- PARTS — minimal vs ICE: cabin filter, wipers, brake pads
-- ===================================================================
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'cabin_filter',  '1107681-00-A',  'Tesla', NULL, NULL,    'HEPA + activated carbon (Bioweapon Defense Mode if equipped)'),
  (@gen_id, NULL, 'wiper_front_d', '1107849-00-A',  'Tesla', NULL, '26 in', 'Driver side (LH drive)'),
  (@gen_id, NULL, 'wiper_front_p', '1107850-00-A',  'Tesla', NULL, '19 in', 'Passenger side'),
  (@gen_id, NULL, 'brake_pad_front','1044644-00-A', 'Tesla', NULL, NULL,    'Front brake pad set'),
  (@gen_id, NULL, 'brake_pad_rear', '1044645-00-A', 'Tesla', NULL, NULL,    'Rear brake pad set');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

-- ===================================================================
-- SERVICE INTERVALS — minimal scheduled maintenance
-- ===================================================================
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'tire_rotation',          6250,  NULL,  10000, NULL,  NULL, 'Per Tesla; recommended every 6,250 mi or when tread depth difference exceeds 2/32".'),
  (@gen_id, NULL, 'brake_inspection',       NULL,  NULL,  NULL,  NULL,  12,   'Annual.'),
  (@gen_id, NULL, 'cabin_air_filter',       NULL,  NULL,  NULL,  NULL,  24,   'Every 2 years.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24,   'Test for moisture every 2 years; replace if >2%.'),
  (@gen_id, NULL, 'ac_desiccant',           NULL,  NULL,  NULL,  NULL,  72,   'Replace A/C desiccant bag every 6 years.'),
  (@gen_id, NULL, 'wiper_blades',           NULL,  NULL,  NULL,  NULL,  12,   'Annual or when streaking begins.'),
  (@gen_id, NULL, 'lubricate_caliper',      12500, NULL,  20000, NULL,  12,   'Annually or 12,500 mi in salty climates.'),
  (@gen_id, NULL, 'gearbox_fluid',          150000,NULL,  240000,NULL,  NULL, 'Single-speed reducer; Tesla labels lifetime, tracked owners change at 100k.');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 42, 290, '235/45 R18 94W (Aero 18)'),
  (@gen_id, NULL, 'rear',  'normal', 42, 290, '235/45 R18 94W (Aero 18)'),
  (@gen_id, NULL, 'front', 'normal', 42, 290, '235/40 R19 96W (Sport 19)'),
  (@gen_id, NULL, 'rear',  'normal', 42, 290, '235/40 R19 96W (Sport 19)'),
  (@gen_id, NULL, 'front', 'normal', 42, 290, '235/35 R20 88Y (Performance 20)'),
  (@gen_id, NULL, 'rear',  'normal', 42, 290, '235/35 R20 88Y (Performance 20)'),
  (@gen_id, NULL, 'spare', 'normal', 0,  0,   'Tirefit kit (no spare)');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;

SELECT (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen_id) AS fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen_id) AS torques,
       (SELECT COUNT(*) FROM electrical_specs WHERE generation_id=@gen_id) AS electrical,
       (SELECT COUNT(*) FROM bulbs WHERE generation_id=@gen_id) AS bulbs,
       (SELECT COUNT(*) FROM fuses WHERE generation_id=@gen_id) AS fuses,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen_id) AS parts,
       (SELECT COUNT(*) FROM service_intervals WHERE generation_id=@gen_id) AS service_intervals,
       (SELECT COUNT(*) FROM tire_pressures WHERE generation_id=@gen_id) AS tires,
       (SELECT COUNT(*) FROM images WHERE generation_id=@gen_id) AS images;
