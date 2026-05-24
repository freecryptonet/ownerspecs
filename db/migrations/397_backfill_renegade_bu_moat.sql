-- mig 397: backfill Jeep Renegade BU (gen 338) moat. Fluids already present (10 rows,
-- OM source 874). Engines 2038 (GSE-T4 1.3T, code already correct) + 2036 (2.4 Tigershark,
-- shared/deferred). Adds electrical, bulbs, fuses, torques, service intervals, parts, tires.
--
-- Sources: 874 = Renegade OM (Mopar, public). NEW svc = workshop service specs (engine
-- torques, wheel-nut torque, spark-plug gap, tyre pressures+sizes). NEW bat = flagged
-- non-OEM battery-fitment reference (HaynesPro gives only battery location, no Ah/CCA).

SET @g  := 338;
SET @om := 874;
SET @e13 := 2038;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Jeep Renegade (BU) workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data (engine torques, wheel-nut torque, spark-plug gap, cold tyre pressures + sizes). Vendor-neutral per house policy.'),
  ('reference', 'Jeep Renegade (BU) battery fitment reference (aggregated)', NULL, 0, 1, NOW(),
   'Battery group/CCA/Ah. NOT OEM documentation: OM + workshop data give only battery location, so the fitment spec is from a third-party battery-fitment reference. Provenance flagged.');
SET @svc := (SELECT id FROM sources WHERE citation='Jeep Renegade (BU) workshop service specifications' LIMIT 1);
SET @bat := (SELECT id FROM sources WHERE citation='Jeep Renegade (BU) battery fitment reference (aggregated)' LIMIT 1);

-- 1. ELECTRICAL (flagged fitment reference)
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, 'H6 (AGM)', 760, 69, NULL);

-- 2. BULBS (OM p358)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Low/high beam (halogen)',     'H13',    2, 0),
  (@g, 'Low/high beam (LED version)', 'LED',    2, 1),
  (@g, 'Front position/DRL/turn',     'PSY24W', 2, 0),
  (@g, 'Front fog lamp',              'H11',    2, 0),
  (@g, 'Side indicator',              'WY5W',   2, 0),
  (@g, 'Tail/brake/turn',             'P21W',   2, 0),
  (@g, 'Tail/brake/turn (LED ver.)',  'LED',    2, 1),
  (@g, 'Center high-mount stop',      'LED',    1, 1),
  (@g, 'License plate',               'W5W',    2, 0);

-- 3. FUSES (OM p352-354)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'Underhood PDC', 'F01', 70, 'Body Computer Module',                0),
  (@g, 'Underhood PDC', 'F02', 70, 'Body Computer / rear distribution',   0),
  (@g, 'Underhood PDC', 'F03', 20, 'Controller power supply (BCM)',       0),
  (@g, 'Underhood PDC', 'F04', 30, 'Brake control electronics module',    0),
  (@g, 'Underhood PDC', 'F05', 70, 'Electric power-assisted steering',    0),
  (@g, 'Underhood PDC', 'F07', 50, 'Engine cooling fan (2.4L)',           0),
  (@g, 'Underhood PDC', 'F08', 30, 'Automatic transmission / GSM',        0),
  (@g, 'Underhood PDC', 'F10', 15, 'Horn',                                0),
  (@g, 'Underhood PDC', 'F15', 40, 'Brake control module pump',           0),
  (@g, 'Underhood PDC', 'F16',  5, 'Engine Control Module power',         0);

-- 4. TORQUE (wheel nut from service data; 1.3T engine torques)
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel nut',            120, 89, 'Service data: stage 2 120 N·m, criss-cross pattern.'),
  (@g, @e13, 'Engine oil drain plug',  27, 20, '1.3L GSE-T4, service data.'),
  (@g, @e13, 'Oxygen sensor',          41, 30, '1.3L GSE-T4, service data.'),
  (@g, @e13, 'Alternator bracket bolt', 50, 37, '1.3L GSE-T4, service data.');

-- 5. SERVICE INTERVALS
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, 'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; severe duty 4,000 mi.'),
  (@g, 'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval.'),
  (@g, 'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, 'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, 'spark_plugs',           NULL, NULL, NULL, NULL, NULL, 'OM: mileage-based per maintenance chart.'),
  (@g, 'coolant_flush',         150000, NULL, 240000, NULL, 120, 'OM: flush + replace coolant at 10 yr / 150,000 mi.'),
  (@g, 'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: ATF per severe-duty chart (9-spd / DDCT).');

-- 6. PARTS
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e13, 'spark_plug', 'Mopar (OE)', 'Mopar', 0.65, '1.3L GSE-T4: gap 0.65 mm (service data); Mopar plug, OE PN not printed in OM.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (workshop-published; front 2.4 bar / rear 2.2 bar normal)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 35.0, 240, '215/65R16'),
  (@g, 'rear',  'normal', 32.0, 220, '215/65R16'),
  (@g, 'front', 'normal', 35.0, 240, '225/55R18'),
  (@g, 'rear',  'normal', 32.0, 220, '225/55R18');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g AND part_type='oil_filter';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @svc FROM parts WHERE generation_id=@g AND part_type='spark_plug';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @bat FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @svc FROM tire_pressures WHERE generation_id=@g;
