-- mig 341 — ingest_extras: Q5 (FY) (gen_id 82)
-- Crawl source: scrapers/output/haynespro-exhaustive-q5-fy-2026-05-24.json
-- 156 torques · 8 batteries · 32 procedures · 629 intervals

SET NAMES utf8mb4;

-- 1. HaynesPro source row (re-uses existing if present)
SET @s_haynes := (SELECT id FROM sources WHERE url = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001449' ORDER BY id DESC LIMIT 1);

-- 2. torque_specs (156 rows)
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Valve cover', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Valve cover');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolts A)', 15, 11, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolts A)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Engine oil drain plug', 30, 22, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Engine oil drain plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Oil filter', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Oil filter');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Without combustion chamber pressure sensor)', 17, 13, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Without combustion chamber pressure sensor)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'With combustion chamber pressure sensor)', 12, 9, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'With combustion chamber pressure sensor)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Camshaft position sensor', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Camshaft position sensor');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Oxygen sensor', 55, 41, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Oxygen sensor');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Alternator', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Alternator');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Camshaft gearwheel', 100, 74, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Camshaft gearwheel');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Stud bolt)', 15, 11, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Stud bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Nut)', 20, 15, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Nut)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Timing cover', 12, 9, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Timing cover');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Fuel rail', 20, 15, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Fuel rail');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Nut)', 95, 70, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Nut)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bracket)', 20, 15, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bracket)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Turbocharger oil supply line (to turbocharger)', 16, 12, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Turbocharger oil supply line (to turbocharger)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the seals)', 30, 22, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the seals)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the seal)', 14, 10, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the seal)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the O-ring)', 10, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the O-ring)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'EGR valve', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'EGR valve');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Manual transmission filler plug', 45, 33, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Manual transmission filler plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Manual transmission drain plug', 45, 33, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Manual transmission drain plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the bolt)', 4, 3, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Steel bolts)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Steel bolts)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Tighten, starting from the centre and working outwards)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Tighten, starting from the centre and working outwards)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'All bolts)', 5, 4, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'All bolts)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the seal)', 30, 22, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the seal)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Oxygen sensor', 52, 38, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Oxygen sensor');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'NOx sensor', 52, 38, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'NOx sensor');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'To drive plate)', 60, 44, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'To drive plate)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'High-pressure pump gearwheel', 95, 70, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'High-pressure pump gearwheel');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Turbocharger oil supply line (to turbocharger)', 22, 16, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Turbocharger oil supply line (to turbocharger)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the seal)', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the seal)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the gasket)', 14, 10, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the gasket)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the O-ring)', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the O-ring)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the filler plug)', 35, 26, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the filler plug)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'If the gasket is damaged or stretched, renew it)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'If the gasket is damaged or stretched, renew it)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Metal sump)', 30, 22, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Metal sump)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the O-ring)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the O-ring)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the seal)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the seal)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Starter/alternator', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Starter/alternator');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'With sliding bushes)', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'With sliding bushes)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Check tightening)', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Check tightening)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Check tightening)', 22, 16, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Check tightening)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the seal)', 22, 16, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the seal)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'High-pressure fuel pipe (fuel injector side)', 28, 21, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'High-pressure fuel pipe (fuel injector side)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'High-pressure fuel pipe (fuel rail side)', 28, 21, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'High-pressure fuel pipe (fuel rail side)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'High-pressure fuel pipe (fuel pump side)', 28, 21, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'High-pressure fuel pipe (fuel pump side)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the bolt)', 50, 37, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Tighten the bolts in a criss-cross pattern)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Tighten the bolts in a criss-cross pattern)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Stud bolt)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Stud bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolts)', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolts)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the gasket)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the gasket)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Steel)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Steel)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Nut)', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Nut)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Without pressure sensor)', 17, 13, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Without pressure sensor)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'With pressure sensor)', 12, 9, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'With pressure sensor)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Turbocharger oil supply line', 16, 12, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Turbocharger oil supply line');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Turbocharger oil return line', 14, 10, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Turbocharger oil return line');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Differential filler plug', 16, 12, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Differential filler plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Differential drain plug', 16, 12, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Differential drain plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolts A)', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolts A)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Nut)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Nut)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Stud bolt)', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Stud bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Threads and contact surface lightly oiled)', 27, 20, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Threads and contact surface lightly oiled)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Knock sensor', 22, 16, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Knock sensor');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Coat the thread with high-temperature grease)', 60, 44, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Coat the thread with high-temperature grease)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Left-hand thread)', 35, 26, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Left-hand thread)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the chain tensioner, if removed)', 85, 63, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the chain tensioner, if removed)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolts A)', 20, 15, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolts A)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolt B)', 12, 9, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolt B)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Balance shaft chain tensioner guide', 20, 15, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Balance shaft chain tensioner guide');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Timing chain tensioner', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Timing chain tensioner');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Timing chain tensioner guide', 20, 15, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Timing chain tensioner guide');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Upper)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Upper)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Lower)', 20, 15, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Lower)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Left-hand thread)', 17, 13, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Left-hand thread)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the O-ring)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the O-ring)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'To engine block)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'To engine block)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'To turbocharger)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'To turbocharger)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Oil pump chain tensioner', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Oil pump chain tensioner');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the filler plug)', 15, 11, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the filler plug)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the drain plug)', 15, 11, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the drain plug)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Tighten the bolts until full surface contact is made)', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Tighten the bolts until full surface contact is made)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Glow plugs', 12, 9, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Glow plugs');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Coat the thread with high-temperature grease)', 52, 38, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Coat the thread with high-temperature grease)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Camshaft gearwheel', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Camshaft gearwheel');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Balance shaft gearwheel', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Balance shaft gearwheel');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Steel bolts)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Steel bolts)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Fuel rail', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Fuel rail');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the bolts)', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the bolts)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Stud bolt)', 10, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Stud bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Stud bolt)', 14, 10, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Stud bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the filler plug)', 30, 22, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the filler plug)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the bolts)', 60, 44, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the bolts)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the filler plug)', 27, 20, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the filler plug)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the drain plug)', 12, 9, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the drain plug)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Differential, front, filler plug', 27, 20, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Differential, front, filler plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Differential, front, drain plug', 10, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Differential, front, drain plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Differential, rear, filler plug', 15, 11, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Differential, rear, filler plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Differential, rear, drain plug', 15, 11, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Differential, rear, drain plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Aluminium valve cover)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Aluminium valve cover)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Plastic valve cover)', 5, 4, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Plastic valve cover)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'With starter/alternator)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'With starter/alternator)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'With alternator)', 30, 22, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'With alternator)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Exhaust manifold', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Exhaust manifold');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Coolant pump pulley', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Coolant pump pulley');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolt)', 10, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Oxygen sensor', 60, 44, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Oxygen sensor');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Balance shaft chain tensioner', 85, 63, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Balance shaft chain tensioner');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Timing chain guide', 20, 15, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Timing chain guide');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Timing cover, upper section', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Timing cover, upper section');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Inlet manifold', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Inlet manifold');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Coolant pump', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Coolant pump');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Coat the studs/bolts with high-temperature grease)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Coat the studs/bolts with high-temperature grease)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Differential, rear, level plug', 15, 11, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Differential, rear, level plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolts A)', 10, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolts A)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Spark plugs', 30, 22, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Spark plugs');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Turbocharger oil supply line', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Turbocharger oil supply line');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Turbocharger oil return line', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Turbocharger oil return line');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Differential filler plug', 15, 11, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Differential filler plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Differential drain plug', 15, 11, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Differential drain plug');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the drain plug)', 35, 26, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the drain plug)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolt)', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the gasket)', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the gasket)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Nuts)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Nuts)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Studs)', 22, 16, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Studs)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the seal)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the seal)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Ancillary drive belt idler pulley', 30, 22, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Ancillary drive belt idler pulley');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Exhaust manifold', 8, 6, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Exhaust manifold');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the seal)', 35, 26, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the seal)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Camshaft position sensor', 4, 3, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Camshaft position sensor');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Nuts)', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Nuts)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Studs)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Studs)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Check tightening)', 3, 2, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Check tightening)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Ancillary drive belt tensioner', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Ancillary drive belt tensioner');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the seals)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the seals)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the nut)', 90, 66, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the nut)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'High-pressure pump', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'High-pressure pump');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Renew the studs)', 20, 15, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Renew the studs)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Lower section, metal sump)', 30, 22, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Lower section, metal sump)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Steel bolts)', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Steel bolts)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolt)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Nut)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Nut)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Stud bolt)', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Stud bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Knock sensor', 25, 18, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Knock sensor');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Timing chain tensioner guide', 23, 17, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Timing chain tensioner guide');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Bolts A)', 3, 2, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Bolts A)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Upper section)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Upper section)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Apply thread-locking compound)', 85, 63, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Apply thread-locking compound)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Stud bolt)', 22, 16, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Stud bolt)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Lubricate the O-ring with clean engine oil)', 9, 7, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Lubricate the O-ring with clean engine oil)');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Tyre pressure sensor', 4, 3, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Tyre pressure sensor');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Wheel bolts', 140, 103, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Wheel bolts');
INSERT INTO torque_specs (generation_id, fastener, torque_nm, torque_ftlb, notes)
SELECT 82, 'Used part)', 35, 26, 'HaynesPro adjustmentData'
WHERE NOT EXISTS (SELECT 1 FROM torque_specs WHERE generation_id = 82 AND fastener = 'Used part)');

