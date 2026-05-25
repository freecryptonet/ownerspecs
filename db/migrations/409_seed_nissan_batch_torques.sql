-- mig 409: seed torque_specs for 5 thin Nissan gens (Juke F16, X-Trail T33, Leaf ZE1,
-- Ariya FE0, Micra K14) — non-German thin-content fill, batch 1.
--
-- Data: workshop service-manual torques for each chassis (vendor-neutral citation, public_link=0).
-- torque_ftlb = round(nm * 0.7376). notes NULL (provenance via spec_sources). Owner-critical
-- fasteners use canonical keys (lug_nut/spark_plug/oil_drain/oil_filter/cv_axle_nut). Only values
-- actually published for each chassis are inserted — Juke F16 + X-Trail T33 do NOT publish a
-- wheel-nut torque in the workshop adjustment data, so lug_nut is omitted for those two rather
-- than guessed (flagged for a later owner's-manual extraction).

-- ---- Juke (F16) gen 162 ----
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Nissan Juke (F16) Service Manual',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (162,'spark_plug',24,18,NULL),
  (162,'oil_drain',50,37,NULL),
  (162,'oil_filter',25,18,NULL),
  (162,'cv_axle_nut',280,207,NULL),
  (162,'Manual transmission drain plug',24,18,NULL),
  (162,'Dual-clutch transmission drain plug',45,33,NULL),
  (162,'Steering wheel bolt',44,32,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s FROM torque_specs WHERE generation_id=162;

-- ---- X-Trail (T33) gen 164 ----
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Nissan X-Trail (T33) Service Manual',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (164,'oil_filter',18,13,NULL),
  (164,'cv_axle_nut',125,92,NULL),
  (164,'CVT overflow plug',10,7,NULL),
  (164,'Steering wheel bolt',44,32,NULL),
  (164,'Camshaft gearwheel',35,26,NULL),
  (164,'Oil pump gearwheel',25,18,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s FROM torque_specs WHERE generation_id=164;

-- ---- Leaf (ZE1) gen 319 — EV, minimal workshop torques ----
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Nissan Leaf (ZE1) Service Manual',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (319,'lug_nut',108,80,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s FROM torque_specs WHERE generation_id=319;

-- ---- Ariya (FE0) gen 163 — EV ----
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Nissan Ariya (FE0) Service Manual',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (163,'lug_nut',108,80,NULL),
  (163,'cv_axle_nut',125,92,NULL),
  (163,'Steering wheel bolt',44,32,NULL),
  (163,'Reduction gearbox drain plug',45,33,NULL),
  (163,'Reduction gearbox filler plug',4,3,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s FROM torque_specs WHERE generation_id=163;

-- ---- Micra (K14) gen 320 ----
INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual','Nissan Micra (K14) Service Manual',1,0,NOW());
SET @s := LAST_INSERT_ID();
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (320,'lug_nut',105,77,NULL),
  (320,'spark_plug',24,18,NULL),
  (320,'oil_drain',50,37,NULL),
  (320,'oil_filter',25,18,NULL),
  (320,'Glow plug',15,11,NULL),
  (320,'Manual transmission drain plug',25,18,NULL),
  (320,'Steering wheel bolt',44,32,NULL),
  (320,'Camshaft gearwheel',30,22,NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s FROM torque_specs WHERE generation_id=320;
