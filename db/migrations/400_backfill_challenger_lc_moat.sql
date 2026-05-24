-- mig 400: backfill Dodge Challenger LC (gen 332) moat. Fluids already present (16 rows,
-- OM source 868). HaynesPro has NO Challenger, so OM-gap fields (battery, tyre PSI, engine
-- torques) come from a flagged non-OEM aggregated reference, clearly marked.
--
-- Engines 166/167/168 (HEMI, codes already correct), 138 (Pentastar, shared/deferred).
--
-- Sources: 868 = Challenger LC OM (Mopar, public) — bulbs, fuses, lug torque, maintenance,
-- oil filter. NEW agg = aggregated non-OEM reference (battery, tyre pressure, HEMI service
-- torques) — provenance flagged per house policy.

SET @g  := 332;
SET @om := 868;
SET @e57 := 166;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('reference', 'Dodge Challenger (LC) aggregated service reference (non-OEM)', NULL, 0, 1, NOW(),
   'Battery group/CCA, cold tyre placard pressures, and general HEMI service torques. NOT OEM documentation: HaynesPro has no Challenger and the OM defers these to the placard / does not print them. Compiled from third-party battery-fitment + tire-pressure references. Provenance flagged.');
SET @agg := (SELECT id FROM sources WHERE citation='Dodge Challenger (LC) aggregated service reference (non-OEM)' LIMIT 1);

-- 1. ELECTRICAL (flagged)
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, 'H7 / 94R (AGM)', 730, 80, 160);

-- 2. BULBS (OM p470-471)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Headlamp (HID)',          'D3S',     2, 0),
  (@g, 'Headlamp (halogen)',      'HIR2LL',  2, 0),
  (@g, 'Front fog lamp',          'H11LL',   2, 0),
  (@g, 'Front park/turn',         'LED',     2, 1),
  (@g, 'Front side marker',       'LED',     2, 1),
  (@g, 'Tail lamp',               'LED',     2, 1),
  (@g, 'Stop/turn',               'LED',     2, 1),
  (@g, 'Back-up lamp',            'LED',     2, 1),
  (@g, 'Center high-mount stop',  'LED',     1, 1),
  (@g, 'License plate',           'LED',     2, 1),
  (@g, 'Rear courtesy/reading',   'W5W',     2, 0),
  (@g, 'Trunk lamp',              '562',     1, 0),
  (@g, 'Overhead console',        '578',     2, 0),
  (@g, 'Visor vanity',            'A6220',   2, 0),
  (@g, 'Glove box',               '194',     1, 0);

-- 3. FUSES (OM p460-468 front + rear PDC)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'Front PDC', 'F03', 50, 'Electric power steering #1 / radiator fan', 0),
  (@g, 'Front PDC', 'F04', 30, 'Starter',                       0),
  (@g, 'Front PDC', 'F05', 40, 'Anti-lock brake',               0),
  (@g, 'Front PDC', 'F11', 20, 'Horns',                         0),
  (@g, 'Front PDC', 'F12', 10, 'Air conditioning clutch',       0),
  (@g, 'Front PDC', 'F15', 20, 'Left HID',                      0),
  (@g, 'Front PDC', 'F16', 20, 'Right HID',                     0),
  (@g, 'Front PDC', 'F18', 50, 'Radiator fan',                  0),
  (@g, 'Front PDC', 'F20', 30, 'Wiper motor',                   0),
  (@g, 'Rear PDC',  'R02', 60, 'Front PDC feed #1',             0),
  (@g, 'Rear PDC',  'R06', 40, 'Exterior lighting #1',          0),
  (@g, 'Rear PDC',  'R08', 30, 'Interior lighting',             0),
  (@g, 'Rear PDC',  'R09', 40, 'Power locks',                   0),
  (@g, 'Rear PDC',  'R15', 40, 'HVAC blower',                   0),
  (@g, 'Rear PDC',  'R21', 30, 'Fuel pump',                     0);

-- 4. TORQUE (lug from OM; HEMI service torques flagged)
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel lug nut',        176, 130, 'OM p403: 130 ft-lb (176 N·m). M14x1.5, 22 mm.'),
  (@g, @e57, 'Spark plug (HEMI)',      18,  13, 'General HEMI tapered-seat spark-plug torque ~18 N·m — aggregated reference, NOT OEM documentation.'),
  (@g, NULL,  'Engine oil drain plug', 28,  21, 'General M14 drain-plug torque ~28 N·m — aggregated reference, NOT OEM documentation.');

-- 5. SERVICE INTERVALS (OM)
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, 'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; max 10,000 mi/12 mo; severe 4,000 mi.'),
  (@g, 'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval.'),
  (@g, 'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, 'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, 'spark_plugs',           NULL, NULL, NULL, NULL, NULL, 'OM: mileage-based per maintenance chart.'),
  (@g, 'coolant_flush',         150000, NULL, 240000, NULL, 120, 'OM: Mopar OAT 10 yr / 150,000 mi.'),
  (@g, 'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: ZF 8-speed ATF per severe-duty chart.');

-- 6. PARTS
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e57, 'spark_plug', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Spark Plugs; gap/PN not printed in this OM.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (flagged aggregator)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 32.0, 220, '235/55R18'),
  (@g, 'rear',  'normal', 32.0, 220, '235/55R18'),
  (@g, 'front', 'normal', 32.0, 220, '245/45R20'),
  (@g, 'rear',  'normal', 32.0, 220, '245/45R20');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @om  FROM torque_specs WHERE generation_id=@g AND engine_id IS NULL AND fastener LIKE 'Wheel%';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @agg FROM torque_specs WHERE generation_id=@g AND (engine_id IS NOT NULL OR fastener LIKE '%drain%');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @agg FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @agg FROM tire_pressures WHERE generation_id=@g;
