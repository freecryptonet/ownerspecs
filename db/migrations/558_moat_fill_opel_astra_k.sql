-- mig 558 — moat-fill Opel Astra K (B16, gen 519) via browser HaynesPro (country EU). Facts only.
-- First EU-brand moat fill. New vendor-neutral source. GM-era engines (dexos / ACEA C3).
-- Engines (gen 519): petrol 1.6 SIDI turbo D16SHT/B16SHT (2203/2204); diesel 1.6 CDTi
--   D16DTH/D16DTI/B16DTR/B16DTH (2201/2202/2205/2206).
-- Backfill pending: tyre pressures (didn't parse), diesel coolant capacity, battery CCA, per-engine diesel torques.

SET NAMES utf8mb4;
SET @g := 519;
INSERT INTO sources (type, citation, public_link, is_public, retrieved_at, notes) VALUES
 ('workshop_manual','Workshop service manual — Opel Astra K',0,1,NOW(),'Vendor-neutral workshop service data (EU market). Facts only.');
SET @src := LAST_INSERT_ID();

-- FLUIDS ------------------------------------------------------------------------
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
 -- petrol 1.6 SIDI turbo
 (@g,2203,'engine_oil',5.50,'SAE 5W-30','dexos1 Gen 2','1.6 SIDI turbo. With-filter fill. Oil drain plug 14 N·m. Non-EU: ACEA C3 / A3/B3.'),
 (@g,2204,'engine_oil',5.50,'SAE 5W-30','dexos1 Gen 2','1.6 SIDI turbo. With-filter fill. Oil drain plug 14 N·m.'),
 (@g,2203,'coolant',6.30,NULL,'GM long-life (Dex-Cool class)','System capacity.'),
 (@g,2204,'coolant',6.30,NULL,'GM long-life (Dex-Cool class)','System capacity.'),
 -- diesel 1.6 CDTi
 (@g,2201,'engine_oil',5.00,'SAE 5W-30','ACEA C3 (dexos2)','1.6 CDTi. With-filter fill. Oil drain plug 25 N·m; oil filter drain plug 10 N·m.'),
 (@g,2202,'engine_oil',5.00,'SAE 5W-30','ACEA C3 (dexos2)','1.6 CDTi. With-filter fill. Oil drain plug 25 N·m; oil filter drain plug 10 N·m.'),
 (@g,2205,'engine_oil',5.00,'SAE 5W-30','ACEA C3 (dexos2)','1.6 CDTi. With-filter fill. Oil drain plug 25 N·m; oil filter drain plug 10 N·m.'),
 (@g,2206,'engine_oil',5.00,'SAE 5W-30','ACEA C3 (dexos2)','1.6 CDTi. With-filter fill. Oil drain plug 25 N·m; oil filter drain plug 10 N·m.'),
 -- gen-wide
 (@g,NULL,'brake',NULL,NULL,'DOT 4','Brake/clutch hydraulic fluid.');

-- TORQUES -----------------------------------------------------------------------
INSERT INTO torque_specs (generation_id, engine_id, fastener, torque_nm, notes) VALUES
 (@g,NULL,'wheel_bolt',140,'Do not use power tools to run the bolts in.'),
 (@g,2203,'cylinder_head_bolt',25,'1.6 SIDI turbo. Renew bolts. Stage 1: 25 N·m; stage 2: +90° (further angle stages).'),
 (@g,2204,'cylinder_head_bolt',25,'1.6 SIDI turbo. Renew bolts. Stage 1: 25 N·m; stage 2: +90°.'),
 (@g,2203,'oil_drain',14,'1.6 SIDI turbo. Renew the bolt.'),
 (@g,2204,'oil_drain',14,'1.6 SIDI turbo. Renew the bolt.'),
 (@g,2201,'oil_drain',25,'1.6 CDTi. Renew the plug. Oil filter drain plug 10 N·m.'),
 (@g,2202,'oil_drain',25,'1.6 CDTi. Renew the plug.'),
 (@g,2205,'oil_drain',25,'1.6 CDTi. Renew the plug.'),
 (@g,2206,'oil_drain',25,'1.6 CDTi. Renew the plug.');

-- ELECTRICAL --------------------------------------------------------------------
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES
 (@g,NULL,NULL,70,NULL);

-- FUSES — passenger-compartment fuse box --------------------------------------
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
 (@g,'cabin','2',40,'Blower motor control unit',0),
 (@g,'cabin','3',25,'Memory seat CU, driver seat adjustment switch',0),
 (@g,'cabin','4',20,'Cigarette lighter, accessory socket',0),
 (@g,'cabin','6',30,'Power window motors',0),
 (@g,'cabin','7',25,'Electronic brake control unit (EBCM)',0),
 (@g,'cabin','8',7,'Steering wheel heater control unit',0),
 (@g,'cabin','9',30,'Body control unit, door latch, door lock relay',0),
 (@g,'cabin','10',30,'Rear left/right power window motors',0),
 (@g,'cabin','11',20,'Sunroof control unit',0),
 (@g,'cabin','12',20,'Left headlight main beam, front right parking light',0),
 (@g,'cabin','13',25,'Seat heater',0),
 (@g,'cabin','14',7,'Rain/light sensor, camera control unit, mirror switch',0),
 (@g,'cabin','15',15,'Body control unit, door light, left daytime running light',0),
 (@g,'cabin','16',20,'Body control unit, left headlight, rear left fog light',0),
 (@g,'cabin','17',20,'Body control unit, sunshade, rear-view camera, right side',0),
 (@g,'cabin','18',20,'Body control unit, right headlight dipped beam',0),
 (@g,'cabin','19',7,'Data link connector',0),
 (@g,'cabin','20',10,'Supplemental restraint system (SRS)',0),
 (@g,'cabin','21',10,'HVAC control unit',0),
 (@g,'cabin','22',10,'Liftgate relay',0),
 (@g,'cabin','23',7,'Keyless entry control unit',0),
 (@g,'cabin','24',5,'Memory seat control unit',0),
 (@g,'cabin','25',2,'Steering wheel controls',0),
 (@g,'cabin','26',15,'Ignition switch / electronic steering column lock CU',0),
 (@g,'cabin','27',20,'Body control unit, door lock relay, automatic transmission',0),
 (@g,'cabin','28',5,'Audio system',0),
 (@g,'cabin','30',5,'Automatic transmission position indicator / control',0),
 (@g,'cabin','31',20,'Rear wiper motor',0),
 (@g,'cabin','32',20,'Automatic transmission',0),
 (@g,'cabin','33',10,'Alarm system',0),
 (@g,'cabin','34',7,'Parking assistance system control unit',0),
 (@g,'cabin','35',5,'Telematics',0),
 (@g,'cabin','36',10,'HVAC control unit',0),
 (@g,'cabin','37',20,'Radio, alarm control unit',0);

-- SPEC_SOURCES ------------------------------------------------------------------
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fluid_specs' AND ss.spec_id=fluid_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @src FROM torque_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='torque_specs' AND ss.spec_id=torque_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @src FROM electrical_specs WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='electrical_specs' AND ss.spec_id=electrical_specs.id AND ss.source_id=@src);
INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fuses', id, @src FROM fuses WHERE generation_id=@g
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='fuses' AND ss.spec_id=fuses.id AND ss.source_id=@src);
