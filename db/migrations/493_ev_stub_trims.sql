-- 493: add trims to 7 EV "stub" gens that had 0 trims (empty variant tables).
--
-- These gens already had moat data (fluids/coolant/brake/tires/service/12V) — the
-- only gap was trims. EVs are modeled as trims (electric-motor engine_id + peak
-- hp/torque/drive); single-speed reducer = transmission id 71. Peak power per the
-- EV rule (headline peak, not continuous). Trim perf is catalog data (not citation-
-- gated). Most motor engines already existed; the BMW iX (i20) had none and the i7
-- M70 motor was missing — created below with descriptive codes (EV motors have no
-- public sales code, per project convention; e.g. existing "iX1-eDU").
-- ev-database.org / wheel-size used only as research aids, never cited.

-- ---- create the 4 missing electric-motor engines ----
INSERT INTO engines (code, slug, display_name, displacement_cc, fuel)
SELECT 'iX-xDrive40','ix-xdrive40','BMW iX xDrive40 electric drive (240 kW)',0,'electric' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM engines WHERE code='iX-xDrive40');
INSERT INTO engines (code, slug, display_name, displacement_cc, fuel)
SELECT 'iX-xDrive50','ix-xdrive50','BMW iX xDrive50 electric drive (385 kW)',0,'electric' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM engines WHERE code='iX-xDrive50');
INSERT INTO engines (code, slug, display_name, displacement_cc, fuel)
SELECT 'iX-M60','ix-m60','BMW iX M60 electric drive (455 kW)',0,'electric' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM engines WHERE code='iX-M60');
INSERT INTO engines (code, slug, display_name, displacement_cc, fuel)
SELECT 'i7-M70','i7-m70','BMW i7 M70 xDrive electric drive (485 kW)',0,'electric' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM engines WHERE code='i7-M70');

-- ---- trims (idempotent on slug) ----
-- helper pattern: INSERT ... SELECT <vals> WHERE NOT EXISTS(slug in gen)
-- i7 G70 (206)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 206,'i7-edrive50','i7 eDrive50 (449 Hp)',1117,71,2022,449,650,'RWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=206 AND slug='i7-edrive50');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 206,'i7-xdrive60','i7 xDrive60 (544 Hp)',1118,71,2022,544,745,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=206 AND slug='i7-xdrive60');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 206,'i7-m70-xdrive','i7 M70 xDrive (660 Hp)',(SELECT id FROM engines WHERE code='i7-M70'),71,2023,660,1015,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=206 AND slug='i7-m70-xdrive');

-- iX i20 (266)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 266,'ix-xdrive40','iX xDrive40 (326 Hp)',(SELECT id FROM engines WHERE code='iX-xDrive40'),71,2021,326,630,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=266 AND slug='ix-xdrive40');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 266,'ix-xdrive50','iX xDrive50 (516 Hp)',(SELECT id FROM engines WHERE code='iX-xDrive50'),71,2021,516,765,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=266 AND slug='ix-xdrive50');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 266,'ix-m60','iX M60 (619 Hp)',(SELECT id FROM engines WHERE code='iX-M60'),71,2022,619,1015,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=266 AND slug='ix-m60');

-- iX1 U11 (210)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 210,'ix1-xdrive30','iX1 xDrive30 (313 Hp)',2046,71,2022,313,494,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=210 AND slug='ix1-xdrive30');

-- iX3 G08 (169)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 169,'ix3','iX3 (286 Hp)',946,71,2020,286,400,'RWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=169 AND slug='ix3');

-- Nissan Ariya FE0 (163)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 163,'ariya-fwd','Ariya (218 Hp) FWD',2045,71,2022,218,300,'FWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=163 AND slug='ariya-fwd');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 163,'ariya-e-4orce-awd','Ariya e-4ORCE (389 Hp) AWD',2045,71,2022,389,600,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=163 AND slug='ariya-e-4orce-awd');

-- Nissan Leaf ZE1 (319)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 319,'leaf-40','Leaf 40 kWh (147 Hp)',2026,71,2018,147,320,'FWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=319 AND slug='leaf-40');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 319,'leaf-e-plus-62','Leaf e+ 62 kWh (214 Hp)',2026,71,2019,214,340,'FWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=319 AND slug='leaf-e-plus-62');

-- Audi Q8 e-tron (292)
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 292,'50-quattro','50 e-tron quattro (309 Hp)',1715,71,2023,309,540,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=292 AND slug='50-quattro');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 292,'55-quattro','55 e-tron quattro (402 Hp)',1716,71,2023,402,664,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=292 AND slug='55-quattro');
INSERT INTO trims (generation_id, slug, name, engine_id, transmission_id, start_year, hp, torque_nm, drive_wheel)
SELECT 292,'sq8-e-tron','SQ8 e-tron (496 Hp)',1717,71,2023,496,973,'AWD' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM trims WHERE generation_id=292 AND slug='sq8-e-tron');
