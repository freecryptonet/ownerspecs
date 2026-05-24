-- mig 394: backfill Dodge Journey JC (gen 340) moat. Fluids already present (12 rows,
-- OM source 877). Engine 2039 already ED3 (shared row, fixed in mig 393); 138 Pentastar
-- (ERB on this gen) deferred to Pentastar split. Adds electrical, bulbs, fuses, torques,
-- service intervals, parts, tires.
--
-- Sources: 877 = Journey OM (Mopar, public). NEW = vendor-neutral workshop service specs.
--          NEW tire = flagged non-OEM placard aggregator (HaynesPro defers Journey PSI to placard).

SET @g  := 340;
SET @om := 877;
SET @e24 := 2039;
SET @e36 := 138;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Dodge Journey (JC) workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data (battery, engine torques, spark-plug gap). Vendor-neutral per house policy.'),
  ('reference', 'Dodge Journey (JC) tire & loading placard (aggregated reference)', NULL, 0, 1, NOW(),
   'Cold tire inflation pressures. NOT OEM documentation: OM and workshop data defer to the door placard; pressures from third-party tire-pressure aggregators. Provenance flagged.');
SET @svc := (SELECT id FROM sources WHERE citation='Dodge Journey (JC) workshop service specifications' LIMIT 1);
SET @tp  := (SELECT id FROM sources WHERE citation='Dodge Journey (JC) tire & loading placard (aggregated reference)' LIMIT 1);

-- 1. ELECTRICAL
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, NULL, 700, 66, 160);

-- 2. BULBS (OM p269)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Low beam headlamp',      '9006',        2, 0),
  (@g, 'High beam headlamp',     '9005',        2, 0),
  (@g, 'Front park/turn signal', '3757AK',      2, 0),
  (@g, 'Side marker',            '168',         2, 0),
  (@g, 'Front fog lamp',         'PSX24W/2504', 2, 0),
  (@g, 'Center high-mount stop', 'LED',         1, 1),
  (@g, 'License plate',          '168',         2, 0),
  (@g, 'Rear turn signal',       'WY21W/7440A', 2, 0),
  (@g, 'Back-up lamp',           'W21W/7440',   2, 0),
  (@g, 'Rear tail/stop/turn',    'P27/7W/3157', 2, 0),
  (@g, 'Rear tail (LED version)','LED',         2, 1);

-- 3. FUSES (OM p276-278)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'PDC', 'F107', 10, 'Rear camera',                    0),
  (@g, 'PDC', 'F108', 15, 'Instrument panel',               0),
  (@g, 'PDC', 'F109', 10, 'Climate control / HVAC',         0),
  (@g, 'PDC', 'F114', 20, 'Rear HVAC blower',               0),
  (@g, 'PDC', 'F115', 20, 'Rear wiper motor',               0),
  (@g, 'PDC', 'F116', 30, 'Rear defroster (EBL)',           0),
  (@g, 'PDC', 'F120', 10, 'All-wheel drive',                0),
  (@g, 'PDC', 'F121', 15, 'Wireless ignition node',         0),
  (@g, 'PDC', 'F122', 25, 'Driver door module',             0),
  (@g, 'PDC', 'F123', 25, 'Passenger door module',          0),
  (@g, 'PDC', 'F126', 25, 'Audio amplifier',                0),
  (@g, 'PDC', 'F127', 20, 'Trailer tow',                    0),
  (@g, 'PDC', 'F128', 15, 'Radio',                          0),
  (@g, 'PDC', 'F130', 15, 'Climate control / instrument panel', 0);

-- 4. TORQUE
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel lug nut',          135, 100, 'OM p361: 100 ft-lb (135 N·m).'),
  (@g, @e24, 'Crankshaft pulley bolt',  210, 155, '2.4L ED3, service data.'),
  (@g, @e24, 'Alternator bracket bolt',  61,  45, '2.4L ED3, service data.');

-- 5. SERVICE INTERVALS
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, NULL,  'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; severe duty 4,000 mi.'),
  (@g, NULL,  'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval.'),
  (@g, NULL,  'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, NULL,  'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, @e24, 'spark_plugs',            NULL, NULL, NULL, NULL, NULL, 'OM: mileage-based per maintenance chart (2.4L / 3.6L).'),
  (@g, NULL,  'coolant_flush',         150000, NULL, 240000, NULL, 120, 'OM: flush + replace coolant at 10 yr / 150,000 mi.'),
  (@g, NULL,  'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: change ATF and filter per severe-duty chart.');

-- 6. PARTS
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e24, 'spark_plug', 'Mopar (OE)', 'Mopar', 1.10, '2.4L ED3: gap 1.1 mm (service data); Mopar plug, OE PN not printed in OM.'),
  (@g, @e36, 'spark_plug', 'Mopar (OE)', 'Mopar', 1.10, '3.6L ERB: gap 1.1 mm; Mopar plug, OE PN not printed in OM.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (flagged aggregator)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 36.0, 248, '225/65R17'),
  (@g, 'rear',  'normal', 36.0, 248, '225/65R17'),
  (@g, 'front', 'normal', 36.0, 248, '225/55R19'),
  (@g, 'rear',  'normal', 36.0, 248, '225/55R19');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @om  FROM torque_specs WHERE generation_id=@g AND engine_id IS NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g AND engine_id IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @svc FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @tp FROM tire_pressures WHERE generation_id=@g;
