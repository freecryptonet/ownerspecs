-- BMW B-series engine oil spec correction — replace lore LL-01 FE claims
-- with HaynesPro-verified LL-17 FE+, plus label normalization.
--
-- ISSUE: many B46/B48/B58 engine_oil rows in the catalog claim "BMW
-- Longlife-01 FE" or "BMW Longlife-01 FE" as the spec. BMW LL-01 was the
-- N-series-era spec phased out around 2015. B-series engines (introduced
-- 2014-2017) never officially listed LL-01 as preferred — they use
-- LL-12 FE / LL-14 FE / LL-17 FE+ / LL-19 FE / LL-22 FE++ depending on
-- production date and after-treatment (OPF / DPF).
--
-- VERIFIED 2026-05-23 via HaynesPro for B48B20B (G20 330i t_619015365):
--   Preferred: SAE 0W-20, BMW Longlife-17 FE+
--   Alternative: SAE 0W-30, BMW Longlife-19 FE
--   Alternative: SAE 0W-30, BMW Longlife-12 FE
--   Alternative: SAE 5W-30, BMW Longlife-04 (legacy, warranty-out)
--   Engine sump incl. filter: 5.25 L
--   Drain plug: 25 Nm (renew seal)
--
-- This migration only fixes the SPEC NAME (LL-01 → LL-17 FE+ for B-series)
-- and normalizes the label form. Capacity + viscosity left as-is — the
-- catalog 5.20/5.25 L values match HaynesPro within rounding tolerance,
-- and 0W-30 is a valid HaynesPro-listed alternative even though 0W-20 is
-- preferred. A future migration can swap to 0W-20 preferred if Tim wants
-- to mirror BMW's current preferred recommendation.
--
-- Scope: all engine_oil rows on engines with codes B38, B46, B47, B48,
-- B57, B58, S55, S58 (the modern B-series family + their S-derivatives).
-- N-series engines (N20, N13, N47, N57, N55, N63) keep LL-01 — that IS
-- the correct spec for those.

SET NAMES utf8mb4;

-- ============================================================================
-- 1. Replace LL-01 FE claims on B-series with LL-17 FE+
-- ============================================================================
UPDATE fluid_specs fs
JOIN engines e ON e.id = fs.engine_id
SET fs.spec_standard = 'BMW Longlife-17 FE+'
WHERE fs.fluid_type = 'engine_oil'
  AND e.code REGEXP '^(B38|B46|B47|B48|B57|B58|S55|S58)'
  AND fs.spec_standard IN ('BMW Longlife-01 FE', 'BMW LL-01 FE');

-- ============================================================================
-- 2. Normalize label variants for LL-17 FE+ to canonical form
-- ============================================================================
UPDATE fluid_specs fs
SET fs.spec_standard = 'BMW Longlife-17 FE+'
WHERE fs.fluid_type = 'engine_oil'
  AND fs.spec_standard IN ('BMW LL-17 FE+', 'BMW LL-17 FE+ (Longlife)', 'BMW LL-17 FE+ Longlife');

-- ============================================================================
-- 3. Same for LL-22 FE++ if any label variants exist
-- ============================================================================
UPDATE fluid_specs fs
SET fs.spec_standard = 'BMW Longlife-22 FE++'
WHERE fs.fluid_type = 'engine_oil'
  AND fs.spec_standard IN ('BMW LL-22 FE++', 'BMW LL-22 FE++ (Longlife)');

-- ============================================================================
-- 4. Audit
-- ============================================================================
SELECT e.code, COUNT(fs.id) AS n,
       GROUP_CONCAT(DISTINCT fs.spec_standard SEPARATOR ' | ') AS specs,
       GROUP_CONCAT(DISTINCT fs.viscosity SEPARATOR ' / ') AS viscs,
       GROUP_CONCAT(DISTINCT fs.capacity_l ORDER BY fs.capacity_l SEPARATOR ' / ') AS capacities
FROM fluid_specs fs
JOIN engines e ON e.id = fs.engine_id
WHERE fs.fluid_type = 'engine_oil'
  AND e.code REGEXP '^(B38|B46|B47|B48|B57|B58|S55|S58)'
GROUP BY e.code
ORDER BY e.code;
