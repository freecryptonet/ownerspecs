-- mig 551 — Audi Q2 (354) + SQ2 (356) GA backfill (browser HaynesPro, country EU/Germany).
-- Completes the items deferred from mig 550, all from facts (Feist) — no verbatim text.
--   1. DFGA (engine 320, 2.0 TDI 110kW quattro) oil+coolant+driveline — CONFIRMED distinct from DTRB:
--      VW 507 00 / 0W-30 / 4.7 L (EA288, NOT the 509 00/0W-20/5.5 L of the EA288-evo DTRB).
--   2. DFGA diesel-specific service intervals (fuel filter, timing belt, DPF) — engine-scoped.
--   3. Tyre pressures (Q2) — front/rear, normal + full load, per OE size (bar->psi/kpa).
--   4. Engine-compartment fuse box (SA1-SA5, body-wide) on both gens.
--   5. SQ2 passenger fuse box — clone of the GA body box added to 354 in mig 550.
-- Reuse source 817 (vendor-neutral, public_link=0).

SET NAMES utf8mb4;
SET @gq2  := 354;
SET @gsq2 := 356;
SET @src  := 817;
SET @e_dfga := 320;

-- ---------------------------------------------------------------------------
-- 1. DFGA (2.0 TDI quattro) fluids — engine-scoped
-- ---------------------------------------------------------------------------
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 (@gq2,@e_dfga,'engine_oil',       4.70,'SAE 0W-30','VW 507 00',       '2.0 TDI (EA288). With-filter fill. 5W-30 (VW 507 00) accepted on builds up to 2020. Oil drain plug 30 N·m.'),
 (@gq2,@e_dfga,'coolant',          8.00, NULL,      'TL-VW 774L (G12EVO)','40% antifreeze -> -25°C; 50% -> -36°C.'),
 (@gq2,@e_dfga,'transmission_dct', 6.90, NULL,      'VW G 055 529 A2', '0GC 7-speed wet dual-clutch (quattro): initial fill 6.7-6.9 L, refill 6.0 L.'),
 (@gq2,@e_dfga,'transfer_case',    0.75,'SAE 75W-90','VW G 052 145',   'quattro: transfer box refill 0.6-0.75 L by code (0CN/0FN/0AV).'),
 (@gq2,@e_dfga,'rear_differential',0.95, NULL,      'VW G 052 580 A2', 'quattro: rear differential (0BR). Builds to 14/04/2019 used VW G 052 145 S2.'),
 (@gq2,@e_dfga,'haldex',           0.65, NULL,      'VW G 065 175 A2', 'quattro: Haldex coupling refill 0.65 L (initial 0.75 L).');

-- ---------------------------------------------------------------------------
-- 2. DFGA diesel service intervals (engine-scoped; no spark plugs on diesel)
-- ---------------------------------------------------------------------------
INSERT INTO service_intervals (generation_id, engine_id, service, miles_normal, km_normal, months, notes) VALUES
 (@gq2,@e_dfga,'fuel_filter',            56000, 90000, NULL, '2.0 TDI: renew the fuel filter every 90,000 km.'),
 (@gq2,@e_dfga,'timing_belt_replacement',130000,210000,NULL, '2.0 TDI: renew the timing belt every 210,000 km (belt-driven, unlike the chain-driven petrol engines).'),
 (@gq2,@e_dfga,'accessory_drive_belt',   130000,210000,NULL, '2.0 TDI: renew the ancillary (accessory) drive belt every 210,000 km.'),
 (@gq2,@e_dfga,'dpf_check',              130000,210000,NULL, '2.0 TDI: diesel particulate filter saturation check (diagnostic) first at 210,000 km, then every 30,000 km.');

-- ---------------------------------------------------------------------------
-- 3. Tyre pressures (Q2) — per OE size, front/rear, normal (partial) + full load.
--    bar -> psi (x14.5) / kpa (x100). Representative for the gen (minor axle-load variation by variant).
-- ---------------------------------------------------------------------------
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
 (@gq2,'front','normal',34.8,240,'205/60 R16 92V'),(@gq2,'front','full',39.2,270,'205/60 R16 92V'),
 (@gq2,'rear', 'normal',27.6,190,'205/60 R16 92V'),(@gq2,'rear', 'full',36.3,250,'205/60 R16 92V'),
 (@gq2,'front','normal',31.9,220,'215/60 R16 95V'),(@gq2,'front','full',36.3,250,'215/60 R16 95V'),
 (@gq2,'rear', 'normal',27.6,190,'215/60 R16 95V'),(@gq2,'rear', 'full',33.4,230,'215/60 R16 95V'),
 (@gq2,'front','normal',31.9,220,'215/55 R17 94V'),(@gq2,'front','full',36.3,250,'215/55 R17 94V'),
 (@gq2,'rear', 'normal',27.6,190,'215/55 R17 94V'),(@gq2,'rear', 'full',33.4,230,'215/55 R17 94V'),
 (@gq2,'front','normal',33.4,230,'215/50 R18 92W'),(@gq2,'front','full',37.7,260,'215/50 R18 92W'),
 (@gq2,'rear', 'normal',27.6,190,'215/50 R18 92W'),(@gq2,'rear', 'full',34.8,240,'215/50 R18 92W'),
 (@gq2,'front','normal',33.4,230,'235/40 R19 96Y'),(@gq2,'front','full',37.7,260,'235/40 R19 96Y'),
 (@gq2,'rear', 'normal',27.6,190,'235/40 R19 96Y'),(@gq2,'rear', 'full',34.8,240,'235/40 R19 96Y');

