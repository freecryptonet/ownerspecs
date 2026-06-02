-- mig 554 — moat-fill Audi A8 (4H / D4) 2010-2017 (gen 352) via browser HaynesPro (country EU).
-- Facts only (Feist). Reuse vendor-neutral source 811 "Workshop service manual — Audi A8 (4H)" (public_link=0).
-- Per-engine oil (capacity engine-specific). 3.0/4.2 TDI = VW 507 00; 2.0/3.0/4.0/4.2 petrol FSI/TFSI = VW 502 00 (Longlife VW 504 00).
-- Oil filled across all DB engine codes (3.0 TDI: CTBA/CLAA/CTBD/CDTA family = 6.4 L; 3.0 TFSI: CREC/CREA = 6.8 L;
-- 4.0 TFSI: CTGA/CEUA = 8.5 L; 4.2 TDI: CDSB/CTEC = 9.5 L). Brake VW 501 14 (gen-wide).
-- Backfill pending: coolant capacities, tyre pressures, torque tables, fuse boxes.

SET NAMES utf8mb4;
SET @g := 352;
SET @src := 811;

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 (@g,1663,'engine_oil',4.60,'SAE 5W-30','VW 502 00','2.0 TFSI hybrid. With-filter fill; VW 504 00 for Longlife. Drain plug 30 N·m.'),
 (@g,1668,'engine_oil',6.40,'SAE 5W-30','VW 507 00','3.0 V6 TDI. With-filter fill. Drain plug 30 N·m.'),
 (@g,1590,'engine_oil',6.40,'SAE 5W-30','VW 507 00','3.0 V6 TDI. With-filter fill. Drain plug 30 N·m.'),
 (@g,1671,'engine_oil',6.40,'SAE 5W-30','VW 507 00','3.0 V6 TDI. With-filter fill. Drain plug 30 N·m.'),
 (@g,2123,'engine_oil',6.40,'SAE 5W-30','VW 507 00','3.0 V6 TDI. With-filter fill. Drain plug 30 N·m.'),
 (@g,2155,'engine_oil',6.80,'SAE 5W-30','VW 502 00','3.0 TFSI (EA837 evo, supercharged V6). With-filter fill; VW 504 00 for Longlife. Drain plug 30 N·m.'),
 (@g,2156,'engine_oil',6.80,'SAE 5W-30','VW 502 00','3.0 TFSI (EA837 evo, supercharged V6). With-filter fill; VW 504 00 for Longlife. Drain plug 30 N·m.'),
 (@g,1677,'engine_oil',8.50,'SAE 5W-30','VW 502 00','4.0 TFSI (V8 biturbo). With-filter fill; VW 504 00 for Longlife. Drain plug 20 N·m.'),
 (@g,1676,'engine_oil',8.50,'SAE 5W-30','VW 502 00','4.0 TFSI (V8 biturbo). With-filter fill; VW 504 00 for Longlife. Drain plug 20 N·m.'),
 (@g,1679,'engine_oil',9.50,'SAE 5W-30','VW 507 00','4.2 V8 TDI. With-filter fill. Drain plug 30 N·m.'),
 (@g,1680,'engine_oil',9.50,'SAE 5W-30','VW 507 00','4.2 V8 TDI. With-filter fill. Drain plug 30 N·m.'),
 (@g,1678,'engine_oil',7.70,'SAE 5W-30','VW 502 00','4.2 FSI (V8). With-filter fill; VW 504 00 for Longlife. Drain plug 25 N·m.'),
 (@g,NULL,'brake',NULL,NULL,'VW 501 14 / DOT 4','VW 501 14 preferred, DOT 4 alternative.');

INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
 (@g,'H8 (LN5)',520,92,NULL);

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fluid_specs' AND ss.spec_id=fluid_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='electrical_specs' AND ss.spec_id=electrical_specs.id AND ss.source_id=@src);
