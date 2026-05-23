-- mig 238 — Nissan spec data for Qashqai J12 + X-Trail T33 e-Power.
-- Both vehicles share the KR15DDT 1.5L VC-Turbo engine acting as a generator
-- in NISSAN's e-Power series hybrid system — the wheels are driven exclusively
-- by the electric motor, the engine never drives the wheels directly.
--
-- Citation pattern: spec_sources.page_number identifies the page within each
-- OM PDF (manual_inventory rows).
--
-- Source PDFs:
--   inventory_id 12 — Qashqai MY24 (OM24NL-HT33E1EUR) — 525 pages — appendix page 484-486
--   inventory_id 8  — X-Trail MY23 (OM23NL-HJ12E0EUR) — 554 pages — appendix page 508-510
--
-- Engine_oil + coolant capacity NOT FILLED in this migration — the visible
-- spec appendix on these e-Power OMs focuses on the e-drive components
-- (reduction gear, A/C, brakes) rather than the ICE generator. Add those
-- in a follow-up once a different chapter is dumped, or once HaynesPro
-- adds these chassis (currently they don't have Nissan in workshopdata).

SET NAMES utf8mb4;

SET @g_qashqai := (SELECT id FROM generations WHERE slug = 'qashqai-j12-suv-2021-present');
SET @g_xtrail  := (SELECT id FROM generations WHERE slug = 'x-trail-t33-suv-2022-present');

-- ====== Engines ======
-- KR15DDT VC-Turbo (variable compression 8:1–14:1, so displacement varies 1477–1497 cc)
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('KR15DDT', 'Nissan 1.5 VC-Turbo (KR15DDT) e-Power 3-cyl', 1497, 'hybrid', 'turbo', 3);
SET @e_kr15ddt := (SELECT id FROM engines WHERE code = 'KR15DDT');

-- ====== Source rows ======
INSERT INTO sources (type, citation, url, manual_inventory_id, retrieved_at, notes, is_public, public_link)
SELECT
  'oem_manual',
  CONCAT('Nissan ', mi.model_year_start, ' ', mi.model, ' Owner''s Manual — Edition ', mi.edition_code),
  NULL, mi.id, NOW(), 'Manufacturer owner manual; NL/EU edition; ingested via scan_manuals.ts.', 1, 0
FROM manual_inventory mi WHERE mi.id IN (12, 8)
  AND NOT EXISTS (SELECT 1 FROM sources s WHERE s.manual_inventory_id = mi.id);

SET @s_qashqai_my24  := (SELECT id FROM sources WHERE manual_inventory_id = 12);
SET @s_xtrail_my23   := (SELECT id FROM sources WHERE manual_inventory_id = 8);

-- ====== Qashqai J12 e-Power (KR15DDT) — page 484-487 of MY24 OM ======

-- engine_oil viscosity (no capacity in the spec appendix — page 486 only lists viscosity guidance)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_qashqai, 'engine_oil', @e_kr15ddt, NULL, NULL, '0W-20', 'NISSAN ACEA-C-class (Qashqai e-Power)', 'KR15DDT VC-Turbo. 0W-20 preferred; alternative viscosities per ambient-temperature chart on page 486. Capacity not listed in OM spec appendix — consult dealer / service manual.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_qashqai AND fluid_type = 'engine_oil' AND engine_id = @e_kr15ddt);

-- transmission_at (e-Power reduction gear)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_qashqai, 'transmission_at', @e_kr15ddt, 1.54, 1.63, NULL, 'NISSAN Matic S ATF (do not substitute)', 'e-Power single-speed reduction gear. Non-OE fluid voids warranty.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_qashqai AND fluid_type = 'transmission_at' AND engine_id = @e_kr15ddt);

-- brake_fluid (gen-wide)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_qashqai, 'brake_fluid', NULL, NULL, NULL, NULL, 'NISSAN Brake Fluid or DOT 4 (FMVSS 116)', NULL
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_qashqai AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- ac_refrigerant (EU spec — HFO-1234yf)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_qashqai, 'ac_refrigerant', NULL, NULL, NULL, NULL, 'HFO-1234yf (R-1234yf) — EU. Non-EU: HFC-134a. A/C oil RB100EV (POE).', 'Capacity per OM table on page 484: ~500-550 g range.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_qashqai AND fluid_type = 'ac_refrigerant' AND engine_id IS NULL);

-- ====== X-Trail T33 e-Power (KR15DDT) — page 508-510 of MY23 OM ======

-- engine_oil viscosity (capacity missing)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_xtrail, 'engine_oil', @e_kr15ddt, NULL, NULL, '0W-20', 'NISSAN ACEA-C-class (X-Trail e-Power)', 'KR15DDT VC-Turbo. 0W-20 preferred; alternative viscosities per ambient-temperature chart. Capacity not listed in OM spec appendix.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_xtrail AND fluid_type = 'engine_oil' AND engine_id = @e_kr15ddt);

-- transmission_at (e-Power reduction gear, identical to Qashqai)
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_xtrail, 'transmission_at', @e_kr15ddt, 1.54, 1.63, NULL, 'NISSAN Matic S ATF (do not substitute)', 'e-Power single-speed reduction gear. Non-OE fluid voids warranty.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_xtrail AND fluid_type = 'transmission_at' AND engine_id = @e_kr15ddt);

-- brake_fluid
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_xtrail, 'brake_fluid', NULL, NULL, NULL, NULL, 'NISSAN Brake Fluid or DOT 4 (FMVSS 116)', NULL
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_xtrail AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- ac_refrigerant
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT @g_xtrail, 'ac_refrigerant', NULL, NULL, NULL, NULL, 'HFO-1234yf (R-1234yf) 550 g — EU. Non-EU: HFC-134a 500 g.', 'A/C system oil: NISSAN SP-A2 or equivalent.'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = @g_xtrail AND fluid_type = 'ac_refrigerant' AND engine_id IS NULL);

-- ====== spec_sources — link to manual editions ======
INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', fs.id, @s_qashqai_my24,
  CASE fs.fluid_type WHEN 'engine_oil' THEN 486 WHEN 'transmission_at' THEN 485 ELSE 484 END
FROM fluid_specs fs
WHERE fs.generation_id = @g_qashqai
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table = 'fluid_specs' AND ss.spec_id = fs.id AND ss.source_id = @s_qashqai_my24);

INSERT INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', fs.id, @s_xtrail_my23,
  CASE fs.fluid_type WHEN 'engine_oil' THEN 510 WHEN 'transmission_at' THEN 509 ELSE 508 END
FROM fluid_specs fs
WHERE fs.generation_id = @g_xtrail
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table = 'fluid_specs' AND ss.spec_id = fs.id AND ss.source_id = @s_xtrail_my23);

-- ====== Audit ======
SELECT g.slug, fs.fluid_type,
       COALESCE(e.code, '(gen-wide)') AS engine,
       fs.capacity_l, fs.viscosity, fs.spec_standard
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
LEFT JOIN engines e ON e.id = fs.engine_id
WHERE g.slug IN ('qashqai-j12-suv-2021-present','x-trail-t33-suv-2022-present')
ORDER BY g.slug, fs.fluid_type;
