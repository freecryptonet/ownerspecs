-- mig 416: German thin-gen tyre batch (BMW G26, G16, G11) from service-manual fitment data.
-- Standard fitment + cold pressure (low end of the placard range = normal). psi*6.895≈kPa.
-- Cited to new vendor-neutral "Workshop service manual — …" sources (underlying aggregator
-- never named). Lug torque on these chassis is 103 ft-lb ≈ 140 N·m (already in torque_specs).

-- ── BMW 4 Series Gran Coupe (G26) gen 227 — square 245/45 R18 @ 32 psi ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Workshop service manual — BMW 4 Series (G22, G26)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (227,'front','normal',32.0,221,'245/45 R18'),
  (227,'rear','normal',32.0,221,'245/45 R18');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=227;

-- ── BMW 8 Series Gran Coupe (G16) gen 249 — staggered 245/40 R19 F / 275/35 R19 R ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Workshop service manual — BMW 8 Series (G14, G15, G16)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (249,'front','normal',35.0,241,'245/40 R19'),
  (249,'rear','normal',39.0,269,'275/35 R19');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=249;

-- ── BMW 7 Series (G11) gen 204 — square 245/45 R19 @ 35 psi ──
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Workshop service manual — BMW 7 Series (G11, G12)',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (204,'front','normal',35.0,241,'245/45 R19'),
  (204,'rear','normal',35.0,241,'245/45 R19');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s FROM tire_pressures WHERE generation_id=204;
