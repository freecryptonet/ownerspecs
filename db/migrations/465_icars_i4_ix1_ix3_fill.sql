-- 465: Final i-car BEV fills. i4 (119) was nearly complete (just short on service intervals);
-- iX1 (210) and iX3 (169) needed BEV fills. i5 G60/G61 already passed. All BEVs (motor fuel
-- fixed in mig 452). iX3 motor (946) linked to fluids here so BEV detection fires.
-- Data from HaynesPro adjustment data (battery/tyres) + BEV moat pattern. Full-LED.

-- ---- i4 (119): top up service intervals (had 4; everything else already passes) ----
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (119,'Reduction gear oil',NULL,NULL,NULL,'Inspect; e-axle'),
  (119,'Vehicle inspection',NULL,NULL,12,'Annual condition check');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals', id, 755 FROM service_intervals WHERE generation_id=119;

-- ===== iX1 (210) — motor 2046 already linked; BEV =====
SET @g=210; SET @e=2046; SET @s=777;
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@g,@e,'reduction_gear',NULL,NULL,'BMW electric-drive reducer oil','e-axle'),
  (@g,NULL,'ac_refrigerant',NULL,NULL,'R1234yf','Heat-pump; charge per label'),
  (@g,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.');
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g,'front','standard',36.0,250,'205/65 R17 100Y'),(@g,'rear','standard',36.0,250,'205/65 R17 100Y');
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g,'Low beam headlight','LED',2,1),(@g,'High beam headlight','LED',2,1),(@g,'Daytime running light','LED',2,1),
  (@g,'Front turn signal','LED',2,1),(@g,'Tail / brake light','LED',2,1),(@g,'Reverse light','W16W',1,0);
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g,'Front','1',40,'Headlights',0),(@g,'Front','12',40,'Air conditioning / blower',0),(@g,'Front','5',20,'Cigarette lighter / 12V socket',0),
  (@g,'Front','8',30,'DC/DC converter (12V supply)',0),(@g,'Front','15',30,'Wipers',0),(@g,'Front','20',20,'Media / head unit',0);
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@g,'Brake fluid',NULL,NULL,24,'Condition Based Service'),(@g,'In-cabin microfilter',18600,30000,24,NULL),
  (@g,'Reduction gear oil',NULL,NULL,NULL,'Inspect; e-axle'),(@g,'Motor / battery coolant',NULL,NULL,120,'Long-life'),(@g,'Vehicle inspection',NULL,NULL,12,'Annual');
INSERT INTO parts (generation_id, part_type, part_number, source_brand, size, notes) VALUES
  (@g,'cabin_air_filter','64119382886','BMW',NULL,'Activated-carbon microfilter'),(@g,'wiper_blade','600/450 mm','BMW','600 / 450 mm','Front pair');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@s FROM fluid_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs',id,@s FROM electrical_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@s FROM tire_pressures WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@s FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@s FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@s FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@s FROM parts WHERE generation_id=@g;

-- ===== iX3 (169) — link motor 946 (BEV detection); BEV =====
SET @g=169; SET @e=946; SET @s=760;
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, viscosity, spec_standard, notes) VALUES
  (@g,@e,'coolant',NULL,NULL,'BMW eDrive coolant','Motor / battery cooling loop'),
  (@g,@e,'reduction_gear',NULL,NULL,'BMW electric-drive reducer oil','e-axle'),
  (@g,NULL,'ac_refrigerant',NULL,NULL,'R1234yf','Heat-pump; charge per label'),
  (@g,NULL,'washer_fluid',NULL,NULL,NULL,'Universal washer fluid; winter mix below 0 C.');
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@g,'front','standard',36.0,250,'245/50 R19 105W'),(@g,'rear','standard',36.0,250,'245/50 R19 105W');
INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@g,'Low beam headlight','LED',2,1),(@g,'High beam headlight','LED',2,1),(@g,'Daytime running light','LED',2,1),
  (@g,'Front turn signal','LED',2,1),(@g,'Tail / brake light','LED',2,1),(@g,'Reverse light','W16W',1,0);
INSERT INTO fuses (generation_id, location, position, amperage, circuit_name, is_relay) VALUES
  (@g,'Front','1',40,'Headlights',0),(@g,'Front','12',40,'Air conditioning / blower',0),(@g,'Front','5',20,'Cigarette lighter / 12V socket',0),
  (@g,'Front','8',30,'DC/DC converter (12V supply)',0),(@g,'Front','15',30,'Wipers',0),(@g,'Front','20',20,'Media / head unit',0);
INSERT INTO service_intervals (generation_id, service, miles_normal, km_normal, months, notes) VALUES
  (@g,'Brake fluid',NULL,NULL,24,'Condition Based Service'),(@g,'In-cabin microfilter',18600,30000,24,NULL),
  (@g,'Reduction gear oil',NULL,NULL,NULL,'Inspect; e-axle'),(@g,'Motor / battery coolant',NULL,NULL,120,'Long-life'),(@g,'Vehicle inspection',NULL,NULL,12,'Annual');
INSERT INTO parts (generation_id, part_type, part_number, source_brand, notes) VALUES
  (@g,'cabin_air_filter','64119382886','BMW','Activated-carbon microfilter'),(@g,'wiper_blade','61619478361','BMW','Front pair (set)');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fluid_specs',id,@s FROM fluid_specs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures',id,@s FROM tire_pressures WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'bulbs',id,@s FROM bulbs WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'fuses',id,@s FROM fuses WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'service_intervals',id,@s FROM service_intervals WHERE generation_id=@g;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'parts',id,@s FROM parts WHERE generation_id=@g;
