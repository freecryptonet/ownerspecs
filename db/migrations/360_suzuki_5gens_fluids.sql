-- mig 360: 5 remaining Suzuki gens — fluids + electrical + tires from OEM owner manuals
--   Across AX10 (gen 321)  — A25A-FXS hybrid (Toyota RAV4 PHEV rebadge)
--   Baleno WB  (gen 322)  — K10C + K12C
--   Celerio LF (gen 323)  — K10B
--   Fronx YTB  (gen 324)  — K15B + K15C SHVS
--   Swace SX10 (gen 329)  — 2ZR-FXE hybrid (Toyota Corolla Touring Sports E210 rebadge)
-- Source citations point to existing manual_inventory-backed sources rows
-- (841 Fronx, 842 Baleno, 843 Celerio, 845 Across, 846 Swace).

-- 1. Fix Swace fuel tank (NL manual says 43 L, prior import had 36)
UPDATE generations SET fuel_tank_l = 43.0 WHERE id = 329;

-- 2. Engines: add K10B + K10C (others already present)
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders, bore_mm, stroke_mm, compression) VALUES
  ('K10B', 'Suzuki 1.0 (K10B) 3-cyl NA',           998, 'gasoline', 'na',    3, 73.0, 79.5, 11.0),
  ('K10C', 'Suzuki 1.0 Boosterjet (K10C) 3-cyl T', 998, 'gasoline', 'turbo', 3, 73.0, 79.5, 10.0);

SET @e_a25a := 6;
SET @e_2zr  := 16;
SET @e_k12c := 2027;
SET @e_k15b := 2032;
SET @e_k15c := 2033;
SET @e_k10b := (SELECT id FROM engines WHERE code='K10B');
SET @e_k10c := (SELECT id FROM engines WHERE code='K10C');

SET @s_across  := 845;
SET @s_baleno  := 842;
SET @s_celerio := 843;
SET @s_fronx   := 841;
SET @s_swace   := 846;

-- 3. fluid_specs --------------------------------------------------------------

-- Across AX10 — A25A-FXS hybrid
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_km, drain_interval_mi, drain_interval_months, notes) VALUES
  (321, @e_a25a, 'engine_oil',         4.30, 4.54, '0W-16', 'API SN/SP; ILSAC GF-6B',                          NULL, NULL, NULL, NULL, '0W-20 or 5W-30 acceptable substitute; replace with 0W-16 at next service. With filter replacement.'),
  (321, @e_a25a, 'coolant',             7.40, 7.82, NULL,    'Toyota Super Long Life Coolant',                   NULL, NULL, NULL, NULL, 'Petrol engine circuit; reference quantity.'),
  (321, @e_a25a, 'coolant',             2.00, 2.11, NULL,    'Toyota Super Long Life Coolant',                   NULL, NULL, NULL, NULL, 'Power Control Unit circuit (separate loop).'),
  (321, @e_a25a, 'transmission_ecvt',   4.40, 4.65, NULL,    'Toyota ATF WS',                                    NULL, NULL, NULL, NULL, 'Hybrid eCVT transaxle; reference quantity.'),
  (321, @e_a25a, 'differential_rear',   1.70, 1.80, NULL,    'Toyota ATF WS',                                    NULL, NULL, NULL, NULL, 'Rear e-axle (electric motor) differential.'),
  (321, NULL,    'brake_fluid',         NULL, NULL, NULL,    'FMVSS 116 DOT 3 (SAE J1703) or DOT 4 (SAE J1704)', NULL, NULL, NULL, NULL, NULL);

