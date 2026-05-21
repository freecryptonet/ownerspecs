-- Hyundai / Kia / Genesis family — oil verification + bulk 2nd-source citation.
--
-- The Smartstream / Theta / Lambda engine families are shared across the
-- three brands (Hyundai-Kia owns Genesis). Canonical per-engine capacities:
--
--   Nu 2.0 MPI (G2.0 Smartstream NA):           4.2 L  / 4.4 qt   0W-20
--   Smartstream G1.6T (1.6L turbo, Kona/Elantra N-Line): 3.8 L 0W-20
--   Smartstream G2.5T (2.5L turbo, Sonata N-Line / GV70 base): 5.7 L 0W-20
--   Lambda II 3.3T (legacy V6 twin-turbo G70 / GV70): 6.4 L  5W-30
--   Lambda III 3.5T (V6 twin-turbo GV70 3.5T / Palisade Hyundai): 6.4 L 5W-30
--   Lambda II 3.8 NA (legacy V6 Genesis / Palisade): 5.7 L 5W-30
--   Theta T-GDi 2.0T (Genesis G70 base / Tucson old): 5.0 L 5W-30
--   Hybrid G2.5 + electric (Santa Fe / Sorento HEV): 4.5 L 0W-20
--   E-GMP (BEV: IONIQ 5, EV6, GV60, GV70 EV): reduction-gear oil only
--
-- Sources: AMSOIL Hyundai/Kia lookups, checkeredflaghyundaiworld.com
-- per-model pages (citing Hyundai owner's manual), engineoildb,
-- ownersmanual.hyundai.com fluid recommendation tables.
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Corrections worth shipping:                                         │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Elantra CN7 (gen 45)   3.50 L 5W-30 → 4.2 L 0W-20                  │
-- │   Our value matched the G1.6T but base Elantra uses 2.0 Nu MPI.    │
-- │   Hyundai US spec: 4.2 L 0W-20 for 2.0L Nu MPI canonical.          │
-- │                                                                     │
-- │ Kona SX2 (gen 118)     4.30 L 5W-30 → 4.2 L 0W-20                  │
-- │   2.0L Nu MPI base trim. Viscosity 5W-30 was wrong (Hyundai US     │
-- │   spec is 0W-20 for the 2.0L NA Smartstream).                       │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

-- Elantra CN7 — capacity + viscosity correction
UPDATE fluid_specs
SET capacity_l = 4.2,
    capacity_qt = 4.4,
    viscosity = '0W-20',
    notes = 'Elantra base SE/SEL 2.0L Nu MPI (G2.0 Smartstream NA): 4.2 L (4.4 qt) with filter, 0W-20 API SP. Elantra N-Line 1.6T (G1.6T turbo): 3.8 L 0W-20. Elantra Hybrid 1.6L + electric: 3.8 L 0W-20. Elantra N 2.0T (Theta II): 5.0 L 5W-30.'
WHERE generation_id = 45 AND fluid_type = 'engine_oil';

-- Kona SX2 — viscosity correction
UPDATE fluid_specs
SET capacity_l = 4.2,
    capacity_qt = 4.4,
    viscosity = '0W-20',
    notes = 'Kona SE/SEL base 2.0L Nu MPI (G2.0 Smartstream NA, 147 hp): 4.2 L (4.4 qt) with filter, 0W-20 API SP. Kona N-Line / Limited 1.6T (G1.6T turbo, 190 hp): 3.8 L 0W-20. Kona Electric: reduction-gear oil only.'
WHERE generation_id = 118 AND fluid_type = 'engine_oil';

-- Register Hyundai/Kia/Genesis 2nd source
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Hyundai/Kia/Genesis factory oil spec (AMSOIL + checkeredflag + engineoildb cross-verification)',
       NOW(),
       1,
       'https://ownersmanual.hyundai.com/docview/webhelp/doc/8bf31204-4eb5-48f8-a3be-f1c555de698f/id16b1d73f4d3.html',
       'AMSOIL per-engine lookup + checkeredflaghyundaiworld.com per-model OEM-citing pages + engineoildb Hyundai/Kia capacity guides + Hyundai owner''s manual portal "Recommended lubricants and capacities" reference table.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Hyundai/Kia/Genesis factory oil spec (AMSOIL + checkeredflag + engineoildb cross-verification)');

SET @src := (SELECT id FROM sources WHERE citation='Hyundai/Kia/Genesis factory oil spec (AMSOIL + checkeredflag + engineoildb cross-verification)' LIMIT 1);

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
SELECT 'fluid_specs', f.id, @src
FROM fluid_specs f
JOIN generations g ON g.id = f.generation_id
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
WHERE mk.slug IN ('hyundai','kia','genesis') AND g.is_active=1;

SELECT 'Hyundai/Kia/Genesis verified' AS status,
       (SELECT COUNT(*) FROM spec_sources WHERE source_id=@src) AS rows_linked;
