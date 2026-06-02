-- mig 552 — moat-fill Audi A1 (8X) 2011-2018 (gen 350) via browser HaynesPro (country EU).
-- Facts only (Feist). Reuse vendor-neutral source 815 "Workshop service manual — Audi A1 (8X)" (public_link=0).
-- Engine-scoped oil+coolant per DB engine. Oil specs by engine family (extracted per family,
-- applied to the family's member engines): EA211 TFSI / EA111 TFSI / EA888 / EA113 / EA189+EA288 TDI.
-- Coolant: TL-VW 774J (G13) gen-wide spec; capacity 8.0 L confirmed on the volume engine (petrol);
-- diesel coolant capacity not separately confirmed -> spec only.
-- Petrol oil drain plug 30 N·m. All TFSI use VW 504 00 (Longlife); TDI use VW 507 00.

SET NAMES utf8mb4;
SET @g := 350;
SET @src := 815;

-- ENGINE OIL (engine-scoped) ----------------------------------------------------
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 (@g,2160,'engine_oil',4.00,'SAE 0W-30','VW 504 00','1.0 TFSI (EA211). With-filter fill. Drain plug 30 N·m.'),
 (@g,2161,'engine_oil',4.00,'SAE 0W-30','VW 504 00','1.0 TFSI (EA211). With-filter fill. Drain plug 30 N·m.'),
 (@g,2158,'engine_oil',4.00,'SAE 0W-30','VW 504 00','1.4 TFSI (EA211). With-filter fill; 0W-20/VW 508 00 on 2018 build. Drain plug 30 N·m.'),
 (@g,2159,'engine_oil',4.00,'SAE 0W-30','VW 504 00','1.4 TFSI (EA211). With-filter fill. Drain plug 30 N·m.'),
 (@g,2078,'engine_oil',4.00,'SAE 0W-30','VW 504 00','1.4 TFSI (EA211, CPTA). With-filter fill. Drain plug 30 N·m.'),
 (@g,2162,'engine_oil',3.60,'SAE 5W-30','VW 504 00','1.2 TFSI (EA111). With-filter fill; 5W-40/VW 502 00 for fixed service. Drain plug 30 N·m.'),
 (@g,2079,'engine_oil',3.60,'SAE 5W-30','VW 504 00','1.4 TFSI (EA111). With-filter fill; 5W-40/VW 502 00 for fixed service. Drain plug 30 N·m.'),
 (@g,2077,'engine_oil',3.60,'SAE 5W-30','VW 504 00','1.4 TFSI (EA111). With-filter fill; 5W-40/VW 502 00 for fixed service. Drain plug 30 N·m.'),
 (@g,2157,'engine_oil',5.20,'SAE 0W-30','VW 504 00','1.8 TFSI (EA888). With-filter fill. Drain plug 30 N·m.'),
 (@g,2076,'engine_oil',4.50,'SAE 5W-30','VW 504 00','2.0 TFSI (EA113). With-filter fill; 5W-40/VW 502 00 for fixed service. Drain plug 30 N·m.'),
 (@g,1722,'engine_oil',3.70,'SAE 0W-30','VW 507 00','1.4 TDI (EA288). With-filter fill. Drain plug 30 N·m.'),
 (@g,1728,'engine_oil',4.90,'SAE 5W-30','VW 507 00','1.6 TDI (EA288). With-filter fill. Drain plug 30 N·m.'),
 (@g,1298,'engine_oil',4.30,'SAE 5W-30','VW 507 00','1.6 TDI (EA189). With-filter fill. Drain plug 30 N·m.'),
 (@g,1299,'engine_oil',4.30,'SAE 5W-30','VW 507 00','1.6 TDI (EA189). With-filter fill. Drain plug 30 N·m.'),
 (@g,1730,'engine_oil',4.30,'SAE 5W-30','VW 507 00','2.0 TDI (EA189). With-filter fill. Drain plug 30 N·m.');

-- COOLANT (engine-scoped; G13 spec gen-wide; petrol capacity confirmed 8.0 L) ----
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 (@g,2160,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G). 40% antifreeze -> -25°C; 50% -> -35°C.'),
 (@g,2161,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,2158,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G). 40% -> -25°C; 50% -> -36°C.'),
 (@g,2159,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,2078,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,2162,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,2079,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,2077,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,2157,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,2076,'coolant',8.00,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,1722,'coolant',NULL,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G). System capacity not separately confirmed.'),
 (@g,1728,'coolant',NULL,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,1298,'coolant',NULL,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,1299,'coolant',NULL,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).'),
 (@g,1730,'coolant',NULL,NULL,'TL-VW 774J (G13)','Or G12++ (TL-VW 774G).');

-- BRAKE (gen-wide) --------------------------------------------------------------
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 (@g,NULL,'brake',NULL,NULL,'VW 501 14 / DOT 4','VW 501 14 preferred, DOT 4 alternative.');

-- TORQUES (chassis gen-wide; engine torques scoped to the 1.4 TFSI EA211) --------
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, notes) VALUES
 (@g,NULL,'wheel_bolt',120,'Do not use power tools to run the bolts in.'),
 (@g,NULL,'oil_drain',30,'Renew the drain plug/seal.'),
 (@g,2158,'cylinder_head_bolt',40,'1.4 TFSI (EA211). Renew bolts. Stage 1: 40 N·m; stage 2: +90°; stage 3: +90°.'),
 (@g,2158,'oil_filter',20,'1.4 TFSI (EA211) oil filter housing.'),
 (@g,2158,'oxygen_sensor',55,'1.4 TFSI (EA211).'),
 (@g,2158,'starter_motor',40,'1.4 TFSI (EA211).');

