-- Ford F-150 (P702) gen 26, 2021-2025 — per-engine moat refresh.
-- Source: 2022 Ford F-150 Owner's Manual (PDF, official Ford content
-- mirrored at startmycar.com) — saved at scrapers/manuals/2022-ford-f150-om.pdf.
-- Capacity tables from pp. 568-595 (Capacities and Specifications).
--
-- This migration replaces the pre-dedup pickup data (gen-wide-only rows
-- using legacy fluid_type names like 'brake' / 'front_differential') with
-- per-engine values keyed to canonical engine IDs and using the
-- STRUCTURE.md-mandated fluid_type vocabulary (brake_fluid /
-- differential_front / differential_rear).
--
-- Public citations: Ford F-150 (P702) Service Manual (source 130) +
-- Ford F-150 service spec aggregator (source 602).
--
-- Engines (now post-dedup trim-attached, plus orphan-but-known variants):
--   39  Predator        — 5.2L supercharged V8 (Raptor R, MY2023+ — not in
--                          the 2022 OM; data deferred to a 2023 OM pass)
--   172 3.5 EcoBoost    — Ford 3.5L EcoBoost Twin-Turbo V6 (Raptor + std)
--   184 2.7 EcoBoost    — Ford 2.7L EcoBoost Twin-Turbo V6 (orphan in our
--                          trims but present in fluid_specs from prior seed)
--   185 5.0 Coyote      — Ford 5.0L Coyote V8 (Gen 3)
--   186 3.5 PowerBoost  — Ford 3.5L EcoBoost PowerBoost Hybrid V6

SET NAMES utf8mb4;

SET @gen        := 26;
SET @e_predator := 39;
SET @e_35eb     := 172;
SET @e_27eb     := 184;
SET @e_50coyote := 185;
SET @e_35pb     := 186;
SET @s_sm       := 130;   -- Ford F-150 (P702) Service Manual
SET @s_ford     := 602;   -- Ford F-150 service spec aggregator

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_cvt','transmission_dct','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_cvt','transmission_dct','brake','brake_fluid','ac_refrigerant','front_differential','rear_differential','differential_front','differential_rear','transfer_case');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen;

-- =========================================================================
-- engine_oil — per-engine. Capacities + viscosities + Motorcraft Ford specs
-- from the 2022 F-150 OM Capacities chapter.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_27eb, 'engine_oil', 5.7, 6.0, '5W-30', 'Ford WSS-M2C961-A1 (Motorcraft 5W-30 synthetic blend, XO-5W30-Q1SP)', 10000, 16000, 12,
   '2.7L EcoBoost Twin-Turbo V6 (Nano family). With-filter sump capacity 5.7 L per 2022 F-150 OM Section 17. Cold-temperature alt: SAE 0W-30 WSS-M2C963-A1 below -30 °C. Motorcraft is OE; off-the-shelf 5W-30 with API SP Resource Conserving + WSS-M2C961-A1 license is acceptable.'),
  (@gen, @e_35eb, 'engine_oil', 5.7, 6.0, '5W-30', 'Ford WSS-M2C961-A1 (Motorcraft 5W-30 synthetic blend)', 10000, 16000, 12,
   '3.5L EcoBoost Twin-Turbo V6 (Nano family, base + Raptor 450 Hp). With-filter sump capacity 5.7 L per 2022 F-150 OM. Cold alt: 0W-30 WSS-M2C963-A1. Same Motorcraft spec as the 2.7L EcoBoost.'),
  (@gen, @e_35pb, 'engine_oil', 5.7, 6.0, '5W-30', 'Ford WSS-M2C961-A1 (Motorcraft 5W-30 synthetic blend)', 10000, 16000, 12,
   '3.5L EcoBoost PowerBoost Hybrid V6 (HEV). With-filter sump capacity 5.7 L per 2022 F-150 OM — same as ICE 3.5 EB. Cold alt: 0W-30. PowerBoost adds a 35 kW motor-generator between the engine and the 10R80 transmission.'),
  (@gen, @e_50coyote, 'engine_oil', 7.33, 7.75, '5W-30', 'Ford WSS-M2C961-A1 (Motorcraft 5W-30 synthetic blend)', 10000, 16000, 12,
   '5.0L Coyote V8 (Gen 3, Ti-VCT, port + direct injection). With-filter sump capacity 7.33 L / 7.75 US qt — significantly larger than the EcoBoost variants. Cold alt: 0W-30 WSS-M2C963-A1.'),
  (@gen, @e_predator, 'engine_oil', NULL, NULL, '5W-50', 'Ford WSS-M2C931-C (Motorcraft 5W-50 full synthetic)', 5000, 8000, 6,
   '5.2L Predator Supercharged V8 (Raptor R, MY2023+). The 2022 F-150 OM does not include the Raptor R (launched MY2023); capacity not published in accessible Ford documentation for the F-150 application. Reference value from the GT500 application (same engine): 6.2 US qt with filter. Severe-duty 5W-50 required.');

