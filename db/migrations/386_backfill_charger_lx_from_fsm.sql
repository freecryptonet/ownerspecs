-- mig 386: BACKFILL Dodge Charger LX (gen 123) from the same Mopar LX FSM (source 856)
--
-- Charger LX shares the LX platform with 300 LX (gen 124) — identical chassis hardware,
-- engines (2.7 EER 212 / 3.5 EGG 213 / 5.7 HEMI 166 / 6.1 SRT8 214), transmission,
-- axles, fuses, torques, service intervals. Only the bulb table differs (Charger-
-- specific rear lamps + park/turn). Data from FSM p540-541 (fuses), p551/p2048 (bulbs),
-- p1855 (plugs), p8443/p8446 (tires/torque), p544 (service), p30 (chassis fluids).

SET @g := 123;
SET @s_fsm := 856;
SET @e_27 := 212;
SET @e_35 := 213;
SET @e_57 := 166;
SET @e_61 := 214;

-- 1. FIX chassis-fluid capacities (FSM p30) — same as 300 LX
UPDATE fluid_specs SET capacity_l = 5.0, capacity_qt = 5.28,
    notes = CONCAT(COALESCE(LEFT(notes,180),''), ' | FSM p30: NAG1 (W5A580) service fill 5.0 L; 42RLE (2.7L base) 3.8 L.')
  WHERE generation_id=@g AND fluid_type='transmission_at' AND capacity_l IS NULL;
UPDATE fluid_specs SET capacity_l = 0.6, capacity_qt = 0.63,
    notes = CONCAT(COALESCE(LEFT(notes,180),''), ' | FSM p30: MS140 transfer case 0.6 L (AWD only).')
  WHERE generation_id=@g AND fluid_type='transfer_case' AND capacity_l IS NULL;
UPDATE fluid_specs SET capacity_l = 0.6, capacity_qt = 0.63,
    notes = CONCAT(COALESCE(LEFT(notes,160),''), ' | FSM p30: 175MM FIA front axle 600 ml (AWD only).')
  WHERE generation_id=@g AND fluid_type='differential_front' AND capacity_l IS NULL;
UPDATE fluid_specs SET capacity_l = 1.4, capacity_qt = 1.48,
    notes = CONCAT(COALESCE(LEFT(notes,160),''), ' | FSM p30: 198MM RII rear axle 1.4 L. SRT8 uses 210MM RII.')
  WHERE generation_id=@g AND fluid_type='differential_rear' AND capacity_l IS NULL;

-- 2. PARTS — spark plugs + oil filter (same engines as 300 LX)
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@g, @e_27, 'spark_plug', 'RE10PMC5',   'Mopar/Champion', 1.35, '2.7L EER V6 spark plug per FSM p1855. Gap 0.048-0.058 in.'),
  (@g, @e_35, 'spark_plug', 'ZFR5LP-13G', 'NGK',            1.35, '3.5L EGG V6 spark plug per FSM p1855.'),
  (@g, @e_57, 'spark_plug', 'RE14MCC4',   'Champion',       1.14, '5.7L HEMI V8 spark plug per FSM p1855. Gap 0.045 in. 16 plugs.'),
  (@g, @e_61, 'spark_plug', 'PLZTR5A-13', 'NGK',            1.30, '6.1L SRT8 HEMI spark plug per FSM p1855. Gap 0.050 in. Torque-critical 15-20 N·m.'),
  (@g, NULL,  'oil_filter', 'Mopar full-flow', 'Mopar',     NULL, 'Mopar disposable full-flow oil filter per FSM. Exact PN in parts catalog.');

-- 3. BULBS — Dodge Charger-specific table (FSM p2048-2049)
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g, 'Low beam headlamp',        '9006',     2, 0),
  (@g, 'High beam headlamp',       '9005',     2, 0),
  (@g, 'Front park/turn',          '3157NAK',  2, 0),
  (@g, 'Front fog lamp',           '9145/H10', 2, 0),
  (@g, 'Front sidemarker',         '194',      2, 0),
  (@g, 'Tail/stop/turn',           '3057',     2, 0),
  (@g, 'Rear sidemarker',          '168',      2, 0),
  (@g, 'Backup lamp',              '921',      2, 0),
  (@g, 'CHMSL',                    'LED',      1, 1),
  (@g, 'License',                  '168',      2, 0),
  (@g, 'Spot lamp (police pkg)',   'H3',       1, 0),
  (@g, 'Rear courtesy/reading',    'W5W',      2, 0),
  (@g, 'Trunk/rear compartment',   '579',      1, 0),
  (@g, 'Overhead console reading', '578',      2, 0),
  (@g, 'Glove box',                '194',      1, 0),
  (@g, 'Door courtesy',            '562',      2, 0);

