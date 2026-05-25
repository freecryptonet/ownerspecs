-- 456: Moat fill for BMW M5 (F90) gen 146. Engine S63B44T4 (396, clean post mig-452/453).
-- Had fluids(4, deduped), tyres(2), torque(cloned). Missing: battery, bulbs, fuses, svc, parts +
-- fluids top-up (4 -> 8). AWD xDrive (front+rear diff), EPS (no PS fluid), Li-ion 12V battery.
-- Data from HaynesPro adjustment data + startmycar (F90 fuses) + cross-checked web (parts).

SET @gen = 146;   -- m5-f90-sedan-2018-2023
SET @eng = 396;   -- S63B44T4
SET @src = (SELECT id FROM sources WHERE (citation LIKE '%F90%' OR citation LIKE '%G30%') AND citation LIKE '%BMW%' LIMIT 1);

-- ---- FLUIDS (4 -> 8) ----
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_front', 0.60, NULL, 'BMW axle oil',  'xDrive front axle'),
  (@gen, NULL, 'differential_rear',  1.00, NULL, 'BMW M Active differential oil', NULL),
  (@gen, NULL, 'ac_refrigerant',     NULL, NULL, 'R1234yf',       'Charge per under-hood label'),
  (@gen, NULL, 'washer_fluid',       NULL, NULL, NULL,            'Universal washer fluid; winter mix below 0 C.');

-- ---- ELECTRICAL (Lithium-ion 12V; luggage) ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca, alternator_amps) VALUES (@gen, 'Li-ion', 70, 860, 250);

-- ---- TORQUES ----
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel bolts',           140, 103, NULL),
  (@gen, @eng, 'Engine oil drain plug',  40,  30, 'Renew sealing washer'),
  (@gen, @eng, 'Spark plugs',            23,  17, 'M12'),
  (@gen, @eng, 'Oil filter housing cap', 30,  22, NULL),
  (@gen, @eng, 'Oxygen sensor',          50,  37, NULL);

-- ---- BULBS (full LED) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',   'LED',  2, 1),
  (@gen, 'High beam headlight',  'LED',  2, 1),
  (@gen, 'Daytime running light','LED',  2, 1),
  (@gen, 'Front turn signal',    'LED',  2, 1),
  (@gen, 'Tail / brake light',   'LED',  2, 1),
  (@gen, 'Reverse light',        'W16W', 1, 0);

-- ---- FUSES (F90) ----
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@gen, 'Passenger', '223', 20, 'Main headlights / light sensor',    0),
  (@gen, 'Passenger', '225', 20, 'Main headlights / rain sensor',     0),
  (@gen, 'Passenger', '206', 10, 'Air conditioning / DME',            0),
  (@gen, 'Passenger', '273', 20, 'Cigarette lighter / 12V sockets',   0),
  (@gen, 'Passenger', '244', 5,  'Fuel pump relay / control',         0),
  (@gen, 'Passenger', '271', 30, 'Fuel pump / DME',                   0),
  (@gen, 'Passenger', '203', 8,  'Engine management (DME/IVM)',       0),
  (@gen, 'Passenger', '259', 15, 'Engine management (DME/IVM)',       0),
  (@gen, 'Passenger', '231', 30, 'Rear window defogger',              0),
  (@gen, 'Passenger', '257', 5,  'Driving assistance / interior',     0);

-- ---- SERVICE INTERVALS (BMW Condition Based Service) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, 'Engine oil & filter', 9300,  15000, 24,  'Condition Based Service (CBS)'),
  (@gen, 'Brake fluid',         NULL,  NULL,  24,  'Time-based (CBS)'),
  (@gen, 'In-cabin microfilter',18600, 30000, 24,  NULL),
  (@gen, 'Spark plugs',         37000, 60000, 48,  NULL),
  (@gen, 'Engine air filter',   37000, 60000, 48,  NULL),
  (@gen, 'Vehicle inspection',  NULL,  NULL,  12,  'Annual condition check');

-- ---- PARTS ----
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (@gen, @eng, 'spark_plug', '12120042724', 'NGK', 'SILZKBR9F8S; S63B44T4'),
  (@gen, @eng, 'oil_filter', '11425A33C43', 'BMW', 'S63T4 element (cap w/ drain)');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src FROM electrical_specs  WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=@gen;
