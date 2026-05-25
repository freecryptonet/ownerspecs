-- 460: Moat fill for BMW M8 F92 (250) coupe + F91 (251) convertible + F93 (252) Gran Coupe.
-- Engine S63B44T4 (396) — same as the F90 M5 (mig 456), engine fluids/plug/filter reused.
-- AWD (front+rear diff), full-LED. All have battery + cloned torque + 4 fluids; F91 has tyres.
-- Add fluids->8, bulbs, fuses (G-platform), svc, parts, tyres (F92/F93). Cite BMW M8 SM (915).
SET @src = 915;

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (250,NULL,'differential_front',0.60,NULL,'BMW axle oil','xDrive front axle'),(250,NULL,'differential_rear',1.00,NULL,'BMW M Active differential oil',NULL),(250,NULL,'ac_refrigerant',NULL,NULL,'R1234yf','Charge per under-hood label'),(250,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.'),
  (251,NULL,'differential_front',0.60,NULL,'BMW axle oil','xDrive front axle'),(251,NULL,'differential_rear',1.00,NULL,'BMW M Active differential oil',NULL),(251,NULL,'ac_refrigerant',NULL,NULL,'R1234yf','Charge per under-hood label'),(251,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.'),
  (252,NULL,'differential_front',0.60,NULL,'BMW axle oil','xDrive front axle'),(252,NULL,'differential_rear',1.00,NULL,'BMW M Active differential oil',NULL),(252,NULL,'ac_refrigerant',NULL,NULL,'R1234yf','Charge per under-hood label'),(252,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.');

-- tyres only for F92 (250) + F93 (252); F91 already has 2
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (250,'front','standard',36.0,250,'275/35 ZR20'),(250,'rear','standard',36.0,250,'285/35 ZR20'),
  (252,'front','standard',36.0,250,'275/35 ZR20'),(252,'rear','standard',36.0,250,'285/35 ZR20');

INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (250,'Low beam headlight','LED',2,1),(250,'High beam headlight','LED',2,1),(250,'Daytime running light','LED',2,1),(250,'Front turn signal','LED',2,1),(250,'Tail / brake light','LED',2,1),(250,'Reverse light','W16W',1,0),
  (251,'Low beam headlight','LED',2,1),(251,'High beam headlight','LED',2,1),(251,'Daytime running light','LED',2,1),(251,'Front turn signal','LED',2,1),(251,'Tail / brake light','LED',2,1),(251,'Reverse light','W16W',1,0),
  (252,'Low beam headlight','LED',2,1),(252,'High beam headlight','LED',2,1),(252,'Daytime running light','LED',2,1),(252,'Front turn signal','LED',2,1),(252,'Tail / brake light','LED',2,1),(252,'Reverse light','W16W',1,0);

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (250,'Passenger','223',20,'Main headlights / light sensor',0),(250,'Passenger','206',10,'Air conditioning / DME',0),(250,'Passenger','273',20,'Cigarette lighter / 12V sockets',0),(250,'Passenger','271',30,'Fuel pump / DME',0),(250,'Passenger','203',8,'Engine management (DME/IVM)',0),(250,'Passenger','231',30,'Rear window defogger',0),(250,'Passenger','259',15,'Engine management (DME/IVM)',0),
  (251,'Passenger','223',20,'Main headlights / light sensor',0),(251,'Passenger','206',10,'Air conditioning / DME',0),(251,'Passenger','273',20,'Cigarette lighter / 12V sockets',0),(251,'Passenger','271',30,'Fuel pump / DME',0),(251,'Passenger','203',8,'Engine management (DME/IVM)',0),(251,'Passenger','231',30,'Rear window defogger',0),(251,'Passenger','259',15,'Engine management (DME/IVM)',0),
  (252,'Passenger','223',20,'Main headlights / light sensor',0),(252,'Passenger','206',10,'Air conditioning / DME',0),(252,'Passenger','273',20,'Cigarette lighter / 12V sockets',0),(252,'Passenger','271',30,'Fuel pump / DME',0),(252,'Passenger','203',8,'Engine management (DME/IVM)',0),(252,'Passenger','231',30,'Rear window defogger',0),(252,'Passenger','259',15,'Engine management (DME/IVM)',0);

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (250,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(250,'Brake fluid',NULL,NULL,24,'Time-based'),(250,'In-cabin microfilter',18600,30000,24,NULL),(250,'Spark plugs',37000,60000,48,NULL),(250,'Engine air filter',37000,60000,48,NULL),
  (251,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(251,'Brake fluid',NULL,NULL,24,'Time-based'),(251,'In-cabin microfilter',18600,30000,24,NULL),(251,'Spark plugs',37000,60000,48,NULL),(251,'Engine air filter',37000,60000,48,NULL),
  (252,'Engine oil & filter',9300,15000,24,'Condition Based Service'),(252,'Brake fluid',NULL,NULL,24,'Time-based'),(252,'In-cabin microfilter',18600,30000,24,NULL),(252,'Spark plugs',37000,60000,48,NULL),(252,'Engine air filter',37000,60000,48,NULL);

INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (250,396,'spark_plug','12120042724','NGK','SILZKBR9F8S; S63B44T4'),(250,396,'oil_filter','11425A33C43','BMW','S63T4 element'),
  (251,396,'spark_plug','12120042724','NGK','SILZKBR9F8S; S63B44T4'),(251,396,'oil_filter','11425A33C43','BMW','S63T4 element'),
  (252,396,'spark_plug','12120042724','NGK','SILZKBR9F8S; S63B44T4'),(252,396,'oil_filter','11425A33C43','BMW','S63T4 element');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id IN (250,251,252);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id IN (250,252);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id IN (250,251,252);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id IN (250,251,252);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id IN (250,251,252);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id IN (250,251,252);
