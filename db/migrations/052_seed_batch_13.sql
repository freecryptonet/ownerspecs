-- Batch 13: Cadillac Escalade (T1XX) + Toyota Prius XW60 + Lexus IS XE30

SET NAMES utf8mb4;

-- Cadillac make + Escalade model
INSERT IGNORE INTO makes(slug,name) VALUES ('cadillac','Cadillac');
SET @cad_id := (SELECT id FROM makes WHERE slug='cadillac');
INSERT IGNORE INTO models(make_id,slug,name) VALUES (@cad_id,'escalade','Escalade');

-- New models for Lexus + Toyota
INSERT IGNORE INTO models(make_id,slug,name) VALUES
  (19,'is','IS'),
  (2,'prius','Prius');

-- Generations
INSERT INTO generations(model_id,slug,codename,display_name,body_type,start_year,end_year,platform,is_active) VALUES
  ((SELECT id FROM models WHERE slug='escalade' AND make_id=@cad_id),'escalade-gmt-t1xx-suv-2021-2024','T1XX','Escalade V (T1XX)','suv',2021,2024,'GM T1XX',1),
  ((SELECT id FROM models WHERE slug='prius' AND make_id=2),'prius-xw60-liftback-2023-present','XW60','Prius V (XW60)','liftback',2023,NULL,'TNGA-C',1),
  ((SELECT id FROM models WHERE slug='is' AND make_id=19),'is-xe30-sedan-2014-2020','XE30','IS III (XE30)','sedan',2014,2020,'Lexus N',1);

