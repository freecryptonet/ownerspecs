-- Engine oil corrections from the 2026-05-23 comparator audit
-- (docs/oil-audit-2026-05-23.md, 34 rows audited / 18 flagged).
--
-- Comparator data: scrapers/output/haynespro-oil-{engine_code}.json
-- (16 engines harvested via Playwright on Tim's authenticated HaynesPro session).
--
-- THREE categories of finding, filtered to load-bearing corrections only:
--
-- 1) BMW B48B20 viscosity inconsistency — 12 rows claim "0W-30 + BMW
--    Longlife-17 FE+". HaynesPro: preferred is "0W-20 + LL-17 FE+".
--    LL-17 FE+ is paired with 0W-20 per BMW spec sheet — 0W-30 is the
--    LL-19 FE / LL-12 FE / LL-04 alternatives, not LL-17 FE+. The catalog
--    pairing was internally inconsistent. Fix viscosity to 0W-20.
--
-- 2) Honda CR-V RS capacity off by 0.3 L (3.80 → 3.50). HaynesPro L15B7
--    Civic X shows sump 3.5 L incl filter. The CR-V RS uses the SAME
--    L15B7 engine — 3.80 was lore.
--
-- 3) Toyota RAV4 XA50 capacity off by 0.3 L (4.80 → 4.50). HaynesPro
--    A25A-FKS Camry XV70 shows sump 4.5 L incl filter. RAV4 uses same
--    engine — 4.80 was lore.
--
-- Skipped (not load-bearing):
-- - Honda "API SP / ILSAC GF-6" vs HaynesPro "Honda HFE-20" — same oil,
--   different naming. API SP is more useful to consumers than the Honda
--   vendor name. Leave as-is.
-- - Toyota "API SP" vs HaynesPro "API SN" — catalog is NEWER spec (API SP
--   came in 2020); HaynesPro shows the older base spec from before the
--   update. Catalog is correct.
-- - Camry XV70 4.40 vs 4.50 — within 0.2 L tolerance, defensible
--   per-trim variation.

SET NAMES utf8mb4;

-- ============================================================================
-- 1. BMW B48B20 viscosity fix — 0W-30 → 0W-20 (matches LL-17 FE+ spec)
-- ============================================================================
UPDATE fluid_specs fs
JOIN engines e ON e.id = fs.engine_id
SET fs.viscosity = '0W-20'
WHERE fs.fluid_type = 'engine_oil'
  AND e.code IN ('B48B20', 'B48B20B', 'B46B20')
  AND fs.viscosity = '0W-30'
  AND fs.spec_standard = 'BMW Longlife-17 FE+';

-- ============================================================================
-- 2. Honda CR-V RS engine oil capacity correction — 3.80 → 3.50 L
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
JOIN engines e ON e.id = fs.engine_id
SET fs.capacity_l = 3.50,
    fs.capacity_qt = 3.70
WHERE fs.fluid_type = 'engine_oil'
  AND e.code = 'L15B7'
  AND g.slug = 'cr-v-rs-suv-2023-present'
  AND fs.capacity_l = 3.80;

-- ============================================================================
-- 3. Toyota RAV4 XA50 engine oil capacity correction — 4.80 → 4.50 L
-- ============================================================================
UPDATE fluid_specs fs
JOIN generations g ON g.id = fs.generation_id
JOIN engines e ON e.id = fs.engine_id
SET fs.capacity_l = 4.50,
    fs.capacity_qt = 4.76
WHERE fs.fluid_type = 'engine_oil'
  AND e.code = 'A25A-FKS'
  AND g.slug = 'rav4-xa50-suv-2019-2021'
  AND fs.capacity_l = 4.80;

-- ============================================================================
-- Audit
-- ============================================================================
SELECT e.code, COUNT(fs.id) AS n,
       GROUP_CONCAT(DISTINCT fs.capacity_l ORDER BY fs.capacity_l SEPARATOR ' / ') AS capacities,
       GROUP_CONCAT(DISTINCT fs.viscosity SEPARATOR ' / ') AS viscs,
       GROUP_CONCAT(DISTINCT fs.spec_standard SEPARATOR ' | ') AS specs
FROM fluid_specs fs
JOIN engines e ON e.id = fs.engine_id
WHERE fs.fluid_type = 'engine_oil'
  AND e.code IN ('B48B20', 'B48B20B', 'B46B20', 'L15B7', 'A25A-FKS')
GROUP BY e.code
ORDER BY e.code;
