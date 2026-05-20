-- Add canonical trims for batch 11 + 12 gens so trim-detail + engine catalogue grow.

SET NAMES utf8mb4;

-- Engines
INSERT IGNORE INTO engines(code,display_name,displacement_cc,fuel,aspiration,valvetrain,cylinders,bore_mm,stroke_mm,compression) VALUES
  ('EA839','3.0 TFSI V6 turbo',2995,'petrol','turbo','DOHC',6,84.50,89.00,11.20),
  ('M256','3.0L I6 turbo (M256)',2999,'petrol','turbo','DOHC',6,83.00,92.30,10.50),
  ('M264','2.0L I4 turbo (M264)',1991,'petrol','turbo','DOHC',4,83.00,92.00,10.50),
  ('OM656','3.0L diesel I6 (OM656)',2925,'diesel','turbo','DOHC',6,82.00,92.30,15.00),
  ('MA2.0T','3.0L V6 turbo (Macan S)',2995,'petrol','turbo','DOHC',6,84.50,89.00,11.20),
  ('G2.5T','2.5L Smartstream turbo',2497,'petrol','turbo','DOHC',4,88.00,101.00,10.50),
  ('G3.5T','3.5L Smartstream V6 turbo',3470,'petrol','turbo','DOHC',6,92.00,87.00,10.50),
  ('FA24F','2.4L FA24F turbo (Subaru)',2387,'petrol','turbo','DOHC',4,94.00,86.00,10.60),
  ('e-SKYACTIV-G-3.3','3.3L e-Skyactiv-G I6',3283,'petrol','turbo','DOHC',6,86.00,94.20,11.00),
  ('PHEV-2.5','2.5L PHEV (CX-90)',2488,'petrol','na','DOHC',4,89.00,100.00,13.00),
  ('FA24D','2.4L FA24D NA (BRZ/86)',2387,'petrol','na','DOHC',4,94.00,86.00,12.50),
  ('PE-VPS','2.0L PE-VPS Skyactiv-G',1998,'petrol','na','DOHC',4,83.50,91.20,13.00),
  ('K20C2-HRV','2.0L K20C2 (HR-V)',1996,'petrol','na','DOHC',4,81.00,96.90,10.60),
  ('B4204T35','2.0L Drive-E T6/T8',1969,'petrol','superch+turbo','DOHC',4,82.00,93.20,10.30);

-- Transmissions
INSERT IGNORE INTO transmissions(type,gears,display_name) VALUES
  ('automatic',8,'8AT'),('automatic',9,'9G-TRONIC'),('dct',7,'PDK 7DCT'),
  ('cvt',NULL,'Subaru Lineartronic CVT'),('manual',6,'6MT'),('automatic',6,'6AT'),
  ('dct',7,'DQ381 7DSG');

-- Q7 4M trims (gen 90)
SET @gen := 90;
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'q7-3-0-tfsi-quattro','3.0 TFSI quattro',(SELECT id FROM engines WHERE code='EA839'),(SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1),2015,2019,333,440,5.7,250,2070,'awd'),
  (@gen,'q7-3-0-tdi-quattro','3.0 TDI quattro',(SELECT id FROM engines WHERE code='OM656'),(SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1),2015,2019,272,600,6.3,234,2105,'awd');

-- GLE V167 trims (gen 91)
SET @gen := 91;
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'gle-350','GLE 350 4MATIC',(SELECT id FROM engines WHERE code='M264'),(SELECT id FROM transmissions WHERE display_name='9G-TRONIC'),2019,2023,255,370,6.9,240,2185,'awd'),
  (@gen,'gle-450','GLE 450 4MATIC',(SELECT id FROM engines WHERE code='M256'),(SELECT id FROM transmissions WHERE display_name='9G-TRONIC'),2019,2023,362,500,5.7,250,2220,'awd'),
  (@gen,'gle-300d','GLE 300d 4MATIC',(SELECT id FROM engines WHERE code='OM656'),(SELECT id FROM transmissions WHERE display_name='9G-TRONIC'),2019,2023,245,500,7.2,225,2275,'awd');

-- Macan 95B trims (gen 92)
SET @gen := 92;
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'macan-s','Macan S',(SELECT id FROM engines WHERE code='MA2.0T'),(SELECT id FROM transmissions WHERE display_name='PDK 7DCT'),2014,2018,340,460,5.2,254,1875,'awd');

