-- 573: Citroën C3 III (524) fuses + maintenance. Source 1716.
SET @src := 1716;

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
(524,'engine_bay','F1',40,'Blower',0),(524,'engine_bay','F2',60,'ESP control unit',0),(524,'engine_bay','F3',80,'Additional fuse box in passenger compartment',0),(524,'engine_bay','F4',30,'ESP control unit',0),(524,'engine_bay','F5',70,'Fuse box No. 1 in passenger compartment',0),(524,'engine_bay','F6',60,'Two-speed cooling fan',0),(524,'engine_bay','F7',80,'Fuse box No. 1 in passenger compartment',0),(524,'engine_bay','F8',15,'Oil pressure control valve',0),(524,'engine_bay','F9',15,'Engine control unit',0),(524,'engine_bay','F10',15,'Engine control unit',0),(524,'engine_bay','F11',20,'Engine control unit',0),(524,'engine_bay','F12',5,'Fan assembly; Accessory socket',0),(524,'engine_bay','F13',5,'Fuse box No. 1 in passenger compartment',0),(524,'engine_bay','F14',5,'Battery sensor',0),(524,'engine_bay','F15',5,'Spare fuse',0),(524,'engine_bay','F16',20,'Front fog lights',0),(524,'engine_bay','F17',5,'Fuse box No. 1 in passenger compartment',0),(524,'engine_bay','F18',10,'Right headlight, main beam',0),(524,'engine_bay','F19',10,'Left headlight, main beam',0),(524,'engine_bay','F20',30,'Engine control unit; Fuel pump with level sensor',0),(524,'engine_bay','F21',30,'Starter motor',0),(524,'engine_bay','F22',30,'Starter motor; Or; Headlight washer',0),(524,'engine_bay','F23',40,'Spare fuse',0),(524,'engine_bay','F24',20,'Spare fuse',0),(524,'engine_bay','F25',40,'Additional fuse box in passenger compartment',0),(524,'engine_bay','F26',20,'Automatic transmission; (15A also used)',0),(524,'engine_bay','F27',20,'Fuse box No. 1 in passenger compartment',0),(524,'engine_bay','F28',30,'Engine control unit',0),(524,'engine_bay','F29',40,'Windscreen wiper',0),(524,'engine_bay','F30',80,'Glow plug control unit; or not used',0),(524,'engine_bay','F31',80,'Protection and Switching unit',0),(524,'engine_bay','F32',80,'Electric power steering',0);

INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) VALUES
  (524,'brake_fluid_flush',NULL,NULL,24,NULL),(524,'coolant_flush',180000,112000,120,NULL);
INSERT INTO service_intervals (generation_id, engine_id, service, km_normal, miles_normal, months, notes) VALUES
  (524,2229,'engine_oil_and_filter',20000,12000,12,'Petrol (PureTech)'),
  (524,2229,'engine_air_filter',40000,25000,48,'Petrol (PureTech)'),
  (524,2229,'cabin_air_filter',20000,12000,12,'Petrol (PureTech)'),
  (524,2229,'spark_plugs',40000,25000,48,'Petrol (PureTech)'),
  (524,2229,'timing_belt_replacement',100000,62000,72,'Petrol: first change 100,000 km / 72 months, then every 200,000 km'),
  (524,2212,'engine_oil_and_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (524,2212,'engine_air_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (524,2212,'cabin_air_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (524,2212,'fuel_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (524,2212,'timing_belt_replacement',180000,112000,120,'Diesel (BlueHDi)');

INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id=524;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=524;
