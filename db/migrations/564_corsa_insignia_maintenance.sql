-- 564: Service intervals for Opel Corsa F (518) and Insignia B (520), restated
-- from workshop service-item-interval data. km_normal is exact; miles_normal is
-- the rounded conversion that drives the by-mileage matrix; months as published.
-- Items that differ petrol vs diesel are scoped to a representative engine of that
-- fuel with a notes label; items common to all engines are gen-wide. Sources 1682/1683.

-- ───────────────────────── Corsa F (518) ──────────────────────────────────
-- gen-wide (same across all engines)
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) VALUES
  (518, 'brake_fluid_flush', NULL, NULL, 24, NULL),
  (518, 'coolant_flush', 180000, 112000, 120, NULL);
-- petrol 1.2 PureTech (rep engine 2198)
INSERT INTO service_intervals (generation_id, engine_id, service, km_normal, miles_normal, months, notes) VALUES
  (518, 2198, 'engine_oil_and_filter', 20000, 12000, 12, 'Petrol 1.2 PureTech'),
  (518, 2198, 'engine_air_filter', 40000, 25000, 48, 'Petrol 1.2 PureTech'),
  (518, 2198, 'cabin_air_filter', 20000, 12000, 12, 'Petrol 1.2 PureTech'),
  (518, 2198, 'spark_plugs', 40000, 25000, 48, 'Petrol 1.2 PureTech'),
  (518, 2198, 'timing_belt_replacement', 100000, 62000, 72, 'Petrol: first change 100,000 km / 72 months, then every 200,000 km'),
  (518, 2198, 'drive_belt_replacement', 100000, 62000, 72, 'Petrol 1.2 PureTech');
-- 1.5 diesel (engine 2197)
INSERT INTO service_intervals (generation_id, engine_id, service, km_normal, miles_normal, months, notes) VALUES
  (518, 2197, 'engine_oil_and_filter', 30000, 19000, 12, '1.5 diesel'),
  (518, 2197, 'engine_air_filter', 60000, 37000, 48, '1.5 diesel'),
  (518, 2197, 'cabin_air_filter', 30000, 19000, 12, '1.5 diesel'),
  (518, 2197, 'fuel_filter', 60000, 37000, 48, '1.5 diesel'),
  (518, 2197, 'timing_belt_replacement', 180000, 112000, 120, '1.5 diesel'),
  (518, 2197, 'drive_belt_replacement', 120000, 75000, 72, '1.5 diesel');

-- ───────────────────────── Insignia B (520) ───────────────────────────────
-- gen-wide (same across all engines)
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes) VALUES
  (520, 'engine_oil_and_filter', NULL, NULL, 24, 'Variable — determined by the oil-service (flexible service) indicator; 2-year maximum'),
  (520, 'brake_fluid_flush', NULL, NULL, 24, NULL),
  (520, 'coolant_flush', 240000, 149000, 60, NULL),
  (520, 'engine_air_filter', 60000, 37000, 48, NULL),
  (520, 'cabin_air_filter', 60000, 37000, 24, NULL),
  (520, 'drive_belt_replacement', 150000, 93000, 72, NULL);
-- 2.0 petrol (engine 2207)
INSERT INTO service_intervals (generation_id, engine_id, service, km_normal, miles_normal, months, notes) VALUES
  (520, 2207, 'spark_plugs', 60000, 37000, 48, '2.0 petrol');
-- 2.0 diesel (rep engine 2208)
INSERT INTO service_intervals (generation_id, engine_id, service, km_normal, miles_normal, months, notes) VALUES
  (520, 2208, 'fuel_filter', 60000, 37000, 24, '2.0 diesel'),
  (520, 2208, 'timing_belt_replacement', 120000, 75000, 72, '2.0 diesel');

-- citations
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, 1682 FROM service_intervals WHERE generation_id = 518;
INSERT INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, 1683 FROM service_intervals WHERE generation_id = 520;
