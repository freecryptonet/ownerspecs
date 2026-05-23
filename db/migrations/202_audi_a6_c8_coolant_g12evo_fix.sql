-- Audi A6 C8 family — coolant correction: G13 → G12EVO, 8.30 L → 10.0 L.
--
-- HaynesPro (workshopdata.com, modelId d_319001693) consistently lists the
-- entire 4A chassis lineup as using **TL-VW 774L (G12EVO)** with a 10.0 L
-- cooling system. Verified on 5 different engine variants:
--   - DMTA (45 TFSI 4-cyl petrol)  t_619035648 — captured 2026-05-23
--   - DKMB (S6 2.9 V6 TFSI)         t_619017205 — captured 2026-05-22
--   - DEWA (S6 3.0 V6 TDI)          t_619023125 — captured 2026-05-22
--   - DJPB (RS6 4.0 V8 TFSI)        t_619028750 — captured 2026-05-22
--   - DWLA (RS6 LCI std)            t_619116169 — captured 2026-05-22
--
-- Mig 195 + 198 originally seeded "VW G 13 (lilac)" with 8.30 L capacity
-- on the 5 regular A6 family gens. The G13 label was lore — Audi switched
-- to G12EVO (TL-VW 774L) for the C8 from launch. The 8.30 L capacity was
-- likely a partial-fill auto-data hint, not the system-total HaynesPro
-- publishes.
--
-- Scope: 5 regular A6 family gens (sedan + Avant pre-LCI + LCI + Allroad).
-- The S6 + RS6 sibling gens (mig 201) already have the correct G12EVO + 10.0 L
-- since they were seeded from real HaynesPro pulls.

SET NAMES utf8mb4;

SET @s_haynes := 709;  -- HaynesPro WorkshopData — Audi A6/-Allroad (4A) 2019-

-- ----------------------------------------------------------------------------
-- 1. Update the 5 coolant rows on the regular A6 family
-- ----------------------------------------------------------------------------
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.capacity_l    = 10.0,
    fs.capacity_qt   = 10.57,
    fs.spec_standard = 'TL-VW 774L (G12EVO)',
    fs.notes         = 'Corrected 2026-05-23 from G13 / 8.30 L lore to HaynesPro-verified G12EVO / 10.0 L (modelId d_319001693, multi-engine cross-verified: DMTA, DKMB, DEWA, DJPB, DWLA all show identical coolant spec across the 4A chassis). 40% antifreeze gives protection to -25 °C, 50% antifreeze to -36 °C.'
WHERE g.family_slug = 'audi-a6-c8-2018-present'
  AND g.model_id = (SELECT id FROM models WHERE slug = 'a6')
  AND fs.fluid_type = 'coolant';

-- ----------------------------------------------------------------------------
-- 2. Ensure spec_sources link to HaynesPro 709 (idempotent)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.family_slug = 'audi-a6-c8-2018-present'
  AND g.model_id = (SELECT id FROM models WHERE slug = 'a6')
  AND fs.fluid_type = 'coolant';

-- ----------------------------------------------------------------------------
-- 3. Audit — confirm all 5 regular A6 gens now show G12EVO + 10.0 L
-- ----------------------------------------------------------------------------
SELECT g.slug, fs.capacity_l, fs.spec_standard,
       (SELECT COUNT(DISTINCT ss.source_id) FROM spec_sources ss
        WHERE ss.spec_table = 'fluid_specs' AND ss.spec_id = fs.id) AS source_count
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.family_slug = 'audi-a6-c8-2018-present'
  AND g.model_id = (SELECT id FROM models WHERE slug = 'a6')
  AND fs.fluid_type = 'coolant'
ORDER BY g.start_year, g.body_type;
