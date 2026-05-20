-- Fix engine fuel-type misclassifications.
--
-- 1. 14 engines were ingested with fuel='electric' but have non-null
--    displacement_cc + aspiration (so they're clearly ICE). Source:
--    auto-data scraper occasionally tags hybrid/MHEV powertrains' ICE
--    block as "electric" when reading the variant header. All 14 should
--    be 'gasoline'.
-- 2. "petrol" vs "gasoline" inconsistency — 108 rows use 'gasoline', 11
--    use 'petrol' (my hand-written batch 11 + 13 migrations). Standardize
--    on 'gasoline' since it's dominant and the dual-unit page labels use
--    "gasoline".

SET NAMES utf8mb4;

UPDATE engines
SET fuel = 'gasoline'
WHERE fuel = 'electric' AND displacement_cc IS NOT NULL;

UPDATE engines
SET fuel = 'gasoline'
WHERE fuel = 'petrol';

SELECT 'Engine fuel cleanup done' AS status,
       SUM(CASE WHEN fuel='gasoline' THEN 1 ELSE 0 END) AS gasoline,
       SUM(CASE WHEN fuel='diesel'   THEN 1 ELSE 0 END) AS diesel,
       SUM(CASE WHEN fuel='hybrid'   THEN 1 ELSE 0 END) AS hybrid,
       SUM(CASE WHEN fuel='electric' THEN 1 ELSE 0 END) AS electric,
       SUM(CASE WHEN fuel='petrol'   THEN 1 ELSE 0 END) AS petrol
FROM engines;