-- 3. electrical_specs (8 rows)
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)
SELECT 82, 'J1L', NULL, 61, NULL
WHERE NOT EXISTS (SELECT 1 FROM electrical_specs WHERE generation_id = 82 AND battery_group = 'J1L');
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)
SELECT 82, 'J2D', NULL, 68, NULL
WHERE NOT EXISTS (SELECT 1 FROM electrical_specs WHERE generation_id = 82 AND battery_group = 'J2D');
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)
SELECT 82, 'J0L', NULL, 70, NULL
WHERE NOT EXISTS (SELECT 1 FROM electrical_specs WHERE generation_id = 82 AND battery_group = 'J0L');
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)
SELECT 82, 'J1N', NULL, 75, NULL
WHERE NOT EXISTS (SELECT 1 FROM electrical_specs WHERE generation_id = 82 AND battery_group = 'J1N');
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)
SELECT 82, 'J0R', NULL, 80, NULL
WHERE NOT EXISTS (SELECT 1 FROM electrical_specs WHERE generation_id = 82 AND battery_group = 'J0R');
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)
SELECT 82, 'J0B', NULL, 92, NULL
WHERE NOT EXISTS (SELECT 1 FROM electrical_specs WHERE generation_id = 82 AND battery_group = 'J0B');
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)
SELECT 82, 'J0P', NULL, 105, NULL
WHERE NOT EXISTS (SELECT 1 FROM electrical_specs WHERE generation_id = 82 AND battery_group = 'J0P');
INSERT INTO electrical_specs (generation_id, battery_group, cca, ah, alternator_amps)
SELECT 82, 'J0Z', NULL, 110, NULL
WHERE NOT EXISTS (SELECT 1 FROM electrical_specs WHERE generation_id = 82 AND battery_group = 'J0Z');

