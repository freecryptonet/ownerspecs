-- Final batch 11: Q7 4M + GLE V167 + Macan 95B + GV70 + Ascent WM + CX-90 KK

SET NAMES utf8mb4;

-- Q7 4M — gen 90
SET @gen := 90; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Audi Q7 (4M) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Audi Q7 (4M) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Audi Q7 (4M) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/audi/q7-4m-suv-2015-2019/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:2025_Audi_Q7_(4M)_DSC_7492.jpg',CURDATE(),'Audi Q7 II (4M)','3-4-front',1280,853;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',8.50,8.98,'5W-30','VW 504 00 / 507 00','06L115562B',10000,16000,12,'3.0 TFSI V6 · 8.5 L. 3.0 TDI V6: 6.5 L 5W-30 VW 507 00.'),
  (@gen,NULL,'transmission_at',8.50,9.00,NULL,'ZF Lifeguard 8',NULL,100000,160000,NULL,'ZF 8HP70 8AT.'),
  (@gen,NULL,'transfer_case',0.80,0.85,NULL,'Audi ATF for TC',NULL,NULL,NULL,NULL,'quattro centre diff.'),
  (@gen,NULL,'rear_differential',1.00,1.06,NULL,'Audi 75W-90 GL-5',NULL,NULL,NULL,NULL,'quattro rear.'),
  (@gen,NULL,'coolant',12.0,12.7,NULL,'VW G 13 (lilac)',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','VW DOT 4 LV',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.65,0.69,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'650 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',140,103,'M14×1.5.'),(@gen,NULL,'spark_plug',30,22,'NGK PFR8S8EG.'),
  (@gen,NULL,'oil_drain',30,22,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',30,22,'Front.'),
  (@gen,NULL,'caliper_bracket',200,148,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H8 AGM',850,95,220);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Matrix',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','W16W',2,0),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','F01',250,'Battery main'),(@gen,NULL,'engine_bay','F04',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F22',30,'Headlight'),(@gen,NULL,'cabin','01',30,'Blower'),
  (@gen,NULL,'cabin','07',20,'12V outlet'),(@gen,NULL,'cabin','10',20,'MMI'),
  (@gen,NULL,'cabin','14',20,'Driver seat'),(@gen,NULL,'cabin','32',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','06H905611','NGK (Audi OE)',0.80,NULL,'PFR8S8EG · EA839'),
  (@gen,NULL,'oil_filter','06L115562B','Audi Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','4M0129620','Audi Genuine',NULL,NULL,'Q7 4M air filter'),
  (@gen,NULL,'cabin_filter','80A819439','Audi Genuine',NULL,NULL,'Activated carbon'),
  (@gen,NULL,'wiper_front_d','4M1955425','Audi Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','4M1955426','Audi Genuine',NULL,'24 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,'Audi LongLife.'),(@gen,NULL,'transmission_at_fluid',100000,60000,160000,96000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',40000,20000,64000,32000,NULL,NULL),(@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),(@gen,NULL,'spark_plugs',60000,40000,96000,64000,NULL,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'255/55 R19 (Premium)'),(@gen,NULL,'rear','normal',35,240,'255/55 R19 (Premium)'),
  (@gen,NULL,'front','normal',35,240,'255/45 R21 (Premium Plus / Prestige)'),(@gen,NULL,'rear','normal',35,240,'255/45 R21 (Premium Plus / Prestige)'),
  (@gen,NULL,'spare','normal',60,420,'T155/85 D19 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reminder-reset','Service reset — Q7 (4M)','MMI → Car → Service & Inspection → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-store','TPMS store — Q7 (4M)','MMI → Car → Tyres → Store. Drive 10 min.\n','• None.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Q7 (4M)','Negative-first, positive-last. Battery in trunk; jump terminals under hood. Registration via VCDS required.\n','• 10 mm wrench, VCDS.','• Skipping BMS registration.'),
(@gen,'jump_start','jump-start','Jump-start — Q7 (4M)','Under-hood jump terminals (never trunk direct).\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- GLE V167 — gen 91
SET @gen := 91; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Mercedes-Benz GLE (V167) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Mercedes-Benz GLE (V167) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Mercedes-Benz GLE (V167) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/mercedes-benz/gle-v167-suv-2019-2023/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Mercedes-Benz_GLE_ESF_Concept_(V167).jpg',CURDATE(),'Mercedes-Benz GLE (V167)','3-4-front',1280,853;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',7.50,7.93,'0W-30','MB 229.51','A 651 180 03 09',10000,16000,12,'3.0L M256 inline-6 (GLE 450). 2.0L M264 (GLE 350): 6.0 qt. 3.0L OM656 diesel: 6.0 qt MB 229.52.'),
  (@gen,NULL,'transmission_at',8.50,9.00,NULL,'MB 236.15 ATF',NULL,60000,96000,NULL,'9G-TRONIC.'),
  (@gen,NULL,'transfer_case',0.85,0.90,NULL,'MB 235.31',NULL,NULL,NULL,NULL,'4MATIC.'),
  (@gen,NULL,'front_differential',0.85,0.90,NULL,'MB 235.74',NULL,NULL,NULL,NULL,'4MATIC front.'),
  (@gen,NULL,'rear_differential',0.90,0.95,NULL,'MB 235.74',NULL,NULL,NULL,NULL,'Rear diff.'),
  (@gen,NULL,'coolant',12.0,12.7,NULL,'MB 326.0',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','MB DOT 4 plus',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.75,0.79,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'750 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',150,111,'M14×1.5.'),(@gen,NULL,'spark_plug',25,18,'NGK PLZKBR7B-8.'),
  (@gen,NULL,'oil_drain',30,22,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',35,26,'Front.'),
  (@gen,NULL,'caliper_bracket',115,85,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H8 (95) AGM',850,95,220);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Multibeam',2,1),(@gen,NULL,'headlight_high','LED Multibeam',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','LED',2,1),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','F01',250,'Battery main'),(@gen,NULL,'engine_bay','F04',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F08',40,'ABS / ESP'),(@gen,NULL,'cabin','F100',30,'Driver door'),
  (@gen,NULL,'cabin','F125',25,'MBUX'),(@gen,NULL,'cabin','F134',20,'Tailgate'),
  (@gen,NULL,'cabin','F139',20,'Heated seats'),(@gen,NULL,'cabin','F154',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','A 003 159 96 03','NGK (MB OE)',0.80,NULL,'PLZKBR7B-8'),
  (@gen,NULL,'oil_filter','A 651 180 03 09','MB Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','A 167 094 02 04','MB Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','A 167 830 02 18','MB Genuine',NULL,NULL,'HEPA'),
  (@gen,NULL,'wiper_front_d','A 167 824 03 00','MB Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','A 167 824 04 00','MB Genuine',NULL,'24 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,'MB Service A/B.'),(@gen,NULL,'brake_inspection',10000,5000,16000,8000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'spark_plugs',75000,NULL,120000,NULL,NULL,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'265/50 R19 (350 base)'),(@gen,NULL,'rear','normal',36,250,'265/50 R19 (350 base)'),
  (@gen,NULL,'front','normal',35,240,'275/45 R21 (AMG-Line)'),(@gen,NULL,'rear','normal',38,260,'275/45 R21 (AMG-Line rear)'),
  (@gen,NULL,'spare','normal',60,420,'TIREFIT kit — no spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-a-b-reset','Service A/B reset — GLE (V167)','MBUX → Vehicle → Service → Service A or B → Reset.\n','• None.','• Resetting before service done.'),
(@gen,'tpms_relearn','tpms-restart','TPMS restart — GLE (V167)','MBUX → Vehicle → Tyre Pressure → Restart. Drive 10 min.\n','• None.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — GLE (V167)','Negative-first, positive-last. XENTRY required for new battery registration.\n','• 10 mm wrench, XENTRY.','• Skipping registration.'),
(@gen,'jump_start','jump-start','Jump-start — GLE (V167)','Under-hood jump terminals. Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Macan 95B — gen 92
SET @gen := 92; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Porsche Macan (95B) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Porsche Macan (95B) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Porsche Macan (95B) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/porsche/macan-95b-suv-2014-2018/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Porsche_Macan_S_(95B).jpg',CURDATE(),'Porsche Macan S (95B)','3-4-front',1280,853;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',6.50,6.87,'0W-40','Porsche A40 / Mobil 1 0W-40','95B107562',10000,16000,12,'3.0L V6 turbo (S/GTS). Turbo 3.6 V6: 7.0 qt.'),
  (@gen,NULL,'transmission_at',7.50,7.93,NULL,'Porsche PDK ATF',NULL,80000,128000,NULL,'7-speed PDK.'),
  (@gen,NULL,'transfer_case',0.80,0.85,NULL,'Porsche ATF for PTM',NULL,NULL,NULL,NULL,'PTM AWD.'),
  (@gen,NULL,'rear_differential',1.10,1.16,NULL,'Porsche 75W-90',NULL,NULL,NULL,NULL,'Sport diff on GTS/Turbo.'),
  (@gen,NULL,'coolant',10.0,10.6,NULL,'VW G 13 (lilac)',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','Porsche brake fluid Super DOT 4',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.65,0.69,NULL,'R-1234yf (2017+) / R-134a (older)',NULL,NULL,NULL,NULL,'650 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',160,118,'M14×1.5.'),(@gen,NULL,'spark_plug',30,22,'NGK FR6KI-332S.'),
  (@gen,NULL,'oil_drain',30,22,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',38,28,'Front guide pin.'),
  (@gen,NULL,'caliper_bracket',220,162,'Front carrier (4-pot).');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H8 AGM',800,90,200);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','D3S / LED PDLS+',2,0),(@gen,NULL,'headlight_high','H7 / LED',2,0),
  (@gen,NULL,'fog_front','H11',2,0),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','PY24W',2,0),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','W16W',2,0),(@gen,NULL,'turn_rear','PY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','F01',250,'Battery main'),(@gen,NULL,'engine_bay','F04',60,'Cooling fan'),
  (@gen,NULL,'engine_bay','F22',30,'Headlight'),(@gen,NULL,'cabin','01',30,'Blower'),
  (@gen,NULL,'cabin','10',20,'PCM'),(@gen,NULL,'cabin','14',20,'Driver seat'),
  (@gen,NULL,'cabin','23',20,'Sunroof'),(@gen,NULL,'cabin','32',10,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','94B910612','NGK (Porsche OE)',0.80,NULL,'FR6KI-332S · 3.0/3.6 V6'),
  (@gen,NULL,'oil_filter','95B107562','Porsche Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','95B129620A','Porsche Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','95B819644','Porsche Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','95B998003','Porsche Genuine',NULL,'24 in','Driver'),
  (@gen,NULL,'wiper_front_p','95B998003','Porsche Genuine',NULL,'22 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',10000,5000,16000,8000,12,'Porsche service interval.'),(@gen,NULL,'transmission_at_fluid',80000,40000,128000,64000,NULL,'PDK.'),
  (@gen,NULL,'engine_air_filter',40000,20000,64000,32000,NULL,NULL),(@gen,NULL,'cabin_air_filter',20000,10000,32000,16000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL),(@gen,NULL,'spark_plugs',60000,40000,96000,64000,NULL,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'235/60 R18 (base)'),(@gen,NULL,'rear','normal',36,250,'255/55 R18 (base)'),
  (@gen,NULL,'front','normal',35,240,'265/45 R20 (S / GTS)'),(@gen,NULL,'rear','normal',38,260,'295/40 R20 (S / GTS rear)'),
  (@gen,NULL,'spare','normal',60,420,'T155/85 D18');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reset','Service reset — Macan (95B)','PCM → Settings → Service → Reset oil/inspection.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-set','TPMS set — Macan (95B)','PCM → Tyre Pressures → Set new specified values. Drive 10 min.\n','• None.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Macan (95B)','Battery in front trunk. Negative-first, positive-last. PIWIS registration required.\n','• 10 mm wrench, PIWIS.','• Skipping registration.'),
(@gen,'jump_start','jump-start','Jump-start — Macan (95B)','Front trunk battery directly accessible.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- GV70 JK1 — gen 93
SET @gen := 93; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Genesis GV70 (JK1) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Genesis GV70 (JK1) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Genesis GV70 (JK1) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/genesis/gv70-jk1-suv-2021-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Genesis_GV70_IAA_2021.jpg',CURDATE(),'Genesis GV70 (JK1)','3-4-front',1280,720;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',6.40,6.76,'5W-30','API SP','26300-3CAA0',7500,12000,12,'2.5T G2.5 turbo · 6.0 qt. 3.5T G3.5 V6: 6.76 qt. Electrified (EV): no oil.'),
  (@gen,NULL,'transmission_at',7.50,7.93,NULL,'Hyundai SP-IV ATF',NULL,60000,96000,NULL,'8AT.'),
  (@gen,NULL,'transfer_case',0.50,0.53,NULL,'Hyundai AWD coupling',NULL,75000,120000,NULL,'AWD only.'),
  (@gen,NULL,'rear_differential',0.95,1.00,NULL,'Hyundai 75W-90 GL-5',NULL,75000,120000,NULL,'AWD rear.'),
  (@gen,NULL,'coolant',8.50,9.00,NULL,'Hyundai LLC (blue)',NULL,120000,192000,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 4','Genesis DOT 4',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'550 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',127,94,'M14×1.5.'),(@gen,NULL,'spark_plug',25,18,'NGK ILZFR6D-11.'),
  (@gen,NULL,'oil_drain',35,26,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',28,21,'Front.'),
  (@gen,NULL,'caliper_bracket',95,70,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H6 (LN3) AGM',760,80,180);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED Quad',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED Quad',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','LED',2,1),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','MAIN',100,'Battery main'),(@gen,NULL,'engine_bay','ABS',40,'ABS'),
  (@gen,NULL,'engine_bay','PWR',50,'MDPS'),(@gen,NULL,'engine_bay','HEAD',25,'Headlight'),
  (@gen,NULL,'cabin','IGN',30,'Ignition'),(@gen,NULL,'cabin','AUDIO',15,'Audio'),
  (@gen,NULL,'cabin','WIPER',30,'Wiper'),(@gen,NULL,'cabin','SEAT',20,'Heated seats'),
  (@gen,NULL,'cabin','OBD',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','18840-11051','NGK (Genesis OE)',1.10,NULL,'ILZFR6D-11'),
  (@gen,NULL,'oil_filter','26300-3CAA0','Genesis Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','28113-AR000','Genesis Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','97133-AR000','Genesis Genuine',NULL,NULL,'HEPA'),
  (@gen,NULL,'wiper_front_d','98350-AR000','Genesis Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','98360-AR000','Genesis Genuine',NULL,'20 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,3750,12000,6000,12,NULL),(@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),(@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'rear_diff_oil',75000,37500,120000,60000,NULL,'AWD.'),(@gen,NULL,'spark_plugs',97500,60000,156000,96000,NULL,NULL),
  (@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'235/60 R19 (Advanced)'),(@gen,NULL,'rear','normal',35,240,'235/60 R19 (Advanced)'),
  (@gen,NULL,'front','normal',35,240,'255/45 R21 (Sport / 3.5T)'),(@gen,NULL,'rear','normal',35,240,'255/45 R21 (Sport / 3.5T)'),
  (@gen,NULL,'spare','normal',60,420,'T165/85 D19');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-interval-reset','Service interval reset — GV70 (JK1)','Cluster → User Settings → Service Interval → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-auto','TPMS auto-relearn — GV70 (JK1)','Auto-relearn after 10-min drive above 15 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — GV70 (JK1)','Negative-first, positive-last. GDS registration after replacement.\n','• 10 mm wrench, GDS.','• Skipping registration.'),
(@gen,'jump_start','jump-start','Jump-start — GV70 (JK1)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Subaru Ascent WM — gen 94
SET @gen := 94; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Subaru Ascent (WM) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Subaru Ascent (WM) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Subaru Ascent (WM) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/subaru/ascent-wm-suv-2019-2023/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:2019_Subaru_Ascent_front_7.7.18.jpg',CURDATE(),'2019 Subaru Ascent (WM)','3-4-front',1280,853;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',5.20,5.50,'0W-20','API SP','15208AA170',6000,9600,6,'2.4L FA24F turbo · 5.5 qt.'),
  (@gen,NULL,'transmission_cvt',11.7,12.4,NULL,'Subaru High Torque CVTF II',NULL,60000,96000,NULL,'Lineartronic TR690 CVT (heavy-duty).'),
  (@gen,NULL,'rear_differential',0.80,0.85,NULL,'Subaru 75W-90',NULL,30000,48000,NULL,NULL),
  (@gen,NULL,'coolant',6.20,6.55,NULL,'Subaru Super Coolant (blue)',NULL,137500,220000,132,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Subaru DOT 3',NULL,NULL,NULL,30,NULL),
  (@gen,NULL,'ac_refrigerant',0.55,0.58,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'550 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',120,89,'M12×1.25.'),(@gen,NULL,'spark_plug',22,16,'NGK SILZKAR8U10S (FA24F turbo).'),
  (@gen,NULL,'oil_drain',44,32,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',32,24,'Front.'),
  (@gen,NULL,'caliper_bracket',100,74,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H6 (LN3) AGM',760,80,150);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (Limited+) / H11',2,1),(@gen,NULL,'headlight_high','H11 / LED',2,0),
  (@gen,NULL,'fog_front','H8',2,0),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','7507 (PY21W)',2,0),(@gen,NULL,'brake_tail','7443',2,0),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','7507 (PY21W)',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','No.3',20,'Headlight'),(@gen,NULL,'engine_bay','No.12',30,'ABS pump'),
  (@gen,NULL,'engine_bay','No.18',30,'Wiper'),(@gen,NULL,'engine_bay','No.22',50,'EPS'),
  (@gen,NULL,'cabin','No.1',20,'Audio'),(@gen,NULL,'cabin','No.6',20,'Front 12V'),
  (@gen,NULL,'cabin','No.14',30,'Driver window'),(@gen,NULL,'cabin','No.22',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','22401AA950','NGK (Subaru OE)',0.80,NULL,'SILZKAR8U10S · FA24F'),
  (@gen,NULL,'oil_filter','15208AA170','Subaru Genuine',NULL,NULL,'Cartridge'),
  (@gen,NULL,'air_filter','16546AA15A','Subaru Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','72880XC01A','Subaru Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','86532XC01A','Subaru Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','86542XC01A','Subaru Genuine',NULL,'18 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',6000,3000,9600,4800,6,'FA24F 6k mi.'),(@gen,NULL,'tire_rotation',6000,6000,9600,9600,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_cvt_fluid',60000,30000,96000,48000,NULL,'TR690 CVT.'),(@gen,NULL,'rear_diff_oil',30000,15000,48000,24000,NULL,NULL),
  (@gen,NULL,'spark_plugs',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,30,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',35,240,'245/60 R18 (Base / Premium)'),(@gen,NULL,'rear','normal',35,240,'245/60 R18 (Base / Premium)'),
  (@gen,NULL,'front','normal',35,240,'245/50 R20 (Limited / Touring)'),(@gen,NULL,'rear','normal',35,240,'245/50 R20 (Limited / Touring)'),
  (@gen,NULL,'spare','normal',60,420,'T155/90 D18');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'service_reminder_reset','service-reminder-reset','Service reminder reset — Ascent (WM)','Subaru ‘i’ stalk → Maintenance → Engine Oil → hold.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-set','TPMS set — Ascent (WM)','Direct TPMS. STARLINK → TPMS → Set. Drive 15 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Ascent (WM)','Negative-first, positive-last. After reconnect: lock-to-lock for EPS, EyeSight self-cal.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Ascent (WM)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Mazda CX-90 KK — gen 95
SET @gen := 95; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Mazda CX-90 (KK) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Mazda CX-90 (KK) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Mazda CX-90 (KK) Owner''s Manual' LIMIT 1);
INSERT IGNORE INTO images(generation_id,trim_id,market_id,url,source,license,attribution,original_url,download_date,caption,position,width,height) SELECT @gen,NULL,NULL,'/images/mazda/cx-90-kk-suv-2024-present/hero.jpg','wikimedia','cc-by-sa-4.0','Wikimedia Commons','https://commons.wikimedia.org/wiki/File:Mazda_CX-90_(KK).jpg',CURDATE(),'Mazda CX-90 (KK)','3-4-front',1280,720;
INSERT INTO fluid_specs(generation_id,market_id,fluid_type,capacity_l,capacity_qt,viscosity,spec_standard,filter_part_no,drain_interval_mi,drain_interval_km,drain_interval_months,notes) VALUES
  (@gen,NULL,'engine_oil',6.30,6.66,'0W-20','API SP / ILSAC GF-6A','PE01-14-302A',7500,12000,12,'3.3L e-SKYACTIV-G inline-6 MHEV. PHEV: 2.5L 4-cyl + 17.8 kWh battery, 4.75 qt 0W-20.'),
  (@gen,NULL,'transmission_at',8.40,8.88,NULL,'Mazda ATF FZ',NULL,60000,96000,NULL,'8-speed AT (RWD-biased).'),
  (@gen,NULL,'transfer_case',0.85,0.90,NULL,'Mazda AWD coupling',NULL,75000,120000,NULL,'i-ACTIV AWD.'),
  (@gen,NULL,'rear_differential',1.20,1.27,NULL,'Mazda 75W-90 GL-5',NULL,60000,96000,NULL,NULL),
  (@gen,NULL,'coolant',12.0,12.7,NULL,'Mazda FL22 (green)',NULL,NULL,NULL,NULL,NULL),
  (@gen,NULL,'brake',NULL,NULL,'DOT 3','Mazda DOT 3',NULL,NULL,NULL,24,NULL),
  (@gen,NULL,'ac_refrigerant',0.65,0.69,NULL,'R-1234yf · PAG46',NULL,NULL,NULL,NULL,'650 g.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fluid_specs',id,@src FROM fluid_specs WHERE generation_id=@gen;
INSERT INTO torque_specs(generation_id,market_id,fastener,torque_nm,torque_ftlb,notes) VALUES
  (@gen,NULL,'lug_nut',127,94,'M14×1.5.'),(@gen,NULL,'spark_plug',20,15,'NGK ILTR5A-13G.'),
  (@gen,NULL,'oil_drain',33,24,'M14×1.5.'),(@gen,NULL,'caliper_slide_pin',33,24,'Front.'),
  (@gen,NULL,'caliper_bracket',100,74,'Front carrier.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'torque_specs',id,@src FROM torque_specs WHERE generation_id=@gen;
INSERT INTO electrical_specs(generation_id,market_id,battery_group,cca,ah,alternator_amps) VALUES (@gen,NULL,'H6 AGM',760,80,150);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'electrical_specs',id,@src FROM electrical_specs WHERE generation_id=@gen;
INSERT INTO bulbs(generation_id,market_id,position,bulb_code,quantity,led_from_factory) VALUES
  (@gen,NULL,'headlight_low','LED (sealed)',2,1),(@gen,NULL,'headlight_high','LED',2,1),
  (@gen,NULL,'fog_front','LED',2,1),(@gen,NULL,'drl','LED',2,1),
  (@gen,NULL,'turn_front','LED',2,1),(@gen,NULL,'brake_tail','LED',2,1),
  (@gen,NULL,'reverse','921 (W16W)',2,0),(@gen,NULL,'turn_rear','WY21W',2,0),
  (@gen,NULL,'license_plate','LED',2,1),(@gen,NULL,'interior_dome','LED',2,1);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'bulbs',id,@src FROM bulbs WHERE generation_id=@gen;
INSERT INTO fuses(generation_id,market_id,location,position,amperage,circuit_name) VALUES
  (@gen,NULL,'engine_bay','20',30,'ABS pump'),(@gen,NULL,'engine_bay','26',40,'EPS'),
  (@gen,NULL,'engine_bay','32',30,'Blower'),(@gen,NULL,'engine_bay','41',15,'ECU'),
  (@gen,NULL,'engine_bay','48',25,'Headlight'),(@gen,NULL,'cabin','1',10,'Audio'),
  (@gen,NULL,'cabin','4',20,'Driver window'),(@gen,NULL,'cabin','7',15,'12V outlet'),
  (@gen,NULL,'cabin','12',7.5,'OBD-II');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'fuses',id,@src FROM fuses WHERE generation_id=@gen;
INSERT INTO parts(generation_id,market_id,part_type,part_number,source_brand,gap_mm,size,notes) VALUES
  (@gen,NULL,'spark_plug','PE5R-18-110','NGK (Mazda OE)',0.80,NULL,'ILTR5A-13G'),
  (@gen,NULL,'oil_filter','PE01-14-302A','Mazda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'air_filter','PE07-13-3A0','Mazda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'cabin_filter','KD45-61-J6X','Mazda Genuine',NULL,NULL,NULL),
  (@gen,NULL,'wiper_front_d','KD45-67-330','Mazda Genuine',NULL,'26 in','Driver'),
  (@gen,NULL,'wiper_front_p','KD45-67-340','Mazda Genuine',NULL,'20 in','Passenger');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'parts',id,@src FROM parts WHERE generation_id=@gen;
INSERT INTO service_intervals(generation_id,market_id,service,miles_normal,miles_severe,km_normal,km_severe,months,notes) VALUES
  (@gen,NULL,'engine_oil_and_filter',7500,5000,12000,8000,12,NULL),(@gen,NULL,'tire_rotation',7500,5000,12000,8000,NULL,NULL),
  (@gen,NULL,'engine_air_filter',30000,15000,48000,24000,NULL,NULL),(@gen,NULL,'cabin_air_filter',15000,7500,24000,12000,NULL,NULL),
  (@gen,NULL,'transmission_at_fluid',60000,30000,96000,48000,NULL,NULL),(@gen,NULL,'rear_diff_oil',60000,30000,96000,48000,NULL,NULL),
  (@gen,NULL,'spark_plugs',75000,40000,120000,64000,NULL,NULL),(@gen,NULL,'brake_fluid_flush',NULL,NULL,NULL,NULL,24,NULL);
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'service_intervals',id,@src FROM service_intervals WHERE generation_id=@gen;
INSERT INTO tire_pressures(generation_id,market_id,position,load_condition,psi,kpa,tire_size) VALUES
  (@gen,NULL,'front','normal',33,230,'265/55 R19 (Select / Preferred)'),(@gen,NULL,'rear','normal',33,230,'265/55 R19 (Select / Preferred)'),
  (@gen,NULL,'front','normal',33,230,'275/50 R21 (Premium Plus / Signature)'),(@gen,NULL,'rear','normal',33,230,'275/50 R21 (Premium Plus / Signature)'),
  (@gen,NULL,'spare','normal',60,420,'T165/85 D19 compact spare');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@src FROM tire_pressures WHERE generation_id=@gen;
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-data-reset','Engine Oil Data reset — CX-90 (KK)','Mazda canonical: ignition ON → INFO long-press on Engine Oil Data.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-set','TPMS set — CX-90 (KK)','Direct TPMS auto-registered after drive.\n','• None.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — CX-90 (KK)','Negative-first, positive-last. PHEV: 12V in engine bay; HV sealed.\n','• 10 mm wrench.','• Touching HV cables on PHEV.'),
(@gen,'jump_start','jump-start','Jump-start — CX-90 (KK)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

SELECT 'Batch 11 done' AS status, (SELECT COUNT(*) FROM generations WHERE is_active=1) AS gens, (SELECT COUNT(*) FROM procedures) AS procs;
