-- Hyundai Ioniq 5 (NE1) moat fill — 2021-2024 BEV, E-GMP platform
-- Cross-verified against startmycar.com fuse-box (2022 Ioniq 5, 48+64
-- positions extracted live), HaynesPro WorkshopData, Hyundai OM.
-- Different from Tesla: dedicated 800 V E-GMP, 2-speed reducer on some
-- AWD trims, V2L (vehicle-to-load) outlet capability.

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = 'NE1' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Hyundai Ioniq 5 (NE1) Service Manual' AND is_public = 1 LIMIT 1);

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/hyundai/ioniq-5-ne1-suv-2021-2024/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
  'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:Hyundai_Ioniq_5_IAA_2021_1X7A0189.jpg',
  CURDATE(), 'Hyundai Ioniq 5 (NE1)', '3-4-front', 1280, 662
FROM generations g WHERE g.id = @gen_id;

-- BEV: coolant + reducer + brake + A/C. No engine oil, no transmission ATF.
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'coolant',         8.40, 8.87, NULL,    'Hyundai Long Life Coolant (low-conductivity, blue)', NULL, NULL,  NULL,   NULL, 'Combined battery + motor + heat-pump loop. Low-conductivity EV-specific coolant — never use ICE green/orange OAT.'),
  (@gen_id, NULL, 'gearbox',         1.10, 1.16, NULL,    'Hyundai EV Reducer Oil (Diff Oil G ICE)',           NULL, 150000,240000, NULL, 'Single-speed reducer (2 motors on AWD). Hyundai labels lifetime; tracked owners change at 100k mi.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 4', 'DOT 4 LV (Hyundai Genuine)',                        NULL, NULL,  NULL,   24, 'Every 2 years; iBAU (integrated brake actuation unit) needs DOT 4 LV specifically.'),
  (@gen_id, NULL, 'ac_refrigerant',  1.00, 1.06, NULL,    'R-1234yf · POE oil (NOT PAG)',                      NULL, NULL,  NULL,   NULL, 'Heat-pump system uses electric compressor — POE oil only; PAG damages compressor windings. Charge weight 1000 ±15 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       110, 81,  'M14×1.5; star pattern.'),
  (@gen_id, NULL, 'caliper_bolt',  32,  24,  'Front caliper slide-pin.'),
  (@gen_id, NULL, 'caliper_bracket_bolt', 100, 74, 'Front carrier-to-knuckle.'),
  (@gen_id, NULL, 'gearbox_drain', 53,  39,  'Front/rear reducer drain.'),
  (@gen_id, NULL, 'half-shaft_nut', 280, 207, 'Hub nut — high torque for AWD.'),
  (@gen_id, NULL, 'service_disconnect', 12, 9, 'HV service disconnect plug. Always disconnect before working on HV system.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, '12 V AGM (LN1/H4)', 380, 45, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED (Parametric Pixel)', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED', 2, 1),
  (@gen_id, NULL, 'drl',            'LED (Parametric Pixel)', 2, 1),
  (@gen_id, NULL, 'turn_front',     'LED', 2, 1),
  (@gen_id, NULL, 'brake_tail',     'LED (Parametric)', 2, 1),
  (@gen_id, NULL, 'reverse',        'LED', 2, 1),
  (@gen_id, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'interior_map',   'LED', 2, 1),
  (@gen_id, NULL, 'frunk',          'LED', 1, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

-- FUSES — REAL DATA from startmycar.com /hyundai/ioniq-5/info/fusebox/2022
-- E-GMP platform has unique IBU (Integrated Body Unit), VCU, ICCU, V2L unit
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'cabin',      '1',  15,  'Child Lock / Unlock Relay'),
  (@gen_id, NULL, 'cabin',      '2',  20,  'Steering / Heater Rear'),
  (@gen_id, NULL, 'cabin',      '4',  7.5, 'Overhead Console'),
  (@gen_id, NULL, 'cabin',      '6',  10,  'Head-Up Display'),
  (@gen_id, NULL, 'cabin',      '7',  7.5, 'VCU / IBU (vehicle control)'),
  (@gen_id, NULL, 'cabin',      '8',  20,  'SDC (Smart Door Control)'),
  (@gen_id, NULL, 'cabin',      '9',  10,  'Driver / Passenger Outside Mirror Unit'),
  (@gen_id, NULL, 'cabin',      '10', 15,  'Liftgate Release Relay'),
  (@gen_id, NULL, 'cabin',      '11', 10,  'Rear Inverter (V2L outlet)'),
  (@gen_id, NULL, 'cabin',      '13', 7.5, 'Multifunction Switch / Stop Lamp Switch'),
  (@gen_id, NULL, 'cabin',      '14', 7.5, 'Head-Up Display / Instrument Cluster'),
  (@gen_id, NULL, 'cabin',      '15', 10,  'V2L Unit / ICCU / VCMS / Rear EOP / CDM'),
  (@gen_id, NULL, 'engine_bay', 'LDC',150, 'Low-voltage DC-DC converter main'),
  (@gen_id, NULL, 'engine_bay', 'MDPS1',80, 'MDPS Unit (Motor-Driven Power Steering)'),
  (@gen_id, NULL, 'engine_bay', 'IEB1',50, 'IEB Unit (Integrated Electronic Brake)'),
  (@gen_id, NULL, 'engine_bay', 'IEB2',50, 'IEB Unit secondary'),
  (@gen_id, NULL, 'engine_bay', 'C/FAN',40, 'Cooling Fan Motor'),
  (@gen_id, NULL, 'engine_bay', 'IG1', 30, 'IG1 main relay (RLY.5/RLY.7)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'cabin_filter',  '97133-GI000',   'Hyundai', NULL, NULL,    'HEPA + activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', '98350-GI000',   'Hyundai', NULL, '26 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '98360-GI000',   'Hyundai', NULL, '16 in', 'Passenger side'),
  (@gen_id, NULL, 'brake_pad_front','58101-GI100',  'Hyundai', NULL, NULL,    'Front pad set (iBAU one-box brake actuator)'),
  (@gen_id, NULL, 'brake_pad_rear', '58302-GI300',  'Hyundai', NULL, NULL,    'Rear pad set');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, 'Critical on dual-motor AWD — torque vectoring needs matched tread.'),
  (@gen_id, NULL, 'brake_inspection',       NULL,  NULL,  NULL,  NULL,  12,   'Annual. iBAU brake-by-wire reduces pad wear vs ICE.'),
  (@gen_id, NULL, 'cabin_air_filter',       NULL,  NULL,  NULL,  NULL,  24,   'Every 2 years.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24,   'DOT 4 LV. Critical for iBAU.'),
  (@gen_id, NULL, 'reducer_fluid',          150000,NULL,  240000,NULL,  NULL, 'Hyundai lifetime; tracked owners change at 100k.'),
  (@gen_id, NULL, 'ac_desiccant',           NULL,  NULL,  NULL,  NULL,  72,   'Heat-pump system desiccant every 6 yr.'),
  (@gen_id, NULL, 'wiper_blades',           NULL,  NULL,  NULL,  NULL,  12,   'Annual.'),
  (@gen_id, NULL, 'hv_battery_inspection',  NULL,  NULL,  NULL,  NULL,  12,   'Annual HV pack health check at Hyundai dealer (Bluelink reports remote).');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 36, 250, '235/55 R19 105V'),
  (@gen_id, NULL, 'rear',  'normal', 36, 250, '235/55 R19 105V'),
  (@gen_id, NULL, 'front', 'normal', 38, 260, '255/45 R20 105V (Limited)'),
  (@gen_id, NULL, 'rear',  'normal', 38, 260, '255/45 R20 105V (Limited)'),
  (@gen_id, NULL, 'spare', 'normal', 0,  0,   'Tirefit kit (no spare)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src_oem FROM tire_pressures WHERE generation_id = @gen_id;
