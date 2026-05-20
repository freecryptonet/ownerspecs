-- Batch 10: Odyssey RL6 + Sienna XL40 + Pacifica RU + Maverick + TLX II + G70 IK
-- Compact format — same canonical moat data structure as prior batches.

SET NAMES utf8mb4;

-- Honda Odyssey RL6 — gen 84
SET @gen := 84;
INSERT INTO sources (type, citation, retrieved_at, is_public) SELECT 'oem_manual','Honda Odyssey (RL6) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Honda Odyssey (RL6) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation='Honda Odyssey (RL6) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/honda/odyssey-rl6-minivan-2018-2023/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Honda_Odyssey_2018_Chinese_facelift_001.jpg',CURDATE(),'Honda Odyssey V (RL6)','3-4-front',1280,853;
INSERT INTO fluid_specs (generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',4.30,4.54,'0W-20','API SP','15400-PLM-A02',7500,12000,12,'3.5L J35Y6 V6 · 4.54 qt.'),
  (@gen,NULL,'transmission_at',8.40,8.88,NULL,'Honda DW-1 ATF',NULL,60000,96000,NULL,'9-speed / 10-speed.'),
  (@gen,NULL,'coolant',8.40,8.88,NULL,'Honda Type 2 LLC',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Honda DOT 3',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'550 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',108,80,'M12×1.5.'),(@gen,NULL,'spark_plug',18,13,'Denso SK20HR11 · J35Y6.'),
  (@gen,NULL,'oil_drain',40,30,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',36,27,'Front.'),
  (@gen,NULL,'caliper_bracket',109,80,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'24F (LN2)',550,55,130);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','1',40,'ABS'),(@gen,NULL,'engine_bay','3',50,'EPS'),
  (@gen,NULL,'engine_bay','5',50,'IG1'),(@gen,NULL,'engine_bay','20',30,'Cooling fan'),
  (@gen,NULL,'cabin','1',20,'12V outlet'),(@gen,NULL,'cabin','5',30,'Wiper'),
  (@gen,NULL,'cabin','15',25,'Power sliding doors'),(@gen,NULL,'cabin','20',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','12290-5G0-A01','Denso (Honda OE)',1.10,NULL,'SK20HR11'),
  (@gen,NULL,'oil_filter','15400-PLM-A02','Honda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','17220-5MR-A01','Honda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','80292-THR-A01','Honda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','76622-THR-A01','Honda Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','76632-THR-A01','Honda Genuine',NULL,'22 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,NULL),(@gen,NULL,'tire_rotation',7500,3750,12000,6000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'spark_plugs',105000,60000,168000,96000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'235/65 R18 (LX / EX)'),(@gen,NULL,'rear','normal',35,240,'235/65 R18 (LX / EX)'),
  (@gen,NULL,'front','normal',35,240,'235/60 R19 (Touring / Elite)'),(@gen,NULL,'rear','normal',35,240,'235/60 R19 (Touring / Elite)'),
  (@gen,NULL,'spare','normal',60,420,'T155/80 D18 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'maintenance_minder_reset','maintenance-minder-reset','Maintenance Minder reset — Odyssey (RL6)','Honda DIC pattern (same as Civic/CR-V): Settings → Vehicle → Maintenance Info → select item → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-calibration','TPMS calibration — Odyssey (RL6)','Indirect TPMS. DIC → Settings → Vehicle → TPMS Calibration → Calibrate. Drive 30 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Odyssey (RL6)','Negative-first, positive-last.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Odyssey (RL6)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative post.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Toyota Sienna XL40 — gen 85 (Toyota Sienna 2.5 hybrid only, GA-K platform sibling of RAV4 XA50)
SET @gen := 85;
INSERT INTO sources (type, citation, retrieved_at, is_public) SELECT 'oem_manual','Toyota Sienna (XL40) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Toyota Sienna (XL40) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation='Toyota Sienna (XL40) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/toyota/sienna-xl40-minivan-2021-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:0_Toyota_Sienna_(XL40)_1.jpg',CURDATE(),'Toyota Sienna IV (XL40)','3-4-front',1280,720;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',4.30,4.54,'0W-16','API SP','04152-YZZA6',10000,16000,12,'2.5L A25A-FXS hybrid only · 4.54 qt.'),
  (@gen,NULL,'transmission_ecvt',4.20,4.44,NULL,'Toyota WS ATF',NULL,NULL,NULL,NULL,'Hybrid eCVT.'),
  (@gen,NULL,'rear_differential',0.95,1.00,NULL,'Toyota 75W-85 GL-5',NULL,NULL,NULL,NULL,'AWD trims — electric rear motor + diff.'),
  (@gen,NULL,'coolant',9.10,9.62,NULL,'Toyota SLLC (pink)',NULL,100000,160000,120,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Toyota DOT 3',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'550 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',103,76,'M12×1.5.'),(@gen,NULL,'spark_plug',18,13,'Denso FK20HR11.'),
  (@gen,NULL,'oil_drain',40,30,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',34,25,'Front.'),
  (@gen,NULL,'caliper_bracket',107,79,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H6 (LN3) AGM',760,80,150);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','AM1',50,'Ignition'),(@gen,NULL,'engine_bay','EFI MAIN',30,'Fuel inj'),
  (@gen,NULL,'engine_bay','HEAD',25,'Headlight'),(@gen,NULL,'engine_bay','ABS',40,'ABS pump'),
  (@gen,NULL,'cabin','PWR OUT',20,'12V'),(@gen,NULL,'cabin','AUDIO',15,'Audio'),
  (@gen,NULL,'cabin','WIPER',30,'Wiper'),(@gen,NULL,'cabin','SEAT HTR',20,'Heated seats'),
  (@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','90919-01298','Denso (Toyota OE)',0.80,NULL,'FK20HR11 · A25A-FXS'),
  (@gen,NULL,'oil_filter','04152-YZZA6','Toyota Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','17801-F0050','Toyota Genuine',NULL,NULL,'GA-K shared'),
  (@gen,NULL,'cabin_filter','87139-08010','Toyota Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','85212-08020','Toyota Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','85222-08020','Toyota Genuine',NULL,'22 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,NULL),(@gen,NULL,'tire_rotation',5000,5000,8000,8000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'spark_plugs',120000,60000,192000,96000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'coolant_flush',100000,50000,160000,80000,120,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'235/60 R18 (LE / XLE)'),(@gen,NULL,'rear','normal',35,240,'235/60 R18 (LE / XLE)'),
  (@gen,NULL,'front','normal',33,230,'235/55 R20 (XSE / Limited / Platinum)'),(@gen,NULL,'rear','normal',33,230,'235/55 R20 (XSE / Limited / Platinum)'),
  (@gen,NULL,'spare','normal',60,420,'T155/80 D18');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-maintenance-reset','Oil maintenance reset — Sienna (XL40)','Toyota canonical: ignition ON, trip-button hold while turning to ON. Hybrid: press POWER twice without brake to reach IG ON.\n','• None.','• Releasing button too early.'),
(@gen,'tpms_relearn','tpms-register','TPMS register — Sienna (XL40)','TPMS SET (under steering column) hold until blink 3×. Wait 20 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Sienna (XL40)','Negative-first, positive-last. 12V auxiliary in engine bay; HV battery under rear seat — never touch orange cables.\n','• 10 mm wrench.','• Touching HV cables.'),
(@gen,'jump_start','jump-start','Jump-start — Sienna (XL40)','Under-hood red-cap jump terminal (hybrid). Standard 4-clamp procedure with engine-block ground.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Chrysler Pacifica RU — gen 86
SET @gen := 86;
INSERT INTO sources (type, citation, retrieved_at, is_public) SELECT 'oem_manual','Chrysler Pacifica (RU) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Chrysler Pacifica (RU) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation='Chrysler Pacifica (RU) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/chrysler/pacifica-ru-minivan-2017-2023/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:2017_Chrysler_Pacifica_Touring_L_Plus.jpg',CURDATE(),'2017 Chrysler Pacifica (RU)','3-4-front',1280,853;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',5.70,6.00,'0W-20','API SP / Chrysler MS-6395','68191349AC',10000,16000,12,'3.6L Pentastar V6 · 6.0 qt. PHEV: same engine with 16 kWh battery.'),
  (@gen,NULL,'transmission_at',9.50,10.0,NULL,'Mopar MS-12892 ATF',NULL,60000,96000,NULL,'9-speed 948TE (gas) / eCVT (PHEV).'),
  (@gen,NULL,'coolant',13.0,13.7,NULL,'Mopar OAT (orange)',NULL,150000,240000,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Mopar DOT 3',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.85,0.90,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'850 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',176,130,'M14×1.5.'),(@gen,NULL,'spark_plug',17,13,'NGK ZFR6F-11G.'),
  (@gen,NULL,'oil_drain',34,25,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',35,26,'Front.'),
  (@gen,NULL,'caliper_bracket',175,129,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H8 (94R) AGM',800,80,220);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (Limited)',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','3157NAK',2,0),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','3157NAK',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','F01',200,'PCM main'),(@gen,NULL,'engine_bay','F04',40,'Cooling fan'),
  (@gen,NULL,'engine_bay','F18',30,'Heated rear window'),(@gen,NULL,'engine_bay','F23',25,'Headlight'),
  (@gen,NULL,'cabin','M01',20,'Cigar lighter'),(@gen,NULL,'cabin','M05',15,'Audio amplifier'),
  (@gen,NULL,'cabin','M12',20,'Heated seats'),(@gen,NULL,'cabin','M15',25,'Power sliding doors'),
  (@gen,NULL,'cabin','M18',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','68303800AA','NGK (Mopar OE)',1.10,NULL,'ZFR6F-11G'),
  (@gen,NULL,'oil_filter','68191349AC','Mopar Genuine',NULL,NULL,'3.6L Pentastar cartridge'),
  (@gen,NULL,'air_filter','68235476AB','Mopar Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','68229402AA','Mopar Genuine',NULL,NULL,'Activated carbon'),
  (@gen,NULL,'wiper_front_d','68197174AA','Mopar Genuine',NULL,'28 in','Driver'),
  (@gen,NULL,'wiper_front_p','68197175AA','Mopar Genuine',NULL,'20 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,4000,16000,6400,12,'Mopar OCIS.'),(@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),(@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,'948TE.'),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),(@gen,NULL,'spark_plugs',100000,60000,160000,96000,NULL,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',36,250,'235/65 R17 (Touring / Touring L)'),(@gen,NULL,'rear','normal',36,250,'235/65 R17 (Touring / Touring L)'),
  (@gen,NULL,'front','normal',36,250,'235/60 R18 (Limited)'),(@gen,NULL,'rear','normal',36,250,'235/60 R18 (Limited)'),
  (@gen,NULL,'spare','normal',60,420,'T165/80 D17');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-change-indicator-reset','Oil Change Indicator reset — Pacifica (RU)','Mopar OCIS canonical: Uconnect → Controls → Vehicle Maintenance → Oil Change Indicator → Reset. OR accelerator pedal method.\n','• None.','• Pedal pressed too fast.'),
(@gen,'tpms_relearn','tpms-auto','TPMS auto-relearn — Pacifica (RU)','Auto-relearn after a 20-min drive above 15 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Pacifica (RU)','Negative-first, positive-last. PHEV trim: 12V in engine bay; HV battery sealed.\n','• 10 mm wrench.','• Touching HV connectors on PHEV.'),
(@gen,'jump_start','jump-start','Jump-start — Pacifica (RU)','Standard 4-clamp procedure. PHEV: same; HV system does not assist.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Ford Maverick P758 — gen 87
SET @gen := 87;
INSERT INTO sources (type, citation, retrieved_at, is_public) SELECT 'oem_manual','Ford Maverick (P758) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Ford Maverick (P758) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation='Ford Maverick (P758) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/ford/maverick-pickup-2022-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:2022_Ford_Maverick_Lariat_FWD_Ecoboost.jpg',CURDATE(),'2022 Ford Maverick Lariat (P758)','3-4-front',1280,853;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',5.50,5.80,'5W-30','API SP / Ford WSS-M2C961-A1','FL-500S',10000,16000,12,'2.0L EcoBoost · 5.5 qt. 2.5L FHEV Atkinson: 4.5 qt 0W-20.'),
  (@gen,NULL,'transmission_at',7.40,7.82,NULL,'Mercon LV ATF',NULL,60000,96000,NULL,'8-speed 8F35 (2.0T) or eCVT (FHEV).'),
  (@gen,NULL,'coolant',7.50,7.93,NULL,'Motorcraft Yellow (WSS-M97B44-D2)',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Motorcraft DOT 3',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'rear_differential',0.85,0.90,NULL,'Motorcraft 75W-85 GL-5',NULL,60000,96000,NULL,'AWD trims.'),
  (@gen,NULL,'ac_refrigerant',0.50,0.53,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'500 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',176,130,'M12×1.5.'),(@gen,NULL,'spark_plug',15,11,'2.0L EcoBoost CYFS-12Y-2.'),
  (@gen,NULL,'oil_drain',27,20,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',27,20,'Front.'),
  (@gen,NULL,'caliper_bracket',150,111,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'24F (LN1)',600,55,150);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'cargo_lamp','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','1',40,'PCM main'),(@gen,NULL,'engine_bay','4',30,'Cooling fan'),
  (@gen,NULL,'engine_bay','18',25,'Headlight'),(@gen,NULL,'engine_bay','23',20,'Fuel pump'),
  (@gen,NULL,'cabin','1',20,'Front 12V'),(@gen,NULL,'cabin','5',15,'Audio'),
  (@gen,NULL,'cabin','8',20,'Heated seats'),(@gen,NULL,'cabin','20',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','CYFS-12Y-2','Motorcraft (Ford OE)',1.30,NULL,'2.0L EcoBoost'),
  (@gen,NULL,'oil_filter','FL-500S','Motorcraft (Ford OE)',NULL,NULL,'Spin-on'),
  (@gen,NULL,'air_filter','PB3Z-9601-A','Motorcraft (Ford OE)',NULL,NULL,'Maverick air filter'),
  (@gen,NULL,'cabin_filter','FP-87','Motorcraft (Ford OE)',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','PB3Z-17528-A','Ford Genuine',NULL,'22 in','Driver'),
  (@gen,NULL,'wiper_front_p','PB3Z-17528-B','Ford Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,'Ford IOLM.'),(@gen,NULL,'tire_rotation',7500,7500,12000,12000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',150000,75000,240000,120000,NULL,'8F35.'),(@gen,NULL,'rear_diff_oil',60000,30000,96000,48000,NULL,'AWD only.'),
  (@gen,NULL,'spark_plugs',100000,60000,160000,96000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',36,250,'225/65 R17 (XL / XLT)'),(@gen,NULL,'rear','normal',36,250,'225/65 R17 (XL / XLT)'),
  (@gen,NULL,'front','normal',35,240,'235/55 R18 (Lariat)'),(@gen,NULL,'rear','normal',35,240,'235/55 R18 (Lariat)'),
  (@gen,NULL,'spare','normal',60,420,'T155/80 D18 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-life-reset','Oil-Life Monitor reset — Maverick','Ford IOLM: SYNC 4 → Settings → Vehicle → Oil Life → Reset to 100%.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-relearn','TPMS relearn — Maverick','Ford pedal-headlight sequence (same as F-150). Then magnet over each valve LF→RF→RR→LR.\n','• Magnet/activator.','• Sequence times out.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Maverick','Negative-first, positive-last. FORScan required for BMS registration.\n','• 10 mm wrench.','• Positive first; skipping BMS registration.'),
(@gen,'jump_start','jump-start','Jump-start — Maverick','Standard 4-clamp procedure. Hybrid: same procedure, donor 500+ CCA enough.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Acura TLX II — gen 88
SET @gen := 88;
INSERT INTO sources (type, citation, retrieved_at, is_public) SELECT 'oem_manual','Acura TLX II Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Acura TLX II Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation='Acura TLX II Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/acura/tlx-ii-sedan-2021-2024/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Acura_TLX_Type-S_WGI22.jpg',CURDATE(),'Acura TLX II Type-S','3-4-front',1280,720;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',4.70,4.97,'0W-20','API SP / ILSAC GF-6A','15400-PLM-A02',7500,12000,12,'2.0T K20C4 · 4.97 qt. Type-S 3.0T V6 (J30AC): 5.7 qt 0W-20.'),
  (@gen,NULL,'transmission_at',8.40,8.88,NULL,'Honda DW-1 ATF',NULL,60000,96000,NULL,'10-speed 10AT.'),
  (@gen,NULL,'transfer_case',0.50,0.53,NULL,'Honda DPSF II',NULL,60000,96000,NULL,'SH-AWD coupling (Type-S / SH-AWD trims).'),
  (@gen,NULL,'rear_differential',1.20,1.27,NULL,'Honda VTM-4 DF',NULL,30000,48000,NULL,'SH-AWD rear.'),
  (@gen,NULL,'coolant',7.50,7.93,NULL,'Honda Type 2 LLC',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Honda DOT 3',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'550 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',108,80,'M12×1.5.'),(@gen,NULL,'spark_plug',18,13,'NGK DILZKAR8H8S (K20C4) / ILZKBR8H8S (J30AC).'),
  (@gen,NULL,'oil_drain',40,30,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',36,27,'Front.'),
  (@gen,NULL,'caliper_bracket',109,80,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'46B24L',410,45,130);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Jewel Eye',2,1),(@gen,NULL,'headlight_high','LED Jewel Eye',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','1',40,'ABS'),(@gen,NULL,'engine_bay','3',50,'EPS'),
  (@gen,NULL,'engine_bay','5',50,'IG1'),(@gen,NULL,'engine_bay','11',20,'L headlight'),
  (@gen,NULL,'engine_bay','12',20,'R headlight'),(@gen,NULL,'engine_bay','14',30,'SH-AWD coupling'),
  (@gen,NULL,'cabin','1',20,'12V outlet'),(@gen,NULL,'cabin','5',30,'Wiper'),
  (@gen,NULL,'cabin','8',20,'Heated seats'),(@gen,NULL,'cabin','20',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','12290-RPY-G01','NGK (Acura OE)',0.80,NULL,'DILZKAR8H8S · K20C4'),
  (@gen,NULL,'oil_filter','15400-PLM-A02','Acura Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','17220-6S8-A00','Acura Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','80292-TYA-A01','Acura Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','76622-TYA-A02','Acura Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','76632-TYA-A02','Acura Genuine',NULL,'19 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,'Acura MM.'),(@gen,NULL,'tire_rotation',7500,3750,12000,6000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,'10AT.'),(@gen,NULL,'rear_diff_oil',30000,15000,48000,24000,NULL,'SH-AWD.'),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL),(@gen,NULL,'spark_plugs',105000,60000,168000,96000,NULL,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'225/55 R18 (Base)'),(@gen,NULL,'rear','normal',33,230,'225/55 R18 (Base)'),
  (@gen,NULL,'front','normal',33,230,'255/40 R19 (A-Spec / Advance)'),(@gen,NULL,'rear','normal',33,230,'255/40 R19 (A-Spec / Advance)'),
  (@gen,NULL,'front','normal',32,220,'255/35 R20 (Type S)'),(@gen,NULL,'rear','normal',32,220,'255/35 R20 (Type S)'),
  (@gen,NULL,'spare','normal',60,420,'T125/70 D17');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'maintenance_minder_reset','maintenance-minder-reset','Maintenance Minder reset — TLX II','Acura DIC pattern: Settings → Vehicle → Maintenance Info → select item → Reset.\n','• None.','• Resetting All.'),
(@gen,'tpms_relearn','tpms-calibration','TPMS calibration — TLX II','Indirect TPMS. Settings → Vehicle → TPMS Calibration → Calibrate. Drive 30 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — TLX II','Negative-first, positive-last.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — TLX II','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Genesis G70 IK — gen 89
SET @gen := 89;
INSERT INTO sources (type, citation, retrieved_at, is_public) SELECT 'oem_manual','Genesis G70 (IK) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Genesis G70 (IK) Owner''s Manual');
SET @src := (SELECT id FROM sources WHERE citation='Genesis G70 (IK) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images (generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/genesis/g70-ik-sedan-2018-2020/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Genesis_G70_Facelift_1X7A6392.jpg',CURDATE(),'Genesis G70 (IK)','3-4-front',1280,853;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',6.40,6.76,'5W-30','API SP','26300-3CAA0',7500,12000,12,'2.0T G2.0 · 5.5 qt. 3.3T G3.3 V6: 6.76 qt. 2.2 CRDi diesel: 6.5 qt 5W-30 ACEA C2.'),
  (@gen,NULL,'transmission_at',7.50,7.93,NULL,'Hyundai SP-IV ATF',NULL,60000,96000,NULL,'8AT (gas) / 6AT (diesel base) / 8DCT (some markets).'),
  (@gen,NULL,'transfer_case',0.50,0.53,NULL,'Hyundai AWD coupling',NULL,75000,120000,NULL,'AWD only.'),
  (@gen,NULL,'rear_differential',0.95,1.00,NULL,'Hyundai 75W-90 GL-5',NULL,75000,120000,NULL,'RWD/AWD rear.'),
  (@gen,NULL,'coolant',8.10,8.55,NULL,'Hyundai LLC (blue)',NULL,120000,192000,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','Hyundai DOT 4',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'550 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',107,79,'M12×1.5.'),(@gen,NULL,'spark_plug',25,18,'NGK ILZFR6D-11.'),
  (@gen,NULL,'oil_drain',35,26,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',22,16,'Front.'),
  (@gen,NULL,'caliper_bracket',95,70,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'24F (LN2) AGM',680,72,150);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (Sport)',2,1),(@gen,NULL,'headlight_high','LED / HB3',2,0),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','PY21W',2,0),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','PY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',100,'Battery main'),(@gen,NULL,'engine_bay','ABS',40,'ABS pump'),
  (@gen,NULL,'engine_bay','PWR',50,'MDPS'),(@gen,NULL,'engine_bay','COOL',40,'Cooling fan'),
  (@gen,NULL,'engine_bay','HEAD',25,'Headlight'),(@gen,NULL,'cabin','IGN',30,'Ignition'),
  (@gen,NULL,'cabin','AUDIO',15,'Audio'),(@gen,NULL,'cabin','WIPER',30,'Wiper'),
  (@gen,NULL,'cabin','SEAT',20,'Heated seats'),(@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','18840-11051','NGK (Genesis OE)',1.10,NULL,'ILZFR6D-11 · 3.3 T-GDi V6'),
  (@gen,NULL,'oil_filter','26300-3CAA0','Genesis Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','28113-G9000','Genesis Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','97133-G9000','Genesis Genuine',NULL,NULL,'Activated carbon HEPA'),
  (@gen,NULL,'wiper_front_d','98350-G9000','Genesis Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','98360-G9000','Genesis Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,NULL),(@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),(@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'rear_diff_oil',75000,37500,120000,60000,NULL,NULL),(@gen,NULL,'spark_plugs',97500,60000,156000,96000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'225/45 R18 (Advanced)'),(@gen,NULL,'rear','normal',33,230,'255/40 R18 (Advanced rear)'),
  (@gen,NULL,'front','normal',33,230,'225/40 R19 (Sport)'),(@gen,NULL,'rear','normal',33,230,'255/35 R19 (Sport rear)'),
  (@gen,NULL,'spare','normal',60,420,'T135/80 D17');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-interval-reset','Service interval reset — G70 (IK)','Hyundai Group canonical: cluster → User Settings → Service Interval → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-auto','TPMS auto-relearn — G70 (IK)','Auto-relearn after 10-min drive above 15 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — G70 (IK)','Negative-first, positive-last. Genesis BMS registration via GDS scan tool after replacement.\n','• 10 mm wrench, GDS or Foxwell scan tool.','• Skipping BMS registration.'),
(@gen,'jump_start','jump-start','Jump-start — G70 (IK)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

SELECT 'Batch 10 done' AS status, (SELECT COUNT(*) FROM generations WHERE is_active=1) AS gens, (SELECT COUNT(*) FROM procedures) AS procs;
