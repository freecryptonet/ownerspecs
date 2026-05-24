-- mig 399: backfill Jeep Grand Cherokee WK2 (gen 335) moat. Fluids already present (17
-- rows, OM source 871). Engines 166/167/168 (HEMI, codes already correct), 138 (Pentastar)
-- + 202 (EcoDiesel) shared/deferred. Adds electrical, bulbs, fuses, torques, service, parts, tires.
--
-- Sources: 871 = GC WK2 OM (Mopar, public). NEW svc = workshop service specs (battery,
-- engine torques, spark-plug gap). NEW tp = flagged non-OEM placard aggregator.

SET @g  := 335;
SET @om := 871;
SET @e36 := 138;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Jeep Grand Cherokee (WK2) workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data (battery, engine torques, spark-plug gap). Vendor-neutral per house policy.'),
  ('reference', 'Jeep Grand Cherokee (WK2) tire & loading placard (aggregated reference)', NULL, 0, 1, NOW(),
   'Cold tire inflation pressures. NOT OEM documentation: OM + workshop data defer to the door placard; from third-party tire-pressure aggregators. Provenance flagged.');
SET @svc := (SELECT id FROM sources WHERE citation='Jeep Grand Cherokee (WK2) workshop service specifications' LIMIT 1);
SET @tp  := (SELECT id FROM sources WHERE citation='Jeep Grand Cherokee (WK2) tire & loading placard (aggregated reference)' LIMIT 1);

-- 1. ELECTRICAL
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, NULL, 700, 75, 160);

-- 2. BULBS (OM p395-396)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Low beam headlamp (halogen)', 'H11',    2, 0),
  (@g, 'High beam headlamp',          'H9',     2, 0),
  (@g, 'Headlamp (HID)',              'D3S',    2, 0),
  (@g, 'Front fog lamp',              'H11',    2, 0),
  (@g, 'Front side marker',           'W5W',    2, 0),
  (@g, 'Glove compartment',           '194',    1, 0),
  (@g, 'Grab handle lamp',            'W5W',    2, 0),
  (@g, 'Overhead console',            'VT4976', 2, 0),
  (@g, 'Rear cargo lamp',             '214-2',  1, 0),
  (@g, 'Visor vanity',                'V26377', 2, 0),
  (@g, 'Underpanel courtesy',         '906',    2, 0);

-- 3. FUSES (OM p405-407 PDC)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'Underhood PDC', 'F11', 30, 'Trailer tow electric brake',        0),
  (@g, 'Underhood PDC', 'F12', 40, 'Body Controller #3 / power locks',  0),
  (@g, 'Underhood PDC', 'F13', 40, 'Blower motor front',                0),
  (@g, 'Underhood PDC', 'F14', 40, 'Body Controller #4 / exterior lighting', 0),
  (@g, 'Underhood PDC', 'F15', 40, 'Low-temperature radiator (engine)', 0),
  (@g, 'Underhood PDC', 'F17', 30, 'Headlamp washer',                   0),
  (@g, 'Underhood PDC', 'F20', 30, 'Passenger door module',             0),
  (@g, 'Underhood PDC', 'F22', 20, 'Engine Control Module',             0),
  (@g, 'Underhood PDC', 'F23', 30, 'Interior lights #1',                0),
  (@g, 'Underhood PDC', 'F24', 30, 'Driver door module',               0),
  (@g, 'Underhood PDC', 'F25', 30, 'Front wipers',                      0),
  (@g, 'Underhood PDC', 'F26', 30, 'Anti-lock brakes / stability control', 0),
  (@g, 'Underhood PDC', 'F30', 30, 'Trailer tow receptacle',            0);

-- 4. TORQUE (lug from OM; engine torques service data)
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel lug nut',          176, 130, 'OM p501: 130 ft-lb (176 N·m).'),
  (@g, @e36, 'Cylinder head bolt (final)', 45, 33, '3.6L Pentastar: staged 30 > 45 N·m > +90°; renew bolts. Service data.'),
  (@g, @e36, 'Valve/cam cover bolt',    12,  9, '3.6L Pentastar: 12 N·m, Mopar RTV sealant. Service data.');

-- 5. SERVICE INTERVALS
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, 'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; severe duty 4,000 mi.'),
  (@g, 'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval.'),
  (@g, 'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, 'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, 'spark_plugs',           NULL, NULL, NULL, NULL, NULL, 'OM: mileage-based per maintenance chart.'),
  (@g, 'coolant_flush',         150000, NULL, 240000, NULL, 120, 'OM: flush + replace coolant at 10 yr / 150,000 mi.'),
  (@g, 'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: 8-speed (8HP) ATF per severe-duty chart.');

-- 6. PARTS
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e36, 'spark_plug', 'Mopar (OE)', 'Mopar', 1.00, '3.6L Pentastar: gap ~1.0 mm (service data); Mopar plug, OE PN not printed in OM.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (flagged aggregator)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 33.0, 228, '265/60R18'),
  (@g, 'rear',  'normal', 33.0, 228, '265/60R18'),
  (@g, 'front', 'normal', 33.0, 228, '265/50R20'),
  (@g, 'rear',  'normal', 36.0, 248, '265/50R20');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g AND part_type='oil_filter';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @svc FROM parts WHERE generation_id=@g AND part_type='spark_plug';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @om  FROM torque_specs WHERE generation_id=@g AND engine_id IS NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g AND engine_id IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @svc FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @tp FROM tire_pressures WHERE generation_id=@g;
