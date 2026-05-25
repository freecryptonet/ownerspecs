-- 455: Moat fill for BMW M5 (F10) gen 176. Engine now S63B44T0 (mig 453). Had fluids(4), tyres(2),
-- torque(cloned). Missing: battery, bulbs, fuses, svc, parts + fluids top-up (4 -> 8).
-- Data from HaynesPro adjustment data + startmycar (F10 5-series fuses) + cross-checked web.

SET @gen = 176;   -- m5-f10-sedan-2011-2016
SET @eng = (SELECT id FROM engines WHERE code='S63B44T0');
SET @src = (SELECT id FROM sources WHERE citation LIKE '%F10%' AND citation LIKE '%BMW%' LIMIT 1);

-- ---- FLUIDS (4 -> 8) ----
UPDATE fluid_specs SET capacity_l=1.00, capacity_qt=ROUND(1.00*1.05669,2) WHERE generation_id=@gen AND fluid_type='brake_fluid';
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_rear', 1.00, NULL, 'BMW limited-slip axle oil', NULL),
  (@gen, NULL, 'power_steering',    NULL, NULL, 'BMW CHF 11S (Pentosin)',    'Hydraulic (Servotronic)'),
  (@gen, NULL, 'ac_refrigerant',    NULL, NULL, 'R134a',                     'Charge 850 +/- 10 g'),
  (@gen, NULL, 'washer_fluid',      NULL, NULL, NULL,                        'Universal washer fluid; winter mix below 0 C.');

-- ---- ELECTRICAL (AGM, luggage compartment) ----
INSERT INTO electrical_specs (generation_id, battery_group, ah, cca) VALUES (@gen, NULL, 80, 800);

-- ---- TORQUES ----
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@gen, NULL, 'Wheel bolts',           140, 103, NULL),
  (@gen, @eng, 'Engine oil drain plug',  25,  18, 'Renew seal'),
  (@gen, @eng, 'Spark plugs',            23,  17, 'M12; 20-26 Nm'),
  (@gen, @eng, 'Oil filter housing cap', 30,  22, NULL),
  (@gen, @eng, 'Oxygen sensor',          50,  37, NULL);

-- ---- BULBS (bi-xenon) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'Low beam headlight',  'D1S',   2, 0),
  (@gen, 'High beam headlight', 'H7',    2, 0),
  (@gen, 'Front turn signal',   'PY21W', 2, 0),
  (@gen, 'Parking / DRL ring',  'H8',    2, 0),
  (@gen, 'Reverse light',       'P21W',  1, 0),
  (@gen, 'Licence plate light', 'C5W',   2, 0);

-- ---- FUSES (F10 5-series platform) ----
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@gen, 'Passenger', '20',  20, 'Engine management (DME/IVM)',       0),
  (@gen, 'Passenger', '21',  30, 'Engine management (DME/IVM)',       0),
  (@gen, 'Passenger', '36',  30, 'Headlight washer pump',             0),
  (@gen, 'Passenger', '54',  20, 'Cigarette lighter / 12V sockets',   0),
  (@gen, 'Passenger', '11',  8,  'Climate control unit',              0),
  (@gen, 'Passenger', '51',  30, 'Wiper module',                      0),
  (@gen, 'Passenger', '50',  40, 'ABS / DSC',                         0),
  (@gen, 'Luggage',   '132', 5,  'High beam, right',                  0),
  (@gen, 'Luggage',   '119', 15, 'Audio / head unit',                 0),
  (@gen, 'Luggage',   '177', 20, 'Heater blower',                     0),
  (@gen, 'Luggage',   '184', 20, 'Fuel pump control',                 0);

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
  (@gen, @eng, 'spark_plug', '12120039664', 'NGK', 'SILZKBR8D8S; S63 4.4 V8'),
  (@gen, @eng, 'oil_filter', '11427848321', 'BMW', 'N63/S63 4.4 V8 element');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src FROM electrical_specs  WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs',      id, @src FROM torque_specs      WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id=@gen;
