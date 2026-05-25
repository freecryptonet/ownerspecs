-- mig 425: older German tyres batch 3 (BMW E93 3-conv, Mercedes E-Class W212, Audi A3 8V / A5 8T
-- / A7 4G) from service-manual fitment. Older BMW E-series sedans/coupes (E90/E92/E60/E63) have
-- NO Tire Fitment quick-lookup in this source → not fillable here. psi*6.895≈kPa. Vendor-neutral.

INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — BMW 3 Series (E90, E91, E92, E93)',1,0,NOW()); SET @e9:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (190,'front','normal',32.0,221,'225/40 R18'),(190,'rear','normal',34.0,234,'225/40 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@e9 FROM tire_pressures WHERE generation_id=190;

INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Mercedes-Benz E-Class (W212)',1,0,NOW()); SET @w212:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (308,'front','normal',35.0,241,'245/45 R17'),(308,'rear','normal',41.0,283,'245/45 R17');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@w212 FROM tire_pressures WHERE generation_id=308;

INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi A3 (8V)',1,0,NOW()); SET @a38v:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (269,'front','normal',41.0,283,'225/40 R18'),(269,'rear','normal',41.0,283,'225/40 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@a38v FROM tire_pressures WHERE generation_id=269;

INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi A5 (8T)',1,0,NOW()); SET @a58t:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (273,'front','normal',38.0,262,'245/40 R18'),(273,'rear','normal',41.0,283,'245/40 R18');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@a58t FROM tire_pressures WHERE generation_id=273;

INSERT INTO sources (type,citation,is_public,public_link,retrieved_at) VALUES ('service_manual','Workshop service manual — Audi A7 (4G)',1,0,NOW()); SET @a74g:=LAST_INSERT_ID();
INSERT INTO tire_pressures (generation_id,position,load_condition,psi,kpa,tire_size) VALUES
  (283,'front','normal',38.0,262,'255/40 R19'),(283,'rear','normal',41.0,283,'255/40 R19');
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id) SELECT 'tire_pressures',id,@a74g FROM tire_pressures WHERE generation_id=283;
