-- 464: Moat fill for BMW M3 E90 (192) + E92 (193) + E93 (194). Engine S65B40A 4.0 V8 (1015)
-- + GTS/CRT S65B44A (1016) — both legit variants, kept. Verified on E90 M3 HaynesPro: rear
-- diff 1.1 L, tyres 245/40+265/40 R18, NGK LKR8AP (8 plugs, same as the S85 V10). Oil 8.8 /
-- coolant 11.4 already present. Battery present. Cite BMW 3 (E90-E93) SM (765).
SET @src = 765;

-- fill the GTS/CRT (S65B44A) coolant NULL
UPDATE fluid_specs SET capacity_l=11.40, capacity_qt=ROUND(11.40*1.05669,2)
  WHERE fluid_type='coolant' AND capacity_l IS NULL AND generation_id IN (192,193,194);

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes)
SELECT g,NULL,'differential_rear',1.10,NULL,'BMW limited-slip axle oil',NULL FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,NULL,'ac_refrigerant',NULL,NULL,'R134a','Charge per under-hood label' FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.' FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x;

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (192,'front','standard',33.0,230,'245/40 ZR18'),(192,'rear','standard',36.0,250,'265/40 ZR18'),
  (193,'front','standard',33.0,230,'245/40 ZR18'),(193,'rear','standard',36.0,250,'265/40 ZR18'),
  (194,'front','standard',33.0,230,'245/40 ZR18'),(194,'rear','standard',36.0,250,'265/40 ZR18');

INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory)
SELECT g,'Low beam headlight','D1S',2,0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'High beam headlight','H7',2,0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Front turn signal','PY21W',2,0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Parking / DRL ring','H8',2,0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Reverse light','P21W',1,0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Licence plate light','C5W',2,0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x;

INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay)
SELECT g,'Glovebox','4',10,'Engine control module (ECM)',0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Glovebox','11',20,'Engine management (injectors / sensors)',0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Glovebox','14',15,'Radio',0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Glovebox','70',20,'Fuel pump (EKPS)',0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Glovebox','77',10,'Climate / HVAC blower',0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Glovebox','79',30,'Wiper control',0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Glovebox','92',60,'Engine cooling fan',0 FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x;

INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes)
SELECT g,'Engine oil & filter',9300,15000,24,'Condition Based Service' FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Brake fluid',NULL,NULL,24,'Time-based' FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'In-cabin microfilter',18600,30000,24,NULL FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Spark plugs',37000,60000,48,'8 plugs' FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x
UNION ALL SELECT g,'Engine air filter',37000,60000,48,NULL FROM (SELECT 192 g UNION SELECT 193 UNION SELECT 194) x;

INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
  (192,1015,'spark_plug','LKR8AP','NGK','Set of 8; S65 4.0 V8'),(192,1015,'oil_filter','11427837997','BMW','S65 element'),
  (193,1015,'spark_plug','LKR8AP','NGK','Set of 8; S65 4.0 V8'),(193,1015,'oil_filter','11427837997','BMW','S65 element'),
  (194,1015,'spark_plug','LKR8AP','NGK','Set of 8; S65 4.0 V8'),(194,1015,'oil_filter','11427837997','BMW','S65 element');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',       id, @src FROM fluid_specs       WHERE generation_id IN (192,193,194);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',    id, @src FROM tire_pressures    WHERE generation_id IN (192,193,194);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',             id, @src FROM bulbs             WHERE generation_id IN (192,193,194);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',             id, @src FROM fuses             WHERE generation_id IN (192,193,194);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id IN (192,193,194);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',             id, @src FROM parts             WHERE generation_id IN (192,193,194);
