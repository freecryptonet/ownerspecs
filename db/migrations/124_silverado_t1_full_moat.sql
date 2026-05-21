-- Chevrolet Silverado 1500 (T1) gen 38, 2019-2024 — per-engine moat refresh.
-- Source: 2022 Chevrolet Silverado 1500 Owner's Manual (PDF) at
-- scrapers/manuals/2022-chevy-silverado1500-om.pdf. Capacity tables pp. 426-428.
-- Public citations: Chevrolet Silverado 1500 (T1) Service Manual (207) + GM
-- Group aggregator (610).
--
-- Engines (post-dedup trim-attached + orphan-but-known):
--   169 6.2 L87 V8         — GM L87 6.2L V8 Direct-Injection
--   197 2.7 TurboMax (L3B) — GM 2.7L L3B Turbo I4 (orphan in trims)
--   198 5.3 L82 V8         — GM L82 5.3L EcoTec3 V8
--   199 5.3 L84 V8 DFM     — GM L84 5.3L EcoTec3 V8 Dynamic Fuel Mgt
--   171 3.0 Duramax        — GM Duramax 3.0L I6 Diesel (orphan in trims)

SET NAMES utf8mb4;

SET @gen     := 38;
SET @e_l87   := 169;
SET @e_l3b   := 197;
SET @e_l82   := 198;
SET @e_l84   := 199;
SET @e_lm2   := 171;
SET @s_sm    := 207;
SET @s_gm    := 610;

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_cvt','transmission_dct','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_cvt','transmission_dct','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen;

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen) AS x);
DELETE FROM parts WHERE generation_id=@gen;

-- =========================================================================
-- engine_oil — per engine. Capacities + spark-plug gaps from 2022 OM.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_l3b, 'engine_oil', 5.7, 6.0, '0W-20', 'GM dexos1 Gen 3 (full synthetic)', 7500, 12000, 12,
   '2.7L L3B Turbo I4 (TurboMax — replaced 4.3L V6 and 2.7L Turbo as base engine MY2022+). With-filter sump capacity 5.7 L per 2022 Silverado OM.'),
  (@gen, @e_l82, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen 3 (full synthetic)', 7500, 12000, 12,
   '5.3L L82 V8 EcoTec3 (NA, no DFM/AFM). With-filter sump capacity 7.6 L per 2022 Silverado OM. Cold-temp alt: 0W-20 below -29 °C is still preferred.'),
  (@gen, @e_l84, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen 3 (full synthetic)', 7500, 12000, 12,
   '5.3L L84 V8 EcoTec3 with Dynamic Fuel Management (17-mode cylinder deactivation). Same sump as L82; identical 7.6 L with-filter capacity.'),
  (@gen, @e_l87, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen 3 (full synthetic)', 7500, 12000, 12,
   '6.2L L87 V8 EcoTec3 Direct-Injection with DFM. With-filter sump capacity 7.6 L per 2022 Silverado OM. dexos1 Gen 3 ONLY — older dexos1 Gen 2 not approved.'),
  (@gen, @e_lm2, 'engine_oil', NULL, NULL, '0W-20', 'GM dexos D Gen 2 (low-SAPS diesel) / ACEA C5 alternative', 7500, 12000, 12,
   '3.0L LM2 Duramax I6 Diesel (Silverado 1500 diesel variant). Capacity per Silverado-Duramax supplement (not in main OM); reference ~7.6 L with filter. dexos D required for DPF compatibility.');

