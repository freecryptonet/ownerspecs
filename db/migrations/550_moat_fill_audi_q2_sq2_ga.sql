-- mig 550 — moat-fill Audi Q2 (GA, gen 354) + SQ2 (GA, gen 356)
-- Source: dealer workshop service data, extracted 2026-05-30 (English UI), country=Germany.
--   Reuse existing vendor-neutral source row 817 "Workshop service manual — Audi Q2 (GA)" (public_link=0).
-- Engine-scope rigor: oil/coolant are engine-specific. The DB engine rows are:
--   1376 DGTE  (1.6 TDI)        <- filled from the 1.6 TDI lubricant spec (DDYA, same EA288 1.6 TDI family)
--   320  DFGA  (2.0 TDI 110kW)  <- DEFERRED: EA288 (2017) vs my extracted EA288-evo (DTRB 2021) diverge on the
--                                  507 00/0W-30 -> 509 00/0W-20 oil migration. Pull DFGA exact via browser HaynesPro.
--   2141 DADA/DPCA (1.5 TFSI)   <- DPCA extracted EXACT
--   2140 EA888/DKZA (2.0 TFSI)  <- filled from 2.0 TFSI EA888 spec (DNNA, same family/MY-equivalent)
--   1392 DNUE (SQ2 2.0 TFSI)    <- filled from SQ2 EA888 spec (DNFC, same engine family)
-- Deferred to browser-HaynesPro session: DFGA oil/coolant, exact-code confirm (DGTE/DKZA/DNUE),
--   tyre PSI (placard), wheel-bolt torque ("Extra Info"), engine-bay fuse box, bulbs.

SET NAMES utf8mb4;

SET @gq2  := 354;
SET @gsq2 := 356;
SET @src  := 817;
SET @e_16tdi  := 1376;
SET @e_15tfsi := 2141;
SET @e_20tfsi := 2140;
SET @e_sq2    := 1392;

-- ---------------------------------------------------------------------------
-- 0. Remove thin scraper-leftover fluid rows (NULL viscosity/spec) we now replace.
-- ---------------------------------------------------------------------------
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (8873,8874,8877,8878);
DELETE FROM fluid_specs WHERE id IN (8873,8874,8877,8878);

-- ---------------------------------------------------------------------------
-- 1. FLUIDS — Q2 (354)
-- ---------------------------------------------------------------------------
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 -- engine-scoped engine oil + coolant
 (@gq2,@e_16tdi, 'engine_oil', 4.70, 'SAE 0W-30', 'VW 507 00',           '1.6 TDI (EA288): with-filter fill. Oil drain plug 30 N·m.'),
 (@gq2,@e_16tdi, 'coolant',    8.00, NULL,        'TL-VW 774L (G12EVO)', '40% antifreeze -> -25°C; 50% -> -36°C.'),
 (@gq2,@e_15tfsi,'engine_oil', 4.30, 'SAE 0W-20', 'VW 508 00',           '1.5 TFSI (EA211evo). With-filter fill. Oil drain plug 30 N·m.'),
 (@gq2,@e_15tfsi,'coolant',    9.00, NULL,        'TL-VW 774L (G12EVO)', '40% antifreeze -> -25°C; 50% -> -36°C.'),
 (@gq2,@e_20tfsi,'engine_oil', 5.70, 'SAE 0W-20', 'VW 508 00',           '2.0 TFSI (EA888 gen3). With-filter fill. Oil drain plug 30 N·m.'),
 (@gq2,@e_20tfsi,'coolant',   10.00, NULL,        'TL-VW 774L (G12EVO)', '40% antifreeze -> -25°C; 50% -> -36°C.'),
 -- gen-wide
 (@gq2,NULL,'brake',          1.00, NULL, 'VW 501 14 / DOT 4', 'System fill 1.0 L (automatic / dual-clutch), 1.15 L (manual). VW 501 14 preferred, DOT 4 alternative.'),
 (@gq2,NULL,'ac_refrigerant', NULL, NULL, 'R1234yf',           '460 ± 15 g (R1234yf); 500 ± 15 g (R134a, earlier build). Compressor oil 75-110 ml per compressor make.'),
 (@gq2,NULL,'def_fluid',      NULL, NULL, 'AUS32 (AdBlue)',    'Diesel only (TDI). Selective catalytic reduction reductant.'),
 -- transmission_* must be engine-scoped on this multi-engine gen (NULL-engine rows are render-suppressed)
 (@gq2,@e_16tdi, 'transmission_dct',1.70, NULL,    'VW G 055 512 A2','0CW 7-speed dry dual-clutch, filled for life; initial fill 1.7 L. Hydraulic control unit (0CW) VW G 004 000 M2, 1.0 L.'),
 (@gq2,@e_15tfsi,'transmission_dct',1.70, NULL,    'VW G 055 512 A2','0CW 7-speed dry dual-clutch, filled for life; initial fill 1.7 L. Hydraulic control unit (0CW) VW G 004 000 M2, 1.0 L.'),
 (@gq2,@e_20tfsi,'transmission_dct',6.90, NULL,    'VW G 055 529 A2','0GC 7-speed wet dual-clutch (quattro): initial fill 6.9 L, refill 6.0-6.4 L.'),
 (@gq2,@e_16tdi, 'transmission_mt', 2.10, 'SAE 75W','VW G 052 527 A2','6-speed manual (02S): refill ~2.1 L (2.3 L after overhaul).'),
 (@gq2,@e_15tfsi,'transmission_mt', 2.10, 'SAE 75W','VW G 052 512',   '6-speed manual (02S/0C9): refill 1.5-2.1 L by gearbox (2.3 L after overhaul).'),
 -- quattro driveline scoped to the 40 TFSI quattro engine
 (@gq2,@e_20tfsi,'transfer_case',     0.75,'SAE 75W-90','VW G 052 145',     'quattro: transfer box refill 0.6-0.75 L by code (0FV/0AV/0FN/0CN).'),
 (@gq2,@e_20tfsi,'rear_differential', 0.95, NULL,      'VW G 052 580 A2',   'quattro: rear differential.'),
 (@gq2,@e_20tfsi,'haldex',            0.65, NULL,      'VW G 065 175 A2',   'quattro: Haldex coupling refill 0.65 L (initial 0.75 L).');