-- GV70 trims (gen 93)
SET @gen := 93;
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'gv70-2-5t-awd','GV70 2.5T AWD',(SELECT id FROM engines WHERE code='G2.5T'),(SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1),2021,NULL,300,422,5.9,240,1875,'awd'),
  (@gen,'gv70-3-5t-awd','GV70 3.5T AWD',(SELECT id FROM engines WHERE code='G3.5T'),(SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1),2021,NULL,375,520,4.9,240,2010,'awd');

-- Ascent WM trims (gen 94)
SET @gen := 94;
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'ascent-touring','Ascent Touring (FA24F)',(SELECT id FROM engines WHERE code='FA24F'),(SELECT id FROM transmissions WHERE display_name='Subaru Lineartronic CVT'),2019,2023,260,376,7.6,210,2018,'awd');

-- CX-90 KK trims (gen 95)
SET @gen := 95;
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'cx-90-3-3-turbo-s','CX-90 3.3 Turbo S',(SELECT id FROM engines WHERE code='e-SKYACTIV-G-3.3'),(SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1),2024,NULL,340,500,6.4,225,2173,'awd'),
  (@gen,'cx-90-phev','CX-90 PHEV',(SELECT id FROM engines WHERE code='PHEV-2.5'),(SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1),2024,NULL,323,500,6.7,225,2390,'awd');

-- BRZ ZD8 trims (look up by slug since IDs are auto-generated)
SET @gen := (SELECT id FROM generations WHERE slug='brz-zd8-coupe-2022-present');
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'brz-premium-6mt','BRZ Premium 6MT',(SELECT id FROM engines WHERE code='FA24D'),(SELECT id FROM transmissions WHERE display_name='6MT'),2022,NULL,228,249,6.1,226,1280,'rwd'),
  (@gen,'brz-limited-6at','BRZ Limited 6AT',(SELECT id FROM engines WHERE code='FA24D'),(SELECT id FROM transmissions WHERE display_name='6AT'),2022,NULL,228,249,6.6,226,1300,'rwd');

-- MX-5 ND trims
SET @gen := (SELECT id FROM generations WHERE slug='mx-5-nd-roadster-2015-present');
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'mx-5-2-0-6mt','MX-5 2.0 6MT',(SELECT id FROM engines WHERE code='PE-VPS'),(SELECT id FROM transmissions WHERE display_name='6MT'),2018,NULL,181,205,6.5,219,1058,'rwd'),
  (@gen,'mx-5-rf-2-0-6at','MX-5 RF 2.0 6AT',(SELECT id FROM engines WHERE code='PE-VPS'),(SELECT id FROM transmissions WHERE display_name='6AT'),2018,NULL,181,205,6.9,219,1140,'rwd');

-- HR-V RV3 trims
SET @gen := (SELECT id FROM generations WHERE slug='hr-v-rv3-suv-2023-present');
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'hr-v-ex-l-awd','HR-V EX-L AWD',(SELECT id FROM engines WHERE code='K20C2-HRV'),(SELECT id FROM transmissions WHERE display_name='Subaru Lineartronic CVT'),2023,NULL,158,187,9.4,177,1448,'awd');

-- XC90 II trims
SET @gen := (SELECT id FROM generations WHERE slug='xc90-ii-suv-2015-present');
INSERT INTO trims(generation_id,slug,name,engine_id,transmission_id,start_year,end_year,hp,torque_nm,zero_100_kmh_s,top_speed_kmh,curb_weight_kg,drive_wheel) VALUES
  (@gen,'xc90-t6-awd','XC90 T6 AWD',(SELECT id FROM engines WHERE code='B4204T35'),(SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1),2015,NULL,316,400,6.5,230,2105,'awd'),
  (@gen,'xc90-t8-recharge','XC90 T8 Recharge',(SELECT id FROM engines WHERE code='B4204T35'),(SELECT id FROM transmissions WHERE display_name='8AT' LIMIT 1),2015,NULL,455,709,5.3,230,2390,'awd');

SELECT 'Trims batch 11+12 done' AS status, (SELECT COUNT(*) FROM trims) AS total_trims;
