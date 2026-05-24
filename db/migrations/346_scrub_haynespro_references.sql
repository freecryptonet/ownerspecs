-- mig 346 — URGENT: scrub all public-facing references to "HaynesPro" and
-- "WorkshopData" from rendered columns. Tim's hard rule: never expose a
-- copyright/origin reference to a paid dataset; weakens our Feist v Rural
-- defence and invites DMCA pressure.
--
-- Affected columns (audited 2026-05-24):
--   torque_specs.notes       52729 rows say 'HaynesPro adjustmentData'
--   fluid_specs.notes         6026 rows say 'HaynesPro …'
--   procedures.body_md        3665 rows are the '(See HaynesPro WorkshopData
--                                   for full procedure — storyId X)' placeholder
--   sources.citation           123 rows literally say 'HaynesPro WorkshopData — …'
--   service_intervals.notes      0 rows already (mig 344 used the raw item
--                                   text 'Renew the engine oil' as notes)
--
-- Policy after scrub:
--   - sources.citation renamed to neutral 'Workshop service manual — <chassis>'
--     so the Sources block still shows accurate provenance ('this came from
--     a workshop manual') without naming HaynesPro.
--   - torque/fluid/procedure notes columns -> NULL (these were internal
--     provenance markers, not informational for the reader).
--   - procedures.body_md placeholder rows -> empty string. The procedures
--     page renders an empty body gracefully (title + slug only) until a
--     restated body_md is produced from body_md_source_text.

SET NAMES utf8mb4;

-- 1. sources.citation: HaynesPro WorkshopData -> Workshop service manual
UPDATE sources
SET citation = REPLACE(REPLACE(REPLACE(REPLACE(citation,
    'HaynesPro WorkshopData', 'Workshop service manual'),
    'HaynesPro', 'Workshop manual'),
    'WorkshopData', 'Workshop manual'),
    'workshopdata', 'Workshop manual')
WHERE citation LIKE '%HaynesPro%'
   OR citation LIKE '%WorkshopData%'
   OR citation LIKE '%workshopdata%';

-- 2. torque_specs.notes: 'HaynesPro adjustmentData' -> NULL
UPDATE torque_specs SET notes = NULL
WHERE notes LIKE '%HaynesPro%' OR notes LIKE '%WorkshopData%' OR notes LIKE '%workshopdata%';

-- 3. fluid_specs.notes: 'HaynesPro …' -> NULL
UPDATE fluid_specs SET notes = NULL
WHERE notes LIKE '%HaynesPro%' OR notes LIKE '%WorkshopData%' OR notes LIKE '%workshopdata%';

-- 4. service_intervals.notes (defensive — should already be 0)
UPDATE service_intervals SET notes = NULL
WHERE notes LIKE '%HaynesPro%' OR notes LIKE '%WorkshopData%' OR notes LIKE '%workshopdata%';

-- 5. procedures.body_md placeholders -> empty string (column is NOT NULL)
UPDATE procedures SET body_md = ''
WHERE body_md LIKE '%HaynesPro%' OR body_md LIKE '%WorkshopData%' OR body_md LIKE '%workshopdata%';

-- 6. Re-audit
SELECT 'torque_specs.notes' AS col, COUNT(*) AS leaking_rows FROM torque_specs WHERE notes LIKE '%HaynesPro%' OR notes LIKE '%WorkshopData%'
UNION ALL SELECT 'service_intervals.notes', COUNT(*) FROM service_intervals WHERE notes LIKE '%HaynesPro%' OR notes LIKE '%WorkshopData%'
UNION ALL SELECT 'fluid_specs.notes', COUNT(*) FROM fluid_specs WHERE notes LIKE '%HaynesPro%' OR notes LIKE '%WorkshopData%'
UNION ALL SELECT 'procedures.body_md', COUNT(*) FROM procedures WHERE body_md LIKE '%HaynesPro%' OR body_md LIKE '%WorkshopData%'
UNION ALL SELECT 'sources.citation', COUNT(*) FROM sources WHERE citation LIKE '%HaynesPro%' OR citation LIKE '%WorkshopData%' OR citation LIKE '%workshopdata%';
