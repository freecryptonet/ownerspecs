-- mig 466: Mercedes-Benz B-Class (W246) gen 317 — repair the broken maintenance
-- schedule, correct engine fuel-type mislabels, and fill the empty electrical +
-- tyre lanes.
--
-- Why: the live /maintenance-schedule page dumped all 22 service items at a single
-- bogus 50,000 km / 24-month milestone and every row cited only source 835
-- (HaynesPro, is_public=0) so the verification badge rendered "0 sources".
--
-- Sources:
--   835  HaynesPro WorkshopData — W246 service-item intervals, adjustment data
--        (battery Ah/CCA, alternator, wheel-bolt torque). is_public=0 -> internal only.
--   958  Mercedes-Benz Owner's Manual — ASSYST service system (public anchor).
--   959  Mercedes-Benz Service Information — maintenance & service-reset (public anchor).
--   NEW  Tyre-pressure placard reference, cross-checked across two independent
--        tyre-pressure databases (is_public=0, flagged provenance).

SET @gen := 317;

-- 1) Engine fuel-type corrections (fuel is intrinsic to the engine -> globally correct).
--    607.951 (K9K) = Renault 1.5 dCi diesel; 651.901/651.930 = OM651 diesel;
--    780.990 = B250e electric drive. All were mislabelled 'petrol'.
UPDATE engines SET fuel = 'diesel'   WHERE id IN (1993, 1994, 1995) AND fuel <> 'diesel';
UPDATE engines SET fuel = 'electric' WHERE id = 2011 AND fuel <> 'electric';

-- 2) Maintenance schedule — drop the corrupted flat rows + their citations, reseed.
DELETE ss FROM spec_sources ss
  JOIN service_intervals si ON ss.spec_table = 'service_intervals' AND ss.spec_id = si.id
 WHERE si.generation_id = @gen;
DELETE FROM service_intervals WHERE generation_id = @gen;

INSERT INTO service_intervals
  (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
  (@gen, NULL, 'engine_oil_and_filter', 15500,  25000,  12,  'ASSYST PLUS Service A; flexible system may call for it sooner under severe use'),
  (@gen, NULL, 'cabin_air_filter',      15500,  25000,  24,  'ASSYST PLUS Service B'),
  (@gen, NULL, 'engine_air_filter',     46500,  75000,  48,  NULL),
  (@gen, NULL, 'transmission_at_fluid', 62000,  100000, 60,  '7G-DCT (724.0); includes hydraulic filter'),
  (@gen, NULL, 'spark_plugs',           46500,  75000,  48,  'Petrol engines (M270) only'),
  (@gen, NULL, 'fuel_filter',           46500,  75000,  48,  'Diesel engines only'),
  (@gen, NULL, 'brake_fluid_flush',     NULL,   NULL,   24,  'Time-based, regardless of distance'),
  (@gen, NULL, 'coolant_flush',         NULL,   NULL,   120, 'Long-life antifreeze · approx. 200,000 km');

-- cite every service row: 835 (internal HaynesPro) + 958 + 959 (public anchors)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', si.id, s.id
  FROM service_intervals si
  CROSS JOIN (SELECT 835 AS id UNION SELECT 958 UNION SELECT 959) s
 WHERE si.generation_id = @gen;

-- 3) Electrical — battery + alternator from HaynesPro adjustment data.
--    Main battery: 60/70/80 Ah options (510/760/800 CCA EN) + 12 Ah auxiliary for
--    start/stop. Record the common 70 Ah / 760 CCA EFB fitment (group H6 / LN3).
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)
VALUES (@gen, 'H6 (LN3)', 760, 70, 150);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', es.id, s.id
  FROM electrical_specs es
  CROSS JOIN (SELECT 835 AS id UNION SELECT 958) s
 WHERE es.generation_id = @gen;

-- 4) Tyre pressures — HaynesPro defers cold pressure to the door-jamb placard, so
--    pull from a cross-checked placard reference (two independent tyre-pressure DBs
--    agreed; wheel-bolt torque 130 Nm matched HaynesPro exactly). Flagged provenance.
INSERT INTO sources (type, citation, public_link, retrieved_at, is_public, notes)
VALUES ('reference',
        'Tyre pressure data (door-jamb placard)',
        0, NOW(), 0,
        'Aggregated reference, NOT OEM workshop documentation. Cold pressures originate on the vehicle door-jamb placard; cross-checked across two independent tyre-pressure databases. Wheel-bolt torque (130 Nm) corroborated against HaynesPro.');
SET @src_tyre := LAST_INSERT_ID();

INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen, 'front', 'normal', 36.0, 250, '205/55 R16'),
  (@gen, 'rear',  'normal', 36.0, 250, '205/55 R16'),
  (@gen, 'front', 'normal', 36.0, 250, '225/45 R17'),
  (@gen, 'rear',  'normal', 32.0, 220, '225/45 R17'),
  (@gen, 'front', 'normal', 36.0, 250, '225/40 R18'),
  (@gen, 'rear',  'normal', 32.0, 220, '225/40 R18');

-- cite tyres: 958 (public OEM anchor) + flagged placard reference (internal)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', tp.id, s.id
  FROM tire_pressures tp
  CROSS JOIN (SELECT 958 AS id UNION SELECT @src_tyre) s
 WHERE tp.generation_id = @gen;
