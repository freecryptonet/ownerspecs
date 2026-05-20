-- Batch 15: BMW i4 G26 + Kia EV6 + Lincoln Navigator U554 + Dodge Charger LD

SET NAMES utf8mb4;

INSERT IGNORE INTO makes(slug,name) VALUES ('lincoln','Lincoln'),('dodge','Dodge');

INSERT IGNORE INTO models(make_id,slug,name) VALUES
  ((SELECT id FROM makes WHERE slug='bmw'),'i4','i4'),
  ((SELECT id FROM makes WHERE slug='kia'),'ev6','EV6'),
  ((SELECT id FROM makes WHERE slug='lincoln'),'navigator','Navigator'),
  ((SELECT id FROM makes WHERE slug='dodge'),'charger','Charger');

INSERT INTO generations(model_id,slug,codename,display_name,body_type,start_year,end_year,platform,is_active) VALUES
  ((SELECT id FROM models WHERE slug='i4' AND make_id=(SELECT id FROM makes WHERE slug='bmw')),'i4-g26-sedan-2021-present','G26','i4 (G26)','sedan',2021,NULL,'BMW CLAR',1),
  ((SELECT id FROM models WHERE slug='ev6' AND make_id=(SELECT id FROM makes WHERE slug='kia')),'ev6-suv-2021-present',NULL,'EV6','suv',2021,NULL,'Hyundai E-GMP',1),
  ((SELECT id FROM models WHERE slug='navigator' AND make_id=(SELECT id FROM makes WHERE slug='lincoln')),'navigator-u554-suv-2018-present','U554','Navigator IV (U554)','suv',2018,NULL,'Ford T3',1),
  ((SELECT id FROM models WHERE slug='charger' AND make_id=(SELECT id FROM makes WHERE slug='dodge')),'charger-ld-sedan-2011-2023','LD','Charger VII (LD)','sedan',2011,2023,'LX',1);

