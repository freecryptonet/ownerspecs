-- 462: S55 group — dedup M3 F80 split engine + moat-fill M3 F80 (141), M2 F87 (213),
-- M4 F82 (223), M4 F83 (224). Engine S55B30A (887, 3.0 TT I6). Engine data verified on the
-- M3 F80 HaynesPro: oil 6.5 L, coolant 13.9 L, rear diff 1.0 L, Bosch ZR5TPP330 plug
-- (BMW 12120039634), filter 11427953129, drain 20 Nm, R134a 550 g. F8x offered a 7-DCT.
-- M2 F87 legitimately carries TWO engines (N55 base + S55 Competition) — left intact.

-- ---- DEDUP: M3 F80 generic S55B30 (235) rows duplicate the specific S55B30A (887) ----
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (1994,1995);
DELETE FROM fluid_specs WHERE id IN (1994,1995);  -- generic-235 engine_oil + coolant

-- ---- FLUIDS (to 8 each; gen-wide adds) ----
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (141,NULL,'differential_rear',1.00,NULL,'BMW limited-slip axle oil',NULL),(141,NULL,'transmission_dct',NULL,NULL,'BMW DCTF-1','7-speed M-DCT (where fitted)'),(141,NULL,'ac_refrigerant',NULL,NULL,'R134a','Charge 550 +/- 10 g'),(141,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.'),
  (213,NULL,'differential_rear',1.00,NULL,'BMW limited-slip axle oil',NULL),(213,NULL,'transmission_dct',NULL,NULL,'BMW DCTF-1','7-speed M-DCT (where fitted)'),(213,NULL,'ac_refrigerant',NULL,NULL,'R134a','Charge 550 +/- 10 g'),(213,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.'),
  (223,NULL,'differential_rear',1.00,NULL,'BMW limited-slip axle oil',NULL),(223,NULL,'transmission_dct',NULL,NULL,'BMW DCTF-1','7-speed M-DCT (where fitted)'),(223,NULL,'ac_refrigerant',NULL,NULL,'R134a','Charge 550 +/- 10 g'),(223,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.'),
  (224,NULL,'differential_rear',1.00,NULL,'BMW limited-slip axle oil',NULL),(224,NULL,'transmission_dct',NULL,NULL,'BMW DCTF-1','7-speed M-DCT (where fitted)'),(224,NULL,'ac_refrigerant',NULL,NULL,'R134a','Charge 550 +/- 10 g'),(224,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.');

-- ---- TYRES (M2 narrower than M3/M4) ----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (141,'front','standard',36.0,250,'255/35 ZR19'),(141,'rear','standard',39.0,270,'275/35 ZR19'),
  (223,'front','standard',36.0,250,'255/35 ZR19'),(223,'rear','standard',39.0,270,'275/35 ZR19'),
  (224,'front','standard',36.0,250,'255/35 ZR19'),(224,'rear','standard',39.0,270,'275/35 ZR19'),
  (213,'front','standard',36.0,250,'245/35 ZR19'),(213,'rear','standard',39.0,270,'265/35 ZR19');

-- ---- BULBS (F8x bi-xenon) ----
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory)
SELECT g, 'Low beam headlight','D1S',2,0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'High beam headlight','H7',2,0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Front turn signal','PY21W',2,0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Parking / DRL ring','H8',2,0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Reverse light','P21W',1,0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Licence plate light','C5W',2,0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x;

-- ---- FUSES (F3x platform) ----
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay)
SELECT g,'Passenger','20',20,'Engine management (DME)',0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Passenger','36',30,'Headlight washer pump',0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Passenger','54',20,'Cigarette lighter / 12V sockets',0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Passenger','11',8,'Climate control unit',0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Passenger','51',30,'Wiper module',0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Luggage','184',20,'Fuel pump control',0 FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x;

-- ---- SERVICE INTERVALS (BMW CBS) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes)
SELECT g,'Engine oil & filter',9300,15000,24,'Condition Based Service' FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Brake fluid',NULL,NULL,24,'Time-based' FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'In-cabin microfilter',18600,30000,24,NULL FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Spark plugs',37000,60000,48,NULL FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x
UNION ALL SELECT g,'Engine air filter',37000,60000,48,NULL FROM (SELECT 141 g UNION SELECT 213 UNION SELECT 223 UNION SELECT 224) x;

-- ---- PARTS (S55) ----
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (141,887,'spark_plug','12120039634','Bosch','ZR5TPP330; S55 3.0 I6'),(141,887,'oil_filter','11427953129','BMW','S55 element kit'),
  (213,887,'spark_plug','12120039634','Bosch','ZR5TPP330; S55 3.0 I6'),(213,887,'oil_filter','11427953129','BMW','S55 element kit'),
  (223,887,'spark_plug','12120039634','Bosch','ZR5TPP330; S55 3.0 I6'),(223,887,'oil_filter','11427953129','BMW','S55 element kit'),
  (224,887,'spark_plug','12120039634','Bosch','ZR5TPP330; S55 3.0 I6'),(224,887,'oil_filter','11427953129','BMW','S55 element kit');

-- ---- CITATIONS (per-gen source) ----
SET @s141=753; SET @s213=778; SET @s223=781; SET @s224=781;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, CASE generation_id WHEN 141 THEN @s141 WHEN 213 THEN @s213 WHEN 223 THEN @s223 ELSE @s224 END FROM fluid_specs WHERE generation_id IN (141,213,223,224);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, CASE generation_id WHEN 141 THEN @s141 WHEN 213 THEN @s213 WHEN 223 THEN @s223 ELSE @s224 END FROM tire_pressures WHERE generation_id IN (141,213,223,224);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, CASE generation_id WHEN 141 THEN @s141 WHEN 213 THEN @s213 WHEN 223 THEN @s223 ELSE @s224 END FROM bulbs WHERE generation_id IN (141,213,223,224);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, CASE generation_id WHEN 141 THEN @s141 WHEN 213 THEN @s213 WHEN 223 THEN @s223 ELSE @s224 END FROM fuses WHERE generation_id IN (141,213,223,224);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, CASE generation_id WHEN 141 THEN @s141 WHEN 213 THEN @s213 WHEN 223 THEN @s223 ELSE @s224 END FROM service_intervals WHERE generation_id IN (141,213,223,224);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, CASE generation_id WHEN 141 THEN @s141 WHEN 213 THEN @s213 WHEN 223 THEN @s223 ELSE @s224 END FROM parts WHERE generation_id IN (141,213,223,224);
