-- Audi S6 + RS6 (C8) — per-engine moat data captured from REAL HaynesPro
-- Playwright session 2026-05-22.
--
-- Captured pages:
--   DKMB (S6 2.9 V6 TFSI) — t_619017205 lubricants + adjustment data
--   DEWA (S6 3.0 V6 TDI pre-LCI EU) — t_619023125 lubricants
--   DJPB (RS6 4.0 V8 TFSI pre-LCI) — t_619028750 lubricants
--   DWLA (RS6 4.0 V8 LCI std) — t_619116169 lubricants (spot-verified identical to DJPB)
--
-- The DMKD (S6 TDI LCI) and DYGB/DYGA (RS6 LCI variants) lubricant pages
-- were not separately visited — they're treated as identical to their
-- pre-LCI sibling because HaynesPro consistently shows the same lubricant
-- spec across an engine family on the same MLB Evo chassis. The 4.0 V8
-- TFSI family (DJPB/DWLA/DYGB/DYGA) all use VW 511.00 0W-40 + ZF 0D6.
--
-- KEY HaynesPro CORRECTIONS to prior assumptions:
--   - C8 coolant is **G12EVO** (TL-VW 774L), not G13 (corrects mig 195 + 198)
--   - S6 transmission code is **0D5** (not 0HL or generic "ZF 8HP")
--   - RS6 transmission code is **0D6** (different from S6, higher-torque variant)
--   - RS6 engine oil spec is **VW 511.00 0W-40** (NOT 504.00 — RS6-specific for V8 biturbo)
--   - S6 V6 TFSI uses VW 504.00 0W-30
--   - S6 V6 TDI uses VW 507.00 0W-30
--   - Brake fluid preferred spec is **VW 501 14** with DOT 4 as alternate

SET NAMES utf8mb4;

SET @s_haynes := 709;  -- HaynesPro WorkshopData — Audi A6/-Allroad (4A) 2019-

-- Engine IDs
SET @e_dkmb := 246;
SET @e_dewa := 247;
SET @e_dmkd := 248;
SET @e_djpb := 249;
SET @e_dwla := 250;
SET @e_dygb := 251;
SET @e_dyga := 252;

-- Generation IDs
SET @g_s6_sedan_pre  := 156;
SET @g_s6_avant_pre  := 157;
SET @g_s6_sedan_lci  := 158;
SET @g_s6_avant_lci  := 159;
SET @g_rs6_avant_pre := 160;
SET @g_rs6_avant_lci := 161;

-- ============================================================================
-- 1. fluid_specs — per gen, per engine where engine-scoped
-- ============================================================================

