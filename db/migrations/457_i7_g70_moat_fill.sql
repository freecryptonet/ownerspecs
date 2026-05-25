-- 457: Moat fill for BMW i7 (G70) gen 206 — BEV, now correctly detected (mig 452 fixed the motor
-- fuel labels + removed the i5-M60 contamination). Had fluids(3: coolant x2 + brake), torque(108
-- cloned). Missing: battery, bulbs, fuses, tyres, svc, parts + fluids to BEV floor (3 -> 6).
-- Data from HaynesPro adjustment data + startmycar (G70 fuses) + cross-checked web (parts).

SET @gen = 206;   -- i7-g70-sedan-2022-present
SET @eng = 1118;  -- i7 xDrive60 motor (electric)
SET @src = (SELECT id FROM sources WHERE citation LIKE '%G70, i7%' LIMIT 1);

-- ---- FLUIDS (3 -> 6; BEV) ----
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, @eng, 'reduction_gear', NULL, NULL, 'BMW electric-drive reducer oil', 'e-axle gear oil'),
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R1234yf',                        'Heat-pump system; charge per label'),
  (@gen, NULL, 'washer_fluid',   NULL, NULL, NULL,                             'Universal washer fluid; winter mix below 0 C.');

-- ---- ELECTRICAL (12V auxiliary, AGM) ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca) VALUES (@gen, NULL, 70, 720);

-- ---- BULBS (full LED) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',   'LED',  2, 1),
  (@gen, 'High beam headlight',  'LED',  2, 1),
  (@gen, 'Daytime running light','LED',  2, 1),
  (@gen, 'Front turn signal',    'LED',  2, 1),
  (@gen, 'Tail / brake light',   'LED',  2, 1),
  (@gen, 'Reverse light',        'W16W', 1, 0);

-- ---- TYRES (staggered; heavy luxury BEV) ----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'standard', 44.0, 300, '255/45 R20 105Y'),
  (@gen, 'rear',  'standard', 44.0, 300, '285/40 R20 108Y');

-- ---- FUSES (G70) ----
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@gen, 'Luggage', '141', 60, 'Headlights / ride-height control', 0),
  (@gen, 'Luggage', '249', 20, 'Headlights / level control',       0),
  (@gen, 'Luggage', '257', 40, 'Media (HiFi amp / radio / tuner)', 0),
  (@gen, 'Luggage', '263', 20, 'Media system',                     0),
  (@gen, 'Luggage', '261', 8,  'Cigarette lighter / 12V sockets',  0),
  (@gen, 'Luggage', '267', 20, 'Front and rear power outlets',     0),
  (@gen, 'Luggage', '223', 8,  'Air conditioning',                 0),
  (@gen, 'Luggage', '282', 30, 'Air conditioning / seat adjust',   0),
  (@gen, 'Luggage', '214', 8,  '48V system',                       0),
  (@gen, 'Passenger','154',30, 'Rear wiper',                       0);

-- ---- SERVICE INTERVALS (BMW CBS; BEV) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'Brake fluid',            NULL, NULL,  24,  'Condition Based Service'),
  (@gen, 'In-cabin microfilter',   18600,30000, 24,  NULL),
  (@gen, 'Reduction gear oil',     NULL, NULL,  NULL,'Inspect; e-axle'),
  (@gen, 'Coolant (HV battery/motor)',NULL,NULL,120, 'Long-life'),
  (@gen, 'Vehicle inspection',     NULL, NULL,  12,  'Annual condition check');

-- ---- PARTS (BEV: no spark plug / oil filter) ----
INSERT INTO parts (generation_id, part_type, part_number, source_brand, notes) VALUES
  (@gen, 'cabin_air_filter', '64115A547D4', 'BMW', 'Activated-carbon microfilter'),
  (@gen, 'wiper_blade',      '61615A43610', 'BMW', 'Front pair (set)');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src FROM electrical_specs  WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=@gen;
