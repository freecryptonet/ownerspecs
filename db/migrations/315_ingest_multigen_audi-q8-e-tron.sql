-- mig 315 — multi-gen HaynesPro ingest: Audi Q8 e-tron (GET, GEG)
-- crawl: haynespro-crawl-audi-q8-e-tron-2026-05-23.json
-- modelId: d_319017708
-- 3 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi Q8 e-tron (GET, GEG)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319017708', NOW(), 'Multi-gen ingest, 3 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319017708' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('EASB', '50 Quattro (EASB) 250kW', 0, 'petrol', 'NA', NULL),
  ('EASA', '55 Quattro (EASA) 300kW', 0, 'petrol', 'NA', NULL),
  ('EAVA', 'SQ8 (EAVA) 370kW', 0, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 292, 'coolant', (SELECT id FROM engines WHERE code = 'EASB'), 20, 21.13, NULL, NULL, 'HaynesPro typeId t_619113258; 50 Quattro'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 292 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'EASB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 292, 'coolant', (SELECT id FROM engines WHERE code = 'EASA'), 20, 21.13, NULL, NULL, 'HaynesPro typeId t_619112889; 55 Quattro'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 292 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'EASA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 292, 'coolant', (SELECT id FROM engines WHERE code = 'EAVA'), 20, 21.13, NULL, NULL, 'HaynesPro typeId t_619112888; SQ8'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 292 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'EAVA'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 292, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319017708;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 292 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (292)
  AND e.code IN ('EASB', 'EASA', 'EAVA')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (292)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (292) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;