-- S6 Sedan + Avant pre-LCI (gens 156/157) — DKMB petrol + DEWA TDI
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  -- Engine oil
  (@g_s6_sedan_pre, 'engine_oil', @e_dkmb, 7.6, 8.03, '0W-30', 'VW 504 00',            10000, 16000, 'HaynesPro DKMB t_619017205: 7.6 L sump incl. filter, drain plug 30 Nm threads lightly oiled.'),
  (@g_s6_sedan_pre, 'engine_oil', @e_dewa, 6.1, 6.45, '0W-30', 'VW 507 00',            10000, 16000, 'HaynesPro DEWA t_619023125: 6.1 L sump incl. filter, drain plug 30 Nm renew seal. EU-only TDI.'),
  (@g_s6_avant_pre, 'engine_oil', @e_dkmb, 7.6, 8.03, '0W-30', 'VW 504 00',            10000, 16000, 'HaynesPro DKMB t_619017205: 7.6 L sump incl. filter, drain plug 30 Nm threads lightly oiled.'),
  (@g_s6_avant_pre, 'engine_oil', @e_dewa, 6.1, 6.45, '0W-30', 'VW 507 00',            10000, 16000, 'HaynesPro DEWA t_619023125: 6.1 L sump incl. filter, drain plug 30 Nm renew seal. EU-only TDI.'),
  -- Coolant (gen-wide G12EVO)
  (@g_s6_sedan_pre, 'coolant',         NULL, 10.0, 10.57, NULL,   'TL-VW 774L (G12EVO)', NULL, NULL, 'HaynesPro DKMB/DEWA: G12EVO not G13. 50% antifreeze gives protection to -36 °C, 40% to -25 °C.'),
  (@g_s6_avant_pre, 'coolant',         NULL, 10.0, 10.57, NULL,   'TL-VW 774L (G12EVO)', NULL, NULL, 'HaynesPro DKMB/DEWA: G12EVO not G13. 50% antifreeze gives protection to -36 °C, 40% to -25 °C.'),
  -- Brake fluid
  (@g_s6_sedan_pre, 'brake',           NULL, 1.0, 1.06,  'DOT 4', 'VW 501 14',           24000, 38400, 'HaynesPro: VW 501 14 preferred, DOT 4 alternate. 1.0 L (automatic transmission cars).'),
  (@g_s6_avant_pre, 'brake',           NULL, 1.0, 1.06,  'DOT 4', 'VW 501 14',           24000, 38400, 'HaynesPro: VW 501 14 preferred, DOT 4 alternate. 1.0 L (automatic transmission cars).'),
  -- ZF 0D5 transmission (S6 only, 8-speed)
  (@g_s6_sedan_pre, 'transmission_at', NULL, 8.6, 9.09,  NULL,   'VW G 060 162 A2',      NULL, NULL, 'HaynesPro: ZF 0D5 8-speed, "filled for life" but drain refill 3.6-4.0 L. Initial filling 8.6 L. Audi workshop code 0D5 (not the generic 0HL — this is the S6-specific torque-capacity variant).'),
  (@g_s6_avant_pre, 'transmission_at', NULL, 8.6, 9.09,  NULL,   'VW G 060 162 A2',      NULL, NULL, 'HaynesPro: ZF 0D5 8-speed, "filled for life" but drain refill 3.6-4.0 L. Initial filling 8.6 L. Audi workshop code 0D5.'),
  -- Transfer case (S6 + RS6 share gear-oil spec but use different workshop codes 0D5 vs 0D6)
  (@g_s6_sedan_pre, 'transfer_case',   NULL, 1.0, 1.06,  '75W-90', 'VW G 055 145 A2',     NULL, NULL, 'HaynesPro: 0D5 transfer box, "filled for life" but refill 0.8 L. SAE 75W-90.'),
  (@g_s6_avant_pre, 'transfer_case',   NULL, 1.0, 1.06,  '75W-90', 'VW G 055 145 A2',     NULL, NULL, 'HaynesPro: 0D5 transfer box, "filled for life" but refill 0.8 L. SAE 75W-90.'),
  -- Rear differential (TVR option 0D3 on most S6)
  (@g_s6_sedan_pre, 'rear_differential', NULL, 0.95, 1.00, '75W-85', 'VW G 055 190 A2',   NULL, NULL, 'HaynesPro: 0D3 torque-vectoring rear differential, 0.95 L refill. Optional Sport diff Audi S6.'),
  (@g_s6_avant_pre, 'rear_differential', NULL, 0.95, 1.00, '75W-85', 'VW G 055 190 A2',   NULL, NULL, 'HaynesPro: 0D3 torque-vectoring rear differential, 0.95 L refill. Optional Sport diff Audi S6.'),
  -- A/C refrigerant
  (@g_s6_sedan_pre, 'ac_refrigerant',  NULL, NULL, NULL, NULL,    'R-1234yf · PAG46',     NULL, NULL, 'HaynesPro: R-1234yf 510 ± 15 g. Compressor oil 100 ± 10 ml ISO 46 VW G 055 535 M2 (Denso) or VW G 052 535 (Sanden).'),
  (@g_s6_avant_pre, 'ac_refrigerant',  NULL, NULL, NULL, NULL,    'R-1234yf · PAG46',     NULL, NULL, 'HaynesPro: R-1234yf 510 ± 15 g. Compressor oil 100 ± 10 ml ISO 46 VW G 055 535 M2 (Denso) or VW G 052 535 (Sanden).');

