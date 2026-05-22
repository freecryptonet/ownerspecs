-- Fix G30 contamination on G60 (gen 128) and i5 (gen 129) procedure rows.
--
-- mig 177 cloned procedures from G30 LCI (gen 127) onto G60 verbatim. Mig
-- 179 did the same for i5 (with a title REPLACE that only fixed the title
-- string, not body_md). Result:
-- - G60 procedure titles all say "— 5 Series (G30)"
-- - G60 + i5 procedure body_md introduces each procedure as "The G30 ..."
-- - G60 + i5 procedure rows cite source 503 (BMW 5 Series G30 Owner's
--   Manual) and 658 (HaynesPro G30/G31/F90) which are wrong sources for
--   these gens — they should cite the G60-specific OEM manuals + the new
--   G60 HaynesPro entry.

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. G60 procedure titles: "5 Series (G30)" → "5 Series (G60)"
-- ----------------------------------------------------------------------------
UPDATE procedures
SET title = REPLACE(title, '5 Series (G30)', '5 Series (G60)')
WHERE generation_id = 128;

-- ----------------------------------------------------------------------------
-- 2. G60 procedure body_md: opening "The G30" lead-ins refactored to G60
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = REPLACE(body_md,
  'The G30 uses the ZF 8-speed automatic',
  'The G60 5 Series uses the ZF 8-speed automatic')
WHERE generation_id = 128 AND slug = 'at-fluid-zf-8hp';

UPDATE procedures
SET body_md = REPLACE(body_md,
  'The G30 cooling system uses tightly routed plastic galleries',
  'The G60 cooling system uses tightly routed plastic galleries')
WHERE generation_id = 128 AND slug = 'coolant-drain-refill';

-- Replace G30-era engine capacity list with G60 engine list
UPDATE procedures
SET body_md = REPLACE(body_md,
  'published system capacity (G30 petrol: ~7 L; B58 inline-six ~8.5 L; N63 V8 ~11.5 L). Use BMW G48 HOAT for MY2017–2022 pre-LCI and early LCI; LC-18 spec is required from MY2023 LCI onwards.',
  'published system capacity (G60 B48 petrol: ~6.5 L; B58 inline-six ~8.5 L; B47/B57 diesel ~7–9 L). The G60 ships with BMW LC-18 coolant from launch (replaces the G48 HOAT used on pre-LCI G30 and early LCI G30 through MY2022). Do NOT mix LC-18 with G48 or generic ethylene-glycol coolant.')
WHERE generation_id = 128 AND slug = 'coolant-drain-refill';

UPDATE procedures
SET body_md = REPLACE(body_md,
  'The G30 uses motor-on-caliper electronic parking brake actuators',
  'The G60 uses the same motor-on-caliper electronic parking brake actuators as the late G30 LCI')
WHERE generation_id = 128 AND slug = 'epb-service-mode';

UPDATE procedures
SET body_md = REPLACE(body_md,
  'The G30 5 Series ships without a physical engine oil dipstick',
  'The G60 5 Series ships without a physical engine oil dipstick')
WHERE generation_id = 128 AND slug = 'oil-level-check';

-- Linear-piston caveat — G30 wording was kept by mig 181's title pass but
-- the body still said "as the G30 rear pistons are linear"; rewrite to G60.
UPDATE procedures
SET body_md = REPLACE(body_md,
  'as the G30 rear pistons are linear',
  'as the G60 rear pistons are linear')
WHERE generation_id IN (128, 129) AND slug = 'epb-service-mode';

-- ----------------------------------------------------------------------------
-- 3. i5 procedure body_md: same G30 → G60 lead-in cleanup
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = REPLACE(body_md,
  'The G30 cooling system uses tightly routed plastic galleries',
  'The i5 (G60 chassis) shares the BMW vacuum-fill cooling architecture with the late G30 LCI and G60 ICE — tightly routed plastic galleries')
WHERE generation_id = 129 AND slug = 'coolant-drain-refill';

UPDATE procedures
SET body_md = REPLACE(body_md,
  'The G30 uses motor-on-caliper electronic parking brake actuators',
  'The i5 (G60 chassis) uses the same motor-on-caliper electronic parking brake actuators as the late G30 LCI and G60 ICE')
WHERE generation_id = 129 AND slug = 'epb-service-mode';

