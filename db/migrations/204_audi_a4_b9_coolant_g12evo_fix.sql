-- Audi A4 B9 family — coolant spec correction: G13 → G12EVO.
--
-- Same root cause as the A6 C8 fix in mig 202: the VW Group MLB Evo
-- platform from the 2016 A4 B9 onward uses TL-VW 774L (G12EVO), not the
-- earlier G13 the catalog claims on these 20 rows.
--
-- Verified 2026-05-23 via HaynesPro WorkshopData:
--   - A4 B9 1.4 TFSI CVNA (typeId t_318011813)
--   - Lubricants page lists: Coolant TL-VW 774L (G12EVO)
--   - Same frost-protection table as A6 C8: 40% → -25 °C, 50% → -36 °C
--
-- Per-engine capacities (8.0 / 8.5 / 10.5 L) in the DB are kept as-is —
-- they're chassis-typical and not visible on the HaynesPro lubricants
-- page for this engine (likely on the adjustment-data page per-engine).
-- This migration only corrects the spec_standard string; capacities
-- can be verified per-engine in a follow-up.
--
-- HaynesPro source 687 (Audi A4 8W modelId d_317000026, REAL URL
-- verified yesterday) is already linked to these coolant rows; we just
-- update the spec_standard text.

SET NAMES utf8mb4;

UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'TL-VW 774L (G12EVO)',
    fs.notes = CONCAT(COALESCE(fs.notes, ''),
                      CASE WHEN fs.notes IS NULL OR fs.notes = '' THEN '' ELSE ' ' END,
                      'Corrected 2026-05-23 from VW G13 to G12EVO (TL-VW 774L) per HaynesPro A4 B9 1.4 TFSI CVNA t_318011813 lubricants page. The B9 MLB Evo platform uses G12EVO from launch, not the earlier G13.')
WHERE g.family_slug = 'audi-a4-b9-2015-2025'
  AND fs.fluid_type = 'coolant';

-- Audit
SELECT g.slug, COUNT(fs.id) AS coolant_rows,
       GROUP_CONCAT(DISTINCT fs.spec_standard) AS specs
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.family_slug = 'audi-a4-b9-2015-2025'
  AND fs.fluid_type = 'coolant'
GROUP BY g.id
ORDER BY g.start_year, g.body_type;
