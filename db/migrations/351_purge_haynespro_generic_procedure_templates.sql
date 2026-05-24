-- mig 351 — purge the ~3,400 HaynesPro generic-template procedure rows
-- that were auto-imported with body_md_source_text but never restated.
-- Discovered 2026-05-24 (post-mig-350) when investigating what to restate:
--   - "maintenance-battery-procedures-for-disconnection-reconnection" exists
--     on 197 gens across 6 brands (Audi, BMW, Honda, MB, Toyota, VW).
--   - "maintenance-wheel-alignment-settings" on 194 gens, 5 brands.
--   - Sampled body_md_source_text for BMW 3 Series G20 wheel alignment ->
--     mentions VAG 1869/2, VAS 5051B, VAS 6458 (Volkswagen-Audi tools, not
--     BMW). The crawler that produced body_md_source_text was pulling a
--     generic HP "Maintenance Procedures" library and attaching identical
--     content to every gen, regardless of actual chassis applicability.
--   - 309 of 2206 BMW source-text rows (14%) carry Audi/VW tool markers.
--     Restating them would publish factually wrong content under a BMW
--     chassis page — direct violation of Tim's "no synthesized data"
--     rule and undermines the moat's defensibility.
--
-- Scope (verified 2026-05-24):
--   maintenance-*  procedures: 2972 empty (to delete) +   13 populated (KEEP)
--   schedule-*     procedures:  199 empty (to delete) +    0 populated
--   service-*      procedures:  252 empty (to delete) +   54 populated (KEEP)
--   chassis-prefix procedures:   41 empty (KEEP — these are real gaps to
--                                          fill manually from OEM sources)
--                                 505 populated (KEEP)
-- Total deletable: 3423 procedure rows.
--
-- Side-effect cleanup: spec_sources polymorphic rows pointing at the
-- deleted procedure IDs (no FK constraints, so we must DELETE manually).
--
-- After this:
--   - procedures table goes from ~4036 to ~613 rows
--   - The procedures-index page already filtered empty-body rows out, so
--     no rendered page disappears. The procedure-detail SSG paths for
--     these slugs were 404'ing already.
--   - The 41 chassis-specific empty procedures (Audi C8 / B9: dsg-7sp
--     fluid change, EPB service mode, jacking-points-air-suspension, ZF
--     8HP fluid change) become the well-defined real backlog for
--     OEM-sourced restating later.

SET NAMES utf8mb4;

START TRANSACTION;

-- 1. Clean up spec_sources rows pointing at the doomed procedures.
DELETE ss
FROM spec_sources ss
JOIN procedures p ON p.id = ss.spec_id
WHERE ss.spec_table = 'procedures'
  AND (p.slug LIKE 'maintenance-%'
       OR p.slug LIKE 'schedule-%'
       OR p.slug LIKE 'service-%')
  AND (p.body_md IS NULL OR p.body_md = '');

-- 2. Delete the procedure rows themselves.
DELETE FROM procedures
WHERE (slug LIKE 'maintenance-%'
       OR slug LIKE 'schedule-%'
       OR slug LIKE 'service-%')
  AND (body_md IS NULL OR body_md = '');

-- POST-CHECK
SELECT 'remaining procedures total' k, COUNT(*) n FROM procedures
UNION ALL
SELECT 'remaining empties (real gaps)', COUNT(*)
  FROM procedures WHERE body_md IS NULL OR body_md = ''
UNION ALL
SELECT 'remaining maintenance-*', COUNT(*)
  FROM procedures WHERE slug LIKE 'maintenance-%'
UNION ALL
SELECT 'remaining schedule-*', COUNT(*)
  FROM procedures WHERE slug LIKE 'schedule-%'
UNION ALL
SELECT 'remaining service-*', COUNT(*)
  FROM procedures WHERE slug LIKE 'service-%'
UNION ALL
SELECT 'spec_sources -> procedures', COUNT(*)
  FROM spec_sources WHERE spec_table = 'procedures'
UNION ALL
SELECT 'spec_sources orphans (procedures)', COUNT(*)
  FROM spec_sources ss LEFT JOIN procedures p ON p.id = ss.spec_id
  WHERE ss.spec_table = 'procedures' AND p.id IS NULL;

COMMIT;
