-- mig 318 — multi-gen HaynesPro ingest: Audi A1 (GBA, GBH)
-- crawl: haynespro-crawl-audi-a1-gb-2026-05-23.json
-- modelId: d_319002998
-- 14 engines × per-engine target gens, with INSERT...NOT EXISTS guards.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (citation, url, retrieved_at, notes, is_public, public_link) VALUES
  ('HaynesPro WorkshopData — Audi A1 (GBA, GBH)', 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319002998', NOW(), 'Multi-gen ingest, 14 engines across 1 catalog gens.', 0, 0);
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319002998' ORDER BY id DESC LIMIT 1);

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('DKLA', '25 TFSI (DKLA) 70kW', 999, 'petrol', 'turbo', NULL),
  ('DLAC', '25 TFSI (DLAC) 70kW', 999, 'petrol', 'turbo', NULL),
  ('DUSB', '25 TFSI (DUSB) 70kW', 999, 'petrol', 'turbo', NULL),
  ('DKJA', '30 TFSI (DKJA) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DKRA', '30 TFSI (DKRA) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DKRF', '30 TFSI (DKRF) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DLAA', '30 TFSI (DLAA) 81kW', 999, 'petrol', 'turbo', NULL),
  ('DUSA', '30 TFSI (DUSA) 85kW', 999, 'petrol', 'turbo', NULL),
  ('DADA', '35 TFSI (DADA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DPCA', '35 TFSI (DPCA) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('DXDB', '35 TFSI (DXDB) 110kW', 1498, 'petrol', 'turbo', NULL),
  ('CZPC', '40 TFSI (CZPC) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('DKZC', '40 TFSI (DKZC) 147kW', 1984, 'petrol', 'turbo', NULL),
  ('DNND', '40 TFSI (DNND) 152kW', 1984, 'petrol', 'turbo', NULL);

-- Per-(engine, gen) fluid_specs with NOT EXISTS guard
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKLA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016902; 25 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DKLA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016902; 25 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DKLA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_619016902; 25 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DKLA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLAC'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035628; 25 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DLAC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035628; 25 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DLAC'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619035628; 25 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DUSB'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619139049; 25 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DUSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DUSB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619139049; 25 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DUSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DUSB'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_619139049; 25 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DUSB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKJA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017298; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DKJA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017298; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKJA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619017298; 30 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKJA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKRA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017297; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DKRA'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017297; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DKRA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619017297; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKRF'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619013136; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DKRF'), 8, 8.45, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619013136; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DKRF'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619013136; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DKRF'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DLAA'), 4, 4.23, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619035629; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DLAA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035629; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DLAA'), 2.3, 2.43, NULL, 'SAE 75W', 'HaynesPro typeId t_619035629; 30 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DLAA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DUSA'), NULL, NULL, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619139048; 30 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DUSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DUSA'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619139048; 30 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DUSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DUSA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619139048; 30 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DUSA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DADA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619016901; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DADA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619016901; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_mt', (SELECT id FROM engines WHERE code = 'DADA'), 2.1, 2.22, NULL, 'SAE 75W', 'HaynesPro typeId t_619016901; 35 TFSI; Manual transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_mt' AND engine_id = (SELECT id FROM engines WHERE code = 'DADA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DPCA'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619024126; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DPCA'), 9, 9.51, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619024126; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DPCA'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619024126; 35 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DPCA'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DXDB'), 4.3, 4.54, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619114300; 35 TFSI; drain 30 Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DXDB'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619114300; 35 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DXDB'), 1.7, 1.8, NULL, 'VW G 055 512 A2', 'HaynesPro typeId t_619114300; 35 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DXDB'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'CZPC'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017296; 40 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'CZPC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017296; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_dct', (SELECT id FROM engines WHERE code = 'CZPC'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_619017296; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'CZPC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'engine_oil', (SELECT id FROM engines WHERE code = 'DKZC'), 5.7, 6.02, '0W-20', 'VW 508 00', 'HaynesPro typeId t_619017006; 40 TFSI; drain ? Nm'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'engine_oil' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DKZC'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619017006; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DKZC'), 5.2, 5.49, NULL, NULL, 'HaynesPro typeId t_619017006; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DKZC'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'coolant', (SELECT id FROM engines WHERE code = 'DNND'), 10, 10.57, NULL, 'TL-VW 774L (G12EVO)', 'HaynesPro typeId t_619035630; 40 TFSI'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'coolant' AND engine_id = (SELECT id FROM engines WHERE code = 'DNND'));
INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'transmission_dct', (SELECT id FROM engines WHERE code = 'DNND'), 6.9, 7.29, NULL, NULL, 'HaynesPro typeId t_619035630; 40 TFSI; Dual-clutch transmission'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'transmission_dct' AND engine_id = (SELECT id FROM engines WHERE code = 'DNND'));

INSERT INTO fluid_specs (generation_id, fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard, notes)
SELECT 294, 'brake_fluid', NULL, 1, 1.06, NULL, 'VW 501 14', 'HaynesPro chassis d_319002998; Alt: DOT 4'
WHERE NOT EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = 294 AND fluid_type = 'brake_fluid' AND engine_id IS NULL);

-- Link engine-scoped rows (oil, coolant, transmission_*)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs JOIN engines e ON e.id = fs.engine_id
WHERE fs.generation_id IN (294)
  AND e.code IN ('DKLA', 'DLAC', 'DUSB', 'DKJA', 'DKRA', 'DKRF', 'DLAA', 'DUSA', 'DADA', 'DPCA', 'DXDB', 'CZPC', 'DKZC', 'DNND')
  AND fs.fluid_type IN ('engine_oil', 'coolant', 'transmission_at', 'transmission_mt', 'transmission_dct', 'transmission_cvt');

-- Link gen-wide brake_fluid rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, @s_haynes
FROM fluid_specs fs
WHERE fs.generation_id IN (294)
  AND fs.fluid_type = 'brake_fluid' AND fs.engine_id IS NULL;

SELECT g.slug, fs.fluid_type, COUNT(*) AS rows_count
FROM fluid_specs fs JOIN generations g ON g.id = fs.generation_id
WHERE fs.generation_id IN (294) AND fs.fluid_type IN ('engine_oil','coolant','brake_fluid','transmission_at','transmission_mt','transmission_dct','transmission_cvt')
GROUP BY g.slug, fs.fluid_type ORDER BY g.slug, fs.fluid_type;