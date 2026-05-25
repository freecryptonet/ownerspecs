-- 451: Moat fill for BMW M5 (E60) gen 183. Had fluids(3), torque(257 cloned). Engine clean (S85B50A V10).
-- Missing: battery, bulbs, fuses, tyres, svc, parts + fluids top-up (3 -> 8). Cite BMW E60 SM.
-- Data from HaynesPro adjustment data + startmycar fuses + cross-checked web (bulbs, oil filter).

SET @gen = 183;   -- m5-e60-sedan-2005-2010
SET @eng = 994;   -- S85B50A 5.0 V10
SET @src = (SELECT id FROM sources WHERE citation LIKE '%E60%' AND citation LIKE '%BMW%' LIMIT 1);

-- ---- FLUIDS (3 -> 8) ----
UPDATE fluid_specs SET capacity_l=9.30, capacity_qt=ROUND(9.30*1.05669,2) WHERE generation_id=@gen AND fluid_type='engine_oil';
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_rear', 1.10, NULL, 'BMW limited-slip axle oil',        NULL),
  (@gen, @eng, 'gearbox',           NULL, NULL, 'BMW MTF-LT-2',                     'SMG GS7S-47BG 7-speed / 6-speed manual'),
  (@gen, NULL, 'power_steering',    NULL, NULL, 'BMW CHF 11S (Pentosin)',           NULL),
  (@gen, NULL, 'ac_refrigerant',    NULL, NULL, 'R134a',                            'Charge 810 +/- 10 g'),
  (@gen, NULL, 'washer_fluid',      NULL, NULL, NULL,                               'Universal washer fluid; winter mix below 0 C.');

-- ---- ELECTRICAL (90Ah AGM main + 12Ah aux, luggage compartment) ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca, alternator_amps) VALUES (@gen, NULL, 90, 900, 170);

-- ---- TORQUES ----
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel bolts',           130, 96, NULL),
  (@gen, @eng, 'Engine oil drain plug',  25, 18, NULL),
  (@gen, @eng, 'Oil filter housing cap', 25, 18, NULL),
  (@gen, @eng, 'Oxygen sensor',          50, 37, NULL),
  (@gen, @eng, 'Alternator',             46, 34, NULL);

-- ---- TYRES (staggered) ----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'standard', 35.0, 240, '245/40 R18 93W'),
  (@gen, 'rear',  'standard', 36.0, 250, '275/35 R18 95W');

-- ---- BULBS ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',  'D2S',   2, 0),
  (@gen, 'High beam headlight', 'H7',    2, 0),
  (@gen, 'Front turn signal',   'PY21W', 2, 0),
  (@gen, 'Parking / DRL ring',  'H8',    2, 0),
  (@gen, 'Reverse light',       'P21W',  1, 0),
  (@gen, 'Licence plate light', 'C5W',   2, 0);

-- ---- FUSES (E60 M5) ----
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@gen, 'Passenger', '8',  60, 'Engine management (DME)',          0),
  (@gen, 'Passenger', '9',  60, 'Electric cooling fan',             0),
  (@gen, 'Passenger', '11', 5,  'Body module (locking/windows/wiper)',0),
  (@gen, 'Passenger', '26', 8,  'Climate control (IHKA)',           0),
  (@gen, 'Passenger', '28', 20, 'Steering column module',           0),
  (@gen, 'Passenger', '30', 20, 'Fuel pump',                        0),
  (@gen, 'Passenger', '35', 5,  'Navigation system',                0),
  (@gen, 'Passenger', '42', 15, 'SMG transmission',                 0),
  (@gen, 'Luggage',   '50', 30, 'Headlight washer pump',            0),
  (@gen, 'Luggage',   '54', 40, 'Rear window defogger',             0),
  (@gen, 'Luggage',   '87', 20, 'Cigarette lighter / front socket', 0);

-- ---- SERVICE INTERVALS (BMW Condition Based Service) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'Engine oil & filter', 9300,  15000, 24,  'Condition Based Service (CBS)'),
  (@gen, 'Brake fluid',         NULL,  NULL,  24,  'Time-based (CBS)'),
  (@gen, 'In-cabin microfilter',18600, 30000, 24,  NULL),
  (@gen, 'Spark plugs',         37000, 60000, 48,  '10 plugs'),
  (@gen, 'Engine air filter',   37000, 60000, 48,  NULL),
  (@gen, 'Vehicle inspection',  NULL,  NULL,  12,  'Annual condition check');

-- ---- PARTS ----
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (@gen, @eng, 'spark_plug', 'LKR8AP',      'NGK', 'Set of 10; S85 V10'),
  (@gen, @eng, 'oil_filter', '11427837710', 'BMW', 'S85 element (with oil-cooler connection)');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src FROM electrical_specs  WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=@gen;
