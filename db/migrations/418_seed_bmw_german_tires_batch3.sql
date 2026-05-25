-- mig 418: German tyre batch 3 (BMW 8-Series conv, M8 conv, X1, X4, X6, X4 M) from
-- service-manual fitment data. Chassis confirmed from FSM section titles + model body style
-- (avoids G22/G23/G26 ambiguity). Cold pressure = low end of placard range. psi*6.895≈kPa.
-- Vendor-neutral workshop sources; aggregator never named.

-- ── 8 Series Convertible (G14) gen 248 — reuse the G14/G15/G16 source from mig 416 ──
SET @s8 := (SELECT id FROM sources WHERE citation='Workshop service manual — BMW 8 Series (G14, G15, G16)');
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (248,'front','normal',32.0,221,'245/40 R19'),
  (248,'rear','normal',36.0,248,'245/40 R19');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s8 FROM tire_pressures WHERE generation_id=248;

-- ── M8 Convertible (F91) gen 251 — staggered 275/35 R20 F / 285/35 R20 R @ 32 ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at) VALUES ('service_manual','Workshop service manual — BMW M8 (F91, F92, F93)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (251,'front','normal',32.0,221,'275/35 R20'),
  (251,'rear','normal',32.0,221,'285/35 R20');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=251;

-- ── X1 (F48) gen 208 — square 225/50 R18 @ 33 ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at) VALUES ('service_manual','Workshop service manual — BMW X1 (F48)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (208,'front','normal',33.0,227,'225/50 R18'),
  (208,'rear','normal',33.0,227,'225/50 R18');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=208;

-- ── X4 (G02) gen 231 — square 245/50 R19 @ 35 ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at) VALUES ('service_manual','Workshop service manual — BMW X4 (G02)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (231,'front','normal',35.0,241,'245/50 R19'),
  (231,'rear','normal',35.0,241,'245/50 R19');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=231;

-- ── X6 (G06) gen 237 — square 275/45 R20 @ 32 ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at) VALUES ('service_manual','Workshop service manual — BMW X6 (G06)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (237,'front','normal',32.0,221,'275/45 R20'),
  (237,'rear','normal',32.0,221,'275/45 R20');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=237;

-- ── X4 M (F98) gen 233 — staggered 255/45 R20 F / 265/45 R20 R ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at) VALUES ('service_manual','Workshop service manual — BMW X4 M (F98)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (233,'front','normal',32.0,221,'255/45 R20'),
  (233,'rear','normal',35.0,241,'265/45 R20');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=233;
