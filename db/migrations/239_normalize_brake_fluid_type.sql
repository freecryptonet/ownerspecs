-- mig 239 — Normalize brake / brake_fluid dual convention.
--
-- Background: hand-seeded rows used fluid_type='brake' (113 rows, often with
-- richer spec strings like 'VW TL 766-Z (DOT 4 LV)'). Phase 4 HaynesPro ingest
-- used fluid_type='brake_fluid' (56 rows, simpler spec like 'VW 501 14').
-- On gens with both, brake-fluid page now renders 2 rows that mean the same
-- thing — bad UX.
--
-- Plan:
--   1. For gens with BOTH: migrate Phase 4 row's spec_sources onto the older
--      'brake' row (preserving the HaynesPro citation), then DELETE the
--      Phase 4 row.
--   2. UPDATE all surviving fluid_type='brake' → 'brake_fluid' (longer-form
--      is the convention going forward — matches Phase 4+5 ingest).
--   3. brake-fluid page handler reverts to fluidTypes=['brake_fluid'] in
--      a separate code change.

SET NAMES utf8mb4;

-- Step 1a — for each gen-wide duplicate, move spec_sources from the
-- doomed brake_fluid row to the surviving brake row.
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id, page_number)
SELECT 'fluid_specs', survivor.id, ss.source_id, ss.page_number
FROM fluid_specs survivor
JOIN fluid_specs doomed
  ON doomed.generation_id = survivor.generation_id
 AND doomed.engine_id IS NULL AND survivor.engine_id IS NULL
 AND doomed.fluid_type = 'brake_fluid' AND survivor.fluid_type = 'brake'
JOIN spec_sources ss
  ON ss.spec_table = 'fluid_specs' AND ss.spec_id = doomed.id;

-- Step 1b — delete spec_sources rows referencing the doomed brake_fluid rows
DELETE ss FROM spec_sources ss
JOIN fluid_specs doomed
  ON ss.spec_table = 'fluid_specs' AND ss.spec_id = doomed.id
JOIN fluid_specs survivor
  ON doomed.generation_id = survivor.generation_id
 AND doomed.engine_id IS NULL AND survivor.engine_id IS NULL
 AND doomed.fluid_type = 'brake_fluid' AND survivor.fluid_type = 'brake';

-- Step 1c — delete the doomed brake_fluid rows themselves
DELETE doomed FROM fluid_specs doomed
JOIN fluid_specs survivor
  ON doomed.generation_id = survivor.generation_id
 AND doomed.engine_id IS NULL AND survivor.engine_id IS NULL
 AND doomed.fluid_type = 'brake_fluid' AND survivor.fluid_type = 'brake';

-- Step 2 — normalize fluid_type: 'brake' → 'brake_fluid' everywhere
UPDATE fluid_specs SET fluid_type = 'brake_fluid' WHERE fluid_type = 'brake';

-- Audit
SELECT fluid_type, COUNT(*) AS n FROM fluid_specs WHERE fluid_type LIKE '%brake%' GROUP BY fluid_type;
SELECT g.slug, COUNT(*) AS n FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL
GROUP BY g.slug HAVING n > 1;  -- should return 0 rows
