-- 562: Opel Insignia B (gen 520) moat fill — fluids (engine-scoped oil+coolant),
-- brake fluid, transmission, torques, battery, tyres, brakes. Alignment omitted
-- (front geometry not published in the workshop adjustment data for this chassis).
-- Engines: 2207 B20NFT 2.0T petrol (LTG); 2208/2209/2210/2211 = 2.0 diesel
-- B20DT family (1956cc, shared oil/coolant). Vendor-neutral source, public_link=0.

INSERT INTO sources (citation, type, retrieved_at, public_link, is_public, notes)
VALUES ('Workshop service manual — Opel Insignia B', 'service_manual', NOW(), 0, 1,
        'Vendor-neutral workshop reference; not an OEM-owned source.');
SET @ins := LAST_INSERT_ID();

DELETE FROM fluid_specs WHERE generation_id = 520 AND viscosity IS NULL AND spec_standard IS NULL;

-- engine_oil (engine-scoped)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (520, 2207, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03', 4.70, 'Sump incl. filter (2WD); 5.7 L with 4WD; drain plug 25 N·m'),
  (520, 2208, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03', 4.90, 'Sump incl. filter; ACEA C3 outside Europe; drain plug 20 N·m'),
  (520, 2209, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03', 4.90, 'Sump incl. filter; ACEA C3 outside Europe; drain plug 20 N·m'),
  (520, 2210, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03', 4.90, 'Sump incl. filter; ACEA C3 outside Europe; drain plug 20 N·m'),
  (520, 2211, 'engine_oil', 'SAE 5W-30', 'STELLANTIS FPW9.55535/03', 4.90, 'Sump incl. filter; ACEA C3 outside Europe; drain plug 20 N·m');

-- coolant (engine-scoped; petrol 5.0 L, diesel 5.9 L)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, capacity_l, notes) VALUES
  (520, 2207, 'coolant', 'ASTM D3306-21 III', 5.00, 'De-ionised water + 50% antifreeze'),
  (520, 2208, 'coolant', 'ASTM D3306-21 III', 5.90, 'De-ionised water + 50% antifreeze'),
  (520, 2209, 'coolant', 'ASTM D3306-21 III', 5.90, 'De-ionised water + 50% antifreeze'),
  (520, 2210, 'coolant', 'ASTM D3306-21 III', 5.90, 'De-ionised water + 50% antifreeze'),
  (520, 2211, 'coolant', 'ASTM D3306-21 III', 5.90, 'De-ionised water + 50% antifreeze');

-- gen-wide fluids
INSERT INTO fluid_specs (generation_id, fluid_type, viscosity, spec_standard, capacity_l, notes) VALUES
  (520, 'brake', NULL, 'DOT 4 LV', 1.00, 'Brake system total'),
  (520, 'transmission_at', NULL, NULL, 7.10, 'Aisin AF50-8 8-speed / GM 9T60-9T65 9-speed automatic; refill after overhaul (without oil cooler)');
-- AdBlue (diesels)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, spec_standard, notes) VALUES
  (520, 2208, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid'),
  (520, 2209, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid'),
  (520, 2210, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid'),
  (520, 2211, 'def_fluid', 'ISO 22241 (AUS 32 / AdBlue)', 'SCR diesel exhaust fluid');

-- torques
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (520, NULL, 'Wheel nuts', 140, 103, 'Tighten in a criss-cross pattern'),
  (520, 2207, 'Engine oil drain plug', 25, 18, 'Renew the seal'),
  (520, 2208, 'Engine oil drain plug', 20, 15, 'Renew the seal'),
  (520, 2209, 'Engine oil drain plug', 20, 15, 'Renew the seal'),
  (520, 2210, 'Engine oil drain plug', 20, 15, 'Renew the seal'),
  (520, 2211, 'Engine oil drain plug', 20, 15, 'Renew the seal'),
  (520, 2208, 'Cylinder head bolts (Stage 1)', 65, 48, 'Then Stage 2/3/4: 90° angle each. Renew bolts.'),
  (520, 2210, 'Cylinder head bolts (Stage 1)', 65, 48, 'Then Stage 2/3/4: 90° angle each. Renew bolts.');

-- battery
INSERT INTO electrical_specs (generation_id, ah) VALUES (520, 70);

-- tyres
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (520, 'front', 'normal', 31.9, 220, '225/55 R17'),
  (520, 'front', 'full',   39.2, 270, '225/55 R17'),
  (520, 'rear',  'normal', 31.9, 220, '225/55 R17'),
  (520, 'rear',  'full',   39.2, 270, '225/55 R17');

-- brakes (front disc packages by trim; rear disc both solid + vented variants)
INSERT INTO brake_specs (generation_id, axle, brake_type, disc_diameter_mm, disc_thickness_mm, disc_min_thickness_mm, pad_min_mm, notes) VALUES
  (520, 'front', 'disc_vented', 300.0, 26.0, 23.0, 2.0, 'Base brake package; new pad 13.0 mm'),
  (520, 'front', 'disc_vented', 321.0, 28.0, 25.0, 2.0, 'Mid brake package; new pad 12.5 mm'),
  (520, 'front', 'disc_vented', 345.0, 30.0, 27.0, 2.0, 'GSi / BiTurbo brake package; new pad 10.0 mm'),
  (520, 'rear',  'disc_solid',  288.0, 12.0, 10.0, 2.0, 'Disc rear brakes; new pad 10.0 mm'),
  (520, 'rear',  'disc_vented', 315.0, 23.0, 21.0, 2.0, 'GSi / BiTurbo rear brakes; new pad 11.0 mm');

-- citations
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @ins FROM fluid_specs WHERE generation_id = 520;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @ins FROM torque_specs WHERE generation_id = 520;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @ins FROM electrical_specs WHERE generation_id = 520;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @ins FROM tire_pressures WHERE generation_id = 520;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'brake_specs', id, @ins FROM brake_specs WHERE generation_id = 520;
