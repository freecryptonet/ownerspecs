-- mig 426: German fillable tyres — BMW 4-coupe G22, Audi A8 4H/Q3 8U/TT 8J/RS5 8T/S6 LCI C8.
-- Service-manual fitment, model+body mapped, asymmetric/staggered per axle. psi*6.895≈kPa.
-- Reuses existing chassis sources where present. (RS6 Avant + RS7 have NO Tire Fitment in this
-- source — left unfilled.)

-- BMW 4-Series Coupe (G22) gen 225 — reuse 4-Series source
SET @g22:=(SELECT id FROM sources WHERE citation='Workshop service manual — BMW 4 Series (G22, G26)');
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (225,'front','normal',33.0,227,'225/45 R18'),(225,'rear','normal',35.0,241,'225/45 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@g22 FROM tire_pressures WHERE generation_id=225;

-- Audi S6 LCI sedan (C8) gen 158 — reuse C8 source
SET @c8:=(SELECT id FROM sources WHERE citation='Workshop service manual — Audi A6/S6/RS6 (C8)');
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (158,'front','normal',44.0,303,'255/35 R21'),(158,'rear','normal',44.0,303,'255/35 R21');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@c8 FROM tire_pressures WHERE generation_id=158;

-- Audi RS5 (8T) gen 274 — reuse A5 8T source
SET @a58t:=(SELECT id FROM sources WHERE citation='Workshop service manual — Audi A5 (8T)');
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (274,'front','normal',44.0,303,'265/35 R19'),(274,'rear','normal',41.0,283,'265/35 R19');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@a58t FROM tire_pressures WHERE generation_id=274;

-- Audi A8 (4H) gen 288
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi A8 (4H)',1,0,NOW()); SET @a84h:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (288,'front','normal',36.0,248,'255/45 R19'),(288,'rear','normal',38.0,262,'255/45 R19');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@a84h FROM tire_pressures WHERE generation_id=288;

-- Audi Q3 (8U) gen 278
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi Q3 (8U)',1,0,NOW()); SET @q38u:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (278,'front','normal',33.0,227,'235/50 R18'),(278,'rear','normal',36.0,248,'235/50 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@q38u FROM tire_pressures WHERE generation_id=278;

-- Audi TT (8J) gen 298 — staggered pressure F34/R32
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi TT (8J)',1,0,NOW()); SET @tt8j:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (298,'front','normal',34.0,234,'245/40 R18'),(298,'rear','normal',32.0,221,'245/40 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@tt8j FROM tire_pressures WHERE generation_id=298;
