-- mig 237 — Nissan spec data for Juke F16 (ICE + Hybrid) + Ariya FE0.
-- Extracted from owner manual PDFs in manual_inventory.
--
-- Citation pattern: each spec row is sourced via spec_sources to a `sources`
-- row that carries `manual_inventory_id` pointing at the exact PDF edition,
-- and the spec_sources `page_number` field identifies the page within that PDF.
--
-- Source PDFs used here:
--   inventory_id 10 — Juke MY24 (OM24NL-0F16E1EUR) — 432 pages — Juke ICE specs page 391
--   inventory_id 3  — Juke Hybrid MY22 (OM22NL-HF16E0EUR) — 393 pages — page 361
--   inventory_id 11 — Ariya MY24 (OM24NL-0FE0E4EUR) — 541 pages — page 502

SET NAMES utf8mb4;

-- Generations resolved
SET @g_juke      := (SELECT id FROM generations WHERE slug = 'juke-f16-suv-2019-present');
SET @g_ariya     := (SELECT id FROM generations WHERE slug = 'ariya-fe0-suv-2022-present');

-- ====== Engines used by these gens ======
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('HR10DDT', 'Nissan 1.0 TCe (HR10DDT) 3-cyl turbo', 999, 'petrol', 'turbo', 3),
  ('HR16DE', 'Nissan 1.6 (HR16DE) — Juke Hybrid combustion side', 1598, 'hybrid', 'NA', 4);

SET @e_hr10ddt := (SELECT id FROM engines WHERE code = 'HR10DDT');
SET @e_hr16de  := (SELECT id FROM engines WHERE code = 'HR16DE');

-- ====== Source rows linked to manual_inventory ======
-- Convention from CLAUDE.md mig 216: manufacturer-authored manuals → is_public=1, public_link=0
-- (we cite by name, never link to a redistribute-restricted PDF).

INSERT INTO sources (type, citation, url, manual_inventory_id, retrieved_at, notes, is_public, public_link)
SELECT
  'oem_manual',
  CONCAT('Nissan ', mi.model_year_start, ' ', mi.model, ' Owner''s Manual — Edition ', mi.edition_code),
  NULL, mi.id, NOW(), 'Manufacturer owner manual; NL/EU edition; ingested via scan_manuals.ts.', 1, 0
FROM manual_inventory mi WHERE mi.id IN (10, 3, 11)
  AND NOT EXISTS (SELECT 1 FROM sources s WHERE s.manual_inventory_id = mi.id);

SET @s_juke_my24    := (SELECT id FROM sources WHERE manual_inventory_id = 10);
SET @s_juke_hyb_my22:= (SELECT id FROM sources WHERE manual_inventory_id = 3);
SET @s_ariya_my24   := (SELECT id FROM sources WHERE manual_inventory_id = 11);

-- ====== Juke F16 (ICE HR10DDT) — page 391 of Juke MY24 OM ======

-- engine_oil HR10DDT: ACEA C5 SAE 0W-20, 4.1 L with filter, 3.8 L without
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_juke, 'engine_oil', @e_hr10ddt, 4.1, 4.33, '0W-20', 'ACEA C5 (alt: ACEA C3 SAE 5W-30)', 'With filter change. Without filter: 3.8 L. NISSAN Motor Oil Synthetic Technology 5W-30 C3 alternative.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_juke AND fluid_type = 'engine_oil' AND engine_id = @e_hr10ddt);

-- coolant HR10DDT MT: 6.26 L (incl reservoir)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_juke, 'coolant', @e_hr10ddt, 6.26, 6.62, NULL, 'NISSAN Genuine Engine Coolant L255N', 'MT model incl reservoir. DCT variant: 6.81 L. Expansion tank alone: 1.0 L.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_juke AND fluid_type = 'coolant' AND engine_id = @e_hr10ddt);

-- transmission_mt HR10DDT: NISSAN MT-XZ NFX 75W, 1.35 L
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_juke, 'transmission_mt', @e_hr10ddt, 1.35, 1.43, '75W', 'NISSAN MT-XZ Gear Oil NFX 75W', '6-speed manual transmission.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_juke AND fluid_type = 'transmission_mt' AND engine_id = @e_hr10ddt);

-- transmission_dct HR10DDT: NISSAN DCT Fluid, 4.0 L
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_juke, 'transmission_dct', @e_hr10ddt, 4.0, 4.23, NULL, 'NISSAN DCT Fluid (do not substitute)', 'Dual-clutch automatic. Voids warranty if non-OE fluid used.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_juke AND fluid_type = 'transmission_dct' AND engine_id = @e_hr10ddt);

-- brake_fluid (gen-wide for Juke F16): NISSAN or DOT 4
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_juke, 'brake_fluid', NULL, NULL, NULL, NULL, 'NISSAN Brake Fluid or DOT 4 equivalent', 'Shared between brake and clutch hydraulic circuits.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_juke AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- ac_refrigerant (gen-wide for Juke F16): R1234yf, 450±25 g
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_juke, 'ac_refrigerant', NULL, NULL, NULL, NULL, 'HFO-1234yf (R-1234yf) 450±25 g; A/C oil SP-A2 90 cc', 'GWP 0.501. A/C system oil: NISSAN A/C Type SP-A2 or equivalent.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_juke AND fluid_type = 'ac_refrigerant' AND engine_id IS NULL);

-- ====== Juke F16 Hybrid (HR16DE + electric) — page 361 of Juke Hybrid MY22 OM ======

