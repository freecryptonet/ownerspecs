-- VW Group coolant corrections — extend the G13→G12EVO fix (mig 202/204)
-- across the rest of the VW Group families. Per-family HaynesPro
-- verification on 2026-05-23:
--
--   Family               Catalog years   Verdict per HaynesPro
--   ------------------- ---------------- -----------------------------------
--   Audi Q5 FY          2017-2020        TL-VW 774L (G12EVO) 10.0 L
--                                        (45 TFSI DAYB 2017-2018 t_319005530)
--   Audi Q7 4M          2015-2019        TL-VW 774L (G12EVO) 10.0 L
--                                        (2.0 TFSI CYMC 2016-2019 t_619017270)
--   VW Golf VIII (Mk8)  2020-2024        TL-VW 774L (G12EVO) 10.0 L
--                                        (1.5 TSI DPCA 2020-2024 t_619028741)
--   VW Tiguan AD1       2017-2024        MIXED — same pattern as Passat B8:
--                                        early G13, post-2019/2020 G12EVO
--                                        (1.4 TSI CZEA 2016-2018 t_319000775 → G13 10.0 L
--                                         1.5 TSI DPCA 2020-2024 t_619014595 → G12EVO 8.0 L)
--
-- Skipped (own coolant spec): Porsche Macan 95B + Porsche 911 992 use
-- Glysantin G40 / TL-VW 774G (G12++). Skoda Octavia Mk4 + VW Atlas CA
-- + VW Passat B8 + Audi A4 B9 + Audi A6 C8 family already on G12EVO via
-- earlier migrations or correct from seeding.

SET NAMES utf8mb4;

-- ============================================================================
-- 1. Add HaynesPro source rows for the affected modelIds (verified URLs).
--    NOTE: `sources` has no UNIQUE constraint on `url` so re-running this
--    migration would create duplicate rows. Treat as run-once.
-- ============================================================================
INSERT INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi Q5 (FY) 2016- Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001449',
   NOW(),
   'Real Audi Q5 FY chassis modelId d_319001449. Captured 2026-05-23 via Playwright. Sample typeId t_319005530 (45 TFSI DAYB 2017-2018) lubricants page confirms TL-VW 774L (G12EVO) + 10.0 L cooling system from launch.',
   0, 0),
  ('HaynesPro WorkshopData — Audi Q7 (4MB, 4MG) 2016- Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_312000002',
   NOW(),
   'Real Audi Q7 4M chassis modelId d_312000002. Captured 2026-05-23 via Playwright. Sample typeId t_619017270 (2.0 TFSI CYMC 2016-2019) confirms TL-VW 774L (G12EVO) + 10.0 L from launch. Q7 4M predates the Tiguan AD1 G12EVO switch — Audi MLB Evo went G12EVO platform-wide earlier than VW MQB.',
   0, 0),
  ('HaynesPro WorkshopData — VW Golf VIII (CD, CG) 2020- Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319007235',
   NOW(),
   'Real VW Golf VIII chassis modelId d_319007235. Captured 2026-05-23 via Playwright. Sample typeId t_619028741 (1.5 TSI DPCA 2020-2024) confirms TL-VW 774L (G12EVO) + 10.0 L from launch.',
   0, 0),
  ('HaynesPro WorkshopData — VW Tiguan II (AD, AX, BT, BW, BJ) 2016-2024 Maintenance Procedures',
   'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000050',
   NOW(),
   'Real VW Tiguan II AD1 chassis modelId d_317000050. Captured 2026-05-23 via Playwright. SWITCH WITHIN GENERATION: early 1.4 TSI CZEA 2016-2018 t_319000775 uses TL-VW 774J (G13) 10.0 L; late 1.5 TSI DPCA 2020-2024 t_619014595 uses TL-VW 774L (G12EVO) 8.0 L. Capacity dropped 2L with the switch — likely smaller cooling system in the later MQB Evo refresh.',
   0, 0);

