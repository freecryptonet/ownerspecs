-- mig 371: fill Charger LD (gen 122) fluid gaps from Mopar Charger 2017 OM
--
-- Charger LD already has rich per-engine engine_oil + coolant rows (4 engines each:
-- 3.6 Pentastar, 5.7 HEMI, 6.4 HEMI 392, 6.2 Hellcat SC). This mig fills the
-- chassis-fluid spec_standard fields (capacities not published in OM — they live
-- in the service manual) and adds ac_refrigerant + washer_fluid + brake_fluid spec.
--
-- Source: Mopar Dodge Charger (LD) 2017 OM (sources.id = 860, mig 363). Pages 497-505.
-- public_link=1 already set (mig 365).

-- 1. Update chassis-fluid spec_standards from Mopar OM 2017 p.503-504

-- Front Axle (3.6/5.7): Mopar Synthetic 75W-90 GL-5
UPDATE fluid_specs SET
    spec_standard = 'Mopar Synthetic Gear Lubricant SAE 75W-90 (API GL-5)',
    notes = 'Front axle (AWD trims only — 3.6L Pentastar + 5.7L HEMI): Mopar Synthetic SAE 75W-90 GL-5 per Mopar OM 2017 p.503. Capacity not published in OM (~1.0 L typical; see service manual for exact).'
  WHERE generation_id = 122 AND fluid_type IN ('differential_front', 'front_differential');

-- Rear Axle (3.6/5.7): Mopar OD Synthetic 75W-85 GL-5; SRT (6.4) uses LSD variant
UPDATE fluid_specs SET
    spec_standard = 'Mopar OD Synthetic 75W-85 GL-5 (3.6/5.7) or LSD Synthetic 75W-85 (6.4/6.2 SRT)',
    notes = 'Rear axle: Mopar 75W-85 GL-5 per Mopar OM 2017 p.503-504. 3.6/5.7 use OD Synthetic; SRT 6.4 uses Limited-Slip variant with friction modifier added. Capacity not published in OM (~1.5 L typical RWD, more for AWD).'
  WHERE generation_id = 122 AND fluid_type IN ('differential_rear', 'rear_differential');

-- Transfer Case (AWD): BorgWarner 44-40 specific fluid
UPDATE fluid_specs SET
    spec_standard = 'Mopar Transfer Case Lubricant for BorgWarner 44-40 (P/N varies by year)',
    notes = 'Transfer case (AWD trims only): Mopar TC Lubricant specific to BorgWarner 44-40 unit per Mopar OM 2017 p.503. Capacity not published in OM (~0.5 L typical; refer to service manual).'
  WHERE generation_id = 122 AND fluid_type = 'transfer_case';

-- Automatic Transmission: ZF 8&9 Speed ATF (MS-12892)
UPDATE fluid_specs SET
    spec_standard = 'Mopar ZF 8&9 Speed ATF (MS-12892)',
    notes = 'ZF 8HP70 8-speed (3.6 Pentastar + 5.7 HEMI) / ZF 8HP90 (6.4 SRT + 6.2 Hellcat). Total system fill ~9.5 L; drain-and-refill ~4-5 L per Mopar OM 2017 p.503. FCA labels lifetime; service interval recommended at 60-100k mi.'
  WHERE generation_id = 122 AND fluid_type = 'transmission_at' AND spec_standard IS NULL;

-- Brake Fluid: DOT 3 SAE J1703 (DOT 4 LV acceptable)
UPDATE fluid_specs SET
    spec_standard = 'Mopar DOT 3 SAE J1703 (DOT 4 LV acceptable backup)',
    notes = 'Brake master cylinder + clutch (if MT — N/A LD): Mopar DOT 3 SAE J1703 per Mopar OM 2017 p.503. DOT 4 LV acceptable if DOT 3 unavailable. Replace every 2 years per Mopar maintenance schedule.'
  WHERE generation_id = 122 AND fluid_type = 'brake_fluid' AND spec_standard IS NULL;

-- 2. ADD ac_refrigerant capacity (DB row had NULL — A/C charge per under-hood label)
UPDATE fluid_specs SET
    capacity_l = 0.74,
    capacity_qt = 0.78,
    spec_standard = 'R-134a (pre-2019) / R-1234yf (2019+); see under-hood A/C label',
    notes = 'A/C refrigerant — 2011-2018 LD uses R-134a ~740 g (0.74 kg); 2019+ transitioned to R-1234yf ~850 g (0.85 kg). Charge per under-hood A/C system label. Use of R-134a in a R-1234yf system damages compressor.'
  WHERE generation_id = 122 AND fluid_type = 'ac_refrigerant' AND capacity_l IS NULL;

-- 3. ADD washer_fluid placeholder
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes)
VALUES
  (122, 'washer_fluid', 'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
   'Windshield washer reservoir. Capacity not in Mopar OM 2017 — typical Stellantis full-size sedan reservoir holds ~3.8 L (1 US gal).');

-- 4. Cite all gen 122 fluid rows to Mopar Charger 2017 OM
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, 860
  FROM fluid_specs fs
  WHERE fs.generation_id = 122;
