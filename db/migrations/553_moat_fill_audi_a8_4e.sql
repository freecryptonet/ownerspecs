-- mig 553 — moat-fill Audi A8 (4E / D3) 2003-2010 (gen 351) via browser HaynesPro (country EU).
-- Facts only (Feist). Reuse vendor-neutral source 810 "Workshop service manual — Audi A8 (4E)" (public_link=0).
-- Per-engine oil (V6/V8/W12 — capacity is engine-specific). Petrol FSI/V6/V8/W12 = VW 502 00 (Longlife VW 504 00);
-- V6/V8 TDI = VW 505 00/505 01 (BVN 4.2 V8 TDI = VW 507 00). Brake DOT 4 (gen-wide).
-- Backfill pending (D3, larger effort): coolant capacities, torque tables per engine, fuse boxes, wheel-bolt.

SET NAMES utf8mb4;
SET @g := 351;
SET @src := 810;

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 (@g,1648,'engine_oil',6.20,'SAE 5W-30','VW 502 00','2.8 FSI (V6). With-filter fill; VW 504 00 for Longlife. Drain plug 30 N·m.'),
 (@g,1649,'engine_oil',6.30,'SAE 5W-30','VW 502 00','3.0 V6 petrol. With-filter fill; VW 504 00 for Longlife. Drain plug 30 N·m.'),
 (@g,1651,'engine_oil',8.20,'SAE 5W-30','VW 505 01','3.0 V6 TDI. With-filter fill. Drain plug M14 30 N·m / M24 50 N·m.'),
 (@g,1653,'engine_oil',6.50,'SAE 5W-30','VW 502 00','3.2 FSI (V6). With-filter fill; VW 504 00 for Longlife. Drain plug 30 N·m.'),
 (@g,1654,'engine_oil',7.50,'SAE 5W-30','VW 502 00','3.7 V8 petrol. With-filter fill; VW 504 00 for Longlife. Drain plug 50 N·m.'),
 (@g,1655,'engine_oil',9.50,'SAE 5W-30','VW 505 01','4.0 V8 TDI. With-filter fill. Drain plug 50 N·m.'),
 (@g,1656,'engine_oil',7.50,'SAE 5W-30','VW 502 00','4.2 V8 petrol. With-filter fill; VW 504 00 for Longlife. Drain plug 50 N·m.'),
 (@g,1657,'engine_oil',7.50,'SAE 5W-30','VW 502 00','4.2 V8 petrol (FSI). With-filter fill; VW 504 00 for Longlife. Drain plug 50 N·m.'),
 (@g,1660,'engine_oil',9.50,'SAE 5W-30','VW 507 00','4.2 V8 TDI. Refill 9.5 L (initial fill 11.5 L). Drain plug 50 N·m.'),
 (@g,2120,'engine_oil',12.50,'SAE 5W-30','VW 502 00','6.0 W12. With-filter fill; VW 504 00 for Longlife. Drain plug 30 N·m.'),
 (@g,NULL,'brake',NULL,NULL,'DOT 4','Brake/clutch hydraulic fluid.');

INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
 (@g,'H8 (LN5)',520,92,NULL);

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
 (@g,'front','normal',34.8,240,'255/40 R19 100Y'),(@g,'front','full',40.6,280,'255/40 R19 100Y'),
 (@g,'rear','normal',31.9,220,'255/40 R19 100Y'),(@g,'rear','full',43.5,300,'255/40 R19 100Y'),
 (@g,'front','normal',33.4,230,'255/45 R18 99Y'),(@g,'front','full',39.2,270,'255/45 R18 99Y'),
 (@g,'rear','normal',30.5,210,'255/45 R18 99Y'),(@g,'rear','full',42.1,290,'255/45 R18 99Y');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fluid_specs' AND ss.spec_id=fluid_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='electrical_specs' AND ss.spec_id=electrical_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='tire_pressures' AND ss.spec_id=tire_pressures.id AND ss.source_id=@src);
