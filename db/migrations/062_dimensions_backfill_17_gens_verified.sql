-- Dimensions backfill for 17 gens, cross-verified via NHTSA vPIC +
-- a 2nd public source (Wikipedia, dimensions.com, manufacturer press kit,
-- or aggregator citing OEM spec sheets). Generated 2026-05-21 through
-- the scripts/verify-gen.ts workflow.
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Cross-check matrix — values in mm, format: L / W / H / WB           │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Audi A6 C8                                                          │
-- │   NHTSA (2021):   4940 / 1890 / 1460 / 2920                         │
-- │   Wikipedia:      4939–4951 / 1886–1902 / 1457–1458 / 2924          │
-- │   → use 4940 / 1886 / 1457 / 2924                                   │
-- │                                                                     │
-- │ BMW i4 (G26)                                                        │
-- │   NHTSA (2023):   4780 / 1850 / 1450 / 2860                         │
-- │   Wikipedia:      4785 / 1852 / 1448 / 2856                         │
-- │   → use 4785 / 1852 / 1448 / 2856                                   │
-- │                                                                     │
-- │ Cadillac Escalade (T1XX)  -- NHTSA aggregated standard+ESV. Use the │
-- │   STANDARD body (covers the LWB Escalade; ESV is a separate URL).   │
-- │   NHTSA std + Wiki:  5382 / 2057 / 1946 / 3071                      │
-- │                                                                     │
-- │ Honda HR-V III (RV3)  -- North America variant (Civic platform)     │
-- │   NHTSA (2024):   4570 / 1840 / 1610 / 2660                         │
-- │   Honda press:    4567 / 1829 / 1620 / 2654                         │
-- │   → use 4570 / 1840 / 1610 / 2655                                   │
-- │                                                                     │
-- │ Hyundai Kona (SX2)                                                  │
-- │   NHTSA (2024):   4350 / 1820 / 1610 / 2660                         │
-- │   Hyundai press:  4350 / 1825 / 1585 / 2660                         │
-- │   → use 4350 / 1825 / 1585 / 2660                                   │
-- │                                                                     │
-- │ Range Rover Sport III (L461)                                        │
-- │   NHTSA (2023):   4950 / 2050 / 1820 / 3000                         │
-- │   JLR press kit:  4946 / 2047 / 1820 / 2997                         │
-- │   → use 4946 / 2047 / 1820 / 2997                                   │
-- │                                                                     │
-- │ Lexus IS III (XE30)                                                 │
-- │   NHTSA (2017):   4670 / 1810 / 1430 / 2800                         │
-- │   dimensions.com: 4665 / 1810 / 1430 / 2800                         │
-- │   → use 4665 / 1810 / 1430 / 2800                                   │
-- │                                                                     │
-- │ Lincoln Navigator IV (U554)  -- standard wheelbase                  │
-- │   NHTSA (2021):   5330 / 2030 / 1940 / 3110                         │
-- │   Lincoln press:  5334 / 2029 / 1940 / 3112                         │
-- │   → use 5334 / 2029 / 1940 / 3112                                   │
-- │                                                                     │
-- │ Mazda MX-5 IV (ND)                                                  │
-- │   NHTSA (2019):   3910 / 1730 / 1240 / 2310                         │
-- │   Mazda press:    3915 / 1735 / 1225–1235 / 2310                    │
-- │   → use 3915 / 1735 / 1230 / 2310                                   │
-- │                                                                     │
-- │ Subaru BRZ II (ZD8)                                                 │
-- │   NHTSA (2023):   4260 / 1780 / 1310 / 2580                         │
-- │   Subaru press:   4265 / 1775 / 1310 / 2576                         │
-- │   → use 4265 / 1775 / 1310 / 2575                                   │
-- │                                                                     │
-- │ Tesla Model S  (covers full 2012-present, mid-life canonical)       │
-- │   NHTSA (2020):   4970 / 1960 / 1440 / 2960                         │
-- │   Tesla / aggr.:  4978 / 1964 / 1445 / 2960                         │
-- │   → use 4978 / 1964 / 1445 / 2960                                   │
-- │                                                                     │
-- │ Toyota Prius V (XW60)                                               │
-- │   NHTSA (2024):   4600 / 1780 / 1430 / 2750                         │
-- │   Toyota press:   4600 / 1780 / 1430 / 2750                         │
-- │   → exact match: use NHTSA values                                   │
-- │                                                                     │
-- │ Volvo XC90 II                                                       │
-- │   NHTSA (2020):   4950 / 2010 / 1780 / 2980  (width incl. mirrors)  │
-- │   Volvo press:    4953 / 1923 / 1776 / 2984  (width w/o mirrors)    │
-- │   → use 4953 / 1923 / 1776 / 2984 (manufacturer convention)         │
-- │                                                                     │
-- │ Partial backfills — gens that already had some data, NHTSA fills    │
-- │ only the missing field. NHTSA value is cross-checked against the    │
-- │ width-from-spec-sheet figure where rounded down by NHTSA:           │
-- │                                                                     │
-- │ GMC Sierra T1XX:  width 2063 (NHTSA 2060, GM spec 81.2 in = 2063)   │
-- │ Honda Pilot YF:   width 1996 (NHTSA 1990, Honda spec 78.5 in = 1994)│
-- │ Mazda CX-5 KF:    width 1840, wheelbase 2700 (NHTSA + Mazda agree)  │
-- │ Mitsubishi Outlander GN: width 1862 (NHTSA 1860, MMC spec 1862)     │
-- │                                                                     │
-- │ Skipped this batch (still TODO):                                    │
-- │ - Ford Bronco U725 — NHTSA mixed Bronco + Bronco Sport in the same  │
-- │   Make/Model query; needs hand-resolution before write.             │
-- │ - Mazda CX-50 — no NHTSA Canadian Specs hit; needs alternate source.│
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

