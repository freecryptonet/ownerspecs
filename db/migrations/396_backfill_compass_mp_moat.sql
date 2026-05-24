-- mig 396: backfill Jeep Compass MP (gen 337) moat. Fluids already present (8 rows, OM
-- source 873). Only engine wired is 2036 "2.4 Tigershark" (shared 4 gens, code EDD here vs
-- ED6 on Cherokee — divergent, so deferred to the engine-code pass). Adds electrical, bulbs,
-- fuses, torques, service intervals, parts, tires.
--
-- Sources: 873 = Compass MP OM (Mopar, public). NEW = workshop service specs (battery,
-- engine torques, spark-plug gap, tyre pressure+sizes — pressure is workshop-published).

SET @g  := 337;
SET @om := 873;
SET @e24 := 2036;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Jeep Compass (MP) workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data (battery, engine torques, spark-plug gap, cold tyre pressures + sizes). Vendor-neutral per house policy.');
SET @svc := (SELECT id FROM sources WHERE citation='Jeep Compass (MP) workshop service specifications' LIMIT 1);

-- 1. ELECTRICAL
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, NULL, 525, 72, 160);

-- 2. BULBS (OM p285; base trim, Premium = LED)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Low/high beam (LED)',          'LED',       2, 1),
  (@g, 'Front direction/position (base)','7442NA',  2, 0),
  (@g, 'Side marker',                  '2825',      2, 0),
  (@g, 'Front fog lamp (base)',        'H11LL',     2, 0),
  (@g, 'Tail/brake (base)',            'W21/5WLL',  2, 0),
  (@g, 'Turn indicator (base)',        'W21WLL',    2, 0),
  (@g, 'Center high-mount stop',       'LED',       1, 1),
  (@g, 'License plate',                'LED',       2, 1),
  (@g, 'DRL / front position (premium)','LED',      2, 1);

-- 3. FUSES (OM p275-277 PDC)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'Underhood PDC', 'F04', 30, 'Rear defroster (EBL)',              0),
  (@g, 'Underhood PDC', 'F06', 40, 'Trailer tow module',               0),
  (@g, 'Underhood PDC', 'F09', 30, 'Power feed',                       0),
  (@g, 'Underhood PDC', 'F11', 30, 'BCM feed 3 / run-start',           0),
  (@g, 'Underhood PDC', 'F12', 40, 'Brake System Module pump',         0),
  (@g, 'Underhood PDC', 'F13', 40, 'Brake System Module valves',       0),
  (@g, 'Underhood PDC', 'F15', 40, 'Starter motor solenoid',           0),
  (@g, 'Underhood PDC', 'F17', 40, 'HVAC fan',                         0),
  (@g, 'Underhood PDC', 'F20',  8, 'Engine Control Module',            0),
  (@g, 'Underhood PDC', 'F22',  8, 'A/C compressor',                   0),
  (@g, 'Underhood PDC', 'F25', 20, 'Left HID lamp',                    0),
  (@g, 'Underhood PDC', 'F27', 25, 'Engine Control Module / fuel',     0),
  (@g, 'Underhood PDC', 'F30', 20, 'Right HID lamp',                   0),
  (@g, 'Underhood PDC', 'F32', 20, 'Fuel injectors / ignition coils',  0);

-- 4. TORQUE
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel lug nut',                135, 100, 'OM p314: 100 ft-lb (135 N·m).'),
  (@g, @e24, 'Crankshaft pulley bolt',         50,  37, '2.4L Tigershark: stage 1 50 N·m, stage 2 +68°. Service data.'),
  (@g, @e24, 'Ancillary drive belt tensioner', 26,  19, '2.4L Tigershark, service data.');

-- 5. SERVICE INTERVALS
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, 'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; severe duty 4,000 mi.'),
  (@g, 'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval.'),
  (@g, 'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, 'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, 'spark_plugs',           NULL, NULL, NULL, NULL, NULL, 'OM: mileage-based per maintenance chart.'),
  (@g, 'coolant_flush',         150000, NULL, 240000, NULL, 120, 'OM: flush + replace coolant at 10 yr / 150,000 mi.'),
  (@g, 'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: 9-speed (948TE) ATF per severe-duty chart.');

-- 6. PARTS
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e24, 'spark_plug', 'Mopar (OE)', 'Mopar', 1.20, '2.4L Tigershark: gap 1.2 mm (service data); Mopar plug, OE PN not printed in OM.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (workshop-published; normal-load lower bound)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 35.0, 241, '215/65R16'),
  (@g, 'rear',  'normal', 32.0, 221, '215/65R16'),
  (@g, 'front', 'normal', 35.0, 241, '225/60R17'),
  (@g, 'rear',  'normal', 32.0, 221, '225/60R17');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @om  FROM torque_specs WHERE generation_id=@g AND engine_id IS NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g AND engine_id IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @svc FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @svc FROM tire_pressures WHERE generation_id=@g;
