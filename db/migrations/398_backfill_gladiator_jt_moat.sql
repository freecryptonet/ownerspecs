-- mig 398: backfill Jeep Gladiator JT (gen 334) moat. Fluids already present (12 rows,
-- OM source 870). Engines 202 (3.0 EcoDiesel = EXJ, shared 2 gens -> deferred to EcoDiesel
-- code pass) + 138 (Pentastar = ERC here, shared catch-all -> deferred). Adds electrical,
-- bulbs, fuses, torques, service intervals, parts, tires.
--
-- Sources: 870 = Gladiator OM (Mopar, public). NEW svc = workshop service specs (battery,
-- wheel-nut + axle torques). NEW tp = flagged non-OEM placard aggregator (PSI placard-deferred).

SET @g  := 334;
SET @om := 870;
SET @e36 := 138;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Jeep Gladiator (JT) workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data (battery, wheel-nut + axle torques). Vendor-neutral per house policy.'),
  ('reference', 'Jeep Gladiator (JT) tire & loading placard (aggregated reference)', NULL, 0, 1, NOW(),
   'Cold tire inflation pressures. NOT OEM documentation: OM + workshop data defer to the door placard; from third-party tire-pressure aggregators. Provenance flagged.');
SET @svc := (SELECT id FROM sources WHERE citation='Jeep Gladiator (JT) workshop service specifications' LIMIT 1);
SET @tp  := (SELECT id FROM sources WHERE citation='Jeep Gladiator (JT) tire & loading placard (aggregated reference)' LIMIT 1);

-- 1. ELECTRICAL
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, NULL, 700, 80, 240);

-- 2. BULBS (OM p332)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Headlamp (halogen)',          'H13',     2, 0),
  (@g, 'Headlamp (premium)',          'LED',     2, 1),
  (@g, 'Sport front park/turn',       '7442NALL',2, 0),
  (@g, 'Base turn lamp',              '7440NA',  2, 0),
  (@g, 'Base park/DRL lamp',          '7443',    2, 0),
  (@g, 'Front fog (base)',            'PSX24W',  2, 0),
  (@g, 'Rear stop/tail/turn (base)',  '3157',    2, 0),
  (@g, 'Rear backup (base)',          '7440',    2, 0),
  (@g, 'Soundbar dome lamp',          '912',     1, 0),
  (@g, 'Center high-mount stop',      'LED',     1, 1),
  (@g, 'License plate',               'LED',     2, 1);

-- 3. FUSES (OM p326-328 PDC)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'Underhood PDC', 'F02', 40, 'Starter',                          0),
  (@g, 'Underhood PDC', 'F03',  5, 'Intelligent Battery Sensor (IBS)', 0),
  (@g, 'Underhood PDC', 'F04', 20, 'Fuel pump / FPCM',                 0),
  (@g, 'Underhood PDC', 'F05',  5, 'Security gateway',                 0),
  (@g, 'Underhood PDC', 'F08', 15, 'Transmission Control Module (8HP)',0),
  (@g, 'Underhood PDC', 'F10', 15, 'Key Ignition Node / RF Hub',       0),
  (@g, 'Underhood PDC', 'F12', 25, 'HiFi amplifier',                   0),
  (@g, 'Underhood PDC', 'F18', 10, 'A/C compressor clutch',            0),
  (@g, 'Underhood PDC', 'F20', 30, 'Central Body Controller - interior lights', 0),
  (@g, 'Underhood PDC', 'F22', 10, 'Engine Control Module / PCM',      0),
  (@g, 'Underhood PDC', 'F26', 40, 'CBC exterior lights #1',           0),
  (@g, 'Underhood PDC', 'F27', 30, 'Front wipers',                     0),
  (@g, 'Underhood PDC', 'F28', 40, 'CBC power locks',                  0),
  (@g, 'Underhood PDC', 'F29', 40, 'CBC exterior lights #2',           0);

-- 4. TORQUE (service data)
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL, 'Wheel nut',                       176, 130, 'Service data: stage 2 176 N·m, criss-cross.'),
  (@g, NULL, 'Front differential filler plug',   34,  25, 'Axle 210FBI, service data.'),
  (@g, NULL, 'Front differential drain plug',    34,  25, 'Axle 210FBI, service data.');

-- 5. SERVICE INTERVALS
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, 'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; severe duty 4,000 mi.'),
  (@g, 'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval.'),
  (@g, 'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, 'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, 'spark_plugs',           NULL, NULL, NULL, NULL, NULL, 'OM: 3.6L plugs mileage-based per maintenance chart.'),
  (@g, 'coolant_flush',         150000, NULL, 240000, NULL, 120, 'OM: flush + replace coolant at 10 yr / 150,000 mi.'),
  (@g, 'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: 8-speed (8HP) ATF per severe-duty chart.');

-- 6. PARTS
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e36, 'spark_plug', 'Mopar (OE)', 'Mopar', NULL, '3.6L Pentastar: Mopar plug; gap/PN not printed in OM.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (flagged aggregator)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 36.0, 248, '245/75R17'),
  (@g, 'rear',  'normal', 36.0, 248, '245/75R17'),
  (@g, 'front', 'normal', 36.0, 248, '255/70R18'),
  (@g, 'rear',  'normal', 36.0, 248, '255/70R18');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @svc FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @tp FROM tire_pressures WHERE generation_id=@g;