-- Cadillac Escalade T1XX
SET @gen := (SELECT id FROM generations WHERE slug='escalade-gmt-t1xx-suv-2021-2024');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Cadillac Escalade V (T1XX) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/cadillac/escalade-gmt-t1xx-suv-2021-2024/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:23_Cadillac_Escalade-V.jpg',CURDATE(),'Cadillac Escalade V (T1XX)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',7.60,8.00,'0W-20','dexos1 Gen3','PF63E',7500,12000,12,'6.2L L87 V8 (Base/Premium/Sport). Diesel 3.0L LM2: 7.6 qt 5W-30 dexos2.'),
  (@gen,NULL,'transmission_at',11.5,12.16,NULL,'GM Dexron HP / Mobil 1 ATF',NULL,45000,72000,NULL,'10L80/10L90 10AT.'),
  (@gen,NULL,'transfer_case',2.00,2.11,NULL,'GM Auto-Trak II',NULL,45000,72000,NULL,'4WD models.'),
  (@gen,NULL,'rear_differential',1.95,2.06,NULL,'GM 75W-90 GL-5',NULL,45000,72000,NULL,'Electronic LSD.'),
  (@gen,NULL,'coolant',16.0,16.9,NULL,'Dex-Cool (orange)',NULL,150000,240000,60,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','GM DOT 3',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.75,0.79,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'750 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',190,140,'M14×1.5.'),(@gen,NULL,'spark_plug',24,18,'AC Delco 41-114.'),
  (@gen,NULL,'oil_drain',25,18,'M12×1.5.'),(@gen,NULL,'caliper_slide_pin',30,22,'Front.'),
  (@gen,NULL,'caliper_bracket',150,111,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H8 (94R) AGM',800,80,220);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Matrix',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',300,'Battery main'),(@gen,NULL,'engine_bay','F1',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F12',40,'Headlight'),(@gen,NULL,'cabin','01',30,'Blower'),
  (@gen,NULL,'cabin','12',20,'12V outlet'),(@gen,NULL,'cabin','27',20,'Tailgate'),
  (@gen,NULL,'cabin','38',20,'Heated seats'),(@gen,NULL,'cabin','42',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','12681659','ACDelco (GM OE)',1.00,NULL,'41-114 platinum'),
  (@gen,NULL,'oil_filter','PF63E','GM Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','85119535','GM Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','13503676','GM Genuine',NULL,NULL,'HEPA'),
  (@gen,NULL,'wiper_front_d','84352213','GM Genuine',NULL,'22 in','Driver'),
  (@gen,NULL,'wiper_front_p','84352214','GM Genuine',NULL,'22 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,'Oil Life Monitor.'),(@gen,NULL,'tire_rotation',7500,7500,12000,12000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',45000,22500,72000,36000,NULL,NULL),(@gen,NULL,'cabin_air_filter',22500,11250,36000,18000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',45000,22500,72000,36000,NULL,'10AT.'),(@gen,NULL,'rear_diff_oil',45000,22500,72000,36000,NULL,NULL),
  (@gen,NULL,'spark_plugs',97500,60000,156000,96000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'275/60 R20 (Luxury)'),(@gen,NULL,'rear','normal',35,240,'275/60 R20 (Luxury)'),
  (@gen,NULL,'front','normal',35,240,'285/45 R22 (Premium / Sport)'),(@gen,NULL,'rear','normal',35,240,'285/45 R22 (Premium / Sport)'),
  (@gen,NULL,'spare','normal',60,420,'T235/85 D17');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-life-reset','Oil Life reset — Escalade (T1XX)','DIC → Vehicle Information → Remaining Oil Life → hold SET/CLR.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-relearn','TPMS sensor relearn — Escalade (T1XX)','GM canonical: door lock hold → horn → cycle L-front → R-front → R-rear → L-rear (deflate each).\n','• TPMS tool / magnet.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Escalade (T1XX)','Negative-first, positive-last. BMS reset with GDS2 / SPS2.\n','• 10 mm wrench, GDS2.','• Skipping BMS reset.'),
(@gen,'jump_start','jump-start','Jump-start — Escalade (T1XX)','Use under-hood jump posts; battery accessible at rear cargo for replacement.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Toyota Prius XW60
SET @gen := (SELECT id FROM generations WHERE slug='prius-xw60-liftback-2023-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Toyota Prius V (XW60) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/toyota/prius-xw60-liftback-2023-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:2023_Toyota_Prius_Z_HEV.jpg',CURDATE(),'Toyota Prius V (XW60)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',3.90,4.12,'0W-16','API SP','04152-YZZA1',10000,16000,12,'2.0L M20A-FXS HEV; PHEV same.'),
  (@gen,NULL,'transmission_eCVT',3.60,3.80,NULL,'Toyota Genuine ATF WS',NULL,100000,160000,NULL,'eCVT (P810).'),
  (@gen,NULL,'coolant',6.20,6.55,NULL,'Toyota SLLC (pink)',NULL,100000,160000,NULL,NULL),
  (@gen,NULL,'inverter_coolant',5.50,5.81,NULL,'Toyota SLLC (pink)',NULL,150000,240000,NULL,'Inverter loop.'),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Toyota DOT 3',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'ac_refrigerant',0.40,0.42,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'400 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',103,76,'M12×1.5.'),(@gen,NULL,'spark_plug',22,16,'Denso FK20HBR11.'),
  (@gen,NULL,'oil_drain',40,30,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',28,21,'Front.'),
  (@gen,NULL,'caliper_bracket',107,79,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'LN1 AGM (auxiliary)',410,45,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','HV',125,'HV main'),(@gen,NULL,'engine_bay','12V',100,'12V battery main'),
  (@gen,NULL,'engine_bay','IGCT',30,'Ignition'),(@gen,NULL,'engine_bay','ECU-B',7.5,'ECU'),
  (@gen,NULL,'cabin','HTR',30,'Heater'),(@gen,NULL,'cabin','D/L',20,'Door lock'),
  (@gen,NULL,'cabin','P/W',20,'Power window'),(@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','90919-01298','Denso (Toyota OE)',1.10,NULL,'FK20HBR11'),
  (@gen,NULL,'oil_filter','04152-YZZA1','Toyota Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','17801-25020','Toyota Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','87139-30100','Toyota Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','85212-47120','Toyota Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','85222-47080','Toyota Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,'ToyotaCare 0W-16 + filter.'),(@gen,NULL,'tire_rotation',5000,5000,8000,8000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'transmission_eCVT_fluid',100000,60000,160000,96000,NULL,'eCVT.'),(@gen,NULL,'coolant_engine',100000,NULL,160000,NULL,NULL,NULL),
  (@gen,NULL,'spark_plugs',120000,60000,192000,96000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',36,250,'195/65 R17 (LE)'),(@gen,NULL,'rear','normal',33,230,'195/65 R17 (LE)'),
  (@gen,NULL,'front','normal',38,260,'195/50 R19 (XLE / Limited)'),(@gen,NULL,'rear','normal',36,250,'195/50 R19 (XLE / Limited)'),
  (@gen,NULL,'spare','normal',60,420,'Tire repair kit — no spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'maintenance_reminder_reset','maintenance-reset','Maintenance light reset — Prius (XW60)','Ready OFF · trip A displayed · Ready ON · hold trip until ‘000000’.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-reset','TPMS reset — Prius (XW60)','Direct TPMS. Hold TPMS button on dash 3 s until light blinks 3×. Drive 20 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','12v-battery-disconnect','12V battery disconnect — Prius (XW60)','12V auxiliary battery only. Never touch HV orange cables. Negative-first, positive-last.\n','• 10 mm wrench.','• Touching HV system.'),
(@gen,'jump_start','jump-start','Jump-start — Prius (XW60)','Under-hood jump posts (driver-side cover). Standard 4-clamp. Never jump from HV battery.\n','• Jumper cables.','• Touching HV cables.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Lexus IS XE30
SET @gen := (SELECT id FROM generations WHERE slug='is-xe30-sedan-2014-2020');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Lexus IS III (XE30) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/lexus/is-xe30-sedan-2014-2020/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:LEXUS_IS_F_SPORT_(XE30).jpg',CURDATE(),'Lexus IS III (XE30) F Sport','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',6.10,6.45,'0W-20','API SP','04152-YZZA6',10000,16000,12,'2.0L 8AR-FTS turbo (IS 200t/300). 3.5L 2GR-FKS V6 (IS 350): 6.4 qt 5W-30.'),
  (@gen,NULL,'transmission_at',7.40,7.82,NULL,'Toyota Genuine ATF WS',NULL,60000,96000,NULL,'8AT (UA80). 350 RWD: AB60E 6AT.'),
  (@gen,NULL,'rear_differential',1.20,1.27,NULL,'Toyota 75W-85 GL-5',NULL,60000,96000,NULL,NULL),
  (@gen,NULL,'coolant',8.50,9.00,NULL,'Toyota SLLC (pink)',NULL,100000,160000,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Toyota DOT 3',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'ac_refrigerant',0.45,0.48,NULL,'R-134a (pre-2018) / R-1234yf · PAG46',NULL,NULL,NULL,NULL,'450 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',103,76,'M12×1.5.'),(@gen,NULL,'spark_plug',22,16,'Denso FK20HBR11.'),
  (@gen,NULL,'oil_drain',40,30,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',107,79,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H6 (LN3) AGM',760,80,150);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Tri-beam',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','7507 (PY21W)',2,0),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',140,'Battery main'),(@gen,NULL,'engine_bay','ALT',150,'Alternator'),
  (@gen,NULL,'engine_bay','HTR',50,'Heater'),(@gen,NULL,'engine_bay','HEAD',25,'Headlight'),
  (@gen,NULL,'cabin','IG2',30,'Ignition'),(@gen,NULL,'cabin','D/L',25,'Door lock'),
  (@gen,NULL,'cabin','P/W',30,'Power window'),(@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','90919-01253','Denso (Lexus OE)',1.10,NULL,'FK20HBR11'),
  (@gen,NULL,'oil_filter','04152-YZZA6','Lexus Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','17801-36020','Lexus Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','87139-30100','Lexus Genuine',NULL,NULL,'HEPA'),
  (@gen,NULL,'wiper_front_d','85212-53080','Lexus Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','85222-53080','Lexus Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,NULL),(@gen,NULL,'tire_rotation',5000,5000,8000,8000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'rear_diff_oil',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'spark_plugs',120000,60000,192000,96000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',32,220,'225/45 R17 (Base)'),(@gen,NULL,'rear','normal',32,220,'255/40 R17 (Base RWD)'),
  (@gen,NULL,'front','normal',32,220,'225/40 R18 (F Sport)'),(@gen,NULL,'rear','normal',32,220,'255/35 R18 (F Sport RWD)'),
  (@gen,NULL,'spare','normal',60,420,'T155/70 D17 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'maintenance_reminder_reset','maintenance-reset','Maintenance light reset — IS (XE30)','Ignition OFF · trip A displayed · ignition ON (no start) · hold trip until ‘000000’.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-reset','TPMS reset — IS (XE30)','Direct TPMS. Hold TPMS button until light blinks 3×. Drive 20 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — IS (XE30)','Negative-first, positive-last. Re-init power windows + sunroof after.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — IS (XE30)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

SELECT 'Batch 13 done' AS status, (SELECT COUNT(*) FROM generations WHERE is_active=1) AS gens, (SELECT COUNT(*) FROM procedures) AS procs;