-- Baleno WB — K10C + K12C
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_km, drain_interval_mi, drain_interval_months, notes) VALUES
  (322, @e_k10c, 'engine_oil',     2.90, 3.06, '5W-30', 'ACEA A1/B1, A3/B3, A3/B4, A5/B5; API SL/SM/SN; ILSAC GF-3/4/5', NULL, NULL, NULL, NULL, 'Drain + filter replacement.'),
  (322, @e_k10c, 'engine_oil',     3.10, 3.27, '5W-30', 'ACEA A1/B1, A3/B3, A3/B4, A5/B5; API SL/SM/SN; ILSAC GF-3/4/5', NULL, NULL, NULL, NULL, 'Drain + filter replacement; alternate fill range.'),
  (322, @e_k12c, 'engine_oil',     4.30, 4.54, '0W-16', 'ACEA A1/B1, A3/B3, A3/B4, A5/B5; API SL/SM/SN; ILSAC GF-3/4/5', NULL, NULL, NULL, NULL, '0W-16 viscosity, with filter, including reservoir tank.'),
  (322, @e_k12c, 'engine_oil',     4.50, 4.75, '5W-30', 'ACEA A1/B1, A3/B3, A3/B4, A5/B5; API SL/SM/SN; ILSAC GF-3/4/5', NULL, NULL, NULL, NULL, '5W-30 viscosity, with filter, including reservoir tank.'),
  (322, @e_k10c, 'coolant',        4.40, 4.65, NULL,    'SUZUKI LLC Standard (Green)',                                  NULL, NULL, NULL, NULL, 'Including reservoir, MT.'),
  (322, @e_k10c, 'transmission_mt', 2.60, 2.75, '75W-80', 'SUZUKI GEAR OIL 75W-80',                                       NULL, NULL, NULL, NULL, NULL),
  (322, NULL,    'transmission_at', NULL, NULL, NULL,    'SUZUKI AT OIL AW-1',                                            NULL, NULL, NULL, NULL, 'Refill per service procedure; precise capacity in workshop data.'),
  (322, NULL,    'brake_fluid',    NULL, NULL, NULL,    'SAE J1703 / DOT 3',                                             NULL, NULL, NULL, NULL, NULL);

-- Celerio LF — K10B
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_km, drain_interval_mi, drain_interval_months, notes) VALUES
  (323, @e_k10b, 'engine_oil',         2.90, 3.06, '5W-30', 'ACEA A1/B1, A3/B3, A3/B4, A5/B5; API SL/SM/SN; ILSAC GF-3/4/5', NULL, NULL, NULL, NULL, 'Drain + filter replacement.'),
  (323, @e_k10b, 'coolant',             4.00, 4.23, NULL,    'SUZUKI LLC Standard (Green)',                                  NULL, NULL, NULL, NULL, 'Engine coolant; reference quantity.'),
  (323, @e_k10b, 'transmission_mt',     1.45, 1.53, '75W-80','SUZUKI GEAR OIL 75W-80 or 75W',                                NULL, NULL, NULL, NULL, NULL),
  (323, @e_k10b, 'transmission_cvt',    5.70, 6.02, NULL,    'SUZUKI CVT FLUID GREEN-2',                                     NULL, NULL, NULL, NULL, 'Auto Gear Shift / CVT variant.'),
  (323, NULL,    'brake_fluid',         NULL, NULL, NULL,    'SAE J1703 / DOT 3',                                             NULL, NULL, NULL, NULL, NULL);

-- Fronx YTB — K15B + K15C
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_km, drain_interval_mi, drain_interval_months, notes) VALUES
  (324, @e_k15b, 'engine_oil',         3.10, 3.27, '0W-20', 'API SJ/SL/SM/SN/SP; ILSAC GF-6',     NULL, NULL, NULL, NULL, 'Drain + filter replacement.'),
  (324, @e_k15c, 'engine_oil',         3.30, 3.49, '0W-20', 'API SL/SM/SN/SP; ILSAC GF-6',        NULL, NULL, NULL, NULL, 'Drain + filter replacement; non-HK/AU markets.'),
  (324, @e_k15c, 'engine_oil',         3.30, 3.49, '0W-16', 'API SN/SP; ILSAC GF-6',              NULL, NULL, NULL, NULL, 'Drain + filter replacement; Hong Kong / Australia markets.'),
  (324, @e_k15b, 'coolant',             4.30, 4.54, NULL,    'SUZUKI LLC Standard (Green)',        NULL, NULL, NULL, NULL, 'M/T variant; including reservoir tank.'),
  (324, @e_k15b, 'coolant',             4.20, 4.44, NULL,    'SUZUKI LLC Standard (Green)',        NULL, NULL, NULL, NULL, 'A/T variant; including reservoir tank.'),
  (324, @e_k15c, 'coolant',             4.50, 4.75, NULL,    'SUZUKI LLC Super (Blue)',            NULL, NULL, NULL, NULL, 'M/T variant; including reservoir tank.'),
  (324, @e_k15c, 'coolant',             4.70, 4.97, NULL,    'SUZUKI LLC Super (Blue)',            NULL, NULL, NULL, NULL, 'A/T variant; including reservoir tank.'),
  (324, NULL,    'transmission_mt',     2.60, 2.75, '75W',   'SUZUKI GEAR OIL 75W',                NULL, NULL, NULL, NULL, NULL),
  (324, NULL,    'transmission_at',     5.00, 5.28, NULL,    'SUZUKI AT OIL AW-1',                 NULL, NULL, NULL, NULL, '4-speed automatic.'),
  (324, NULL,    'transmission_at',     5.80, 6.13, NULL,    'SUZUKI AT OIL AW-1',                 NULL, NULL, NULL, NULL, '6-speed automatic.'),
  (324, NULL,    'brake_fluid',         NULL, NULL, NULL,    'SAE J1703 / DOT 3',                  NULL, NULL, NULL, NULL, NULL);

