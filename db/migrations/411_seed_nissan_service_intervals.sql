-- mig 411: seed service_intervals for 6 thin Nissan gens from workshop "Service Item Intervals".
-- miles = round(km / 1.609). Engine oil + oil filter share the oil interval → engine_oil_and_filter.
-- Cited to each chassis's existing "Nissan <Model> (<code>) Service Manual" source. severe columns
-- left NULL (only the normal schedule was extracted). EVs (Leaf/Ariya) have only the items the
-- workshop schedule publishes (no oil/plugs).

-- ── Qashqai J12 (165) ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan Qashqai (J12) Service Manual');
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months) VALUES
  (165,'engine_oil_and_filter',9320,15000,12),
  (165,'engine_air_filter',9320,15000,12),
  (165,'cabin_air_filter',18640,30000,12),
  (165,'brake_fluid_flush',37280,60000,24),
  (165,'spark_plugs',18640,30000,24);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=165;

-- ── Juke F16 (162) ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan Juke (F16) Service Manual');
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months) VALUES
  (162,'engine_oil_and_filter',18640,30000,12),
  (162,'engine_air_filter',37280,60000,48),
  (162,'cabin_air_filter',18640,30000,12),
  (162,'brake_fluid_flush',37280,60000,24),
  (162,'spark_plugs',37280,60000,48);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=162;

-- ── X-Trail T33 (164) ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan X-Trail (T33) Service Manual');
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months) VALUES
  (164,'engine_oil_and_filter',9320,15000,12),
  (164,'engine_air_filter',27960,45000,36),
  (164,'cabin_air_filter',18640,30000,24),
  (164,'brake_fluid_flush',18640,30000,24),
  (164,'spark_plugs',46600,75000,60);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=164;

-- ── Leaf ZE1 (319) — EV ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan Leaf (ZE1) Service Manual');
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months) VALUES
  (319,'cabin_air_filter',18640,30000,12);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=319;

-- ── Ariya FE0 (163) — EV ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan Ariya (FE0) Service Manual');
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months) VALUES
  (163,'brake_fluid_flush',37280,60000,24),
  (163,'cabin_air_filter',18640,30000,12);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=163;

-- ── Micra K14 (320) ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan Micra (K14) Service Manual');
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months) VALUES
  (320,'engine_oil_and_filter',12430,20000,12),
  (320,'engine_air_filter',37280,60000,36),
  (320,'cabin_air_filter',12430,20000,12),
  (320,'brake_fluid_flush',24850,40000,24),
  (320,'spark_plugs',37280,60000,36);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id=320;