-- Captured source IDs (post-applied, for reference):
--   713 = Q5 FY
--   714 = Q7 4M
--   715 = VW Golf VIII
--   716 = VW Tiguan AD1

SET @s_q5 := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001449');
SET @s_q7 := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_312000002');
SET @s_g8 := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319007235');
SET @s_tig:= (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000050');

-- ============================================================================
-- 2. Audi Q5 FY 2017-2020 — G13 → G12EVO
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = CASE
        WHEN fs.spec_standard LIKE '%HV battery%' THEN 'TL-VW 774L (G12EVO) + HV battery loop'
        WHEN fs.spec_standard LIKE '%Mercedes%' THEN 'TL-VW 774L (G12EVO) — Mercedes spec accepted'
        ELSE 'TL-VW 774L (G12EVO)'
    END
WHERE g.slug = 'q5-fy-suv-2017-2020'
  AND fs.fluid_type = 'coolant';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_q5
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.slug = 'q5-fy-suv-2017-2020' AND fs.fluid_type = 'coolant';

-- ============================================================================
-- 3. Audi Q7 4M 2015-2019 — G13 → G12EVO
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = CASE
        WHEN fs.spec_standard LIKE '%HV battery%' THEN 'TL-VW 774L (G12EVO) + HV battery loop'
        WHEN fs.spec_standard LIKE '%Mercedes%' THEN 'TL-VW 774L (G12EVO) — Mercedes spec accepted'
        ELSE 'TL-VW 774L (G12EVO)'
    END
WHERE g.slug = 'q7-4m-suv-2015-2019'
  AND fs.fluid_type = 'coolant';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_q7
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.slug = 'q7-4m-suv-2015-2019' AND fs.fluid_type = 'coolant';

-- ============================================================================
-- 4. VW Golf Mk8 2020-2024 — G13 → G12EVO
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'TL-VW 774L (G12EVO)'
WHERE g.slug = 'golf-mk8-hatchback-2020-2024'
  AND fs.fluid_type = 'coolant';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_g8
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.slug = 'golf-mk8-hatchback-2020-2024' AND fs.fluid_type = 'coolant';

-- ============================================================================
-- 5. VW Tiguan AD1 2017-2024 — MIXED label (follows Passat B8 pattern)
--    Production switch from G13 to G12EVO around MY2019-2020.
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'TL-VW 774J (G13) early or TL-VW 774L (G12EVO) post-MY2020'
WHERE g.slug = 'tiguan-ad1-suv-2017-2024'
  AND fs.fluid_type = 'coolant';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_tig
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.slug = 'tiguan-ad1-suv-2017-2024' AND fs.fluid_type = 'coolant';

-- ============================================================================
-- 6. Skoda Octavia Mk4 + VW Atlas CA + VW Passat B8 — normalize label
--    to the consistent "TL-VW 774L (G12EVO)" or mixed pattern used above.
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'TL-VW 774L (G12EVO)'
WHERE g.slug IN ('octavia-mk4-liftback-2020-2025', 'atlas-ca-suv-2018-2023')
  AND fs.fluid_type = 'coolant'
  AND fs.spec_standard LIKE '%G12 EVO%';

UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'TL-VW 774J (G13) early or TL-VW 774L (G12EVO) post-07/2019'
WHERE g.slug = 'passat-b8-sedan-2015-2019'
  AND fs.fluid_type = 'coolant';

-- ============================================================================
-- 7. Audit
-- ============================================================================
SELECT g.slug, COUNT(fs.id) AS coolant_rows, GROUP_CONCAT(DISTINCT fs.spec_standard SEPARATOR ' | ') AS specs
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
WHERE g.slug IN (
    'q5-fy-suv-2017-2020', 'q7-4m-suv-2015-2019',
    'golf-mk8-hatchback-2020-2024', 'tiguan-ad1-suv-2017-2024'
)
  AND fs.fluid_type = 'coolant'
GROUP BY g.id
ORDER BY g.start_year;
