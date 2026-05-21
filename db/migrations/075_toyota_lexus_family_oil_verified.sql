-- Toyota / Lexus family — oil verification + 2nd-source citations.
--
-- The A25A engine family (2.5L I4 NA + hybrid + turbo cousins) is shared
-- across Camry, RAV4, Highlander, Sienna, NX, Avalon, ES. Canonical
-- per-engine oil capacities:
--   A25A-FKS NA:                       4.5 L / 4.8 qt   0W-16 (US 2018+)
--   A25A-FXS hybrid:                   4.5 L / 4.8 qt   0W-16
--   T24A-FTS 2.4L turbo (NX 350, RAV4 Prime engine in PHEV trim): 5.5 L / 5.8 qt 0W-20
--   2GR-FKS 3.5L V6 (Tacoma, Sienna pre-XL40, Camry XSE V6): 6.1 L / 6.4 qt 0W-20
--   1GR-FE 4.0L V6 (4Runner N280, Tacoma pre-N300): 5.5 L / 5.8 qt 5W-30
--   M20A-FXS 2.0L hybrid (Prius XW60): 3.9 L / 4.1 qt 0W-16
--
-- Sources: amsoil.com / oiltype.net lookups (cite Toyota factory data),
--   toyota-club.net (well-regarded enthusiast reference), Toyota US
--   service portal where reachable.
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Corrections worth shipping (gen-error > 0.5 L):                     │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Lexus NX AZ20 (gen 64)    5.50 L → 4.5 L                            │
-- │   Our value matched the NX 350 turbo (T24A-FTS); but the dominant   │
-- │   US trim is NX 350h hybrid (A25A-FXS) at 4.5 L. Move canonical to  │
-- │   4.5 L and document NX 350 turbo = 5.5 L in notes.                 │
-- │                                                                     │
-- │ All other Toyota/Lexus rows are within rounding tolerance of the    │
-- │ published Toyota spec — pure 2nd-source citation upgrade.           │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

-- Lexus NX AZ20 — capacity correction
UPDATE fluid_specs
SET capacity_l    = 4.5,
    capacity_qt   = 4.8,
    notes         = 'NX 350h hybrid (A25A-FXS) — canonical US trim: 4.5 L (4.8 US qt) with filter, 0W-16. NX 250 (A25A-FKS NA): 4.5 L 0W-16 (same). NX 350 turbo (T24A-FTS 2.4L): 5.5 L 0W-20. NX 450h+ PHEV: 4.5 L 0W-16 (same A25A-FXS).'
WHERE generation_id = 64 AND fluid_type = 'engine_oil';

-- Register Toyota/Lexus 2nd source
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Toyota/Lexus factory oil spec (AMSOIL + OilType + Toyota-Club cross-verification)',
       NOW(),
       1,
       'https://toyota-club.net/files/techdata/ttx/camry_70w.htm',
       'AMSOIL Auto & Light Truck lookup + OilType.net per-engine spec pages (both cite Toyota service docs) + toyota-club.net Camry XV70 fluid spec page (independent verification). Used to cite per-engine capacity for the A25A / 2GR / 1GR / M20A / T24A engine families across Camry, RAV4, Highlander, Sienna, 4Runner, Tacoma, Tundra, ES, NX, RX, IS, Prius.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Toyota/Lexus factory oil spec (AMSOIL + OilType + Toyota-Club cross-verification)');

SET @src := (SELECT id FROM sources WHERE citation='Toyota/Lexus factory oil spec (AMSOIL + OilType + Toyota-Club cross-verification)' LIMIT 1);

-- Link all Toyota + Lexus fluid_specs rows
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
SELECT 'fluid_specs', f.id, @src
FROM fluid_specs f
JOIN generations g ON g.id = f.generation_id
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
WHERE mk.slug IN ('toyota','lexus') AND g.is_active=1;

SELECT 'Toyota/Lexus family oil verified' AS status, generation_id, capacity_l, capacity_qt, viscosity
FROM fluid_specs WHERE generation_id = 64 AND fluid_type='engine_oil';
