-- mig 427: German tyres — Mercedes C-Class W203 / E-Class W211, Audi RS3 8Y, BMW 1-coupe E82.
-- Service-manual fitment, model+body mapped, asymmetric/staggered per axle. psi*6.895≈kPa.
-- (C207 E-coupe, Audi A3 8P, BMW 6-GT G32 had no Tire Fitment / not found — left unfilled.)

INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Mercedes-Benz C-Class (W203)',1,0,NOW()); SET @w203:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (302,'front','normal',28.0,193,'225/45 R17'),(302,'rear','normal',28.0,193,'225/45 R17');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@w203 FROM tire_pressures WHERE generation_id=302;

INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Mercedes-Benz E-Class (W211)',1,0,NOW()); SET @w211:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (307,'front','normal',28.0,193,'245/45 R17'),(307,'rear','normal',33.0,227,'245/45 R17');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@w211 FROM tire_pressures WHERE generation_id=307;

-- Audi RS3 (8Y) gen 272 — reuse A3 8Y source; reverse-staggered 265/30 R19 F / 245/35 R19 R @ 44
SET @a38y:=(SELECT id FROM sources WHERE citation='Workshop service manual — Audi A3 (8Y)');
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (272,'front','normal',44.0,303,'265/30 R19'),(272,'rear','normal',44.0,303,'245/35 R19');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@a38y FROM tire_pressures WHERE generation_id=272;

INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW 1 Series (E82)',1,0,NOW()); SET @e82:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (196,'front','normal',32.0,221,'205/50 R17'),(196,'rear','normal',35.0,241,'225/45 R17');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@e82 FROM tire_pressures WHERE generation_id=196;
