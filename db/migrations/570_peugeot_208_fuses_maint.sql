-- 570: Peugeot 208 II (521) fuses + maintenance. Fuses from workshop electrical
-- data (engine + passenger boxes). Maintenance = verified PSA service plan
-- (208 petrol intervals confirmed identical to the Corsa F EB2/DV5 platform),
-- engine-scoped petrol vs diesel. Source 1685.

SET @src := 1685;

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
(521,'engine_bay','F1',40,'Blower control',0),(521,'engine_bay','F2',50,'ABS/ESP control unit',0),(521,'engine_bay','F3',80,'Fuse and relay box in passenger compartment',0),(521,'engine_bay','F4',30,'ABS/ESP control unit',0),(521,'engine_bay','F5',70,'BSI',0),(521,'engine_bay','F6',60,'Fan assembly; Relay box',0),(521,'engine_bay','F7',80,'BSI',0),(521,'engine_bay','F8',20,'Not used',0),(521,'engine_bay','F9',15,'Not used',0),(521,'engine_bay','F10',15,'Not used',0),(521,'engine_bay','F11',20,'Not used',0),(521,'engine_bay','F12',5,'Accessory socket',0),(521,'engine_bay','F13',5,'BSI; relays R3, R6',0),(521,'engine_bay','F14',5,'Warning light, battery charge',0),(521,'engine_bay','F15',20,'Fuse box',0),(521,'engine_bay','F16',15,'Not used',0),(521,'engine_bay','F17',10,'Not used',0),(521,'engine_bay','F18',10,'Right headlight, main beam',0),(521,'engine_bay','F19',10,'Left headlight, main beam',0),(521,'engine_bay','F20',30,'Not used',0),(521,'engine_bay','F21',30,'Relay R3; Or; Starter solenoid',0),(521,'engine_bay','F22',15,'Automatic transmission control unit',0),(521,'engine_bay','F23',40,'Blower',0),(521,'engine_bay','F24',20,'Heated windscreen',0),(521,'engine_bay','F25',40,'Fuse box in passenger compartment',0),(521,'engine_bay','F26',7.5,'Not used',0),(521,'engine_bay','F27',25,'BSI',0),(521,'engine_bay','F28',40,'Selective catalytic reduction (SCR); Or; Not used',0),(521,'engine_bay','F29',40,'Windscreen wiper(s)',0),(521,'engine_bay','F30',80,'Pre-post heating; Or; Not used',0),(521,'engine_bay','F31',80,'PTC heater',0),(521,'engine_bay','F32',80,'Electric power steering',0),
(521,'cabin','F1',40,'Heated rear windscreen',0),(521,'cabin','F2',10,'Heated mirrors',0),(521,'cabin','F3',30,'Power window controls',0),(521,'cabin','F4',20,'Driver''s power window',0),(521,'cabin','F5',30,'Rear power windows',0),(521,'cabin','F6',5,'Not used',0),(521,'cabin','F7',30,'Not used',0),(521,'cabin','F8',40,'Passenger compartment relay R2',0),(521,'cabin','F9',25,'Not used',0),(521,'cabin','F10',30,'Heated seat supply',0),(521,'cabin','F11',5,'Driver''s seat control unit',0),(521,'cabin','F12',10,'Not used',0);

-- maintenance (PSA service plan; petrol rep 2214, diesel rep 2212)
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) VALUES
  (521,'brake_fluid_flush',NULL,NULL,24,NULL),
  (521,'coolant_flush',180000,112000,120,NULL);
INSERT INTO service_intervals (generation_id, engine_id, service, km_normal, miles_normal, months, notes) VALUES
  (521,2214,'engine_oil_and_filter',20000,12000,12,'Petrol (PureTech)'),
  (521,2214,'engine_air_filter',40000,25000,48,'Petrol (PureTech)'),
  (521,2214,'cabin_air_filter',20000,12000,12,'Petrol (PureTech)'),
  (521,2214,'spark_plugs',40000,25000,48,'Petrol (PureTech)'),
  (521,2214,'timing_belt_replacement',100000,62000,72,'Petrol: first change 100,000 km / 72 months, then every 200,000 km'),
  (521,2212,'engine_oil_and_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (521,2212,'engine_air_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (521,2212,'cabin_air_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (521,2212,'fuel_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (521,2212,'timing_belt_replacement',180000,112000,120,'Diesel (BlueHDi)');

INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id=521;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=521;