-- =========================================================================
-- coolant — per-engine. Capacities vary by chassis cooling-system spec.
-- All variants use Motorcraft Yellow Prediluted Antifreeze/Coolant
-- WSS-M97B57-A2 (OAT chemistry).
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_27eb, 'coolant', 14.3, 15.1, 'Motorcraft Yellow Prediluted (WSS-M97B57-A2, VC-13DL-G)', '2.7L EcoBoost — 14.3 L total cooling system per 2022 F-150 OM. OAT yellow chemistry; never substitute with green silicate IAT or older Motorcraft Orange.'),
  (@gen, @e_35eb, 'coolant', 13.5, 14.3, 'Motorcraft Yellow Prediluted (WSS-M97B57-A2, VC-13DL-G)', '3.5L EcoBoost — 13.5 L cooling system. Raptor variant takes 13.0 L (slightly smaller — different shroud).'),
  (@gen, @e_35pb, 'coolant', 14.5, 15.3, 'Motorcraft Yellow Prediluted (WSS-M97B57-A2, VC-13DL-G)', '3.5L PowerBoost HEV — high-temp cooling circuit 14.5 L (engine + electric drive) + separate low-temp circuit 6.8 L (battery + power electronics). Total 21.3 L across both loops.'),
  (@gen, @e_50coyote, 'coolant', 12.5, 13.2, 'Motorcraft Yellow Prediluted (WSS-M97B57-A2, VC-13DL-G)', '5.0L Coyote — 12.5 L cooling system.'),
  (@gen, @e_predator, 'coolant', NULL, NULL, 'Motorcraft Yellow Prediluted (WSS-M97B57-A2, VC-13DL-G)', '5.2L Predator (Raptor R) — capacity not in 2022 F-150 OM; deferred. Coolant chemistry same as the rest of the lineup.');

-- =========================================================================
-- transmission_at — Ford 10R80 10-speed AT (gen-wide on all P702 trims
-- except PowerBoost which uses the 10R80 modular hybrid variant).
-- Total fluid capacity is service-only spec; not published in OM.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transmission_at', NULL, NULL, 'Motorcraft MERCON ULV (WSS-M2C949-A, XT-12-QULV)', 'Ford 10R80 10-speed automatic transmission (or 10R80 MHT on the PowerBoost HEV). Total fluid capacity is a service-only spec; not published in the owner manual. Service-drain refill ~6 US qt.');

-- =========================================================================
-- gen-wide: brake_fluid, transfer_case, differential_front, differential_rear,
-- ac_refrigerant. Values from 2022 F-150 OM Capacities chapter.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', NULL, NULL, 'Motorcraft DOT 4 LV (WSS-M6C65-A2 / ISO 4925 Class 6, PM-20)', 'Brake fluid — DOT 4 LV (Low Viscosity) required for the F-150 P702 ABS/AdvanceTrac module. The OM specifies "fill as required" — total system capacity not published.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transfer_case', 1.4, 1.5, 'Motorcraft MERCON LV (WSS-M2C938-A, XT-10-QLVC)', '4WD transfer case fluid. Capacities by transfer-case variant: 1.4 L Electronic Shift on Fly + 1.4 L Automatic 4WD (Torque on Demand). The 2-speed Mechanical Lock variant + Raptor 2-speed take 1.8 L. Single MERCON LV ATF spec across all variants.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_front', 1.7, 1.8, 'Motorcraft SAE 75W-85 Synthetic Hypoid (WSS-M2C942-A, XY-75W85-QL)', '4WD front axle. Standard front axle 1.7 L; Torsen limited-slip front axle 1.55 L (Raptor) — add 118.5 mL of Motorcraft XL-3 Friction Modifier (EST-M2C118-A) to the LSD variant.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_rear', 2.0, 2.1, 'Motorcraft SAE 75W-85 Synthetic Hypoid (WSS-M2C942-A, XY-75W85-QL)', 'Rear axle. 8.8 inch ring gear: 1.9–2.0 L. 9.75 inch ring gear: 2.1–2.2 L (most XL/XLT/Lariat/King Ranch/Platinum trims). Raptor 9.75 inch: 2.36–2.44 L (larger sump). Police Responder 9.75 inch: 2.1–2.2 L.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', 0.74, NULL, 'R-1234yf, Motorcraft PAG oil YN-35-G', 'A/C refrigerant charge 0.74 kg (1.63 lb) per under-hood label. PowerBoost HEV uses an integrated heat-pump system with shared refrigerant loop for cabin HVAC + HV-battery thermal management.');

-- =========================================================================
-- torque_specs — wheel-nut torque (gen-wide)
-- =========================================================================
INSERT INTO torque_specs(generation_id, engine_id, fastener, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  (@gen, NULL, 'lug_nut', 204, 150, NULL, 'F-150 P702 wheel nut torque — 150 lb·ft (204 N·m) per 2022 F-150 OM. Apply in star pattern with the vehicle on the ground.');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_front','differential_rear','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_ford FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_at','brake_fluid','transfer_case','differential_front','differential_rear','ac_refrigerant');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_sm FROM torque_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s_ford FROM torque_specs WHERE generation_id=@gen;

-- =========================================================================
-- sweep + qt backfill
-- =========================================================================
UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'F-150 P702 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM torque_specs WHERE generation_id=@gen) AS torques;
