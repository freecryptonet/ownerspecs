-- Batch 14: Audi A6 C8 + Tesla Model S + Range Rover Sport L461 + Hyundai Kona SX2

SET NAMES utf8mb4;

-- Land Rover make
INSERT IGNORE INTO makes(slug,name) VALUES ('land-rover','Land Rover');
SET @lr_id := (SELECT id FROM makes WHERE slug='land-rover');
INSERT IGNORE INTO models(make_id,slug,name) VALUES (@lr_id,'range-rover-sport','Range Rover Sport');

-- New models for existing makes — use slug lookups so we don't depend on hard-coded make IDs.
INSERT IGNORE INTO models(make_id,slug,name) VALUES
  ((SELECT id FROM makes WHERE slug='audi'),'a6','A6'),
  ((SELECT id FROM makes WHERE slug='tesla'),'model-s','Model S'),
  ((SELECT id FROM makes WHERE slug='hyundai'),'kona','Kona');

-- Generations
INSERT INTO generations(model_id,slug,codename,display_name,body_type,start_year,end_year,platform,is_active) VALUES
  ((SELECT id FROM models WHERE slug='a6' AND make_id=(SELECT id FROM makes WHERE slug='audi')),'a6-c8-sedan-2018-present','C8','A6 V (C8)','sedan',2018,NULL,'VW MLB Evo',1),
  ((SELECT id FROM models WHERE slug='model-s' AND make_id=(SELECT id FROM makes WHERE slug='tesla')),'model-s-sedan-2012-present',NULL,'Model S','sedan',2012,NULL,'Tesla Model S',1),
  ((SELECT id FROM models WHERE slug='range-rover-sport' AND make_id=@lr_id),'range-rover-sport-l461-suv-2022-present','L461','Range Rover Sport III (L461)','suv',2022,NULL,'JLR MLA-Flex',1),
  ((SELECT id FROM models WHERE slug='kona' AND make_id=(SELECT id FROM makes WHERE slug='hyundai')),'kona-sx2-suv-2023-present','SX2','Kona II (SX2)','suv',2023,NULL,'Hyundai K3',1);

