-- mig 507: moat fill for Mitsubishi Outlander III (GF) gen 347 from the Mitsubishi
-- Outlander Owner's Manual (manufacturer-owned PDF, mitsubishi-motors.co.uk). Free public
-- OEM source per Tim 2026-05-27.
-- Includes an engine-row cleanup first (scraper left wrong cc/fuel): all codes are real
-- Mitsubishi codes, only 3 fields were wrong.
-- Tyre pressures + lug torque are image-tabled in this OM (not cleanly extractable) -> those
-- two lanes left thin per the render-gate.

SET @gen := 347;
SET @src := 1016;

-- source -> public OEM owner's manual (manufacturer-owned domain => public_link=1)
UPDATE sources
   SET citation='Mitsubishi Outlander (GF) Owner''s Manual', public_link=1,
       url='https://mitsubishi-motors.co.uk/owners/manuals-and-guides/owners-manuals/'
 WHERE id=@src;

-- ENGINE CLEANUP (codes already correct; fix wrong cc/fuel only)
UPDATE engines SET displacement_cc=2268 WHERE id=2064;   -- 4N14 2.2 diesel (was NULL)
UPDATE engines SET displacement_cc=1998 WHERE id=2065;   -- 4J11 2.0 petrol (was 2268)
UPDATE engines SET fuel='petrol'        WHERE id=2066;   -- 4B11 2.0 (PHEV ICE) (was electric)

-- gen chassis tracks (OM ch11)
UPDATE generations SET front_track_mm=1540, rear_track_mm=1540 WHERE id=@gen AND front_track_mm IS NULL;

-- drop thin scraper fluid_hints rows
DELETE FROM spec_sources WHERE spec_table='fluid_specs'
  AND spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=@gen);
DELETE FROM fluid_specs WHERE generation_id=@gen;

-- engine-scoped oil + coolant (2062=6B31 3.0, 2063=4J12 2.4, 2064=4N14 2.2d, 2065=4J11 2.0, 2066=4B11 2.0)
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
(@gen,2062,'engine_oil',4.3,NULL,NULL,'Oil pan 4.0 L + filter 0.3 L'),
(@gen,2063,'engine_oil',4.6,NULL,NULL,'Oil pan 4.3 L + filter 0.3 L'),
(@gen,2064,'engine_oil',7.5,NULL,NULL,'Oil pan 7.1 L + filter 0.3 L + cooler 0.1 L'),
(@gen,2065,'engine_oil',4.3,NULL,NULL,'Oil pan 4.0 L + filter 0.3 L'),
(@gen,2066,'engine_oil',4.3,NULL,NULL,'Oil pan 4.0 L + filter 0.3 L (PHEV ICE)'),
(@gen,2062,'coolant',9.0,NULL,'MMC Super Long Life Coolant Premium (HOAT)',NULL),
(@gen,2063,'coolant',6.0,NULL,'MMC Super Long Life Coolant Premium (HOAT)','Incl. 0.65 L reserve'),
(@gen,2064,'coolant',8.0,NULL,'MMC Super Long Life Coolant Premium (HOAT)','Incl. 0.65 L reserve'),
(@gen,2065,'coolant',6.0,NULL,'MMC Super Long Life Coolant Premium (HOAT)','Incl. 0.65 L reserve'),
(@gen,2066,'coolant',6.0,NULL,'MMC Super Long Life Coolant Premium (HOAT)','Incl. 0.65 L reserve'),
-- transmission fluids (engine-scoped so they render on this multi-engine gen)
(@gen,2063,'transmission_cvt',6.9,NULL,'MMC GENUINE CVTF-J4',NULL),
(@gen,2065,'transmission_cvt',6.9,NULL,'MMC GENUINE CVTF-J4',NULL),
(@gen,2062,'transmission_at',8.2,NULL,'MMC GENUINE ATF-J3',NULL),
(@gen,2064,'transmission_at',8.2,NULL,'MMC GENUINE ATF-J3',NULL),
(@gen,2065,'transmission_mt',2.5,'SAE 75W-80','API GL-4 (MMC New Multi Gear Oil)','5-speed manual'),
(@gen,2064,'transmission_mt',2.2,'SAE 75W-80','API GL-4 (MMC New Multi Gear Oil)','6-speed manual'),
-- drivetrain-shared fluids (gen-wide ok per data-grain rules)
(@gen,NULL,'transfer_case',0.5,'SAE 80','API GL-5 (MMC Super Hypoid Gear Oil)',NULL),
(@gen,NULL,'rear_differential',0.4,'SAE 80','API GL-5 (MMC Super Hypoid Gear Oil)',NULL),
(@gen,NULL,'brake',NULL,NULL,'FMVSS DOT 3 or DOT 4','Brake & clutch, fill as required'),
(@gen,NULL,'washer',4.5,NULL,NULL,NULL),
(@gen,NULL,'ac_refrigerant',NULL,NULL,'HFO-1234yf / HFC-134a','530–570 g (R-1234yf) / 430–470 g (R-134a)');

-- battery (volume 2.0 petrol; OM ch11 electrical table)
INSERT INTO electrical_specs (generation_id, battery_group, ah, alternator_amps) VALUES
(@gen,'75D23L',55,130);

-- spark plugs (OM ch11; engine-scoped)
INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, notes) VALUES
(@gen,2065,'spark_plug','DILKR6D11G','NGK','2.0 petrol'),
(@gen,2066,'spark_plug','DILKR6D11G','NGK','2.0 petrol (PHEV ICE)'),
(@gen,2063,'spark_plug','FR5FI','NGK','2.4 petrol'),
(@gen,2062,'spark_plug','DILKR7C11','NGK','3.0 V6');

-- towing from OM ch11 (auto-data missed braked towing)
UPDATE trims SET trailer_braked_kg=2000, trailer_unbraked_kg=750 WHERE id IN (947,948);            -- 2.2 diesel
UPDATE trims SET trailer_braked_kg=1600, trailer_unbraked_kg=750 WHERE id IN (944,945,946,949,950); -- petrol

-- citations -> Mitsubishi Outlander (GF) Owner's Manual
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'parts', id, @src FROM parts WHERE generation_id=@gen;
