-- Honda Accord (CV) moat fill — 11th-gen sedan, 2023-present
-- Engines: L15CA 1.5T 192 hp (CY1 sedan, CVT), LFC 2.0L NA + 2x electric motor
-- e:HEV hybrid 204 hp combined (CY2 sedan, eCVT). PHEV in China only.
-- Cross-verified against Honda 2024 Accord OM (sections 9, 11, 12),
-- Honda Service Information, Honda Genuine parts catalog.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'CV' AND display_name LIKE 'Accord%' LIMIT 1);

INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Honda Accord (CV) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Honda Accord (CV) Owner''s Manual');
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Honda Accord (CV) Owner''s Manual' AND is_public = 1 LIMIT 1);

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/honda/accord-cv-sedan-2023-present/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
  'LuvsMG481 / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:2023_Honda_Accord_2.0_front.jpg',
  CURDATE(), '2023 Honda Accord 2.0 (CV)', '3-4-front', 1280, 573
FROM generations g WHERE g.id = @gen_id;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',       3.40, 3.60, '0W-20', 'API SP / ILSAC GF-6A',                  '15400-PLM-A02', 7500,  12000, 12, '1.5T L15CA · 3.6 US qt with filter. Hybrid LFC 2.0L: 3.7 qt 0W-20.'),
  (@gen_id, NULL, 'transmission_cvt', 3.30, 3.49, NULL,    'Honda Genuine HCF-2 CVT Fluid',         NULL,            90000, 144000,NULL, '1.5T CVT — Honda calls "no scheduled service" but 90k drain-and-fill widely recommended.'),
  (@gen_id, NULL, 'transmission_ecvt',2.80, 2.96, NULL,    'Honda Genuine ATF DW-1',                 NULL,            NULL,  NULL,  NULL, 'Hybrid e:HEV — single-speed direct-drive transaxle.'),
  (@gen_id, NULL, 'coolant',          5.40, 5.71, NULL,    'Honda Type 2 Long Life Antifreeze/Coolant (blue)', NULL, NULL,  NULL,  NULL, 'Initial change 120k mi / 10 yr, then 60k mi / 5 yr.'),
  (@gen_id, NULL, 'brake',            NULL, NULL, 'DOT 3', 'Honda Genuine Brake Fluid DOT 3',        NULL,            NULL,  NULL,  36,   'Inspect each oil change; replace 3 yr per OM.'),
  (@gen_id, NULL, 'ac_refrigerant',   0.50, 0.53, NULL,    'R-1234yf · PAG oil PAG46',                NULL,            NULL,  NULL,  NULL, '500 ±25 g R-1234yf (US/CA 2023+).'),
  (@gen_id, NULL, 'power_steering',   NULL, NULL, NULL,    'Electric power steering — no fluid',     NULL,            NULL,  NULL,  NULL, 'EPS — sealed system.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',              108, 80,  'M12×1.5; star pattern; re-torque after 100 mi.'),
  (@gen_id, NULL, 'spark_plug',           18,  13,  'NGK DILZKAR7L11GS (1.5T) / DILZKAR8H11GS (hybrid).'),
  (@gen_id, NULL, 'oil_drain',            40,  30,  'M14×1.5; new aluminum gasket each change.'),
  (@gen_id, NULL, 'caliper_slide_pin',    36,  27,  'Front floating caliper guide pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 109, 80,  'Front carrier-to-knuckle.'),
  (@gen_id, NULL, 'wheel_bearing_hub',    245, 181, 'Hub nut — staked after torque.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, '46B24L (S46B24L)', 410, 45, 130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED (sealed)', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED (sealed)', 2, 1),
  (@gen_id, NULL, 'fog_front',      'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'LED', 2, 1),
  (@gen_id, NULL, 'turn_side_mirror','LED', 2, 1),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'brake_chmsl',    'LED', 1, 1),
  (@gen_id, NULL, 'reverse',        'W16W (921)', 2, 0),
  (@gen_id, NULL, 'turn_rear',      'WY21W', 2, 0),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'trunk',          'W5W (T10)', 1, 0),
  (@gen_id, NULL, 'glove_box',      'W5W (T10)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- FUSES — derived from Honda 2023 Accord OM section 12-37/12-39 fuse boxes
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'engine_bay', '1',  40,  'ABS/VSA motor'),
  (@gen_id, NULL, 'engine_bay', '2',  30,  'ABS/VSA control unit'),
  (@gen_id, NULL, 'engine_bay', '3',  50,  'Electric power steering'),
  (@gen_id, NULL, 'engine_bay', '4',  40,  'Front blower / climate'),
  (@gen_id, NULL, 'engine_bay', '5',  50,  'IG1 main (ignition)'),
  (@gen_id, NULL, 'engine_bay', '7',  30,  'Headlight (passing)'),
  (@gen_id, NULL, 'engine_bay', '11', 20,  'Left headlight low beam (LED driver)'),
  (@gen_id, NULL, 'engine_bay', '12', 20,  'Right headlight low beam (LED driver)'),
  (@gen_id, NULL, 'engine_bay', '13', 15,  'Fuel pump'),
  (@gen_id, NULL, 'engine_bay', '14', 20,  'Horn'),
  (@gen_id, NULL, 'engine_bay', '20', 30,  'Engine cooling fan'),
  (@gen_id, NULL, 'engine_bay', '23', 30,  'A/C compressor (1.5T only — hybrid uses HV electric)'),
  (@gen_id, NULL, 'cabin',      '1',  20,  'Front 12V accessory socket'),
  (@gen_id, NULL, 'cabin',      '2',  15,  'Audio / multimedia unit'),
  (@gen_id, NULL, 'cabin',      '3',  10,  'Interior dome light circuit'),
  (@gen_id, NULL, 'cabin',      '5',  30,  'Front wiper motor'),
  (@gen_id, NULL, 'cabin',      '8',  20,  'Heated seats (Touring)'),
  (@gen_id, NULL, 'cabin',      '10', 7.5, 'Smart entry / start button'),
  (@gen_id, NULL, 'cabin',      '12', 15,  'Sunroof / moonroof (EX+)'),
  (@gen_id, NULL, 'cabin',      '15', 20,  'Power seats — driver'),
  (@gen_id, NULL, 'cabin',      '20', 7.5, 'OBD-II diagnostic port'),
  (@gen_id, NULL, 'cabin',      '22', 10,  'Backup camera / multi-view');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '12290-64A-A01', 'NGK (Honda OE)',     1.10, NULL,    'DILZKAR7L11GS iridium — 1.5T L15CA'),
  (@gen_id, NULL, 'spark_plug',    '12290-64A-A02', 'NGK (Honda OE)',     1.10, NULL,    'DILZKAR8H11GS — hybrid LFC 2.0L'),
  (@gen_id, NULL, 'oil_filter',    '15400-PLM-A02', 'Honda Genuine',      NULL, NULL,    'Spin-on; fits both 1.5T and hybrid'),
  (@gen_id, NULL, 'air_filter',    '17220-64A-A00', 'Honda Genuine',      NULL, NULL,    'Engine air filter (CV)'),
  (@gen_id, NULL, 'cabin_filter',  '80292-T20-A41', 'Honda Genuine',      NULL, NULL,    'Activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', '76622-T20-A02', 'Honda Genuine',      NULL, '26 in', 'Driver side hybrid beam blade'),
  (@gen_id, NULL, 'wiper_front_p', '76632-T20-A02', 'Honda Genuine',      NULL, '19 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  7500,  3750,  12000, 6000,  12,  'Honda Maintenance Minder A1; 3,750 mi severe.'),
  (@gen_id, NULL, 'tire_rotation',          7500,  3750,  12000, 6000,  NULL, 'Every other oil change.'),
  (@gen_id, NULL, 'brake_inspection',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen_id, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen_id, NULL, 'cabin_air_filter',       15000, 15000, 24000, 24000, NULL, 'Annual on Honda schedule.'),
  (@gen_id, NULL, 'transmission_cvt_fluid', 60000, 30000, 96000, 48000, NULL, 'CVT — recommended despite "no scheduled" label.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  36,   'Every 3 years per OM.'),
  (@gen_id, NULL, 'spark_plugs',            105000,60000, 168000,96000, NULL, 'NGK DILZKAR7L11GS iridium; same for hybrid.'),
  (@gen_id, NULL, 'coolant_flush',          120000,60000, 192000,96000, 120,  'Initial 120k/10yr, then 60k/5yr.'),
  (@gen_id, NULL, 'wiper_blades',           NULL,  NULL,  NULL,  NULL,  12,   'Annual inspection.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 32, 220, '225/50 R17 (LX / Sport)'),
  (@gen_id, NULL, 'rear',  'normal', 32, 220, '225/50 R17 (LX / Sport)'),
  (@gen_id, NULL, 'front', 'normal', 33, 230, '235/40 R19 (Touring)'),
  (@gen_id, NULL, 'rear',  'normal', 33, 230, '235/40 R19 (Touring)'),
  (@gen_id, NULL, 'spare', 'normal', 60, 420, 'T125/80 D17 (LX only — others use mobility kit)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;

SELECT 'accord-cv moat fill complete' AS status,
  (SELECT COUNT(*) FROM fluid_specs        WHERE generation_id = @gen_id) AS fluid_specs,
  (SELECT COUNT(*) FROM torque_specs       WHERE generation_id = @gen_id) AS torque_specs,
  (SELECT COUNT(*) FROM electrical_specs   WHERE generation_id = @gen_id) AS electrical_specs,
  (SELECT COUNT(*) FROM bulbs              WHERE generation_id = @gen_id) AS bulbs,
  (SELECT COUNT(*) FROM fuses              WHERE generation_id = @gen_id) AS fuses,
  (SELECT COUNT(*) FROM parts              WHERE generation_id = @gen_id) AS parts,
  (SELECT COUNT(*) FROM service_intervals  WHERE generation_id = @gen_id) AS service_intervals,
  (SELECT COUNT(*) FROM tire_pressures     WHERE generation_id = @gen_id) AS tire_pressures;
