-- Cadillac Escalade (T1XX) gen 100, 2021-2024 — per-engine moat refresh.
-- Source: 2022 Cadillac Escalade Owner's Manual (PDF). Saved at
-- scrapers/manuals/2022-cadillac-escalade-om.pdf. Capacities pp. 468-470.
-- Public citations: Cadillac Escalade V (T1XX) OM (source 576) + GM aggregator (610).
--
-- Engines (already canonical — no dedup repointing needed):
--   169 6.2 L87 V8     — GM L87 6.2L V8 DI (standard Escalade)
--   170 6.2 LT4 SC     — GM LT4 6.2L Supercharged V8 (Escalade-V)
--   171 3.0 Duramax    — GM Duramax 3.0L I6 Diesel

SET NAMES utf8mb4;

SET @gen   := 100;
SET @e_l87 := 169;
SET @e_lt4 := 170;
SET @e_lm2 := 171;
SET @s_sm  := 576;
SET @s_gm  := 610;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen;

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_l87, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen 3 (full synthetic)', 7500, 12000, 12,
   '6.2L L87 V8 EcoTec3 DI with DFM (standard Escalade Luxury / Premium Luxury / Sport / Sport Platinum). With-filter sump 7.6 L per 2022 Cadillac Escalade OM. dexos1 Gen 3 ONLY.'),
  (@gen, @e_lt4, 'engine_oil', 9.5, 10.0, '0W-40', 'GM dexos1 Gen 3 / Mobil 1 0W-40 Full Synthetic (LT4-specific)', 5000, 8000, 6,
   '6.2L LT4 Supercharged V8 (Escalade-V, 682 Hp). Capacity per Escalade-V supplement; reference ~9.5 L with filter. LT4 uses heavier 0W-40 for supercharger heat tolerance — do NOT substitute the 0W-20 used in the L87. Severe-duty change interval (5,000 mi).'),
  (@gen, @e_lm2, 'engine_oil', NULL, NULL, '0W-20', 'GM dexos D Gen 2 (low-SAPS diesel) / ACEA C5 alternative', 7500, 12000, 12,
   '3.0L LM2 Duramax I6 Diesel (Escalade diesel variant). Capacity per Escalade-Duramax supplement; reference ~7.6 L with filter. dexos D required for DPF compatibility.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_l87, 'coolant', 14.3, 15.1, 'GM DEX-COOL (orange OAT, 50/50 pre-mix)', '6.2L L87 — 14.3 L total cooling system per 2022 Escalade OM.'),
  (@gen, @e_lt4, 'coolant', NULL, NULL, 'GM DEX-COOL (orange OAT)', 'LT4 SC — Escalade-V supplement covers; supercharger intercooler loop is separate from main coolant.'),
  (@gen, @e_lm2, 'coolant', NULL, NULL, 'GM DEX-COOL (orange OAT) — verify in Duramax supplement', '3.0L LM2 — cooling capacity not in main Escalade OM.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transmission_at', NULL, NULL, 'GM DEXRON-HP / Mobil 1 ATF (GM 10L80 10-speed)', 'GM 10L80 10-speed AT (or 10L90 on LT4 Escalade-V). DEXRON-HP spec.'),
  (@gen, NULL, 'brake_fluid', NULL, NULL, 'GM Genuine DOT 3', 'Brake fluid — DOT 3.'),
  (@gen, NULL, 'transfer_case', 1.5, 1.6, 'GM Auto-Trak II', '4WD transfer case — 1.5 L per 2022 Escalade OM.'),
  (@gen, NULL, 'differential_rear', 1.5, 1.6, 'GM 75W-90 GL-5 synthetic axle lubricant', 'Rear differential — 1.5 L per 2022 Escalade OM (mechanical limited slip) / 1.5 L (electronic limited slip). eLSD variants add GM friction modifier.'),
  (@gen, NULL, 'ac_refrigerant', 0.75, NULL, 'R-1234yf, PAG46 oil', 'A/C refrigerant 0.75 kg charge per under-hood label.');

INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, NULL, 'lug_nut', 190, 140, NULL, 'Escalade T1XX wheel nut torque — 140 lb·ft (190 N·m). Star pattern.');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_rear','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_gm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_rear','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs', id, @s_gm FROM torque_specs WHERE generation_id=@gen;

UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'Escalade T1XX moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen) AS torques;
