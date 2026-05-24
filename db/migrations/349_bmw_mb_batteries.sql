-- mig 349 — Phase D-3: BMW/Mercedes battery ingest
-- parseElectricalV2 fallback extracts 'Battery capacity N (Ah)' without 'Equipment code' header.
-- Synthesised equipment_code 'STD-NAh' when BMW/MB doesn't expose an OE code.

SET NAMES utf8mb4;


-- ──── Tiguan II (AD, AX, BT, BW, BJ) (1 gens · 10 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000050' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J1P', NULL, 44, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J2S', NULL, 51, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J0N', NULL, 61, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J1D', NULL, 72, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J1N', NULL, 75, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J0V', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J4J', NULL, 59, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J0S', NULL, 59, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J0T', NULL, 69, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (44, 'J2D', NULL, 68, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=44;

-- ──── Golf VIII (CD, CG) (1 gens · 5 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319007235' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (18, 'J0V', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (18, 'J0S', NULL, 59, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (18, 'J4J', NULL, 59, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (18, 'J2D', NULL, 68, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (18, 'J0H', NULL, 58, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=18;

-- ──── 5 (G60, G61, G90) (6 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018562' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (128, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=128;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (134, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=134;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (129, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=129;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (135, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=135;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (147, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=147;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (148, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=148;

-- ──── Civic X (FK, FC) (1 gens · 6 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001478' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (1, 'STD-48Ah', NULL, 48, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (1, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (1, 'STD-36Ah', NULL, 36, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (1, 'STD-47Ah', NULL, 47, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (1, 'STD-56Ah', NULL, 56, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (1, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=1;

-- ──── Civic XI (FE, FL) (1 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319010573' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (50, 'STD-45Ah', NULL, 45, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=50;

-- ──── Camry (XV70) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001688' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (2, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (2, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (2, 'STD-58Ah', NULL, 58, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=2;

-- ──── 3 (F30, F31, F80, Q30) (5 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_200000009' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (53, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (53, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=53;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (136, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (136, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=136;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (125, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (125, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=125;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (137, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (137, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=137;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (141, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (141, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=141;

-- ──── A (W177) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001679' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (315, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (315, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (315, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=315;

-- ──── B (W247) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319002954' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (318, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (318, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (318, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=318;

-- ──── C (W203, S203) (1 gens · 4 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_3610' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (302, 'STD-74Ah', NULL, 74, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (302, 'STD-95Ah', NULL, 95, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (302, 'STD-100Ah', NULL, 100, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (302, 'STD-62Ah', NULL, 62, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=302;

-- ──── C (W205) (2 gens · 4 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_301000084' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (304, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (304, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (304, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (304, 'STD-95Ah', NULL, 95, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=304;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (306, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (306, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (306, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (306, 'STD-95Ah', NULL, 95, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=306;

-- ──── E (W212) (1 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000087' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (308, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=308;

-- ──── E (W213) (1 gens · 6 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319000496' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (310, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (310, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (310, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (310, 'STD-95Ah', NULL, 95, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (310, 'STD-78Ah', NULL, 78, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (310, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=310;

-- ──── E Coupe/Cabrio (W238) (1 gens · 4 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001437' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (311, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (311, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (311, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (311, 'STD-95Ah', NULL, 95, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=311;

-- ──── E (W214) (1 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018555' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (312, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=312;

-- ──── 6 (E63, E64) (4 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_860' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (253, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (253, 'STD-110Ah', NULL, 110, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=253;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (254, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (254, 'STD-110Ah', NULL, 110, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=254;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (255, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (255, 'STD-110Ah', NULL, 110, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=255;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (256, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (256, 'STD-110Ah', NULL, 110, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=256;

-- ──── 6 (F06, F12, F13) (6 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000141' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (257, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (257, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=257;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (258, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (258, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=258;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (259, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (259, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=259;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (260, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (260, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=260;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (261, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (261, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=261;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (262, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (262, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=262;

-- ──── X2 (F39) (1 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001659' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (264, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (264, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=264;

-- ──── X2 (U10) (1 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319021717' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (265, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=265;

-- ──── iX (I20) (1 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319009108' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (266, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=266;

-- ──── Z4 (E85, E86) (2 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_890' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (243, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (243, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (243, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=243;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (244, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (244, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (244, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=244;

-- ──── Z4 (E89) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000124' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (245, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (245, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (245, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=245;

-- ──── Z4 (G29) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319003512' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (246, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (246, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (246, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=246;

-- ──── 8 (F91, F92, F93, G14, G15, G16) (6 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319003011' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (247, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=247;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (248, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=248;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (249, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=249;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (250, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=250;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (251, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=251;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (252, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=252;

-- ──── X4 (F26) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_304000002' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (230, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (230, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (230, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=230;

-- ──── X4 (F98, G02) (3 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001694' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (231, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (231, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (231, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=231;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (232, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (232, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (232, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=232;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (233, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (233, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (233, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=233;

-- ──── X6 (E71, E72) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000125' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (234, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (234, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (234, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=234;

-- ──── X6 (F16, F86) (1 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_304000001' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (235, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (235, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=235;

-- ──── 4 (F32, F33, F36, F82, F83) (8 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_301000031' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (217, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=217;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (218, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=218;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (219, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=219;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (220, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=220;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (221, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=221;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (222, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=222;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (223, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=223;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (224, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=224;

-- ──── 4 (G22, G23, G24, G26, G82, G83) (5 gens · 4 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319008746' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (225, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (225, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (225, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (225, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=225;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (226, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (226, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (226, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (226, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=226;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (227, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (227, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (227, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (227, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=227;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (228, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (228, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (228, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (228, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=228;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (229, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (229, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (229, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (229, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=229;

-- ──── X1 (E84) (1 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000120' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (207, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (207, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=207;

-- ──── X1 (F48) (1 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_318000006' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (208, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (208, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=208;

-- ──── X1 (U11) (2 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319017768' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (209, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (209, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (209, 'STD-50Ah', NULL, 50, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=209;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (210, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (210, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (210, 'STD-50Ah', NULL, 50, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=210;

-- ──── 2 (F22, F23, F87) (3 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_302000002' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (211, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (211, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (211, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=211;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (212, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (212, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (212, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=212;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (213, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (213, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (213, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=213;

-- ──── 2 Gran Coupe (F44) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319004912' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (214, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (214, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (214, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=214;

-- ──── 2 (G42, G87) (2 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319009165' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (215, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (215, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (215, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=215;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (216, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (216, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (216, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=216;

-- ──── 1 (E81, E82, E87, E88) (2 gens · 4 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_830' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (195, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (195, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (195, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (195, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=195;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (196, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (196, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (196, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (196, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=196;

-- ──── 1 (F20, F21) (2 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000239' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (197, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (197, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=197;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (198, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (198, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=198;

-- ──── 1 (F40) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319004645' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (199, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (199, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (199, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=199;

-- ──── 1 (F70) (1 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319022590' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (200, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (200, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=200;

-- ──── 7 (E65, E66, E67, E68) (1 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_800' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (201, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=201;

-- ──── 7 (F01, F02, F04) (1 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000073' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (202, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (202, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=202;

-- ──── 7 (G11, G12) (2 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_317000028' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (203, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (203, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (203, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=203;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (204, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (204, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (204, 'STD-60Ah', NULL, 60, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=204;

-- ──── 3 (E90, E91, E92, E93) (11 gens · 4 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_900' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (184, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (184, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (184, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (184, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=184;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (185, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (185, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (185, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (185, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=185;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (186, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (186, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (186, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (186, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=186;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (187, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (187, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (187, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (187, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=187;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (188, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (188, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (188, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (188, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=188;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (189, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (189, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (189, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (189, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=189;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (190, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (190, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (190, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (190, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=190;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (191, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (191, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (191, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (191, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=191;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (192, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (192, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (192, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (192, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=192;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (193, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (193, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (193, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (193, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=193;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (194, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (194, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (194, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (194, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=194;

-- ──── X5 (E70) (2 gens · 2 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_1000001' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (177, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (177, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=177;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (178, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (178, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=178;

-- ──── iX3 (G08) (1 gens · 1 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319018751' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (169, 'STD-50Ah', NULL, 50, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=169;

-- ──── X3 (E83) (2 gens · 4 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_840' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (170, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (170, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (170, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (170, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=170;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (171, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (171, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (171, 'STD-55Ah', NULL, 55, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (171, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=171;

-- ──── X3 (F25) (2 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_102000210' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (166, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (166, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (166, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=166;
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (167, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (167, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (167, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=167;

-- ──── X3 (G01) (1 gens · 3 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001442' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (60, 'STD-90Ah', NULL, 90, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (60, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (60, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=60;

-- ──── i4 (G26) (1 gens · 5 batteries) ────
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319009109' ORDER BY id DESC LIMIT 1);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (119, 'STD-50Ah', NULL, 50, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (119, 'STD-70Ah', NULL, 70, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (119, 'STD-80Ah', NULL, 80, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (119, 'STD-92Ah', NULL, 92, NULL);
INSERT IGNORE INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps) VALUES (119, 'STD-105Ah', NULL, 105, NULL);
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id=119;

-- Audit
SELECT COUNT(DISTINCT generation_id) AS gens_with_electrical FROM electrical_specs;