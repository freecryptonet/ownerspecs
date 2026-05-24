-- mig 392: backfill Dodge Nitro KA (gen 343) moat + correct engine codes.
-- Fluids already complete (12 rows, OM source 880). Adds electrical, bulbs, fuses,
-- torques, service intervals, parts, tires.
--
-- Engine codes corrected from HaynesPro's authoritative Engine-code column (both
-- engines are Nitro-only, no cross-gen impact). URL slug is frozen (mig 389) so the
-- /engines/ pages don't move:
--   2042 "3.7 PowerTech V6" -> EKG (3.7L PowerTech, slug 37-powertech-v6 unchanged)
--   2043 "4.0 SOHC V6"      -> EGS (4.0L SOHC 3952cc, slug 40-sohc-v6 unchanged)
--
-- Sources:
--   880 = "Dodge Nitro (KA) 2010 Owner's Manual" (Mopar, public) — bulbs, fuses,
--         lug torque, spark plugs (the OM prints PN+gap), maintenance, oil filter.
--   NEW = vendor-neutral workshop service specifications — battery, engine torques,
--         tyre pressure + sizes (pressure is workshop-published here, not placard-deferred).

SET @g  := 343;
SET @om := 880;
SET @e37 := 2042;
SET @e40 := 2043;

-- ---- engine code corrections ------------------------------------------------
UPDATE engines SET code='EKG', display_name='Chrysler 3.7L PowerTech SOHC V6 (EKG)' WHERE id=@e37;
UPDATE engines SET code='EGS', display_name='Chrysler 4.0L SOHC V6 (EGS)'           WHERE id=@e40;

-- ---- source row -------------------------------------------------------------
INSERT INTO sources (type, citation, url, public_link, is_public, retrieved_at, notes) VALUES
  ('service_manual', 'Dodge Nitro (KA) workshop service specifications', NULL, 0, 1, NOW(),
   'Workshop-grade service data for the KA platform (battery, engine torque sequences, cold tyre pressures + sizes). Vendor-neutral per house policy.');
SET @svc := (SELECT id FROM sources WHERE citation='Dodge Nitro (KA) workshop service specifications' LIMIT 1);

-- ---- 1. ELECTRICAL ----------------------------------------------------------
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, NULL, 600, 66, 160);
-- Base 66 Ah / 600 CCA; heavy-duty option 75 Ah / 800 CCA; alternator 136 or 160 A (service data).

-- ---- 2. BULBS (OM p440 replacement-bulb table) ------------------------------
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Headlamp (low/high)',        '9008/H13', 2, 0),
  (@g, 'Front park/turn signal',     '3157',     2, 0),
  (@g, 'Front side marker',          '168',      2, 0),
  (@g, 'Front fog lamp',             '9145/H10', 2, 0),
  (@g, 'Rear tail/stop/turn',        '3057',     2, 0),
  (@g, 'Back-up lamp',               '3057',     2, 0),
  (@g, 'Center high-mount stop',     'LED',      1, 1),
  (@g, 'License plate',              '168',      2, 0),
  (@g, 'Dome lamp',                  '212-2',    1, 0),
  (@g, 'Liftgate lamp',              '567',      1, 0),
  (@g, 'Overhead console',           '214-2',    2, 0),
  (@g, 'Reading lamp',               '212-2',    2, 0);

-- ---- 3. FUSES (OM p433-434 Totally Integrated Power Module) -----------------
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'TIPM', 'J1',  40, 'Power folding seat',                 0),
  (@g, 'TIPM', 'J2',  30, 'Transfer case / power liftgate',     0),
  (@g, 'TIPM', 'J3',  30, 'Rear door module',                   0),
  (@g, 'TIPM', 'J4',  25, 'Driver door node',                   0),
  (@g, 'TIPM', 'J5',  25, 'Passenger door node',                0),
  (@g, 'TIPM', 'J6',  40, 'ABS pump / ESP',                     0),
  (@g, 'TIPM', 'J7',  30, 'ABS valve / ESP',                    0),
  (@g, 'TIPM', 'J8',  40, 'Power memory seat',                  0),
  (@g, 'TIPM', 'J10', 30, 'Headlamp washer relay',              0),
  (@g, 'TIPM', 'J11', 30, 'Sway bar / power sliding door',      0),
  (@g, 'TIPM', 'J13', 60, 'Ignition Off Draw (IOD) main',       0),
  (@g, 'TIPM', 'J14', 40, 'Ignition feed',                      0);

