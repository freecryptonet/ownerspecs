-- mig 338 — multi-gen HaynesPro ingest: Mercedes-Benz B (W245)
-- crawl: haynespro-crawl-mb-b-w245-2026-05-23.json
-- modelId: d_3480
-- 6 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz B (W245)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3480', NOW(), 'Multi-gen ingest, 6 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3480' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('266.920', '150, -LPG (266.920) 71kW', 1498, 'petrol', 'NA', NULL),
  ('266.960', '170 NGT BlueEFF (266.960) 85kW', 2034, 'petrol', 'NA', NULL),
  ('266.940', '170, -LPG (266.940) 86kW', 1699, 'petrol', 'NA', NULL),
  ('640.940', '180 CDI (640.940) 80kW', 1992, 'petrol', 'NA', NULL),
  ('640.941', '200 CDI (640.941) 103kW', 1992, 'petrol', 'NA', NULL),
  ('266.980', '200 Turbo, -LPG (266.980) 142kW', 2034, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'engine_oil', (SELECT id FROM engines WHERE code = '266.920'), 5, 5.28, '0W-30', 'MB 229.5', 'HaynesPro typeId t_5470; 150, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '266.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'coolant', (SELECT id FROM engines WHERE code = '266.920'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_5470; 150, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '266.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'transmission_mt', (SELECT id FROM engines WHERE code = '266.920'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_5470; 150, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '266.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'engine_oil', (SELECT id FROM engines WHERE code = '266.960'), 5, 5.28, '0W-30', 'MB 229.5', 'HaynesPro typeId t_102001662; 170 NGT BlueEFF; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '266.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'coolant', (SELECT id FROM engines WHERE code = '266.960'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_102001662; 170 NGT BlueEFF'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '266.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'transmission_mt', (SELECT id FROM engines WHERE code = '266.960'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_102001662; 170 NGT BlueEFF; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '266.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'engine_oil', (SELECT id FROM engines WHERE code = '266.940'), 5, 5.28, '0W-30', 'MB 229.5', 'HaynesPro typeId t_5500; 170, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '266.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'coolant', (SELECT id FROM engines WHERE code = '266.940'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_5500; 170, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '266.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'transmission_mt', (SELECT id FROM engines WHERE code = '266.940'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_5500; 170, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '266.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'engine_oil', (SELECT id FROM engines WHERE code = '640.940'), NULL, NULL, '0W-30', 'MB 229.52', 'HaynesPro typeId t_5570; 180 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '640.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'coolant', (SELECT id FROM engines WHERE code = '640.940'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_5570; 180 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '640.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'transmission_mt', (SELECT id FROM engines WHERE code = '640.940'), 1.7, 1.8, NULL, 'SAE 75W-75', 'HaynesPro typeId t_5570; 180 CDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '640.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'engine_oil', (SELECT id FROM engines WHERE code = '640.941'), NULL, NULL, '0W-30', 'MB 229.52', 'HaynesPro typeId t_5600; 200 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '640.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'coolant', (SELECT id FROM engines WHERE code = '640.941'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_5600; 200 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '640.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'transmission_mt', (SELECT id FROM engines WHERE code = '640.941'), 1.7, 1.8, NULL, 'SAE 75W-75', 'HaynesPro typeId t_5600; 200 CDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '640.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'engine_oil', (SELECT id FROM engines WHERE code = '266.980'), 5, 5.28, '0W-30', 'MB 229.5', 'HaynesPro typeId t_5230; 200 Turbo, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '266.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'coolant', (SELECT id FROM engines WHERE code = '266.980'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_5230; 200 Turbo, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '266.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'transmission_mt', (SELECT id FROM engines WHERE code = '266.980'), 1.7, 1.8, NULL, 'SAE 75W-75', 'HaynesPro typeId t_5230; 200 Turbo, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '266.980'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 316, 'brake_fluid', NULL, 0.6, 0.63, NULL, 'MB 331.0', 'HaynesPro chassis d_3480;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 316 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (316)
  AND e.code IN ('266.920', '266.960', '266.940', '640.940', '640.941', '266.980')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (316)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (316) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;