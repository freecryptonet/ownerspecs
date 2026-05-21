-- Engine reference dedup for the 4 US pickup gens.
-- Per CLAUDE.md note on "Engine duplicate records on US pickups": trims on
-- F-150 P702 + Silverado T1 + Tahoe T1XX reference short-code engine rows
-- (e.g. id 26 "EcoBoost" 2264cc 4-cyl) when descriptive canonical rows
-- exist (e.g. id 172 "3.5 EcoBoost" 3496cc V6). The fluid_specs for these
-- gens are empty so the legacy-FK problem hasn't surfaced yet, but per-engine
-- moat backfill is blocked until trims point at the canonical engines.
--
-- IMPORTANT: We do NOT delete the short-code engine rows. They remain valid
-- entries used by OTHER gens:
--   id 25 (Coyote 4951cc)  → Mustang S550 (gen 19) — correct 5.0 Gen 2 displacement
--   id 26 (EcoBoost 2264cc 4-cyl) → Mustang S550 (gen 19) — 2.3 EcoBoost Mustang
--   id 62/63/64 (L87/L84/L82 short codes) → GMC Sierra T1XX (gen 77) — same
--                                            physical engines, same naming used
--                                            by gen 77 (out of scope here).
--   id 125 (LM2)            → Tahoe T1XX only (after this dedup, it's an orphan
--                              but kept for historical reference; we wipe it
--                              from trim references only).
-- Escalade T1XX (gen 100) already uses canonical IDs — NO CHANGES needed.
--
-- Repointing map (4 gens):
--   F-150 P702 (gen 26):
--     trim 98  Raptor R Predator         → keep eid 39 (Predator)
--     trim 99  Raptor 3.5 EcoBoost       eid 26  → 172 (3.5 EcoBoost canonical)
--     trims 100,101  5.0 Ti-VCT V8       NULL    → 185 (5.0 Coyote canonical)
--     trims 102,103  3.5 PowerBoost FHEV NULL    → 186 (3.5 PowerBoost canonical)
--     trims 104,105  3.5 EcoBoost V6     NULL    → 172 (3.5 EcoBoost canonical)
--   Silverado T1 (gen 38):
--     trim 145 6.2 V8 (L87)              eid 62  → 169
--     trim 146 5.3 V8 (L84, DFM)         eid 63  → 199
--     trim 147 5.3 V8 (L82)              eid 64  → 198
--     trim 148 5.3 V8 (L84, DFM, 4WD)    eid 63  → 199
--   Tahoe T1XX (gen 76):
--     trims 309,310 6.2 V8               eid 62  → 169
--     trims 311,312 5.3 V8               eid 63  → 199
--     trim 313 3.0d Duramax              eid 125 → 171

SET NAMES utf8mb4;

-- =========================================================================
-- STEP 0 — pre-state dump (for audit / rollback). Captures every trim row
-- we're about to touch with its current engine_id. SELECT only — no writes.
-- =========================================================================
SELECT 'PRE-STATE: trims about to be repointed' AS marker,
       t.id, t.generation_id, t.name, t.engine_id AS old_engine_id
FROM trims t
WHERE t.id IN (99, 100, 101, 102, 103, 104, 105,           -- F-150 P702 trims
               145, 146, 147, 148,                          -- Silverado T1
               309, 310, 311, 312, 313)                    -- Tahoe T1XX
ORDER BY t.generation_id, t.id;

-- =========================================================================
-- STEP 1 — F-150 P702 (gen 26) trim repointing
-- =========================================================================
UPDATE trims SET engine_id = 172 WHERE id = 99  AND generation_id = 26;  -- Raptor 3.5 EcoBoost
UPDATE trims SET engine_id = 185 WHERE id = 100 AND generation_id = 26;  -- 5.0 Ti-VCT FFV
UPDATE trims SET engine_id = 185 WHERE id = 101 AND generation_id = 26;  -- 5.0 Ti-VCT FFV 4x4
UPDATE trims SET engine_id = 186 WHERE id = 102 AND generation_id = 26;  -- 3.5 PowerBoost
UPDATE trims SET engine_id = 186 WHERE id = 103 AND generation_id = 26;  -- 3.5 PowerBoost 4x4
UPDATE trims SET engine_id = 172 WHERE id = 104 AND generation_id = 26;  -- 3.5 EcoBoost
UPDATE trims SET engine_id = 172 WHERE id = 105 AND generation_id = 26;  -- 3.5 EcoBoost 4x4

-- =========================================================================
-- STEP 2 — Silverado T1 (gen 38) trim repointing
-- =========================================================================
UPDATE trims SET engine_id = 169 WHERE id = 145 AND generation_id = 38;  -- 6.2 L87 DFM
UPDATE trims SET engine_id = 199 WHERE id = 146 AND generation_id = 38;  -- 5.3 L84 DFM
UPDATE trims SET engine_id = 198 WHERE id = 147 AND generation_id = 38;  -- 5.3 L82
UPDATE trims SET engine_id = 199 WHERE id = 148 AND generation_id = 38;  -- 5.3 L84 DFM 4WD

-- =========================================================================
-- STEP 3 — Tahoe T1XX (gen 76) trim repointing
-- =========================================================================
UPDATE trims SET engine_id = 169 WHERE id = 309 AND generation_id = 76;  -- 6.2 V8 AWD
UPDATE trims SET engine_id = 169 WHERE id = 310 AND generation_id = 76;  -- 6.2 V8 FWD
UPDATE trims SET engine_id = 199 WHERE id = 311 AND generation_id = 76;  -- 5.3 V8 AWD
UPDATE trims SET engine_id = 199 WHERE id = 312 AND generation_id = 76;  -- 5.3 V8 RWD
UPDATE trims SET engine_id = 171 WHERE id = 313 AND generation_id = 76;  -- 3.0d Duramax

-- =========================================================================
-- STEP 4 — post-state report
-- =========================================================================
SELECT 'POST-STATE: trim->engine after dedup' AS marker,
       t.id, t.generation_id, t.name, t.engine_id AS new_engine_id,
       e.code AS new_eng_code, e.display_name AS new_eng_display
FROM trims t
LEFT JOIN engines e ON e.id = t.engine_id
WHERE t.id IN (99, 100, 101, 102, 103, 104, 105,
               145, 146, 147, 148,
               309, 310, 311, 312, 313)
ORDER BY t.generation_id, t.id;

SELECT 'Pickup engine dedup complete' AS status,
       (SELECT COUNT(*) FROM trims WHERE generation_id IN (26,38,76,100) AND engine_id IS NULL) AS pickup_trims_still_nulled,
       (SELECT COUNT(DISTINCT engine_id) FROM trims WHERE generation_id = 26) AS f150_engines,
       (SELECT COUNT(DISTINCT engine_id) FROM trims WHERE generation_id = 38) AS silverado_engines,
       (SELECT COUNT(DISTINCT engine_id) FROM trims WHERE generation_id = 76) AS tahoe_engines,
       (SELECT COUNT(DISTINCT engine_id) FROM trims WHERE generation_id = 100) AS escalade_engines;