-- ---- 4. TORQUE SPECS --------------------------------------------------------
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel lug nut',         130,  95, 'OM p394: 95 ft-lb (130 N·m). Service-data range 116-156 N·m.'),
  (@g, @e37, 'Crankshaft pulley bolt', 175, 129, '3.7L EKG, service data.'),
  (@g, @e37, 'Flywheel / flexplate',    95,  70, '3.7L EKG, service data.'),
  (@g, @e37, 'Exhaust manifold',        25,  18, '3.7L EKG, service data.'),
  (@g, @e37, 'Coolant pump',            58,  43, '3.7L EKG, service data.');

-- ---- 5. SERVICE INTERVALS (OM schedule) -------------------------------------
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, NULL,  'engine_oil_and_filter', 6000, 3000, 10000, 5000, 12, 'OM Schedule: change oil + filter every 6,000 mi (10,000 km); severe 3,000 mi.'),
  (@g, NULL,  'tire_rotation',         6000, NULL, 10000, NULL, NULL, 'OM: rotate tires every 6,000 mi (10,000 km).'),
  (@g, NULL,  'engine_air_filter',     30000, NULL, 50000, NULL, NULL, 'OM: replace at 30,000 mi (50,000 km).'),
  (@g, @e37, 'spark_plugs',            30000, NULL, 50000, NULL, NULL, 'OM: 3.7L plugs at 30,000 mi; 4.0L per maintenance chart.'),
  (@g, NULL,  'coolant_flush',         100000, NULL, 160000, NULL, 60, 'OM: Mopar HOAT 5 yr / 100,000 mi coolant.'),
  (@g, NULL,  'transmission_at',       126000, NULL, 210000, NULL, NULL, 'OM: change ATF+4 and filter at 126,000 mi (210,000 km).'),
  (@g, NULL,  'brake_inspection',      12000, NULL, 20000, NULL, NULL, 'OM: inspect brake linings, CV joints, exhaust, front suspension from 12,000 mi.');

-- ---- 6. PARTS (spark-plug PN+gap printed in OM p446) ------------------------
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e37, 'spark_plug', 'ZFR6F-11G',  'NGK',   1.09, 'OM p446: 3.7L EKG, gap 0.043 in (1.09 mm).'),
  (@g, @e40, 'spark_plug', 'ZFR5LP-13G', 'NGK',   1.27, 'OM p446: 4.0L EGS, gap 0.050 in (1.27 mm).'),
  (@g, NULL,  'oil_filter', 'Mopar (OE)',  'Mopar', NULL, 'OM p446: Mopar Engine Oil Filter; exact OE PN not printed.');

-- ---- 7. TIRE PRESSURES (sizes + pressure both from workshop service data) ----
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 33.0, 230, 'P225/75R16'),
  (@g, 'rear',  'normal', 33.0, 230, 'P225/75R16'),
  (@g, 'front', 'normal', 33.0, 230, 'P235/65R17'),
  (@g, 'rear',  'normal', 33.0, 230, 'P235/65R17'),
  (@g, 'front', 'normal', 33.0, 230, 'P245/50R20'),
  (@g, 'rear',  'normal', 33.0, 230, 'P245/50R20');

-- ---- citations --------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @om FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @om FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @om FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @om FROM parts WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @om  FROM torque_specs WHERE generation_id=@g AND engine_id IS NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @svc FROM torque_specs WHERE generation_id=@g AND engine_id IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @svc FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @svc FROM tire_pressures WHERE generation_id=@g;
