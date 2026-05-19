-- Porsche 911 (992) moat fill — 8th-gen, 2019-2024 (992.1 pre-facelift)
-- Cross-verified against HaynesPro WorkshopData (Porsche → 911 992),
-- Porsche OM, Porsche Tequipment catalog. Flat-six 3.0 twin-turbo (9A2 EVO).

SET NAMES utf8mb4;
SET @gen_id := (SELECT id FROM generations WHERE codename = '992' LIMIT 1);
SET @src_oem := (SELECT id FROM sources WHERE citation = 'Porsche 911 (992) Service Manual' AND is_public = 1 LIMIT 1);
SELECT @gen_id AS gen_id, @src_oem AS src_oem;

INSERT IGNORE INTO images
  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
SELECT g.id, NULL, NULL,
  '/images/porsche/911-992-coupe-2019-2024/hero.jpg',
  'wikimedia', 'cc-by-sa-4.0',
  'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
  'https://commons.wikimedia.org/wiki/File:Porsche_992_Carrera_S_coupe_IMG_5838.jpg',
  CURDATE(),
  'Porsche 911 (992) Carrera S Coupe',
  '3-4-front', 1280, 628
FROM generations g WHERE g.id = @gen_id;

-- 3.0 twin-turbo flat-six (9A2 EVO MDH.NA) — Carrera S / 4S / GTS
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen_id, NULL, 'engine_oil',      8.50, 8.98, '0W-40', 'Porsche C40 / ACEA A3/B4 (Mobil 1 0W-40)',          '9A110722400', 10000, 15000, 12, '3.0 9A2 EVO twin-turbo · 8.98 US qt with filter. GT3 4.0 NA: 9.5 qt 0W-40. PDK transmission has its own service.'),
  (@gen_id, NULL, 'transmission_pdk',8.50, 8.98, NULL,    'Porsche PDK fluid (9A132002500)',                   '95830509100', 75000, 120000, NULL, '8-speed PDK (only on 992; 7-speed manual available on GTS). Total dry capacity; Porsche labels lifetime.'),
  (@gen_id, NULL, 'front_differential',1.10, 1.16, NULL,  'Porsche 75W-90 GL-5 (000043205254)',                NULL,         60000, 96000, NULL, '4WD models (Carrera 4 / 4S / 4 GTS) only.'),
  (@gen_id, NULL, 'coolant',         24.0, 25.4, NULL,    'Porsche coolant (000043301357, pink HOAT)',          NULL,         NULL,  NULL,   NULL, 'Lifetime fill per Porsche; rear-engine + front radiator + dual-circuit. Large total volume.'),
  (@gen_id, NULL, 'brake',           NULL, NULL, 'DOT 4', 'Porsche DOT 4 plus (00004330616)',                  NULL,         NULL,  NULL,   24,   'Every 2 years; track use shortens to annual.'),
  (@gen_id, NULL, 'ac_refrigerant',  0.60, 0.63, NULL,    'R-1234yf · PAG oil ND-12',                          NULL,         NULL,  NULL,   NULL, 'Charge weight 600 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src_oem FROM fluid_specs WHERE generation_id = @gen_id;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen_id, NULL, 'lug_nut',       160, 118, 'M14×1.5; center-lock on Turbo/GT models is 600 N·m via tool.'),
  (@gen_id, NULL, 'spark_plug',    27,  20,  'NGK PMR8C iridium (9A2 EVO flat-six).'),
  (@gen_id, NULL, 'oil_drain',     50,  37,  'M22×1.5; new copper crush washer each service.'),
  (@gen_id, NULL, 'caliper_bolt',  85,  63,  'Front caliper-to-knuckle. Brembo six-piston (S+) or four-piston (base).'),
  (@gen_id, NULL, 'pdk_drain',     35,  26,  'PDK transaxle drain plug.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src_oem FROM torque_specs WHERE generation_id = @gen_id;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen_id, NULL, 'LN5 H8 AGM (lithium opt)', 850, 90, 220);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src_oem FROM electrical_specs WHERE generation_id = @gen_id;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_id, NULL, 'headlight_low',  'LED Matrix', 2, 1),
  (@gen_id, NULL, 'headlight_high', 'LED Matrix', 2, 1),
  (@gen_id, NULL, 'drl',            'LED', 2, 1),
  (@gen_id, NULL, 'turn_front',     'LED', 2, 1),
  (@gen_id, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen_id, NULL, 'reverse',        'LED', 2, 1),
  (@gen_id, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen_id, NULL, 'license_plate',  'LED', 2, 1),
  (@gen_id, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen_id, NULL, 'frunk',          'LED', 1, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src_oem FROM bulbs WHERE generation_id = @gen_id;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen_id, NULL, 'frunk',     'F01', 250, 'Battery main / megafuse'),
  (@gen_id, NULL, 'frunk',     'F05', 250, 'Alternator'),
  (@gen_id, NULL, 'frunk',     'F08', 80,  'EPS'),
  (@gen_id, NULL, 'frunk',     'F11', 60,  'PSM / ABS'),
  (@gen_id, NULL, 'cabin',     'F30', 7.5, 'Instrument cluster'),
  (@gen_id, NULL, 'cabin',     'F38', 25,  'PCM 6.0 infotainment'),
  (@gen_id, NULL, 'cabin',     'F42', 30,  'Driver power window'),
  (@gen_id, NULL, 'cabin',     'F50', 40,  'Climate blower'),
  (@gen_id, NULL, 'cabin',     'F55', 25,  'Heated/ventilated seats'),
  (@gen_id, NULL, 'engine_bay','F70', 30,  'Engine ECU (DME)'),
  (@gen_id, NULL, 'engine_bay','F75', 30,  'Cooling fan main'),
  (@gen_id, NULL, 'engine_bay','F80', 20,  'Ignition coils');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src_oem FROM fuses WHERE generation_id = @gen_id;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen_id, NULL, 'spark_plug',    '94717213910',   'Porsche', 0.80, NULL,    '9A2 EVO NGK PMR8C iridium'),
  (@gen_id, NULL, 'oil_filter',    '9A110722400',   'Porsche', NULL, NULL,    'Cartridge; 3.0 twin-turbo'),
  (@gen_id, NULL, 'air_filter',    '9A2110131',     'Porsche', NULL, NULL,    'Twin filters (one per turbo bank)'),
  (@gen_id, NULL, 'cabin_filter',  '992819441A',    'Porsche', NULL, NULL,    'Activated carbon'),
  (@gen_id, NULL, 'wiper_front_d', '9G2955425',     'Porsche', NULL, '22 in', 'Driver side'),
  (@gen_id, NULL, 'wiper_front_p', '9G2955426',     'Porsche', NULL, '20 in', 'Passenger side');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src_oem FROM parts WHERE generation_id = @gen_id;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen_id, NULL, 'engine_oil_and_filter',  10000, 5000,  15000, 8000,  12, 'Porsche flex service. Track use shortens dramatically.'),
  (@gen_id, NULL, 'tire_rotation',          NULL,  NULL,  NULL,  NULL,  NULL, 'N/A — staggered fitment (245F/305R) prevents rotation. Per-axle replacement.'),
  (@gen_id, NULL, 'brake_inspection',       10000, 5000,  15000, 8000,  NULL, 'PCCB ceramic (option) inspection has unique limits.'),
  (@gen_id, NULL, 'engine_air_filter',      40000, 20000, 64000, 32000, NULL, 'Twin filters — both sides.'),
  (@gen_id, NULL, 'cabin_air_filter',       20000, 10000, 32000, 16000, 24,   NULL),
  (@gen_id, NULL, 'transmission_pdk_fluid', 75000, 30000, 120000,48000, NULL, '8-speed PDK; Porsche labels lifetime, track owners 30k.'),
  (@gen_id, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24,   'DOT 4 plus. Track use: annually.'),
  (@gen_id, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, 'NGK PMR8C iridium (six plugs total).'),
  (@gen_id, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  NULL, 'Porsche coolant lifetime fill.'),
  (@gen_id, NULL, 'pdk_clutch_inspection',  60000, NULL,  96000, NULL,  NULL, 'PDK dual-clutch wear check.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src_oem FROM service_intervals WHERE generation_id = @gen_id;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_id, NULL, 'front', 'normal', 35, 240, '245/35 R20 91Y'),
  (@gen_id, NULL, 'rear',  'normal', 41, 280, '305/30 R21 100Y'),
  (@gen_id, NULL, 'front', 'normal', 36, 250, '245/35 ZR20 (Turbo S spec)'),
  (@gen_id, NULL, 'rear',  'normal', 42, 290, '315/30 ZR21 (Turbo S spec)'),
  (@gen_id, NULL, 'spare', 'normal', 0,  0,   'Tire repair kit (no spare)');
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
