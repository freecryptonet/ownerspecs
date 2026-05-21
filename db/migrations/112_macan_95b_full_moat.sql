-- Porsche Macan (95B) gen 92, 2014-2018 — per-engine moat backfill.
-- Sourced from HaynesPro WorkshopData (CTLA Turbo 3.6 t_304000059,
-- CTMA S 3.0 t_304000058, CTBA S 3.0 Diesel t_302000363). Cross-verified
-- with VW Group factory oil spec (source 609). Public citations: Porsche
-- Macan (95B) Service Manual (source 545) + VW Group aggregator (609).
--
-- Engines (4 — one is a duplicate row in our engines table):
--   CTLA (eid 146) — Turbo 3.6 V6 TT     294 kW / 400 Hp gasoline
--   CTMA (eid 147) — S 3.0 V6 TT         250 kW / 340 Hp gasoline
--   CTBA (eid 148) — S 3.0 V6 Diesel TT  190 kW / 258 Hp diesel
--   MA2.0T (eid 156) — duplicate of CTMA in our DB (legacy Macan S row);
--                      same physical engine + same fluids as CTMA. We
--                      write identical rows so legacy trim FK joins resolve.
--
-- HaynesPro publishes per-engine fluid specs; the 3.6 TT and 3.0 TT share
-- the Audi 3.0 TFSI engine family bottom-end so oil cap is identical at
-- 8.0 L. Diesel V6 has a smaller 6.4 L sump.

SET NAMES utf8mb4;

SET @gen      := 92;
SET @e_ctla   := 146;
SET @e_ctma   := 147;
SET @e_ctba   := 148;
SET @e_ma2t   := 156;
SET @s_sm     := 545;
SET @s_vwg    := 609;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_rear','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_rear','transfer_case');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain')) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen AND fastener IN ('oil_drain');

-- =========================================================================
-- engine_oil
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_ctla, 'engine_oil', 8.0, 8.5, '0W-40', 'Porsche A40 (ACEA A3/B4)', 10000, 16000, 12,
   '3.6 TT V6 (Audi 4.0 V8 split-block, EA837 family). Wet-sump SUV layout — with-filter capacity 8.0 L per Porsche service data. 0W-40 Porsche A40 preferred all-temperature; 5W-40 / 5W-50 acceptable above -25 °C. Drain plug: 28 Nm.'),
  (@gen, @e_ctma, 'engine_oil', 8.0, 8.5, '0W-40', 'Porsche A40 (ACEA A3/B4)', 10000, 16000, 12,
   '3.0 TT V6 (Audi 3.0 TFSI EA839). Same Macan bottom-end / pan as CTLA; identical 8.0 L with-filter capacity. 0W-40 Porsche A40 preferred all-temperature.'),
  (@gen, @e_ctba, 'engine_oil', 6.4, 6.8, '0W-30', 'Porsche C30 (low-SAPS diesel) / VW 507 00 alternative', 10000, 16000, 12,
   '3.0 TDI V6 (Audi VAG TDI EA897). DPF-equipped diesel — Porsche C30 low-SAPS spec required, 0W-30 or 5W-30 viscosity. Smaller 6.4 L sump than the gasoline V6 variants. Drain plug: 30 Nm.'),
  (@gen, @e_ma2t, 'engine_oil', 8.0, 8.5, '0W-40', 'Porsche A40 (ACEA A3/B4)', 10000, 16000, 12,
   '3.0 TT V6 Macan S (legacy DB engine row coded MA2.0T; same physical engine and fluid spec as CTMA — see notes on CTMA row).');

-- =========================================================================
-- coolant — Glysantin G40 / TL-VW 774G (G12++) across all four engines.
-- HaynesPro does not publish a numeric Macan cooling-system capacity in
-- the accessible lubricants section; left NULL with explanatory note.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_ctla, 'coolant', NULL, NULL, 'Glysantin G40 / TL-VW 774G (G12++)', '3.6 TT — lifetime fill per Porsche. Coolant system capacity is not published as a single number in the accessible workshop data.'),
  (@gen, @e_ctma, 'coolant', NULL, NULL, 'Glysantin G40 / TL-VW 774G (G12++)', '3.0 TT — lifetime fill per Porsche.'),
  (@gen, @e_ctba, 'coolant', NULL, NULL, 'Glysantin G40 / TL-VW 774G (G12++)', '3.0 TDI — adds DPF-protected EGR cooler to the coolant loop; lifetime fill per Porsche.'),
  (@gen, @e_ma2t, 'coolant', NULL, NULL, 'Glysantin G40 / TL-VW 774G (G12++)', 'Macan S (legacy row, same as CTMA).');

