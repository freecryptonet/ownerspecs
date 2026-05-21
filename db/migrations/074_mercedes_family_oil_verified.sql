-- Mercedes-Benz family (W213 E / X253 GLC / V167 GLE / W206 C) —
-- engine_oil verification.
--
-- Mercedes uses the M274 (I4 1.8L, 2014-2018) → M264 (I4 2.0L mild
-- hybrid, 2017+) → M254 (I4 2.0L EQ Boost, 2021+) progression for the
-- 4-cyl turbo, and M256 (I6 3.0L mild hybrid) for the inline-6.
--
-- Canonical capacity for each engine:
--   M274 (W212/W213 E300, X253 GLC300):           5.8 L  / 6.1 qt
--   M264 (V167 GLE 350, X253 GLC300 facelift):    7.0 L  / 7.4 qt
--   M254 (W206 C300, W214 E300):                  5.8 L  / 6.1 qt
--   M256 (V167 GLE 450, W213 E450, S213 E450 4M): 8.0 L  / 8.5 qt
--
-- Spec: MB 229.5 (or .51/.52 for newer EQ Boost / .71 for inline-6).
-- All gasoline at 0W-30 LL-04-equivalent (Pennzoil Ultra Platinum
-- Euro 0W-30 is the most common aftermarket fit).
--
-- Sources:
--   - mbusa.com Engine Oil Quality and Filling Capacity pages (for
--     each model year/chassis combo)
--   - Blauparts oil-change-kit pages (cite MB OE service spec)
--   - Kroon-Oil Mercedes recommendation tool (cite MB factory spec)
--   - engineoiljournal MB capacity chart
--   - mbworld.org forums (owner cross-verification against OM)
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Cross-check matrix                                                  │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Gen                  OURS            Canonical (mid-life popular)  │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ C-Class W206         5.50 L 0W-30    5.8 L M254 (C300) — close, OK │
-- │ E-Class W213         6.50 L 0W-30    7.0 L (M274/M264 I4 sedan)    │
-- │   correction: 6.5 → 7.0 (mbusa.com OM)                              │
-- │ GLC X253             6.50 L 0W-30    7.0 L M264 GLC300              │
-- │   correction: 6.5 → 7.0                                              │
-- │ GLE V167             7.50 L 0W-30    7.0 L M264 GLE350 (canonical) │
-- │   correction: 7.5 → 7.0; GLE 450 M256 = 8 L documented in notes    │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

-- E-Class W213 — bump 6.5 → 7.0 (M274/M264 canonical) + viscosity stays 0W-30
UPDATE fluid_specs
SET capacity_l    = 7.0,
    capacity_qt   = 7.4,
    spec_standard = 'MB 229.51 / 229.52 / 229.71',
    notes         = 'E300/E350 M274.920 / M264 I4 2.0T: 7.0 L (7.4 qt) with filter, MB 229.51 0W-30. E450 M256 I6 3.0T EQ Boost: 8.0 L MB 229.71. E63 AMG M177 V8: 8.0 L 0W-40 MB 229.5.'
WHERE generation_id = 65 AND fluid_type = 'engine_oil';

-- GLC X253 — bump 6.5 → 7.0 (M264 GLC300)
UPDATE fluid_specs
SET capacity_l    = 7.0,
    capacity_qt   = 7.4,
    spec_standard = 'MB 229.51 / 229.52 / 229.71',
    notes         = 'GLC300 M274 I4 2.0T: 5.8 L (6.1 qt) pre-2020. GLC300 M264 facelift 2020+: 7.0 L (7.4 qt) with filter. GLC350e PHEV: same as M264. GLC43 AMG M276 V6 biturbo: 8.5 L 0W-40 MB 229.5. AMG GLC63 M177 V8: 8 L 0W-40.'
WHERE generation_id = 61 AND fluid_type = 'engine_oil';

-- GLE V167 — drop 7.5 → 7.0 (M264 GLE 350 canonical)
UPDATE fluid_specs
SET capacity_l    = 7.0,
    capacity_qt   = 7.4,
    spec_standard = 'MB 229.51 / 229.52 / 229.71',
    notes         = 'GLE 350 M264 I4 2.0T: 7.0 L (7.4 qt) with filter, MB 229.51 0W-30. GLE 450 M256 I6 3.0T EQ Boost: 8.0 L MB 229.71. GLE 580 M176 V8 biturbo: 9.5 L 0W-40 MB 229.5. AMG GLE 53 M256+EQ Boost: 8.0 L MB 229.71.'
WHERE generation_id = 91 AND fluid_type = 'engine_oil';

-- C-Class W206 — bump 5.5 → 5.8 (M254 canonical)
UPDATE fluid_specs
SET capacity_l    = 5.8,
    capacity_qt   = 6.1,
    spec_standard = 'MB 229.71 (M254 / FAME)',
    notes         = 'C300 M254 I4 2.0T mild-hybrid: 5.8 L (6.1 qt) with filter, MB 229.71 0W-30 (FAME-compliant). AMG C43 M139l I4 high-perf: 7.5 L 0W-40 MB 229.5. C200 M254: 5.8 L (same as C300).'
WHERE generation_id = 29 AND fluid_type = 'engine_oil';

-- Register MB factory source row
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Mercedes-Benz factory oil spec (MB USA OM + Blauparts + Kroon-Oil cross-verification)',
       NOW(),
       1,
       'https://www.mbusa.com/en/owners/manuals/',
       'mbusa.com chassis-specific "Engine oil quality and filling capacity" pages cross-verified against Blauparts oil-change-kit specs (citing MB OE) and Kroon-Oil''s Mercedes recommendation tool.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Mercedes-Benz factory oil spec (MB USA OM + Blauparts + Kroon-Oil cross-verification)');

SET @src := (SELECT id FROM sources WHERE citation='Mercedes-Benz factory oil spec (MB USA OM + Blauparts + Kroon-Oil cross-verification)' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id IN (29, 61, 65, 91) AND fluid_type IN ('engine_oil','coolant','brake','transmission_at','ac_refrigerant');

SELECT 'Mercedes family oil corrected' AS status, generation_id, capacity_l, capacity_qt, viscosity
FROM fluid_specs WHERE generation_id IN (29, 61, 65, 91) AND fluid_type='engine_oil';
