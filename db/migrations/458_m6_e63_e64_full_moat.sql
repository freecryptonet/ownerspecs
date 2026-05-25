-- 458: Moat fill for BMW M6 E63 (255) coupe + E64 (256) convertible. Engine S85B50A V10 (994) —
-- IDENTICAL to the E60 M5 (mig 451), so engine fluids/plug/filter are reused (same engine,
-- verified once). Both had battery + cloned torque + 3 fluids. Missing: fluids->8, tyres, bulbs,
-- fuses, svc, parts. Chassis is the E6x platform (same fuse architecture as E60 M5). M6 coupe
-- tyres + battery confirmed via HaynesPro. Cite BMW 6 (E63, E64) SM (793).

SET @src = 793;

-- ---- FLUIDS (3 -> 8 each) ----
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (255, NULL, 'differential_rear', 1.10, NULL, 'BMW limited-slip axle oil', NULL),
  (255, 994,  'gearbox',           NULL, NULL, 'BMW MTF-LT-2',             'SMG GS7S-47BG / 6-speed manual'),
  (255, NULL, 'power_steering',    NULL, NULL, 'BMW CHF 11S (Pentosin)',   NULL),
  (255, NULL, 'ac_refrigerant',    NULL, NULL, 'R134a',                    'Charge 810 +/- 10 g'),
  (255, NULL, 'washer_fluid',      NULL, NULL, NULL,                       'Universal washer fluid; winter mix below 0 C.'),
  (256, NULL, 'differential_rear', 1.10, NULL, 'BMW limited-slip axle oil', NULL),
  (256, 994,  'gearbox',           NULL, NULL, 'BMW MTF-LT-2',             'SMG GS7S-47BG / 6-speed manual'),
  (256, NULL, 'power_steering',    NULL, NULL, 'BMW CHF 11S (Pentosin)',   NULL),
  (256, NULL, 'ac_refrigerant',    NULL, NULL, 'R134a',                    'Charge 810 +/- 10 g'),
  (256, NULL, 'washer_fluid',      NULL, NULL, NULL,                       'Universal washer fluid; winter mix below 0 C.');

-- ---- TYRES (M6 coupe/convertible, staggered) ----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (255,'front','standard',36.0,250,'255/40 ZR19'),(255,'rear','standard',39.0,270,'285/35 ZR19'),
  (256,'front','standard',36.0,250,'255/40 ZR19'),(256,'rear','standard',39.0,270,'285/35 ZR19');

-- ---- BULBS (bi-xenon, as E60/E63 platform) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (255,'Low beam headlight','D2S',2,0),(255,'High beam headlight','H7',2,0),(255,'Front turn signal','PY21W',2,0),
  (255,'Parking / DRL ring','H8',2,0),(255,'Reverse light','P21W',1,0),(255,'Licence plate light','C5W',2,0),
  (256,'Low beam headlight','D2S',2,0),(256,'High beam headlight','H7',2,0),(256,'Front turn signal','PY21W',2,0),
  (256,'Parking / DRL ring','H8',2,0),(256,'Reverse light','P21W',1,0),(256,'Licence plate light','C5W',2,0);

-- ---- FUSES (E6x platform; same architecture as the E60 M5) ----
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (255,'Passenger','8',60,'Engine management (DME)',0),(255,'Passenger','9',60,'Electric cooling fan',0),
  (255,'Passenger','11',5,'Body module (locking/windows/wiper)',0),(255,'Passenger','26',8,'Climate control (IHKA)',0),
  (255,'Passenger','30',20,'Fuel pump',0),(255,'Passenger','42',15,'SMG transmission',0),
  (255,'Luggage','50',30,'Headlight washer pump',0),(255,'Luggage','54',40,'Rear window defogger',0),
  (256,'Passenger','8',60,'Engine management (DME)',0),(256,'Passenger','9',60,'Electric cooling fan',0),
  (256,'Passenger','11',5,'Body module (locking/windows/wiper)',0),(256,'Passenger','26',8,'Climate control (IHKA)',0),
  (256,'Passenger','30',20,'Fuel pump',0),(256,'Passenger','42',15,'SMG transmission',0),
  (256,'Luggage','50',30,'Headlight washer pump',0),(256,'Luggage','54',40,'Rear window defogger',0);

-- ---- SERVICE INTERVALS (BMW CBS) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (255,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(255,'Brake fluid',NULL,NULL,24,'Time-based'),
  (255,'In-cabin microfilter',18600,30000,24,NULL),(255,'Spark plugs',37000,60000,48,'10 plugs'),
  (255,'Engine air filter',37000,60000,48,NULL),
  (256,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(256,'Brake fluid',NULL,NULL,24,'Time-based'),
  (256,'In-cabin microfilter',18600,30000,24,NULL),(256,'Spark plugs',37000,60000,48,'10 plugs'),
  (256,'Engine air filter',37000,60000,48,NULL);

-- ---- PARTS (S85 V10) ----
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (255,994,'spark_plug','LKR8AP','NGK','Set of 10; S85 V10'),(255,994,'oil_filter','11427837710','BMW','S85 element'),
  (256,994,'spark_plug','LKR8AP','NGK','Set of 10; S85 V10'),(256,994,'oil_filter','11427837710','BMW','S85 element');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id IN (255,256);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id IN (255,256);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id IN (255,256);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id IN (255,256);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id IN (255,256);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id IN (255,256);
