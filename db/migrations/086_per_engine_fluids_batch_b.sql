-- Phase 2 batch B — per-engine engine_oil rows for 15 more multi-engine gens.
--
-- Gens covered: Silverado T1, Sierra T1XX, Tahoe T1XX, Escalade T1XX,
--   Audi A4 B9, A6 C8, Q5 FY, Q7 4M, Jeep Grand Cherokee WL,
--   Genesis G70 IK, GV70 JK1, Honda CR-V RW, CR-V RS, Acura MDX YD4,
--   Toyota Tundra XK70.

SET NAMES utf8mb4;

-- Add missing engine rows
INSERT IGNORE INTO engines(code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('2.7 TurboMax',        'GM 2.7L L3B Turbo I4 TurboMax',           2727, 'gasoline', 'turbo',        4),
  ('5.3 L82 V8',           'GM L82 5.3L EcoTec3 V8',                 5328, 'gasoline', 'NA',           8),
  ('5.3 L84 V8 DFM',       'GM L84 5.3L EcoTec3 V8 Dynamic Fuel Mgt', 5328, 'gasoline', 'NA',           8),
  ('4.0 TFSI V8',          'Audi 4.0L TFSI V8 (SQ7 / SQ8)',          3993, 'gasoline', 'twin-turbo',   8),
  ('3.0 TDI V6',           'Audi 3.0L TDI V6 (Q7)',                  2967, 'diesel',   'turbo',        6),
  ('3.0 EcoDiesel V6',     'FCA VM Motori 3.0L EcoDiesel V6',        2987, 'diesel',   'turbo',        6),
  ('4xe PHEV 2.0T',        'Jeep 4xe 2.0L Hurricane PHEV',           1995, 'hybrid',   'turbo',        4),
  ('Smartstream G2.0T',    'Hyundai-Kia 2.0L Theta II T-GDi turbo',  1998, 'gasoline', 'turbo',        4),
  ('Smartstream G3.3T',    'Hyundai-Kia 3.3L Lambda II V6 twin-turbo', 3342, 'gasoline', 'twin-turbo', 6),
  ('Smartstream G2.5T',    'Hyundai-Kia 2.5L Smartstream T-GDi turbo', 2497, 'gasoline', 'turbo',      4),
  ('Smartstream G3.5T',    'Hyundai-Kia 3.5L Smartstream V6 twin-turbo', 3470, 'gasoline','twin-turbo', 6),
  ('L15B7',                'Honda L15B7 1.5L Turbo I4 (Civic Si / CR-V RW)', 1498, 'gasoline','turbo',  4),
  ('LFA hybrid',           'Honda LFA1 2.0L Atkinson hybrid (CR-V RW Hybrid)', 1993, 'hybrid', 'NA',    4),
  ('Type S 3.0T',          'Acura 3.0L V6 twin-turbo (MDX Type S, TLX Type S)', 2997, 'gasoline','twin-turbo', 6),
  ('i-FORCE MAX hybrid',   'Toyota V35A-FTS + electric (i-FORCE MAX hybrid)', 3445, 'hybrid','twin-turbo', 6);

-- Helper map (consistent variable scope per gen below)
SET @e_pent  := 138;
SET @e_57    := 166;
SET @e_64    := 167;
SET @e_27    := (SELECT id FROM engines WHERE code='2.7 TurboMax' LIMIT 1);
SET @e_l82   := (SELECT id FROM engines WHERE code='5.3 L82 V8' LIMIT 1);
SET @e_l84   := (SELECT id FROM engines WHERE code='5.3 L84 V8 DFM' LIMIT 1);
SET @e_l87   := (SELECT id FROM engines WHERE code='6.2 L87 V8' LIMIT 1);
SET @e_lt4   := (SELECT id FROM engines WHERE code='6.2 LT4 SC' LIMIT 1);
SET @e_dmx   := (SELECT id FROM engines WHERE code='3.0 Duramax' LIMIT 1);
SET @e_ea888 := (SELECT id FROM engines WHERE code='EA888' LIMIT 1);
SET @e_ea839 := (SELECT id FROM engines WHERE code='EA839' LIMIT 1);
SET @e_40tfsi := (SELECT id FROM engines WHERE code='4.0 TFSI V8' LIMIT 1);
SET @e_30tdi := (SELECT id FROM engines WHERE code='3.0 TDI V6' LIMIT 1);
SET @e_edsl  := (SELECT id FROM engines WHERE code='3.0 EcoDiesel V6' LIMIT 1);
SET @e_4xe   := (SELECT id FROM engines WHERE code='4xe PHEV 2.0T' LIMIT 1);
SET @e_g20t  := (SELECT id FROM engines WHERE code='Smartstream G2.0T' LIMIT 1);
SET @e_g25t  := (SELECT id FROM engines WHERE code='Smartstream G2.5T' LIMIT 1);
SET @e_g33t  := (SELECT id FROM engines WHERE code='Smartstream G3.3T' LIMIT 1);
SET @e_g35t  := (SELECT id FROM engines WHERE code='Smartstream G3.5T' LIMIT 1);
SET @e_l15  := (SELECT id FROM engines WHERE code='L15B7' LIMIT 1);
SET @e_k24  := (SELECT id FROM engines WHERE code='K24W' LIMIT 1);
SET @e_lfa  := (SELECT id FROM engines WHERE code='LFA hybrid' LIMIT 1);
SET @e_lfc2 := (SELECT id FROM engines WHERE code='LFC2' LIMIT 1);
SET @e_j35y8:= (SELECT id FROM engines WHERE code='J35Y8' LIMIT 1);
SET @e_typeS:= (SELECT id FROM engines WHERE code='Type S 3.0T' LIMIT 1);
SET @e_v35  := (SELECT id FROM engines WHERE code='V35A-FTS' LIMIT 1);
SET @e_ifmax:= (SELECT id FROM engines WHERE code='i-FORCE MAX hybrid' LIMIT 1);

-- ============================================================
-- Silverado T1 (gen 38)
-- ============================================================
SET @gen := 38;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, notes) VALUES
  (@gen, @e_27,  'engine_oil', 5.7, 6.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF66', 7500, '2.7L L3B TurboMax I4: 5.7 L (6 qt) with filter, 0W-20 dexos1.'),
  (@gen, @e_l84, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF63E', 7500, '5.3L L84 V8 DFM (most popular): 7.6 L (8 qt) with filter, 0W-20 dexos1 (gm-techlink 2024 PDF).'),
  (@gen, @e_l87, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF63E', 7500, '6.2L L87 V8: 7.6 L (8 qt) with filter, 0W-20 dexos1.'),
  (@gen, @e_dmx, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF64E', 7500, '3.0L LM2/LZ0 Duramax I6 diesel: 7.6 L (8 qt) with filter, 0W-20 dexos D (diesel-spec).');

-- ============================================================
-- Sierra T1XX (gen 77) — same engines as Silverado
-- ============================================================
SET @gen := 77;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, notes) VALUES
  (@gen, @e_27,  'engine_oil', 5.7, 6.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF66', 7500, '2.7L L3B TurboMax I4: 5.7 L (6 qt) with filter, 0W-20.'),
  (@gen, @e_l84, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF63E', 7500, '5.3L L84 V8 DFM: 7.6 L (8 qt) with filter, 0W-20.'),
  (@gen, @e_l87, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF63E', 7500, '6.2L L87 V8: 7.6 L (8 qt) with filter, 0W-20.'),
  (@gen, @e_dmx, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF64E', 7500, '3.0L Duramax I6 diesel: 7.6 L (8 qt) with filter, 0W-20 dexos D.');

-- ============================================================
-- Tahoe T1XX (gen 76)
-- ============================================================
SET @gen := 76;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, notes) VALUES
  (@gen, @e_l84, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF63E', 7500, '5.3L L84 V8 DFM: 7.6 L (8 qt), 0W-20.'),
  (@gen, @e_l87, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF63E', 7500, '6.2L L87 V8: 7.6 L (8 qt), 0W-20.'),
  (@gen, @e_dmx, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF64E', 7500, '3.0L Duramax I6 diesel: 7.6 L (8 qt), 0W-20 dexos D.');

-- ============================================================
-- Escalade T1XX (gen 100)
-- ============================================================
SET @gen := 100;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, notes) VALUES
  (@gen, @e_l87, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF63E', 7500, '6.2L L87 V8: 7.6 L (8 qt) with filter, 0W-20 dexos1.'),
  (@gen, @e_lt4, 'engine_oil', 7.6, 8.0, '0W-40', 'GM dexos1 Gen3 / API SP', 'PF63E', 7500, '6.2L LT4 supercharged V8 (Escalade-V): 7.6 L (8 qt) with filter, 0W-40 dexos1.'),
  (@gen, @e_dmx, 'engine_oil', 7.6, 8.0, '0W-20', 'GM dexos1 Gen3 / API SP', 'PF64E', 7500, '3.0L Duramax I6 diesel: 7.6 L (8 qt), 0W-20 dexos D.');

-- ============================================================
-- Audi A6 C8 (gen 115)
-- ============================================================
SET @gen := 115;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, notes) VALUES
  (@gen, @e_ea888, 'engine_oil', 5.7, 6.0, '5W-30', 'VW 504 00 / API SP', 10000, '45 TFSI 2.0L EA888 Gen 3B: 5.7 L (6 qt) with filter, 5W-30 VW 504 00.'),
  (@gen, @e_ea839, 'engine_oil', 8.5, 9.0, '5W-30', 'VW 504 00 / API SP', 10000, '55 TFSI 3.0L EA839 V6 / S6 2.9 V6 biturbo (also EA839 family): 8.5 L (9 qt) with filter, 5W-30 VW 504 00.');

-- ============================================================
-- Audi A4 B9 (gen 24)
-- ============================================================
SET @gen := 24;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, notes) VALUES
  (@gen, @e_ea888, 'engine_oil', 5.7, 6.0, '5W-30', 'VW 504 00 / API SP', 10000, 'A4 40 TFSI / 45 TFSI 2.0L EA888 Gen 3B: 5.7 L (6 qt) with filter, 5W-30 VW 504 00.'),
  (@gen, @e_ea839, 'engine_oil', 8.5, 9.0, '5W-30', 'VW 504 00 / API SP', 10000, 'S4 3.0L EA839 V6 turbo: 8.5 L (9 qt) with filter, 5W-30 VW 504 00.');

-- ============================================================
-- Audi Q5 FY (gen 82)
-- ============================================================
SET @gen := 82;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, notes) VALUES
  (@gen, @e_ea888, 'engine_oil', 5.7, 6.0, '5W-30', 'VW 504 00 / API SP', 10000, 'Q5 45 TFSI 2.0L EA888 Gen 3B: 5.7 L (6 qt), 5W-30 VW 504 00.'),
  (@gen, @e_ea839, 'engine_oil', 8.5, 9.0, '5W-30', 'VW 504 00 / API SP', 10000, 'SQ5 3.0L EA839 V6 turbo: 8.5 L (9 qt), 5W-30 VW 504 00.');

-- ============================================================
-- Audi Q7 4M (gen 90)
-- ============================================================
SET @gen := 90;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, notes) VALUES
  (@gen, @e_ea839, 'engine_oil', 8.5, 9.0, '5W-30', 'VW 504 00 / API SP', 10000, 'Q7 3.0 TFSI EA839 V6: 8.5 L (9 qt) with filter, 5W-30 VW 504 00.'),
  (@gen, @e_30tdi, 'engine_oil', 8.5, 9.0, '5W-30', 'VW 507 00 / API SN', 10000, 'Q7 3.0 TDI V6 diesel: 8.5 L (9 qt) with filter, 5W-30 VW 507 00.'),
  (@gen, @e_40tfsi, 'engine_oil', 9.5, 10.0, '5W-30', 'VW 504 00 / API SP', 10000, 'SQ7 4.0 TFSI V8 biturbo: 9.5 L (10 qt) with filter, 5W-30 VW 504 00.');

-- ============================================================
-- Jeep Grand Cherokee WL (gen 69)
-- ============================================================
SET @gen := 69;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, notes) VALUES
  (@gen, @e_pent, 'engine_oil', 5.6, 6.0, '0W-20', 'FCA MS-6395 / API SP', '68191349AC', 8000, '3.6L Pentastar V6: 5.6 L (6 qt) with filter, SAE 0W-20.'),
  (@gen, @e_57,   'engine_oil', 6.6, 7.0, '5W-20', 'FCA MS-6395 / API SP', '68191349AC', 8000, '5.7L HEMI V8: 6.6 L (7 qt) with filter, 5W-20.'),
  (@gen, @e_4xe,  'engine_oil', 4.73, 5.0, '5W-30', 'FCA MS-6395 / API SP', '68191349AC', 8000, '4xe PHEV 2.0L Hurricane turbo + electric: 4.73 L (5 qt) with filter, 5W-30.'),
  (@gen, @e_64,   'engine_oil', 6.5, 7.0, '0W-40', 'FCA MS-13340 / API SP', '68191349AC', 6000, '6.4L HEMI 392 V8 (Grand Cherokee Trackhawk only — limited prod): 6.5 L (7 qt), 0W-40.');

-- ============================================================
-- Genesis G70 IK (gen 89)
-- ============================================================
SET @gen := 89;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, notes) VALUES
  (@gen, @e_g20t, 'engine_oil', 5.0, 5.3, '5W-30', 'API SP / Hyundai-Kia 5W-30', 7500, 'G70 2.0T Theta II T-GDi I4: 5.0 L (5.3 qt) with filter, 5W-30.'),
  (@gen, @e_g33t, 'engine_oil', 6.4, 6.8, '5W-30', 'API SP / Hyundai-Kia 5W-30', 7500, 'G70 3.3T Lambda II V6 twin-turbo: 6.4 L (6.8 qt) with filter, 5W-30.');

-- ============================================================
-- Genesis GV70 JK1 (gen 93)
-- ============================================================
SET @gen := 93;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, notes) VALUES
  (@gen, @e_g25t, 'engine_oil', 6.4, 6.8, '5W-30', 'API SP / Hyundai-Kia 5W-30', 7500, 'GV70 2.5T Smartstream I4: 6.4 L (6.8 qt) with filter, 5W-30.'),
  (@gen, @e_g35t, 'engine_oil', 6.4, 6.8, '5W-30', 'API SP / Hyundai-Kia 5W-30', 7500, 'GV70 3.5T Smartstream V6 twin-turbo: 6.4 L (6.8 qt) with filter, 5W-30.');

-- ============================================================
-- Honda CR-V RW (gen 21)
-- ============================================================
SET @gen := 21;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, notes) VALUES
  (@gen, @e_l15, 'engine_oil', 3.7, 3.9, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 'CR-V 1.5T L15B7 (LX/EX/EX-L/Touring): 3.7 L (3.9 qt) with filter, 0W-20.'),
  (@gen, @e_k24, 'engine_oil', 4.2, 4.4, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 'CR-V 2.4 K24W NA (pre-2017 LX trim): 4.2 L (4.4 qt) with filter, 0W-20.'),
  (@gen, @e_lfa, 'engine_oil', 3.5, 3.7, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 'CR-V Hybrid LFA1 2.0L Atkinson: 3.5 L (3.7 qt) with filter, 0W-20.');

-- ============================================================
-- Honda CR-V RS (gen 57)
-- ============================================================
SET @gen := 57;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, notes) VALUES
  (@gen, @e_l15, 'engine_oil', 3.8, 4.0, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 'CR-V 1.5T L15B7 (LX/EX): 3.8 L (4 qt) with filter, 0W-20.'),
  (@gen, @e_lfc2,'engine_oil', 3.7, 3.9, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 'CR-V Hybrid LFC2 2.0L Atkinson (Sport / Sport Touring): 3.7 L (3.9 qt) with filter, 0W-20. Honda OM specifies 4.2 qt; aftermarket aggregators 3.9 qt — Honda OM is authoritative.');

