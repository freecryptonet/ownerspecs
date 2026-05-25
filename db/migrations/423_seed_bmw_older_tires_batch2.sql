-- mig 423: older BMW tyre batch 2 (5-Series F10, 6-Series F06/F12/F13, M5 F10, M6, 7-Series F01)
-- from service-manual fitment (MY2015/2016). Mapped by model+body. Staggered M-cars; asymmetric
-- front/rear on the regular cars. psi*6.895≈kPa. Vendor-neutral sources (one per chassis family).

-- 5 Series (F10/F11) + M5 F10 — gens 173, 176
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW 5 Series (F10, F11)',1,0,NOW()); SET @f10:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (173,'front','normal',35.0,241,'245/45 R18'),(173,'rear','normal',39.0,269,'245/45 R18'),
  (176,'front','normal',31.0,214,'265/40 R19'),(176,'rear','normal',31.0,214,'295/35 R19');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@f10 FROM tire_pressures WHERE generation_id IN (173,176);

-- 6 Series (F06/F12/F13) + M6 — gens 257, 258, 259, 260, 261, 262
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW 6 Series (F06, F12, F13)',1,0,NOW()); SET @f06:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (257,'front','normal',32.0,221,'245/45 R18'),(257,'rear','normal',35.0,241,'245/45 R18'),
  (258,'front','normal',33.0,227,'245/45 R18'),(258,'rear','normal',38.0,262,'245/45 R18'),
  (259,'front','normal',33.0,227,'245/45 R18'),(259,'rear','normal',36.0,248,'245/45 R18'),
  (260,'front','normal',31.0,214,'265/40 R19'),(260,'rear','normal',31.0,214,'295/35 R19'),
  (261,'front','normal',31.0,214,'265/40 R19'),(261,'rear','normal',31.0,214,'295/35 R19'),
  (262,'front','normal',34.0,234,'265/35 R20'),(262,'rear','normal',34.0,234,'295/30 R20');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@f06 FROM tire_pressures WHERE generation_id IN (257,258,259,260,261,262);

-- 7 Series (F01/F02) — gen 202
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW 7 Series (F01, F02)',1,0,NOW()); SET @f01:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (202,'front','normal',32.0,221,'245/50 R18'),(202,'rear','normal',35.0,241,'245/50 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@f01 FROM tire_pressures WHERE generation_id=202;