-- 4. FUSES — same LX-platform front + rear PDC (FSM p540-541)
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g, 'Front PDC', 'F01', 20, 'Left high beam headlight',      0),
  (@g, 'Front PDC', 'F02', 20, 'Right high beam headlight',     0),
  (@g, 'Front PDC', 'F04', 20, 'Horn',                          0),
  (@g, 'Front PDC', 'F06', 15, 'Front Control Module (FCM)',    0),
  (@g, 'Front PDC', 'F07', 20, 'Fog lamp',                      0),
  (@g, 'Front PDC', 'F08', 15, 'Park lamp',                     0),
  (@g, 'Front PDC', 'F11', 20, 'Auto Shutdown / PCM',           0),
  (@g, 'Front PDC', 'F14', 25, 'Powertrain Control Module',     0),
  (@g, 'Front PDC', 'F15', 20, 'Injectors, ignition coils',     0),
  (@g, 'Front PDC', 'F19', 50, 'Radiator fan',                  0),
  (@g, 'Front PDC', 'F21', 50, 'ABS pump motor',                0),
  (@g, 'Front PDC', 'F26', 20, 'Transmission',                  0),
  (@g, 'Rear PDC',  'R01', 60, 'Ignition Off Draw (IOD)',       0),
  (@g, 'Rear PDC',  'R02', 40, 'Battery feed',                  0),
  (@g, 'Rear PDC',  'R05', 30, 'Heated seat / steering column', 0),
  (@g, 'Rear PDC',  'R06', 20, 'Fuel pump',                     0),
  (@g, 'Rear PDC',  'R08', 15, 'Ignition start/run',            0);

-- 5. TIRE PRESSURES (FSM p8443; PSI per placard)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g, 'front', 'normal', 32.0, 220, '215/65R17 / 225/60R18 (base)'),
  (@g, 'rear',  'normal', 32.0, 220, '215/65R17 / 225/60R18 (base)'),
  (@g, 'front', 'normal', 35.0, 241, '245/45ZR20 (SRT8 Goodyear Eagle F1)'),
  (@g, 'rear',  'normal', 35.0, 241, '255/45ZR20 (SRT8 Goodyear Eagle F1)');

-- 6. TORQUE SPECS (FSM p8446/p1855/p571)
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, torque_ftlb, notes) VALUES
  (@g, NULL,  'Wheel lug nut',          150, 110, 'FSM p8446. M14x1.5 stud, 21 mm hex. 5 nuts.'),
  (@g, @e_61, 'Spark plug (6.1L SRT8)',  18,  13, 'FSM p1855: 15-20 N·m. Torque-critical tapered seat — do not exceed 15 ft·lb.'),
  (@g, @e_57, 'Spark plug (5.7L HEMI)',  18,  13, 'FSM p1855. 16 plugs total.'),
  (@g, NULL,  'ABS ICU mounting bolt',   11,   8, 'FSM p571: 11 N·m (97 in·lb).'),
  (@g, NULL,  'Brake hose-to-knuckle bracket screw', 11, 8, 'FSM p571: 11 N·m.');

-- 7. SERVICE INTERVALS (FSM p544-545) — same LX maintenance schedule
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (@g, 'engine_oil_and_filter', 6000, 3000, 10000, 5000, 6,  'FSM p544: Schedule A 6k mi / Schedule B (severe) 3k mi or 3 months.'),
  (@g, 'coolant_flush',         NULL, 102000, NULL, 164000, 60, 'FSM p544: flush + replace engine coolant at 102,000 mi / 60 months (HOAT 5yr/100k).'),
  (@g, 'transmission_at',       NULL, 60000, NULL, 96000, NULL, 'FSM p544: ATF + filter every 60,000 mi under Schedule B severe-duty.'),
  (@g, 'engine_air_filter',     30000, NULL, 48000, NULL, NULL, 'FSM p545: inspect each oil change, replace ~30,000 mi.'),
  (@g, 'brake_inspection',      6000, NULL, 10000, NULL, NULL, 'FSM p545: inspect brake hoses + linings at each oil change.'),
  (@g, 'spark_plugs',           NULL, NULL, NULL, NULL, NULL, 'FSM Schedule maintenance chart. 5.7/6.1 HEMI ~30k mi.');

-- 8. ELECTRICAL — battery (same LX-platform spec)
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
  (@g, 'H7 / Group 94R', 730, 80, 160);

-- 9. CITE all to FSM
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts', id, @s_fsm FROM parts WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs', id, @s_fsm FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses', id, @s_fsm FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @s_fsm FROM tire_pressures WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'torque_specs', id, @s_fsm FROM torque_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, @s_fsm FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_fsm FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @s_fsm FROM fluid_specs WHERE generation_id=@g;