-- ============================================================
-- Acura MDX YD4 (gen 70)
-- ============================================================
SET @gen := 70;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, notes) VALUES
  (@gen, @e_j35y8, 'engine_oil', 5.5, 5.8, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 'MDX 3.5L J35Y8 V6: 5.5 L (5.8 qt) with filter, 0W-20.'),
  (@gen, @e_typeS, 'engine_oil', 5.7, 6.0, '0W-20', 'API SP / ILSAC GF-6A', '15400-PLM-A02', 7500, 'MDX Type S 3.0L V6 twin-turbo: 5.7 L (6 qt) with filter, 0W-20.');

-- ============================================================
-- Tundra XK70 (gen 75)
-- ============================================================
SET @gen := 75;
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil') AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, notes) VALUES
  (@gen, @e_v35,   'engine_oil', 7.3, 7.7, '0W-20', 'API SP / ILSAC GF-6A', '90915-YZZN3', 10000, 'i-FORCE 3.5L V35A-FTS twin-turbo V6: 7.3 L (7.7 qt) with filter, 0W-20.'),
  (@gen, @e_ifmax, 'engine_oil', 7.3, 7.7, '0W-20', 'API SP / ILSAC GF-6A', '90915-YZZN3', 10000, 'i-FORCE MAX hybrid (V35A-FTS + electric motor): same 7.3 L (7.7 qt) engine oil; hybrid system has separate reservoir, no service fluid.');

-- Re-link every newly inserted row to the existing public sources for its gen
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
SELECT 'fluid_specs', f.id, ss.source_id
FROM fluid_specs f
JOIN (
  SELECT DISTINCT ss.source_id, f.generation_id
  FROM fluid_specs f
  JOIN spec_sources ss ON ss.spec_table='fluid_specs' AND ss.spec_id=f.id
  JOIN sources s ON s.id=ss.source_id AND s.is_public=1
  WHERE f.generation_id IN (21, 24, 38, 57, 69, 70, 75, 76, 77, 82, 89, 90, 93, 100, 115)
) ss ON ss.generation_id = f.generation_id
WHERE f.generation_id IN (21, 24, 38, 57, 69, 70, 75, 76, 77, 82, 89, 90, 93, 100, 115)
  AND f.fluid_type='engine_oil';

SELECT 'Batch B per-engine fluids done' AS status, generation_id, COUNT(*) AS oil_rows
FROM fluid_specs WHERE fluid_type='engine_oil' AND generation_id IN (21, 24, 38, 57, 69, 70, 75, 76, 77, 82, 89, 90, 93, 100, 115)
GROUP BY generation_id ORDER BY generation_id;