-- ---------------------------------------------------------------------------
-- 2. FLUIDS — SQ2 (356)
-- ---------------------------------------------------------------------------
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 (@gsq2,@e_sq2,'engine_oil', 5.70, 'SAE 0W-30', 'VW 504 00',           'SQ2 2.0 TFSI (EA888 gen3, performance). With-filter fill. Note: 504 00/0W-30, not the 508 00/0W-20 of the regular 2.0 TFSI.'),
 (@gsq2,@e_sq2,'coolant',   10.00, NULL,        'TL-VW 774L (G12EVO)', '40% antifreeze -> -25°C; 50% -> -36°C.'),
 (@gsq2,NULL,  'brake',      1.00, NULL,        'VW 501 14 / DOT 4',   'System fill 1.0 L. VW 501 14 preferred, DOT 4 alternative.'),
 (@gsq2,NULL,  'ac_refrigerant', NULL, NULL,    'R1234yf',             '460 ± 15 g (R1234yf); 500 ± 15 g (R134a). Compressor oil 75-110 ml per make.'),
 (@gsq2,NULL,  'transmission_dct', 6.90, NULL,  'VW G 055 529 A2',     '0GC 7-speed wet dual-clutch (quattro): initial fill 6.9 L, refill 6.0-6.4 L.'),
 (@gsq2,NULL,  'transfer_case',    0.75,'SAE 75W-90','VW G 052 145',   'Transfer box refill 0.6-0.75 L by code (0FV/0AV/0FN/0CN).'),
 (@gsq2,NULL,  'rear_differential',0.95, NULL,  'VW G 052 580 A2',     'Rear differential.'),
 (@gsq2,NULL,  'haldex',           0.65, NULL,  'VW G 065 175 A2',     'Haldex coupling refill 0.65 L (initial 0.75 L).');

