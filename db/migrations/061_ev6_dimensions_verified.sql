-- Kia EV6 generation backfill — dimensions + per-trim curb weight,
-- cross-verified across NHTSA vPIC + Wikipedia. First migration written
-- through the NHTSA verify-gen.ts workflow.
--
-- Cross-check matrix:
--
--                    NHTSA vPIC (gov, MY 2023)    Wikipedia (Kia press kit)
-- Length             4,680 mm                      4,680–4,695 mm   → 4,680 mm
-- Width              1,880 mm                      1,880–1,890 mm   → 1,880 mm
-- Height             1,550 mm                      1,550 mm          → 1,550 mm
-- Wheelbase          2,900 mm                      2,900 mm          → 2,900 mm
--
-- Per-trim curb weight (NHTSA vPIC 2023, all 3 variants):
--   EV6 RWD (Wind)         1,822 kg
--   EV6 RWD LR (Light)     1,955 kg
--   EV6 AWD (GT-Line/GT)   2,062 kg
--
-- Layout: 'awd' for AWD trims, 'rwd' for base. Setting 'awd' as the
-- canonical because the popular trims (GT-Line/GT) are AWD.

SET NAMES utf8mb4;

-- Register NHTSA as a public source if not already
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'gov_database',
       'NHTSA vPIC GetCanadianVehicleSpecifications',
       NOW(),
       1,
       'https://vpic.nhtsa.dot.gov/api/vehicles/GetCanadianVehicleSpecifications',
       'US government open-data; manufacturer-filed per FMVSS reporting. Public domain. Used for dimensions, curb weight, drive type, engine codes.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='NHTSA vPIC GetCanadianVehicleSpecifications');

-- 1. Generation dimensions
UPDATE generations
SET length_mm    = COALESCE(length_mm, 4680),
    width_mm     = COALESCE(width_mm, 1880),
    height_mm    = COALESCE(height_mm, 1550),
    wheelbase_mm = COALESCE(wheelbase_mm, 2900)
WHERE slug = 'ev6-suv-2021-present';

-- 2. Backfill (or insert) the 3 canonical trims with per-trim curb weight
--    from NHTSA. Existing trim rows (if any) get curb_weight updated;
--    otherwise INSERT new ones.

SET @gen := (SELECT id FROM generations WHERE slug='ev6-suv-2021-present');

INSERT INTO trims(generation_id, slug, name, start_year, end_year, hp, torque_nm,
                  curb_weight_kg, drive_wheel)
VALUES
  (@gen, 'ev6-rwd-wind',    'EV6 RWD (Wind / Standard Range)', 2022, NULL, 167, 350, 1822, 'rwd'),
  (@gen, 'ev6-rwd-lr',      'EV6 RWD Long Range (Wind / Light)', 2022, NULL, 225, 350, 1955, 'rwd'),
  (@gen, 'ev6-awd-gt-line', 'EV6 AWD Long Range (GT-Line)',     2022, NULL, 320, 605, 2062, 'awd')
ON DUPLICATE KEY UPDATE
  curb_weight_kg = VALUES(curb_weight_kg),
  drive_wheel = VALUES(drive_wheel);

-- 3. Link new trim rows to the NHTSA source
SET @src := (SELECT id FROM sources WHERE citation='NHTSA vPIC GetCanadianVehicleSpecifications' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
SELECT 'trims', id, @src FROM trims WHERE generation_id=@gen;

-- 4. Add Wikipedia (Kia press kit) as a 2nd public source for dimensions
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'wikipedia',
       'Wikipedia — Kia EV6 (citing Kia press materials)',
       NOW(),
       1,
       'https://en.wikipedia.org/wiki/Kia_EV6',
       'Used as 3rd cross-check alongside NHTSA and the existing Kia EV6 Owner''s Manual source.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Wikipedia — Kia EV6 (citing Kia press materials)');

SELECT 'EV6 backfill done' AS status,
       length_mm, width_mm, height_mm, wheelbase_mm,
       (SELECT COUNT(*) FROM trims WHERE generation_id=@gen) AS trims_now
FROM generations WHERE slug='ev6-suv-2021-present';