-- =========================================================================
-- coolant — per-engine, OM-verified. Single GM DEX-COOL chemistry across all.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_l3b, 'coolant', 11.8, 12.4, 'GM DEX-COOL (orange OAT, 50/50 pre-mix)', '2.7L L3B — 11.8 L total cooling system per 2022 Silverado OM. Smallest engine in the lineup. Lifetime fill per GM; replace if contaminated.'),
  (@gen, @e_l82, 'coolant', 12.8, 13.5, 'GM DEX-COOL (orange OAT, 50/50 pre-mix)', '5.3L L82 — 12.8 L cooling system. Slightly smaller than L84 (no DFM oil cooler).'),
  (@gen, @e_l84, 'coolant', 13.1, 13.8, 'GM DEX-COOL (orange OAT, 50/50 pre-mix)', '5.3L L84 — 13.1 L cooling system. Includes DFM cooler loop.'),
  (@gen, @e_l87, 'coolant', 12.6, 13.3, 'GM DEX-COOL (orange OAT, 50/50 pre-mix)', '6.2L L87 — 12.6 L cooling system. Less than the 5.3L L84 because the 6.2L uses a different intake-side cooling path.'),
  (@gen, @e_lm2, 'coolant', NULL, NULL, 'GM DEX-COOL (orange OAT) — verify in Duramax diesel supplement', '3.0L LM2 Duramax — cooling system capacity not in main OM; see Duramax supplement. Reference ~13 L with EGR cooler + DPF heat exchanger.');

-- =========================================================================
-- transmission_at — GM Hydra-Matic 10L80 10-speed (8L90 6-speed on early
-- L82). Gen-wide (one ATF spec across all engines).
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transmission_at', NULL, NULL, 'GM DEXRON-VI ATF / Hydra-Matic AFL (PN 88861800)', 'GM 10L80 10-speed AT on 5.3L L84 + 6.2L L87 + 3.0 Duramax; 8L90 8-speed on early L82. Single DEXRON-VI ATF spec across all variants. Total system capacity is service-only spec; not published in OM.');

-- =========================================================================
-- gen-wide: brake fluid + transfer case + diffs + A/C refrigerant
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', NULL, NULL, 'GM Genuine DOT 3 (PN 88958860)', 'Brake fluid — DOT 3 per 2022 Silverado OM. Fill as required. 3-year change interval per GM schedule.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transfer_case', 1.5, 1.6, 'GM Transfer Case Fluid (AutoTrak II / BorgWarner active TC)', '4WD transfer case fluid — 1.5 L total per 2022 Silverado OM. AutoTrak II is the OE blue synthetic fluid; do NOT substitute with generic ATF.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_front', 1.42, 1.5, 'SAE 75W-90 GL-5 synthetic (GM Synthetic Axle Lubricant)', '4WD front differential — 1.42 L. AAM front axle on 1500-series. Service interval 60,000 mi normal, halved for severe duty (towing).'),
  (@gen, NULL, 'differential_rear', 1.66, 1.75, 'SAE 75W-90 GL-5 synthetic (GM Synthetic Axle Lubricant) + GM friction modifier (LSD trims)', 'Rear differential — 1.66 L. AAM 9.5" axle (most trims) or AAM 11.5" on max-tow. eLSD trims require GM friction modifier (PN 89021958) added to the fill.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', 0.79, NULL, 'R-134a (MY2019-2020) / R-1234yf (MY2021+), PAG46 oil', 'A/C refrigerant charge per under-hood label. GM transitioned the Silverado T1 from R-134a to R-1234yf during the gen run.');

-- =========================================================================
-- torque_specs — wheel-nut torque
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, NULL, 'lug_nut', 190, 140, NULL, 'Silverado 1500 wheel nut torque — 140 lb·ft (190 N·m) per 2022 OM. Apply in star pattern.');

-- =========================================================================
-- parts — spark plug PNs not in the 2022 Silverado OM (deferred to a future
-- pass with ACDelco catalogue cross-verification). Gap values captured in
-- the engine_oil notes above as fallback metadata.
-- =========================================================================

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_front','differential_rear','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_gm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_front','differential_rear','ac_refrigerant');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_gm FROM torque_specs WHERE generation_id=@gen;


-- =========================================================================
-- sweep + qt backfill
-- =========================================================================
UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'Silverado T1 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen) AS torques;