-- ---------------------------------------------------------------------------
-- 3. TORQUES — engine (2.0 TFSI EA888) scoped + chassis gen-wide. Staged angles in notes.
--    Engine torques from the 2.0 TFSI spec; applied to engine 2140 (Q2) + 1392 (SQ2).
-- ---------------------------------------------------------------------------
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, notes) VALUES
 -- engine 2.0 TFSI — Q2 (2140)
 (@gq2,@e_20tfsi,'cylinder_head_bolt',50, 'Renew bolts. Stage 1: 50 N·m; stage 2: +90°; stage 3: +90°. Bolts A: 8 N·m +90°.'),
 (@gq2,@e_20tfsi,'spark_plug',       30, 'M14: 30-35 N·m; M12: 20-25 N·m.'),
 (@gq2,@e_20tfsi,'crankshaft_pulley',100,'Renew bolt. Stage 1: 100 N·m; stage 2: +180°.'),
 (@gq2,@e_20tfsi,'flywheel_bolt',    60, 'Dual-mass flywheel. Renew bolts. Stage 1: 60 N·m; stage 2: +90°.'),
 (@gq2,@e_20tfsi,'oxygen_sensor',    60, NULL),
 (@gq2,@e_20tfsi,'alternator',       23, NULL),
 (@gq2,@e_20tfsi,'starter_motor',    40, 'M10: 40 N·m; M12: 80 N·m.'),
 -- engine 2.0 TFSI — SQ2 (1392)
 (@gsq2,@e_sq2,'cylinder_head_bolt',50, 'Renew bolts. Stage 1: 50 N·m; stage 2: +90°; stage 3: +90°. Bolts A: 8 N·m +90°.'),
 (@gsq2,@e_sq2,'spark_plug',       30, 'M14: 30-35 N·m; M12: 20-25 N·m.'),
 (@gsq2,@e_sq2,'crankshaft_pulley',100,'Renew bolt. Stage 1: 100 N·m; stage 2: +180°.'),
 (@gsq2,@e_sq2,'flywheel_bolt',    60, 'Dual-mass flywheel. Renew bolts. Stage 1: 60 N·m; stage 2: +90°.'),
 (@gsq2,@e_sq2,'oxygen_sensor',    60, NULL),
 (@gsq2,@e_sq2,'alternator',       23, NULL),
 (@gsq2,@e_sq2,'starter_motor',    40, 'M10: 40 N·m; M12: 80 N·m.'),
 -- chassis / service — gen-wide both gens
 (@gq2, NULL,'oil_drain', 30, 'Renew the seal.'),
 (@gq2, NULL,'oil_filter',     25, 'Renew the O-ring.'),
 (@gq2, NULL,'front_driveshaft_to_hub', 200, 'Renew bolt. Stage 1: 200 N·m; stage 2: +90° (or +180° per bolt part no.).'),
 (@gq2, NULL,'rear_driveshaft_to_hub',  200, 'Renew bolt. Stage 1: 200 N·m; stage 2: +90°.'),
 (@gq2, NULL,'steering_wheel', 50, 'Used wheel: 50 N·m. New wheel: 30 N·m +90°.'),
 (@gq2, NULL,'ac_compressor',  25, 'Steel bolts 25 N·m; aluminium bolts 8 N·m +180°.'),
 (@gq2, NULL,'dct_drain_plug', 45, 'Wet DCT (0GC) drain plug, renew sealing washer.'),
 (@gq2, NULL,'rear_diff_drain',19, 'Renew the plug.'),
 (@gq2, NULL,'haldex_drain',   32, 'Renew the drain plug (filler plug 15 N·m).'),
 (@gsq2,NULL,'oil_drain', 30, 'Renew the seal.'),
 (@gsq2,NULL,'oil_filter',     25, 'Renew the O-ring.'),
 (@gsq2,NULL,'front_driveshaft_to_hub', 200, 'Renew bolt. Stage 1: 200 N·m; stage 2: +90° (or +180° per bolt part no.).'),
 (@gsq2,NULL,'rear_driveshaft_to_hub',  200, 'Renew bolt. Stage 1: 200 N·m; stage 2: +90°.'),
 (@gsq2,NULL,'steering_wheel', 50, 'Used wheel: 50 N·m. New wheel: 30 N·m +90°.'),
 (@gsq2,NULL,'ac_compressor',  25, 'Steel bolts 25 N·m; aluminium bolts 8 N·m +180°.'),
 (@gsq2,NULL,'dct_drain_plug', 45, 'Wet DCT (0GC) drain plug, renew sealing washer.'),
 (@gsq2,NULL,'rear_diff_drain',19, 'Renew the plug.'),
 (@gsq2,NULL,'haldex_drain',   32, 'Renew the drain plug (filler plug 15 N·m).');