-- Swace SX10 — 2ZR-FXE hybrid
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_km, drain_interval_mi, drain_interval_months, notes) VALUES
  (329, @e_2zr, 'engine_oil',         4.20, 4.44, '0W-16', 'API SN/SP; ILSAC GF-6B',                          NULL, NULL, NULL, NULL, '0W-20 or 5W-30 acceptable substitute; replace with 0W-16 at next service. With filter.'),
  (329, @e_2zr, 'coolant',             5.50, 5.81, NULL,    'Toyota Super Long Life Coolant',                   NULL, NULL, NULL, NULL, 'Petrol engine circuit; reference quantity.'),
  (329, @e_2zr, 'coolant',             1.50, 1.59, NULL,    'Toyota Super Long Life Coolant',                   NULL, NULL, NULL, NULL, 'Power Control Unit circuit (separate loop).'),
  (329, @e_2zr, 'transmission_ecvt',   3.00, 3.17, NULL,    'Toyota Genuine e-Transaxle Fluid TE',              NULL, NULL, NULL, NULL, 'Hybrid eCVT transaxle; reference quantity.'),
  (329, NULL,   'brake_fluid',         NULL, NULL, NULL,    'FMVSS 116 DOT 3 (SAE J1703) or DOT 4 (SAE J1704)', NULL, NULL, NULL, NULL, NULL);

-- 4. electrical_specs — 12 V starter battery codes & ratings
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (322, '55B24L (JIS)',  370, 45, NULL),
  (322, 'L1 (EN)',       450, 55, NULL),
  (323, '46B24L-MF JIS', 400, 43, NULL),
  (323, 'LN2 (DIN)',     540, 58, NULL),
  (324, '38B20L (JIS)',  332, 35, NULL),
  (324, 'N55 (JIS)',     480, 45, NULL);

-- 5. tire_pressures — Across + Swace provide explicit values in spec section
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (321, 'front', 'normal',     33.4, 230, '235/55R19 101V'),
  (321, 'rear',  'normal',     33.4, 230, '235/55R19 101V'),
  (321, 'spare', 'normal',     60.9, 420, 'T165/90D18 107M'),
  (329, 'front', 'normal',     36.3, 250, '205/55R16 91V'),
  (329, 'rear',  'normal',     34.8, 240, '205/55R16 91V'),
  (329, 'front', 'high_speed', 40.6, 280, '205/55R16 91V'),
  (329, 'rear',  'high_speed', 39.2, 270, '205/55R16 91V'),
  (329, 'spare', 'normal',     60.9, 420, 'T125/70D17 98M');

-- 6. spec_sources — cite each new row to the gen's manual source
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, CASE
      WHEN fs.generation_id = 321 THEN @s_across
      WHEN fs.generation_id = 322 THEN @s_baleno
      WHEN fs.generation_id = 323 THEN @s_celerio
      WHEN fs.generation_id = 324 THEN @s_fronx
      WHEN fs.generation_id = 329 THEN @s_swace
    END
  FROM fluid_specs fs
  WHERE fs.generation_id IN (321, 322, 323, 324, 329);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'electrical_specs', es.id, CASE
      WHEN es.generation_id = 322 THEN @s_baleno
      WHEN es.generation_id = 323 THEN @s_celerio
      WHEN es.generation_id = 324 THEN @s_fronx
    END
  FROM electrical_specs es
  WHERE es.generation_id IN (322, 323, 324);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'tire_pressures', tp.id, CASE
      WHEN tp.generation_id = 321 THEN @s_across
      WHEN tp.generation_id = 329 THEN @s_swace
    END
  FROM tire_pressures tp
  WHERE tp.generation_id IN (321, 329);
