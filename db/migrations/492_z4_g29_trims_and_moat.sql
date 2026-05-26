-- 492: BMW Z4 G29 (gen 246) — add trims + engine oil + service; fix bad rows
--
-- The Z4 G29 (petrol roadster, 2019+) had 0 trims and no engine_oil — a clear gap.
-- Engines already in DB: B48B20B (id 12) for sDrive20i/30i; B58B30C (id 81) for M40i.
-- All G29 are 8-speed auto (ZF 8HP / Steptronic, transmission id 5) — RWD ("sDrive").
-- Oil values cross-checked against our own verified G20 rows for the same engines
-- (B48 5.2 L 0W-20 LL-17 FE+; B58 6.5 L 0W-30) and corroborated by BMW press/TIS.
-- Trim perf is catalog data (hp/torque/0-100/top speed), not citation-gated.
-- Coolant capacity, exact tyre pressures, fuses, and an OEM bulb list could NOT be
-- verified (BMW OM is CBS/placard-deferred) and are left as-is / unfilled.

-- 1) Trims (idempotent on slug)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, drive_wheel)
SELECT * FROM (SELECT
  246, 'sdrive20i-197-hp-automatic', 'sDrive20i (197 Hp) Automatic', 12, 5, 2019, 197, 320, 6.6, 240, 'RWD') v
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=246 AND slug='sdrive20i-197-hp-automatic');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, drive_wheel)
SELECT * FROM (SELECT
  246, 'sdrive30i-258-hp-automatic', 'sDrive30i (258 Hp) Automatic', 12, 5, 2019, 258, 400, 5.4, 250, 'RWD') v
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=246 AND slug='sdrive30i-258-hp-automatic');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, zero_100_kmh_s, top_speed_kmh, drive_wheel)
SELECT * FROM (SELECT
  246, 'm40i-340-hp-automatic', 'M40i (340 Hp) Automatic', 81, 5, 2019, 340, 500, 4.5, 250, 'RWD') v
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=246 AND slug='m40i-340-hp-automatic');

-- 2) Engine oil (cross-checked vs G20 same-engine rows)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months)
SELECT 246, 12, 'engine_oil', 5.20, 5.50, '0W-20', 'BMW Longlife-17 FE+', '11428583898', NULL, NULL, 12
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM fluid_specs WHERE generation_id=246 AND engine_id=12 AND fluid_type='engine_oil') z);
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_mi, drain_interval_km, drain_interval_months)
SELECT 246, 81, 'engine_oil', 6.50, 6.90, '0W-30', 'BMW Longlife-17 FE+', '11428575211', NULL, NULL, 12
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM fluid_specs WHERE generation_id=246 AND engine_id=81 AND fluid_type='engine_oil') z);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', fs.id, 603 FROM fluid_specs fs
WHERE fs.generation_id=246 AND fs.fluid_type='engine_oil' AND fs.engine_id IN (12,81);

-- 3) Service intervals (BMW Condition Based Service)
SET @bmw_mb = (SELECT id FROM sources WHERE citation='BMW Maintenance Booklet (MY2025)' LIMIT 1);
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes)
SELECT g, s, mi, km, mo, nt FROM (SELECT 246 g) gens CROSS JOIN (
  SELECT 'engine_oil_and_filter' s, NULL mi, NULL km, 12 mo, 'Condition Based Service (CBS) — oil-service display governs timing; annual recommended. BMW Longlife oil.' nt
  UNION ALL SELECT 'brake_fluid_flush', NULL, NULL, 24, 'Date-based: every 2 years (CBS brake-fluid indicator).'
  UNION ALL SELECT 'spark_plugs', 60000, 96000, NULL, 'BMW B48/B58 turbo petrol — ~60k mi.'
) r WHERE NOT EXISTS (SELECT 1 FROM service_intervals si WHERE si.generation_id=gens.g AND si.service=r.s);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', si.id, @bmw_mb FROM service_intervals si
WHERE si.generation_id=246 AND @bmw_mb IS NOT NULL;

-- 4) Fix bad scraped rows
DELETE FROM fluid_specs WHERE id=5903 AND fluid_type='transmission_mt'; -- Z4 G29 is auto-only; no manual
UPDATE fluid_specs SET spec_standard='BMW Genuine Antifreeze/Coolant (G48-type), 50/50'
WHERE generation_id=246 AND fluid_type='coolant' AND spec_standard LIKE '%De-ionised%';
