-- Batch 8: Atlas CA + Rogue T33 + Crosstrek GT + Tundra XK70 + Tahoe T1XX + Sierra T1XX

SET NAMES utf8mb4;

-- VW ATLAS CA — gen 72
SET @gen := 72;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Volkswagen Atlas (CA) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Volkswagen Atlas (CA) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Volkswagen Atlas (CA) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen, NULL, NULL, '/images/volkswagen/atlas-ca-suv-2018-2023/hero.jpg', 'wikimedia', 'cc-by-sa-4.0',
    'Wikimedia Commons contributor', 'https://commons.wikimedia.org/wiki/File:VW_Atlas_P4250862.jpg',
    CURDATE(), 'Volkswagen Atlas (CA)', '3-4-front', 1280, 853;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, NULL, 'engine_oil',5.40,5.71,'5W-30','VW 502 00 / VW 508 00','06H115403J',10000,16000,12,'3.6L VR6 (US) · 5.7 qt. 2.0T (US): 4.8 qt 5W-30 VW 508 00.'),
  (@gen, NULL, 'transmission_at',7.00,7.40,NULL,'VW G 060 162 A2 ATF',NULL,80000,128000,NULL,'8-speed AQ450 Aisin AT.'),
  (@gen, NULL, 'coolant',12.5,13.2,NULL,'VW G 13 (lilac)',NULL,NULL,NULL,NULL,'Initial 75k mi.'),
  (@gen, NULL, 'brake',NULL,NULL,'DOT 4','VW DOT 4 LV',NULL,NULL,NULL,24,'2 yr.'),
  (@gen, NULL, 'haldex_oil',0.85,0.90,NULL,'VW G 060 175 A2',NULL,40000,64000,NULL,'4MOTION trims.'),
  (@gen, NULL, 'ac_refrigerant',0.60,0.63,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'600 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',120,89,'M14×1.5.'), (@gen,NULL,'spark_plug',30,22,'NGK PFR7S8EG.'),
  (@gen,NULL,'oil_drain',30,22,'M14×1.5.'), (@gen,NULL,'caliper_slide_pin',30,22,'Front.'),
  (@gen,NULL,'caliper_bracket',200,148,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'H7 AGM',760,80,180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED (sealed)',2,1),
  (@gen,NULL,'fog_front','H8',2,0),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','PY24W',2,0),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','W16W',2,0),(@gen,NULL,'turn_rear','PY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','F01',250,'Battery main'),
  (@gen,NULL,'engine_bay','F04',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F22',30,'Headlight'),
  (@gen,NULL,'cabin','01',30,'Blower'),
  (@gen,NULL,'cabin','07',20,'12V outlet'),
  (@gen,NULL,'cabin','10',20,'Discover Pro'),
  (@gen,NULL,'cabin','14',20,'Driver power seat'),
  (@gen,NULL,'cabin','23',20,'Sunroof'),
  (@gen,NULL,'cabin','32',10,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','06H905611','NGK (VW OE)',0.80,NULL,'PFR7S8EG · 3.6L VR6'),
  (@gen,NULL,'oil_filter','06H115403J','VW Genuine',NULL,NULL,'3.6L VR6 cartridge'),
  (@gen,NULL,'air_filter','3Q0129620','VW Genuine',NULL,NULL,'Atlas air filter'),
  (@gen,NULL,'cabin_filter','3Q0819644','VW Genuine',NULL,NULL,'Activated carbon'),
  (@gen,NULL,'wiper_front_d','3Q1955425','VW Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','3Q1955426','VW Genuine',NULL,'21 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,'VW LongLife.'),
  (@gen,NULL,'engine_air_filter',40000,20000,64000,32000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',80000,40000,128000,64000,NULL,'AQ450 8AT.'),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'spark_plugs',60000,40000,96000,64000,NULL,NULL),
  (@gen,NULL,'haldex_oil',40000,40000,64000,64000,NULL,'4MOTION only.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'255/70 R18 (S / SE)'),
  (@gen,NULL,'rear','normal',35,240,'255/70 R18 (S / SE)'),
  (@gen,NULL,'front','normal',35,240,'255/60 R20 (SEL Premium / R-Line)'),
  (@gen,NULL,'rear','normal',35,240,'255/60 R20 (SEL Premium / R-Line)'),
  (@gen,NULL,'spare','normal',60,420,'T155/90 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reminder-reset','Service reminder reset — Atlas (CA)','VW MQB pattern: steering wheel **VIEW** hold → service menu → long-press **0.0**.\n','• None.','• Resetting All instead of just the serviced item.'),
(@gen,'tpms_relearn','tpms-calibration','TPMS calibration — Atlas (CA)','Indirect TPMS. Settings → Tyres → Calibrate. Drive 10 min.\n','• None.','• Setting hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect order — Atlas (CA)','Negative-first, positive-last. BMS registration via VCDS/OBDeleven required after replacement.\n','• 10 mm wrench, gloves.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Atlas (CA)','Engine-bay jump terminals. Standard 4-clamp procedure.\n','• Jumper cables, donor 600+ CCA.','• Clamping black to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- NISSAN ROGUE T33 — gen 73
SET @gen := 73;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Nissan Rogue (T33) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Nissan Rogue (T33) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Nissan Rogue (T33) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/nissan/rogue-t33-suv-2021-present/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:2021_Nissan_Rogue_(T33)_front_view_(United_States).png',
    CURDATE(),'2021 Nissan Rogue (T33)','3-4-front',1280,720;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',4.70,4.97,'0W-20','API SP / ILSAC GF-6A','15208-65F0E',7500,12000,12,'2.5L PR25DD (early) · 4.97 qt. 1.5T KR15DDT (2022+): 4.5 qt 0W-20.'),
  (@gen,NULL,'transmission_cvt',7.40,7.82,NULL,'Nissan NS-3 CVT fluid',NULL,60000,96000,NULL,'Xtronic CVT.'),
  (@gen,NULL,'coolant',7.60,8.03,NULL,'Nissan Long Life Antifreeze (green)',NULL,NULL,NULL,NULL,'Initial 120k mi.'),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Nissan DOT 3',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'rear_differential',0.65,0.69,NULL,'Nissan Hypoid Gear Oil 80W-90',NULL,30000,48000,NULL,'AWD trims.'),
  (@gen,NULL,'ac_refrigerant',0.43,0.45,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'430 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',108,80,'M12×1.25.'),
  (@gen,NULL,'spark_plug',25,18,'NGK ILZKAR8H7G (PR25DD) / DILKAR7C9H (KR15DDT).'),
  (@gen,NULL,'oil_drain',32,24,'M12×1.5.'),
  (@gen,NULL,'caliper_slide_pin',38,28,'Front.'),
  (@gen,NULL,'caliper_bracket',107,79,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'24F (LN1)',550,55,130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED (sealed)',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',1,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','1',40,'ABS pump'),
  (@gen,NULL,'engine_bay','3',50,'EPS'),
  (@gen,NULL,'engine_bay','11',20,'L headlight'),
  (@gen,NULL,'engine_bay','12',20,'R headlight'),
  (@gen,NULL,'engine_bay','20',30,'Cooling fan'),
  (@gen,NULL,'cabin','1',20,'12V outlet'),
  (@gen,NULL,'cabin','5',30,'Wiper'),
  (@gen,NULL,'cabin','12',15,'Sunroof'),
  (@gen,NULL,'cabin','20',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','22401-EW61D','NGK (Nissan OE)',0.80,NULL,'ILZKAR8H7G · PR25DD'),
  (@gen,NULL,'oil_filter','15208-65F0E','Nissan Genuine',NULL,NULL,'Spin-on'),
  (@gen,NULL,'air_filter','16546-6CA0A','Nissan Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','27277-6CA0A','Nissan Genuine',NULL,NULL,'Activated carbon'),
  (@gen,NULL,'wiper_front_d','28890-6CA0A','Nissan Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','28890-6CA0B','Nissan Genuine',NULL,'17 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,NULL),
  (@gen,NULL,'tire_rotation',7500,3750,12000,6000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_cvt_fluid',60000,30000,96000,48000,NULL,'CVT NS-3.'),
  (@gen,NULL,'rear_diff_oil',30000,15000,48000,24000,NULL,'AWD only.'),
  (@gen,NULL,'spark_plugs',105000,60000,168000,96000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'235/65 R17 (S / SV)'),
  (@gen,NULL,'rear','normal',33,230,'235/65 R17 (S / SV)'),
  (@gen,NULL,'front','normal',33,230,'235/55 R19 (SL / Platinum)'),
  (@gen,NULL,'rear','normal',33,230,'235/55 R19 (SL / Platinum)'),
  (@gen,NULL,'spare','normal',60,420,'T155/90 D17 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'oil_life_reset','oil-maintenance-reset','Oil maintenance reset — Rogue (T33)','Cluster menu: Settings → Maintenance → Engine Oil → hold OK 1 s.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-easy-fill','TPMS Easy Fill — Rogue (T33)','Nissan Easy Fill: ignition ON, horn chirps when active tire reaches placard. Auto-relearn after 10-min drive.\n','• Tire pressure gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Rogue (T33)','Negative-first, positive-last. After reconnect: lock-to-lock for EPS.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Rogue (T33)','Standard 4-clamp procedure.\n','• Jumper cables, donor 600+ CCA.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- SUBARU CROSSTREK GT — gen 74
SET @gen := 74;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Subaru Crosstrek (GT) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Subaru Crosstrek (GT) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Subaru Crosstrek (GT) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/subaru/crosstrek-gt-suv-2018-2023/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons / Flickr CC','https://commons.wikimedia.org/wiki/File:2018_Subaru_Crosstrek_au_SIAM_2018.JPG',
    CURDATE(),'2018 Subaru Crosstrek (GT)','3-4-front',1280,853;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',4.80,5.07,'0W-20','API SP / ILSAC GF-6A','15208AA170',6000,9600,6,'2.0L FB20 · 5.07 qt with filter.'),
  (@gen,NULL,'transmission_cvt',11.7,12.4,NULL,'Subaru High Torque CVTF II',NULL,60000,96000,NULL,'Lineartronic CVT TR580.'),
  (@gen,NULL,'rear_differential',0.80,0.85,NULL,'Subaru Gear Oil 75W-90 GL-5',NULL,30000,48000,NULL,'Symmetrical AWD rear diff.'),
  (@gen,NULL,'coolant',6.20,6.55,NULL,'Subaru Super Coolant (blue, pre-mixed)',NULL,137500,220000,132,'Initial 11 yr.'),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Subaru DOT 3',NULL,NULL,NULL,30,NULL),
  (@gen,NULL,'ac_refrigerant',0.45,0.48,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'450 ±20 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',120,89,'M12×1.25.'),
  (@gen,NULL,'spark_plug',22,16,'NGK SILZKAR7B11 (FB20).'),
  (@gen,NULL,'oil_drain',44,32,'M14×1.5.'),
  (@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',100,74,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'25-550 (B24L)',550,50,130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (Limited+) / H7',2,1),(@gen,NULL,'headlight_high','H7',2,0),
  (@gen,NULL,'fog_front','H8',2,0),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','7507 (PY21W)',2,0),(@gen,NULL,'brake_tail','7443',2,0),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','7507 (PY21W)',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','194 (W5W)',1,0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','No.1',10,'Reverse circuit'),
  (@gen,NULL,'engine_bay','No.3',20,'Headlight'),
  (@gen,NULL,'engine_bay','No.12',30,'ABS pump'),
  (@gen,NULL,'engine_bay','No.18',30,'Wiper'),
  (@gen,NULL,'engine_bay','No.22',50,'EPS'),
  (@gen,NULL,'cabin','No.1',20,'Audio'),
  (@gen,NULL,'cabin','No.6',20,'Front 12V'),
  (@gen,NULL,'cabin','No.10',15,'Cigarette lighter'),
  (@gen,NULL,'cabin','No.22',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','22401AA800','NGK (Subaru OE)',0.80,NULL,'SILZKAR7B11 · FB20'),
  (@gen,NULL,'oil_filter','15208AA170','Subaru Genuine',NULL,NULL,'Cartridge FB20'),
  (@gen,NULL,'air_filter','16546AA12A','Subaru Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','72880FL00A','Subaru Genuine',NULL,NULL,'Activated carbon'),
  (@gen,NULL,'wiper_front_d','86532SG010','Subaru Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','86542SG010','Subaru Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',6000,3000,9600,4800,6,'FB20 6k mi.'),
  (@gen,NULL,'tire_rotation',6000,6000,9600,9600,NULL,'Symmetrical AWD.'),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_cvt_fluid',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'rear_diff_oil',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'spark_plugs',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,30,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',32,220,'225/60 R17 (Base / Premium)'),
  (@gen,NULL,'rear','normal',32,220,'225/60 R17 (Base / Premium)'),
  (@gen,NULL,'front','normal',32,220,'225/55 R18 (Sport / Limited)'),
  (@gen,NULL,'rear','normal',32,220,'225/55 R18 (Sport / Limited)'),
  (@gen,NULL,'spare','normal',60,420,'T155/70 D17 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reminder-reset','Service reminder reset — Crosstrek (GT)','Subaru ‘i’ stalk → Maintenance → Engine Oil Reminder → hold to reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-set','TPMS set — Crosstrek (GT)','Direct TPMS. STARLINK → TPMS → Set. Drive 15 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Crosstrek (GT)','Negative-first, positive-last. EyeSight self-cal during normal driving.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Crosstrek (GT)','Standard 4-clamp procedure. Subaru recommends engine-bay strut tower bolt for negative ground.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- TOYOTA TUNDRA XK70 — gen 75
SET @gen := 75;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Toyota Tundra (XK70) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Toyota Tundra (XK70) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Toyota Tundra (XK70) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/toyota/tundra-xk70-pickup-2022-present/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:2022_Toyota_Tundra_TRD_Pro.jpg',
    CURDATE(),'2022 Toyota Tundra TRD Pro (XK70)','3-4-front',1280,720;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',7.10,7.50,'0W-20','API SP / ILSAC GF-6A','04152-YZZA6',10000,16000,12,'3.5L V35A-FTS twin-turbo · 7.5 qt. i-FORCE MAX hybrid: same engine.'),
  (@gen,NULL,'transmission_at',12.0,12.7,NULL,'Toyota Genuine ATF WS',NULL,60000,96000,NULL,'10-speed AC10F1.'),
  (@gen,NULL,'transfer_case',1.85,1.96,NULL,'Toyota Transfer Case Fluid LF',NULL,60000,96000,NULL,'4WD only.'),
  (@gen,NULL,'front_differential',2.20,2.33,NULL,'Toyota 75W-85 GL-5',NULL,60000,96000,NULL,'4WD front.'),
  (@gen,NULL,'rear_differential',3.30,3.49,NULL,'Toyota 75W-85 GL-5',NULL,60000,96000,NULL,'10.5" rear axle. TRD Pro adds eLocker.'),
  (@gen,NULL,'coolant',16.0,16.9,NULL,'Toyota Super Long Life Coolant (pink)',NULL,100000,160000,120,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Toyota DOT 3',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'ac_refrigerant',0.80,0.85,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'800 ±30 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',209,154,'M14×1.5; star pattern.'),
  (@gen,NULL,'spark_plug',18,13,'Denso FK20HR11 · V35A-FTS (6 plugs).'),
  (@gen,NULL,'oil_drain',40,30,'M14×1.5.'),
  (@gen,NULL,'caliper_slide_pin',35,26,'Front.'),
  (@gen,NULL,'caliper_bracket',147,108,'Front carrier (truck-grade).'),
  (@gen,NULL,'diff_fill_plug',39,29,'Diff fill plug.'),
  (@gen,NULL,'transfer_case_drain',39,29,'TC drain plug.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'H8 (LN5) AGM',900,90,180);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED (sealed)',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'cargo_lamp','LED',2,1),
  (@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','AM1',50,'Ignition'),
  (@gen,NULL,'engine_bay','EFI MAIN',30,'Engine fuel inj'),
  (@gen,NULL,'engine_bay','HEAD',25,'Headlight'),
  (@gen,NULL,'engine_bay','ABS',40,'ABS pump'),
  (@gen,NULL,'engine_bay','RDI FAN',30,'Cooling fan'),
  (@gen,NULL,'engine_bay','TR-TOW',30,'Trailer 7-pin'),
  (@gen,NULL,'cabin','PWR OUT',20,'12V'),
  (@gen,NULL,'cabin','AUDIO',15,'Audio'),
  (@gen,NULL,'cabin','WIPER',30,'Wiper'),
  (@gen,NULL,'cabin','PWR DR',25,'Power door'),
  (@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','90919-01298','Denso (Toyota OE)',0.80,NULL,'FK20HR11 · V35A-FTS'),
  (@gen,NULL,'oil_filter','04152-YZZA6','Toyota Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','17801-0S010','Toyota Genuine',NULL,NULL,'XK70'),
  (@gen,NULL,'cabin_filter','87139-0E040','Toyota Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','85222-0C040','Toyota Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','85212-0C040','Toyota Genuine',NULL,'22 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,NULL),
  (@gen,NULL,'tire_rotation',5000,5000,8000,8000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,'10AT.'),
  (@gen,NULL,'transfer_case_fluid',60000,30000,96000,48000,NULL,'4WD only.'),
  (@gen,NULL,'front_diff_oil',60000,30000,96000,48000,NULL,'4WD only.'),
  (@gen,NULL,'rear_diff_oil',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'spark_plugs',120000,60000,192000,96000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'coolant_flush',100000,50000,160000,80000,120,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',38,260,'265/70 R18 (SR / SR5)'),
  (@gen,NULL,'rear','normal',38,260,'265/70 R18 (SR / SR5)'),
  (@gen,NULL,'front','normal',38,260,'275/55 R20 (Limited / Platinum)'),
  (@gen,NULL,'rear','normal',38,260,'275/55 R20 (Limited / Platinum)'),
  (@gen,NULL,'front','normal',30,205,'285/65 R18 (TRD Pro)'),
  (@gen,NULL,'rear','normal',30,205,'285/65 R18 (TRD Pro)'),
  (@gen,NULL,'spare','normal',60,420,'Full-size matching spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'oil_life_reset','oil-maintenance-reset','Oil maintenance reset — Tundra (XK70)','Toyota family pattern (same as Highlander / RAV4): ignition ON → trip-button hold while turning ignition ON → wait for 000000.\n','• None.','• Releasing button too early.'),
(@gen,'tpms_relearn','tpms-register','TPMS register — Tundra (XK70)','Press TPMS SET (under steering column) until blink 3×. Wait 20 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Tundra (XK70)','Negative-first, positive-last. Hybrid i-FORCE MAX: 12V in engine bay; HV battery under rear seat — never touch orange cables.\n','• 10 mm wrench.','• Touching HV cables on hybrid.'),
(@gen,'jump_start','jump-start','Jump-start — Tundra (XK70)','Standard 4-clamp procedure to 12V on passenger side. Hybrid: under-hood red-cap jump terminal.\n','• Jumper cables, donor 700+ CCA.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- CHEVY TAHOE T1XX — gen 76
SET @gen := 76;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Chevrolet Tahoe (T1XX) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Chevrolet Tahoe (T1XX) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Chevrolet Tahoe (T1XX) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/chevrolet/tahoe-t1xx-suv-2021-2024/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:2021_Chevrolet_Tahoe_Z71.jpg',
    CURDATE(),'2021 Chevrolet Tahoe Z71 (T1XX)','3-4-front',1280,720;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',7.60,8.00,'0W-20','API SP / dexos1 Gen 3','PF63E',7500,12000,12,'5.3L L84 V8 · 8.0 qt. 6.2L L87: 8.0 qt 0W-20. 3.0L LM2 Duramax: 7.5 qt 0W-20 dexos D.'),
  (@gen,NULL,'transmission_at',12.0,12.7,NULL,'Dexron HP ATF',NULL,60000,96000,NULL,'10L80 / 10L90 10-speed.'),
  (@gen,NULL,'transfer_case',1.40,1.48,NULL,'Auto-Trak II',NULL,75000,120000,NULL,'4WD only.'),
  (@gen,NULL,'rear_differential',1.85,1.96,NULL,'GM 75W-90 GL-5',NULL,75000,120000,NULL,'9.5" rear.'),
  (@gen,NULL,'coolant',14.0,14.8,NULL,'Dex-Cool (orange)',NULL,150000,240000,NULL,'Initial 150k mi.'),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','GM DOT 3',NULL,NULL,NULL,60,NULL),
  (@gen,NULL,'ac_refrigerant',0.85,0.90,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'850 ±30 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',190,140,'M14×1.5.'),
  (@gen,NULL,'spark_plug',20,15,'AC Delco 41-103 iridium · L84 V8.'),
  (@gen,NULL,'oil_drain',25,18,'M14×1.5.'),
  (@gen,NULL,'caliper_slide_pin',30,22,'Front.'),
  (@gen,NULL,'caliper_bracket',175,129,'Front carrier.'),
  (@gen,NULL,'diff_fill_plug',47,35,'Rear diff fill plug.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'H8 (94R) AGM',850,80,170);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED (sealed)',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1),
  (@gen,NULL,'cargo_lamp','LED',2,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','F1',60,'ABS'),
  (@gen,NULL,'engine_bay','F4',40,'Cooling fan'),
  (@gen,NULL,'engine_bay','F11',30,'Trailer'),
  (@gen,NULL,'engine_bay','F14',30,'4WD actuator'),
  (@gen,NULL,'engine_bay','F18',25,'Headlight LH'),
  (@gen,NULL,'engine_bay','F19',25,'Headlight RH'),
  (@gen,NULL,'engine_bay','F23',20,'Fuel pump'),
  (@gen,NULL,'cabin','IP1',20,'Driver power lock'),
  (@gen,NULL,'cabin','IP8',15,'Audio'),
  (@gen,NULL,'cabin','IP12',15,'Heated seats'),
  (@gen,NULL,'cabin','IP22',10,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','12671659','ACDelco (GM OE)',1.10,NULL,'41-114 · 5.3L L84'),
  (@gen,NULL,'spark_plug','12698554','ACDelco (GM OE)',1.10,NULL,'41-103 · 6.2L L87'),
  (@gen,NULL,'oil_filter','PF63E','ACDelco (GM OE)',NULL,NULL,'Spin-on'),
  (@gen,NULL,'air_filter','23295790','ACDelco (GM OE)',NULL,NULL,'Tahoe/Suburban air filter'),
  (@gen,NULL,'cabin_filter','23321737','ACDelco (GM OE)',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','84571726','GM Genuine',NULL,'22 in','Driver'),
  (@gen,NULL,'wiper_front_p','84571727','GM Genuine',NULL,'22 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,4000,12000,6400,12,'GM Oil-Life System.'),
  (@gen,NULL,'tire_rotation',7500,7500,12000,12000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',45000,22500,72000,36000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',22500,11250,36000,18000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',150000,75000,240000,120000,NULL,'10L80/10L90.'),
  (@gen,NULL,'transfer_case_fluid',75000,37500,120000,60000,NULL,'4WD only.'),
  (@gen,NULL,'rear_diff_oil',75000,37500,120000,60000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,60,'5 yr.'),
  (@gen,NULL,'spark_plugs',97500,60000,156000,96000,NULL,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'265/65 R18 (LS / LT)'),
  (@gen,NULL,'rear','normal',35,240,'265/65 R18 (LS / LT)'),
  (@gen,NULL,'front','normal',35,240,'275/55 R20 (Premier / High Country)'),
  (@gen,NULL,'rear','normal',35,240,'275/55 R20 (Premier / High Country)'),
  (@gen,NULL,'front','normal',35,240,'275/50 R22 (RST Performance Edition)'),
  (@gen,NULL,'rear','normal',35,240,'275/50 R22 (RST Performance Edition)'),
  (@gen,NULL,'spare','normal',60,420,'Full-size matching spare under cargo floor');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'oil_life_reset','oil-life-reset','Oil-Life System reset — Tahoe (T1XX)','Press MENU on DIC → Vehicle Information → Oil Life → hold SET/CLR.\n\nOR accelerator pedal method: ignition ON, press accelerator to floor 3× within 5 s.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-relearn','TPMS relearn — Tahoe (T1XX)','From DIC → Tire Pressure → SET/CLR. Horn chirps + LF turn signal. Magnet over each valve stem LF → RF → RR → LR within 90 s gaps.\n','• Magnet or TPMS activator.','• Letting the 90-sec gap time out.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Tahoe (T1XX)','Negative-first, positive-last. Dual-battery package on some trims — same order on both.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Tahoe (T1XX)','Standard 4-clamp procedure to 12V passenger side. Diesel 3.0 LM2 needs donor 700+ CCA in cold.\n','• Jumper cables 4 AWG, donor 600+ CCA gas / 700+ CCA diesel.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- GMC SIERRA 1500 T1XX — gen 77 (sibling of Silverado T1)
SET @gen := 77;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'GMC Sierra 1500 (T1XX) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'GMC Sierra 1500 (T1XX) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'GMC Sierra 1500 (T1XX) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/gmc/sierra-1500-t1xx-pickup-2019-2024/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:2021_GMC_Sierra_1500_AT4,_Front_Left,_03-26-2021.jpg',
    CURDATE(),'2021 GMC Sierra 1500 AT4 (T1XX)','3-4-front',1280,853;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',7.60,8.00,'0W-20','API SP / dexos1 Gen 3','PF63E',10000,16000,12,'5.3L L84 V8 · 8.0 qt. 6.2L L87: 8.0 qt. 3.0L LM2 Duramax: 7.5 qt dexos D.'),
  (@gen,NULL,'transmission_at',9.50,10.0,NULL,'Dexron HP ATF',NULL,60000,96000,NULL,'10L80 10AT (V8) / 8L90 (V6).'),
  (@gen,NULL,'transfer_case',1.40,1.48,NULL,'Auto-Trak II',NULL,75000,120000,NULL,'4WD.'),
  (@gen,NULL,'front_differential',1.10,1.16,NULL,'GM 75W-90 GL-5',NULL,75000,120000,NULL,'4WD only.'),
  (@gen,NULL,'rear_differential',2.10,2.22,NULL,'GM 75W-90 GL-5',NULL,75000,120000,NULL,'Eaton G80 / electronic locker.'),
  (@gen,NULL,'coolant',12.5,13.2,NULL,'Dex-Cool (orange)',NULL,150000,240000,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','GM DOT 3',NULL,NULL,NULL,60,'5 yr.'),
  (@gen,NULL,'ac_refrigerant',0.85,0.90,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'850 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',190,140,'M14×1.5.'),
  (@gen,NULL,'spark_plug',20,15,'AC Delco 41-103 iridium · L84 V8.'),
  (@gen,NULL,'oil_drain',25,18,'M14×1.5.'),
  (@gen,NULL,'caliper_slide_pin',30,22,'Front.'),
  (@gen,NULL,'caliper_bracket',175,129,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'H8 (94R) AGM',850,80,170);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (Elevation+)',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'cargo_lamp','906',2,0),
  (@gen,NULL,'bed_lamp','LED (Denali)',4,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','F1',60,'ABS pump'),
  (@gen,NULL,'engine_bay','F4',40,'Cooling fan'),
  (@gen,NULL,'engine_bay','F8',30,'Front blower'),
  (@gen,NULL,'engine_bay','F11',30,'Trailer'),
  (@gen,NULL,'engine_bay','F14',30,'4WD actuator'),
  (@gen,NULL,'engine_bay','F18',25,'Headlight LH'),
  (@gen,NULL,'engine_bay','F23',20,'Fuel pump'),
  (@gen,NULL,'cabin','IP1',20,'Driver power'),
  (@gen,NULL,'cabin','IP5',25,'Sliding rear window'),
  (@gen,NULL,'cabin','IP8',15,'Audio'),
  (@gen,NULL,'cabin','IP22',10,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','12671659','ACDelco (GM OE)',1.10,NULL,'41-114 · 5.3L L84'),
  (@gen,NULL,'oil_filter','PF63E','ACDelco (GM OE)',NULL,NULL,'Spin-on (shared with Silverado/Tahoe)'),
  (@gen,NULL,'air_filter','84121219','ACDelco (GM OE)',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','23321737','ACDelco (GM OE)',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','84571726','GM Genuine',NULL,'22 in','Driver'),
  (@gen,NULL,'wiper_front_p','84571727','GM Genuine',NULL,'22 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,4000,16000,6400,12,'GM Oil-Life System.'),
  (@gen,NULL,'tire_rotation',8000,8000,12800,12800,NULL,NULL),
  (@gen,NULL,'engine_air_filter',45000,22500,72000,36000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',22500,11250,36000,18000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',150000,75000,240000,120000,NULL,'10L80 / 8L90.'),
  (@gen,NULL,'transfer_case_fluid',75000,37500,120000,60000,NULL,'4WD only.'),
  (@gen,NULL,'rear_diff_oil',75000,37500,120000,60000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,60,'5 yr.'),
  (@gen,NULL,'spark_plugs',97500,60000,156000,96000,NULL,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'265/65 R18 (Pro / SLE)'),
  (@gen,NULL,'rear','normal',35,240,'265/65 R18 (Pro / SLE)'),
  (@gen,NULL,'front','normal',35,240,'275/55 R20 (Elevation / SLT / AT4)'),
  (@gen,NULL,'rear','normal',35,240,'275/55 R20 (Elevation / SLT / AT4)'),
  (@gen,NULL,'front','normal',35,240,'275/50 R22 (Denali)'),
  (@gen,NULL,'rear','normal',35,240,'275/50 R22 (Denali)'),
  (@gen,NULL,'front','loaded',45,310,'275/55 R20 — max tow / payload'),
  (@gen,NULL,'rear','loaded',50,345,'275/55 R20 — max tow / payload'),
  (@gen,NULL,'spare','normal',60,420,'Full-size matching spare under bed');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'oil_life_reset','oil-life-reset','Oil-Life System reset — Sierra 1500 (T1XX)','GM canonical (same as Silverado T1 / Tahoe T1XX): DIC → Vehicle Info → Oil Life → hold SET/CLR. OR accelerator method.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-relearn','TPMS relearn — Sierra 1500 (T1XX)','Same as Silverado T1: from DIC → Tire Pressure → SET/CLR. Horn chirps + turn-signal sequence with magnet per valve.\n','• Magnet or TPMS activator.','• 90-sec gap timeout.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Sierra 1500 (T1XX)','Negative-first, positive-last. Dual-battery on some trims — same order on both batteries.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Sierra 1500 (T1XX)','Standard 4-clamp procedure to 12V on passenger side. Diesel 3.0 LM2: donor 700+ CCA in cold.\n','• Jumper cables 4 AWG.','• Clamping to dead negative.'),
(@gen,'spare_tire','spare-tire-change','Spare tire lower & change — Sierra 1500 (T1XX)','Identical to Silverado T1 (same bed-mounted spare carrier).\n\n1. Insert extension+lug wrench through bumper access hole.\n2. Turn **counterclockwise** to lower spare.\n3. Disconnect retainer through wheel centre.\n4. Slide spare out.\n5. Crack lug nuts before jacking; jack at frame rail.\n6. Star-pattern lug install, torque to 190 N·m (140 ft·lb).\n','• OE scissor jack, lug wrench/extension.','• Tightening lug nuts in clockwise sequence — warps rotor.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

SELECT 'Batch 8 complete' AS status, (SELECT COUNT(*) FROM generations WHERE is_active=1) AS total_gens, (SELECT COUNT(*) FROM procedures) AS total_procs;