-- Audi A6 C8
SET @gen := (SELECT id FROM generations WHERE slug='a6-c8-sedan-2018-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Audi A6 (C8) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/audi/a6-c8-sedan-2018-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Audi_A6_Allroad_Quattro_C8.jpg',CURDATE(),'Audi A6 V (C8)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',6.30,6.66,'5W-30','VW 508 00 / 509 00','06L115562B',10000,16000,12,'45 TFSI 2.0L EA888. 55 TFSI 3.0L EA839: 6.5 qt. 50 TDI 3.0L: 6.5 qt 5W-30 VW 507 00.'),
  (@gen,NULL,'transmission_at',8.40,8.88,NULL,'ZF Lifeguard 8',NULL,80000,128000,NULL,'ZF 8HP 8AT (Tiptronic).'),
  (@gen,NULL,'transmission_dct',5.20,5.50,NULL,'VW DSG fluid G 052 529',NULL,40000,64000,NULL,'S tronic 7DSG.'),
  (@gen,NULL,'transfer_case',0.80,0.85,NULL,'Audi ATF for TC',NULL,NULL,NULL,NULL,'quattro AWD.'),
  (@gen,NULL,'rear_differential',1.00,1.06,NULL,'Audi 75W-90 GL-5',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'coolant',10.0,10.6,NULL,'VW G 13 (lilac)',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','VW DOT 4 LV',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'550 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',140,103,'M14×1.5.'),(@gen,NULL,'spark_plug',30,22,'NGK PFR8S8EG.'),
  (@gen,NULL,'oil_drain',30,22,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',30,22,'Front.'),
  (@gen,NULL,'caliper_bracket',175,129,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H8 AGM',850,95,220);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED HD Matrix',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED OLED',2,1),
  (@gen,NULL,'reverse','W16W',2,0),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','F01',250,'Battery main'),(@gen,NULL,'engine_bay','F04',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F22',30,'Headlight'),(@gen,NULL,'cabin','01',30,'Blower'),
  (@gen,NULL,'cabin','10',20,'MMI'),(@gen,NULL,'cabin','14',20,'Driver seat'),
  (@gen,NULL,'cabin','25',20,'Sunroof'),(@gen,NULL,'cabin','32',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','06H905611','NGK (Audi OE)',0.80,NULL,'PFR8S8EG · EA888/EA839'),
  (@gen,NULL,'oil_filter','06L115562B','Audi Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','4M0129620','Audi Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','4N0819439','Audi Genuine',NULL,NULL,'Activated carbon'),
  (@gen,NULL,'wiper_front_d','4M2955425','Audi Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','4M2955426','Audi Genuine',NULL,'20 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,'Audi LongLife.'),(@gen,NULL,'engine_air_filter',40000,20000,64000,32000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),(@gen,NULL,'transmission_at_fluid',80000,40000,128000,64000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),(@gen,NULL,'spark_plugs',60000,40000,96000,64000,NULL,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'225/55 R18 (Premium)'),(@gen,NULL,'rear','normal',33,230,'225/55 R18 (Premium)'),
  (@gen,NULL,'front','normal',35,240,'255/40 R20 (Prestige / S6)'),(@gen,NULL,'rear','normal',35,240,'255/40 R20 (Prestige / S6)'),
  (@gen,NULL,'spare','normal',60,420,'T125/70 D18 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reminder-reset','Service reset — A6 (C8)','MMI → Car → Service & Inspection → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-store','TPMS store — A6 (C8)','MMI → Car → Tyres → Store. Drive 10 min.\n','• None.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — A6 (C8)','Battery in trunk. Negative-first, positive-last. VCDS BMS registration required.\n','• 10 mm wrench, VCDS.','• Skipping BMS registration.'),
(@gen,'jump_start','jump-start','Jump-start — A6 (C8)','Under-hood jump terminals (never trunk direct).\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Tesla Model S
SET @gen := (SELECT id FROM generations WHERE slug='model-s-sedan-2012-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Tesla Model S Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/tesla/model-s-sedan-2012-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Tesla_Model_S_Plaid.jpg',CURDATE(),'Tesla Model S (Plaid refresh)','3-4-front',1280,720);
-- Model S is BEV: no engine_oil, just reduction-gear oil + thermal coolant + brake + AC
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'reduction_gear',1.40,1.48,NULL,'Tesla Drive Unit Oil',NULL,150000,240000,NULL,'Front + rear drive units; spec by VIN. Plaid tri-motor: 3 units.'),
  (@gen,NULL,'coolant',23.0,24.3,NULL,'Tesla HV Coolant (G-48 ethylene glycol)',NULL,NULL,NULL,NULL,'Battery + drivetrain loop; lifetime per Tesla.'),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Tesla DOT 3',NULL,NULL,NULL,24,'Inspection every 2 yr; flush per condition.'),
  (@gen,NULL,'ac_refrigerant',1.50,1.59,NULL,'R-1234yf · PAG46 (heat pump)',NULL,NULL,NULL,NULL,'1.50 kg with heat pump. Pre-heat-pump cars: 1.30 kg R-134a.'),
  (@gen,NULL,'washer_fluid',5.20,5.50,NULL,'Tesla washer fluid',NULL,NULL,NULL,NULL,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',175,129,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',43,32,'Front (Brembo on Plaid).'),
  (@gen,NULL,'caliper_bracket',150,111,'Front bracket.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'Li-ion 16V / 12V Pb-acid',NULL,6,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED',2,1),(@gen,NULL,'headlight_high','LED Matrix',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','LED',2,1),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'cabin_filter','1107681-00-A','Tesla Genuine',NULL,NULL,'HEPA bioweapon-defense filter (post-2016)'),
  (@gen,NULL,'wiper_front_d','1471689-00-A','Tesla Genuine',NULL,'28 in','Driver'),
  (@gen,NULL,'wiper_front_p','1471690-00-A','Tesla Genuine',NULL,'19 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'cabin_air_filter',24000,12000,38400,19200,24,'Tesla recommends every 2 years.'),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,'Inspect and flush per condition.'),
  (@gen,NULL,'tire_rotation',6250,5000,10000,8000,NULL,'Or 2/32" tread depth difference.'),
  (@gen,NULL,'ac_desiccant',24000,NULL,38400,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',42,290,'245/45 R19 (base)'),(@gen,NULL,'rear','normal',42,290,'245/45 R19 (base)'),
  (@gen,NULL,'front','normal',45,310,'265/35 R21 (Plaid)'),(@gen,NULL,'rear','normal',45,310,'295/30 R21 (Plaid rear)'),
  (@gen,NULL,'spare','normal',60,420,'No spare — tire repair kit');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-mode','Service mode — Model S','Touchscreen → Controls → Service → Service Mode. Allows component-level reset.\n','• None.','• Skipping service-mode exit.'),
(@gen,'tpms_relearn','tpms-pressure','TPMS pressure reset — Model S','Auto-relearn after pressure set + drive above 25 mph for 20 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','12v-battery-disconnect','12V battery service — Model S','Front trunk 12V (Pb-acid) or 16V Li-ion (2021+). NEVER touch orange HV connectors. Tesla diagnostics highly recommended.\n','• 10 mm wrench.','• Touching HV connectors.'),
(@gen,'jump_start','jump-start','Jump-start — Model S','12V only: pull frunk release, expose lower panel, attach to dedicated jump-start terminals. Never to HV pack.\n','• Jumper cables.','• Jumping HV.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Range Rover Sport L461
SET @gen := (SELECT id FROM generations WHERE slug='range-rover-sport-l461-suv-2022-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Land Rover Range Rover Sport (L461) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/land-rover/range-rover-sport-l461-suv-2022-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Land_Rover_Range_Rover_Sport_L461.jpg',CURDATE(),'Range Rover Sport III (L461)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',7.10,7.50,'0W-20','STJLR.51.5122','LR149077',16000,25750,12,'3.0L Ingenium I6 MHEV (P400/P440e). D300 diesel: 5.7 qt 5W-30 STJLR.03.5006.'),
  (@gen,NULL,'transmission_at',8.50,9.00,NULL,'ZF Lifeguard 8',NULL,150000,240000,NULL,'ZF 8HP70 8AT.'),
  (@gen,NULL,'transfer_case',1.50,1.59,NULL,'JLR ATF for TC',NULL,NULL,NULL,NULL,'2-speed transfer (low range).'),
  (@gen,NULL,'front_differential',1.30,1.37,NULL,'JLR 75W-90 GL-5',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'rear_differential',1.20,1.27,NULL,'JLR 75W-90 GL-5',NULL,NULL,NULL,NULL,'eLSD on Dynamic SE.'),
  (@gen,NULL,'coolant',13.5,14.3,NULL,'JLR Coolant (orange)',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','JLR DOT 4',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.80,0.85,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'800 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',170,125,'M14×1.5.'),(@gen,NULL,'spark_plug',23,17,'NGK ILZKR7B-11.'),
  (@gen,NULL,'oil_drain',25,18,'M12×1.5.'),(@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',175,129,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H9 AGM',900,105,250);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Pixel',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','LED',2,1),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','F01',300,'Battery main'),(@gen,NULL,'engine_bay','F04',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F08',40,'ABS / ESP'),(@gen,NULL,'cabin','F100',30,'Driver door'),
  (@gen,NULL,'cabin','F125',25,'Pivi Pro'),(@gen,NULL,'cabin','F134',20,'Tailgate'),
  (@gen,NULL,'cabin','F139',20,'Heated seats'),(@gen,NULL,'cabin','F154',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','LR082420','NGK (JLR OE)',1.10,NULL,'ILZKR7B-11'),
  (@gen,NULL,'oil_filter','LR149077','JLR Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','LR123604','JLR Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','LR065963','JLR Genuine',NULL,NULL,'PM2.5 filter'),
  (@gen,NULL,'wiper_front_d','LR134272','JLR Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','LR134273','JLR Genuine',NULL,'24 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',16000,8000,25750,12875,12,NULL),(@gen,NULL,'tire_rotation',12000,6000,19300,9650,NULL,NULL),
  (@gen,NULL,'engine_air_filter',32000,16000,51500,25750,NULL,NULL),(@gen,NULL,'cabin_air_filter',16000,8000,25750,12875,NULL,'PM2.5.'),
  (@gen,NULL,'transmission_at_fluid',150000,NULL,240000,NULL,NULL,'ZF spec "lifetime", JLR recommends.'),(@gen,NULL,'transfer_case_fluid',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'spark_plugs',75000,40000,120000,64000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',38,260,'255/55 R20 (SE)'),(@gen,NULL,'rear','normal',42,290,'255/55 R20 (SE rear)'),
  (@gen,NULL,'front','normal',38,260,'275/40 R23 (First Edition / SV)'),(@gen,NULL,'rear','normal',42,290,'285/40 R23 (First Edition / SV rear)'),
  (@gen,NULL,'spare','normal',60,420,'T155/90 R20 / repair kit on First Edition');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reset','Service reset — RR Sport (L461)','Pivi Pro → Settings → Service → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-set','TPMS set — RR Sport (L461)','Pivi Pro → Vehicle → Tyre Pressures → Set. Drive 10 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — RR Sport (L461)','Battery in cargo area. Negative-first, positive-last. JLR SDD registration required (BMS).\n','• 10 mm wrench, JLR SDD.','• Skipping registration.'),
(@gen,'jump_start','jump-start','Jump-start — RR Sport (L461)','Under-hood jump posts on driver side. Standard 4-clamp.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Hyundai Kona SX2
SET @gen := (SELECT id FROM generations WHERE slug='kona-sx2-suv-2023-present');
INSERT INTO sources(type,citation,retrieved_at,is_public) VALUES ('oem_manual','Hyundai Kona II (SX2) Owner''s Manual',NOW(),1);
SET @src := LAST_INSERT_ID();
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) VALUES
  (@gen,NULL,NULL,'/images/hyundai/kona-sx2-suv-2023-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Hyundai_Kona_(SX2).jpg',CURDATE(),'Hyundai Kona II (SX2)','3-4-front',1280,720);
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',4.30,4.54,'5W-30','API SP','26300-2J000',7500,12000,12,'2.0L Smartstream G2.0 MPI. 1.6T G1.6 turbo: 4.8 qt 0W-30. EV: no oil.'),
  (@gen,NULL,'transmission_cvt',6.80,7.19,NULL,'Hyundai IVT-1 (SP-IV equivalent)',NULL,75000,120000,NULL,'IVT (Smartstream IVT).'),
  (@gen,NULL,'transmission_dct',1.90,2.01,NULL,'Hyundai DCTF',NULL,75000,120000,NULL,'7DCT (N Line / 1.6T).'),
  (@gen,NULL,'transfer_case',0.45,0.48,NULL,'Hyundai AWD coupling fluid',NULL,75000,120000,NULL,'AWD only.'),
  (@gen,NULL,'rear_differential',0.65,0.69,NULL,'Hyundai 75W-90',NULL,75000,120000,NULL,'AWD.'),
  (@gen,NULL,'coolant',7.40,7.82,NULL,'Hyundai LLC (blue)',NULL,120000,192000,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','Hyundai DOT 4',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.45,0.48,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'450 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',127,94,'M12×1.5.'),(@gen,NULL,'spark_plug',25,18,'NGK ILZKBR7B8DG (G1.6T).'),
  (@gen,NULL,'oil_drain',40,30,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',28,21,'Front.'),
  (@gen,NULL,'caliper_bracket',95,70,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H5 (LN2)',570,55,110);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'drl','LED Pixel',2,1),(@gen,NULL,'turn_front','LED',2,1),
  (@gen,NULL,'brake_tail','LED',2,1),(@gen,NULL,'reverse','921 (W16W)',2,0),
  (@gen,NULL,'turn_rear','LED',2,1),(@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',100,'Battery main'),(@gen,NULL,'engine_bay','ABS',40,'ABS'),
  (@gen,NULL,'engine_bay','PWR',50,'MDPS'),(@gen,NULL,'engine_bay','HEAD',25,'Headlight'),
  (@gen,NULL,'cabin','IGN',30,'Ignition'),(@gen,NULL,'cabin','AUDIO',15,'Audio'),
  (@gen,NULL,'cabin','WIPER',30,'Wiper'),(@gen,NULL,'cabin','SEAT',20,'Heated seats'),
  (@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','18840-11051','NGK (Hyundai OE)',0.80,NULL,'ILZKBR7B8DG · G1.6T'),
  (@gen,NULL,'oil_filter','26300-2J000','Hyundai Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','28113-CT000','Hyundai Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','97133-CT000','Hyundai Genuine',NULL,NULL,'PM2.5'),
  (@gen,NULL,'wiper_front_d','98350-CT000','Hyundai Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','98360-CT000','Hyundai Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,NULL),(@gen,NULL,'tire_rotation',7500,7500,12000,12000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_cvt_fluid',75000,30000,120000,48000,NULL,'IVT.'),(@gen,NULL,'rear_diff_oil',75000,30000,120000,48000,NULL,'AWD.'),
  (@gen,NULL,'spark_plugs',97500,60000,156000,96000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'215/60 R17 (SE)'),(@gen,NULL,'rear','normal',33,230,'215/60 R17 (SE)'),
  (@gen,NULL,'front','normal',33,230,'235/45 R19 (Limited / N Line)'),(@gen,NULL,'rear','normal',33,230,'235/45 R19 (Limited / N Line)'),
  (@gen,NULL,'spare','normal',60,420,'T125/80 D16 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-interval-reset','Service interval reset — Kona (SX2)','Cluster → User Settings → Service Interval → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-auto','TPMS auto-relearn — Kona (SX2)','Direct TPMS auto-relearns after 10-min drive above 15 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Kona (SX2)','Negative-first, positive-last. After replacement: GDS BMS registration.\n','• 10 mm wrench, GDS.','• Skipping registration.'),
(@gen,'jump_start','jump-start','Jump-start — Kona (SX2)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

SELECT 'Batch 14 done' AS status, (SELECT COUNT(*) FROM generations WHERE is_active=1) AS gens, (SELECT COUNT(*) FROM procedures) AS procs;
