-- BMW + Honda + Toyota coolant audit corrections (extends the VW Group
-- pattern of mig 202/204/207).
--
-- Per-chassis HaynesPro verification on 2026-05-23:
--
--   BMW chassis           HaynesPro verdict
--   --------------------- ----------------------------------------------
--   F30/F31 (2012-2018)   Pre-01/2019 spec: "BMW LC-87" 8.10 L
--                         (verified F30 320i B48 t_317000540)
--   G20/G21 (2019-2022)   Pre-01/2019 spec: "BMW LC-87" / post: "BMW LC-18" 9.80 L
--                         G20 launched late 2018 so effectively LC-18 from launch
--                         (verified G20 330i B48 t_619015365)
--   G30/G31 (2017-2020)   MIXED: spans the 01/01/2019 switch
--   G30/G31 LCI (2020-)   BMW LC-18 (already correct)
--   G60/G61/G90 (2023-)   BMW LC-18 (already correct, mig 200/i5)
--   X3 G01 (2018-2024)    MIXED: spans the switch
--   X5 G05 (2019-2023)    BMW LC-18 (launched 2019 = post-switch)
--   M3/M5 G80/G90 (2020+) BMW LC-18 (already correct)
--   M3 F80 (2014-2018)    BMW LC-87 (pre-switch chassis)
--   M5 F90 (2018-2023)    MIXED (launched 2018, spans switch)
--   i4 G26, i5 G60/G61    BMW LC-18 (already correct for HV-cooling system)
--
--   Honda chassis         HaynesPro verdict
--   --------------------- ----------------------------------------------
--   Civic X (2016-2021)   "Honda Pro HP Type 2 Coolant" (verified L15B7 t_319005573)
--                         Type 2 is BLUE per Honda's own spec sheet —
--                         catalog "pink" claim is wrong.
--
--   Toyota chassis        HaynesPro verdict
--   --------------------- ----------------------------------------------
--   Camry XV70 (2018-)    "Toyota Super Longlife Coolant" (verified A25A-FKS t_619020126)
--   All Toyota/Lexus      Toyota SLLC pink — chemistry correct, normalize label only.
--
-- "BMW G48" in our catalog refers to the HOAT chemistry FAMILY (HT-12 / G48
-- / SunFlex / Pentosin Pentofrost). BMW-specific formula names ARE LC-87
-- (pre-2019) and LC-18 (post-2019). Both fall within the G48 family. The
-- catalog should use the BMW-specific formula name for E-E-A-T.

SET NAMES utf8mb4;

-- ============================================================================
-- 1. BMW pre-switch chassis (LC-87)
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'BMW LC-87 (HOAT, blue-green silicate, pre-2019 BMW spec; G48-class)'
WHERE g.slug IN (
    '3-series-f30-sedan-2012-2015',
    '3-series-f31-touring-2012-2015',
    '3-series-f30-lci-sedan-2015-2018',
    '3-series-f31-lci-touring-2015-2019',
    'm3-f80-sedan-2014-2018'
)
  AND fs.fluid_type = 'coolant';

-- ============================================================================
-- 2. BMW LC-18 chassis (2019+ launches, fully post-switch)
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'BMW LC-18 (HOAT, blue-green silicate, lifetime fill; G48-class)'
WHERE g.slug IN (
    '3-series-sedan-g20-2019-2022',
    '3-series-g21-touring-2019-2022',
    'x5-g05-suv-2019-2023'
)
  AND fs.fluid_type = 'coolant'
  AND fs.spec_standard NOT LIKE '%HV%';

-- BMW LC-18 + HV loop variant (X5 G05 45e PHEV)
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'BMW LC-18 + HV battery loop (HOAT lifetime fill, PHEV-specific dual circuit)'
WHERE g.slug = 'x5-g05-suv-2019-2023'
  AND fs.fluid_type = 'coolant'
  AND fs.spec_standard LIKE '%HV%';

-- ============================================================================
-- 3. BMW MIXED chassis (span the 01/01/2019 switch)
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'BMW LC-87 pre-01/2019 or BMW LC-18 post-01/01/2019 (HOAT, blue-green silicate, G48-class)'
WHERE g.slug IN (
    '5-series-g30-sedan-2017-2020',
    '5-series-g31-touring-2017-2020',
    'x3-g01-suv-2018-2024',
    'm5-f90-sedan-2018-2023'
)
  AND fs.fluid_type = 'coolant';

-- ============================================================================
-- 4. Honda Civic X coolant — pink → blue (chemistry stays Type 2)
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = 'Honda Type 2 Long Life Antifreeze/Coolant (blue, OAT, pre-mixed)'
WHERE g.slug = 'civic-sedan-x-2016-2021'
  AND fs.fluid_type = 'coolant'
  AND fs.spec_standard LIKE '%pink%';

-- ============================================================================
-- 5. Toyota / Lexus SLLC — normalize label across catalog
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
SET fs.spec_standard = CASE
        WHEN fs.spec_standard LIKE '%inverter%' OR fs.spec_standard LIKE '%HV%'
            THEN 'Toyota Super Long Life Coolant (SLLC, pink) + inverter / HV loop'
        ELSE 'Toyota Super Long Life Coolant (SLLC, pink)'
    END
WHERE g.id IN (
    SELECT id FROM generations
    WHERE model_id IN (
        SELECT m.id FROM models m JOIN makes mk ON mk.id=m.make_id
        WHERE mk.slug IN ('toyota','lexus')
    )
)
  AND fs.fluid_type = 'coolant';

-- ============================================================================
-- 6. Audit
-- ============================================================================
SELECT mk.slug AS brand, g.slug, COUNT(fs.id) AS n, GROUP_CONCAT(DISTINCT fs.spec_standard SEPARATOR ' | ') AS specs
FROM fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
JOIN makes mk ON mk.id = (SELECT make_id FROM models WHERE id = g.model_id)
WHERE mk.slug IN ('bmw','honda','toyota','lexus')
  AND fs.fluid_type = 'coolant'
GROUP BY g.id
ORDER BY mk.slug, g.start_year;