-- engine_oil HR16DE: NISSAN ACEA C3 SAE 5W-30, 4.8 L with filter, 3.6 L without
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_juke, 'engine_oil', @e_hr16de, 4.8, 5.07, '5W-30', 'ACEA C3 (NISSAN Motor Oil Synthetic Technology 5W-30 C3)', 'Juke Hybrid (HR16DE engine). With filter change. Without filter: 3.6 L.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_juke AND fluid_type = 'engine_oil' AND engine_id = @e_hr16de);

-- coolant HR16DE: NISSAN L255N, hybrid 6.9 L incl reservoir
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_juke, 'coolant', @e_hr16de, 6.9, 7.29, NULL, 'NISSAN Genuine Engine Coolant L255N', 'Hybrid powertrain incl reservoir. Expansion tank alone: 1.0 L. Inverter cooling loop is separate (5.5 L, NISSAN cooling).'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_juke AND fluid_type = 'coolant' AND engine_id = @e_hr16de);

-- transmission for hybrid (eCVT/series-hybrid gearbox): NISSAN hybrid transmission oil, 2.0 L
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_juke, 'transmission_cvt', @e_hr16de, 2.0, 2.11, NULL, 'NISSAN Hybrid Transmission Oil (do not substitute)', 'Juke Hybrid gearbox. Non-OE fluid voids warranty.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_juke AND fluid_type = 'transmission_cvt' AND engine_id = @e_hr16de);

-- ====== Ariya FE0 (BEV) — page 502 of Ariya MY24 OM ======

-- coolant (e-powertrain): 2WD 3.8 L, 4WD 5.8 L incl reservoir
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_ariya, 'coolant', NULL, 3.8, 4.01, NULL, 'NISSAN Genuine Engine Coolant (or equivalent)', '2WD model — e-powertrain coolant loop incl reservoir. 4WD variant: 5.8 L.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_ariya AND fluid_type = 'coolant' AND engine_id IS NULL);

-- battery_coolant — Li-ion thermal mgmt: 2.9 L (new fluid_type)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_ariya, 'battery_coolant', NULL, 2.9, 3.06, NULL, 'NISSAN Genuine Engine Coolant (or equivalent)', 'Lithium-ion battery thermal management loop incl reservoir.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_ariya AND fluid_type = 'battery_coolant' AND engine_id IS NULL);

-- transmission (reduction gear): NISSAN MT-XZ NFX 75W, 0.87 L
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_ariya, 'transmission_at', NULL, 0.87, 0.92, '75W', 'NISSAN MT-XZ Gear Oil NFX 75W', 'Single-speed BEV reduction gear (front motor). Non-OE oil degrades drivetrain — not covered by warranty.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_ariya AND fluid_type = 'transmission_at' AND engine_id IS NULL);

-- differential_rear (4WD only): 0.755 L
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_ariya, 'differential_rear', NULL, 0.755, 0.80, NULL, 'NISSAN final drive oil', 'Rear final drive (4WD models only).'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_ariya AND fluid_type = 'differential_rear' AND engine_id IS NULL);

-- brake_fluid (gen-wide): NISSAN or DOT3/DOT4
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_ariya, 'brake_fluid', NULL, NULL, NULL, NULL, 'NISSAN Brake Fluid or DOT 3 / DOT 4 equivalent', 'Never mix DOT 3 and DOT 4.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_ariya AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- ac_refrigerant: HFO-1234yf, 1050 g (note: heavier than ICE due to heat-pump system)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_ariya, 'ac_refrigerant', NULL, NULL, NULL, NULL, 'HFO-1234yf (R-1234yf) 1.050 kg', 'BEV A/C+heat-pump system uses substantially more refrigerant than ICE vehicles (~2x typical).'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_ariya AND fluid_type = 'ac_refrigerant' AND engine_id IS NULL);

-- ====== spec_sources — link each row to its manual edition + page number ======

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', fs.id, @s_juke_my24, 391
FROM fluid_specs fs
WHERE fs.generation_id = @g_juke AND fs.engine_id = @e_hr10ddt
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table = 'fluid_specs' AND ss.spec_id = fs.id AND ss.source_id = @s_juke_my24);

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', fs.id, @s_juke_my24, 391
FROM fluid_specs fs
WHERE fs.generation_id = @g_juke AND fs.engine_id IS NULL AND fs.fluid_type IN ('brake_fluid','ac_refrigerant')
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table = 'fluid_specs' AND ss.spec_id = fs.id AND ss.source_id = @s_juke_my24);

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', fs.id, @s_juke_hyb_my22, 361
FROM fluid_specs fs
WHERE fs.generation_id = @g_juke AND fs.engine_id = @e_hr16de
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table = 'fluid_specs' AND ss.spec_id = fs.id AND ss.source_id = @s_juke_hyb_my22);

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', fs.id, @s_ariya_my24, 502
FROM fluid_specs fs
WHERE fs.generation_id = @g_ariya
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table = 'fluid_specs' AND ss.spec_id = fs.id AND ss.source_id = @s_ariya_my24);

-- ====== Audit ======
SELECT g.slug, fs.fluid_type,
       COALESCE(e.code, '(gen-wide)') AS engine,
       fs.capacity_l, fs.viscosity, fs.spec_standard
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
LEFT JOIN engines e ON e.id = fs.engine_id
WHERE g.slug IN ('juke-f16-suv-2019-present','ariya-fe0-suv-2022-present')
ORDER BY g.slug, fs.fluid_type, e.code;
