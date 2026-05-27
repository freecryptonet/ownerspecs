-- mig 506: moat fill for Hyundai i20 II (GB) gen 346 from the Hyundai i20 (GB)
-- Owner's Manual (manufacturer-owned PDF, hyundai.com UK portal). Free public OEM
-- source per Tim 2026-05-27. Citations -> source 1002.
-- Engines: 2061=Kappa 1.0 T-GDI(998), 2059=G4LA 1.25 MPI(1248), 2058=G4LC 1.4 MPI(1368).
-- (Diesels D3FA/D4FC: OM petrol-only section, no oil/coolant data -> left for a diesel OM.)
-- Maintenance-schedule mileage table is deferred to a separate Service Booklet (not in OM)
-- so service_intervals is intentionally left thin (render-gate handles it).

SET @gen := 346;
SET @src := 1002;            -- Hyundai i20 (GB) Owner's Manual
SET @e10 := 2061; SET @e125 := 2059; SET @e14 := 2058;

UPDATE sources SET citation='Hyundai i20 (GB) Owner''s Manual' WHERE id=@src;

-- gen chassis values from OM ch8 (5-door): tracks + fuel tank
UPDATE generations SET front_track_mm=1520, rear_track_mm=1519, fuel_tank_l=50.0 WHERE id=@gen;

-- remove the thin scraper fluid_hints rows (replaced by engine-scoped OM rows)
DELETE FROM spec_sources WHERE spec_table='fluid_specs'
  AND spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=@gen);
DELETE FROM fluid_specs WHERE generation_id=@gen;

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes) VALUES
(@gen,@e10 ,'engine_oil',3.6,3.80,'0W-30','ACEA C2','Drain & refill incl. filter'),
(@gen,@e125,'engine_oil',3.5,3.70,'5W-20','ACEA A5/B5 (API/ILSAC latest)','Drain & refill incl. filter'),
(@gen,@e14 ,'engine_oil',3.5,3.70,'5W-20','ACEA A5/B5 (API/ILSAC latest)','Drain & refill incl. filter'),
(@gen,@e10 ,'coolant',6.4,NULL,NULL,'Ethylene-glycol (long-life, aluminium radiator)',NULL),
(@gen,@e125,'coolant',4.3,NULL,NULL,'Ethylene-glycol (long-life, aluminium radiator)',NULL),
(@gen,@e14 ,'coolant',4.3,NULL,NULL,'Ethylene-glycol (long-life, aluminium radiator)',NULL),
(@gen,@e10 ,'transmission_mt',1.6,NULL,'SAE 70W','API GL-4','6-speed manual (5MT 1.6–1.7 L / 6MT 1.5–1.6 L)'),
(@gen,@e125,'transmission_mt',1.55,NULL,'SAE 70W','API GL-4','Manual transaxle (1.5–1.6 L)'),
(@gen,@e14 ,'transmission_mt',1.65,NULL,'SAE 70W','API GL-4','Manual transaxle (1.6–1.7 L)'),
(@gen,@e10 ,'transmission_dct',1.85,NULL,'SAE 70W','API GL-4 (DCTF 70W)','7-speed dual-clutch (1.8–1.9 L)'),
(@gen,@e14 ,'transmission_at',6.8,7.18,NULL,'ATF SP-III','4-speed automatic transaxle'),
(@gen,NULL ,'brake',0.75,NULL,NULL,'FMVSS116 DOT-3 or DOT-4','Brake & clutch reservoir (0.7–0.8 L)'),
(@gen,NULL ,'ac_refrigerant',NULL,NULL,NULL,'R-1234yf / R-134a','470 ± 25 g charge; PAG compressor oil 110 g');

INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
(@gen,'headlight_low','H4',2,0),
(@gen,'headlight_high','H4',2,0),
(@gen,'front_position','W5W',2,0),
(@gen,'front_turn','PY21W',2,0),
(@gen,'drl','P21W',2,0),
(@gen,'front_fog','H8',2,0),
(@gen,'tail_stop','P21/5W',2,0),
(@gen,'rear_turn','PY21W',2,0),
(@gen,'rear_fog','PR21W',1,0),
(@gen,'reverse','P21W',1,0),
(@gen,'license','W5W',2,0),
(@gen,'high_mount_stop','W5W',1,0),
(@gen,'interior_map','FESTOON',2,0);

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
(@gen,'front','normal',34,235,'185/65 R15'),
(@gen,'rear','normal',31,215,'185/65 R15'),
(@gen,'front','loaded',35,240,'185/65 R15'),
(@gen,'rear','loaded',36,250,'185/65 R15'),
(@gen,'front','normal',34,235,'195/55 R16'),
(@gen,'rear','normal',31,215,'195/55 R16'),
(@gen,'front','normal',34,235,'205/45 R17'),
(@gen,'rear','normal',31,215,'205/45 R17'),
(@gen,'spare','normal',60,420,'T125/80 D15');

INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
(@gen,'wheel_lug',117,86,'OM range 107–127 N·m (11–13 kgf·m)');

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
(@gen,'Interior fuse panel','RR HTD',30,'Rear window defroster',0),
(@gen,'Interior fuse panel','S/HEATER',20,'Driver & passenger seat warmers',0),
(@gen,'Interior fuse panel','SAFETY P/WDW',25,'Driver safety power-window module',0),
(@gen,'Interior fuse panel','T/SIG',15,'Body control module (BCM)',0),
(@gen,'Interior fuse panel','MODULE 6',10,'Data link connector',0),
(@gen,'Interior fuse panel','P/WDW RH',25,'Power-window main switch / passenger switch (LHD)',0),
(@gen,'Interior fuse panel','P/WDW LH',25,'Power-window switch (RHD)',0),
(@gen,'Interior fuse panel','SUNROOF',20,'Sunroof motor',0),
(@gen,'Interior fuse panel','PDM 2',10,'Smart key control module, start/stop button',0),
(@gen,'Interior fuse panel','POWER OUTLET RH',20,'Power outlet (RH)',0),
(@gen,'Interior fuse panel','DR LOCK',20,'Door lock/unlock relays',0),
(@gen,'Interior fuse panel','BRAKE SWITCH',10,'Stop-lamp switch, smart key control module',0),
(@gen,'Interior fuse panel','TCU',15,'Transmission control unit',0),
(@gen,'Interior fuse panel','START',10,'Clutch switch, transaxle range switch, ECM',0),
(@gen,'Interior fuse panel','PDM 1',25,'Smart key control module',0),
(@gen,'Interior fuse panel','HTD MIRR',10,'Heated mirrors, A/C control module',0);

-- citations: every new row -> Hyundai i20 (GB) Owner's Manual (#1002)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'bulbs', id, @src FROM bulbs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fuses', id, @src FROM fuses WHERE generation_id=@gen;