-- BMW i4 G26 (BEV)
SET @gen := (SELECT id FROM generations WHERE slug='i4-g26-sedan-2021-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','BMW i4 (G26) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/bmw/i4-g26-sedan-2021-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:BMW_i4_(G26).jpg',CURDATE(),'BMW i4 (G26)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'reduction_gear',1.30,1.37,NULL,'BMW E-Drive Oil',NULL,NULL,NULL,NULL,'Front + rear drive unit; service per BMW CBS.'),
  (@gen,NULL,'coolant',16.5,17.4,NULL,'BMW HV-coolant blue',NULL,NULL,NULL,NULL,'HV battery + drive loop.'),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','BMW DOT 4 LV',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',1.20,1.27,NULL,'R-1234yf · PAG46 (heat pump)',NULL,NULL,NULL,NULL,'1.20 kg with heat pump.'),
  (@gen,NULL,'washer_fluid',5.20,5.50,NULL,'BMW washer fluid',NULL,NULL,NULL,NULL,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',140,103,'M14×1.25.'),(@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',110,81,'Front carrier (M Sport).');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'12V AGM auxiliary',NULL,80,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Laser',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'drl','LED',2,1),(@gen,NULL,'turn_front','LED',2,1),
  (@gen,NULL,'brake_tail','LED',2,1),(@gen,NULL,'reverse','LED',2,1),
  (@gen,NULL,'turn_rear','LED',2,1),(@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',250,'12V battery main'),(@gen,NULL,'engine_bay','F1',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F17',30,'Headlight'),(@gen,NULL,'cabin','F100',30,'Driver door'),
  (@gen,NULL,'cabin','F125',25,'iDrive'),(@gen,NULL,'cabin','F134',20,'Tailgate'),
  (@gen,NULL,'cabin','F154',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'cabin_filter','64119382886','BMW Genuine',NULL,NULL,'PM2.5'),
  (@gen,NULL,'wiper_front_d','61617381205','BMW Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','61617381206','BMW Genuine',NULL,'19 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,24,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'tire_rotation',6000,6000,9600,9600,NULL,NULL),
  (@gen,NULL,'reduction_gear_oil',NULL,NULL,NULL,NULL,NULL,'CBS reports condition; service when triggered.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',38,260,'225/55 R18 (eDrive40)'),(@gen,NULL,'rear','normal',41,280,'225/55 R18 (eDrive40)'),
  (@gen,NULL,'front','normal',38,260,'245/40 R19 (M50)'),(@gen,NULL,'rear','normal',44,300,'255/40 R19 (M50 rear)'),
  (@gen,NULL,'spare','normal',60,420,'Tire repair kit — no spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'cbs_reset','cbs-reset','CBS reset — i4 (G26)','iDrive → Vehicle status → Service requirements → select item → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','rdc-reset','RDC reset — i4 (G26)','iDrive → Settings → Tyre pressure monitor → Reset. Drive 10 min.\n','• None.','• Hot pressures.'),
(@gen,'battery_disconnect_order','12v-battery-disconnect','12V battery service — i4 (G26)','12V aux battery in trunk. Never touch orange HV cables. ISTA registration after replacement.\n','• 10 mm wrench, ISTA.','• Touching HV connectors.'),
(@gen,'jump_start','jump-start','Jump-start — i4 (G26)','Use under-hood jump terminals (positive cover + ground stud). Never to HV pack or 12V trunk negative direct.\n','• Jumper cables.','• Jumping from trunk negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Kia EV6 (BEV)
SET @gen := (SELECT id FROM generations WHERE slug='ev6-suv-2021-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Kia EV6 Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/kia/ev6-suv-2021-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Kia_EV6_GT.jpg',CURDATE(),'Kia EV6 GT','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'reduction_gear',0.95,1.00,NULL,'Hyundai-Kia EV transaxle oil',NULL,75000,120000,NULL,'Single-speed gear reducer; AWD adds front unit.'),
  (@gen,NULL,'coolant',15.0,15.9,NULL,'Hyundai LLC HV (blue)',NULL,150000,240000,NULL,'Battery + PE thermal loop.'),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','Hyundai-Kia DOT 4',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',1.05,1.11,NULL,'R-1234yf · PAG46 (heat pump)',NULL,NULL,NULL,NULL,'1.05 kg with heat pump.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',127,94,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',95,70,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'12V Li-ion (LFP)',NULL,12,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'drl','LED Pixel',2,1),(@gen,NULL,'turn_front','LED',2,1),
  (@gen,NULL,'brake_tail','LED',2,1),(@gen,NULL,'reverse','921 (W16W)',2,0),
  (@gen,NULL,'turn_rear','LED',2,1),(@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',250,'12V LV main'),(@gen,NULL,'engine_bay','HV',60,'HV junction'),
  (@gen,NULL,'engine_bay','HEAD',25,'Headlight'),(@gen,NULL,'cabin','IG',30,'Ignition'),
  (@gen,NULL,'cabin','HUD',10,'HUD'),(@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'cabin_filter','97133-CV000','Kia Genuine',NULL,NULL,'HEPA'),
  (@gen,NULL,'wiper_front_d','98350-CV000','Kia Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','98360-CV000','Kia Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,12,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'tire_rotation',7500,7500,12000,12000,NULL,NULL),
  (@gen,NULL,'reduction_gear_oil',75000,40000,120000,64000,NULL,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',36,250,'235/55 R19 (Wind)'),(@gen,NULL,'rear','normal',36,250,'235/55 R19 (Wind)'),
  (@gen,NULL,'front','normal',38,260,'255/45 R20 (GT-Line / GT)'),(@gen,NULL,'rear','normal',38,260,'255/45 R20 (GT-Line / GT)'),
  (@gen,NULL,'spare','normal',60,420,'Tire repair kit — no spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reset','Service reset — EV6','Cluster → User Settings → Service Interval → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-auto','TPMS auto-relearn — EV6','Direct TPMS auto-relearns after 10-min drive above 15 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','12v-battery-disconnect','12V battery disconnect — EV6','12V Li-ion (LFP) in front trunk. Never touch HV orange cables. Service Mode in head unit before disconnect recommended.\n','• 10 mm wrench, GDS.','• Touching HV connectors.'),
(@gen,'jump_start','jump-start','Jump-start — EV6','12V only: under front-trunk panel. Standard 4-clamp procedure. Never jump from HV.\n','• Jumper cables.','• Jumping HV.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Lincoln Navigator U554
SET @gen := (SELECT id FROM generations WHERE slug='navigator-u554-suv-2018-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Lincoln Navigator IV (U554) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/lincoln/navigator-u554-suv-2018-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Lincoln_Navigator_(U554).jpg',CURDATE(),'Lincoln Navigator IV (U554)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',5.70,6.02,'5W-30','API SP / WSS-M2C961-A1','FL-500S',7500,12000,12,'3.5L EcoBoost V6 twin-turbo.'),
  (@gen,NULL,'transmission_at',13.4,14.16,NULL,'Motorcraft Mercon ULV',NULL,150000,240000,NULL,'10R80 10AT.'),
  (@gen,NULL,'transfer_case',1.40,1.48,NULL,'Motorcraft XL-12 (TXF-2)',NULL,150000,240000,NULL,'4WD models.'),
  (@gen,NULL,'rear_differential',1.90,2.01,NULL,'Ford 75W-85 GL-5',NULL,150000,240000,NULL,NULL),
  (@gen,NULL,'coolant',13.5,14.3,NULL,'Motorcraft Orange',NULL,150000,240000,60,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','Motorcraft DOT 4',NULL,NULL,NULL,36,NULL),
  (@gen,NULL,'ac_refrigerant',0.85,0.90,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'850 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',204,150,'M14×1.5.'),(@gen,NULL,'spark_plug',20,15,'Motorcraft SP-580.'),
  (@gen,NULL,'oil_drain',38,28,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',30,22,'Front.'),
  (@gen,NULL,'caliper_bracket',184,136,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H8 AGM (94R)',850,95,200);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','F1',300,'Battery main'),(@gen,NULL,'engine_bay','F4',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F12',40,'Headlight'),(@gen,NULL,'cabin','01',30,'Blower'),
  (@gen,NULL,'cabin','12',20,'SYNC'),(@gen,NULL,'cabin','27',20,'Power liftgate'),
  (@gen,NULL,'cabin','38',20,'Heated seats'),(@gen,NULL,'cabin','42',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','BL3E-12405-AA','Motorcraft (Ford OE)',0.80,NULL,'SP-580 · Iridium'),
  (@gen,NULL,'oil_filter','FL-500S','Motorcraft',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','FA-1927','Motorcraft',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','FP-83','Motorcraft',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','JL3Z-17528-A','Motorcraft',NULL,'22 in','Driver'),
  (@gen,NULL,'wiper_front_p','JL3Z-17528-B','Motorcraft',NULL,'22 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,5000,12000,8000,12,'IOLM monitor.'),(@gen,NULL,'tire_rotation',10000,7500,16000,12000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',150000,60000,240000,96000,NULL,'10R80.'),(@gen,NULL,'rear_diff_oil',150000,60000,240000,96000,NULL,NULL),
  (@gen,NULL,'spark_plugs',100000,50000,160000,80000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,36,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'265/50 R22 (Standard)'),(@gen,NULL,'rear','normal',35,240,'265/50 R22 (Standard)'),
  (@gen,NULL,'front','normal',35,240,'285/45 R22 (Black Label)'),(@gen,NULL,'rear','normal',35,240,'285/45 R22 (Black Label)'),
  (@gen,NULL,'spare','normal',60,420,'T245/70 D18');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-life-reset','Oil Life reset — Navigator (U554)','SYNC4 → Settings → Vehicle → Oil Life Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-procedure','TPMS training — Navigator (U554)','Ford direct TPMS: cycle ignition, press brake 3×, hold horn, deflate-inflate each tire L-front clockwise.\n','• TPMS tool or magnet, tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Navigator (U554)','Negative-first, positive-last. Throttle relearn after (ignition ON 30 s, OFF 30 s).\n','• 10 mm wrench.','• Skipping relearn.'),
(@gen,'jump_start','jump-start','Jump-start — Navigator (U554)','Standard 4-clamp; under-hood jump posts on driver side.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Dodge Charger LD
SET @gen := (SELECT id FROM generations WHERE slug='charger-ld-sedan-2011-2023');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Dodge Charger (LD) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/dodge/charger-ld-sedan-2011-2023/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Dodge_Charger_(LD).jpg',CURDATE(),'Dodge Charger (LD)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',5.70,6.02,'5W-30','MS-12633 / API SP','68191349AC',8000,12800,12,'5.7L HEMI V8 (R/T). 3.6L Pentastar V6 (SXT/GT): 5.7 qt 5W-20.  6.4L 392 (Scat Pack): 6.5 qt 0W-40 MS-13340. 6.2L Hellcat: 7.0 qt 0W-40.'),
  (@gen,NULL,'transmission_at',5.20,5.50,NULL,'Mopar ATF+4 / ZF Lifeguard 8 (ZF8HP)',NULL,60000,96000,NULL,'5AT (W5A580 SXT base) / 8AT (ZF8HP70 ZF). Hellcat: 9.5 qt ZF Lifeguard 8.'),
  (@gen,NULL,'transfer_case',1.50,1.59,NULL,'Mopar BW-44-40',NULL,NULL,NULL,NULL,'AWD only.'),
  (@gen,NULL,'rear_differential',1.50,1.59,NULL,'Mopar 75W-140 (R/T+) / 75W-90 (V6)',NULL,30000,48000,NULL,'LSD on Scat Pack/Hellcat.'),
  (@gen,NULL,'coolant',12.5,13.2,NULL,'Mopar OAT (HOAT)',NULL,150000,240000,60,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','Mopar DOT 4',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.70,0.74,NULL,'R-134a (pre-2017) / R-1234yf · PAG46',NULL,NULL,NULL,NULL,'700 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',176,130,'M14×1.5.'),(@gen,NULL,'spark_plug',18,13,'NGK ZFR5LP-13G (HEMI).'),
  (@gen,NULL,'oil_drain',34,25,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',150,111,'Front carrier (Brembo on Scat Pack/Hellcat).');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H7 (94R) AGM',800,80,180);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','H11 / LED (post-2015)',2,0),(@gen,NULL,'headlight_high','9005 (HB3)',2,0),
  (@gen,NULL,'fog_front','PSX24W',2,0),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','3157NAK',2,0),(@gen,NULL,'brake_tail','LED Racetrack',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','F1',250,'Battery main'),(@gen,NULL,'engine_bay','F4',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F12',40,'Headlight'),(@gen,NULL,'cabin','01',30,'Blower'),
  (@gen,NULL,'cabin','12',20,'Uconnect'),(@gen,NULL,'cabin','15',20,'Sunroof'),
  (@gen,NULL,'cabin','38',20,'Heated seats'),(@gen,NULL,'cabin','42',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','5149224AB','NGK (Mopar OE)',1.10,NULL,'ZFR5LP-13G · 5.7L HEMI'),
  (@gen,NULL,'oil_filter','68191349AC','Mopar',NULL,NULL,'5.7L HEMI'),
  (@gen,NULL,'air_filter','4861688AB','Mopar',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','68042866AB','Mopar',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','68197102AA','Mopar',NULL,'22 in','Driver'),
  (@gen,NULL,'wiper_front_p','68197102AB','Mopar',NULL,'19 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',8000,4000,12800,6400,12,'Oil-Life Monitor on most.'),(@gen,NULL,'tire_rotation',8000,8000,12800,12800,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',24000,12000,38400,19200,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'rear_diff_oil',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'spark_plugs',30000,30000,48000,48000,NULL,'HEMI plugs ×16.'),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',32,220,'235/55 R18 (SXT/GT)'),(@gen,NULL,'rear','normal',32,220,'235/55 R18 (SXT/GT)'),
  (@gen,NULL,'front','normal',32,220,'245/45 R20 (R/T / Scat Pack)'),(@gen,NULL,'rear','normal',32,220,'245/45 R20 (R/T / Scat Pack)'),
  (@gen,NULL,'front','normal',32,220,'275/40 R20 (Hellcat / Widebody)'),(@gen,NULL,'rear','normal',32,220,'305/35 R20 (Hellcat / Widebody rear)'),
  (@gen,NULL,'spare','normal',60,420,'T155/70 D17 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-life-reset','Oil Life reset — Charger (LD)','Uconnect → Apps → Vehicle Info → Oil Life → Reset; or pedal-dance (key ON: press accel pedal 3× within 10 s).\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-reset','TPMS reset — Charger (LD)','Direct TPMS auto-relearns after drive above 15 mph for 20 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Charger (LD)','Battery in trunk-wall (R/T+) or under hood (V6). Negative-first, positive-last. wiTECH BMS register after replace.\n','• 10 mm wrench, wiTECH.','• Skipping registration.'),
(@gen,'jump_start','jump-start','Jump-start — Charger (LD)','Under-hood jump posts in engine bay. Never to trunk battery negative direct.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

SELECT 'Batch 15 done' AS status, (SELECT COUNT(*) FROM generations WHERE is_active=1) AS gens, (SELECT COUNT(*) FROM procedures) AS procs;
