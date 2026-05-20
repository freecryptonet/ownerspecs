-- Batch 12: 4 more nameplates — BRZ ZD8, MX-5 ND, HR-V RV3, XC90 II

SET NAMES utf8mb4;

-- Models
INSERT IGNORE INTO models(make_id,slug,name) VALUES
  (14,'brz','BRZ'),
  (6,'mx-5','MX-5'),
  (1,'hr-v','HR-V'),
  (17,'xc90','XC90');

-- Generations
INSERT INTO generations(model_id,slug,codename,display_name,body_type,start_year,end_year,platform,is_active) VALUES
  ((SELECT id FROM models WHERE slug='brz' AND make_id=14),'brz-zd8-coupe-2022-present','ZD8','BRZ II (ZD8)','coupe',2022,NULL,'Subaru Global Platform',1),
  ((SELECT id FROM models WHERE slug='mx-5' AND make_id=6),'mx-5-nd-roadster-2015-present','ND','MX-5 IV (ND)','roadster',2015,NULL,'Mazda Skyactiv',1),
  ((SELECT id FROM models WHERE slug='hr-v' AND make_id=1),'hr-v-rv3-suv-2023-present','RV3','HR-V III (RV3)','suv',2023,NULL,'Honda Global Compact',1),
  ((SELECT id FROM models WHERE slug='xc90' AND make_id=17),'xc90-ii-suv-2015-present','II','XC90 II','suv',2015,NULL,'Volvo SPA',1);

