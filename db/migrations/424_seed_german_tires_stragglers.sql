-- mig 424: German tyre stragglers — BMW 4-LCI (F32/F33/F36), 7-Series G70, Audi A3 8Y,
-- Mercedes C-Class W206, E-Class W214. Service-manual fitment, model+body mapped, asymmetric/
-- staggered captured per axle. psi*6.895≈kPa. Vendor-neutral sources; aggregator never named.

-- BMW 4-Series LCI (F32/F33/F36) — reuse existing 4-Series source; gens 218,220,222
SET @f4:=(SELECT id FROM sources WHERE citation='Workshop service manual — BMW 4 Series (F32, F33, F36)');
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (218,'front','normal',32.0,221,'225/45 R18'),(218,'rear','normal',35.0,241,'225/45 R18'),
  (220,'front','normal',32.0,221,'225/45 R18'),(220,'rear','normal',39.0,269,'225/45 R18'),
  (222,'front','normal',32.0,221,'225/45 R18'),(222,'rear','normal',38.0,262,'225/45 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@f4 FROM tire_pressures WHERE generation_id IN (218,220,222);

-- BMW 7-Series (G70) gen 205 — staggered 255/45 R20 / 285/40 R20 @ 32
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW 7 Series (G70)',1,0,NOW()); SET @g70:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (205,'front','normal',32.0,221,'255/45 R20'),(205,'rear','normal',32.0,221,'285/40 R20');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@g70 FROM tire_pressures WHERE generation_id=205;

-- Audi A3 (8Y) gen 271 — 225/45 R17, 41F/38R
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi A3 (8Y)',1,0,NOW()); SET @a3:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (271,'front','normal',41.0,283,'225/45 R17'),(271,'rear','normal',38.0,262,'225/45 R17');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@a3 FROM tire_pressures WHERE generation_id=271;

-- Mercedes C-Class (W206) gen 305 — staggered 225/45 R18 F / 245/40 R18 R
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Mercedes-Benz C-Class (W206)',1,0,NOW()); SET @w206:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (305,'front','normal',38.0,262,'225/45 R18'),(305,'rear','normal',44.0,303,'245/40 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@w206 FROM tire_pressures WHERE generation_id=305;

-- Mercedes E-Class (W214) gen 312 — 225/55 R18, 39F/42R
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Mercedes-Benz E-Class (W214)',1,0,NOW()); SET @w214:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (312,'front','normal',39.0,269,'225/55 R18'),(312,'rear','normal',42.0,290,'225/55 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@w214 FROM tire_pressures WHERE generation_id=312;
