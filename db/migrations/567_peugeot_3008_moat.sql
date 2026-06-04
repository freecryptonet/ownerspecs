-- 567: Peugeot 3008 II (gen 523) core moat. EMP2 SUV with 6 engine families:
-- EB2 1.2 PureTech (3.5 L, 5W-30 B71 2297), DV5 1.5 BlueHDi (4.0 L, 5W-30 B71 2297),
-- DV6 1.6 BlueHDi (3.75 L, 0W-30 B71 2312), EP6 1.6 THP petrol incl. Hybrid4
-- (4.25 L, 0W-30 B71 2312), DW10 2.0 BlueHDi (6.0 L refill, 5W-30 B71 2297).
-- Source 1700. Fuses + maintenance deferred.

SET @src := 1700;
DELETE FROM fluid_specs WHERE generation_id = 523 AND viscosity IS NULL AND spec_standard IS NULL;

-- engine_oil per family
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (523, 2227, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'EB2 1.2 PureTech; sump incl. filter'),
  (523, 2216, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 4.00, 'DV5 1.5 BlueHDi; sump incl. filter; drain 34 N·m'),
  (523, 2225, 'engine_oil', 'SAE 0W-30', 'STELLANTIS FPW9.55535/02 (PSA B71 2312)', 3.75, 'DV6 1.6 BlueHDi; sump incl. filter; drain 34 N·m'),
  (523, 2226, 'engine_oil', 'SAE 0W-30', 'STELLANTIS FPW9.55535/02 (PSA B71 2312)', 3.75, 'DV6 1.6 BlueHDi; sump incl. filter; drain 34 N·m'),
  (523, 2222, 'engine_oil', 'SAE 0W-30', 'STELLANTIS FPW9.55535/02 (PSA B71 2312)', 4.25, 'EP6 1.6 THP; sump incl. filter; drain 30 N·m'),
  (523, 2223, 'engine_oil', 'SAE 0W-30', 'STELLANTIS FPW9.55535/02 (PSA B71 2312)', 4.25, 'EP6 1.6 THP; sump incl. filter; drain 30 N·m'),
  (523, 2224, 'engine_oil', 'SAE 0W-30', 'STELLANTIS FPW9.55535/02 (PSA B71 2312)', 4.25, 'EP6 1.6 PHEV Hybrid4; sump incl. filter'),
  (523, 2221, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03', 6.00, 'DW10 2.0 BlueHDi; refill incl. filter (initial fill 7.1 L)');

-- coolant per engine (shared OAT spec)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes)
  SELECT 523, e.id, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'
  FROM engines e WHERE e.id IN (2227,2216,2225,2226,2222,2223,2224,2221);

-- gen-wide
INSERT INTO fluid_specs (generation_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (523, 'brake', NULL, 'DOT 4 LV', 1.00, 'Brake/clutch system total'),
  (523, 'transmission_mt', 'SAE 75W', 'PSA B71 2316', NULL, '6-speed manual'),
  (523, 'transmission_at', NULL, NULL, NULL, '8-speed automatic (EAT8)');
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes)
  SELECT 523, e.id, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid'
  FROM engines e WHERE e.id IN (2216,2221,2225,2226);

-- torques
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (523, NULL, 'Wheel bolts', 100, 74, 'Alloy wheels; 115 N·m on steel wheels. Do not use power tools for final tightening'),
  (523, 2222, 'Engine oil drain plug', 30, 22, NULL),
  (523, 2223, 'Engine oil drain plug', 30, 22, NULL),
  (523, 2225, 'Engine oil drain plug', 34, 25, NULL),
  (523, 2226, 'Engine oil drain plug', 34, 25, NULL),
  (523, 2216, 'Engine oil drain plug', 34, 25, NULL),
  (523, 2227, 'Engine oil drain plug', 42, 31, 'Steel sump (20 N·m alu)');

INSERT INTO electrical_specs (generation_id, battery_group, ah) VALUES (523, 'AGM', 60);

-- tyres
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (523, 'front', 'normal', 30.5, 210, '215/65 R17'),
  (523, 'front', 'full',   33.4, 230, '215/65 R17'),
  (523, 'rear',  'normal', 30.5, 210, '215/65 R17'),
  (523, 'rear',  'full',   33.4, 230, '215/65 R17');

-- brakes
INSERT INTO brake_specs (generation_id, axle, brake_type, disc_diameter_mm, disc_thickness_mm, disc_min_thickness_mm, pad_min_mm, notes) VALUES
  (523, 'front', 'disc_vented', 304.0, 28.0, 26.0, 2.0, 'Base brake package'),
  (523, 'front', 'disc_vented', 330.0, 30.0, 28.0, 2.0, 'Larger brake package'),
  (523, 'rear',  'disc_solid',  268.0, 12.0, 10.0, 2.0, 'Base rear discs'),
  (523, 'rear',  'disc_solid',  290.0, 12.0, 10.0, 2.0, 'Larger rear discs');

-- alignment (front toe-in not published in this data set)
INSERT INTO alignment_specs (generation_id, axle, camber, caster, toe, thrust_angle, notes) VALUES
  (523, 'front', '-0°36'' ± 0°30''', '4°00'' ± 0°30''', NULL, NULL, 'Geometry not adjustable.'),
  (523, 'rear',  '-1°51'' ± 0°30''', NULL, '0°44'' ± 0°08''', '0°04''', NULL);

-- citations
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = 523;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = 523;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = 523;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = 523;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'brake_specs', id, @src FROM brake_specs WHERE generation_id = 523;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'alignment_specs', id, @src FROM alignment_specs WHERE generation_id = 523;
