-- Batch 9: Palisade LX2 + Sorento MQ4 + CX-50 + 5 Series G30 + Q5 FY + 4Runner N280

SET NAMES utf8mb4;

-- HYUNDAI PALISADE LX2 — gen 78
SET @gen := 78;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Hyundai Palisade (LX2) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Hyundai Palisade (LX2) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Hyundai Palisade (LX2) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/hyundai/palisade-lx2-suv-2020-2022/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:2020_Hyundai_Palisade_08-11-2019.jpg',
    CURDATE(),'2020 Hyundai Palisade (LX2)','3-4-front',1280,853;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',6.40,6.76,'5W-30','API SP / dexos1 Gen 3 equivalent','26300-3CAA0',7500,12000,12,'3.8L Lambda V6 (G6DR / G6DN) · 6.76 qt with filter.'),
  (@gen,NULL,'transmission_at',9.50,10.0,NULL,'Hyundai SP-IV ATF',NULL,60000,96000,NULL,'8-speed A8MF1.'),
  (@gen,NULL,'transfer_case',0.50,0.53,NULL,'Hyundai AWD coupling fluid',NULL,75000,120000,NULL,'AWD HTRAC.'),
  (@gen,NULL,'rear_differential',1.10,1.16,NULL,'Hyundai 75W-90 GL-5',NULL,75000,120000,NULL,'AWD rear.'),
  (@gen,NULL,'coolant',11.2,11.8,NULL,'Hyundai LLC (blue)',NULL,120000,192000,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Hyundai DOT 3',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.65,0.69,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'650 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',137,101,'M14×1.5.'),(@gen,NULL,'spark_plug',25,18,'NGK ILZFR6D-11.'),
  (@gen,NULL,'oil_drain',44,32,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',28,21,'Front.'),
  (@gen,NULL,'caliper_bracket',95,70,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'H6 (LN3)',760,80,150);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (Limited)',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',100,'Battery main'),(@gen,NULL,'engine_bay','ALT',150,'Alternator'),
  (@gen,NULL,'engine_bay','ABS',40,'ABS pump'),(@gen,NULL,'engine_bay','PWR',50,'MDPS'),
  (@gen,NULL,'engine_bay','HEAD',25,'Headlight'),(@gen,NULL,'cabin','IGN',30,'Ignition'),
  (@gen,NULL,'cabin','AUDIO',15,'Audio'),(@gen,NULL,'cabin','WIPER',30,'Wiper'),
  (@gen,NULL,'cabin','SEAT',20,'Heated seats'),(@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','18840-11051','NGK (Hyundai OE)',1.10,NULL,'ILZFR6D-11 · 3.8L Lambda V6'),
  (@gen,NULL,'oil_filter','26300-3CAA0','Hyundai Genuine',NULL,NULL,'Spin-on'),
  (@gen,NULL,'air_filter','28113-S8000','Hyundai Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','97133-S8000','Hyundai Genuine',NULL,NULL,'Activated carbon'),
  (@gen,NULL,'wiper_front_d','98350-S8000','Hyundai Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','98360-S8000','Hyundai Genuine',NULL,'21 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,NULL),(@gen,NULL,'tire_rotation',7500,3750,12000,6000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,'A8MF1.'),(@gen,NULL,'rear_diff_oil',75000,37500,120000,60000,NULL,'AWD only.'),
  (@gen,NULL,'spark_plugs',97500,60000,156000,96000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'245/60 R18 (SE)'),(@gen,NULL,'rear','normal',35,240,'245/60 R18 (SE)'),
  (@gen,NULL,'front','normal',35,240,'245/50 R20 (SEL / Limited / Calligraphy)'),(@gen,NULL,'rear','normal',35,240,'245/50 R20 (SEL / Limited / Calligraphy)'),
  (@gen,NULL,'spare','normal',60,420,'T165/90 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'service_reminder_reset','service-interval-reset','Service interval reset — Palisade (LX2)','Hyundai Group canonical: cluster → User Settings → Service Interval → Reset.\n','• None.','• Reset before service done.'),
(@gen,'tpms_relearn','tpms-auto','TPMS auto-relearn — Palisade (LX2)','Auto-relearn after 10-min drive above 15 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Palisade (LX2)','Negative-first, positive-last. After reconnect: lock-to-lock for MDPS.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Palisade (LX2)','Standard 4-clamp procedure. Donor 600+ CCA.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- KIA SORENTO MQ4 — gen 79
SET @gen := 79;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Kia Sorento (MQ4) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Kia Sorento (MQ4) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Kia Sorento (MQ4) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/kia/sorento-mq4-suv-2021-present/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:Kia_Sorento_MQ4_white_(3).jpg',
    CURDATE(),'Kia Sorento IV (MQ4)','3-4-front',1280,853;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',5.50,5.81,'5W-30','API SP / ILSAC GF-6','26300-2J000',7500,12000,12,'2.5T G2.5 turbo · 5.81 qt. Hybrid 1.6T+motor: 4.5 qt 0W-20.'),
  (@gen,NULL,'transmission_at',7.50,7.93,NULL,'Hyundai SP-IV ATF',NULL,60000,96000,NULL,'8AT / 8DCT (2.5T).'),
  (@gen,NULL,'transfer_case',0.50,0.53,NULL,'Kia AWD coupling',NULL,75000,120000,NULL,'AWD only.'),
  (@gen,NULL,'rear_differential',0.80,0.85,NULL,'Kia 75W-90 GL-5',NULL,75000,120000,NULL,'AWD rear.'),
  (@gen,NULL,'coolant',9.50,10.0,NULL,'Hyundai LLC (blue)',NULL,120000,192000,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Kia DOT 3',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'550 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',107,79,'M12×1.5.'),(@gen,NULL,'spark_plug',25,18,'NGK ILZFR6D-11 (2.5T).'),
  (@gen,NULL,'oil_drain',35,26,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',22,16,'Front.'),
  (@gen,NULL,'caliper_bracket',95,70,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'24F (LN2)',600,70,130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED (sealed)',2,1),
  (@gen,NULL,'drl','LED',2,1),(@gen,NULL,'turn_front','LED',2,1),
  (@gen,NULL,'brake_tail','LED',2,1),(@gen,NULL,'reverse','921 (W16W)',2,0),
  (@gen,NULL,'turn_rear','WY21W',2,0),(@gen,NULL,'license_plate','LED',2,1),
  (@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',100,'Battery main'),(@gen,NULL,'engine_bay','ABS',40,'ABS pump'),
  (@gen,NULL,'engine_bay','PWR',50,'MDPS'),(@gen,NULL,'engine_bay','COOL',40,'Cooling fan'),
  (@gen,NULL,'engine_bay','HEAD',25,'Headlight'),(@gen,NULL,'cabin','AUDIO',15,'Audio'),
  (@gen,NULL,'cabin','WIPER',30,'Wiper'),(@gen,NULL,'cabin','SEAT',20,'Heated seats'),
  (@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','18849-08080','NGK (Kia OE)',0.80,NULL,'SILZKR7B8EG · Smartstream / 2.5T'),
  (@gen,NULL,'oil_filter','26300-2J000','Kia Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','28113-P2000','Kia Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','97133-P2000','Kia Genuine',NULL,NULL,'Activated carbon'),
  (@gen,NULL,'wiper_front_d','98350-P2000','Kia Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','98360-P2000','Kia Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,NULL),(@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),(@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'rear_diff_oil',75000,37500,120000,60000,NULL,'AWD.'),(@gen,NULL,'spark_plugs',97500,60000,156000,96000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'235/65 R17 (LX / S)'),(@gen,NULL,'rear','normal',33,230,'235/65 R17 (LX / S)'),
  (@gen,NULL,'front','normal',33,230,'235/55 R19 (EX / SX)'),(@gen,NULL,'rear','normal',33,230,'235/55 R19 (EX / SX)'),
  (@gen,NULL,'front','normal',33,230,'235/55 R20 (X-Line)'),(@gen,NULL,'rear','normal',33,230,'235/55 R20 (X-Line)'),
  (@gen,NULL,'spare','normal',60,420,'T165/90 D17');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'service_reminder_reset','service-interval-reset','Service interval reset — Sorento (MQ4)','Hyundai Group canonical: cluster → User Settings → Service Interval → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-auto','TPMS auto-relearn — Sorento (MQ4)','Auto-relearn after 10-min drive above 15 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Sorento (MQ4)','Negative-first, positive-last.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Sorento (MQ4)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- MAZDA CX-50 — gen 80
SET @gen := 80;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Mazda CX-50 Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Mazda CX-50 Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Mazda CX-50 Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/mazda/cx-50-suv-2023-present/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:MAZDA_CX-50_China.jpg',
    CURDATE(),'Mazda CX-50','3-4-front',1280,853;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',4.50,4.75,'0W-20','API SP / ILSAC GF-6A','PE01-14-302A',7500,12000,12,'2.5L PY-VPS · 4.75 qt. 2.5T turbo (PY-VPTS): 5.0 qt 5W-30.'),
  (@gen,NULL,'transmission_at',6.60,6.97,NULL,'Mazda ATF FZ',NULL,NULL,NULL,NULL,'Skyactiv-Drive 6AT.'),
  (@gen,NULL,'rear_differential',1.20,1.27,NULL,'Mazda 75W-90 GL-5',NULL,60000,96000,NULL,'i-ACTIV AWD.'),
  (@gen,NULL,'coolant',7.40,7.82,NULL,'Mazda FL22 (green)',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Mazda DOT 3',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.50,0.53,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'500 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',108,80,'M12×1.5.'),(@gen,NULL,'spark_plug',20,15,'NGK ILTR5A-13G.'),
  (@gen,NULL,'oil_drain',33,24,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',33,24,'Front.'),
  (@gen,NULL,'caliper_bracket',90,66,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'35 (Q-85 EFB)',580,65,110);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',1,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','20',30,'ABS pump'),(@gen,NULL,'engine_bay','26',40,'EPS'),
  (@gen,NULL,'engine_bay','32',30,'Blower'),(@gen,NULL,'engine_bay','41',15,'ECU'),
  (@gen,NULL,'engine_bay','48',25,'Headlight'),(@gen,NULL,'cabin','1',10,'Audio'),
  (@gen,NULL,'cabin','4',20,'Driver window'),(@gen,NULL,'cabin','7',15,'12V outlet'),
  (@gen,NULL,'cabin','12',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','PE5R-18-110','NGK (Mazda OE)',0.80,NULL,'ILTR5A-13G'),
  (@gen,NULL,'oil_filter','PE01-14-302A','Mazda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','PE07-13-3A0','Mazda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','KD45-61-J6X','Mazda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','KD45-67-330','Mazda Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','KD45-67-340','Mazda Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,5000,12000,8000,12,NULL),(@gen,NULL,'tire_rotation',7500,5000,12000,8000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'rear_diff_oil',60000,30000,96000,48000,NULL,'AWD only.'),
  (@gen,NULL,'spark_plugs',75000,40000,120000,64000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',32,220,'225/65 R17 (Select / Preferred)'),(@gen,NULL,'rear','normal',32,220,'225/65 R17 (Select / Preferred)'),
  (@gen,NULL,'front','normal',33,230,'225/55 R20 (Premium / Turbo)'),(@gen,NULL,'rear','normal',33,230,'225/55 R20 (Premium / Turbo)'),
  (@gen,NULL,'spare','normal',60,420,'T155/90 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'oil_life_reset','oil-data-reset','Engine Oil Data reset — CX-50','Same Mazda pattern as CX-5 KF / Mazda3 BP: ignition ON → INFO long-press on Engine Oil Data.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-set','TPMS set — CX-50','Direct TPMS auto-registered after drive. Mazda Connect → Settings → TPMS → Initialise.\n','• None.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — CX-50','Negative-first, positive-last.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — CX-50','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- BMW 5 SERIES G30 — gen 81 (sibling of G20 in BMW model)
SET @gen := 81;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'BMW 5 Series (G30) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'BMW 5 Series (G30) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'BMW 5 Series (G30) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/bmw/5-series-g30-sedan-2017-2020/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:BMW_G30_5-series.jpg',
    CURDATE(),'BMW 5 Series (G30)','3-4-front',1280,720;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',6.50,6.87,'0W-30','BMW Longlife-04','11428583898',10000,16000,12,'2.0L B48 (530i) · 5.3 qt. 3.0L B58 (540i): 6.9 qt. 2.0L B47 diesel (520d): 5.5 qt.'),
  (@gen,NULL,'transmission_at',8.50,9.00,NULL,'ZF Lifeguard 8',NULL,100000,160000,NULL,'ZF 8HP — service at 60k mi.'),
  (@gen,NULL,'transfer_case',0.80,0.85,NULL,'BMW ATF for transfer case',NULL,NULL,NULL,NULL,'xDrive — lifetime.'),
  (@gen,NULL,'front_differential',1.10,1.16,NULL,'BMW SAF-XO',NULL,NULL,NULL,NULL,'xDrive front — lifetime.'),
  (@gen,NULL,'rear_differential',1.20,1.27,NULL,'BMW SAF-XO',NULL,NULL,NULL,NULL,'Lifetime.'),
  (@gen,NULL,'coolant',10.5,11.1,NULL,'BMW HT-12 (blue)',NULL,NULL,NULL,NULL,'Lifetime.'),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','BMW DOT 4 LV',NULL,NULL,NULL,24,'2 yr.'),
  (@gen,NULL,'ac_refrigerant',0.65,0.69,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'650 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',140,103,'M14×1.25.'),(@gen,NULL,'spark_plug',23,17,'NGK ILZKAR8H10SG · B48 / B58.'),
  (@gen,NULL,'oil_drain',25,18,'M22×1.5.'),(@gen,NULL,'caliper_slide_pin',28,21,'Front.'),
  (@gen,NULL,'caliper_bracket',110,81,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'H7 AGM',760,80,200);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Adaptive',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','LED',2,1),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','F01',250,'Battery main'),(@gen,NULL,'engine_bay','F04',50,'Cooling fan'),
  (@gen,NULL,'engine_bay','F08',40,'DSC pump'),(@gen,NULL,'engine_bay','F15',30,'Blower'),
  (@gen,NULL,'cabin','F100',30,'Driver door'),(@gen,NULL,'cabin','F101',30,'Passenger door'),
  (@gen,NULL,'cabin','F125',25,'iDrive'),(@gen,NULL,'cabin','F134',20,'Trunk lid'),
  (@gen,NULL,'cabin','F139',20,'Heated front seats'),(@gen,NULL,'cabin','F154',10,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','12120040551','NGK (BMW OE)',0.80,NULL,'ILZKAR8H10SG · B48/B58'),
  (@gen,NULL,'oil_filter','11428583898','BMW Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','13718580428','BMW Genuine',NULL,NULL,'G30 air filter'),
  (@gen,NULL,'cabin_filter','64119272642','BMW Genuine',NULL,NULL,'HEPA'),
  (@gen,NULL,'wiper_front_d','61617200822','BMW Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','61617242147','BMW Genuine',NULL,'20 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,'BMW CBS.'),(@gen,NULL,'brake_inspection',10000,5000,16000,8000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',100000,60000,160000,96000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'spark_plugs',60000,NULL,96000,NULL,NULL,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',32,220,'225/55 R17 (base)'),(@gen,NULL,'rear','normal',34,235,'225/55 R17 (base)'),
  (@gen,NULL,'front','normal',33,230,'245/45 R18 (M-Sport)'),(@gen,NULL,'rear','normal',35,240,'275/40 R18 (M-Sport rear)'),
  (@gen,NULL,'spare','normal',60,420,'Run-flat — no spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'service_reminder_reset','cbs-reset','CBS reset — 5 Series (G30)','BMW canonical: iDrive → Settings → Maintenance → confirm reset per item.\n','• None.','• Resetting more items than serviced.'),
(@gen,'battery_register','battery-register','Battery registration — 5 Series (G30)','After AGM replacement, register via ISTA / Bimmercode / Carly. Without it the alternator profile is wrong.\n','• Scan tool with BMW battery registration.','• Skipping registration.'),
(@gen,'tpms_relearn','tpms-reset','TPMS reset — 5 Series (G30)','iDrive → Vehicle status → TPMS → Reset. Drive 10 min above 12 mph.\n','• None.','• Hot pressures.'),
(@gen,'jump_start','jump-start','Jump-start — 5 Series (G30)','12V in trunk; use under-hood jump terminals (red cap +). Never jump from the trunk.\n','• Jumper cables.','• Jumping from trunk directly.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- AUDI Q5 FY — gen 82
SET @gen := 82;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Audi Q5 (FY) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Audi Q5 (FY) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Audi Q5 (FY) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/audi/q5-fy-suv-2017-2020/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:Audi_Q5_FY_50_TFSI_e_Facelift_IMG_5284.jpg',
    CURDATE(),'Audi Q5 II (FY)','3-4-front',1280,853;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',5.70,6.02,'5W-30','VW 504 00 / 507 00','06L115562B',10000,16000,12,'2.0 TFSI EA888 · 6.0 qt. 3.0 TFSI V6 (SQ5): 8.0 qt. 2.0 TDI: 4.3 qt 5W-30 VW 507 00.'),
  (@gen,NULL,'transmission_at',6.50,6.87,NULL,'VW G 052 533 ATF',NULL,40000,64000,NULL,'7-speed DQ500 wet DSG / 8-speed ZF (3.0 TFSI).'),
  (@gen,NULL,'haldex_oil',0.85,0.90,NULL,'VW G 060 175 A2',NULL,40000,64000,NULL,'quattro Haldex.'),
  (@gen,NULL,'rear_differential',0.85,0.90,NULL,'Audi sport differential oil (G 052 145)',NULL,NULL,NULL,NULL,'SQ5 sport diff.'),
  (@gen,NULL,'coolant',9.00,9.51,NULL,'VW G 13 (lilac)',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','VW DOT 4 Class 6',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'550 ±25 g.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',140,103,'M14×1.5.'),(@gen,NULL,'spark_plug',30,22,'NGK PFR8S8EG (EA888).'),
  (@gen,NULL,'oil_drain',30,22,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',30,22,'Front.'),
  (@gen,NULL,'caliper_bracket',200,148,'Front carrier.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'H7 AGM',760,80,200);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Matrix opt / H7',2,1),(@gen,NULL,'headlight_high','LED / H7',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','PY24W / LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','W16W',2,0),(@gen,NULL,'turn_rear','PY21W / LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','F01',250,'Battery main'),(@gen,NULL,'engine_bay','F04',50,'Cooling fan'),
  (@gen,NULL,'engine_bay','F12',25,'ECU'),(@gen,NULL,'engine_bay','F22',30,'Headlight'),
  (@gen,NULL,'cabin','01',30,'Blower'),(@gen,NULL,'cabin','07',20,'12V outlet'),
  (@gen,NULL,'cabin','10',20,'MMI'),(@gen,NULL,'cabin','14',20,'Driver power seat'),
  (@gen,NULL,'cabin','23',20,'Sunroof'),(@gen,NULL,'cabin','32',10,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','06H905611','NGK (Audi OE)',0.80,NULL,'PFR8S8EG · EA888'),
  (@gen,NULL,'oil_filter','06L115562B','Audi Genuine',NULL,NULL,'EA888 cartridge'),
  (@gen,NULL,'air_filter','80A129620','Audi Genuine',NULL,NULL,'Q5 FY air filter'),
  (@gen,NULL,'cabin_filter','80A819439','Audi Genuine',NULL,NULL,'Activated carbon'),
  (@gen,NULL,'wiper_front_d','80A998002','Audi Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','80A998002','Audi Genuine',NULL,'20 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,'Audi LongLife.'),
  (@gen,NULL,'engine_air_filter',40000,20000,64000,32000,NULL,NULL),(@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',40000,40000,64000,64000,NULL,'DQ500 DSG.'),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'spark_plugs',60000,40000,96000,64000,NULL,NULL),(@gen,NULL,'haldex_oil',40000,40000,64000,64000,NULL,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'235/65 R17 (Premium)'),(@gen,NULL,'rear','normal',33,230,'235/65 R17 (Premium)'),
  (@gen,NULL,'front','normal',33,230,'235/55 R19 (Premium Plus)'),(@gen,NULL,'rear','normal',33,230,'235/55 R19 (Premium Plus)'),
  (@gen,NULL,'front','normal',35,240,'255/45 R20 (Prestige / S line)'),(@gen,NULL,'rear','normal',35,240,'255/45 R20 (Prestige / S line)'),
  (@gen,NULL,'spare','normal',60,420,'T155/90 D18 compact spare');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reminder-reset','Service reminder reset — Audi Q5 (FY)','MMI → Car → Service & Inspection → Reset for relevant counter.\n','• None.','• Resetting before service is done.'),
(@gen,'tpms_relearn','tpms-store','TPMS store — Audi Q5 (FY)','Indirect TPMS. MMI → Car → Tyres → Store tyre pressures. Drive 10 min.\n','• None.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Audi Q5 (FY)','Negative-first, positive-last. Battery in engine bay. Registration via VCDS / OBDeleven after replacement.\n','• 10 mm wrench.','• Positive first; skipping registration.'),
(@gen,'jump_start','jump-start','Jump-start — Audi Q5 (FY)','Under-hood jump terminals (red cap +, ground stud −).\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- TOYOTA 4RUNNER N280 — gen 83
SET @gen := 83;
INSERT INTO sources (type, citation, retrieved_at, is_public)
  SELECT 'oem_manual', 'Toyota 4Runner (N280) Owner''s Manual', NOW(), 1
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation = 'Toyota 4Runner (N280) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation = 'Toyota 4Runner (N280) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)
  SELECT @gen,NULL,NULL,'/images/toyota/4runner-n280-suv-2010-2024/hero.jpg','wikimedia','cc-by-sa-4.0',
    'Wikimedia Commons contributor','https://commons.wikimedia.org/wiki/File:Toyota_4Runner_(2014-2024_facelift_model).jpg',
    CURDATE(),'Toyota 4Runner (N280) — 2014+ facelift','3-4-front',1280,720;
INSERT INTO fluid_specs (generation_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen,NULL,'engine_oil',5.70,6.02,'0W-20','API SP / ILSAC GF-6A','04152-YZZA6',10000,16000,12,'4.0L 1GR-FE V6 · 6.0 qt with filter.'),
  (@gen,NULL,'transmission_at',8.30,8.77,NULL,'Toyota WS ATF',NULL,60000,96000,NULL,'5-speed A750F.'),
  (@gen,NULL,'transfer_case',1.30,1.37,NULL,'Toyota TC fluid LF',NULL,60000,96000,NULL,'4WD only.'),
  (@gen,NULL,'front_differential',1.40,1.48,NULL,'Toyota 75W-85 GL-5',NULL,60000,96000,NULL,'4WD only.'),
  (@gen,NULL,'rear_differential',2.10,2.22,NULL,'Toyota 75W-85 GL-5',NULL,60000,96000,NULL,'TRD Pro: add LSD additive.'),
  (@gen,NULL,'coolant',12.7,13.4,NULL,'Toyota Super Long Life Coolant (pink)',NULL,100000,160000,120,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Toyota DOT 3',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-134a (pre-2018) / R-1234yf (2018+)',NULL,NULL,NULL,NULL,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs (generation_id, market_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen,NULL,'lug_nut',114,84,'M12×1.5.'),(@gen,NULL,'spark_plug',18,13,'Denso SK20HR11 · 1GR-FE.'),
  (@gen,NULL,'oil_drain',40,30,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',35,26,'Front.'),
  (@gen,NULL,'caliper_bracket',132,97,'Front carrier.'),(@gen,NULL,'diff_fill_plug',40,30,'Diff plug.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs (generation_id, market_id, battery_group, cca, ah, alternator_amps) VALUES (@gen,NULL,'24F (LN2)',550,55,130);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs (generation_id, market_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen,NULL,'headlight_low','H11 (LED facelift)',2,0),(@gen,NULL,'headlight_high','9005 (HB3)',2,0),
  (@gen,NULL,'fog_front','H16 (PSX24W)',2,0),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','7507 (PY21W)',2,0),(@gen,NULL,'brake_tail','7443',2,0),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','7507 (PY21W)',2,0),
  (@gen,NULL,'license_plate','194 (W5W)',2,0),(@gen,NULL,'cargo_lamp','921 (W16W)',2,0);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses (generation_id, market_id, location, position, amperage, circuit_name) VALUES
  (@gen,NULL,'engine_bay','AM1',50,'Ignition'),(@gen,NULL,'engine_bay','EFI MAIN',30,'Fuel inj'),
  (@gen,NULL,'engine_bay','HEAD',25,'Headlight'),(@gen,NULL,'engine_bay','ABS',40,'ABS pump'),
  (@gen,NULL,'engine_bay','RDI FAN',30,'Cooling fan'),(@gen,NULL,'engine_bay','TR-TOW',30,'Trailer'),
  (@gen,NULL,'cabin','PWR OUT',20,'12V'),(@gen,NULL,'cabin','AUDIO',15,'Audio'),
  (@gen,NULL,'cabin','WIPER',30,'Wiper'),(@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts (generation_id, market_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (@gen,NULL,'spark_plug','90919-01253','Denso (Toyota OE)',1.10,NULL,'SK20HR11 · 1GR-FE'),
  (@gen,NULL,'oil_filter','04152-YZZA6','Toyota Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','17801-31130','Toyota Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','87139-YZZ20','Toyota Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','85212-35100','Toyota Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','85222-35100','Toyota Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals (generation_id, market_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,NULL),(@gen,NULL,'tire_rotation',5000,5000,8000,8000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,'A750F.'),(@gen,NULL,'transfer_case_fluid',60000,30000,96000,48000,NULL,'4WD only.'),
  (@gen,NULL,'front_diff_oil',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'rear_diff_oil',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'spark_plugs',120000,60000,192000,96000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'coolant_flush',100000,50000,160000,80000,120,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures (generation_id, market_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen,NULL,'front','normal',29,200,'265/70 R17 (SR5 / Trail)'),(@gen,NULL,'rear','normal',29,200,'265/70 R17 (SR5 / Trail)'),
  (@gen,NULL,'front','normal',32,220,'265/60 R18 (Limited)'),(@gen,NULL,'rear','normal',32,220,'265/60 R18 (Limited)'),
  (@gen,NULL,'front','normal',29,200,'265/70 R17 (TRD Pro 17")'),(@gen,NULL,'rear','normal',29,200,'265/70 R17 (TRD Pro 17")'),
  (@gen,NULL,'spare','normal',60,420,'Full-size matching spare under cargo floor');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
(@gen,'oil_life_reset','oil-maintenance-reset','Oil maintenance reset — 4Runner (N280)','Toyota canonical (same as Highlander / RAV4): ignition ON, trip-button hold while turning to ON.\n','• None.','• Releasing button too early.'),
(@gen,'tpms_relearn','tpms-register','TPMS register — 4Runner (N280)','Press TPMS SET until warning blinks 3×. Wait 20 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — 4Runner (N280)','Negative-first, positive-last.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — 4Runner (N280)','Standard 4-clamp procedure.\n','• Jumper cables, donor 550+ CCA.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

SELECT 'Batch 9 done' AS status, (SELECT COUNT(*) FROM generations WHERE is_active=1) AS gens, (SELECT COUNT(*) FROM procedures) AS procs;
