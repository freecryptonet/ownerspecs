-- mig 408: seed Nissan Qashqai (J12, 2021-) torque_specs (gen 165) — non-German thin-content fill
--
-- Source: workshop service manual data for the J12 chassis (vendor-neutral citation per the
-- never-name-vendor rule; public_link=0). torque_ftlb = round(nm * 0.7376). notes NULL
-- (provenance via spec_sources linkage, not marker strings). Owner-critical fasteners use the
-- canonical keys (lug_nut/spark_plug/oil_drain/oil_filter/cv_axle_nut) so lib/labels renders
-- friendly labels; mechanic fasteners keep their workshop names (humanize() fallback).
-- gen 165 had 0 torque rows → moves it from moat-score 1 to 2.

INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('service_manual', 'Nissan Qashqai (J12) Service Manual', 1, 0, NOW());
SET @s := LAST_INSERT_ID();

INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (165, 'lug_nut',                       113, 83, NULL),
  (165, 'spark_plug',                     24, 18, NULL),
  (165, 'oil_drain',                      50, 37, NULL),
  (165, 'oil_filter',                     32, 24, NULL),
  (165, 'cv_axle_nut',                   255,188, NULL),
  (165, 'Alternator',                     25, 18, NULL),
  (165, 'Starter motor',                  44, 32, NULL),
  (165, 'Air-conditioning compressor',    25, 18, NULL),
  (165, 'Coolant pump',                   25, 18, NULL),
  (165, 'Oxygen sensor',                  44, 32, NULL),
  (165, 'Knock sensor',                   20, 15, NULL),
  (165, 'Ignition coil',                  10,  7, NULL),
  (165, 'Camshaft position sensor',       10,  7, NULL),
  (165, 'Ancillary drive belt tensioner', 25, 18, NULL),
  (165, 'Turbocharger',                   30, 22, NULL),
  (165, 'Inlet manifold',                 11,  8, NULL),
  (165, 'Fuel rail',                      10,  7, NULL),
  (165, 'Steering wheel bolt',            44, 32, NULL),
  (165, 'Front seat',                     40, 30, NULL);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @s FROM torque_specs WHERE generation_id = 165;