-- ---------------------------------------------------------------------------
-- 4. ELECTRICAL (battery) — one representative row per gen; variants in implicit note via group.
-- ---------------------------------------------------------------------------
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
 (@gq2,  'H6 (LN3)', 420, 70, 140),
 (@gsq2, 'H6 (LN3)', 380, 72, 140);

-- ---------------------------------------------------------------------------
-- 5. SERVICE INTERVALS (Longlife). Petrol-only items engine-scoped.
-- ---------------------------------------------------------------------------
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
 (@gq2, NULL,      'engine_oil_and_filter', 18600, 30000, 24, 'Longlife (variable) service: up to 2 years / 30,000 km. Fixed (time/distance) service: 1 year / 15,000 km.'),
 (@gq2, NULL,      'engine_air_filter',     56000, 90000, NULL, 'Renew engine air filter; clean housing.'),
 (@gq2, NULL,      'cabin_air_filter',      37000, 60000, 24, 'Renew dust and pollen filter.'),
 (@gq2, NULL,      'brake_fluid_flush',     NULL,  NULL,  24, 'Renew brake fluid every 24 months.'),
 (@gq2, @e_15tfsi, 'spark_plugs',           37000, 60000, 72, '1.5 TFSI: spark plugs every 60,000 km / 72 months.'),
 (@gq2, @e_20tfsi, 'spark_plugs',           37000, 60000, 72, '2.0 TFSI: spark plugs every 60,000 km / 72 months.'),
 (@gq2, NULL,      'transmission_dct_fluid',75000,120000, NULL, 'Wet DCT (0GC, quattro): renew oil every 120,000 km. Dry DCT (0CW): filled for life.'),
 (@gq2, @e_20tfsi, 'haldex_fluid',          NULL,  NULL,  36, 'quattro: renew Haldex coupling oil every 36 months.'),
 (@gsq2,NULL,      'engine_oil_and_filter', 18600, 30000, 24, 'Longlife (variable) service: up to 2 years / 30,000 km. Fixed service: 1 year / 15,000 km.'),
 (@gsq2,NULL,      'engine_air_filter',     56000, 90000, NULL, 'Renew engine air filter; clean housing.'),
 (@gsq2,NULL,      'cabin_air_filter',      37000, 60000, 24, 'Renew dust and pollen filter.'),
 (@gsq2,NULL,      'brake_fluid_flush',     NULL,  NULL,  24, 'Renew brake fluid every 24 months.'),
 (@gsq2,@e_sq2,    'spark_plugs',           37000, 60000, 72, 'SQ2 2.0 TFSI: spark plugs every 60,000 km / 72 months.'),
 (@gsq2,NULL,      'transmission_dct_fluid',75000,120000, NULL, 'Wet DCT (0GC, quattro): renew oil every 120,000 km.'),
 (@gsq2,NULL,      'haldex_fluid',          NULL,  NULL,  36, 'quattro: renew Haldex coupling oil every 36 months.');

