-- 461: Moat fill for BMW X6 M (F96) 239 (2019-2023) + 240 (LCI 2023+). Engine S63B44T4 (396).
-- SUV-specific: oil 10.0 L (kept as-is, correct), 105Ah/950 AGM battery, 21" staggered tyres.
-- Had cloned torque + 4 fluids; mig 453 removed the S68 contamination. Add battery, fluids->8,
-- bulbs, fuses, svc, parts (+ tyres for the LCI). Cite BMW X6 (F96, G06) SM (787).
SET @src = 787;

INSERT INTO electrical_specs (generation_id, battery_group, ah, cca, alternator_amps) VALUES
  (239, NULL, 105, 950, 250), (240, NULL, 105, 950, 250);

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (239,NULL,'differential_front',0.60,NULL,'BMW axle oil','xDrive front axle'),(239,NULL,'differential_rear',1.00,NULL,'BMW M Active differential oil',NULL),(239,NULL,'ac_refrigerant',NULL,NULL,'R1234yf','Charge per under-hood label'),(239,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.'),
  (240,NULL,'differential_front',0.60,NULL,'BMW axle oil','xDrive front axle'),(240,NULL,'differential_rear',1.00,NULL,'BMW M Active differential oil',NULL),(240,NULL,'ac_refrigerant',NULL,NULL,'R1234yf','Charge per under-hood label'),(240,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.');

-- tyres only for the LCI (240); 239 already has 2
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (240,'front','standard',36.0,250,'295/35 ZR21'),(240,'rear','standard',36.0,250,'315/35 ZR21');

INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (239,'Low beam headlight','LED',2,1),(239,'High beam headlight','LED',2,1),(239,'Daytime running light','LED',2,1),(239,'Front turn signal','LED',2,1),(239,'Tail / brake light','LED',2,1),(239,'Reverse light','W16W',1,0),
  (240,'Low beam headlight','LED',2,1),(240,'High beam headlight','LED',2,1),(240,'Daytime running light','LED',2,1),(240,'Front turn signal','LED',2,1),(240,'Tail / brake light','LED',2,1),(240,'Reverse light','W16W',1,0);

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (239,'Luggage','141',60,'Headlights / ride-height control',0),(239,'Luggage','257',40,'Media (HiFi amp / radio)',0),(239,'Luggage','261',8,'Cigarette lighter / 12V sockets',0),(239,'Luggage','267',20,'Front and rear power outlets',0),(239,'Luggage','223',8,'Air conditioning',0),(239,'Luggage','282',30,'Air conditioning / seat adjust',0),(239,'Passenger','154',30,'Rear wiper',0),
  (240,'Luggage','141',60,'Headlights / ride-height control',0),(240,'Luggage','257',40,'Media (HiFi amp / radio)',0),(240,'Luggage','261',8,'Cigarette lighter / 12V sockets',0),(240,'Luggage','267',20,'Front and rear power outlets',0),(240,'Luggage','223',8,'Air conditioning',0),(240,'Luggage','282',30,'Air conditioning / seat adjust',0),(240,'Passenger','154',30,'Rear wiper',0);

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (239,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(239,'Brake fluid',NULL,NULL,24,'Time-based'),(239,'In-cabin microfilter',18600,30000,24,NULL),(239,'Spark plugs',37000,60000,48,NULL),(239,'Engine air filter',37000,60000,48,NULL),
  (240,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(240,'Brake fluid',NULL,NULL,24,'Time-based'),(240,'In-cabin microfilter',18600,30000,24,NULL),(240,'Spark plugs',37000,60000,48,NULL),(240,'Engine air filter',37000,60000,48,NULL);

INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (239,396,'spark_plug','12120042724','NGK','SILZKBR9F8S; S63B44T4'),(239,396,'oil_filter','11425A33C43','BMW','S63T4 element'),
  (240,396,'spark_plug','12120042724','NGK','SILZKBR9F8S; S63B44T4'),(240,396,'oil_filter','11425A33C43','BMW','S63T4 element');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',  id, @src FROM electrical_specs  WHERE generation_id IN (239,240);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id IN (239,240);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id=240;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id IN (239,240);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id IN (239,240);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id IN (239,240);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id IN (239,240);
