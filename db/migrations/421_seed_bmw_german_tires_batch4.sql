-- mig 421: German tyre batch 4 (BMW X6 M F96, Z4 G29, 8-Coupe G15, M2 G87) from service-manual
-- fitment. Mapped by MODEL+BODY STYLE (BMW FSM groups platforms — first chassis code in titles
-- is unreliable: 8-coupe reads "G14", M2 reads "G42"). Cold pressure = low end of range. psi*6.895≈kPa.
-- Vendor-neutral workshop sources; aggregator never named.

-- X6 M (F96) gen 239 — staggered 295/35 R21 F / 315/35 R21 R @ 36
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW X6 M (F96)',1,0,NOW()); SET @s:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (239,'front','normal',36.0,248,'295/35 R21'),(239,'rear','normal',36.0,248,'315/35 R21');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@s FROM tire_pressures WHERE generation_id=239;

-- Z4 (G29) gen 246 — staggered 255/40 R18 F / 275/40 R18 R @ 32
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW Z4 (G29)',1,0,NOW()); SET @s:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (246,'front','normal',32.0,221,'255/40 R18'),(246,'rear','normal',32.0,221,'275/40 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@s FROM tire_pressures WHERE generation_id=246;

-- 8 Series Coupe (G15) gen 247 — reuse the 8-Series (G14/G15/G16) source; square 245/40 R19, 32F/35R
SET @s8:=(SELECT id FROM sources WHERE citation='Workshop service manual — BMW 8 Series (G14, G15, G16)');
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (247,'front','normal',32.0,221,'245/40 R19'),(247,'rear','normal',35.0,241,'245/40 R19');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@s8 FROM tire_pressures WHERE generation_id=247;

-- M2 (G87) gen 216 — staggered 275/35 R19 F / 285/30 R20 R @ 32
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW M2 (G87)',1,0,NOW()); SET @s:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (216,'front','normal',32.0,221,'275/35 R19'),(216,'rear','normal',32.0,221,'285/30 R20');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@s FROM tire_pressures WHERE generation_id=216;