-- =========================================================================
-- transmission_dct — 7-speed PDK (7SA)
-- All Macan 95B trims share the 7SA 7-speed PDK. Gear-oil section is the
-- user-facing "transmission fluid"; the hydraulic-control circuit is
-- separate (VW G 055 529 A2, 6.5 L initial).
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_ctla, 'transmission_dct', 4.1, 4.3, '75W-80 VW G 055 532 A2 (7SA PDK gear oil)', 80000, 128000, NULL,
   '7-speed PDK (7SA) gearbox section. Drain refill 4.1 L of 75W-80 G 055 532 A2. Separate hydraulic-control circuit holds VW G 055 529 A2 at 6.5 L. Porsche schedule: full PDK service at 80,000 mi.'),
  (@gen, @e_ctma, 'transmission_dct', 4.1, 4.3, '75W-80 VW G 055 532 A2 (7SA PDK gear oil)', 80000, 128000, NULL,
   '7-speed PDK (7SA) gearbox section, 3.0 TT V6 S.'),
  (@gen, @e_ctba, 'transmission_dct', 4.1, 4.3, '75W-80 VW G 055 532 A2 (7SA PDK gear oil)', 80000, 128000, NULL,
   '7-speed PDK (7SA) gearbox section, 3.0 TDI S Diesel.'),
  (@gen, @e_ma2t, 'transmission_dct', 4.1, 4.3, '75W-80 VW G 055 532 A2 (7SA PDK gear oil)', 80000, 128000, NULL,
   '7-speed PDK (7SA) gearbox section, Macan S (legacy row).');

-- =========================================================================
-- transfer case + rear differential (AWD architecture, shared across all trims)
-- These are NOT engine-scoped — they are gen-wide drivetrain components.
-- We record one row each at gen-wide grain.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transfer_case', 0.58, 0.61, 'Porsche 000 043 305 63 (also Shell TF0870)', 'Macan 95B transfer box — fixed-AWD layout. Filled-for-life per Porsche; replace if contaminated.'),
  (@gen, NULL, 'differential_rear', 1.2, 1.27, '75W-90 Porsche 000 043 305 04 (open diff) / 000 043 305 03 (LSD, 1.45 L)', 'Macan 95B rear differential — 1.2 L on the standard open diff; 1.45 L on the limited-slip variant fitted to Turbo + S optional. Both use 75W-90 Porsche-spec gear oil.');

-- =========================================================================
-- gen-wide brake fluid
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'Porsche/Hydraulan 404 — DOT 4 LV alternative', 'Brake reservoir capacity. DOT 4 LV required for Macan PASM-equipped ABS modulator. Porsche schedule: 2-year change interval.');

-- =========================================================================
-- torque_specs — oil drain plug
-- Gas V6 (CTLA, CTMA, MA2.0T): 28 Nm
-- Diesel V6 (CTBA): 30 Nm
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, @e_ctla, 'oil_drain', 28, 21, NULL, '3.6 TT V6 oil pan drain plug — 28 Nm per Porsche.'),
  (@gen, @e_ctma, 'oil_drain', 28, 21, NULL, '3.0 TT V6 oil pan drain plug — 28 Nm per Porsche.'),
  (@gen, @e_ctba, 'oil_drain', 30, 22, NULL, '3.0 TDI V6 oil pan drain plug — 30 Nm per Porsche (different pan + plug to gas V6).'),
  (@gen, @e_ma2t, 'oil_drain', 28, 21, NULL, '3.0 TT V6 Macan S oil pan drain plug — 28 Nm (legacy row, same as CTMA).');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','transfer_case','differential_rear','brake_fluid');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_vwg FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_dct','transfer_case','differential_rear','brake_fluid');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_vwg FROM torque_specs
   WHERE generation_id=@gen AND fastener IN ('oil_drain');

-- =========================================================================
-- sweep + qt backfill
-- =========================================================================
DELETE fs FROM fluid_specs fs
WHERE fs.generation_id = @gen
  AND fs.fluid_type IN ('engine_oil','coolant')
  AND fs.viscosity IS NULL AND fs.spec_standard IS NULL
  AND EXISTS (
    SELECT 1 FROM fluid_specs fr
    WHERE fr.generation_id = fs.generation_id
      AND fr.fluid_type   = fs.fluid_type
      AND fr.id != fs.id
      AND fr.spec_standard IS NOT NULL
  );

UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'Macan 95B moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_torques;
