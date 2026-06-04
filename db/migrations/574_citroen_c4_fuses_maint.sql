-- 574: Citroën C4 III (525) fuses + maintenance. Source 1729.
SET @src := 1729;

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
(525,'engine_bay','F1',40,'Not used',0),(525,'engine_bay','F2',50,'ESP control unit',0),(525,'engine_bay','F3',40,'Blower relay',0),(525,'engine_bay','F4',30,'ESP control unit',0),(525,'engine_bay','F5',50,'BSI',0),(525,'engine_bay','F6',60,'Cooling fan, low-speed relay',0),(525,'engine_bay','F7',80,'BSI',0),(525,'engine_bay','F8',15,'Engine control unit',0),(525,'engine_bay','F9',15,'Engine control unit',0),(525,'engine_bay','F10',15,'Engine control unit',0),(525,'engine_bay','F11',20,'Engine control unit',0),(525,'engine_bay','F12',5,'Accessory socket; Fan assembly supply relay; Engine control unit',0),(525,'engine_bay','F13',5,'BSI',0),(525,'engine_bay','F14',5,'Warning light, battery charge',0),(525,'engine_bay','F15',7.5,'Air-conditioning compressor relay',0),(525,'engine_bay','F16',7.5,'Air-conditioning compressor',0),(525,'engine_bay','F17',10,'Not used',0),(525,'engine_bay','F18',10,'Main beam',0),(525,'engine_bay','F19',10,'Main beam',0),(525,'engine_bay','F20',30,'Engine control unit; Fuel pump',0),(525,'engine_bay','F21',30,'Relay R3; Or; Starter solenoid',0),(525,'engine_bay','F22',15,'Automatic transmission control unit',0),(525,'engine_bay','F23',10,'Not used',0),(525,'engine_bay','F24',40,'Fuse box in passenger compartment',0),(525,'engine_bay','F25',25,'Not used',0),(525,'engine_bay','F26',5,'Relay R2',0),(525,'engine_bay','F27',25,'BSI',0),(525,'engine_bay','F28',30,'Not used',0),(525,'engine_bay','F29',40,'Windscreen wiper',0),(525,'engine_bay','F30',80,'Not used',0),(525,'engine_bay','F31',80,'Fuse and relay box in passenger compartment',0),(525,'engine_bay','F32',80,'BSI',0);

INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) VALUES
  (525,'brake_fluid_flush',NULL,NULL,24,NULL),(525,'coolant_flush',180000,112000,120,NULL);
INSERT INTO service_intervals (generation_id, engine_id, service, km_normal, miles_normal, months, notes) VALUES
  (525,2214,'engine_oil_and_filter',20000,12000,12,'Petrol (PureTech)'),
  (525,2214,'engine_air_filter',40000,25000,48,'Petrol (PureTech)'),
  (525,2214,'cabin_air_filter',20000,12000,12,'Petrol (PureTech)'),
  (525,2214,'spark_plugs',40000,25000,48,'Petrol (PureTech)'),
  (525,2214,'timing_belt_replacement',100000,62000,72,'Petrol: first change 100,000 km / 72 months, then every 200,000 km'),
  (525,2216,'engine_oil_and_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (525,2216,'engine_air_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (525,2216,'cabin_air_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (525,2216,'fuel_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (525,2216,'timing_belt_replacement',180000,112000,120,'Diesel (BlueHDi)');

INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id=525;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=525;
