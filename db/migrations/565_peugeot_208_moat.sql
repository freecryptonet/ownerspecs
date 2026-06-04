-- 565: Peugeot 208 II (gen 521) core moat — engine-scoped oil/coolant, brake,
-- transmission, torques, battery, tyres, brakes, alignment. PSA CMP platform
-- (PureTech 1.2 EB2 + 1.5 BlueHDi DV5 — same engine codes as Corsa F, so oil
-- capacities follow by engine identity). Reuses the gen's vendor-neutral source
-- 1685 (Peugeot 208 Service Manual, public_link=0). Fuses + maintenance deferred.

SET @src := 1685;

-- Drop the thin scraper-leftover fluid row (NULL viscosity AND spec)
DELETE FROM fluid_specs WHERE generation_id = 521 AND viscosity IS NULL AND spec_standard IS NULL;

-- engine_oil (engine-scoped): 2215 HMH NA75 · 2213 HNK T100 · 2214 HNS T130 · 2212 YHY diesel
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (521, 2215, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.25, 'Sump incl. filter; drain plug 42 N·m (steel) / 20 N·m (alu)'),
  (521, 2213, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'Sump incl. filter'),
  (521, 2214, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 3.50, 'Sump incl. filter; drain plug 42 N·m (steel) / 20 N·m (alu)'),
  (521, 2212, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03 (PSA B71 2297)', 4.00, 'Sump incl. filter; drain plug 34 N·m');

-- coolant (engine-scoped; shared OAT spec)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes) VALUES
  (521, 2215, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (521, 2213, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (521, 2214, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (521, 2212, 'coolant', 'PSA B71 5110', 'OAT long-life coolant');

-- gen-wide fluids
INSERT INTO fluid_specs (generation_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (521, 'brake', NULL, 'DOT 4 LV', 1.00, 'Brake/clutch system total'),
  (521, 'transmission_mt', 'SAE 75W', 'PSA B71 2316', NULL, '5-speed manual (MA); PSA 9730 AG alternative'),
  (521, 'transmission_at', NULL, NULL, NULL, '8-speed automatic (EAT8)');
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes) VALUES
  (521, 2212, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid');

-- torques
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (521, NULL, 'Wheel bolts', 115, 85, '16/17-inch wheels; 100 N·m on 15-inch steel wheels. Do not use power tools for final tightening'),
  (521, NULL, 'Oil filter housing', 16, 12, NULL),
  (521, 2215, 'Spark plugs', 22, 16, NULL),
  (521, 2213, 'Spark plugs', 22, 16, NULL),
  (521, 2214, 'Spark plugs', 22, 16, NULL),
  (521, 2212, 'Engine oil drain plug', 34, 25, NULL),
  (521, 2214, 'Cylinder head bolts (Stage 1)', 10, 7, 'Then Stage 2: 30 N·m (bolts 1-10) + 20 N·m (bolt 11); Stage 3: 230° angle. Renew bolts.');

-- battery
INSERT INTO electrical_specs (generation_id, battery_group, ah) VALUES (521, 'AGM', 60);

-- tyres (185/65 R15; bar→psi/kpa)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (521, 'front', 'normal', 31.9, 220, '185/65 R15'),
  (521, 'front', 'full',   34.8, 240, '185/65 R15'),
  (521, 'rear',  'normal', 30.5, 210, '185/65 R15'),
  (521, 'rear',  'full',   42.1, 290, '185/65 R15');

-- brakes
INSERT INTO brake_specs (generation_id, axle, brake_type, disc_diameter_mm, disc_thickness_mm, disc_min_thickness_mm, pad_min_mm, drum_diameter_mm, drum_max_mm, notes) VALUES
  (521, 'front', 'disc_vented', 266.0, 22.0, 20.0, 2.0, NULL, NULL, 'Base brake package'),
  (521, 'front', 'disc_vented', 283.0, 26.0, 24.0, 2.0, NULL, NULL, 'Mid brake package'),
  (521, 'front', 'disc_vented', 302.0, 26.0, 24.0, 2.0, NULL, NULL, 'Larger brake package'),
  (521, 'rear',  'disc_solid',  249.0,  9.0,  7.0, 2.0, NULL, NULL, 'Disc rear brakes'),
  (521, 'rear',  'drum',        NULL,  NULL, NULL, NULL, 203.0, 204.4, 'Drum rear brakes; shoe lining minimum 1.0 mm');

-- wheel alignment (non-adjustable front geometry)
INSERT INTO alignment_specs (generation_id, axle, camber, caster, toe, thrust_angle, notes) VALUES
  (521, 'front', '-0°34'' ± 0°30''', '4°36'' ± 0°30''', '0°12'' ± 0°08''', NULL, 'King-pin inclination 12°54'' ± 0°30''; geometry not adjustable.'),
  (521, 'rear',  '-1°46'' ± 0°30''', NULL, '0°38'' ± 0°08''', '0°00'' ± 0°30''', NULL);

-- citations
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id = 521;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id = 521;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id = 521;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id = 521;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'brake_specs', id, @src FROM brake_specs WHERE generation_id = 521;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'alignment_specs', id, @src FROM alignment_specs WHERE generation_id = 521;