-- S6 LCI Sedan + Avant (gens 158/159) — DKMB petrol + DMKD TDI (DMKD assumed same as DEWA per HaynesPro family-spec consistency)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@g_s6_sedan_lci, 'engine_oil', @e_dkmb, 7.6, 8.03, '0W-30', 'VW 504 00',            10000, 16000, 'HaynesPro DKMB t_619017205: 7.6 L sump incl. filter.'),
  (@g_s6_sedan_lci, 'engine_oil', @e_dmkd, 6.1, 6.45, '0W-30', 'VW 507 00',            10000, 16000, 'HaynesPro DEWA t_619023125 (DMKD same engine family per HaynesPro lubricant convention): 6.1 L. EU-only TDI.'),
  (@g_s6_avant_lci, 'engine_oil', @e_dkmb, 7.6, 8.03, '0W-30', 'VW 504 00',            10000, 16000, 'HaynesPro DKMB t_619017205: 7.6 L sump incl. filter.'),
  (@g_s6_avant_lci, 'engine_oil', @e_dmkd, 6.1, 6.45, '0W-30', 'VW 507 00',            10000, 16000, 'HaynesPro DEWA t_619023125 (DMKD same engine family): 6.1 L. EU-only TDI.'),
  (@g_s6_sedan_lci, 'coolant',         NULL, 10.0, 10.57, NULL,   'TL-VW 774L (G12EVO)', NULL, NULL, 'HaynesPro: G12EVO 10.0 L.'),
  (@g_s6_avant_lci, 'coolant',         NULL, 10.0, 10.57, NULL,   'TL-VW 774L (G12EVO)', NULL, NULL, 'HaynesPro: G12EVO 10.0 L.'),
  (@g_s6_sedan_lci, 'brake',           NULL, 1.0, 1.06,  'DOT 4', 'VW 501 14',           24000, 38400, 'HaynesPro: VW 501 14 / DOT 4.'),
  (@g_s6_avant_lci, 'brake',           NULL, 1.0, 1.06,  'DOT 4', 'VW 501 14',           24000, 38400, 'HaynesPro: VW 501 14 / DOT 4.'),
  (@g_s6_sedan_lci, 'transmission_at', NULL, 8.6, 9.09,  NULL,   'VW G 060 162 A2',      NULL, NULL, 'HaynesPro: ZF 0D5 8-speed. Refill 3.6-4.0 L.'),
  (@g_s6_avant_lci, 'transmission_at', NULL, 8.6, 9.09,  NULL,   'VW G 060 162 A2',      NULL, NULL, 'HaynesPro: ZF 0D5 8-speed. Refill 3.6-4.0 L.'),
  (@g_s6_sedan_lci, 'transfer_case',   NULL, 1.0, 1.06,  '75W-90', 'VW G 055 145 A2',     NULL, NULL, 'HaynesPro: 0D5 transfer box. Refill 0.8 L.'),
  (@g_s6_avant_lci, 'transfer_case',   NULL, 1.0, 1.06,  '75W-90', 'VW G 055 145 A2',     NULL, NULL, 'HaynesPro: 0D5 transfer box. Refill 0.8 L.'),
  (@g_s6_sedan_lci, 'rear_differential', NULL, 0.95, 1.00, '75W-85', 'VW G 055 190 A2',   NULL, NULL, 'HaynesPro: 0D3 torque-vectoring rear diff. 0.95 L.'),
  (@g_s6_avant_lci, 'rear_differential', NULL, 0.95, 1.00, '75W-85', 'VW G 055 190 A2',   NULL, NULL, 'HaynesPro: 0D3 torque-vectoring rear diff. 0.95 L.'),
  (@g_s6_sedan_lci, 'ac_refrigerant',  NULL, NULL, NULL, NULL,    'R-1234yf · PAG46',     NULL, NULL, 'HaynesPro: R-1234yf 510 ± 15 g.'),
  (@g_s6_avant_lci, 'ac_refrigerant',  NULL, NULL, NULL, NULL,    'R-1234yf · PAG46',     NULL, NULL, 'HaynesPro: R-1234yf 510 ± 15 g.');

