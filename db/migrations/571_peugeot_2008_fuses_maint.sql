-- 571: Peugeot 2008 II (522) fuses + maintenance. Source 1691.
SET @src := 1691;

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
(522,'engine_bay','F1',40,'Front air conditioning',0),(522,'engine_bay','F2',50,'ESP control unit; Or; ABS control unit',0),(522,'engine_bay','F3',80,'Fuse and relay box in passenger compartment',0),(522,'engine_bay','F4',30,'Brake control unit; ESP control unit',0),(522,'engine_bay','F5',70,'Fuse box',0),(522,'engine_bay','F6',60,'Relay box; Fan assembly',0),(522,'engine_bay','F7',80,'Fuse box',0),(522,'engine_bay','F8',20,'Spare fuse',0),(522,'engine_bay','F9',15,'Spare fuse',0),(522,'engine_bay','F10',15,'Spare fuse',0),(522,'engine_bay','F11',20,'Spare fuse',0),(522,'engine_bay','F12',5,'Accessory socket',0),(522,'engine_bay','F13',5,'BSI',0),(522,'engine_bay','F14',5,'Battery monitor control unit',0),(522,'engine_bay','F15',20,'Fuse box',0),(522,'engine_bay','F16',15,'Spare fuse',0),(522,'engine_bay','F17',10,'Spare fuse',0),(522,'engine_bay','F18',10,'Right main beam',0),(522,'engine_bay','F19',10,'Left main beam',0),(522,'engine_bay','F20',30,'Spare fuse',0),(522,'engine_bay','F21',30,'Starter solenoid',0),(522,'engine_bay','F22',15,'Automatic transmission control unit',0),(522,'engine_bay','F23',40,'Front air conditioning',0),(522,'engine_bay','F24',20,'Heated windscreen',0),(522,'engine_bay','F25',40,'Fuse box in passenger compartment',0),(522,'engine_bay','F26',7.5,'Spare fuse',0),(522,'engine_bay','F27',25,'Fuse and relay box in passenger compartment',0),(522,'engine_bay','F28',40,'Vacuum pump; Selective catalytic reduction (SCR)',0),(522,'engine_bay','F29',40,'Windscreen wiper',0),(522,'engine_bay','F30',80,'Preheating control unit',0),(522,'engine_bay','F31',80,'Heating and air conditioning',0),(522,'engine_bay','F32',80,'Power steering control unit',0),
(522,'cabin','F36',25,'Trailer battery supply',0),(522,'cabin','F37',20,'Trailer battery supply',0),(522,'cabin','F38',20,'Trailer battery supply',0),(522,'cabin','F39',20,'Spare fuse',0),(522,'cabin','F40',5,'Spare fuse',0);

INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) VALUES
  (522,'brake_fluid_flush',NULL,NULL,24,NULL),(522,'coolant_flush',180000,112000,120,NULL);
INSERT INTO service_intervals (generation_id, engine_id, service, km_normal, miles_normal, months, notes) VALUES
  (522,2214,'engine_oil_and_filter',20000,12000,12,'Petrol (PureTech)'),
  (522,2214,'engine_air_filter',40000,25000,48,'Petrol (PureTech)'),
  (522,2214,'cabin_air_filter',20000,12000,12,'Petrol (PureTech)'),
  (522,2214,'spark_plugs',40000,25000,48,'Petrol (PureTech)'),
  (522,2214,'timing_belt_replacement',100000,62000,72,'Petrol: first change 100,000 km / 72 months, then every 200,000 km'),
  (522,2216,'engine_oil_and_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (522,2216,'engine_air_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (522,2216,'cabin_air_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (522,2216,'fuel_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (522,2216,'timing_belt_replacement',180000,112000,120,'Diesel (BlueHDi)');

INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id=522;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=522;
