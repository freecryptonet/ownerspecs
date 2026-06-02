-- mig 555 — A8 (4E/4H) backfill (coolant + torques) + engine-page enrichment (cylinders).
-- Browser HaynesPro (country EU), facts only. Sources: 810 (A8 4E), 811 (A8 4H).
-- Pairs with the engine-page render fix (oil capacity now shows capacity_l alone, matched per-engine).
-- DEFERRED (format-heavy, follow-up): A8 fuse boxes (D3/D4 split across many boxes), 4H coolant
--   capacities (different adjustment-page layout), per-family engine torques beyond cylinder-head.

SET NAMES utf8mb4;

-- ===========================================================================
-- 1. CYLINDERS — derivable from engine layout; fixes the "—-cylinder" on every
--    A1 8X / A8 engine page. (Catalog spec on engines; not citation-gated.)
-- ===========================================================================
-- A1 8X (350): all 4-cylinder
UPDATE engines SET cylinders=4 WHERE id IN (2160,2161,2162,2079,2077,2159,2158,2078,1722,1728,1298,1299,2157,1730,2076) AND cylinders IS NULL;
-- A8 4E (351): V6 / V8 / W12
UPDATE engines SET cylinders=6  WHERE id IN (1648,1649,1651,1653) AND cylinders IS NULL;
UPDATE engines SET cylinders=8  WHERE id IN (1654,1655,1656,1657,1660) AND cylinders IS NULL;
UPDATE engines SET cylinders=12 WHERE id IN (2120) AND cylinders IS NULL;
-- A8 4H (352): I4 / V6 / V8
UPDATE engines SET cylinders=4 WHERE id IN (1663) AND cylinders IS NULL;
UPDATE engines SET cylinders=6 WHERE id IN (1668,1590,1671,2123,2155,2156) AND cylinders IS NULL;
UPDATE engines SET cylinders=8 WHERE id IN (1677,1676,1679,1680,1678) AND cylinders IS NULL;

-- ===========================================================================
-- 2. A8 4E (351) coolant capacities — engine-scoped. Era coolant = G12 class
--    (TL-VW 774 D/F). Capacities extracted per engine family.
-- ===========================================================================
SET @g4e := 351;
SET @s4e := 810;
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 (@g4e,1648,'coolant',12.0,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (V6 FSI).'),
 (@g4e,1649,'coolant',12.0,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (V6 petrol).'),
 (@g4e,1653,'coolant',12.0,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (V6 FSI).'),
 (@g4e,1654,'coolant',11.5,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (V8 petrol).'),
 (@g4e,1656,'coolant',11.5,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (V8 petrol).'),
 (@g4e,1657,'coolant',11.5,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (V8 petrol).'),
 (@g4e,1651,'coolant',15.8,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (3.0 V6 TDI).'),
 (@g4e,1655,'coolant',14.9,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (V8 TDI).'),
 (@g4e,1660,'coolant',14.9,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (V8 TDI).'),
 (@g4e,2120,'coolant',17.9,NULL,'G12 / G12+ (TL-VW 774 D/F)','System capacity (6.0 W12).');

-- ===========================================================================
-- 3. A8 4E (351) torques — cylinder-head per family (engine-scoped) + V6 FSI
--    ancillary torques (extracted from the 3.2 FSI).
-- ===========================================================================
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, notes) VALUES
 (@g4e,1648,'cylinder_head_bolt',40,'V6 FSI. Renew bolts. Stage 1: 40 N·m; stage 2: +90°; stage 3: +90°.'),
 (@g4e,1649,'cylinder_head_bolt',40,'V6 petrol. Renew bolts. Stage 1: 40 N·m; +90°; +90°.'),
 (@g4e,1653,'cylinder_head_bolt',40,'V6 FSI. Renew bolts. Stage 1: 40 N·m; +90°; +90°.'),
 (@g4e,1654,'cylinder_head_bolt',30,'V8 petrol. Renew bolts. Stage 1: 30 N·m; stage 2: 60 N·m; further angle stages.'),
 (@g4e,1656,'cylinder_head_bolt',30,'V8 petrol. Renew bolts. Stage 1: 30 N·m; stage 2: 60 N·m; further angle stages.'),
 (@g4e,1657,'cylinder_head_bolt',30,'V8 petrol. Renew bolts. Stage 1: 30 N·m; stage 2: 60 N·m; further angle stages.'),
 (@g4e,1651,'cylinder_head_bolt',35,'3.0 V6 TDI. Renew bolts. Stage 1: 35 N·m; further angle stages.'),
 (@g4e,1655,'cylinder_head_bolt',35,'V8 TDI. Renew bolts. Stage 1: 35 N·m; further angle stages.'),
 (@g4e,1660,'cylinder_head_bolt',35,'V8 TDI. Renew bolts. Stage 1: 35 N·m; further angle stages.'),
 (@g4e,2120,'cylinder_head_bolt',30,'6.0 W12. Renew bolts. Stage 1: 30 N·m; further angle stages.'),
 (@g4e,1648,'oil_filter',25,'V6 FSI oil filter housing.'),
 (@g4e,1649,'oil_filter',25,'V6 oil filter housing.'),
 (@g4e,1653,'oil_filter',25,'V6 FSI oil filter housing.'),
 (@g4e,1653,'oxygen_sensor',55,'V6 FSI.'),
 (@g4e,1653,'starter_motor',65,'V6 FSI.'),
 (@g4e,1653,'alternator',22,'V6 FSI.');

-- ===========================================================================
-- 4. A8 4H (352) — wheel-bolt torque (gen-wide chassis; non-PAX = 120 N·m).
-- ===========================================================================
SET @g4h := 352;
SET @s4h := 811;
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, notes) VALUES
 (@g4h,NULL,'wheel_bolt',120,'Without PAX run-flat system. Do not use power tools to run the bolts in.');

-- ===========================================================================
-- 5. spec_sources
-- ===========================================================================
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s4e FROM fluid_specs WHERE generation_id=@g4e AND fluid_type='coolant'
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fluid_specs' AND ss.spec_id=fluid_specs.id AND ss.source_id=@s4e);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @s4e FROM torque_specs WHERE generation_id=@g4e
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='torque_specs' AND ss.spec_id=torque_specs.id AND ss.source_id=@s4e);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @s4h FROM torque_specs WHERE generation_id=@g4h
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='torque_specs' AND ss.spec_id=torque_specs.id AND ss.source_id=@s4h);
