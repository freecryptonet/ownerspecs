-- mig 420: Mercedes-Benz German tyre batch (C-Class W205, AMG C63 W205, E-Class W213,
-- E-Coupe C238, A-Class W177) from service-manual fitment data. Chassis verified from the FSM
-- "NNN Chassis" section title. MB lists asymmetric front/rear cold pressures — captured per axle.
-- psi*6.895≈kPa. Vendor-neutral workshop sources; aggregator never named.

-- C-Class / AMG C63 (W205) — gens 304 (C300), 306 (C63)
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Mercedes-Benz C-Class (W205)',1,0,NOW()); SET @w205:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (304,'front','normal',39.0,269,'225/45 R18'),(304,'rear','normal',45.0,310,'225/45 R18'),
  (306,'front','normal',48.0,331,'245/35 R19'),(306,'rear','normal',45.0,310,'265/35 R19');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@w205 FROM tire_pressures WHERE generation_id IN (304,306);

-- E-Class Sedan (W213) — gen 310
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Mercedes-Benz E-Class (W213)',1,0,NOW()); SET @w213:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (310,'front','normal',33.0,227,'245/45 R18'),(310,'rear','normal',38.0,262,'245/45 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@w213 FROM tire_pressures WHERE generation_id=310;

-- E-Class Coupe (C238) — gen 311
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Mercedes-Benz E-Class Coupe (C238)',1,0,NOW()); SET @c238:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (311,'front','normal',36.0,248,'245/45 R18'),(311,'rear','normal',39.0,269,'245/45 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@c238 FROM tire_pressures WHERE generation_id=311;

-- A-Class (W177) — gen 315
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Mercedes-Benz A-Class (W177)',1,0,NOW()); SET @w177:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (315,'front','normal',39.0,269,'205/55 R17'),(315,'rear','normal',39.0,269,'205/55 R17');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@w177 FROM tire_pressures WHERE generation_id=315;
