-- mig 508: moat fill for Nissan Juke (F15) gen 345 from the Nissan Juke Owner's Manual
-- (Nissan USA, owners.nissanusa.com — manufacturer-owned PDF, public_link=1). Free public
-- OEM source per Tim 2026-05-27.
-- US OM covers the MR16DDT 1.6 turbo only -> engine-scoped oil/coolant for that engine;
-- HR16DE / K9K oil/coolant need a EU OM (left for later). Bulb/fuse/tyre tables in this OM
-- are image-based (not text-extractable) -> those lanes stay thin (fuses are a startmycar
-- follow-up). Engine cleanup: HR16DE was mislabelled fuel=hybrid.

SET @gen := 345;
SET @src := 989;
SET @mr16 := 2054; SET @hr16 := 868; SET @k9k := 2025;

UPDATE engines SET fuel='petrol' WHERE id=@hr16;   -- HR16DE is petrol, not hybrid

UPDATE sources
   SET type='owner_manual', citation='Nissan Juke (F15) Owner''s Manual', public_link=1,
       url='https://owners.nissanusa.com/content/techpub/ManualsAndGuides/JUKE/2015/2015-JUKE-owner-manual.pdf'
 WHERE id=@src;

UPDATE generations SET fuel_tank_l=50.0 WHERE id=@gen AND fuel_tank_l IS NULL;

DELETE FROM spec_sources WHERE spec_table='fluid_specs'
  AND spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=@gen);
DELETE FROM fluid_specs WHERE generation_id=@gen;

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
(@gen,@mr16,'engine_oil',4.5,'0W-20','API Certification Mark (5W-30 alt)','With filter change'),
(@gen,@mr16,'coolant',8.7,NULL,'NISSAN Long Life Antifreeze/Coolant (blue), pre-diluted','CVT model (MT 8.5 L)'),
(@gen,@mr16,'transmission_cvt',NULL,NULL,'NISSAN CVT Fluid NS-3','Genuine NS-3 only'),
(@gen,@mr16,'transmission_mt',NULL,'SAE 75W-80','NISSAN MTF TL/JR (API GL-4+)',NULL),
(@gen,@hr16,'transmission_mt',NULL,'SAE 75W-80','NISSAN MTF TL/JR (API GL-4+)',NULL),
(@gen,@k9k ,'transmission_mt',NULL,'SAE 75W-80','NISSAN MTF TL/JR (API GL-4+)',NULL),
(@gen,NULL ,'rear_differential',NULL,'SAE 80W-90','NISSAN Differential Oil Hypoid Super GL-5','AWD models'),
(@gen,NULL ,'brake',NULL,NULL,'DOT 3','Brake & clutch'),
(@gen,NULL ,'ac_refrigerant',NULL,NULL,'HFC-134a (R-134a)',NULL),
(@gen,NULL ,'washer',4.5,NULL,NULL,NULL);

INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
(@gen,'wheel_lug',108,80,'Wheel nut tightening torque');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id=@gen;