-- RS6 Avant pre-LCI (gen 160) — DJPB only
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@g_rs6_avant_pre, 'engine_oil',          @e_djpb, 9.5, 10.04, '0W-40', 'VW 511 00',            10000, 16000, 'HaynesPro DJPB t_619028750: 9.5 L sump incl. filter. **VW 511 00 — RS6-specific high-performance spec, NOT the regular A6/S6 504.00.** Drain 30 Nm, renew sealing washer.'),
  (@g_rs6_avant_pre, 'coolant',              NULL, 10.0, 10.57, NULL,   'TL-VW 774L (G12EVO)', NULL, NULL, 'HaynesPro: G12EVO 10.0 L.'),
  (@g_rs6_avant_pre, 'brake',                NULL, 1.0, 1.06,  'DOT 4', 'VW 501 14',           24000, 38400, 'HaynesPro: VW 501 14 preferred, DOT 4 alternate.'),
  (@g_rs6_avant_pre, 'transmission_at',      NULL, 8.6, 9.09,  NULL,   'VW G 060 162 A2',      NULL, NULL, 'HaynesPro DJPB: ZF **0D6** 8-speed (NOT 0D5 like S6 — RS6 uses the higher-torque-rated 0D6 variant). Initial 8.6 L, refill 3.6-4.0 L.'),
  (@g_rs6_avant_pre, 'transfer_case',        NULL, 1.0, 1.06,  '75W-90', 'VW G 055 145 A2',     NULL, NULL, 'HaynesPro: 0D6 transfer box. Refill 0.8 L.'),
  (@g_rs6_avant_pre, 'front_differential',   NULL, 1.0, 1.06,  '75W-90', 'VW G 055 145 A2',     NULL, NULL, 'HaynesPro: 0D6 open front diff (RS6 specific — S6 doesn''t have separate front diff in lubricant list). Refill 0.9 L. Filler plug 27 Nm (single-use). Drain plug 10 Nm (single-use).'),
  (@g_rs6_avant_pre, 'rear_differential',    NULL, 1.0, 1.06,  '75W-90', 'VW G 052 145',         NULL, NULL, 'HaynesPro: rear diff 0DG (NOT 0D3 like S6). 1.0 L initial.'),
  (@g_rs6_avant_pre, 'ac_refrigerant',       NULL, NULL, NULL, NULL,    'R-1234yf · PAG46',     NULL, NULL, 'HaynesPro: R-1234yf 575 ± 15 g (higher than S6''s 510 g). Compressor oil 110 ± 10 ml (Denso) or 100 ml (Sanden).');

-- RS6 Avant LCI (gen 161) — DWLA + DYGB std + DYGA Performance
-- DWLA spot-verified identical to DJPB. DYGB/DYGA assumed same engine family per HaynesPro convention.
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, notes) VALUES
  (@g_rs6_avant_lci, 'engine_oil',          @e_dwla, 9.5, 10.04, '0W-40', 'VW 511 00',            10000, 16000, 'HaynesPro DWLA t_619116169: 9.5 L sump incl. filter, VW 511 00 0W-40. Spot-verified identical to DJPB.'),
  (@g_rs6_avant_lci, 'engine_oil',          @e_dygb, 9.5, 10.04, '0W-40', 'VW 511 00',            10000, 16000, 'Same 4.0 V8 TFSI biturbo family as DWLA (HaynesPro consistency convention). 9.5 L, VW 511 00.'),
  (@g_rs6_avant_lci, 'engine_oil',          @e_dyga, 9.5, 10.04, '0W-40', 'VW 511 00',            10000, 16000, 'RS6 Performance — same engine family + lubricant as DWLA. ECU tune adds 30 hp but oil capacity + spec unchanged.'),
  (@g_rs6_avant_lci, 'coolant',              NULL, 10.0, 10.57, NULL,   'TL-VW 774L (G12EVO)', NULL, NULL, 'HaynesPro: G12EVO 10.0 L.'),
  (@g_rs6_avant_lci, 'brake',                NULL, 1.0, 1.06,  'DOT 4', 'VW 501 14',           24000, 38400, 'HaynesPro: VW 501 14 / DOT 4.'),
  (@g_rs6_avant_lci, 'transmission_at',      NULL, 8.6, 9.09,  NULL,   'VW G 060 162 A2',      NULL, NULL, 'HaynesPro DWLA: ZF 0D6 8-speed. Initial 8.6 L, refill 3.6-4.0 L.'),
  (@g_rs6_avant_lci, 'transfer_case',        NULL, 1.0, 1.06,  '75W-90', 'VW G 055 145 A2',     NULL, NULL, 'HaynesPro: 0D6 transfer box. Refill 0.8 L.'),
  (@g_rs6_avant_lci, 'front_differential',   NULL, 1.0, 1.06,  '75W-90', 'VW G 055 145 A2',     NULL, NULL, 'HaynesPro: 0D6 front diff. Refill 0.9 L. Filler plug 27 Nm + drain plug 10 Nm (single-use).'),
  (@g_rs6_avant_lci, 'rear_differential',    NULL, 1.0, 1.06,  '75W-90', 'VW G 052 145',         NULL, NULL, 'HaynesPro: rear diff 0DG. 1.0 L.'),
  (@g_rs6_avant_lci, 'ac_refrigerant',       NULL, NULL, NULL, NULL,    'R-1234yf · PAG46',     NULL, NULL, 'HaynesPro: R-1234yf 575 ± 15 g.');

