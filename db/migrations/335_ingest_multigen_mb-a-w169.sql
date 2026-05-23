-- mig 335 — multi-gen HaynesPro ingest: Mercedes-Benz A (W169)
-- crawl: haynespro-crawl-mb-a-w169-2026-05-23.json
-- modelId: d_3580
-- 8 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Mercedes-Benz A (W169)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3580', NOW(), 'Multi-gen ingest, 8 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3580' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('266.920', '150, -LPG (266.920) 70kW', 1498, 'petrol', 'NA', NULL),
  ('640.942', '160 CDI (640.942) 60kW', 1991, 'petrol', 'NA', NULL),
  ('266.940', '170, -LPG (266.940) 85kW', 1699, 'petrol', 'NA', NULL),
  ('640.940', '180 CDI (640.940) 80kW', 1991, 'petrol', 'NA', NULL),
  ('640.941', '200 CDI (640.941) 103kW', 1991, 'petrol', 'NA', NULL),
  ('266.980', '200 Turbo (266.980) 142kW', 2034, 'petrol', 'turbo', NULL),
  ('266.960', '200, -LPG (266.960) 100kW', 2034, 'petrol', 'NA', NULL),
  ('780.991', 'E-CELL (780.991) 50kW', 0, 'petrol', 'NA', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'engine_oil', (SELECT id FROM engines WHERE code = '266.920'), 5, 5.28, '0W-30', 'MB 229.52', 'HaynesPro typeId t_60700; 150, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '266.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'coolant', (SELECT id FROM engines WHERE code = '266.920'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_60700; 150, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '266.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'transmission_mt', (SELECT id FROM engines WHERE code = '266.920'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_60700; 150, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '266.920'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'engine_oil', (SELECT id FROM engines WHERE code = '640.942'), 5.8, 6.13, '0W-30', 'MB 229.52', 'HaynesPro typeId t_60740; 160 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '640.942'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'coolant', (SELECT id FROM engines WHERE code = '640.942'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_60740; 160 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '640.942'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'transmission_mt', (SELECT id FROM engines WHERE code = '640.942'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_60740; 160 CDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '640.942'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'engine_oil', (SELECT id FROM engines WHERE code = '266.940'), 5, 5.28, '0W-30', 'MB 229.5', 'HaynesPro typeId t_60710; 170, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '266.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'coolant', (SELECT id FROM engines WHERE code = '266.940'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_60710; 170, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '266.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'transmission_mt', (SELECT id FROM engines WHERE code = '266.940'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_60710; 170, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '266.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'engine_oil', (SELECT id FROM engines WHERE code = '640.940'), NULL, NULL, '0W-30', 'MB 229.52', 'HaynesPro typeId t_60750; 180 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '640.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'coolant', (SELECT id FROM engines WHERE code = '640.940'), 8, 8.45, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_60750; 180 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '640.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'transmission_mt', (SELECT id FROM engines WHERE code = '640.940'), 1.7, 1.8, NULL, 'SAE 75W-75', 'HaynesPro typeId t_60750; 180 CDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '640.940'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'engine_oil', (SELECT id FROM engines WHERE code = '640.941'), NULL, NULL, '0W-30', 'MB 229.52', 'HaynesPro typeId t_60760; 200 CDI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '640.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'coolant', (SELECT id FROM engines WHERE code = '640.941'), 9.7, 10.25, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_60760; 200 CDI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '640.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'transmission_mt', (SELECT id FROM engines WHERE code = '640.941'), 1.7, 1.8, NULL, 'SAE 75W-75', 'HaynesPro typeId t_60760; 200 CDI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '640.941'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'engine_oil', (SELECT id FROM engines WHERE code = '266.980'), 5, 5.28, '0W-30', 'MB 229.5', 'HaynesPro typeId t_60730; 200 Turbo; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '266.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'coolant', (SELECT id FROM engines WHERE code = '266.980'), 8.5, 8.98, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_60730; 200 Turbo'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '266.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'transmission_mt', (SELECT id FROM engines WHERE code = '266.980'), 1.7, 1.8, NULL, 'SAE 75W-75', 'HaynesPro typeId t_60730; 200 Turbo; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '266.980'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'engine_oil', (SELECT id FROM engines WHERE code = '266.960'), 5, 5.28, '0W-30', 'MB 229.5', 'HaynesPro typeId t_60720; 200, -LPG; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = '266.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'coolant', (SELECT id FROM engines WHERE code = '266.960'), 6.6, 6.97, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_60720; 200, -LPG'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '266.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'transmission_mt', (SELECT id FROM engines WHERE code = '266.960'), 1.8, 1.9, NULL, 'SAE 75W-75', 'HaynesPro typeId t_60720; 200, -LPG; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = '266.960'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'coolant', (SELECT id FROM engines WHERE code = '780.991'), NULL, NULL, NULL, '(De-ionised water with 50% anti-freeze)', 'HaynesPro typeId t_200000009; E-CELL'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = '780.991'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 313, 'brake_fluid', NULL, 0.5, 0.53, NULL, 'DOT 4+', 'HaynesPro chassis d_3580;'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 313 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (313)
  AND e.code IN ('266.920', '640.942', '266.940', '640.940', '640.941', '266.980', '266.960', '780.991')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (313)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (313) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;