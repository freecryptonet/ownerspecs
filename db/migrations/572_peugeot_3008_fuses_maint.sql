-- 572: Peugeot 3008 II (523) fuses + maintenance. Source 1700.
-- Maintenance = PSA service plan across the gen's petrol (EB2/EP6) and diesel
-- (DV5/DV6/DW10) families; petrol rep 2227 (EB2), diesel rep 2216 (DV5).
SET @src := 1700;

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
(523,'engine_bay','F1',15,'Diesel injection; If fitted',0),(523,'engine_bay','F2',5,'Fan control relay',0),(523,'engine_bay','F3',5,'Alternator',0),(523,'engine_bay','F4',5,'Reductant injector; If fitted',0),(523,'engine_bay','F5',15,'Diesel pump; If fitted',0),(523,'engine_bay','F6',20,'Pump; If fitted',0),(523,'engine_bay','F7',10,'Fuel pressure regulator; Turbocharger (VGT) solenoid; If fitted',0),(523,'engine_bay','F8',10,'Water in fuel; Oil pump; NOx sensor; If fitted',0),(523,'engine_bay','F9',10,'Electric steering lock',0),(523,'engine_bay','F10',5,'Starter system',0),(523,'engine_bay','F11',15,'Protection and Switching unit; Headlight adjustment control unit',0),(523,'engine_bay','F12',5,'Spare fuse',0),(523,'engine_bay','F13',5,'Network voltage regulator control unit',0),(523,'engine_bay','F14',25,'Washer motor',0),(523,'engine_bay','F15',5,'Power steering control unit; Diagnostic socket; Radar sensor',0),(523,'engine_bay','F16',20,'Rear air-conditioning control unit',0),(523,'engine_bay','F17',10,'BSI',0),(523,'engine_bay','F19',30,'Spare fuse',0),(523,'engine_bay','F20',15,'Windscreen washer pump',0),(523,'engine_bay','F21',20,'Spare fuse',0),(523,'engine_bay','F22',15,'Horn',0),(523,'engine_bay','F23',15,'Right main beam',0),(523,'engine_bay','F24',15,'Left main beam',0),(523,'engine_bay','F25',30,'Spare fuse',0),(523,'engine_bay','F27',5,'Spare fuse',0),(523,'engine_bay','F28',5,'Spare fuse',0),(523,'engine_bay','F29',30,'Starter motor',0),(523,'engine_bay','F30',30,'Diesel fuel preheater; If fitted',0),(523,'engine_bay','MF1',5,'Air inlet fan control unit',0),(523,'engine_bay','MF5',15,'Spare fuse',0),(523,'engine_bay','MF6',40,'Front wiper',0),(523,'engine_bay','MF8',30,'NOx sensor; Reductant quality sensor; If fitted',0),(523,'engine_bay','MF9',10,'Spare fuse',0),(523,'engine_bay','MF10',5,'Spare fuse',0),(523,'engine_bay','MF11',5,'Spare fuse',0),(523,'engine_bay','MF12',15,'(Semi-)automatic transmission control unit; If fitted',0),(523,'engine_bay','MF13',20,'Coolant heater',0),(523,'engine_bay','MF14',5,'(Semi-)automatic transmission control unit; If fitted',0),(523,'engine_bay','MF15',15,'Spare fuse',0),(523,'engine_bay','MF16',15,'Spare fuse',0),(523,'engine_bay','MF17',10,'Spare fuse',0),(523,'engine_bay','MF18',5,'Brake pedal switch',0),(523,'engine_bay','MF19',5,'Spare fuse',0);

INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) VALUES
  (523,'brake_fluid_flush',NULL,NULL,24,NULL),(523,'coolant_flush',180000,112000,120,NULL);
INSERT INTO service_intervals (generation_id, engine_id, service, km_normal, miles_normal, months, notes) VALUES
  (523,2227,'engine_oil_and_filter',20000,12000,12,'Petrol (PureTech / THP)'),
  (523,2227,'engine_air_filter',40000,25000,48,'Petrol (PureTech / THP)'),
  (523,2227,'cabin_air_filter',20000,12000,12,'Petrol (PureTech / THP)'),
  (523,2227,'spark_plugs',40000,25000,48,'Petrol (PureTech / THP)'),
  (523,2216,'engine_oil_and_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (523,2216,'engine_air_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (523,2216,'cabin_air_filter',30000,19000,12,'Diesel (BlueHDi)'),
  (523,2216,'fuel_filter',60000,37000,48,'Diesel (BlueHDi)'),
  (523,2216,'timing_belt_replacement',180000,112000,120,'Diesel (BlueHDi)');

INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @src FROM fuses WHERE generation_id=523;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=523;