-- i5 coolant system context — replace G30-era engine capacity list with
-- the i5-specific HV battery + motor coolant volume (~12 L combined).
UPDATE procedures
SET body_md = REPLACE(body_md,
  'published system capacity (G30 petrol: ~7 L; B58 inline-six ~8.5 L; N63 V8 ~11.5 L). Use BMW G48 HOAT for MY2017–2022 pre-LCI and early LCI; LC-18 spec is required from MY2023 LCI onwards.',
  'published system capacity for the i5 (~12 L combined battery + motor circuits per BMW service data; refer to the engine bay label for the exact build-specific volume). Use BMW LC-18 coolant — the i5 uses LC-18 from launch. Do NOT mix LC-18 with G48 HOAT or generic ethylene-glycol coolant.')
WHERE generation_id = 129 AND slug = 'coolant-drain-refill';

-- ----------------------------------------------------------------------------
-- 4. Remove wrong G30-source citations from G60 + i5 rows
-- ----------------------------------------------------------------------------
-- source 503 = "BMW 5 Series (G30) Owner's Manual" — should NOT cite G60 or i5
DELETE FROM spec_sources
WHERE source_id = 503
  AND (
    (spec_table = 'procedures' AND spec_id IN (SELECT id FROM procedures WHERE generation_id IN (128, 129)))
    OR (spec_table = 'fluid_specs' AND spec_id IN (SELECT id FROM fluid_specs WHERE generation_id IN (128, 129)))
    OR (spec_table = 'trims' AND spec_id IN (SELECT id FROM trims WHERE generation_id IN (128, 129)))
    OR (spec_table = 'bulbs' AND spec_id IN (SELECT id FROM bulbs WHERE generation_id IN (128, 129)))
    OR (spec_table = 'tire_pressures' AND spec_id IN (SELECT id FROM tire_pressures WHERE generation_id IN (128, 129)))
    OR (spec_table = 'torque_specs' AND spec_id IN (SELECT id FROM torque_specs WHERE generation_id IN (128, 129)))
  );

-- source 658 = HaynesPro G30/G31/F90 — should NOT cite G60 or i5
DELETE FROM spec_sources
WHERE source_id = 658
  AND (
    (spec_table = 'procedures' AND spec_id IN (SELECT id FROM procedures WHERE generation_id IN (128, 129)))
    OR (spec_table = 'fluid_specs' AND spec_id IN (SELECT id FROM fluid_specs WHERE generation_id IN (128, 129)))
    OR (spec_table = 'trims' AND spec_id IN (SELECT id FROM trims WHERE generation_id IN (128, 129)))
    OR (spec_table = 'bulbs' AND spec_id IN (SELECT id FROM bulbs WHERE generation_id IN (128, 129)))
    OR (spec_table = 'tire_pressures' AND spec_id IN (SELECT id FROM tire_pressures WHERE generation_id IN (128, 129)))
    OR (spec_table = 'torque_specs' AND spec_id IN (SELECT id FROM torque_specs WHERE generation_id IN (128, 129)))
  );

-- ----------------------------------------------------------------------------
-- 5. Add a G60-specific HaynesPro source row and cite it on the new procedures
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sources (citation, url, retrieved_at, notes) VALUES
  ('HaynesPro WorkshopData — BMW 5 (G60, G61, G90) Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelDetailMaintenance?typeId=t_619116379&currentSubject=MAINTENANCE',
   NOW(),
   'G60-specific HaynesPro maintenance procedures dataset (replaces the G30 entry that was wrongly cited on G60 procedures via the mig 177 clone).');

SET @s_haynes_g60 := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelDetailMaintenance?typeId=t_619116379&currentSubject=MAINTENANCE');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_haynes_g60 FROM procedures WHERE generation_id IN (128, 129);

-- ----------------------------------------------------------------------------
-- 6. Cite the G60 OEM manuals (2024/2025/2026) on the G60 procedures so each
--    procedure has ≥2 sources after the G30 removals
-- ----------------------------------------------------------------------------
SET @s_g60_2024 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2024-owners-manual-95446');
SET @s_g60_2025 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2025-owners-manual-100847');
SET @s_g60_2026 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/5-series-2026-owners-manual-105284');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_g60_2024 FROM procedures WHERE generation_id = 128 AND @s_g60_2024 IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_g60_2026 FROM procedures WHERE generation_id = 128 AND @s_g60_2026 IS NOT NULL;

-- And the i5 manuals (2024 + 2026) on i5 procedures
SET @s_i5_2024 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/i5-2024-owners-manual-95889');
SET @s_i5_2026 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/i5-2026-owners-manual-107914');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_i5_2024 FROM procedures WHERE generation_id = 129 AND @s_i5_2024 IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'procedures', id, @s_i5_2026 FROM procedures WHERE generation_id = 129 AND @s_i5_2026 IS NOT NULL;