-- BATTERY (representative; range 61-80 Ah / 330-420 CCA across trims) ------------
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
 (@g,'LN2 (H5)',380,68,110);

-- TYRE PRESSURES (front/rear, normal + full load; bar->psi/kpa) ------------------
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
 (@g,'front','normal',33.4,230,'185/60 R15 84H'),(@g,'front','full',37.7,260,'185/60 R15 84H'),
 (@g,'rear','normal',30.5,210,'185/60 R15 84H'),(@g,'rear','full',31.9,220,'185/60 R15 84H'),
 (@g,'front','normal',31.9,220,'215/45 R16 90V'),(@g,'front','full',36.3,250,'215/45 R16 90V'),
 (@g,'rear','normal',29.0,200,'215/45 R16 90V'),(@g,'rear','full',31.9,220,'215/45 R16 90V'),
 (@g,'front','normal',34.8,240,'195/50 R16 88H'),(@g,'front','full',39.2,270,'195/50 R16 88H'),
 (@g,'rear','normal',30.5,210,'195/50 R16 88H'),(@g,'rear','full',33.4,230,'195/50 R16 88H'),
 (@g,'front','normal',33.4,230,'215/40 R17 87W'),(@g,'front','full',37.7,260,'215/40 R17 87W'),
 (@g,'rear','normal',30.5,210,'215/40 R17 87W'),(@g,'rear','full',33.4,230,'215/40 R17 87W');

-- FUSES — main passenger fuse box No.1 (40 positions) ----------------------------
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
 (@g,'cabin','1',30,'Digital sound package CU, voltage regulator, radio',0),
 (@g,'cabin','2',40,'Heater CU, X-contact relief relay, blower CU, blower',0),
 (@g,'cabin','3',20,'Cigarette lighter, 12V socket',0),
 (@g,'cabin','4',15,'Trailer detection control unit',0),
 (@g,'cabin','5',5,'Data bus diagnostic interface',0),
 (@g,'cabin','6',30,'Front passenger / rear right door control unit',0),
 (@g,'cabin','7',30,'Driver / rear left door control unit',0),
 (@g,'cabin','8',30,'Heated rear windscreen + relay',0),
 (@g,'cabin','9',25,'ABS control unit',0),
 (@g,'cabin','10',20,'Power supply control unit',0),
 (@g,'cabin','11',15,'Horns, horn relay',0),
 (@g,'cabin','12',30,'Power supply control unit',0),
 (@g,'cabin','13',5,'Alarm sensor, alarm horn',0),
 (@g,'cabin','14',5,'Motronic power supply relay, engine control unit',0),
 (@g,'cabin','15',5,'Power supply control unit',0),
 (@g,'cabin','16',5,'ABS CU, voltage regulator, ignition coil relay',0),
 (@g,'cabin','17',5,'Radiator fan control unit',0),
 (@g,'cabin','18',5,'Rain/light sensor, antenna selection CU, sunroof module',0),
 (@g,'cabin','19',15,'Fuel pump control unit / fuel pump relay',0),
 (@g,'cabin','20',10,'Additional coolant pump relay',0),
 (@g,'cabin','21',5,'Steering column electronics control unit',0),
 (@g,'cabin','22',5,'Lighting switch',0),
 (@g,'cabin','23',10,'Climatronic / A-C control unit',0),
 (@g,'cabin','24',10,'Driver / rear left door control unit',0),
 (@g,'cabin','25',10,'Power supply control unit',0),
 (@g,'cabin','26',20,'Radiator fan control unit',0),
 (@g,'cabin','27',30,'Power supply control unit',0),
 (@g,'cabin','28',20,'Wiper relay, ignition coils, engine management supply relay',0),
 (@g,'cabin','29',5,'Glow plug control unit / brake vacuum pump',0),
 (@g,'cabin','30',10,'Additional coolant pump relay, brake light/pedal switch',0),
 (@g,'cabin','31',5,'Fuel pump relay, fuel pressure control valve, coolant pump',0),
 (@g,'cabin','32',15,'Engine CU, clutch pedal position sensor, brake light switch',0),
 (@g,'cabin','33',15,'Ignition coils/transformer, fuel pressure control valve',0),
 (@g,'cabin','34',10,'Radiator fan CU, turbo pressure actuator, canister',0),
 (@g,'cabin','35',5,'CD changer',0),
 (@g,'cabin','36',5,'Radio, TV tuner, telephone, chip card reader',0),
 (@g,'cabin','37',5,'Dashboard panel insert (instrument cluster)',0),
 (@g,'cabin','38',5,'Automatic anti-dazzle rear-view mirror',0),
 (@g,'cabin','39',7,'Radio, information display control unit',0),
 (@g,'cabin','40',5,'Information display control unit',0);

-- SPEC_SOURCES ------------------------------------------------------------------
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fluid_specs' AND ss.spec_id=fluid_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='torque_specs' AND ss.spec_id=torque_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='electrical_specs' AND ss.spec_id=electrical_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='tire_pressures' AND ss.spec_id=tire_pressures.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src FROM fuses WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fuses' AND ss.spec_id=fuses.id AND ss.source_id=@src);
