-- mig 419: Audi German tyre batch (S6/RS5/A5/A7/A8/Q3/Q8/RSQ8/TT) from service-manual
-- fitment data. Mapped by trim+year→gen (Audi FSM titles don't expose chassis codes).
-- Cold pressure = low end of placard range. psi*6.895≈kPa. Vendor-neutral sources; aggregator
-- never named. Each S/RS trim → its own gen (no cross-gen mirroring).

-- A6/S6/RS6 (C8) — gen 156 S6
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi A6/S6/RS6 (C8)',1,0,NOW()); SET @c8:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (156,'front','normal',44.0,303,'255/35 R21'),(156,'rear','normal',44.0,303,'255/35 R21');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@c8 FROM tire_pressures WHERE generation_id=156;

-- A5/S5/RS5 (F5) — gens 275 A5, 276 RS5
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi A5 (F5)',1,0,NOW()); SET @f5:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (275,'front','normal',35.0,241,'245/40 R18'),(275,'rear','normal',35.0,241,'245/40 R18'),
  (276,'front','normal',38.0,262,'265/35 R19'),(276,'rear','normal',38.0,262,'265/35 R19');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@f5 FROM tire_pressures WHERE generation_id IN (275,276);

-- Q8/SQ8/RSQ8 (4M) — gens 290 Q8, 291 RSQ8
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi Q8 (4M)',1,0,NOW()); SET @q8:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (290,'front','normal',35.0,241,'275/50 R20'),(290,'rear','normal',35.0,241,'275/50 R20'),
  (291,'front','normal',35.0,241,'295/40 R22'),(291,'rear','normal',35.0,241,'295/40 R22');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@q8 FROM tire_pressures WHERE generation_id IN (290,291);

-- A7 (4K) — gen 285
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi A7 (4K)',1,0,NOW()); SET @a7:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (285,'front','normal',36.0,248,'255/40 R20'),(285,'rear','normal',36.0,248,'255/40 R20');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@a7 FROM tire_pressures WHERE generation_id=285;

-- A8 (4N) — gen 289
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi A8 (4N)',1,0,NOW()); SET @a8:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (289,'front','normal',38.0,262,'255/45 R19'),(289,'rear','normal',38.0,262,'255/45 R19');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@a8 FROM tire_pressures WHERE generation_id=289;

-- Q3 (F3) — gen 280
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi Q3 (F3)',1,0,NOW()); SET @q3:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (280,'front','normal',38.0,262,'235/55 R18'),(280,'rear','normal',38.0,262,'235/55 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@q3 FROM tire_pressures WHERE generation_id=280;

-- TT (8S) — gen 300 (staggered pressure F33/R30)
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi TT (8S)',1,0,NOW()); SET @tt:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (300,'front','normal',33.0,227,'245/40 R18'),(300,'rear','normal',30.0,207,'245/40 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@tt FROM tire_pressures WHERE generation_id=300;