-- ---------------------------------------------------------------------------
-- 4. Engine-compartment fuse box (SA1-SA5) — body-wide, both gens
-- ---------------------------------------------------------------------------
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
 (@gq2,'engine_bay','SA1',400,'Alternator',0),
 (@gq2,'engine_bay','SA2', 80,'Power steering control unit',0),
 (@gq2,'engine_bay','SA3',125,'Supply: passenger-compartment fuse/relay box',0),
 (@gq2,'engine_bay','SA4', 80,'Supply: passenger-compartment fuse/relay box',0),
 (@gq2,'engine_bay','SA5', 50,'Cooling fan motor (80A/100A also used)',0),
 (@gsq2,'engine_bay','SA1',400,'Alternator',0),
 (@gsq2,'engine_bay','SA2', 80,'Power steering control unit',0),
 (@gsq2,'engine_bay','SA3',125,'Supply: passenger-compartment fuse/relay box',0),
 (@gsq2,'engine_bay','SA4', 80,'Supply: passenger-compartment fuse/relay box',0),
 (@gsq2,'engine_bay','SA5', 50,'Cooling fan motor (80A/100A also used)',0);

-- ---------------------------------------------------------------------------
-- 5. SQ2 (356) passenger fuse/relay box — clone the GA-body box from gen 354 (mig 550)
-- ---------------------------------------------------------------------------
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay)
SELECT @gsq2, location, position, amperage, circuit_name, is_relay
FROM fuses WHERE generation_id=@gq2 AND location='cabin'
  AND NOT EXISTS (SELECT 1 FROM fuses f2 WHERE f2.generation_id=@gsq2 AND f2.location='cabin' AND f2.position=fuses.position);

-- ---------------------------------------------------------------------------
-- 5b. Restated maintenance procedure — service indicator reset (own words, facts only)
-- ---------------------------------------------------------------------------
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes) VALUES
 (@gq2,'service_reminder_reset','service-indicator-reset','Audi Q2 (GA) — service indicator reset',
  'On the Q2 (GA) the service interval display (SII) cannot be cleared with a dashboard button-and-ignition sequence the way many older cars allow. The reset is a software function that has to be sent to the instrument-cluster control unit with a VAG-capable diagnostic scan tool over the OBD port — there is no hidden combination of the trip-reset button and ignition that will do it on this generation. Carry out the reset only after the service work is finished and logged, so the next interval is calculated from the correct starting point.',
  'VAG-compatible diagnostic scan tool with Audi service-reset functions (dealer-level tester or an equivalent aftermarket OBD tool).',
  'Hunting for a stalk/button reset combo that does not exist on the GA Q2; resetting before the service is actually completed, which skews the next due date.'),
 (@gsq2,'service_reminder_reset','service-indicator-reset','Audi SQ2 (GA) — service indicator reset',
  'The SQ2 (GA) shares the Q2 service-reminder system: the interval display is cleared as a software function through a VAG-capable diagnostic scan tool on the OBD port, not by any trip-button-and-ignition sequence. Perform the reset only once the service work has been completed and recorded so the following interval starts from the right point.',
  'VAG-compatible diagnostic scan tool with Audi service-reset functions (dealer-level tester or an equivalent aftermarket OBD tool).',
  'Looking for a manual button reset that the GA platform does not offer; clearing the indicator before the work is done.');

-- ---------------------------------------------------------------------------
-- 6. spec_sources — link the new rows to src 817
-- ---------------------------------------------------------------------------
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id IN (@gq2,@gsq2)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fluid_specs' AND ss.spec_id=fluid_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @src FROM service_intervals WHERE generation_id IN (@gq2,@gsq2)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='service_intervals' AND ss.spec_id=service_intervals.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id IN (@gq2,@gsq2)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='tire_pressures' AND ss.spec_id=tire_pressures.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src FROM fuses WHERE generation_id IN (@gq2,@gsq2)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fuses' AND ss.spec_id=fuses.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', id, @src FROM procedures WHERE generation_id IN (@gq2,@gsq2) AND slug='service-indicator-reset'
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='procedures' AND ss.spec_id=procedures.id AND ss.source_id=@src);
