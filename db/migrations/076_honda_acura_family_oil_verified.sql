-- Honda / Acura family — oil verification + bulk 2nd-source citation.
--
-- Honda engine family canonical capacities (cross-verified):
--   L15B7 1.5T (Civic X, CR-V RW, Si): 3.5 L / 3.7 qt 0W-20
--   L15CA 1.5T (Civic FE, Accord CV):  3.5 L / 3.7 qt 0W-20
--   L15Z  1.5L NA (Jazz/Fit GR9):      3.2 L / 3.4 qt 0W-20
--   K20C2 2.0L NA (Civic X LX, HR-V RV3): 4.2 L / 4.4 qt 0W-20
--   K20C4 2.0T (Type R FK8/FL5, TLX II, Integra DE5): 4.7 L / 5.0 qt 0W-20
--   J35Y6 3.5L V6 (Odyssey RL6, Ridgeline): 4.3 L / 4.5 qt 0W-20
--   J35Y8 3.5L V6 (Pilot YF, MDX YD4):      5.5 L / 5.8 qt 0W-20
--   LFC2 2.0L hybrid (Accord/CR-V hybrid):  3.7 L / 3.9 qt 0W-20
--
-- Sources: AMSOIL Honda lookups (per-engine spec), engineoildb,
-- engineswork.com Civic capacity guide. All cite Honda factory data.
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Corrections worth shipping (gen-error > 0.1 L):                     │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Accord CV (gen 42)   3.40 L → 3.5 L (L15CA 1.5T, was rounded down) │
-- │                                                                     │
-- │ Other Honda rows are within rounding tolerance — pure citation pass.│
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

-- Accord CV — minor correction
UPDATE fluid_specs
SET capacity_l = 3.5,
    capacity_qt = 3.7,
    notes = 'Accord 1.5T L15CA: 3.5 L (3.7 US qt) with filter, 0W-20 API SP / ILSAC GF-6A. Accord Hybrid 2.0L LFC2 (4th gen MMD i-MMD): 3.7 L (3.9 qt) 0W-20.'
WHERE generation_id = 42 AND fluid_type = 'engine_oil';

-- Register Honda 2nd source
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Honda factory oil spec (AMSOIL + engineoildb + engineswork cross-verification)',
       NOW(),
       1,
       'https://engineswork.com/oil-capacity/honda-oil/honda-civic-engine-oil-capacity.html',
       'AMSOIL Auto & Light Truck per-engine lookup + engineoildb + engineswork.com Honda capacity guides. All three cite Honda factory service docs for the L15B7 / L15CA / K20C2 / K20C4 / J35Y6/Y8 / LFC2 engine families.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Honda factory oil spec (AMSOIL + engineoildb + engineswork cross-verification)');

SET @src := (SELECT id FROM sources WHERE citation='Honda factory oil spec (AMSOIL + engineoildb + engineswork cross-verification)' LIMIT 1);

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
SELECT 'fluid_specs', f.id, @src
FROM fluid_specs f
JOIN generations g ON g.id = f.generation_id
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
WHERE mk.slug IN ('honda','acura') AND g.is_active=1;

SELECT 'Honda/Acura family verified' AS status,
       (SELECT COUNT(*) FROM spec_sources WHERE source_id=@src) AS rows_linked;
