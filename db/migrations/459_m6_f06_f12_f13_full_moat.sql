-- 459: Moat fill for BMW M6 F13 (260) coupe + F12 (261) convertible + F06 (262) Gran Coupe.
-- Engine S63B44T0 (2047) — same as the F10 M5 (mig 455), so engine fluids/plug/filter reused.
-- All have battery + tyres + cloned torque + 4 fluids. Add fluids->8, bulbs, fuses (F1x platform),
-- svc, parts. Cite BMW 6 (F06, F12, F13) SM (794).
SET @src = 794;

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (260,NULL,'differential_rear',1.00,NULL,'BMW limited-slip axle oil',NULL),(260,NULL,'power_steering',NULL,NULL,'BMW CHF 11S (Pentosin)',NULL),(260,NULL,'ac_refrigerant',NULL,NULL,'R134a','Charge 850 +/- 10 g'),(260,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.'),
  (261,NULL,'differential_rear',1.00,NULL,'BMW limited-slip axle oil',NULL),(261,NULL,'power_steering',NULL,NULL,'BMW CHF 11S (Pentosin)',NULL),(261,NULL,'ac_refrigerant',NULL,NULL,'R134a','Charge 850 +/- 10 g'),(261,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.'),
  (262,NULL,'differential_rear',1.00,NULL,'BMW limited-slip axle oil',NULL),(262,NULL,'power_steering',NULL,NULL,'BMW CHF 11S (Pentosin)',NULL),(262,NULL,'ac_refrigerant',NULL,NULL,'R134a','Charge 850 +/- 10 g'),(262,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.');

INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (260,'Low beam headlight','D1S',2,0),(260,'High beam headlight','H7',2,0),(260,'Front turn signal','PY21W',2,0),(260,'Parking / DRL ring','H8',2,0),(260,'Reverse light','P21W',1,0),(260,'Licence plate light','C5W',2,0),
  (261,'Low beam headlight','D1S',2,0),(261,'High beam headlight','H7',2,0),(261,'Front turn signal','PY21W',2,0),(261,'Parking / DRL ring','H8',2,0),(261,'Reverse light','P21W',1,0),(261,'Licence plate light','C5W',2,0),
  (262,'Low beam headlight','D1S',2,0),(262,'High beam headlight','H7',2,0),(262,'Front turn signal','PY21W',2,0),(262,'Parking / DRL ring','H8',2,0),(262,'Reverse light','P21W',1,0),(262,'Licence plate light','C5W',2,0);

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (260,'Passenger','20',20,'Engine management (DME/IVM)',0),(260,'Passenger','21',30,'Engine management (DME/IVM)',0),(260,'Passenger','36',30,'Headlight washer pump',0),(260,'Passenger','54',20,'Cigarette lighter / 12V sockets',0),(260,'Passenger','11',8,'Climate control unit',0),(260,'Passenger','51',30,'Wiper module',0),(260,'Luggage','184',20,'Fuel pump control',0),
  (261,'Passenger','20',20,'Engine management (DME/IVM)',0),(261,'Passenger','21',30,'Engine management (DME/IVM)',0),(261,'Passenger','36',30,'Headlight washer pump',0),(261,'Passenger','54',20,'Cigarette lighter / 12V sockets',0),(261,'Passenger','11',8,'Climate control unit',0),(261,'Passenger','51',30,'Wiper module',0),(261,'Luggage','184',20,'Fuel pump control',0),
  (262,'Passenger','20',20,'Engine management (DME/IVM)',0),(262,'Passenger','21',30,'Engine management (DME/IVM)',0),(262,'Passenger','36',30,'Headlight washer pump',0),(262,'Passenger','54',20,'Cigarette lighter / 12V sockets',0),(262,'Passenger','11',8,'Climate control unit',0),(262,'Passenger','51',30,'Wiper module',0),(262,'Luggage','184',20,'Fuel pump control',0);

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (260,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(260,'Brake fluid',NULL,NULL,24,'Time-based'),(260,'In-cabin microfilter',18600,30000,24,NULL),(260,'Spark plugs',37000,60000,48,NULL),(260,'Engine air filter',37000,60000,48,NULL),
  (261,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(261,'Brake fluid',NULL,NULL,24,'Time-based'),(261,'In-cabin microfilter',18600,30000,24,NULL),(261,'Spark plugs',37000,60000,48,NULL),(261,'Engine air filter',37000,60000,48,NULL),
  (262,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(262,'Brake fluid',NULL,NULL,24,'Time-based'),(262,'In-cabin microfilter',18600,30000,24,NULL),(262,'Spark plugs',37000,60000,48,NULL),(262,'Engine air filter',37000,60000,48,NULL);

INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (260,2047,'spark_plug','12120039664','NGK','SILZKBR8D8S; S63 4.4 V8'),(260,2047,'oil_filter','11427848321','BMW','N63/S63 4.4 V8 element'),
  (261,2047,'spark_plug','12120039664','NGK','SILZKBR8D8S; S63 4.4 V8'),(261,2047,'oil_filter','11427848321','BMW','N63/S63 4.4 V8 element'),
  (262,2047,'spark_plug','12120039664','NGK','SILZKBR8D8S; S63 4.4 V8'),(262,2047,'oil_filter','11427848321','BMW','N63/S63 4.4 V8 element');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id IN (260,261,262);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id IN (260,261,262);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id IN (260,261,262);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id IN (260,261,262);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id IN (260,261,262);
