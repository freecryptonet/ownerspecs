-- mig 401: backfill Dodge Dart PF (gen 341) moat. Fluids already present (11 rows, OM
-- source 878). HaynesPro has NO Dart, so OM-gap fields (battery, tyre PSI, engine torques)
-- come from a flagged non-OEM aggregated reference. Engine codes (1.4 MultiAir, 2.0/2.4
-- Tigershark) NOT changed — no authoritative source to verify, deferred to engine-code pass.
--
-- Sources: 878 = Dart PF OM (Mopar, public) — bulbs, fuses, lug torque, maintenance, oil filter.
-- NEW agg = aggregated non-OEM reference (battery, tyre pressure, generic service torques).

SET @g  := 341;
SET @om := 878;
SET @e20 := 2041;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('reference', 'Dodge Dart (PF) aggregated service reference (non-OEM)', NULL, 0, 1, NOW(),
   'Battery group/CCA, cold tyre placard pressures, generic service torques. NOT OEM documentation: HaynesPro has no Dart and the OM defers/omits these. Compiled from third-party battery-fitment + tire-pressure references. Provenance flagged.');
SET @agg := (SELECT id FROM sources WHERE citation='Dodge Dart (PF) aggregated service reference (non-OEM)' LIMIT 1);

-- 1. ELECTRICAL (flagged)
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, 'H5 / 47', 600, 60, NULL);

-- 2. BULBS (OM p635)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Low/high beam (Bi-Halogen)', '9005HL+', 2, 0),
  (@g, 'Low/high beam (Bi-Xenon)',   'D3S',     2, 0),
  (@g, 'Front park/turn signal',     '7442NALL',2, 0),
  (@g, 'Side marker',                '194',     2, 0),
  (@g, 'Front fog lamp',             'H11',     2, 0),
  (@g, 'Back-up lamp',               '7440',    2, 0),
  (@g, 'License plate',              '168',     2, 0),
  (@g, 'Center high-mount stop',     'LED',     1, 1),
  (@g, 'Rear tail/stop/turn',        'LED',     2, 1);

-- 3. FUSES (OM p628-630)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'BCM PDC', 'F1',  20, 'Front heated seats',                0),
  (@g, 'BCM PDC', 'F2',  20, 'Rear heated seats / heated wheel',  0),
  (@g, 'BCM PDC', 'F3',  10, 'Park assist / rear camera',         0),
  (@g, 'BCM PDC', 'F4',  15, 'Instrument cluster',                0),
  (@g, 'BCM PDC', 'F5',  10, 'HVAC / humidity sensor',            0),
  (@g, 'BCM PDC', 'F18', 15, 'Radio',                             0),
  (@g, 'BCM PDC', 'F20', 10, 'Steering column control module',    0),
  (@g, 'BCM PDC', 'F21', 10, 'Diagnostic port',                   0),
  (@g, 'BCM PDC', 'F22', 10, 'Universal garage door opener',      0),
  (@g, 'BCM PDC', 'F23', 20, 'Sunroof',                           0),
  (@g, 'BCM PDC', 'F24',  5, 'Run/accessory relay',               0),
  (@g, 'BCM PDC', 'F25',  5, 'Transmission Control Module',       0),
  (@g, 'BCM PDC', 'F26',  5, 'Stop lamp switch',                  0),
  (@g, 'BCM PDC', 'F27', 10, 'Pneumatic lumbar support',          0);

-- 4. TORQUE (lug from OM; generic service torques flagged)
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel lug nut',        135, 100, 'OM p549: 100 ft-lb (135 N·m). M12x1.25, 19 mm.'),
  (@g, @e20, 'Spark plug',             25,  18, 'Generic Tigershark/MultiAir spark-plug torque ~25 N·m — aggregated reference, NOT OEM documentation.'),
  (@g, NULL,  'Engine oil drain plug', 25,  18, 'Generic M12 drain-plug torque ~25 N·m — aggregated reference, NOT OEM documentation.');

-- 5. SERVICE INTERVALS (OM)
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, 'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; severe duty 4,000 mi.'),
  (@g, 'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval.'),
  (@g, 'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, 'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, 'spark_plugs',           NULL, NULL, NULL, NULL, NULL, 'OM: mileage-based per maintenance chart.'),
  (@g, 'coolant_flush',         150000, NULL, 240000, NULL, 120, 'OM: flush + replace coolant at 10 yr / 150,000 mi.'),
  (@g, 'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: ATF / DDCT fluid per severe-duty chart.');

-- 6. PARTS
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e20, 'spark_plug', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Spark Plugs; gap/PN not printed in OM.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (flagged aggregator)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 34.0, 234, '225/45R17'),
  (@g, 'rear',  'normal', 34.0, 234, '225/45R17'),
  (@g, 'front', 'normal', 34.0, 234, '225/40R18'),
  (@g, 'rear',  'normal', 34.0, 234, '225/40R18');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @om  FROM torque_specs WHERE generation_id=@g AND fastener LIKE 'Wheel%';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @agg FROM torque_specs WHERE generation_id=@g AND fastener NOT LIKE 'Wheel%';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @agg FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @agg FROM tire_pressures WHERE generation_id=@g;