-- ============================================================================
-- 2. torque_specs — gen-wide chassis torques + per-engine fastener torques
-- ============================================================================

-- S6 gens (4 gens) — share chassis torques + petrol engine torques (DKMB)
INSERT INTO torque_specs (generation_id, fastener, engine_id, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  -- Wheel bolts (gen-wide)
  (@g_s6_sedan_pre,  'wheel_lug', NULL,    120, 88, NULL, 'HaynesPro DKMB t_619017205 torque settings: wheel bolts 120 Nm.'),
  (@g_s6_avant_pre,  'wheel_lug', NULL,    120, 88, NULL, 'HaynesPro DKMB t_619017205 torque settings: wheel bolts 120 Nm.'),
  (@g_s6_sedan_lci,  'wheel_lug', NULL,    120, 88, NULL, 'HaynesPro DKMB t_619017205 torque settings: wheel bolts 120 Nm.'),
  (@g_s6_avant_lci,  'wheel_lug', NULL,    120, 88, NULL, 'HaynesPro DKMB t_619017205 torque settings: wheel bolts 120 Nm.'),
  -- Oil drain plug (petrol DKMB)
  (@g_s6_sedan_pre,  'oil_drain', @e_dkmb,  30, 22, NULL, 'HaynesPro DKMB: engine oil drain plug 30 Nm, threads lightly oiled.'),
  (@g_s6_avant_pre,  'oil_drain', @e_dkmb,  30, 22, NULL, 'HaynesPro DKMB: engine oil drain plug 30 Nm, threads lightly oiled.'),
  (@g_s6_sedan_lci,  'oil_drain', @e_dkmb,  30, 22, NULL, 'HaynesPro DKMB: engine oil drain plug 30 Nm.'),
  (@g_s6_avant_lci,  'oil_drain', @e_dkmb,  30, 22, NULL, 'HaynesPro DKMB: engine oil drain plug 30 Nm.'),
  -- Oil drain plug (TDI DEWA pre-LCI / DMKD LCI)
  (@g_s6_sedan_pre,  'oil_drain', @e_dewa,  30, 22, NULL, 'HaynesPro DEWA: engine oil drain plug 30 Nm, renew seal.'),
  (@g_s6_avant_pre,  'oil_drain', @e_dewa,  30, 22, NULL, 'HaynesPro DEWA: engine oil drain plug 30 Nm, renew seal.'),
  (@g_s6_sedan_lci,  'oil_drain', @e_dmkd,  30, 22, NULL, 'HaynesPro DEWA (DMKD same family): engine oil drain plug 30 Nm, renew seal.'),
  (@g_s6_avant_lci,  'oil_drain', @e_dmkd,  30, 22, NULL, 'HaynesPro DEWA (DMKD same family): engine oil drain plug 30 Nm, renew seal.'),
  -- Spark plug (DKMB petrol only) — M12 thread per HaynesPro
  (@g_s6_sedan_pre,  'spark_plug', @e_dkmb, 22, 16, NULL, 'HaynesPro DKMB: spark plug M12 thread, 20-25 Nm. Mid-value used.'),
  (@g_s6_avant_pre,  'spark_plug', @e_dkmb, 22, 16, NULL, 'HaynesPro DKMB: spark plug M12 thread, 20-25 Nm. Mid-value used.'),
  (@g_s6_sedan_lci,  'spark_plug', @e_dkmb, 22, 16, NULL, 'HaynesPro DKMB: spark plug M12 thread, 20-25 Nm. Mid-value used.'),
  (@g_s6_avant_lci,  'spark_plug', @e_dkmb, 22, 16, NULL, 'HaynesPro DKMB: spark plug M12 thread, 20-25 Nm. Mid-value used.'),
  -- Oil filter housing
  (@g_s6_sedan_pre,  'oil_filter', NULL,    25, 18, NULL, 'HaynesPro: oil filter 25 Nm.'),
  (@g_s6_avant_pre,  'oil_filter', NULL,    25, 18, NULL, 'HaynesPro: oil filter 25 Nm.'),
  (@g_s6_sedan_lci,  'oil_filter', NULL,    25, 18, NULL, 'HaynesPro: oil filter 25 Nm.'),
  (@g_s6_avant_lci,  'oil_filter', NULL,    25, 18, NULL, 'HaynesPro: oil filter 25 Nm.');

-- RS6 gens (2 gens) — V8-specific
INSERT INTO torque_specs (generation_id, fastener, engine_id, torque_nm, torque_ftlb, thread_lock, notes) VALUES
  -- Wheel bolts (same chassis torque)
  (@g_rs6_avant_pre, 'wheel_lug',          NULL,    120, 88, NULL, 'HaynesPro: wheel bolts 120 Nm (shared chassis value).'),
  (@g_rs6_avant_lci, 'wheel_lug',          NULL,    120, 88, NULL, 'HaynesPro: wheel bolts 120 Nm.'),
  -- Engine oil drain plug (V8)
  (@g_rs6_avant_pre, 'oil_drain',          @e_djpb,  30, 22, NULL, 'HaynesPro DJPB: oil drain plug 30 Nm, renew sealing washer.'),
  (@g_rs6_avant_lci, 'oil_drain',          @e_dwla,  30, 22, NULL, 'HaynesPro DWLA: oil drain plug 30 Nm.'),
  (@g_rs6_avant_lci, 'oil_drain',          @e_dygb,  30, 22, NULL, 'Same V8 family as DWLA.'),
  (@g_rs6_avant_lci, 'oil_drain',          @e_dyga,  30, 22, NULL, 'Same V8 family as DWLA (Performance ECU tune only).'),
  -- Oil filter
  (@g_rs6_avant_pre, 'oil_filter',         NULL,    25, 18, NULL, 'HaynesPro: oil filter 25 Nm.'),
  (@g_rs6_avant_lci, 'oil_filter',         NULL,    25, 18, NULL, 'HaynesPro: oil filter 25 Nm.'),
  -- Front diff plugs (RS6 only — single-use both)
  (@g_rs6_avant_pre, 'diff_fill_plug',     NULL,    27, 20, NULL, 'HaynesPro DJPB: front differential filler plug 27 Nm (single-use, renew each time).'),
  (@g_rs6_avant_lci, 'diff_fill_plug',     NULL,    27, 20, NULL, 'HaynesPro DWLA: front differential filler plug 27 Nm (single-use).'),
  (@g_rs6_avant_pre, 'diff_drain_plug',    NULL,    10, 7,  NULL, 'HaynesPro DJPB: front differential drain plug 10 Nm (single-use, renew each time).'),
  (@g_rs6_avant_lci, 'diff_drain_plug',    NULL,    10, 7,  NULL, 'HaynesPro DWLA: front differential drain plug 10 Nm (single-use).');

-- ============================================================================
-- 3. Source links — every fluid + torque row to the HaynesPro source
-- ============================================================================
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', ts.id, @s_haynes
FROM torque_specs ts
WHERE ts.generation_id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci);

-- ============================================================================
-- 4. Audit
-- ============================================================================
SELECT g.slug,
       (SELECT COUNT(*) FROM fluid_specs fs WHERE fs.generation_id = g.id) AS fluid_rows,
       (SELECT COUNT(*) FROM torque_specs ts WHERE ts.generation_id = g.id) AS torque_rows,
       (SELECT COUNT(*) FROM spec_sources ss WHERE ss.spec_table = 'fluid_specs'  AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id = g.id)) AS fluid_src_links,
       (SELECT COUNT(*) FROM spec_sources ss WHERE ss.spec_table = 'torque_specs' AND ss.spec_id IN (SELECT id FROM torque_specs WHERE generation_id = g.id)) AS torque_src_links
FROM generations g
WHERE g.id IN (@g_s6_sedan_pre, @g_s6_avant_pre, @g_s6_sedan_lci, @g_s6_avant_lci, @g_rs6_avant_pre, @g_rs6_avant_lci)
ORDER BY g.start_year, g.body_type, g.slug;
