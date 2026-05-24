-- mig 365: link Mopar OEM Owner's Manual sources (mig 363) to existing fluid_specs rows;
-- update gen-level fuel_tank where Mopar PDF reveals a different/more accurate value.
--
-- Source: 7 Mopar OEM Owner's Manual PDFs (sources 858-864 from mig 363).
-- Extraction method: pypdf coordinate-based visitor_text → grouped by Y-bucket → table rows.
-- See scripts/extract_mopar_caps.py and scripts/output/mopar_fluid_extracts.json.
--
-- The fluid_specs rows already exist (populated in prior sessions, notes mention "Mopar OM ...").
-- This mig:
--   1. Fixes fuel_tank_l mismatches against Mopar's published values
--   2. Adds Mopar source citations as a 2nd source per row (Tim's two-source rule)
--   3. Adds the public_link=1 flag where appropriate (manufacturer-owned CDN)

-- 1. Fuel-tank corrections from Mopar OM data

-- Wrangler JL (gen 37): Mopar OM 2020 lists 2-Door=66L AND 4-Door=81L.
-- DB has 66L (2-Door only). Update to 81L (4-Door is the more common variant in JL gen)
-- and add a note about the 2-Door capacity.
UPDATE generations SET fuel_tank_l = 81.0 WHERE id = 37 AND fuel_tank_l = 66.0;
-- 2-Door: 66 L (17.5 gal); 4-Door: 81 L (21.5 gal). 4-Door is the more common variant.

-- Ram 1500 DT (gen 43): Mopar OM 2022 lists Standard=98L, Long Optional=121L, Diesel=98.5L.
-- DB has 125L which doesn't match any Mopar-published value. Update to standard 98L.
UPDATE generations SET fuel_tank_l = 98.0 WHERE id = 43;
-- Standard short/crew cab: 98 L (26 gal). Long-bed optional: 121 L (33 gal). 3.0 EcoDiesel: 98.5 L.

-- 2. Cite each existing fluid_specs row on 7 Stellantis gens to the Mopar OM source
--    (gen → source mapping per mig 363)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, CASE
      WHEN fs.generation_id = 37  THEN 864   -- Jeep Wrangler JL 2020 OM
      WHEN fs.generation_id = 43  THEN 861   -- Ram 1500 DT 2022 OM
      WHEN fs.generation_id = 69  THEN 858   -- Jeep Grand Cherokee WL 2023 OM
      WHEN fs.generation_id = 86  THEN 862   -- Chrysler Pacifica RU 2020 OM
      WHEN fs.generation_id = 122 THEN 860   -- Dodge Charger LD 2017 OM
      WHEN fs.generation_id = 123 THEN 863   -- (NB: 863 is Chrysler 300; for Charger LX use 859)
      WHEN fs.generation_id = 124 THEN 863   -- Chrysler 300 LX 2008 OM
    END
  FROM fluid_specs fs
  WHERE fs.generation_id IN (37, 43, 69, 86, 122, 124);

-- Charger LX (gen 123) cites the Dodge Charger LX 2008 OM (source 859), not the Chrysler 300 OM
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, 859
  FROM fluid_specs fs
  WHERE fs.generation_id = 123;

-- 3. Flip Mopar source rows to public_link=1 (manufacturer-owned CDN, manufacturer brand)
UPDATE sources SET public_link = 1 WHERE id IN (858, 859, 860, 861, 862, 863, 864);
