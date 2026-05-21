-- Chevrolet Tahoe (T1XX) gen 76, 2021-2024 — per-engine moat refresh.
-- Source: 2021 Chevrolet Tahoe/Suburban Owner's Manual (PDF). Saved at
-- scrapers/manuals/2021-chevy-tahoe-om.pdf. Capacities pp. 398-400.
-- Public citations: Chevrolet Tahoe (T1XX) OM (source 466) + GM aggregator (610).
--
-- Engines (post-dedup):
--   169 6.2 L87 V8     — GM L87 6.2L V8 DI
--   199 5.3 L84 V8 DFM — GM L84 5.3L EcoTec3 V8 DFM
--   171 3.0 Duramax    — GM Duramax 3.0L I6 Diesel

SET NAMES utf8mb4;

SET @gen   := 76;
SET @e_l87 := 169;
SET @e_l84 := 199;
SET @e_lm2 := 171;
SET @s_sm  := 466;
SET @s_gm  := 610;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen;

-- engine_oil per engine
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_l84, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen 3 (full synthetic)', 7500, 12000, 12,
   '5.3L L84 V8 EcoTec3 with DFM (Dynamic Fuel Management 17-mode cylinder deactivation). With-filter sump capacity 7.6 L per 2021 Tahoe OM. dexos1 Gen 3 ONLY.'),
  (@gen, @e_l87, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen 3 (full synthetic)', 7500, 12000, 12,
   '6.2L L87 V8 EcoTec3 Direct-Injection with DFM. With-filter sump capacity 7.6 L per 2021 Tahoe OM.'),
  (@gen, @e_lm2, 'engine_oil', NULL, NULL, '0W-20', 'GM dexos D Gen 2 (low-SAPS diesel) / ACEA C5 alternative', 7500, 12000, 12,
   '3.0L LM2 Duramax I6 Diesel (Tahoe diesel variant). Capacity per Tahoe Duramax supplement; reference ~7.6 L with filter. dexos D required for DPF compatibility.');

-- coolant per engine
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_l84, 'coolant', 14.8, 15.6, 'GM DEX-COOL (orange OAT, 50/50 pre-mix)', '5.3L L84 — 14.8 L total cooling system per 2021 Tahoe OM. Larger than Silverado L84 (chassis-specific cooling).'),
  (@gen, @e_l87, 'coolant', 14.3, 15.1, 'GM DEX-COOL (orange OAT, 50/50 pre-mix)', '6.2L L87 — 14.3 L cooling system per 2021 Tahoe OM.'),
  (@gen, @e_lm2, 'coolant', NULL, NULL, 'GM DEX-COOL (orange OAT) — verify in Duramax supplement', '3.0L LM2 — cooling capacity not in main OM; see Duramax supplement.');

-- transmission_at gen-wide
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transmission_at', NULL, NULL, 'GM DEXRON-HP / Mobil 1 ATF (10L80 10-speed)', 'GM 10L80 10-speed AT. DEXRON-HP spec (higher pressure variant). Total capacity is service-only spec.');

-- gen-wide
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', NULL, NULL, 'GM Genuine DOT 3', 'Brake fluid — DOT 3. Fill as required. 3-year change interval per GM schedule.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transfer_case', 1.5, 1.6, 'GM Auto-Trak II (BorgWarner active TC)', '4WD transfer case — 1.5 L per 2021 Tahoe OM. Auto-Trak II blue synthetic; do NOT substitute generic ATF.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_rear', 1.85, 1.96, 'GM 75W-90 GL-5 synthetic axle lubricant', 'Rear differential — 1.85 L. eLSD variants add GM friction modifier (PN 89021958).');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', 0.85, NULL, 'R-1234yf, PAG46 oil', 'A/C refrigerant 0.85 kg charge per under-hood label.');

-- torque
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, NULL, 'lug_nut', 190, 140, NULL, 'Tahoe T1XX wheel nut torque — 140 lb·ft (190 N·m). Star pattern.');

-- citations
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_rear','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_gm FROM fluid_specs WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_rear','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'torque_specs', id, @s_gm FROM torque_specs WHERE generation_id=@gen;

UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'Tahoe T1XX moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen) AS torques;
