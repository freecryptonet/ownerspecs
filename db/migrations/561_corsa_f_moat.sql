-- 561: Opel Corsa F (gen 518) moat fill — fluids (engine-scoped oil+coolant),
-- brake fluid, transmission, torques, battery, tyres, brakes + wheel alignment.
-- Restated from workshop data (PSA CMP platform: PureTech 1.2 petrol EB2 family
-- + 1.5 DV5 diesel). Vendor-neutral source, public_link=0, facts only.

INSERT INTO sources (citation, type, retrieved_at, public_link, is_public, notes)
VALUES ('Workshop service manual — Opel Corsa F', 'service_manual', NOW(), 0, 1,
        'Vendor-neutral workshop reference; not an OEM-owned source.');
SET @cor := LAST_INSERT_ID();

-- Drop thin scraper-leftover fluid rows (NULL viscosity AND spec) before insert.
DELETE FROM fluid_specs WHERE generation_id = 518 AND viscosity IS NULL AND spec_standard IS NULL;

-- engine_oil (engine-scoped). 2200 F12XEL NA · 2199 F12XHL T100 · 2198 F12XHT T130 · 2197 D15DT diesel
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (518, 2200, 'engine_oil', 'SAE 5W-30', 'PSA B71 2297', 3.25, 'Sump incl. filter; drain plug 42 N·m'),
  (518, 2199, 'engine_oil', 'SAE 5W-30', 'PSA B71 2297', 3.50, 'Sump incl. filter'),
  (518, 2198, 'engine_oil', 'SAE 5W-30', 'PSA B71 2297', 3.50, 'Sump incl. filter; drain plug 20 N·m (alu) / 42 N·m (steel)'),
  (518, 2197, 'engine_oil', 'SAE 5W-30', 'PSA B71 2297', 4.00, 'Sump incl. filter (steel sump); 5.3 L with aluminium sump; drain plug 34 N·m');

-- coolant (engine-scoped per data-grain rule; same OAT spec across the family)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes) VALUES
  (518, 2200, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (518, 2199, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (518, 2198, 'coolant', 'PSA B71 5110', 'OAT long-life coolant'),
  (518, 2197, 'coolant', 'PSA B71 5110', 'OAT long-life coolant');

-- gen-wide fluids
INSERT INTO fluid_specs (generation_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (518, 'brake', NULL, 'DOT 4 LV', 1.00, 'Brake/clutch system total'),
  (518, 'transmission_mt', 'SAE 75W', 'PSA B71 2316', 1.70, '6-speed manual (MB6); refill quantity'),
  (518, 'transmission_at', NULL, NULL, 3.50, '8-speed automatic (ATN8); refill 3.5 L, initial fill 6.0 L');
-- AdBlue (diesel only)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes) VALUES
  (518, 2197, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid');

-- torques: wheel bolt gen-wide; drain plug + spark plug engine-scoped
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (518, NULL, 'Wheel bolts', 100, 74, '15-inch steel wheels; do not use power tools for final tightening'),
  (518, NULL, 'Oil filter housing', 16, 12, NULL),
  (518, 2200, 'Engine oil drain plug', 42, 31, NULL),
  (518, 2199, 'Engine oil drain plug', 42, 31, 'Steel sump (20 N·m aluminium sump)'),
  (518, 2198, 'Engine oil drain plug', 42, 31, 'Steel sump (20 N·m aluminium sump)'),
  (518, 2197, 'Engine oil drain plug', 34, 25, NULL),
  (518, 2200, 'Spark plugs', 22, 16, NULL),
  (518, 2199, 'Spark plugs', 22, 16, NULL),
  (518, 2198, 'Spark plugs', 22, 16, NULL),
  (518, 2200, 'Cylinder head bolts (Stage 1)', 10, 7, 'Then Stage 2: 30 N·m (bolts 1-10) + 20 N·m (bolt 11); Stage 3: 230° angle. Renew bolts.'),
  (518, 2198, 'Cylinder head bolts (Stage 1)', 10, 7, 'Then Stage 2: 30 N·m (bolts 1-10) + 20 N·m (bolt 11); Stage 3: 230° angle. Renew bolts.');

-- battery
INSERT INTO electrical_specs (generation_id, battery_group, ah) VALUES (518, 'AGM', 60);

-- tyres (bar→psi/kpa)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (518, 'front', 'normal', 31.9, 220, '195/55 R16'),
  (518, 'front', 'full',   39.2, 270, '195/55 R16'),
  (518, 'rear',  'normal', 30.5, 210, '195/55 R16'),
  (518, 'rear',  'full',   42.1, 290, '195/55 R16'),
  (518, 'front', 'normal', 31.9, 220, '205/45 R17'),
  (518, 'front', 'full',   39.2, 270, '205/45 R17'),
  (518, 'rear',  'normal', 30.5, 210, '205/45 R17'),
  (518, 'rear',  'full',   42.1, 290, '205/45 R17');

-- brakes (multiple front disc packages by wheel size)
INSERT INTO brake_specs (generation_id, axle, brake_type, disc_diameter_mm, disc_thickness_mm, disc_min_thickness_mm, pad_min_mm, drum_diameter_mm, drum_max_mm, notes) VALUES
  (518, 'front', 'disc_vented', 266.0, 22.0, 20.0, 2.0, NULL, NULL, 'Base brake package; new pad 12.0 mm'),
  (518, 'front', 'disc_vented', 283.0, 26.0, 24.0, 2.0, NULL, NULL, 'Mid brake package; new pad 12.0 mm'),
  (518, 'front', 'disc_vented', 302.0, 26.0, 24.0, 2.0, NULL, NULL, 'Larger brake package; new pad 12.0 mm'),
  (518, 'rear',  'disc_solid',  249.0,  9.0,  7.0, 2.0, NULL, NULL, 'Disc rear brakes; new pad 12.0 mm'),
  (518, 'rear',  'drum',        NULL,  NULL, NULL, NULL, 203.0, 205.0, 'Drum rear brakes; shoe lining minimum 1.0 mm');

-- wheel alignment (standard suspension; non-adjustable front geometry)
INSERT INTO alignment_specs (generation_id, axle, camber, caster, toe, thrust_angle, notes) VALUES
  (518, 'front', '-0°40'' ± 0°30''', '4°36'' ± 0°30''', '0°12'' ± 0°08''', NULL, 'King-pin inclination 12°54'' ± 0°30''; geometry not adjustable.'),
  (518, 'rear',  '-1°46'' ± 0°30''', NULL, '0°38'' ± 0°08''', '0°00'' ± 0°30''', NULL);

-- citations (all rows for this gen, vendor-neutral source)
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @cor FROM fluid_specs WHERE generation_id = 518;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @cor FROM torque_specs WHERE generation_id = 518;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @cor FROM electrical_specs WHERE generation_id = 518;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @cor FROM tire_pressures WHERE generation_id = 518;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'brake_specs', id, @cor FROM brake_specs WHERE generation_id = 518;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'alignment_specs', id, @cor FROM alignment_specs WHERE generation_id = 518;
