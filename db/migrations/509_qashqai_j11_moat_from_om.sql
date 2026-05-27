-- mig 509: moat fill for Nissan Qashqai II (J11) gen 344 from the Nissan Qashqai (J11)
-- Owner's Manual (Nissan-owned CDN PDF, www-europe.nissan-cdn.net — public_link=1).
-- Free public OEM source per Tim 2026-05-27.
-- This is the FACELIFT J11 OM (HR13DDT 1.3 DIG-T engine), which our scraped trim lineup
-- lacks; HR13DDT is a genuine J11 engine, added here so its engine oil/coolant render.
-- The pre-facelift petrol engines' (HRA2DDT/MR16DDT) oil/coolant need the pre-facelift OM.
-- Chassis-shared drivetrain fluids + torques apply across the J11 and are filled gen-wide /
-- scoped. Bulb/fuse/tyre tables are image-based (startmycar fuse follow-up).

SET @gen := 344;
SET @src := 972;

UPDATE sources
   SET citation='Nissan Qashqai (J11) Owner''s Manual', public_link=1,
       url='https://www-europe.nissan-cdn.net/content/dam/Nissan/za/OWNERS/OwnerManuals/Nissan%20Qashqai%20Manual.pdf'
 WHERE id=@src;

UPDATE generations SET fuel_tank_l=55.0 WHERE id=@gen AND fuel_tank_l IS NULL;

-- HR13DDT 1.3 DIG-T (facelift J11 engine; real Nissan/Daimler M282 1332cc turbo)
INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders)
VALUES ('HR13DDT','Nissan HR13DDT 1.3 DIG-T 1.3L Turbo I4',1332,'petrol','turbo',4);
SET @hr13 := (SELECT id FROM engines WHERE code='HR13DDT' LIMIT 1);
SET @hra2 := 2056; SET @mr16 := 2054; SET @mr20 := 2053; SET @k9k := 2025; SET @r9m := 2055;

DELETE FROM spec_sources WHERE spec_table='fluid_specs'
  AND spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=@gen);
DELETE FROM fluid_specs WHERE generation_id=@gen;

INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
(@gen,@hr13,'engine_oil',5.4,'5W-30','ACEA C3 RN17 (0W-20 C5 alt)','With filter change'),
(@gen,@hr13,'coolant',8.1,NULL,'NISSAN Genuine Engine Coolant L255N','Xtronic (MT 7.4 L)'),
-- chassis-shared drivetrain fluids (not engine-scoped -> render gen-wide)
(@gen,NULL,'transfer_case',0.31,'SAE 75W-90','API GL-5 (NISSAN Differential Fluid Synthetic)','4WD Xtronic'),
(@gen,NULL,'rear_differential',0.50,'SAE 75W-80','API GL-5 (NISSAN Hypoid fluid S1)','4WD Xtronic'),
(@gen,NULL,'brake',NULL,NULL,'DOT 4 (FMVSS 116)','Brake & clutch'),
(@gen,NULL,'ac_refrigerant',NULL,NULL,'HFO-1234yf (EU) / HFC-134a','550 g charge'),
(@gen,NULL,'washer',NULL,NULL,NULL,NULL),
-- CVT (Xtronic) scoped to the petrol engines that use it
(@gen,@hra2,'transmission_cvt',NULL,NULL,'NISSAN NS-3 CVT Fluid',NULL),
(@gen,@mr16,'transmission_cvt',NULL,NULL,'NISSAN NS-3 CVT Fluid',NULL),
(@gen,@mr20,'transmission_cvt',NULL,NULL,'NISSAN NS-3 CVT Fluid',NULL),
-- Manual transaxle gear oil (chassis spec 1.35 L) scoped to the manual engines
(@gen,@hra2,'transmission_mt',1.35,'SAE 75W','NISSAN MT-XZ Gear Oil NFX',NULL),
(@gen,@mr16,'transmission_mt',1.35,'SAE 75W','NISSAN MT-XZ Gear Oil NFX',NULL),
(@gen,@k9k ,'transmission_mt',1.35,'SAE 75W','NISSAN MT-XZ Gear Oil NFX',NULL),
(@gen,@r9m ,'transmission_mt',1.35,'SAE 75W','NISSAN MT-XZ Gear Oil NFX',NULL);

INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes) VALUES
(@gen,'wheel_lug',113,83,'Road wheel nut'),
(@gen,'oil_drain_plug',50,37,'HR13DDT engine'),
(@gen,'oil_filter',32,24,'2/3 turn after contact');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=@gen;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id=@gen;
