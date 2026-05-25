-- mig 417: German tyre batch 2 (BMW M3/M4/M5 + 4-Series Convertible + 2-Series Gran Coupe)
-- from service-manual fitment data. Chassis confirmed from each manual's own section titles
-- (hardened discovery), so no cross-gen mis-mapping. Cold pressure = low end of placard range.
-- psi*6.895≈kPa. Each cited to a new vendor-neutral workshop source; aggregator never named.

-- ── BMW M3 (G80) gen 142 — staggered 275/40 R18 F / 285/35 R19 R @ 32 psi ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Workshop service manual — BMW M3 (G80)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (142,'front','normal',32.0,221,'275/40 R18'),
  (142,'rear','normal',32.0,221,'285/35 R19');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=142;

-- ── BMW M4 (G82) gen 228 — staggered 275/40 R18 F / 285/35 R19 R @ 32 psi ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Workshop service manual — BMW M4 (G82)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (228,'front','normal',32.0,221,'275/40 R18'),
  (228,'rear','normal',32.0,221,'285/35 R19');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=228;

-- ── BMW M5 (F90) gen 146 — staggered 275/40 R19 F / 285/40 R19 R @ 35 psi ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Workshop service manual — BMW M5 (F90)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (146,'front','normal',35.0,241,'275/40 R19'),
  (146,'rear','normal',35.0,241,'285/40 R19');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=146;

-- ── BMW 4 Series Convertible (G23) gen 226 — square 225/45 R18 @ 33 psi ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Workshop service manual — BMW 4 Series (G23)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (226,'front','normal',33.0,227,'225/45 R18'),
  (226,'rear','normal',33.0,227,'225/45 R18');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=226;

-- ── BMW 2 Series Gran Coupe (F44) gen 214 — square 225/45 R17 @ 36 psi ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Workshop service manual — BMW 2 Series Gran Coupe (F44)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (214,'front','normal',36.0,248,'225/45 R17'),
  (214,'rear','normal',36.0,248,'225/45 R17');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=214;