-- BRZ ZD8
SET @gen := (SELECT id FROM generations WHERE slug='brz-zd8-coupe-2022-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Subaru BRZ (ZD8) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/subaru/brz-zd8-coupe-2022-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:2022_Subaru_BRZ.jpg',CURDATE(),'Subaru BRZ (ZD8)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',5.40,5.70,'0W-20','API SP / ILSAC GF-6A','15208AA170',6000,9600,6,'2.4L FA24D NA flat-4.'),
  (@gen,NULL,'transmission_mt',2.40,2.54,NULL,'Subaru Extra MT-5 75W-90 GL-5',NULL,30000,48000,NULL,'6MT.'),
  (@gen,NULL,'transmission_at',7.50,7.93,NULL,'Subaru ATF HP',NULL,60000,96000,NULL,'6AT (Aisin).'),
  (@gen,NULL,'rear_differential',1.00,1.06,NULL,'Subaru 75W-90 GL-5',NULL,30000,48000,NULL,'Torsen LSD.'),
  (@gen,NULL,'coolant',6.20,6.55,NULL,'Subaru Super Coolant (blue)',NULL,137500,220000,132,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Subaru DOT 3',NULL,NULL,NULL,30,NULL),
  (@gen,NULL,'ac_refrigerant',0.45,0.48,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'450 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',120,89,'M12×1.25.'),(@gen,NULL,'spark_plug',22,16,'NGK SILZKAR8U10S.'),
  (@gen,NULL,'oil_drain',44,32,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',100,74,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H5 (LN2)',600,60,150);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'drl','LED',2,1),(@gen,NULL,'turn_front','LED',2,1),
  (@gen,NULL,'brake_tail','LED',2,1),(@gen,NULL,'reverse','921 (W16W)',2,0),
  (@gen,NULL,'turn_rear','LED',2,1),(@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','No.3',20,'Headlight'),(@gen,NULL,'engine_bay','No.12',30,'ABS pump'),
  (@gen,NULL,'engine_bay','No.18',30,'Wiper'),(@gen,NULL,'engine_bay','No.22',50,'EPS'),
  (@gen,NULL,'cabin','No.1',20,'Audio'),(@gen,NULL,'cabin','No.6',20,'12V outlet'),
  (@gen,NULL,'cabin','No.22',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','22401AA950','NGK (Subaru OE)',0.80,NULL,'SILZKAR8U10S · FA24D'),
  (@gen,NULL,'oil_filter','15208AA170','Subaru Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','16546AA180','Subaru Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','72880CC000','Subaru Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','86532CC050','Subaru Genuine',NULL,'22 in','Driver'),
  (@gen,NULL,'wiper_front_p','86542CC050','Subaru Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',6000,3000,9600,4800,6,'Subaru FA24D severe duty: 3k mi.'),(@gen,NULL,'tire_rotation',6000,6000,9600,9600,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_mt_fluid',30000,15000,48000,24000,NULL,'6MT.'),(@gen,NULL,'rear_diff_oil',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'spark_plugs',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,30,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',32,220,'215/40 R18 (Premium)'),(@gen,NULL,'rear','normal',32,220,'215/40 R18 (Premium)'),
  (@gen,NULL,'spare','normal',60,420,'T125/70 D17 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reminder-reset','Service reminder reset — BRZ (ZD8)','Subaru ‘i’ stalk → Maintenance → Engine Oil → hold OK.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-set','TPMS set — BRZ (ZD8)','Direct TPMS. Settings → TPMS → Set. Drive 15 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — BRZ (ZD8)','Negative-first, positive-last. After: lock-to-lock for EPS.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — BRZ (ZD8)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- MX-5 ND
SET @gen := (SELECT id FROM generations WHERE slug='mx-5-nd-roadster-2015-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Mazda MX-5 (ND) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/mazda/mx-5-nd-roadster-2015-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Mazda_MX-5_ND.jpg',CURDATE(),'Mazda MX-5 (ND)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',4.20,4.43,'0W-20','API SP','PE01-14-302A',7500,12000,12,'2.0L PE-VPS Skyactiv-G.'),
  (@gen,NULL,'transmission_mt',2.10,2.22,NULL,'Mazda 75W-90 MTF',NULL,NULL,NULL,NULL,'6MT.'),
  (@gen,NULL,'transmission_at',7.50,7.93,NULL,'Mazda ATF FZ',NULL,60000,96000,NULL,'6AT.'),
  (@gen,NULL,'rear_differential',0.70,0.74,NULL,'Mazda 75W-90 GL-5',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'coolant',5.50,5.81,NULL,'Mazda FL22 (green)',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Mazda DOT 3',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.40,0.42,NULL,'R-134a (pre-2019) / R-1234yf · PAG46',NULL,NULL,NULL,NULL,'400 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',108,80,'M12×1.5.'),(@gen,NULL,'spark_plug',20,15,'NGK ILTR5A-13G.'),
  (@gen,NULL,'oil_drain',30,22,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',64,47,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'46B24L (S46B24L)',432,45,80);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','H8 (RF only)',2,0),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','20',30,'ABS pump'),(@gen,NULL,'engine_bay','26',40,'EPS'),
  (@gen,NULL,'engine_bay','32',30,'Blower'),(@gen,NULL,'engine_bay','41',15,'ECU'),
  (@gen,NULL,'engine_bay','48',25,'Headlight'),(@gen,NULL,'cabin','1',10,'Audio'),
  (@gen,NULL,'cabin','4',20,'Driver window'),(@gen,NULL,'cabin','12',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','PE5R-18-110','NGK (Mazda OE)',0.80,NULL,'ILTR5A-13G'),
  (@gen,NULL,'oil_filter','PE01-14-302A','Mazda Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','PE07-13-3A0','Mazda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','KD45-61-J6X','Mazda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','N243-67-330','Mazda Genuine',NULL,'17 in','Driver'),
  (@gen,NULL,'wiper_front_p','N243-67-340','Mazda Genuine',NULL,'15 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,5000,12000,8000,12,NULL),(@gen,NULL,'tire_rotation',7500,5000,12000,8000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'rear_diff_oil',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'spark_plugs',75000,40000,120000,64000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',29,200,'195/50 R16 (Sport)'),(@gen,NULL,'rear','normal',29,200,'195/50 R16 (Sport)'),
  (@gen,NULL,'front','normal',29,200,'205/45 R17 (Club / GT)'),(@gen,NULL,'rear','normal',29,200,'205/45 R17 (Club / GT)'),
  (@gen,NULL,'spare','normal',60,420,'No spare — tire repair kit');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-data-reset','Engine Oil Data reset — MX-5 (ND)','Ignition ON · INFO long-press on Engine Oil Data screen → Yes.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-set','TPMS set — MX-5 (ND)','Direct TPMS. Settings → TPMS → Set new pressure. Drive 10 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — MX-5 (ND)','Negative-first, positive-last. i-Activsense settings may revert.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — MX-5 (ND)','Battery in trunk. Standard 4-clamp procedure to under-hood posts.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- HR-V RV3
SET @gen := (SELECT id FROM generations WHERE slug='hr-v-rv3-suv-2023-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Honda HR-V (RV3) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/honda/hr-v-rv3-suv-2023-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Honda_HR-V_(RV3).jpg',CURDATE(),'Honda HR-V III (RV3)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',3.70,3.91,'0W-20','API SP','15400-PLM-A02',7500,12000,12,'2.0L K20C2 NA.'),
  (@gen,NULL,'transmission_cvt',5.40,5.70,NULL,'Honda CVT Fluid',NULL,60000,96000,NULL,'Lineartronic CVT.'),
  (@gen,NULL,'rear_differential',0.45,0.48,NULL,'Honda DPSF',NULL,30000,48000,NULL,'AWD only.'),
  (@gen,NULL,'coolant',5.20,5.50,NULL,'Honda Type 2 (blue)',NULL,120000,192000,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Honda DOT 3',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'ac_refrigerant',0.45,0.48,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'450 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',108,80,'M12×1.5.'),(@gen,NULL,'spark_plug',23,17,'NGK ILZKAR7B11.'),
  (@gen,NULL,'oil_drain',39,29,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',108,80,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'51R',410,40,130);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'drl','LED',2,1),(@gen,NULL,'turn_front','LED',2,1),
  (@gen,NULL,'brake_tail','LED',2,1),(@gen,NULL,'reverse','921 (W16W)',2,0),
  (@gen,NULL,'turn_rear','LED',2,1),(@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','01',100,'Battery main'),(@gen,NULL,'engine_bay','17',40,'EPS'),
  (@gen,NULL,'engine_bay','22',30,'ABS'),(@gen,NULL,'engine_bay','27',30,'Blower'),
  (@gen,NULL,'engine_bay','38',15,'Headlight low'),(@gen,NULL,'cabin','03',10,'Audio'),
  (@gen,NULL,'cabin','12',20,'Heated seats'),(@gen,NULL,'cabin','19',20,'Tailgate'),
  (@gen,NULL,'cabin','27',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','12290-6C1-A01','NGK (Honda OE)',1.10,NULL,'ILZKAR7B11'),
  (@gen,NULL,'oil_filter','15400-PLM-A02','Honda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','17220-64L-A00','Honda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','80292-3M0-F01','Honda Genuine',NULL,NULL,'HEPA'),
  (@gen,NULL,'wiper_front_d','76622-3M0-A01','Honda Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','76632-3M0-A01','Honda Genuine',NULL,'17 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,'Honda Maintenance Minder (15% oil life).'),(@gen,NULL,'tire_rotation',7500,7500,12000,12000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_cvt_fluid',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'spark_plugs',105000,60000,168000,96000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'215/60 R17 (LX/Sport)'),(@gen,NULL,'rear','normal',33,230,'215/60 R17 (LX/Sport)'),
  (@gen,NULL,'front','normal',33,230,'225/55 R18 (EX-L)'),(@gen,NULL,'rear','normal',33,230,'225/55 R18 (EX-L)'),
  (@gen,NULL,'spare','normal',60,420,'T125/80 D16 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','maintenance-reset','Maintenance Minder reset — HR-V (RV3)','Ignition ON · MENU → Vehicle Settings → Reset Maintenance Info → hold ENTER.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-calibration','TPMS calibration — HR-V (RV3)','Indirect TPMS. Settings → TPMS → Calibrate. Drive 30+ min above 30 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — HR-V (RV3)','Negative-first, positive-last. Power-window auto-up needs re-init.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — HR-V (RV3)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- XC90 II
SET @gen := (SELECT id FROM generations WHERE slug='xc90-ii-suv-2015-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Volvo XC90 II Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/volvo/xc90-ii-suv-2015-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Volvo_XC90_II.jpg',CURDATE(),'Volvo XC90 II','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',5.90,6.23,'0W-20','API SN / ACEA C5','31330050',10000,16000,12,'2.0L Drive-E T6 supercharged+turbo. T8 PHEV: same.'),
  (@gen,NULL,'transmission_at',7.00,7.40,NULL,'Volvo ATF AW-1',NULL,80000,128000,NULL,'Aisin 8AT (TG-81SC).'),
  (@gen,NULL,'transfer_case',0.55,0.58,NULL,'Volvo Haldex fluid',NULL,40000,64000,NULL,'Haldex AWD coupling.'),
  (@gen,NULL,'rear_differential',0.95,1.00,NULL,'Volvo 75W-90 GL-5',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'coolant',12.0,12.7,NULL,'Volvo Coolant blue',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','Volvo DOT 4',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.70,0.74,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'700 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',140,103,'M14×1.5.'),(@gen,NULL,'spark_plug',25,18,'Denso ILTR5T-13.'),
  (@gen,NULL,'oil_drain',35,26,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',30,22,'Front.'),
  (@gen,NULL,'caliper_bracket',175,129,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H8 AGM',850,95,180);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (Thor)',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','LED',2,1),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',300,'Battery main'),(@gen,NULL,'engine_bay','MEGA',60,'Cooling'),
  (@gen,NULL,'engine_bay','17',30,'Headlight'),(@gen,NULL,'cabin','03',30,'Driver door'),
  (@gen,NULL,'cabin','15',20,'Sensus'),(@gen,NULL,'cabin','22',20,'Tailgate'),
  (@gen,NULL,'cabin','30',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','31405099','Denso (Volvo OE)',0.80,NULL,'ILTR5T-13'),
  (@gen,NULL,'oil_filter','31330050','Volvo Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','31370089','Volvo Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','31407811','Volvo Genuine',NULL,NULL,'HEPA'),
  (@gen,NULL,'wiper_front_d','31693865','Volvo Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','31693864','Volvo Genuine',NULL,'20 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,7500,16000,12000,12,'Volvo Service interval.'),(@gen,NULL,'tire_rotation',10000,7500,16000,12000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',80000,40000,128000,64000,NULL,NULL),(@gen,NULL,'haldex_fluid',40000,20000,64000,32000,NULL,'AWD.'),
  (@gen,NULL,'spark_plugs',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'235/60 R19 (Momentum)'),(@gen,NULL,'rear','normal',35,240,'235/60 R19 (Momentum)'),
  (@gen,NULL,'front','normal',38,260,'275/45 R21 (R-Design / Inscription)'),(@gen,NULL,'rear','normal',38,260,'275/45 R21 (R-Design / Inscription)'),
  (@gen,NULL,'spare','normal',60,420,'T155/80 D19 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reset','Service reset — XC90 II','Sensus → Settings → Vehicle → Service Information → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-calibration','TPMS calibration — XC90 II','Indirect TPMS. Settings → TPMS → Calibrate. Drive 30 min above 25 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — XC90 II','Battery in trunk well. Negative-first, positive-last. VIDA registration required.\n','• 10 mm wrench, VIDA.','• Skipping registration.'),
(@gen,'jump_start','jump-start','Jump-start — XC90 II','Use under-hood jump posts (right side). Never trunk battery direct.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

SELECT 'Batch 12 done' AS status, (SELECT COUNT(*) FROM generations WHERE is_active=1) AS gens, (SELECT COUNT(*) FROM procedures) AS procs;
