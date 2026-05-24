-- mig 393: backfill Dodge Avenger JS (gen 342) moat + correct 2.4L engine code.
-- Fluids already present (9 rows, OM source 879). Adds electrical, bulbs, fuses,
-- torques, service intervals, parts, tires.
--
-- Engine code: 2039 "2.4 World ED" -> ED3 (the universal Chrysler/GEMA World Gas Engine
-- code per HaynesPro; correct for every application, so safe even though shared). slug frozen.
-- Engine 138 "Pentastar" (3.6 = ERB on this gen per HaynesPro) is a shared multi-variant
-- catch-all (ERB here, ERC/ERG on later gens) — left for a dedicated Pentastar split, not
-- mislabelled inline.
--
-- Sources: 879 = Avenger OM (Mopar, public). NEW = vendor-neutral workshop service specs.

SET @g  := 342;
SET @om := 879;
SET @e24 := 2039;
SET @e36 := 138;

UPDATE engines SET code='ED3', display_name='Chrysler/GEMA 2.4L World Gas Engine I4 (ED3)' WHERE id=@e24;

INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Dodge Avenger (JS) workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data (battery, engine torques, cold tyre pressures + sizes). Vendor-neutral per house policy.');
SET @svc := (SELECT id FROM sources WHERE citation='Dodge Avenger (JS) workshop service specifications' LIMIT 1);

-- 1. ELECTRICAL
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, NULL, 700, 66, 120);

-- 2. BULBS (OM p467)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Low beam headlamp',      '9006',     2, 0),
  (@g, 'High beam headlamp',     '9005',     2, 0),
  (@g, 'Front park/turn signal', '3457A',    2, 0),
  (@g, 'Front fog lamp',         'H11',      2, 0),
  (@g, 'Front side marker',      'WY5W',     2, 0),
  (@g, 'Back-up lamp',           '921',      2, 0),
  (@g, 'License plate',          'W5W',      2, 0),
  (@g, 'Dome / courtesy',        '578/W5W',  2, 0),
  (@g, 'Visor vanity',           '578/W5W',  2, 0),
  (@g, 'Glove box',              'A6220',    1, 0),
  (@g, 'Shift indicator',        'A6220',    1, 0);

-- 3. FUSES (OM p462 underhood, mini-fuse cavities)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'Underhood PDC', 'F2',  20, 'Brake vacuum pump',                 0),
  (@g, 'Underhood PDC', 'F3',  10, 'CHMSL / brake switch',              0),
  (@g, 'Underhood PDC', 'F4',  10, 'Ignition switch',                   0),
  (@g, 'Underhood PDC', 'F5',  20, 'Trailer tow',                       0),
  (@g, 'Underhood PDC', 'F6',  10, 'Power mirror / climate controls',   0),
  (@g, 'Underhood PDC', 'F7',  30, 'Ignition Off Draw (IOD) sense 1',   0),
  (@g, 'Underhood PDC', 'F8',  30, 'Ignition Off Draw (IOD) sense 2',   0),
  (@g, 'Underhood PDC', 'F9',  40, 'Battery feed / power seats',        0),
  (@g, 'Underhood PDC', 'F10', 20, 'Instrument panel / power locks',    0),
  (@g, 'Underhood PDC', 'F11', 15, 'Selectable power outlet',           0),
  (@g, 'Underhood PDC', 'F13', 20, 'Ignition / cigar lighter',          0),
  (@g, 'Underhood PDC', 'F14', 10, 'Instrument panel',                  0);

-- 4. TORQUE SPECS
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel lug nut',         135, 100, 'OM p408: 100 ft-lb (135 N·m).'),
  (@g, @e24, 'Crankshaft pulley bolt', 210, 155, '2.4L ED3, service data.'),
  (@g, @e24, 'Exhaust manifold',        34,  25, '2.4L ED3, service data.');

-- 5. SERVICE INTERVALS (OM oil-change-indicator schedule)
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, NULL,  'engine_oil_and_filter', NULL, 4000, NULL, 6500, 12, 'OM: oil-change-indicator system; severe duty 4,000 mi.'),
  (@g, NULL,  'tire_rotation',         NULL, NULL, NULL, NULL, NULL, 'OM: rotate at every oil-change interval / first sign of wear.'),
  (@g, NULL,  'brake_inspection',      NULL, NULL, NULL, NULL, NULL, 'OM: inspect pads, rotors, hoses, park brake at every oil change.'),
  (@g, NULL,  'engine_air_filter',     NULL, NULL, NULL, NULL, NULL, 'OM: inspect/replace engine air cleaner per chart.'),
  (@g, @e24, 'spark_plugs',            NULL, NULL, NULL, NULL, NULL, 'OM: mileage-based per maintenance chart (2.4L / 3.6L).'),
  (@g, NULL,  'coolant_flush',         150000, NULL, 240000, NULL, 120, 'OM: flush + replace coolant at 10 yr / 150,000 mi.'),
  (@g, NULL,  'transmission_at',       NULL, NULL, NULL, NULL, NULL, 'OM: change ATF+4 and filter per severe-duty chart.');

-- 6. PARTS (OM lists Mopar plugs + gap; no OE PN printed in this OM)
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e24, 'spark_plug', 'Mopar (OE)', 'Mopar', 1.10, 'OM p473: 2.4L gap 0.043 in (1.1 mm); PZEV 0.8 mm. OE PN not printed.'),
  (@g, @e36, 'spark_plug', 'Mopar (OE)', 'Mopar', 1.10, 'OM p473: 3.6L gap 0.043 in (1.1 mm). OE PN not printed.'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)', 'Mopar', NULL, 'OM p473: Mopar Engine Oil Filter; OE PN not printed.');

-- 7. TIRE PRESSURES (sizes + pressure from workshop service data; normal-load 2.2 bar)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 32.0, 220, '215/65R16'),
  (@g, 'rear',  'normal', 32.0, 220, '215/65R16'),
  (@g, 'front', 'normal', 32.0, 220, '215/60R17'),
  (@g, 'rear',  'normal', 32.0, 220, '215/60R17');

-- citations
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @om  FROM torque_specs WHERE generation_id=@g AND engine_id IS NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g AND engine_id IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @svc FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @svc FROM tire_pressures WHERE generation_id=@g;
