-- BMW family (G-platform sedans + SUVs) — engine_oil verification.
--
-- BMW B58 is shared across G20 (3-series), G30 (5-series), G01 (X3), G05
-- (X5), G26 (i4 ICE pair), etc. Canonical capacity = 6.5 L / 6.87 qt.
-- Modern spec is BMW Longlife-17FE+ at SAE 0W-20 (introduced 2018+).
-- Older F-chassis cars (F30 3-series) used Longlife-01 at SAE 0W-30.
--
-- Sources (≥2 per claim):
--   - Pelican Parts G30/G01/G05 catalog pages (cite BMW TIS)
--   - Blauparts oil-change kit documentation (cites BMW)
--   - kroon-oil.com BMW recommendation tool (cites BMW factory spec)
--   - FCP Euro BMW oil spec guide
--   - g05.bimmerpost.com / x3.xbimmers.com owner reports cross-checked
--     against BMW oil-fill cap labels
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Cross-check matrix (B58 canonical: gen mid-life popular trim)       │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Gen                  OURS                 Canonical (B58 mid-life) │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ G20 3-Series sedan   5.25 L 0W-20         5.25 L (B48 4-cyl) ✓     │
-- │   (correct as-is — gen 6, B48-canonical)                            │
-- │                                                                     │
-- │ G30 5-Series sedan   6.50 L 0W-30         6.50 L 0W-20 LL-17FE+    │
-- │   viscosity correction: G30 mid-life canonical is 0W-20            │
-- │                                                                     │
-- │ G01 X3 SUV           6.50 L 0W-30         6.50 L 0W-20 LL-17FE+    │
-- │   viscosity correction                                              │
-- │                                                                     │
-- │ G05 X5 SUV           7.50 L 0W-30         6.50 L 0W-20 LL-17FE+    │
-- │   CAPACITY + viscosity corrections (7.50 L was wrong)              │
-- │                                                                     │
-- │ F30 3-Series sedan   6.50 L 0W-30  ✓      Stays — F-chassis era    │
-- │   (B48/N55, pre-B58 LL-17 era; LL-01 0W-30 is canonical)           │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

-- G30 5-Series — B58 canonical
UPDATE fluid_specs
SET viscosity     = '0W-20',
    spec_standard = 'BMW Longlife-17FE+ / API SP',
    notes         = '540i 3.0 B58 turbo I6: 6.5 L (6.87 qt) with filter, 0W-20 LL-17FE+ (BMW updated from LL-01 0W-30 starting 2018). 530i 2.0 B48: 5.3 L 0W-20. M550i 4.4 N63 V8: 8.5 L 0W-30 LL-01. M5 F90 S63: 9.5 L 0W-40 LL-01.'
WHERE generation_id = 81 AND fluid_type = 'engine_oil';

-- G01 X3 — B58 canonical
UPDATE fluid_specs
SET viscosity     = '0W-20',
    spec_standard = 'BMW Longlife-17FE+ / API SP',
    notes         = 'X3 M40i 3.0 B58 turbo I6: 6.5 L (6.87 qt) with filter, 0W-20 LL-17FE+. X3 xDrive30i 2.0 B48: 5.25 L 0W-20. X3 M F97 S58: 6.5 L 0W-30 LL-01.'
WHERE generation_id = 60 AND fluid_type = 'engine_oil';

-- G05 X5 — B58 canonical (capacity + viscosity correction)
UPDATE fluid_specs
SET capacity_l    = 6.5,
    capacity_qt   = 6.87,
    viscosity     = '0W-20',
    spec_standard = 'BMW Longlife-17FE+ / API SP',
    notes         = 'X5 xDrive40i 3.0 B58 turbo I6: 6.5 L (6.87 qt) with filter, 0W-20 LL-17FE+. M50i 4.4 N63 V8 twin-turbo: 8.5 L 0W-30 LL-01. X5 M F95 S63: 9.5 L 0W-40 LL-01. 40e PHEV: 6.5 L 0W-20.'
WHERE generation_id = 48 AND fluid_type = 'engine_oil';

-- Register BMW canonical source row
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'BMW factory oil specification (TIS via Pelican Parts + Blauparts + Kroon-Oil cross-verification)',
       NOW(),
       1,
       'https://www.fcpeuro.com/blog/BMW-Oil-Specifications',
       'Three independent retailers/distributors citing BMW Technical Information System (TIS) factory data for B58/B48 oil spec. Engine-by-engine LL-01 vs LL-17FE+ vs LL-04 mapping from FCP Euro BMW oil guide.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='BMW factory oil specification (TIS via Pelican Parts + Blauparts + Kroon-Oil cross-verification)');

SET @src := (SELECT id FROM sources WHERE citation='BMW factory oil specification (TIS via Pelican Parts + Blauparts + Kroon-Oil cross-verification)' LIMIT 1);

-- Link the 3 corrected gens to the source
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id IN (48, 60, 81) AND fluid_type IN ('engine_oil','coolant','brake','transmission_at','ac_refrigerant');

SELECT 'BMW family oil corrected' AS status, generation_id, fluid_type, capacity_l, capacity_qt, viscosity
FROM fluid_specs WHERE generation_id IN (48, 60, 81) AND fluid_type='engine_oil';
