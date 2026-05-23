-- mig 241 — multi-gen HaynesPro ingest: Honda Civic XI (FE, FL)
-- crawl: haynespro-crawl-honda-civic-xi-fe-2026-05-23.json
-- modelId: d_319010573
-- 1 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Honda Civic XI (FE, FL)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319010573', NOW(), 'Multi-gen ingest, 1 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319010573' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('LFC1', 'e:HEV (2.0 VTEC) (LFC1) 135kW', 1996, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 50, 'engine_oil', (SELECT id FROM engines WHERE code = 'LFC1'), 4, 4.23, '0W-20', 'Honda Engine Oil Type 2.0', 'HaynesPro typeId t_619106244; e:HEV (2.0 VTEC); drain 40 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 50 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'LFC1'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 50, 'coolant', (SELECT id FROM engines WHERE code = 'LFC1'), 5.6, 5.92, NULL, 'Honda Pro HP Type 2 Coolant', 'HaynesPro typeId t_619106244; e:HEV (2.0 VTEC)'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 50 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'LFC1'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 50, 'transmission_cvt', (SELECT id FROM engines WHERE code = 'LFC1'), 2.2, 2.32, NULL, NULL, 'HaynesPro typeId t_619106244; e:HEV (2.0 VTEC); CVT'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 50 AND fluid_type = 'transmission_cvt' AND engine_id = (SELECT id FROM engines WHERE code = 'LFC1'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 50, 'brake_fluid', NULL, 1, 1.06, NULL, 'DOT 4', 'HaynesPro chassis d_319010573; Alt: DOT 3'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 50 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (50)
  AND e.code IN ('LFC1')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (50)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (50) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;