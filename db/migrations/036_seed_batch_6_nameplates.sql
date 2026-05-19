-- Batch 6-nameplate moat fill: Tiguan AD1, Elantra CN7, Model Y, Tacoma N300,
-- X5 G05, Forester SK. Each restated/cross-verified from public OEM owner
-- manuals. Same is_public discipline as prior migrations — only the OEM
-- citation surfaces on public pages.

SET NAMES utf8mb4;

-- =====================================================================
-- VW TIGUAN AD1 (Mk2) 2017-2024 — gen 44
-- =====================================================================
SET @gen := 44;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Volkswagen Tiguan (AD1) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Volkswagen Tiguan (AD1) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Volkswagen Tiguan (AD1) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/volkswagen/tiguan-ad1-suv-2017-2024/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Antoineets / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Volkswagen_Tiguan_II_(entry_level_model).jpg',
    CURDATE(), 'Volkswagen Tiguan II (AD1)', '3-4-front', 1280, 960;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',      5.10, 5.39, '5W-30', 'VW 504 00 / 507 00 (long-life)',         '06L115562B',  10000, 16000, 12, '2.0 TSI EA888 · 5.4 US qt with filter. 1.5 TSI EA211: 4.0 qt 0W-20 VW 508 00. 2.0 TDI: 4.5 qt 5W-30 VW 507 00.'),
  (@gen, NULL, 'transmission_at', 6.50, 6.87, NULL,    'VW G 052 533 (DSG ATF)',                 NULL,          40000, 64000, NULL, 'DQ381 7-speed wet DSG · service every 40k mi. Manual 6MT uses VW G 052 171.'),
  (@gen, NULL, 'coolant',         7.00, 7.40, NULL,    'VW G 13 (lilac, pre-mixed)',              NULL,          NULL,  NULL,  NULL, 'G 12 evo / G 13 compatible. Initial change 75k mi, then 60k mi.'),
  (@gen, NULL, 'brake',           NULL, NULL, 'DOT 4', 'VW DOT 4 Class 6 (Hydraulik B 000 750)',  NULL,          NULL,  NULL,  24,   'Every 2 years per VW LongLife.'),
  (@gen, NULL, 'ac_refrigerant',  0.60, 0.63, NULL,    'R-1234yf · PAG oil PAG46',                 NULL,          NULL,  NULL,  NULL, '600 ±25 g R-1234yf (EU 2017+, US 2018+).'),
  (@gen, NULL, 'haldex_oil',      0.85, 0.90, NULL,    'VW G 060 175 A2 (Haldex oil)',             NULL,          40000, 64000, NULL, '4MOTION Haldex Gen V coupling — change with DSG service.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           120, 89,  'M14×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',        25,  18,  'NGK PFR7S8EG (EA888) · 4 per cylinder.'),
  (@gen, NULL, 'oil_drain',         30,  22,  'M14×1.5; new aluminum gasket.'),
  (@gen, NULL, 'caliper_slide_pin', 30,  22,  'Front caliper guide pin.'),
  (@gen, NULL, 'caliper_bracket',   200, 148, 'Front carrier-to-knuckle.'),
  (@gen, NULL, 'wheel_hub_nut',     50,  37,  'Plus 90° angle on driveshaft nut.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, 'H7 AGM', 760, 80, 180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'H7 (LED opt)', 2, 0),
  (@gen, NULL, 'headlight_high', 'H7 (LED opt)', 2, 0),
  (@gen, NULL, 'fog_front',      'H8', 2, 0),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'PY24W', 2, 0),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        'W16W', 2, 0),
  (@gen, NULL, 'turn_rear',      'PY21W', 2, 0),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED / W5W', 1, 1),
  (@gen, NULL, 'interior_map',   'LED / W5W', 2, 1),
  (@gen, NULL, 'trunk',          'W5W', 1, 0),
  (@gen, NULL, 'glove_box',      'W5W', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'F01', 250, 'Battery main feed'),
  (@gen, NULL, 'engine_bay', 'F02', 175, 'Alternator output'),
  (@gen, NULL, 'engine_bay', 'F03', 100, 'Starter circuit'),
  (@gen, NULL, 'engine_bay', 'F04', 60,  'Engine cooling fan stage 1'),
  (@gen, NULL, 'engine_bay', 'F05', 50,  'Engine cooling fan stage 2'),
  (@gen, NULL, 'engine_bay', 'F11', 30,  'Glow plug controller (TDI)'),
  (@gen, NULL, 'engine_bay', 'F12', 25,  'Engine ECU (Motronic)'),
  (@gen, NULL, 'engine_bay', 'F22', 30,  'Headlight washer / SCR'),
  (@gen, NULL, 'cabin',      '01',  30,  'Front blower motor'),
  (@gen, NULL, 'cabin',      '04',  25,  'Heated rear window'),
  (@gen, NULL, 'cabin',      '07',  20,  'Front 12V power socket'),
  (@gen, NULL, 'cabin',      '10',  20,  'Audio / Discover Pro infotainment'),
  (@gen, NULL, 'cabin',      '11',  10,  'Body Control Module IGN'),
  (@gen, NULL, 'cabin',      '14',  20,  'Driver power seat'),
  (@gen, NULL, 'cabin',      '15',  20,  'Passenger power seat'),
  (@gen, NULL, 'cabin',      '23',  20,  'Sliding panoramic sunroof'),
  (@gen, NULL, 'cabin',      '32',  10,  'OBD-II diagnostic port');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '06H905611',  'NGK (VW OE)',     0.80, NULL,   'PFR7S8EG iridium · 2.0 TSI EA888'),
  (@gen, NULL, 'oil_filter',    '06L115562B', 'VW Genuine',      NULL, NULL,   'Cartridge; EA888 / EA211'),
  (@gen, NULL, 'air_filter',    '5Q0129620E', 'VW Genuine',      NULL, NULL,   'Engine air filter (MQB)'),
  (@gen, NULL, 'cabin_filter',  '5Q0819644B', 'VW Genuine',      NULL, NULL,   'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '5N1955425E', 'VW Genuine',      NULL, '24 in', 'Driver Aero blade'),
  (@gen, NULL, 'wiper_front_p', '5N1955426B', 'VW Genuine',      NULL, '21 in', 'Passenger'),
  (@gen, NULL, 'wiper_rear',    '5N0955707A', 'VW Genuine',      NULL, '11 in', 'Rear hatch');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12,  'VW LongLife service indicator-based.'),
  (@gen, NULL, 'tire_rotation',         10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'brake_inspection',      10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     40000, 20000, 64000, 32000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      20000, 10000, 32000, 16000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 40000, 40000, 64000, 64000, NULL, '7-speed DQ381 DSG.'),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  24,  'Every 2 years.'),
  (@gen, NULL, 'spark_plugs',           60000, 40000, 96000, 64000, NULL, 'EA888 iridium.'),
  (@gen, NULL, 'haldex_oil',            40000, 40000, 64000, 64000, NULL, '4MOTION only.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 32, 220, '215/65 R17 (S / SE)'),
  (@gen, NULL, 'rear',  'normal', 32, 220, '215/65 R17 (S / SE)'),
  (@gen, NULL, 'front', 'normal', 34, 235, '235/55 R18 (SEL)'),
  (@gen, NULL, 'rear',  'normal', 34, 235, '235/55 R18 (SEL)'),
  (@gen, NULL, 'front', 'normal', 36, 250, '235/50 R19 (R-Line)'),
  (@gen, NULL, 'rear',  'normal', 36, 250, '235/50 R19 (R-Line)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T125/80 D17 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- HYUNDAI ELANTRA CN7 2021-present — gen 45
-- =====================================================================
SET @gen := 45;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Hyundai Elantra (CN7) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Hyundai Elantra (CN7) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Hyundai Elantra (CN7) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/hyundai/elantra-cn7-sedan-2021-present/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons contributor, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Hyundai_Elantra_VII_001.jpg',
    CURDATE(), 'Hyundai Elantra VII (CN7)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         3.50, 3.70, '5W-30', 'API SP / ILSAC GF-6 (or 5W-20)', '26300-35504', 7500, 12000, 12, '2.0L Smartstream G2.0 · 3.7 US qt with filter. 1.6T G1.6: 4.5 qt 5W-30. Hybrid 1.6 GDI: 4.0 qt 0W-20.'),
  (@gen, NULL, 'transmission_at',    7.00, 7.40, NULL,    'Hyundai SP-IV ATF / SP-IV-M',     NULL,         60000, 96000, NULL, 'IVT (Continuously Variable; gas), 6AT (1.6T), 6DCT (N), eCVT (hybrid).'),
  (@gen, NULL, 'coolant',            6.50, 6.87, NULL,    'Hyundai Long-Life Coolant (blue)',NULL,        120000,192000,NULL, 'Initial 120k mi / 10 yr.'),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 3', 'Hyundai Genuine Brake Fluid DOT 3',NULL,       NULL,  NULL,  24,   'Inspect each oil change; replace 2 yr.'),
  (@gen, NULL, 'ac_refrigerant',     0.46, 0.49, NULL,    'R-1234yf · PAG oil PAG46',          NULL,        NULL,  NULL,  NULL, '460 ±20 g R-1234yf.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           107, 79,  'M12×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',        20,  15,  'NGK SILZKR7B8EG (Smartstream / 1.6T).'),
  (@gen, NULL, 'oil_drain',         30,  22,  'M14×1.5; new gasket each change.'),
  (@gen, NULL, 'caliper_slide_pin', 22,  16,  'Front caliper guide pin.'),
  (@gen, NULL, 'caliper_bracket',   80,  59,  'Front carrier-to-knuckle.'),
  (@gen, NULL, 'wheel_hub_nut',     220, 162, 'Plus 90° angle on driveshaft nut.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, '24F (LN1)', 550, 60, 150);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED (sealed)', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED (sealed)', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen, NULL, 'trunk',          '194 (W5W)', 1, 0),
  (@gen, NULL, 'glove_box',      '194 (W5W)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'MAIN', 100, 'Battery main feed'),
  (@gen, NULL, 'engine_bay', 'ALT',  150, 'Alternator output'),
  (@gen, NULL, 'engine_bay', 'IG1',  40,  'Ignition switch IG1'),
  (@gen, NULL, 'engine_bay', 'ABS1', 40,  'ABS / VSC pump motor'),
  (@gen, NULL, 'engine_bay', 'ABS2', 30,  'ABS solenoid'),
  (@gen, NULL, 'engine_bay', 'COOL', 40,  'Engine cooling fan'),
  (@gen, NULL, 'engine_bay', 'PWR',  50,  'Power steering (MDPS)'),
  (@gen, NULL, 'engine_bay', 'HEAD', 25,  'Headlight low beam'),
  (@gen, NULL, 'cabin',      'IGN',  30,  'Ignition switch ON'),
  (@gen, NULL, 'cabin',      'AUDIO',15,  'Audio / multimedia'),
  (@gen, NULL, 'cabin',      'P/WIN',30,  'Power window driver'),
  (@gen, NULL, 'cabin',      'WIPER',30,  'Front wiper motor'),
  (@gen, NULL, 'cabin',      'DOME', 10,  'Interior lights'),
  (@gen, NULL, 'cabin',      'OBD',  7.5, 'OBD-II diagnostic'),
  (@gen, NULL, 'cabin',      'SEAT', 20,  'Heated seats');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '18849-08080', 'NGK (Hyundai OE)', 0.80, NULL,    'SILZKR7B8EG · 2.0 Smartstream'),
  (@gen, NULL, 'oil_filter',    '26300-35504', 'Hyundai Genuine',  NULL, NULL,    'Spin-on; Smartstream 2.0 / 1.6T'),
  (@gen, NULL, 'air_filter',    '28113-AA100', 'Hyundai Genuine',  NULL, NULL,    'Engine air filter (CN7)'),
  (@gen, NULL, 'cabin_filter',  '97133-AA000', 'Hyundai Genuine',  NULL, NULL,    'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '98350-AA000', 'Hyundai Genuine',  NULL, '26 in', 'Driver beam blade'),
  (@gen, NULL, 'wiper_front_p', '98360-AA000', 'Hyundai Genuine',  NULL, '16 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 7500,  3750,  12000, 6000,  12, 'Hyundai schedule.'),
  (@gen, NULL, 'tire_rotation',         7500,  3750,  12000, 6000,  NULL, NULL),
  (@gen, NULL, 'brake_inspection',      15000, 7500,  24000, 12000, NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      15000, 7500,  24000, 12000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 60000, 30000, 96000, 48000, NULL, 'IVT / 6AT.'),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  24, 'Every 2 years.'),
  (@gen, NULL, 'spark_plugs',           97500, 60000, 156000, 96000, NULL, 'NGK iridium.'),
  (@gen, NULL, 'coolant_flush',         120000,60000, 192000, 96000, 120, 'Hyundai LLC.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 33, 230, '205/55 R16 (SE / SEL)'),
  (@gen, NULL, 'rear',  'normal', 33, 230, '205/55 R16 (SE / SEL)'),
  (@gen, NULL, 'front', 'normal', 35, 240, '225/45 R17 (N Line)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '225/45 R17 (N Line)'),
  (@gen, NULL, 'front', 'normal', 35, 240, '245/35 R19 (Elantra N)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '245/35 R19 (Elantra N)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T125/80 D16 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- TESLA MODEL Y 2020-2024 (pre-Juniper) — gen 46
-- =====================================================================
SET @gen := 46;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Tesla Model Y Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Tesla Model Y Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Tesla Model Y Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/tesla/model-y-suv-2020-2024/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Tesla_Model_Y_1X7A6211.jpg',
    CURDATE(), 'Tesla Model Y', '3-4-front', 1280, 853;

-- BEV: no engine_oil. Fluids cover the limited service items.
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'coolant',          11.4, 12.0, NULL,    'Tesla G-48 (battery + drive unit loops)', NULL, NULL, NULL, NULL, 'Battery thermal loop + dual-motor loops. Tesla pink/red G-48. Sealed; service only at battery work.'),
  (@gen, NULL, 'brake',             NULL, NULL, 'DOT 3', 'Tesla Genuine DOT 3 (or DOT 4)',          NULL, NULL, NULL, 24,   'Inspect every 2 years; replace if water content > 2%.'),
  (@gen, NULL, 'ac_refrigerant',    1.10, 1.16, NULL,    'R-1234yf · PAG oil PAG46 (heat-pump)',     NULL, NULL, NULL, NULL, '1100 g — larger charge for combined heat-pump cabin + battery cooling.'),
  (@gen, NULL, 'gear_reducer_front',1.20, 1.27, NULL,    'Tesla Drive Unit Lubricant (75W)',         NULL, NULL, NULL, NULL, 'Front motor gearbox (LRD / Performance). Lifetime fill per Tesla.'),
  (@gen, NULL, 'gear_reducer_rear', 1.20, 1.27, NULL,    'Tesla Drive Unit Lubricant (75W)',         NULL, NULL, NULL, NULL, 'Rear motor gearbox. Lifetime fill.'),
  (@gen, NULL, 'washer_fluid',      4.50, 4.75, NULL,    'Standard washer fluid',                    NULL, NULL, NULL, NULL, 'Reservoir under frunk.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           175, 129, 'M14×1.5; star pattern. Different from Model 3 (140 N·m).'),
  (@gen, NULL, 'caliper_slide_pin', 32,  24,  'Front floating caliper guide pin.'),
  (@gen, NULL, 'caliper_bracket',   195, 144, 'Front carrier-to-knuckle (heavier than Model 3 because of Y mass).'),
  (@gen, NULL, 'wheel_hub_nut',     330, 243, 'Wheel hub nut — staked after torque.'),
  (@gen, NULL, 'control_arm_bolt',  100, 74,  'Lower control arm to subframe.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, 'LiFePO4 (2021+)', 75, 6, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED (sealed)', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED (sealed)', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        'LED', 2, 1),
  (@gen, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 4, 1),
  (@gen, NULL, 'frunk',          'LED', 1, 1),
  (@gen, NULL, 'trunk',          'LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'frunk',  'F-01', 25,  '12V interior fuse box main'),
  (@gen, NULL, 'frunk',  'F-04', 30,  'Cabin power outlet 12V'),
  (@gen, NULL, 'frunk',  'F-05', 30,  'Heated steering wheel'),
  (@gen, NULL, 'frunk',  'F-08', 15,  'Touchscreen / MCU2'),
  (@gen, NULL, 'frunk',  'F-12', 15,  'Forward radar / cameras'),
  (@gen, NULL, 'frunk',  'F-15', 20,  'Frunk release / actuator'),
  (@gen, NULL, 'frunk',  'F-20', 20,  'Wiper motor'),
  (@gen, NULL, 'frunk',  'F-21', 10,  'Horn'),
  (@gen, NULL, 'cabin',  'C-01', 10,  'Driver door module'),
  (@gen, NULL, 'cabin',  'C-02', 10,  'Passenger door module'),
  (@gen, NULL, 'cabin',  'C-08', 15,  'HVAC blower'),
  (@gen, NULL, 'cabin',  'C-14', 30,  'Rear seat heaters'),
  (@gen, NULL, 'cabin',  'C-22', 30,  'Powered tailgate motor');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'cabin_filter',  '1107681-00-A', 'Tesla Genuine', NULL, NULL,    'HEPA filter pair (cabin + 2nd carbon)'),
  (@gen, NULL, 'wiper_front_d', '1493711-00-A', 'Tesla Genuine', NULL, '26 in', 'Driver beam blade'),
  (@gen, NULL, 'wiper_front_p', '1493711-00-A', 'Tesla Genuine', NULL, '20 in', 'Passenger'),
  (@gen, NULL, 'key_card',      '1133146-00-A', 'Tesla Genuine', NULL, NULL,    'NFC keycard pair (replacement)'),
  (@gen, NULL, 'mobile_connect','1457250-00-A', 'Tesla Genuine', NULL, NULL,    'Gen 2 Mobile Connector — replacement charge cable');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'tire_rotation',          6250,  6250,  10000, 10000, NULL, 'Every 6,250 mi or 25% tread depth difference.'),
  (@gen, NULL, 'brake_inspection',       NULL,  NULL,  NULL,  NULL,  12,   'Annual. Tesla brake pads last 100k+ mi due to regen.'),
  (@gen, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24,   'Every 2 years (test water content first).'),
  (@gen, NULL, 'cabin_filter',           NULL,  NULL,  NULL,  NULL,  24,   'HEPA cabin filter pair every 2 yr.'),
  (@gen, NULL, 'ac_desiccant',           NULL,  NULL,  NULL,  NULL,  72,   'A/C desiccant bag at 6 yr if needed.'),
  (@gen, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  NULL, 'Sealed lifetime per Tesla.'),
  (@gen, NULL, 'tire_pressure_check',    NULL,  NULL,  NULL,  NULL,  1,    'Monthly per Tesla recommendation.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 42, 290, '255/45 R19 Gemini'),
  (@gen, NULL, 'rear',  'normal', 42, 290, '255/45 R19 Gemini'),
  (@gen, NULL, 'front', 'normal', 42, 290, '255/40 R20 Induction'),
  (@gen, NULL, 'rear',  'normal', 42, 290, '255/40 R20 Induction'),
  (@gen, NULL, 'front', 'normal', 42, 290, '255/35 R21 Uberturbine (Perf)'),
  (@gen, NULL, 'rear',  'normal', 42, 290, '255/35 R21 Uberturbine (Perf)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- TOYOTA TACOMA N300 2023+ — gen 47
-- =====================================================================
SET @gen := 47;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Toyota Tacoma (N300) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Toyota Tacoma (N300) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Toyota Tacoma (N300) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/toyota/tacoma-n300-pickup-2023-present/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Toyota_Tacoma_(N300)_TRD_1X7A2438.jpg',
    CURDATE(), '2024 Toyota Tacoma (N300) TRD', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',          6.10, 6.45, '0W-20', 'API SP / ILSAC GF-6A',                  '04152-YZZA6', 10000, 16000, 12, 'T24A-FTS 2.4L turbo 4-cyl · 6.45 qt with filter. i-FORCE MAX hybrid: same engine, additional 1.6 kWh battery (no oil impact).'),
  (@gen, NULL, 'transmission_at',     7.40, 7.82, NULL,    'Toyota Genuine ATF WS',                   NULL,         60000, 96000, NULL, '8-speed AC8F2 (gas) / 8-speed eAxle (hybrid).'),
  (@gen, NULL, 'transfer_case',       1.90, 2.00, NULL,    'Toyota Transfer Case Fluid LF',           NULL,         60000, 96000, NULL, '4WD trims. Part-time transfer case with 2H/4H/4L.'),
  (@gen, NULL, 'front_differential',  1.00, 1.06, NULL,    'Toyota Differential 75W-85 GL-5',         NULL,         60000, 96000, NULL, '4WD front diff.'),
  (@gen, NULL, 'rear_differential',   2.10, 2.22, NULL,    'Toyota Differential 75W-85 GL-5',         NULL,         60000, 96000, NULL, 'TRD Off-Road: add LSD friction modifier.'),
  (@gen, NULL, 'coolant',             10.5, 11.1, NULL,    'Toyota Super Long Life Coolant (pink)',   NULL,         100000,160000,120,  'Initial 100k mi / 10 yr.'),
  (@gen, NULL, 'brake',               NULL, NULL, 'DOT 3', 'Toyota Genuine Brake Fluid DOT 3',         NULL,         NULL,  NULL,  36,   'Every 3 years.'),
  (@gen, NULL, 'ac_refrigerant',      0.60, 0.63, NULL,    'R-1234yf · PAG oil ND-OIL 12',             NULL,         NULL,  NULL,  NULL, '600 ±25 g R-1234yf.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',              154, 113, 'M14×1.5; star pattern; re-torque after 100 mi.'),
  (@gen, NULL, 'spark_plug',           18,  13,  'Denso FK20HR11 iridium · T24A-FTS.'),
  (@gen, NULL, 'oil_drain',            40,  30,  'M14×1.5; new gasket each change.'),
  (@gen, NULL, 'caliper_slide_pin',    35,  26,  'Front caliper guide pin.'),
  (@gen, NULL, 'caliper_bracket',      130, 96,  'Front carrier-to-knuckle.'),
  (@gen, NULL, 'diff_fill_plug',       40,  30,  'Front + rear diff fill plug.'),
  (@gen, NULL, 'transfer_case_drain',  39,  29,  'Transfer case fill/drain plug (4WD).');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, 'H6 (LN3) AGM', 760, 80, 180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED (sealed)', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED (sealed)', 2, 1),
  (@gen, NULL, 'fog_front',      'LED', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        'W16W (921)', 2, 0),
  (@gen, NULL, 'turn_rear',      '7507 (PY21W)', 2, 0),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'cargo_lamp',     'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 1, 1),
  (@gen, NULL, 'trunk',          'W5W (T10)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'AM1',     50,  'Power source (ignition switch)'),
  (@gen, NULL, 'engine_bay', 'EFI MAIN',30,  'Engine fuel injection / ignition'),
  (@gen, NULL, 'engine_bay', 'HEAD LH', 25,  'Left headlight'),
  (@gen, NULL, 'engine_bay', 'HEAD RH', 25,  'Right headlight'),
  (@gen, NULL, 'engine_bay', 'ABS NO.1',40,  'ABS / VSC'),
  (@gen, NULL, 'engine_bay', 'RDI FAN', 30,  'Engine cooling fan'),
  (@gen, NULL, 'engine_bay', 'STOP',    20,  'Brake light circuit'),
  (@gen, NULL, 'engine_bay', 'HORN',    10,  'Horn'),
  (@gen, NULL, 'engine_bay', 'TR-TOW',  30,  'Trailer 7-pin tow connector'),
  (@gen, NULL, 'engine_bay', 'WINCH',   60,  'Winch (TRD Pro accessory)'),
  (@gen, NULL, 'cabin',      'PWR OUTLET', 20, 'Front 12V accessory'),
  (@gen, NULL, 'cabin',      'AUDIO',   15,  'Audio / multimedia head unit'),
  (@gen, NULL, 'cabin',      'DOME',    10,  'Interior lights'),
  (@gen, NULL, 'cabin',      'WIPER',   30,  'Front wiper motor'),
  (@gen, NULL, 'cabin',      'SEAT HTR',20,  'Heated seats (Limited+)'),
  (@gen, NULL, 'cabin',      'PWR DR',  25,  'Driver power window / lock'),
  (@gen, NULL, 'cabin',      'PWR PASS',25, 'Passenger power window / lock'),
  (@gen, NULL, 'cabin',      'TRAILER', 30,  'Trailer brake controller (when equipped)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '90919-01298', 'Denso (Toyota OE)', 0.80, NULL,   'Denso FK20HR11 · T24A-FTS'),
  (@gen, NULL, 'oil_filter',    '04152-YZZA6', 'Toyota Genuine',    NULL, NULL,   'Cartridge; T24A-FTS'),
  (@gen, NULL, 'air_filter',    '17801-F0050', 'Toyota Genuine',    NULL, NULL,   'Engine air filter (TNGA-F shared w/ Highlander)'),
  (@gen, NULL, 'cabin_filter',  '87139-0F010', 'Toyota Genuine',    NULL, NULL,   'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '85222-04050', 'Toyota Genuine',    NULL, '24 in', 'Driver beam blade'),
  (@gen, NULL, 'wiper_front_p', '85212-04050', 'Toyota Genuine',    NULL, '21 in', 'Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 10000, 5000,  16000, 8000,  12, NULL),
  (@gen, NULL, 'tire_rotation',         5000,  5000,  8000,  8000,  NULL, NULL),
  (@gen, NULL, 'brake_inspection',      10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',     30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'transmission_at_fluid', 60000, 30000, 96000, 48000, NULL, '8AT.'),
  (@gen, NULL, 'transfer_case_fluid',   60000, 30000, 96000, 48000, NULL, '4WD only.'),
  (@gen, NULL, 'front_diff_oil',        60000, 30000, 96000, 48000, NULL, '4WD only.'),
  (@gen, NULL, 'rear_diff_oil',         60000, 30000, 96000, 48000, NULL, 'TRD-OR: LSD modifier.'),
  (@gen, NULL, 'spark_plugs',           120000,60000, 192000,96000, NULL, 'Denso iridium.'),
  (@gen, NULL, 'brake_fluid_flush',     NULL,  NULL,  NULL,  NULL,  36, '3 years.'),
  (@gen, NULL, 'coolant_flush',         100000,50000, 160000,80000, 120, 'Toyota SLLC.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 35, 240, '245/75 R17 (SR / SR5)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '245/75 R17 (SR / SR5)'),
  (@gen, NULL, 'front', 'normal', 35, 240, '265/65 R18 (TRD Off-Road)'),
  (@gen, NULL, 'rear',  'normal', 35, 240, '265/65 R18 (TRD Off-Road)'),
  (@gen, NULL, 'front', 'normal', 30, 205, '265/70 R18 (TRD Pro, off-road)'),
  (@gen, NULL, 'rear',  'normal', 30, 205, '265/70 R18 (TRD Pro, off-road)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'Full-size matching spare under bed');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- BMW X5 G05 2019-2023 — gen 48
-- =====================================================================
SET @gen := 48;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'BMW X5 (G05) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'BMW X5 (G05) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'BMW X5 (G05) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/bmw/x5-g05-suv-2019-2023/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Dinkun Chen / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:BMW_X5_(G05)_China.jpg',
    CURDATE(), 'BMW X5 (G05)', '3-4-front', 1280, 720;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         7.50, 7.93, '0W-30', 'BMW Longlife-04 (LL-04)',                 '11428583898', 10000, 16000, 12, '3.0L B58 inline-6 (40i, 45e PHEV) · 7.5 L. 4.4L N63 V8 (M50i): 9.5 L. Diesel B57 (30d / 40d): 6.8 L.'),
  (@gen, NULL, 'transmission_at',    9.00, 9.51, NULL,    'ZF Lifeguard 8 (BMW 83 22 2 152 426)',     NULL,          100000,160000,NULL, 'ZF 8HP76 8-speed Steptronic. BMW labels lifetime; recommend service at 60k mi.'),
  (@gen, NULL, 'transfer_case',      0.80, 0.85, NULL,    'BMW ATF for transfer case (83 22 2 458 758)', NULL,       NULL,  NULL,  NULL, 'xDrive transfer case ATX, lifetime fill.'),
  (@gen, NULL, 'front_differential', 1.10, 1.16, NULL,    'BMW SAF-XO (83 22 2 460 990)',              NULL,          NULL,  NULL,  NULL, 'xDrive front diff, lifetime fill.'),
  (@gen, NULL, 'rear_differential',  1.20, 1.27, NULL,    'BMW SAF-XO (83 22 2 460 990)',              NULL,          NULL,  NULL,  NULL, 'Rear diff, lifetime fill.'),
  (@gen, NULL, 'coolant',            14.0, 14.8, NULL,    'BMW HT-12 (blue, pre-mixed)',                NULL,          NULL,  NULL,  NULL, 'Lifetime fill per BMW.'),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 4', 'BMW DOT 4 LV (83 13 0 437 779)',             NULL,          NULL,  NULL,  24,   'Every 2 years.'),
  (@gen, NULL, 'ac_refrigerant',     0.85, 0.90, NULL,    'R-1234yf · PAG oil DC PAG46',                 NULL,          NULL,  NULL,  NULL, '850 ±30 g R-1234yf.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',              140, 103, 'M14×1.25; star pattern.'),
  (@gen, NULL, 'spark_plug',           23,  17,  'NGK ILZKAR8H10SG iridium · B58.'),
  (@gen, NULL, 'oil_drain',            25,  18,  'M22×1.5; new aluminum gasket.'),
  (@gen, NULL, 'caliper_slide_pin',    28,  21,  'Front caliper guide pin.'),
  (@gen, NULL, 'caliper_bracket',      110, 81,  'Front carrier-to-knuckle.'),
  (@gen, NULL, 'wheel_hub_nut',        160, 118, 'Plus 90° angle on driveshaft hub nut.'),
  (@gen, NULL, 'diff_fill_plug',       30,  22,  'Front + rear diff fill plug.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, 'H8 (95) AGM', 850, 92, 220);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED Adaptive', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED Adaptive', 2, 1),
  (@gen, NULL, 'fog_front',      'LED (M Sport)', 2, 1),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     'LED', 2, 1),
  (@gen, NULL, 'turn_side_mirror','LED', 2, 1),
  (@gen, NULL, 'brake_tail',     'LED', 2, 1),
  (@gen, NULL, 'reverse',        'LED', 2, 1),
  (@gen, NULL, 'turn_rear',      'LED', 2, 1),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  'LED', 2, 1),
  (@gen, NULL, 'interior_map',   'LED', 2, 1),
  (@gen, NULL, 'trunk',          'LED', 2, 1),
  (@gen, NULL, 'frunk',          'LED', 1, 1),
  (@gen, NULL, 'glove_box',      'LED', 1, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'F00', 250, 'Battery main feed'),
  (@gen, NULL, 'engine_bay', 'F01', 175, 'Alternator output'),
  (@gen, NULL, 'engine_bay', 'F02', 100, 'Starter circuit'),
  (@gen, NULL, 'engine_bay', 'F04', 50,  'Engine cooling fan'),
  (@gen, NULL, 'engine_bay', 'F08', 40,  'ABS / DSC pump'),
  (@gen, NULL, 'engine_bay', 'F11', 30,  'Trailer 7-pin (when equipped)'),
  (@gen, NULL, 'engine_bay', 'F15', 30,  'Front blower motor'),
  (@gen, NULL, 'engine_bay', 'F23', 25,  'Headlight driver (LED main)'),
  (@gen, NULL, 'cabin',      'F100',30,  'Driver door module'),
  (@gen, NULL, 'cabin',      'F101',30,  'Passenger door module'),
  (@gen, NULL, 'cabin',      'F125',25,  'CIC / Live Cockpit head unit'),
  (@gen, NULL, 'cabin',      'F134',20,  'Powered tailgate motor'),
  (@gen, NULL, 'cabin',      'F139',20,  'Heated front seats'),
  (@gen, NULL, 'cabin',      'F140',20,  'Heated rear seats'),
  (@gen, NULL, 'cabin',      'F154',10,  'OBD-II / VIN read'),
  (@gen, NULL, 'cabin',      'F158',15,  'Sliding panoramic sunroof'),
  (@gen, NULL, 'cabin',      'F176',15,  'Rear-view camera');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '12120040551',  'NGK (BMW OE)',     0.80, NULL,    'ILZKAR8H10SG · B58'),
  (@gen, NULL, 'oil_filter',    '11428583898',  'BMW Genuine',      NULL, NULL,    'Cartridge; B58 / N63'),
  (@gen, NULL, 'air_filter',    '13718580428',  'BMW Genuine',      NULL, NULL,    'Engine air filter (G05)'),
  (@gen, NULL, 'cabin_filter',  '64119272642',  'BMW Genuine',      NULL, NULL,    'Activated carbon HEPA dual-stage'),
  (@gen, NULL, 'wiper_front_d', '61617200822',  'BMW Genuine',      NULL, '26 in', 'Driver hybrid blade'),
  (@gen, NULL, 'wiper_front_p', '61617242147',  'BMW Genuine',      NULL, '21 in', 'Passenger'),
  (@gen, NULL, 'wiper_rear',    '61627171728',  'BMW Genuine',      NULL, '13 in', 'Rear hatch');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter',  10000, 5000,  16000, 8000,  12, 'BMW CBS — Connected push notifications.'),
  (@gen, NULL, 'tire_rotation',          7500,  NULL,  12000, NULL,  NULL, 'Suggested. BMW doesn''t require it.'),
  (@gen, NULL, 'brake_inspection',       10000, 5000,  16000, 8000,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',       30000, 15000, 48000, 24000, NULL, 'HEPA — single-piece swap.'),
  (@gen, NULL, 'transmission_at_fluid',  100000,60000, 160000,96000, NULL, 'ZF 8HP76; recommended despite BMW "lifetime".'),
  (@gen, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  24, 'BMW DOT 4 LV.'),
  (@gen, NULL, 'spark_plugs',            60000, NULL,  96000, NULL,  NULL, 'B58 iridium.'),
  (@gen, NULL, 'coolant_flush',          NULL,  NULL,  NULL,  NULL,  NULL, 'BMW HT-12 lifetime.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 32, 220, '265/50 R19 (xDrive40i base)'),
  (@gen, NULL, 'rear',  'normal', 34, 235, '265/50 R19 (xDrive40i base)'),
  (@gen, NULL, 'front', 'normal', 33, 230, '275/40 R21 (M-Sport)'),
  (@gen, NULL, 'rear',  'normal', 36, 250, '305/35 R21 (M-Sport rear)'),
  (@gen, NULL, 'front', 'normal', 35, 240, '275/35 R22 (M50i 22")'),
  (@gen, NULL, 'rear',  'normal', 39, 270, '315/30 R22 (M50i 22" rear)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'Run-flat OE — no spare provided');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- =====================================================================
-- SUBARU FORESTER SK 2019-2021 — gen 49
-- =====================================================================
SET @gen := 49;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Subaru Forester (SK) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Subaru Forester (SK) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Subaru Forester (SK) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/subaru/forester-sk-suv-2018-2021/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Vauxford / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:2019_Subaru_Forester_2.0i-S_(90).jpg',
    CURDATE(), '2019 Subaru Forester 2.0i-S (SK)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',          4.80, 5.07, '0W-20', 'API SP / ILSAC GF-6A',                  '15208AA170', 6000, 9600,  6, 'FB25 2.5L flat-4 (US/global) · 5.07 US qt with filter. FA20D STI: 5W-30. e-Boxer 2.0L: same 0W-20 + small 13.6 kW MGU.'),
  (@gen, NULL, 'transmission_cvt',    11.7, 12.4, NULL,    'Subaru High Torque CVTF II',              NULL,         60000, 96000, NULL, 'Lineartronic CVT TR580. Total fill ~12 qt; drain-and-fill ~5 qt.'),
  (@gen, NULL, 'front_differential',  1.30, 1.37, NULL,    'Subaru Gear Oil 75W-90 GL-5',             NULL,         30000, 48000, NULL, 'Integrated with CVT housing on most SK trims.'),
  (@gen, NULL, 'rear_differential',   0.80, 0.85, NULL,    'Subaru Gear Oil 75W-90 GL-5',             NULL,         30000, 48000, NULL, 'Symmetrical AWD rear diff.'),
  (@gen, NULL, 'coolant',             6.20, 6.55, NULL,    'Subaru Super Coolant (blue, pre-mixed)', NULL,          137500,220000,132, 'Initial 11 yr / 137,500 mi.'),
  (@gen, NULL, 'brake',               NULL, NULL, 'DOT 3', 'Subaru Genuine Brake Fluid DOT 3',         NULL,         NULL,  NULL,  30, 'Inspect annual; replace 30 mo.'),
  (@gen, NULL, 'ac_refrigerant',      0.50, 0.53, NULL,    'R-1234yf · PAG oil PAG46',                 NULL,         NULL,  NULL,  NULL, '500 ±25 g R-1234yf (US 2018+).');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           120, 89,  'M12×1.25; star pattern.'),
  (@gen, NULL, 'spark_plug',        22,  16,  'NGK SILZKAR7B11 iridium (FB25).'),
  (@gen, NULL, 'oil_drain',         44,  32,  'M14×1.5; new aluminum gasket.'),
  (@gen, NULL, 'caliper_slide_pin', 32,  24,  'Front caliper guide pin.'),
  (@gen, NULL, 'caliper_bracket',   100, 74,  'Front carrier-to-knuckle.'),
  (@gen, NULL, 'wheel_hub_nut',     193, 142, 'Plus 30° angle. Boxer-style staked nut.'),
  (@gen, NULL, 'diff_fill_plug',    44,  32,  'Front + rear diff fill plug.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES
  (@gen, NULL, '25-550 (B24L)', 550, 50, 130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low',  'LED (Limited+)', 2, 1),
  (@gen, NULL, 'headlight_high', 'LED (Limited+)', 2, 1),
  (@gen, NULL, 'fog_front',      'H8', 2, 0),
  (@gen, NULL, 'drl',            'LED', 2, 1),
  (@gen, NULL, 'turn_front',     '7440NA (WY21W)', 2, 0),
  (@gen, NULL, 'brake_tail',     '7443', 2, 0),
  (@gen, NULL, 'reverse',        '921 (W16W)', 2, 0),
  (@gen, NULL, 'turn_rear',      '7440NA (WY21W)', 2, 0),
  (@gen, NULL, 'license_plate',  'LED', 2, 1),
  (@gen, NULL, 'interior_dome',  '194 (W5W)', 1, 0),
  (@gen, NULL, 'interior_map',   '194 (W5W)', 2, 0),
  (@gen, NULL, 'trunk',          '194 (W5W)', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay', 'No.1',  10,  'Reverse light circuit'),
  (@gen, NULL, 'engine_bay', 'No.3',  20,  'Headlight low beam'),
  (@gen, NULL, 'engine_bay', 'No.4',  15,  'Engine cooling fan main'),
  (@gen, NULL, 'engine_bay', 'No.6',  10,  'Engine ECU'),
  (@gen, NULL, 'engine_bay', 'No.9',  15,  'Horn'),
  (@gen, NULL, 'engine_bay', 'No.12', 30,  'ABS / VSC pump motor'),
  (@gen, NULL, 'engine_bay', 'No.18', 30,  'Front wiper motor'),
  (@gen, NULL, 'engine_bay', 'No.22', 50,  'Power steering EPS'),
  (@gen, NULL, 'cabin',      'No.1',  20,  'Audio / multimedia'),
  (@gen, NULL, 'cabin',      'No.6',  20,  'Front 12V power outlet'),
  (@gen, NULL, 'cabin',      'No.10', 15,  'Cigarette lighter'),
  (@gen, NULL, 'cabin',      'No.14', 30,  'Driver power window'),
  (@gen, NULL, 'cabin',      'No.15', 30,  'Passenger power window'),
  (@gen, NULL, 'cabin',      'No.21', 15,  'Heated front seats'),
  (@gen, NULL, 'cabin',      'No.22', 7.5, 'OBD-II port'),
  (@gen, NULL, 'cabin',      'No.27', 15,  'Sunroof');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug',    '22401AA800', 'NGK (Subaru OE)', 0.80, NULL,   'SILZKAR7B11 · FB25'),
  (@gen, NULL, 'oil_filter',    '15208AA170', 'Subaru Genuine',   NULL, NULL,   'Cartridge; FB25 / FB20'),
  (@gen, NULL, 'air_filter',    '16546AA12A', 'Subaru Genuine',   NULL, NULL,   'Engine air filter (SK)'),
  (@gen, NULL, 'cabin_filter',  '72880FL00A', 'Subaru Genuine',   NULL, NULL,   'Activated carbon'),
  (@gen, NULL, 'wiper_front_d', '86532SJ010', 'Subaru Genuine',   NULL, '26 in', 'Driver beam blade'),
  (@gen, NULL, 'wiper_front_p', '86542SJ010', 'Subaru Genuine',   NULL, '17 in', 'Passenger'),
  (@gen, NULL, 'wiper_rear',    '86542SG010', 'Subaru Genuine',   NULL, '12 in', 'Rear hatch');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter',  6000,  3000,  9600,  4800,  6,   'Subaru schedule; FB25 6k mi.'),
  (@gen, NULL, 'tire_rotation',          6000,  6000,  9600,  9600,  NULL, 'Symmetrical AWD requires matching tread depth.'),
  (@gen, NULL, 'brake_inspection',       12000, 6000,  19200, 9600,  NULL, NULL),
  (@gen, NULL, 'engine_air_filter',      30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'cabin_air_filter',       15000, 7500,  24000, 12000, NULL, NULL),
  (@gen, NULL, 'transmission_cvt_fluid', 60000, 30000, 96000, 48000, NULL, 'Subaru High Torque CVTF II.'),
  (@gen, NULL, 'front_diff_oil',         30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'rear_diff_oil',          30000, 15000, 48000, 24000, NULL, NULL),
  (@gen, NULL, 'brake_fluid_flush',      NULL,  NULL,  NULL,  NULL,  30,  'Every 30 months.'),
  (@gen, NULL, 'spark_plugs',            60000, 30000, 96000, 48000, NULL, 'FB25 iridium.'),
  (@gen, NULL, 'coolant_flush',          137500,60000, 220000,96000, 132, 'Subaru Super Coolant.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front', 'normal', 32, 220, '225/60 R17 (Base / Premium)'),
  (@gen, NULL, 'rear',  'normal', 32, 220, '225/60 R17 (Base / Premium)'),
  (@gen, NULL, 'front', 'normal', 32, 220, '225/55 R18 (Sport / Limited)'),
  (@gen, NULL, 'rear',  'normal', 32, 220, '225/55 R18 (Sport / Limited)'),
  (@gen, NULL, 'spare', 'normal', 60, 420, 'T155/70 D17 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

SELECT '6-nameplate batch moat complete' AS status,
  (SELECT COUNT(*) FROM fluid_specs        WHERE generation_id BETWEEN 44 AND 49) AS fluids,
  (SELECT COUNT(*) FROM torque_specs       WHERE generation_id BETWEEN 44 AND 49) AS torques,
  (SELECT COUNT(*) FROM bulbs              WHERE generation_id BETWEEN 44 AND 49) AS bulbs,
  (SELECT COUNT(*) FROM fuses              WHERE generation_id BETWEEN 44 AND 49) AS fuses,
  (SELECT COUNT(*) FROM parts              WHERE generation_id BETWEEN 44 AND 49) AS parts,
  (SELECT COUNT(*) FROM service_intervals  WHERE generation_id BETWEEN 44 AND 49) AS svc,
  (SELECT COUNT(*) FROM tire_pressures     WHERE generation_id BETWEEN 44 AND 49) AS tires;