-- ---------------------------------------------------------------------------
-- 6. FUSES — passenger-compartment fuse/relay box (GA body; applies to both gens).
--    LHD shown; RHD similar. is_relay flag for R-rows.
-- ---------------------------------------------------------------------------
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
 (@gq2,'cabin','SC1', 30,'Reductant heater control unit',0),
 (@gq2,'cabin','SC2', 10,'Driver/passenger seat lumbar support switch',0),
 (@gq2,'cabin','SC4', 8,'Multimedia control unit / alarm horn',0),
 (@gq2,'cabin','SC5', 5,'Data bus diagnostic interface',0),
 (@gq2,'cabin','SC6', 5,'Selector lever / selector lever control unit',0),
 (@gq2,'cabin','SC7', 10,'Heater/AC switch, heated rear window relay, aux heater receiver',0),
 (@gq2,'cabin','SC8', 8,'Light/parking-brake switch, rain-light sensor, alarm, emergency call, cornering/headlight range CU',0),
 (@gq2,'cabin','SC9', 5,'Electronic steering wheel control unit',0),
 (@gq2,'cabin','SC10',5,'Information display / head-up display control unit',0),
 (@gq2,'cabin','SC11',25,'Front left seat belt pretensioner CU / power supply CU',0),
 (@gq2,'cabin','SC12',20,'Information display control unit',0),
 (@gq2,'cabin','SC13',15,'Suspension CU / front left seat belt pretensioner CU',0),
 (@gq2,'cabin','SC14',40,'Blower control unit',0),
 (@gq2,'cabin','SC15',10,'Electronic steering column lock, entry & start authorisation CU',0),
 (@gq2,'cabin','SC16',8,'Antenna amplifier, telephone, USB',0),
 (@gq2,'cabin','SC17',5,'Control panel control unit',0),
 (@gq2,'cabin','SC18',8,'Rear-view camera control unit',0),
 (@gq2,'cabin','SC19',8,'Entry & start authorisation CU, vehicle tracking',0),
 (@gq2,'cabin','SC20',8,'Reductant metering system relay',0),
 (@gq2,'cabin','SC22',40,'Boot lid control unit',0),
 (@gq2,'cabin','SC23',20,'Sliding roof CU / power supply CU',0),
 (@gq2,'cabin','SC24',20,'Power supply CU / sliding roof CU',0),
 (@gq2,'cabin','SC25',30,'Front/rear left door CU, rear left power window',0),
 (@gq2,'cabin','SC26',30,'Power supply control unit',0),
 (@gq2,'cabin','SC27',30,'Digital sound package CU / power supply CU',0),
 (@gq2,'cabin','SC29',8,'Vanity mirror, front sliding roof',0),
 (@gq2,'cabin','SC31',30,'Power supply CU / boot lid CU',0),
 (@gq2,'cabin','SC32',8,'Adaptive cruise, parking assist, lane-change assist, forward-view camera CU',0),
 (@gq2,'cabin','SC33',5,'Airbag CU, front sliding roof',0),
 (@gq2,'cabin','SC34',8,'Auto-hold, reversing light switch, refrigerant pressure sensor, power socket relay',0),
 (@gq2,'cabin','SC35',8,'Interior mirror, headlight range CU, console switches, air quality sensor, headlights, diagnostic connector',0),
 (@gq2,'cabin','SC36',5,'Right headlight',0),
 (@gq2,'cabin','SC37',5,'Left headlight',0),
 (@gq2,'cabin','SC39',30,'Front/rear right door CU, rear right power window',0),
 (@gq2,'cabin','SC40',20,'Cigarette lighter, 12V sockets',0),
 (@gq2,'cabin','SC41',25,'Front right seat belt pretensioner CU',0),
 (@gq2,'cabin','SC42',40,'Power supply control unit',0),
 (@gq2,'cabin','SC43',30,'Power supply CU / digital sound package CU',0),
 (@gq2,'cabin','SC44',15,'4WD control unit',0),
 (@gq2,'cabin','SC45',15,'Special equipment',0),
 (@gq2,'cabin','SC47',15,'Rear wiper motor',0),
 (@gq2,'cabin','SC49',5,'Clutch pedal position sensor, starter relays 1/2',0),
 (@gq2,'cabin','SC52',15,'Electronic suspension control unit',0),
 (@gq2,'cabin','SC53',30,'Heated rear windscreen relay',0),
 (@gq2,'cabin','R1', NULL,'Reductant metering system relay',1),
 (@gq2,'cabin','R2', NULL,'Seat belt pretensioner relay',1),
 (@gq2,'cabin','R4', NULL,'Terminal 15 voltage supply relay',1),
 (@gq2,'cabin','R5', NULL,'Heated rear windscreen relay',1),
 (@gq2,'cabin','R6', NULL,'Power socket relay',1);

-- ---------------------------------------------------------------------------
-- 7. SPEC_SOURCES — link every new row on 354/356 to src 817 (gens had no prior
--    torque/fuse/electrical/interval rows; old scraper fluid rows deleted above).
-- ---------------------------------------------------------------------------
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id IN (@gq2,@gsq2)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fluid_specs' AND ss.spec_id=fluid_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id IN (@gq2,@gsq2)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='torque_specs' AND ss.spec_id=torque_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id IN (@gq2,@gsq2)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='electrical_specs' AND ss.spec_id=electrical_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id IN (@gq2,@gsq2)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='service_intervals' AND ss.spec_id=service_intervals.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src FROM fuses WHERE generation_id IN (@gq2,@gsq2)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fuses' AND ss.spec_id=fuses.id AND ss.source_id=@src);
