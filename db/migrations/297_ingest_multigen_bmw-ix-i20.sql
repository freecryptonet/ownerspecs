-- mig 297 — multi-gen HaynesPro ingest: BMW iX (I20)
-- crawl: haynespro-crawl-bmw-ix-i20-2026-05-23.json
-- modelId: d_319009108
-- 1 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — BMW iX (I20)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319009108', NOW(), 'Multi-gen ingest, 1 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319009108' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('XE2', 'M60 (XE2) 397kW', 0, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 266, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4 LV', 'HaynesPro chassis d_319009108;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 266 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (266)
  AND e.code IN ('XE2')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (266)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (266) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;