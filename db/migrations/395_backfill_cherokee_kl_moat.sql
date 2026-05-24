-- mig 395: backfill Jeep Cherokee KL (gen 336) moat + correct 3.2 engine code.
-- Fluids already present (12 rows, OM source 872). Adds electrical, bulbs, fuses,
-- torques, service intervals, parts, tires.
--
-- Engine codes: 2037 "3.2 Pentastar" -> EHK (Cherokee-only; HaynesPro: EHB 2014-15 / EHK
-- 2016-22, EHK covers most of the run). slug frozen. 2036 "2.4 Tigershark" shared across
-- 4 gens (ED6/EDD/ED8 variants) and 187 GME-T4 -> left for the dedicated engine-code pass.
--
-- Sources: 872 = Cherokee KL OM (Mopar, public). NEW svc = workshop service specs.
--          NEW tp = flagged non-OEM placard aggregator (HaynesPro defers Cherokee PSI).

SET @g  := 336;
SET @om := 872;
SET @e24 := 2036;
SET @e32 := 2037;

UPDATE engines SET code='EHK', display_name='Chrysler 3.2L Pentastar V6 (EHB 2014-15 / EHK 2016+)' WHERE id=@e32;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Jeep Cherokee (KL) workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data (battery, engine torques, spark-plug gap). Vendor-neutral per house policy.'),
  ('reference', 'Jeep Cherokee (KL) tire & loading placard (aggregated reference)', NULL, 0, 1, NOW(),
   'Cold tire inflation pressures. NOT OEM documentation: OM + workshop data defer to the door placard; from third-party tire-pressure aggregators. Provenance flagged.');
SET @svc := (SELECT id FROM sources WHERE citation='Jeep Cherokee (KL) workshop service specifications' LIMIT 1);
SET @tp  := (SELECT id FROM sources WHERE citation='Jeep Cherokee (KL) tire & loading placard (aggregated reference)' LIMIT 1);

-- 1. ELECTRICAL
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, NULL, 525, 60, 160);

-- 2. BULBS (OM p210; KL is largely LED, serviced at dealer)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Back-up lamp',           'W21W', 2, 0),
  (@g, 'Front turn signal',      'LED',  2, 1),
  (@g, 'Front fog lamp',         'LED',  2, 1),
  (@g, 'Rear tail/stop',         'LED',  2, 1),
  (@g, 'Rear turn signal',       'LED',  2, 1),
  (@g, 'Center high-mount stop', 'LED',  1, 1),
  (@g, 'License plate',          'LED',  2, 1);

-- 3. FUSES (OM p213-215 underhood PDC)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'Underhood PDC', 'F07', 15, 'Powertrain Control Module',          0),
  (@g, 'Underhood PDC', 'F08', 25, 'Fuel injectors / ECM',               0),
  (@g, 'Underhood PDC', 'F10', 20, 'Power Transfer Unit (PTU)',          0),
  (@g, 'Underhood PDC', 'F13', 10, 'Voltage Stability Module / PCM',     0),
  (@g, 'Underhood PDC', 'F14', 10, 'Brake System Module / back-up lamp', 0),
  (@g, 'Underhood PDC', 'F16', 20, 'Ignition coils',                     0),
  (@g, 'Underhood PDC', 'F17', 30, 'Brake vacuum pump (GME-T4 / V6)',    0),
  (@g, 'Underhood PDC', 'F19', 40, 'Starter solenoid',                   1),
  (@g, 'Underhood PDC', 'F20', 10, 'A/C compressor clutch',              0),
  (@g, 'Underhood PDC', 'F23', 50, 'Voltage Stability Module #2',        0),
  (@g, 'Underhood PDC', 'F24', 20, 'Rear wiper',                         0),
  (@g, 'Underhood PDC', 'F28', 15, 'Transmission Control Module',        0),
  (@g, 'Underhood PDC', 'F30', 10, 'Engine Control Module / fuel pump',  0),
  (@g, 'Underhood PDC', 'F39', 40, 'HVAC blower motor',                  0);

-- 4. TORQUE (lug from OM; 2.4 engine torques from service data)
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel lug nut',                135, 100, 'OM p273: 100 ft-lb (135 N·m).'),
  (@g, @e24, 'Crankshaft pulley bolt',         50,  37, '2.4L Tigershark: stage 1 50 N·m, stage 2 +68°. Service data.'),
  (@g, @e24, 'Ancillary drive belt tensioner', 26,  19, '2.4L Tigershark, service data.'),
  (@g, @e24, 'Alternator bracket bolt',        23,  17, '2.4L Tigershark, service data.');

-- 5. SERVICE INTERVALS
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, NULL,  'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; severe duty 4,000 mi.'),
  (@g, NULL,  'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval.'),
  (@g, NULL,  'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, NULL,  'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, NULL,  'spark_plugs',           NULL, NULL, NULL, NULL, NULL, 'OM: mileage-based per maintenance chart.'),
  (@g, NULL,  'coolant_flush',         150000, NULL, 240000, NULL, 120, 'OM: flush + replace coolant at 10 yr / 150,000 mi.'),
  (@g, NULL,  'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: 9-speed ZF/948TE ATF per severe-duty chart.');

-- 6. PARTS
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e24, 'spark_plug', 'Mopar (OE)', 'Mopar', 1.20, '2.4L Tigershark: gap 1.2 mm (service data); Mopar plug, OE PN not printed in OM.'),
  (@g, @e32, 'spark_plug', 'Mopar (OE)', 'Mopar', NULL, '3.2L Pentastar: Mopar plug; gap/PN not printed in OM.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (flagged aggregator; sizes from workshop data)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 33.0, 228, '225/60R17'),
  (@g, 'rear',  'normal', 33.0, 228, '225/60R17'),
  (@g, 'front', 'normal', 33.0, 228, '225/60R18'),
  (@g, 'rear',  'normal', 33.0, 228, '225/60R18');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @om  FROM torque_specs WHERE generation_id=@g AND engine_id IS NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g AND engine_id IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @svc FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @tp FROM tire_pressures WHERE generation_id=@g;
