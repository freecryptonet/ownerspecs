-- Batch: Passat B8 + Bronco U725 + Santa Fe TM + Grand Cherokee WL + MDX YD4 + ES XZ10
-- Cross-verified from each gen's OEM Owner's Manual. Compact format.

SET NAMES utf8mb4;

-- ============== VW PASSAT B8 — gen 66 ==============
SET @gen := 66;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Volkswagen Passat (B8) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Volkswagen Passat (B8) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Volkswagen Passat (B8) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/volkswagen/passat-b8-sedan-2015-2019/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons contributor, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Volkswagen_Passat_B8_rr.jpg',
    CURDATE(), 'Volkswagen Passat (B8)', '3-4-front', 1280, 720;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',      4.30, 4.54, '5W-30', 'VW 504 00 / 507 00 (long-life)', '06L115562B', 10000, 16000, 12, '2.0 TSI EA888 · 4.5 qt. 2.0 TDI: 4.5 qt 5W-30 VW 507 00. 1.4 TSI ACT: 3.6 qt VW 508 00.'),
  (@gen, NULL, 'transmission_at', 6.50, 6.87, NULL,    'VW G 052 533 DSG ATF',           NULL,         40000, 64000, NULL, '7-speed DQ381 wet DSG. 6MT uses VW G 052 171.'),
  (@gen, NULL, 'coolant',         7.50, 7.93, NULL,    'VW G 13 (lilac)',                 NULL,         NULL,  NULL,  NULL, 'Initial 75k mi.'),
  (@gen, NULL, 'brake',           NULL, NULL, 'DOT 4', 'VW DOT 4 Class 6',                NULL,         NULL,  NULL,  24,   '2 yr.'),
  (@gen, NULL, 'haldex_oil',      0.85, 0.90, NULL,    'VW G 060 175 A2',                 NULL,         40000, 64000, NULL, '4MOTION Haldex.'),
  (@gen, NULL, 'ac_refrigerant',  0.55, 0.58, NULL,    'R-1234yf · PAG46',                NULL,         NULL,  NULL,  NULL, '550 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',           120, 89,  'M14×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',        25,  18,  'NGK PFR7S8EG (EA888).'),
  (@gen, NULL, 'oil_drain',         30,  22,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin', 30,  22,  'Front guide pin.'),
  (@gen, NULL, 'caliper_bracket',   200, 148, 'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, 'H6 AGM', 720, 70, 180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low','H7 (LED opt)', 2, 0), (@gen, NULL, 'headlight_high','H7', 2, 0),
  (@gen, NULL, 'fog_front','H8', 2, 0), (@gen, NULL, 'drl','LED', 2, 1),
  (@gen, NULL, 'turn_front','PY24W', 2, 0), (@gen, NULL, 'brake_tail','LED', 2, 1),
  (@gen, NULL, 'reverse','W16W', 2, 0), (@gen, NULL, 'turn_rear','PY21W', 2, 0),
  (@gen, NULL, 'license_plate','LED', 2, 1), (@gen, NULL, 'interior_dome','W5W', 1, 0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay','F01',250,'Battery main'),
  (@gen, NULL, 'engine_bay','F04',60,'Cooling fan'),
  (@gen, NULL, 'engine_bay','F12',25,'Engine ECU'),
  (@gen, NULL, 'engine_bay','F22',30,'Headlight'),
  (@gen, NULL, 'cabin','01',30,'Front blower'),
  (@gen, NULL, 'cabin','07',20,'12V outlet'),
  (@gen, NULL, 'cabin','10',20,'Discover Pro infotainment'),
  (@gen, NULL, 'cabin','14',20,'Driver power seat'),
  (@gen, NULL, 'cabin','23',20,'Sunroof'),
  (@gen, NULL, 'cabin','32',10,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug','06H905611','NGK (VW OE)',0.80,NULL,'PFR7S8EG · EA888'),
  (@gen, NULL, 'oil_filter','06L115562B','VW Genuine',NULL,NULL,'Cartridge EA888'),
  (@gen, NULL, 'air_filter','5Q0129620E','VW Genuine',NULL,NULL,'MQB'),
  (@gen, NULL, 'cabin_filter','5Q0819644B','VW Genuine',NULL,NULL,'Activated carbon'),
  (@gen, NULL, 'wiper_front_d','3G1955425','VW Genuine',NULL,'26 in','Driver Aero'),
  (@gen, NULL, 'wiper_front_p','3G1955426','VW Genuine',NULL,'19 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter',10000,5000,16000,8000,12,'VW LongLife.'),
  (@gen, NULL, 'engine_air_filter',40000,20000,64000,32000,NULL,NULL),
  (@gen, NULL, 'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen, NULL, 'transmission_at_fluid',40000,40000,64000,64000,NULL,'DQ381 DSG.'),
  (@gen, NULL, 'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),
  (@gen, NULL, 'spark_plugs',60000,40000,96000,64000,NULL,NULL),
  (@gen, NULL, 'haldex_oil',40000,40000,64000,64000,NULL,'4MOTION only.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front','normal',32,220,'215/55 R17 (S / SE)'),
  (@gen, NULL, 'rear','normal',32,220,'215/55 R17 (S / SE)'),
  (@gen, NULL, 'front','normal',34,235,'235/45 R18 (R-Line)'),
  (@gen, NULL, 'rear','normal',34,235,'235/45 R18 (R-Line)'),
  (@gen, NULL, 'spare','normal',60,420,'T125/70 D17 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== FORD BRONCO U725 — gen 67 ==============
SET @gen := 67;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Ford Bronco (U725) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Ford Bronco (U725) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Ford Bronco (U725) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/ford/bronco-u725-suv-2021-present/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons contributor, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:2021_Ford_Bronco_Outer_Banks_4-dr_in_Area_51,_front_right.jpg',
    CURDATE(), '2021 Ford Bronco Outer Banks 4-dr (U725)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',          5.20, 5.50, '5W-30', 'API SP / Ford WSS-M2C961-A1', 'FL-500S', 10000, 16000, 12, '2.3L EcoBoost I4 · 5.5 qt. 2.7L EcoBoost V6: 6.0 qt.'),
  (@gen, NULL, 'transmission_at',     11.0, 11.6, NULL,    'Mercon LV ATF',                NULL,      60000, 96000, NULL, '10R60 10AT (V6) or 7-spd MT.'),
  (@gen, NULL, 'transfer_case',       1.30, 1.37, NULL,    'Mercon LV',                    NULL,      60000, 96000, NULL, 'BorgWarner 4WD.'),
  (@gen, NULL, 'front_differential',  1.20, 1.27, NULL,    'Motorcraft SAE 75W-85 GL-5',   NULL,      60000, 96000, NULL, 'Dana M186 front axle.'),
  (@gen, NULL, 'rear_differential',   1.40, 1.48, NULL,    'Motorcraft SAE 75W-85 GL-5',   NULL,      60000, 96000, NULL, 'Dana M210 rear; Sasquatch: M220 with locker, add 4 oz friction modifier.'),
  (@gen, NULL, 'coolant',             12.0, 12.7, NULL,    'Motorcraft Yellow (WSS-M97B44-D2)', NULL, NULL,  NULL,  NULL, 'Initial 100k mi / 6 yr.'),
  (@gen, NULL, 'brake',               NULL, NULL, 'DOT 3', 'Motorcraft DOT 3',             NULL,      NULL,  NULL,  36,   '3 yr.'),
  (@gen, NULL, 'ac_refrigerant',      0.80, 0.85, NULL,    'R-1234yf · PAG46',              NULL,      NULL,  NULL,  NULL, '800 ±30 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',                150, 111, 'M14×1.5; star pattern.'),
  (@gen, NULL, 'spark_plug',             15,  11,  '2.3L / 2.7L EcoBoost.'),
  (@gen, NULL, 'oil_drain',              35,  26,  'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin',      30,  22,  'Front.'),
  (@gen, NULL, 'caliper_bracket',        165, 122, 'Front carrier.'),
  (@gen, NULL, 'diff_fill_plug',         35,  26,  'Dana front + rear fill plug.'),
  (@gen, NULL, 'transfer_case_drain',    40,  30,  'BorgWarner transfer case.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, 'H7 AGM (94R)', 800, 80, 180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low','LED (sealed)', 2, 1), (@gen, NULL, 'headlight_high','LED (sealed)', 2, 1),
  (@gen, NULL, 'fog_front','LED', 2, 1), (@gen, NULL, 'drl','LED', 2, 1),
  (@gen, NULL, 'turn_front','LED', 2, 1), (@gen, NULL, 'brake_tail','LED', 2, 1),
  (@gen, NULL, 'reverse','921 (W16W)', 2, 0), (@gen, NULL, 'turn_rear','WY21W', 2, 0),
  (@gen, NULL, 'license_plate','LED', 2, 1), (@gen, NULL, 'interior_dome','LED', 2, 1),
  (@gen, NULL, 'cargo_lamp','LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay','1',40,'PCM main'),
  (@gen, NULL, 'engine_bay','4',30,'Electric cooling fan'),
  (@gen, NULL, 'engine_bay','10',30,'Trailer accessory'),
  (@gen, NULL, 'engine_bay','14',30,'4WD transfer case'),
  (@gen, NULL, 'engine_bay','18',25,'Headlight LH'),
  (@gen, NULL, 'engine_bay','19',25,'Headlight RH'),
  (@gen, NULL, 'engine_bay','23',20,'Fuel pump'),
  (@gen, NULL, 'cabin','1',20,'Front 12V'),
  (@gen, NULL, 'cabin','5',25,'Powered top motors (when equipped)'),
  (@gen, NULL, 'cabin','8',15,'SYNC 4'),
  (@gen, NULL, 'cabin','20',10,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug','CYFS-12Y-2','Motorcraft (Ford OE)',1.30,NULL,'2.3L / 2.7L EcoBoost'),
  (@gen, NULL, 'oil_filter','FL-500S','Motorcraft (Ford OE)',NULL,NULL,'Spin-on'),
  (@gen, NULL, 'air_filter','MB3Z-9601-A','Motorcraft (Ford OE)',NULL,NULL,'Bronco air filter'),
  (@gen, NULL, 'cabin_filter','FP-87','Motorcraft (Ford OE)',NULL,NULL,NULL),
  (@gen, NULL, 'wiper_front_d','MB3Z-17528-A','Ford Genuine',NULL,'22 in','Driver'),
  (@gen, NULL, 'wiper_front_p','MB3Z-17528-B','Ford Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter',10000,5000,16000,8000,12,'Ford IOLM.'),
  (@gen, NULL, 'tire_rotation',7500,7500,12000,12000,NULL,NULL),
  (@gen, NULL, 'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen, NULL, 'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen, NULL, 'transmission_at_fluid',150000,75000,240000,120000,NULL,'10R60.'),
  (@gen, NULL, 'transfer_case_fluid',60000,30000,96000,48000,NULL,'BorgWarner.'),
  (@gen, NULL, 'front_diff_oil',60000,30000,96000,48000,NULL,'Dana M186.'),
  (@gen, NULL, 'rear_diff_oil',60000,30000,96000,48000,NULL,'Dana M210/M220.'),
  (@gen, NULL, 'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL),
  (@gen, NULL, 'spark_plugs',100000,60000,160000,96000,NULL,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front','normal',35,240,'255/75 R17 (Base / Big Bend)'),
  (@gen, NULL, 'rear','normal',35,240,'255/75 R17 (Base / Big Bend)'),
  (@gen, NULL, 'front','normal',35,240,'285/70 R17 (Sasquatch 35")'),
  (@gen, NULL, 'rear','normal',35,240,'285/70 R17 (Sasquatch 35")'),
  (@gen, NULL, 'spare','normal',60,420,'Full-size matching spare on tailgate');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== HYUNDAI SANTA FE TM — gen 68 ==============
SET @gen := 68;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Hyundai Santa Fe (TM) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Hyundai Santa Fe (TM) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Hyundai Santa Fe (TM) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/hyundai/santa-fe-tm-suv-2019-2023/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons / Flickr CC, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Hyundai_Santa_Fe_2.2D_(2019)_(53507140085).jpg',
    CURDATE(), 'Hyundai Santa Fe IV (TM)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         5.50, 5.81, '5W-30', 'API SP / ILSAC GF-6', '26300-35504', 7500, 12000, 12, '2.5L Smartstream G2.5 GDI · 5.8 qt. 2.5T G2.5 turbo: 6.5 qt 5W-30. 2.2 CRDi diesel: 8.0 qt 5W-30 ACEA C2.'),
  (@gen, NULL, 'transmission_at',    7.50, 7.93, NULL,    'Hyundai SP-IV ATF',    NULL,         60000, 96000, NULL, '8AT (gas) or 8DCT (2.5T).'),
  (@gen, NULL, 'transfer_case',      0.50, 0.53, NULL,    'Hyundai AWD coupling fluid', NULL,    75000,120000,NULL, 'AWD HTRAC coupling.'),
  (@gen, NULL, 'rear_differential',  0.80, 0.85, NULL,    'Hyundai Gear Oil 75W-90 GL-5', NULL,  75000,120000,NULL, 'AWD rear.'),
  (@gen, NULL, 'coolant',            8.60, 9.10, NULL,    'Hyundai LLC (blue)',    NULL,        120000,192000,NULL, 'Initial 120k mi / 10 yr.'),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 3', 'Hyundai DOT 3',         NULL,         NULL,  NULL,  24,   NULL),
  (@gen, NULL, 'ac_refrigerant',     0.60, 0.63, NULL,    'R-1234yf · PAG46',       NULL,         NULL,  NULL,  NULL, '600 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',107,79,'M12×1.5.'), (@gen, NULL, 'spark_plug',25,18,'NGK ILZFR6D-11.'),
  (@gen, NULL, 'oil_drain',35,26,'M14×1.5.'), (@gen, NULL, 'caliper_slide_pin',22,16,'Front.'),
  (@gen, NULL, 'caliper_bracket',95,70,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, '24F (LN2)', 600, 70, 130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low','LED / H7 (base)', 2, 1), (@gen, NULL, 'headlight_high','HB3 / LED', 2, 0),
  (@gen, NULL, 'fog_front','H11', 2, 0), (@gen, NULL, 'drl','LED', 2, 1),
  (@gen, NULL, 'turn_front','PY21W', 2, 0), (@gen, NULL, 'brake_tail','LED', 2, 1),
  (@gen, NULL, 'reverse','921 (W16W)', 2, 0), (@gen, NULL, 'turn_rear','PY21W', 2, 0),
  (@gen, NULL, 'license_plate','LED', 2, 1), (@gen, NULL, 'interior_dome','LED', 1, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay','MAIN',100,'Battery main'),
  (@gen, NULL, 'engine_bay','ALT',150,'Alternator'),
  (@gen, NULL, 'engine_bay','ABS',40,'ABS pump'),
  (@gen, NULL, 'engine_bay','PWR',50,'MDPS'),
  (@gen, NULL, 'engine_bay','COOL',40,'Cooling fan'),
  (@gen, NULL, 'engine_bay','HEAD',25,'Headlight'),
  (@gen, NULL, 'cabin','IGN',30,'Ignition'),
  (@gen, NULL, 'cabin','AUDIO',15,'Audio'),
  (@gen, NULL, 'cabin','WIPER',30,'Wiper motor'),
  (@gen, NULL, 'cabin','SEAT',20,'Heated seats'),
  (@gen, NULL, 'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug','18849-08080','NGK (Hyundai OE)',0.80,NULL,'SILZKR7B8EG · Smartstream'),
  (@gen, NULL, 'oil_filter','26300-35504','Hyundai Genuine',NULL,NULL,NULL),
  (@gen, NULL, 'air_filter','28113-S2000','Hyundai Genuine',NULL,NULL,NULL),
  (@gen, NULL, 'cabin_filter','97133-S1000','Hyundai Genuine',NULL,NULL,'Activated carbon'),
  (@gen, NULL, 'wiper_front_d','98350-S2000','Hyundai Genuine',NULL,'26 in','Driver'),
  (@gen, NULL, 'wiper_front_p','98360-S2000','Hyundai Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter',7500,3750,12000,6000,12,NULL),
  (@gen, NULL, 'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen, NULL, 'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen, NULL, 'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),
  (@gen, NULL, 'rear_diff_oil',75000,37500,120000,60000,NULL,'AWD only.'),
  (@gen, NULL, 'spark_plugs',97500,60000,156000,96000,NULL,NULL),
  (@gen, NULL, 'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front','normal',33,230,'235/65 R17 (SE / SEL)'),
  (@gen, NULL, 'rear','normal',33,230,'235/65 R17 (SE / SEL)'),
  (@gen, NULL, 'front','normal',33,230,'235/55 R19 (Limited)'),
  (@gen, NULL, 'rear','normal',33,230,'235/55 R19 (Limited)'),
  (@gen, NULL, 'spare','normal',60,420,'T155/90 D17 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== JEEP GRAND CHEROKEE WL — gen 69 ==============
SET @gen := 69;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Jeep Grand Cherokee (WL) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Jeep Grand Cherokee (WL) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Jeep Grand Cherokee (WL) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/jeep/grand-cherokee-wl-suv-2022-present/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Alexander Migl / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:Jeep_Grand_Cherokee_L_Overland_Automesse_Ludwigsburg_2022_1X7A5919.jpg',
    CURDATE(), 'Jeep Grand Cherokee V (WL)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',          5.70, 6.00, '0W-20', 'API SP / Chrysler MS-6395',    '68191349AC',  10000, 16000, 12, '3.6L Pentastar V6 · 6.0 qt. 5.7L HEMI V8: 7.0 qt 5W-20. 4xe 2.0T PHEV: 5.0 qt 5W-30 MS-13340.'),
  (@gen, NULL, 'transmission_at',     10.0, 10.6, NULL,    'Mopar ZF 8&9 ATF (MS-12892)',  NULL,          60000, 96000, NULL, 'ZF 8HP75 TorqueFlite 8.'),
  (@gen, NULL, 'transfer_case',       1.40, 1.48, NULL,    'Mopar ATF+4',                  NULL,          120000,192000,NULL, 'BW44-46 Quadra-Trac.'),
  (@gen, NULL, 'front_differential',  1.20, 1.27, NULL,    'Mopar 75W-85 Synthetic',       NULL,          60000, 96000, NULL, '9.25" AAM front.'),
  (@gen, NULL, 'rear_differential',   2.10, 2.22, NULL,    'Mopar 75W-85 Synthetic',       NULL,          60000, 96000, NULL, '9.25" AAM rear. Add 4 oz friction modifier on LSD.'),
  (@gen, NULL, 'coolant',             13.0, 13.7, NULL,    'Mopar OAT (orange, MS-12106)', NULL,          150000,240000,NULL, NULL),
  (@gen, NULL, 'brake',               NULL, NULL, 'DOT 3', 'Mopar DOT 3 (or DOT 4 LV)',     NULL,          NULL,  NULL,  24,   NULL),
  (@gen, NULL, 'ac_refrigerant',      0.85, 0.90, NULL,    'R-1234yf · PAG46',              NULL,          NULL,  NULL,  NULL, '850 ±30 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',176,130,'M14×1.5; star.'),
  (@gen, NULL, 'spark_plug',17,13,'NGK ZFR6F-11G (V6) / ZFR5LP-13G (HEMI).'),
  (@gen, NULL, 'oil_drain',34,25,'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin',35,26,'Front.'),
  (@gen, NULL, 'caliper_bracket',175,129,'Front carrier.'),
  (@gen, NULL, 'diff_fill_plug',34,25,'AAM 9.25" diff.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, 'H8 (94R) AGM', 800, 80, 220);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low','LED (sealed)', 2, 1), (@gen, NULL, 'headlight_high','LED (sealed)', 2, 1),
  (@gen, NULL, 'fog_front','LED', 2, 1), (@gen, NULL, 'drl','LED', 2, 1),
  (@gen, NULL, 'turn_front','LED', 2, 1), (@gen, NULL, 'brake_tail','LED', 2, 1),
  (@gen, NULL, 'reverse','LED', 2, 1), (@gen, NULL, 'turn_rear','LED', 2, 1),
  (@gen, NULL, 'license_plate','LED', 2, 1), (@gen, NULL, 'cargo_lamp','LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay','F01',200,'PCM main'),
  (@gen, NULL, 'engine_bay','F02',80,'ABS pump'),
  (@gen, NULL, 'engine_bay','F04',40,'Cooling fan'),
  (@gen, NULL, 'engine_bay','F09',30,'Trailer'),
  (@gen, NULL, 'engine_bay','F18',30,'Heated rear window'),
  (@gen, NULL, 'engine_bay','F23',25,'Headlight'),
  (@gen, NULL, 'cabin','M01',20,'Cigar lighter'),
  (@gen, NULL, 'cabin','M05',15,'Audio amplifier'),
  (@gen, NULL, 'cabin','M12',20,'Heated seats'),
  (@gen, NULL, 'cabin','M18',10,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug','68303800AA','NGK (Mopar OE)',1.10,NULL,'ZFR6F-11G · 3.6L V6'),
  (@gen, NULL, 'oil_filter','68191349AC','Mopar Genuine',NULL,NULL,'3.6L cartridge'),
  (@gen, NULL, 'air_filter','68318343AA','Mopar Genuine',NULL,NULL,NULL),
  (@gen, NULL, 'cabin_filter','68229402AA','Mopar Genuine',NULL,NULL,'Activated carbon'),
  (@gen, NULL, 'wiper_front_d','68349906AA','Mopar Genuine',NULL,'24 in','Driver'),
  (@gen, NULL, 'wiper_front_p','68349907AA','Mopar Genuine',NULL,'21 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter',10000,4000,16000,6400,12,'Mopar OCIS.'),
  (@gen, NULL, 'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen, NULL, 'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen, NULL, 'transmission_at_fluid',60000,60000,96000,96000,NULL,'ZF 8HP75.'),
  (@gen, NULL, 'transfer_case_fluid',120000,60000,192000,96000,NULL,'BW44-46.'),
  (@gen, NULL, 'rear_diff_oil',60000,30000,96000,48000,NULL,'AAM 9.25".'),
  (@gen, NULL, 'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),
  (@gen, NULL, 'spark_plugs',100000,60000,160000,96000,NULL,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front','normal',35,240,'265/60 R18 (Laredo)'),
  (@gen, NULL, 'rear','normal',35,240,'265/60 R18 (Laredo)'),
  (@gen, NULL, 'front','normal',35,240,'265/50 R20 (Limited / Overland)'),
  (@gen, NULL, 'rear','normal',35,240,'265/50 R20 (Limited / Overland)'),
  (@gen, NULL, 'front','normal',35,240,'275/45 R21 (Summit Reserve)'),
  (@gen, NULL, 'rear','normal',35,240,'275/45 R21 (Summit Reserve)'),
  (@gen, NULL, 'spare','normal',60,420,'T165/80 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== ACURA MDX YD4 — gen 70 ==============
SET @gen := 70;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Acura MDX (YD4) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Acura MDX (YD4) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Acura MDX (YD4) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/acura/mdx-yd4-suv-2022-2025/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons contributor, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:2022_Acura_MDX_Type-S.jpg',
    CURDATE(), '2022 Acura MDX Type-S (YD4)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         5.50, 5.80, '0W-20', 'API SP / ILSAC GF-6A',          '15400-PLM-A02', 7500, 12000, 12, '3.5L J35Y8 V6 · 5.8 qt. Type S 3.0T V6 (J30AC): 5.7 qt 0W-20.'),
  (@gen, NULL, 'transmission_at',    8.40, 8.88, NULL,    'Honda Genuine ATF DW-1',         NULL,            60000, 96000, NULL, '10-speed 10AT (Honda MFV).'),
  (@gen, NULL, 'transfer_case',      0.50, 0.53, NULL,    'Honda DPSF (Dual Pump Fluid II)', NULL,            60000, 96000, NULL, 'SH-AWD coupling.'),
  (@gen, NULL, 'rear_differential',  1.20, 1.27, NULL,    'Honda VTM-4 Differential Fluid', NULL,            30000, 48000, NULL, 'SH-AWD rear. Acura recommends 15k mi severe.'),
  (@gen, NULL, 'coolant',            9.20, 9.72, NULL,    'Honda Type 2 LLC (blue)',         NULL,            NULL,  NULL,  NULL, 'Initial 120k mi.'),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 3', 'Honda DOT 3',                    NULL,            NULL,  NULL,  36,   NULL),
  (@gen, NULL, 'ac_refrigerant',     0.65, 0.69, NULL,    'R-1234yf · PAG46',                NULL,            NULL,  NULL,  NULL, '650 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',108,80,'M12×1.5.'),
  (@gen, NULL, 'spark_plug',18,13,'NGK ILZKAR7C iridium · J35Y8 (6 plugs); Type-S J30AC: NGK ILZKBR8H8S.'),
  (@gen, NULL, 'oil_drain',40,30,'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin',36,27,'Front.'),
  (@gen, NULL, 'caliper_bracket',109,80,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, '94R (H7) AGM', 730, 80, 165);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low','LED (Jewel Eye)', 2, 1), (@gen, NULL, 'headlight_high','LED (Jewel Eye)', 2, 1),
  (@gen, NULL, 'fog_front','LED', 2, 1), (@gen, NULL, 'drl','LED', 2, 1),
  (@gen, NULL, 'turn_front','LED', 2, 1), (@gen, NULL, 'brake_tail','LED', 2, 1),
  (@gen, NULL, 'reverse','921 (W16W)', 2, 0), (@gen, NULL, 'turn_rear','WY21W', 2, 0),
  (@gen, NULL, 'license_plate','LED', 2, 1), (@gen, NULL, 'interior_dome','LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay','1',40,'ABS'),
  (@gen, NULL, 'engine_bay','3',50,'EPS'),
  (@gen, NULL, 'engine_bay','5',50,'IG1 main'),
  (@gen, NULL, 'engine_bay','11',20,'L headlight'),
  (@gen, NULL, 'engine_bay','12',20,'R headlight'),
  (@gen, NULL, 'engine_bay','14',30,'SH-AWD coupling'),
  (@gen, NULL, 'cabin','1',20,'12V outlet'),
  (@gen, NULL, 'cabin','5',30,'Wiper'),
  (@gen, NULL, 'cabin','8',20,'Heated seats'),
  (@gen, NULL, 'cabin','20',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug','12290-RLV-A01','NGK (Acura OE)',1.10,NULL,'ILZKAR7C · J35Y8'),
  (@gen, NULL, 'oil_filter','15400-PLM-A02','Acura Genuine',NULL,NULL,'Spin-on'),
  (@gen, NULL, 'air_filter','17220-61A-A00','Acura Genuine',NULL,NULL,NULL),
  (@gen, NULL, 'cabin_filter','80292-T20-A41','Acura Genuine',NULL,NULL,NULL),
  (@gen, NULL, 'wiper_front_d','76622-TYA-A02','Acura Genuine',NULL,'26 in','Driver'),
  (@gen, NULL, 'wiper_front_p','76632-TYA-A02','Acura Genuine',NULL,'21 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter',7500,3750,12000,6000,12,'Acura MM A1.'),
  (@gen, NULL, 'tire_rotation',7500,3750,12000,6000,NULL,NULL),
  (@gen, NULL, 'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen, NULL, 'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen, NULL, 'transmission_at_fluid',60000,30000,96000,48000,NULL,'10AT.'),
  (@gen, NULL, 'rear_diff_oil',30000,15000,48000,24000,NULL,'SH-AWD short interval.'),
  (@gen, NULL, 'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL),
  (@gen, NULL, 'spark_plugs',105000,60000,168000,96000,NULL,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front','normal',33,230,'255/50 R20 (Base / Tech)'),
  (@gen, NULL, 'rear','normal',33,230,'255/50 R20 (Base / Tech)'),
  (@gen, NULL, 'front','normal',33,230,'265/45 R21 (Advance / Type S)'),
  (@gen, NULL, 'rear','normal',33,230,'265/45 R21 (Advance / Type S)'),
  (@gen, NULL, 'spare','normal',60,420,'T165/90 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== LEXUS ES XZ10 — gen 71 ==============
SET @gen := 71;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Lexus ES (XZ10) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Lexus ES (XZ10) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Lexus ES (XZ10) Owner''s Manual' LIMIT 1);

INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/lexus/es-xz10-sedan-2019-2024/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Kevauto / Wikimedia Commons, CC BY-SA 4.0',
    'https://commons.wikimedia.org/wiki/File:2019_Lexus_ES_350_sedan,_7.12.19.jpg',
    CURDATE(), '2019 Lexus ES 350 (XZ10)', '3-4-front', 1280, 853;

INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',         5.70, 6.02, '0W-20', 'API SP / ILSAC GF-6A',                   '04152-YZZA6', 10000, 16000, 12, 'ES 350 2GR-FKS V6 · 6.0 qt. ES 300h hybrid A25A-FXS: 4.5 qt 0W-16.'),
  (@gen, NULL, 'transmission_at',    6.60, 6.97, NULL,    'Toyota Genuine ATF WS',                  NULL,         NULL,  NULL,  NULL, '8AT (ES 350) / eCVT (ES 300h).'),
  (@gen, NULL, 'coolant',            9.10, 9.62, NULL,    'Toyota Super Long Life Coolant (pink)',  NULL,         100000,160000,120,  NULL),
  (@gen, NULL, 'brake',              NULL, NULL, 'DOT 3', 'Toyota DOT 3',                            NULL,         NULL,  NULL,  36,   NULL),
  (@gen, NULL, 'ac_refrigerant',     0.55, 0.58, NULL,    'R-1234yf · PAG46 (ND-OIL 12)',             NULL,         NULL,  NULL,  NULL, '550 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = @gen;

INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'lug_nut',103,76,'M12×1.5.'),
  (@gen, NULL, 'spark_plug',18,13,'Denso SC20HR11 (V6) / FK20HR11 (hybrid).'),
  (@gen, NULL, 'oil_drain',40,30,'M14×1.5.'),
  (@gen, NULL, 'caliper_slide_pin',34,25,'Front.'),
  (@gen, NULL, 'caliper_bracket',107,79,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = @gen;

INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen, NULL, '24F (LN2)', 550, 55, 130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = @gen;

INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, NULL, 'headlight_low','LED (sealed)', 2, 1), (@gen, NULL, 'headlight_high','LED (sealed)', 2, 1),
  (@gen, NULL, 'fog_front','LED', 2, 1), (@gen, NULL, 'drl','LED', 2, 1),
  (@gen, NULL, 'turn_front','LED', 2, 1), (@gen, NULL, 'brake_tail','LED', 2, 1),
  (@gen, NULL, 'reverse','LED', 2, 1), (@gen, NULL, 'turn_rear','LED', 2, 1),
  (@gen, NULL, 'license_plate','LED', 2, 1), (@gen, NULL, 'interior_dome','LED', 2, 1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id = @gen;

INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen, NULL, 'engine_bay','AM1',50,'Ignition'),
  (@gen, NULL, 'engine_bay','EFI MAIN',30,'Engine fuel inj'),
  (@gen, NULL, 'engine_bay','HEAD',25,'Headlight'),
  (@gen, NULL, 'engine_bay','ABS',40,'ABS pump'),
  (@gen, NULL, 'engine_bay','RDI FAN',30,'Cooling fan'),
  (@gen, NULL, 'cabin','PWR OUT',20,'12V'),
  (@gen, NULL, 'cabin','AUDIO',15,'Audio'),
  (@gen, NULL, 'cabin','WIPER',30,'Wiper'),
  (@gen, NULL, 'cabin','SEAT HTR',20,'Heated seats'),
  (@gen, NULL, 'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id = @gen;

INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen, NULL, 'spark_plug','90919-01253','Denso (Lexus OE)',1.10,NULL,'SC20HR11 · 2GR-FKS V6'),
  (@gen, NULL, 'oil_filter','04152-YZZA6','Lexus Genuine',NULL,NULL,'Cartridge'),
  (@gen, NULL, 'air_filter','17801-F0050','Lexus Genuine',NULL,NULL,NULL),
  (@gen, NULL, 'cabin_filter','87139-0E040','Lexus Genuine',NULL,NULL,NULL),
  (@gen, NULL, 'wiper_front_d','85212-33360','Lexus Genuine',NULL,'26 in','Driver'),
  (@gen, NULL, 'wiper_front_p','85222-33360','Lexus Genuine',NULL,'20 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @src FROM parts WHERE generation_id = @gen;

INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter',10000,5000,16000,8000,12,NULL),
  (@gen, NULL, 'tire_rotation',5000,5000,8000,8000,NULL,NULL),
  (@gen, NULL, 'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen, NULL, 'cabin_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen, NULL, 'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),
  (@gen, NULL, 'spark_plugs',120000,60000,192000,96000,NULL,NULL),
  (@gen, NULL, 'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id = @gen;

INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, NULL, 'front','normal',35,240,'235/45 R18 (Base / Luxury)'),
  (@gen, NULL, 'rear','normal',35,240,'235/45 R18 (Base / Luxury)'),
  (@gen, NULL, 'front','normal',35,240,'235/40 R19 (F SPORT)'),
  (@gen, NULL, 'rear','normal',35,240,'235/40 R19 (F SPORT)'),
  (@gen, NULL, 'spare','normal',60,420,'T155/70 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = @gen;

-- ============== PROCEDURES FOR ALL 6 ==============
SET @gen := 66; SET @src := (SELECT id FROM sources WHERE citation LIKE 'Volkswagen Passat%' AND is_public=1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen, 'service_reminder_reset', 'service-reminder-reset', 'Service reminder reset — Passat (B8)',
 'Same VW MQB pattern as Golf Mk8 / Tiguan AD1:\n\n1. Steering wheel: hold **VIEW** for service menu.\n2. Select Inspection / Oil service.\n3. Long-press **0.0** to reset.\n',
 '• Steering wheel buttons (no other tools).\n• Optional: OBDeleven Pro for full service-clearing including DPF (TDI trims).',
 '• Resetting **All** instead of just the serviced item — masks every counter.\n• Not registering a new battery via VCDS / OBDeleven after replacement — the BMS keeps the old battery''s capacity profile and the alternator over- or under-charges the new battery.'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Passat (B8)',
 'Negative-first, positive-last. Engine bay 12V. After reconnect: lock-to-lock for EPS, then drive a short loop for Travel Assist camera self-cal.\n\nBattery registration via VCDS / OBDeleven required after replacement.\n',
 '• 10 mm wrench, gloves, eye protection.\n• OBDeleven Pro or VCDS Lite for battery registration.',
 '• Disconnecting positive first — wrench-to-body short.\n• Skipping registration — VW BMS misjudges charge state.'),
(@gen, 'tpms_relearn', 'tpms-calibration', 'TPMS calibration — Passat (B8)',
 'Indirect TPMS (ABS-based). Settings → Tyres → Calibrate. Drive 10 min mixed speeds.\n',
 '• None — fully menu-driven.', '• Setting hot pressures.'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Passat (B8)',
 'Engine-bay jump terminals (red cap **+**, ground stud **−**). Standard 4-clamp procedure. Drive 30 min after.\n',
 '• Jumper cables 4 AWG or jump pack 1000 A peak.', '• Clamping negative directly to dead battery post.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 67; SET @src := (SELECT id FROM sources WHERE citation LIKE 'Ford Bronco%' AND is_public=1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen, 'oil_life_reset', 'oil-life-reset', 'Oil-Life Monitor reset — Bronco (U725)',
 'Same Ford IOLM pattern as F-150 P702 / Explorer U625:\n\n1. SYNC 4 touchscreen → Settings → Vehicle → Oil Life → Reset to 100%.\n2. Or via cluster: left steering wheel pad → Vehicle Health → Oil Life → hold OK.\n',
 '• None — fully menu-driven.', '• Resetting BEFORE the service is done.'),
(@gen, 'tpms_relearn', 'tpms-relearn', 'TPMS relearn — Bronco (U725)',
 'Same as F-150 (Ford pedal-headlight sequence) or via OBD scan tool (FORScan). After sequence, magnet-activate each sensor LF→RF→RR→LR.\n',
 '• Magnet or TPMS activator tool.\n• Optional: FORScan with extended licence for OBD relearn.',
 '• Headlight switch cycled too quickly between positions.\n• Forgetting to set tire pressures cold first.'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Bronco (U725)',
 'Negative-first, positive-last. After reconnect: drive several miles for Ford camera/radar self-calibration. BMS registration via FORScan required for accurate charge state.\n',
 '• 10 mm wrench, gloves, glasses.\n• FORScan with extended licence for BMS registration.',
 '• Positive first — wrench short. Skipping FORScan registration — BMS misjudges new battery.'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Bronco (U725)',
 'Standard 4-clamp procedure to the 12V in the right-side engine bay.\n',
 '• Jumper cables 4 AWG; donor 600+ CCA for V6 ICE.',
 '• Clamping black to dead negative post.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 68; SET @src := (SELECT id FROM sources WHERE citation LIKE 'Hyundai Santa Fe%' AND is_public=1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen, 'service_reminder_reset', 'service-interval-reset', 'Service interval reset — Santa Fe (TM)',
 'Hyundai Group canonical: cluster menu → **User Settings** → **Service Interval** → **Reset**.\n',
 '• None.', '• Resetting **All** — masks all counters.'),
(@gen, 'tpms_relearn', 'tpms-auto', 'TPMS auto-relearn — Santa Fe (TM)',
 'Auto-relearn after a 10-min drive above 15 mph. Set placard pressures first.\n',
 '• Tire pressure gauge.', '• Setting hot pressures.'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Santa Fe (TM)',
 'Negative-first, positive-last. After reconnect: lock-to-lock for MDPS, drive 5 min for SmartSense camera self-cal.\n',
 '• 10 mm wrench, gloves.', '• Positive first.'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Santa Fe (TM)',
 'Standard 4-clamp procedure.\n',
 '• Jumper cables, donor 600+ CCA.', '• Clamping to dead negative post.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 69; SET @src := (SELECT id FROM sources WHERE citation LIKE 'Jeep Grand Cherokee%' AND is_public=1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen, 'oil_life_reset', 'oil-change-indicator-reset', 'Oil Change Indicator reset — Grand Cherokee (WL)',
 'Mopar OCIS canonical (same as Ram 1500 DT / Wrangler JL):\n\n1. Uconnect 5 → Controls → Vehicle Maintenance → Oil Change Indicator → Reset.\n2. OR cluster method: ignition ON, press accelerator slowly to the floor three times within 10 s.\n',
 '• None — menu-driven.', '• Accelerator pedal pressed too fast — system doesn''t recognise the sequence.'),
(@gen, 'tpms_relearn', 'tpms-auto', 'TPMS auto-relearn — Grand Cherokee (WL)',
 'Auto-relearn after 20-min drive above 15 mph. WL has direct TPMS sensors.\n',
 '• Tire pressure gauge.', '• Setting hot pressures.'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Grand Cherokee (WL)',
 'Negative-first, positive-last. 4xe PHEV: 12V in engine bay; HV traction battery is sealed and inaccessible — do not work on it.\n',
 '• 10 mm wrench, gloves.', '• Touching the HV connectors on 4xe trims.'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Grand Cherokee (WL)',
 'Standard 4-clamp procedure to the 12V on the passenger side of the engine bay. 4xe PHEV: same; HV battery does not assist.\n',
 '• Jumper cables 4 AWG, donor 600+ CCA.', '• Clamping black to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 70; SET @src := (SELECT id FROM sources WHERE citation LIKE 'Acura MDX%' AND is_public=1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen, 'maintenance_minder_reset', 'maintenance-minder-reset', 'Maintenance Minder reset — MDX (YD4)',
 'Acura common pattern (same as Honda MM): touchscreen → Vehicle → Maintenance Info → select serviced item → Reset → confirm.\n',
 '• None.', '• Resetting **All** instead of the serviced item.'),
(@gen, 'tpms_relearn', 'tpms-calibration', 'TPMS calibration — MDX (YD4)',
 'Indirect TPMS (ABS-based). Touchscreen → Settings → Vehicle → TPMS Calibration → Calibrate. Drive 30 min.\n',
 '• Tire pressure gauge.', '• Setting hot pressures.'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — MDX (YD4)',
 'Negative-first, positive-last. After reconnect: i-VTM4 SH-AWD coupling self-recalibrates on first drive.\n',
 '• 10 mm wrench, gloves.', '• Positive first.'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — MDX (YD4)',
 'Standard 4-clamp procedure. Type-S trims use the same 12V battery as base MDX.\n',
 '• Jumper cables, donor 600+ CCA.', '• Clamping to dead negative post.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SET @gen := 71; SET @src := (SELECT id FROM sources WHERE citation LIKE 'Lexus ES%' AND is_public=1 LIMIT 1);
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen, 'oil_life_reset', 'oil-maintenance-reset', 'Oil maintenance reset — Lexus ES (XZ10)',
 'Lexus menu-driven (same as RX AL20 / NX AZ20):\n\n1. Ignition **ON**.\n2. Multi-info display → Settings → Maintenance → Oil Maintenance → Reset.\n',
 '• None.', '• Reset before service is done.'),
(@gen, 'tpms_relearn', 'tpms-register', 'TPMS register — Lexus ES (XZ10)',
 'Direct TPMS. Press and hold **TPMS SET** under steering column until warning blinks 3× slowly. Wait 20 min.\n',
 '• None.', '• Hot pressures.'),
(@gen, 'battery_disconnect_order', 'battery-disconnect', 'Battery disconnect order — Lexus ES (XZ10)',
 'Negative-first, positive-last. Hybrid ES 300h: 12V in engine bay; HV battery under rear seat — never touch orange cables.\n',
 '• 10 mm wrench, gloves.', '• Positive first. Touching HV cables on hybrid.'),
(@gen, 'jump_start', 'jump-start', 'Jump-start — Lexus ES (XZ10)',
 'Standard 4-clamp procedure. Hybrid: under-hood red-cap jump terminal for **+**.\n',
 '• Jumper cables 4 AWG.', '• Clamping black to dead negative post.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures', id, @src FROM procedures WHERE generation_id = @gen;

SELECT '6 new nameplate batch complete' AS status,
  (SELECT COUNT(*) FROM generations WHERE is_active=1) AS total_gens,
  (SELECT COUNT(*) FROM procedures) AS total_procedures,
  (SELECT COUNT(*) FROM fluid_specs WHERE generation_id BETWEEN 66 AND 71) AS new_fluids,
  (SELECT COUNT(*) FROM parts WHERE generation_id BETWEEN 66 AND 71) AS new_parts;
