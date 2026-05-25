-- mig 410: seed tire_pressures for 5 thin Nissan gens from workshop wheels-&-tyres data.
-- psi = bar*14.5038 (1dp), kpa = bar*100. load_condition 'normal'. Cited to each chassis's
-- existing "Nissan <Model> (<code>) Service Manual" source (created in mig 408/409).
-- Micra K14 (gen 320) exposed only a spare size (no front/rear) → omitted rather than guessed.

-- ── Qashqai J12 (165): all OE sizes 2.3 front / 2.1 rear; spare 4.2 ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan Qashqai (J12) Service Manual');
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (165,'front','normal',33.4,230,'215/65 R17'),(165,'rear','normal',30.5,210,'215/65 R17'),
  (165,'front','normal',33.4,230,'235/55 R18'),(165,'rear','normal',30.5,210,'235/55 R18'),
  (165,'front','normal',33.4,230,'235/50 R19'),(165,'rear','normal',30.5,210,'235/50 R19'),
  (165,'front','normal',33.4,230,'235/45 R20'),(165,'rear','normal',30.5,210,'235/45 R20'),
  (165,'spare','normal',60.9,420,'T155/90 R17');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id=165;

-- ── Juke F16 (162): 2.2 front / 2.7 rear; spare 4.2 ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan Juke (F16) Service Manual');
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (162,'front','normal',31.9,220,'215/60 R17'),(162,'rear','normal',39.2,270,'215/60 R17'),
  (162,'front','normal',31.9,220,'225/45 R19'),(162,'rear','normal',39.2,270,'225/45 R19'),
  (162,'spare','normal',60.9,420,'T145/90 R16');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id=162;

-- ── X-Trail T33 (164): 2.3 front / 2.1 rear ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan X-Trail (T33) Service Manual');
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (164,'front','normal',33.4,230,'235/60 R18'),(164,'rear','normal',30.5,210,'235/60 R18'),
  (164,'front','normal',33.4,230,'235/55 R19'),(164,'rear','normal',30.5,210,'235/55 R19'),
  (164,'front','normal',33.4,230,'255/45 R20'),(164,'rear','normal',30.5,210,'255/45 R20');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id=164;

-- ── Leaf ZE1 (319): 2.5 front / 2.5 rear ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan Leaf (ZE1) Service Manual');
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (319,'front','normal',36.3,250,'205/55 R16'),(319,'rear','normal',36.3,250,'205/55 R16'),
  (319,'front','normal',36.3,250,'215/50 R17'),(319,'rear','normal',36.3,250,'215/50 R17');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id=319;

-- ── Ariya FE0 (163): 2.6 (19") / 2.4 (20") front=rear ──
SET @src := (SELECT id FROM sources WHERE citation='Nissan Ariya (FE0) Service Manual');
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (163,'front','normal',37.7,260,'235/55 R19'),(163,'rear','normal',37.7,260,'235/55 R19'),
  (163,'front','normal',34.8,240,'255/45 R20'),(163,'rear','normal',34.8,240,'255/45 R20');
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'tire_pressures', id, @src FROM tire_pressures WHERE generation_id=163;
