-- Backfill procedures for 6 mainstream gens that were missing them.

SET NAMES utf8mb4;

-- Civic FE (gen 50)
SET @gen := 50; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Honda Civic XI (FE) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Honda Civic XI (FE) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Honda Civic XI (FE) Owner''s Manual' LIMIT 1);
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-life-reset','Maintenance Minder reset — Civic (FE)','Ignition ON · MENU on steering wheel → Vehicle Settings → Reset Maintenance Info. Hold SEL/RESET.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-calibration','TPMS calibration — Civic (FE)','Indirect TPMS. Set tires cold to door placard. Settings → TPMS → Calibrate. Drive 30+ min above 30 mph.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Civic (FE)','Negative-first, positive-last. Power-window auto-up needs re-init.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Civic (FE)','Standard 4-clamp procedure on jump terminal under hood.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Mazda 3 BM (gen 51)
SET @gen := 51; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Mazda 3 III (BM) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Mazda 3 III (BM) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Mazda 3 III (BM) Owner''s Manual' LIMIT 1);
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-data-reset','Engine Oil Data reset — Mazda 3 (BM)','Ignition ON · INFO long-press on Engine Oil Data screen → Yes.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-set','TPMS set — Mazda 3 (BM)','Direct TPMS on US. Settings → TPMS → Set. Drive 10 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Mazda 3 (BM)','Negative-first, positive-last. i-stop may relearn over a few cycles.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Mazda 3 (BM)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Corolla E170 (gen 52)
SET @gen := 52; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Toyota Corolla XI (E170) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Toyota Corolla XI (E170) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Toyota Corolla XI (E170) Owner''s Manual' LIMIT 1);
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'maintenance_reminder_reset','maintenance-reset','Maintenance reminder reset — Corolla (E170)','Ignition OFF · trip A displayed · ignition ON · hold trip until ‘000000’.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-reset','TPMS reset — Corolla (E170)','Direct TPMS. Hold TPMS button until light blinks 3×. Drive 20 min.\n','• Tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Corolla (E170)','Negative-first, positive-last. Re-init power windows after.\n','• 10 mm wrench.','• Positive first.'),
(@gen,'jump_start','jump-start','Jump-start — Corolla (E170)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- BMW 3 Series F30 (gen 53)
SET @gen := 53; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','BMW 3 Series (F30) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='BMW 3 Series (F30) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='BMW 3 Series (F30) Owner''s Manual' LIMIT 1);
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'cbs_reset','cbs-reset','Condition-Based Service reset — 3 Series (F30)','iDrive → Vehicle status → Service requirements → select item → Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-reset','RDC / TPMS reset — 3 Series (F30)','iDrive → Vehicle settings → Tyre pressure monitor → Reset. Drive 10 min.\n','• None.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — 3 Series (F30)','Battery in trunk. Negative at IBS sensor first. ISTA registration required.\n','• 10 mm wrench, ISTA.','• Skipping registration.'),
(@gen,'jump_start','jump-start','Jump-start — 3 Series (F30)','Engine-bay jump posts (red +, ground stud). Never to trunk battery negative.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Ford Explorer U625 (gen 54)
SET @gen := 54; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Ford Explorer VI (U625) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Ford Explorer VI (U625) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Ford Explorer VI (U625) Owner''s Manual' LIMIT 1);
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-life-reset','Oil Life reset — Explorer (U625)','SYNC4 → Settings → Vehicle → Oil Life Reset.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-procedure','TPMS training — Explorer (U625)','Direct TPMS with training: cycle ignition, press brake 3×, hold horn, deflate-inflate each tire L-front clockwise.\n','• TPMS tool or magnet, tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Explorer (U625)','Negative-first, positive-last. After: throttle relearn (ignition ON 30 s, OFF 30 s).\n','• 10 mm wrench.','• Skipping throttle relearn.'),
(@gen,'jump_start','jump-start','Jump-start — Explorer (U625)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

-- Chevy Equinox L1U (gen 55)
SET @gen := 55; INSERT INTO sources(type,citation,retrieved_at,is_public) SELECT 'oem_manual','Chevrolet Equinox III (L1U) Owner''s Manual',NOW(),1 WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Chevrolet Equinox III (L1U) Owner''s Manual'); SET @src := (SELECT id FROM sources WHERE citation='Chevrolet Equinox III (L1U) Owner''s Manual' LIMIT 1);
INSERT INTO procedures(generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes) VALUES
(@gen,'oil_life_reset','oil-life-reset','Oil Life reset — Equinox (L1U)','DIC → Vehicle Information → Remaining Oil Life → hold SET/CLR.\n','• None.','• Reset before service.'),
(@gen,'tpms_relearn','tpms-relearn','TPMS sensor relearn — Equinox (L1U)','GM canonical: door lock hold → horn → cycle L-front → R-front → R-rear → L-rear (deflate each).\n','• TPMS tool / magnet, tire gauge.','• Hot pressures.'),
(@gen,'battery_disconnect_order','battery-disconnect','Battery disconnect — Equinox (L1U)','Negative-first, positive-last. After replacement, BMS-reset with GDS2.\n','• 10 mm wrench, GDS2.','• Skipping BMS reset.'),
(@gen,'jump_start','jump-start','Jump-start — Equinox (L1U)','Standard 4-clamp procedure.\n','• Jumper cables.','• Clamping to dead negative.');
INSERT IGNORE INTO spec_sources(spec_table,spec_id,source_id) SELECT 'procedures',id,@src FROM procedures WHERE generation_id=@gen;

SELECT 'Backfill 049 done' AS status, (SELECT COUNT(*) FROM procedures) AS procs;