-- 4. service_intervals (629 interval headers; no per-service items yet)
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '15,000 km/12 months', 15000, 9321, 12, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '15,000 km/12 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '30,000 km/24 months', 30000, 18641, 24, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '30,000 km/24 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '45,000 km/36 months', 45000, 27962, 36, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '45,000 km/36 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '60,000 km/48 months', 60000, 37282, 48, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '60,000 km/48 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '75,000 km/60 months', 75000, 46603, 60, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '75,000 km/60 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '90,000 km/72 months', 90000, 55923, 72, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '90,000 km/72 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '105,000 km/84 months', 105000, 65244, 84, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '105,000 km/84 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '120,000 km/96 months', 120000, 74565, 96, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '120,000 km/96 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '135,000 km/108 months', 135000, 83885, 108, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '135,000 km/108 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '150,000 km/120 months', 150000, 93206, 120, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '150,000 km/120 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '165,000 km/132 months', 165000, 102526, 132, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '165,000 km/132 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '180,000 km/144 months', 180000, 111847, 144, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '180,000 km/144 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '195,000 km/156 months', 195000, 121167, 156, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '195,000 km/156 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '210,000 km/168 months', 210000, 130488, 168, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '210,000 km/168 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '225,000 km/180 months', 225000, 139808, 180, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '225,000 km/180 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '240,000 km/192 months', 240000, 149129, 192, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '240,000 km/192 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '255,000 km/204 months', 255000, 158450, 204, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '255,000 km/204 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '270,000 km/216 months', 270000, 167770, 216, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '270,000 km/216 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '285,000 km/228 months', 285000, 177091, 228, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '285,000 km/228 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '300,000 km/240 months', 300000, 186411, 240, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '300,000 km/240 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '315,000 km/252 months', 315000, 195732, 252, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '315,000 km/252 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '330,000 km/264 months', 330000, 205052, 264, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '330,000 km/264 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '345,000 km/276 months', 345000, 214373, 276, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '345,000 km/276 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '360,000 km/288 months', 360000, 223694, 288, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '360,000 km/288 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '375,000 km/300 months', 375000, 233014, 300, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '375,000 km/300 months');
INSERT INTO service_intervals (generation_id, service, km_normal, miles_normal, months, notes)
SELECT 82, '390,000 km/312 months', 390000, 242335, 312, 'HaynesPro modelDetailMaintenance (interval header)'
WHERE NOT EXISTS (SELECT 1 FROM service_intervals WHERE generation_id = 82 AND service = '390,000 km/312 months');