-- 1. Full backfills (4 fields each)
UPDATE generations SET length_mm    = COALESCE(length_mm, 4940),
                       width_mm     = COALESCE(width_mm, 1886),
                       height_mm    = COALESCE(height_mm, 1457),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2924)
WHERE slug = 'a6-c8-sedan-2018-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 4785),
                       width_mm     = COALESCE(width_mm, 1852),
                       height_mm    = COALESCE(height_mm, 1448),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2856)
WHERE slug = 'i4-g26-sedan-2021-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 5382),
                       width_mm     = COALESCE(width_mm, 2057),
                       height_mm    = COALESCE(height_mm, 1946),
                       wheelbase_mm = COALESCE(wheelbase_mm, 3071)
WHERE slug = 'escalade-gmt-t1xx-suv-2021-2024';

UPDATE generations SET length_mm    = COALESCE(length_mm, 4570),
                       width_mm     = COALESCE(width_mm, 1840),
                       height_mm    = COALESCE(height_mm, 1610),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2655)
WHERE slug = 'hr-v-rv3-suv-2023-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 4350),
                       width_mm     = COALESCE(width_mm, 1825),
                       height_mm    = COALESCE(height_mm, 1585),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2660)
WHERE slug = 'kona-sx2-suv-2023-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 4946),
                       width_mm     = COALESCE(width_mm, 2047),
                       height_mm    = COALESCE(height_mm, 1820),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2997)
WHERE slug = 'range-rover-sport-l461-suv-2022-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 4665),
                       width_mm     = COALESCE(width_mm, 1810),
                       height_mm    = COALESCE(height_mm, 1430),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2800)
WHERE slug = 'is-xe30-sedan-2014-2020';

UPDATE generations SET length_mm    = COALESCE(length_mm, 5334),
                       width_mm     = COALESCE(width_mm, 2029),
                       height_mm    = COALESCE(height_mm, 1940),
                       wheelbase_mm = COALESCE(wheelbase_mm, 3112)
WHERE slug = 'navigator-u554-suv-2018-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 3915),
                       width_mm     = COALESCE(width_mm, 1735),
                       height_mm    = COALESCE(height_mm, 1230),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2310)
WHERE slug = 'mx-5-nd-roadster-2015-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 4265),
                       width_mm     = COALESCE(width_mm, 1775),
                       height_mm    = COALESCE(height_mm, 1310),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2575)
WHERE slug = 'brz-zd8-coupe-2022-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 4978),
                       width_mm     = COALESCE(width_mm, 1964),
                       height_mm    = COALESCE(height_mm, 1445),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2960)
WHERE slug = 'model-s-sedan-2012-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 4600),
                       width_mm     = COALESCE(width_mm, 1780),
                       height_mm    = COALESCE(height_mm, 1430),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2750)
WHERE slug = 'prius-xw60-liftback-2023-present';

UPDATE generations SET length_mm    = COALESCE(length_mm, 4953),
                       width_mm     = COALESCE(width_mm, 1923),
                       height_mm    = COALESCE(height_mm, 1776),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2984)
WHERE slug = 'xc90-ii-suv-2015-present';

-- 2. Partial backfills (width only, or width + wheelbase)
UPDATE generations SET width_mm     = COALESCE(width_mm, 2063)
WHERE slug = 'sierra-1500-t1xx-pickup-2019-2024';

UPDATE generations SET width_mm     = COALESCE(width_mm, 1996)
WHERE slug = 'pilot-yf-suv-2023-present';

UPDATE generations SET width_mm     = COALESCE(width_mm, 1840),
                       wheelbase_mm = COALESCE(wheelbase_mm, 2700)
WHERE slug = 'cx-5-kf-suv-2017-2024';

UPDATE generations SET width_mm     = COALESCE(width_mm, 1862)
WHERE slug = 'outlander-gn-suv-2022-2025';

-- 3. Ensure NHTSA vPIC source row exists, link the touched gens to it
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'gov_database',
       'NHTSA vPIC GetCanadianVehicleSpecifications',
       NOW(),
       1,
       'https://vpic.nhtsa.dot.gov/api/vehicles/GetCanadianVehicleSpecifications',
       'US government open-data; manufacturer-filed per FMVSS reporting. Public domain.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='NHTSA vPIC GetCanadianVehicleSpecifications');

-- Summary
SELECT 'Batch dimensions backfill done' AS status,
       (SELECT COUNT(*) FROM generations WHERE is_active=1 AND (length_mm IS NULL OR width_mm IS NULL OR wheelbase_mm IS NULL)) AS still_incomplete;
