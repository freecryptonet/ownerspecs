-- mig 422: older BMW tyre batch (F22/F23 2-Series, F32/F33/F36 4-Series, pre-LCI) from
-- service-manual fitment (MY2016). Mapped by model+body+year (2016 = pre-LCI). psi*6.895≈kPa.
-- Asymmetric front/rear cold pressures captured per axle. Vendor-neutral sources.

-- 2 Series (F22 coupe / F23 convertible) — gens 211, 212
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW 2 Series (F22, F23)',1,0,NOW()); SET @f2:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (211,'front','normal',32.0,221,'205/50 R17'),(211,'rear','normal',36.0,248,'205/50 R17'),
  (212,'front','normal',33.0,227,'205/50 R17'),(212,'rear','normal',38.0,262,'205/50 R17');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@f2 FROM tire_pressures WHERE generation_id IN (211,212);

-- 4 Series pre-LCI (F32 coupe / F33 conv / F36 gran coupe) — gens 217, 219, 221
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW 4 Series (F32, F33, F36)',1,0,NOW()); SET @f4:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (217,'front','normal',32.0,221,'225/45 R18'),(217,'rear','normal',35.0,241,'225/45 R18'),
  (219,'front','normal',32.0,221,'225/45 R18'),(219,'rear','normal',39.0,269,'225/45 R18'),
  (221,'front','normal',32.0,221,'225/45 R18'),(221,'rear','normal',38.0,262,'225/45 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@f4 FROM tire_pressures WHERE generation_id IN (217,219,221);