-- 5. procedures (32 titles; body_md empty until repairManuals fetch)
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'schedule_note', 'schedule-note-note-note-read-this-before-selecting-a-maintenance-schedule', 'Note: Note: Read this before selecting a maintenance schedule', '(See HaynesPro WorkshopData for full procedure — storyId 317000391)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'schedule-note-note-note-read-this-before-selecting-a-maintenance-schedule');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'service_reset', 'service-reset-service-indicator-reset', 'Service indicator reset', '(See HaynesPro WorkshopData for full procedure — storyId 319016263)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'service-reset-service-indicator-reset');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-battery-procedures-for-disconnection-reconnection', 'Battery: procedures for disconnection/reconnection', '(See HaynesPro WorkshopData for full procedure — storyId 319006262)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-battery-procedures-for-disconnection-reconnection');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-electronic-parking-brake-epb-procedures', 'Electronic parking brake (EPB) procedures', '(See HaynesPro WorkshopData for full procedure — storyId 319002825)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-electronic-parking-brake-epb-procedures');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-keys-and-remote-controls', 'Keys and remote controls', '(See HaynesPro WorkshopData for full procedure — storyId 319006018)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-keys-and-remote-controls');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-self-levelling-suspension-jacking-up-mode', 'Self-levelling suspension: jacking up mode', '(See HaynesPro WorkshopData for full procedure — storyId 319020212)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-self-levelling-suspension-jacking-up-mode');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-jacking-and-lifting-points', 'Jacking and lifting points', '(See HaynesPro WorkshopData for full procedure — storyId 319015377)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-jacking-and-lifting-points');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-start-stop-system-deactivation-activation', 'Start/stop system: deactivation/activation', '(See HaynesPro WorkshopData for full procedure — storyId 319006449)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-start-stop-system-deactivation-activation');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-tyre-pressure-monitoring-system-initialisation', 'Tyre pressure monitoring system: initialisation', '(See HaynesPro WorkshopData for full procedure — storyId 318000273)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-tyre-pressure-monitoring-system-initialisation');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-wheel-alignment-settings', 'Wheel alignment settings', '(See HaynesPro WorkshopData for full procedure — storyId 319007846)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-wheel-alignment-settings');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-windscreen-wipers-service-position', 'Windscreen wipers: service position', '(See HaynesPro WorkshopData for full procedure — storyId 319007145)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-windscreen-wipers-service-position');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-electronic-parking-brake-epb-initialisation', 'Electronic parking brake (EPB): initialisation', '(See HaynesPro WorkshopData for full procedure — storyId 319017557)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-electronic-parking-brake-epb-initialisation');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-power-window-initialisation', 'Power window: initialisation', '(See HaynesPro WorkshopData for full procedure — storyId 319019553)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-power-window-initialisation');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-guidance-digital-service-record', 'Guidance - Digital Service Record', '(See HaynesPro WorkshopData for full procedure — storyId 319033546)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-guidance-digital-service-record');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-general', 'General', '(See HaynesPro WorkshopData for full procedure — storyId 317000502)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-general');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-battery-procedures-for-disconnection-reconnection', 'Battery: procedures for disconnection/reconnection', '(See HaynesPro WorkshopData for full procedure — storyId 319015222)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-battery-procedures-for-disconnection-reconnection');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-dual-clutch-transmission-emergency-park-release', 'Dual-clutch transmission: emergency park release', '(See HaynesPro WorkshopData for full procedure — storyId 319002644)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-dual-clutch-transmission-emergency-park-release');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-dual-clutch-transmission-gearbox-fluid-level-check-and-drain-refill-dual-clutch-tran', 'Dual-clutch transmission: gearbox fluid level check and drain/refill, Dual-clutch transmission, 0CK, 7-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319007174)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-dual-clutch-transmission-gearbox-fluid-level-check-and-drain-refill-dual-clutch-tran');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-dual-clutch-transmission-hydraulic-control-unit-fluid-level-check-and-drain-refill-d', 'Dual-clutch transmission: hydraulic control unit fluid level check and drain/refill, Dual-clutch transmission, 0CK, 7-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319000658)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-dual-clutch-transmission-hydraulic-control-unit-fluid-level-check-and-drain-refill-d');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-battery-procedures-for-disconnection-reconnection', 'Battery: procedures for disconnection/reconnection', '(See HaynesPro WorkshopData for full procedure — storyId 319019948)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-battery-procedures-for-disconnection-reconnection');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-dual-clutch-transmission-emergency-park-release-dual-clutch-transmission-0ck-0dk-7-s', 'Dual-clutch transmission: emergency park release, Dual-clutch transmission, (0CK, 0DK), 7-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319015223)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-dual-clutch-transmission-emergency-park-release-dual-clutch-transmission-0ck-0dk-7-s');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-oil-level-check-vehicles-without-dipstick', 'Oil level check - Vehicles without dipstick', '(See HaynesPro WorkshopData for full procedure — storyId 319008234)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-oil-level-check-vehicles-without-dipstick');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-dual-clutch-transmission-emergency-park-release-dual-clutch-transmission-0cj-7-speed', 'Dual-clutch transmission: emergency park release, Dual-clutch transmission, 0CJ, 7-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319006285)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-dual-clutch-transmission-emergency-park-release-dual-clutch-transmission-0cj-7-speed');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-dual-clutch-transmission-hydraulic-control-unit-fluid-level-check-and-drain-refill-d', 'Dual-clutch transmission: hydraulic control unit fluid level check and drain/refill, Dual-clutch transmission, 0CJ, 7-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319000793)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-dual-clutch-transmission-hydraulic-control-unit-fluid-level-check-and-drain-refill-d');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-oil-level-check-vehicles-without-dipstick', 'Oil level check - Vehicles without dipstick', '(See HaynesPro WorkshopData for full procedure — storyId 319008233)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-oil-level-check-vehicles-without-dipstick');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-dual-clutch-transmission-gearbox-fluid-level-check-and-drain-refill-dual-clutch-tran', 'Dual-clutch transmission: gearbox fluid level check and drain/refill, Dual-clutch transmission, 0CJ, 7-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319007210)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-dual-clutch-transmission-gearbox-fluid-level-check-and-drain-refill-dual-clutch-tran');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-automatic-transmission-emergency-park-release-automatic-transmission-0d5-8-speed', 'Automatic transmission: emergency park release, Automatic transmission, 0D5, 8-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319006447)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-automatic-transmission-emergency-park-release-automatic-transmission-0d5-8-speed');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-automatic-transmission-fluid-level-check-and-drain-refill-automatic-transmission-0d5', 'Automatic transmission: fluid level check and drain/refill, Automatic transmission, 0D5, 8-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319000305)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-automatic-transmission-fluid-level-check-and-drain-refill-automatic-transmission-0d5');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-high-voltage-system-de-energising', 'High-voltage system: de-energising', '(See HaynesPro WorkshopData for full procedure — storyId 319030854)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-high-voltage-system-de-energising');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-inspection-mode-activation', 'Inspection mode: activation', '(See HaynesPro WorkshopData for full procedure — storyId 319030381)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-inspection-mode-activation');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-dual-clutch-transmission-gearbox-fluid-level-check-and-drain-refill-dual-clutch-tran', 'Dual-clutch transmission: gearbox fluid level check and drain/refill, Dual-clutch transmission, (0CJ, 0DK), 7-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319020516)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-dual-clutch-transmission-gearbox-fluid-level-check-and-drain-refill-dual-clutch-tran');
INSERT INTO procedures (generation_id, procedure_type, slug, title, body_md, tools_required, common_mistakes)
SELECT 82, 'maintenance', 'maintenance-dual-clutch-transmission-hydraulic-control-unit-fluid-level-check-and-drain-refill-d', 'Dual-clutch transmission: hydraulic control unit fluid level check and drain/refill, Dual-clutch transmission, (0CJ, 0DK), 7-speed', '(See HaynesPro WorkshopData for full procedure — storyId 319020517)', NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM procedures WHERE generation_id = 82 AND slug = 'maintenance-dual-clutch-transmission-hydraulic-control-unit-fluid-level-check-and-drain-refill-d');

-- 6. spec_sources — link new torque/electrical/service/procedure rows to HaynesPro
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @s_haynes FROM torque_specs WHERE generation_id = 82;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @s_haynes FROM electrical_specs WHERE generation_id = 82;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @s_haynes FROM service_intervals WHERE generation_id = 82;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'procedures', id, @s_haynes FROM procedures WHERE generation_id = 82;

-- Audit
SELECT 'torque_specs' AS spec, COUNT(*) AS n FROM torque_specs WHERE generation_id = 82
UNION ALL SELECT 'electrical_specs', COUNT(*) FROM electrical_specs WHERE generation_id = 82
UNION ALL SELECT 'service_intervals', COUNT(*) FROM service_intervals WHERE generation_id = 82
UNION ALL SELECT 'procedures', COUNT(*) FROM procedures WHERE generation_id = 82;