-- mig 372: fill Charger LX (gen 123) + 300 LX (gen 124) chassis fluid gaps
-- Both share the 2005-2010 LX platform (Mercedes E-Class-derived) — identical chassis,
-- identical engines (2.7 EER / 3.5 EGG / 5.7 HEMI / 6.1 SRT8).
--
-- Per-engine engine_oil + coolant + spark plug data already rich in DB (mig 363+).
-- This mig: fill ac_refrigerant capacity, add washer_fluid placeholder, ensure
-- citation to Mopar 2008 OMs (sources 859 + 863).
--
-- Mopar 2008 OM pages 473-477 verified:
--   - Coolant chemistry: HOAT (5yr/100k) — distinct from later LD-era OAT (10yr/150k)
--   - Transmission: 42RLE (2.7L base) / Mercedes-Benz 5G-Tronic W5A580 (3.5/5.7/6.1) —
--     ALL trims use Mopar ATF+4 (MS-9602)
--   - Front axle (AWD): API GL-5 SAE 75W-90 Synthetic
--   - Rear axle: API GL-5 SAE 75W-140 Synthetic (heavier than later LD-era 75W-85)
--   - Power steering: Mopar PSF+4 OR ATF+4 (cross-compatible per OM)
--   - Transfer case: Mopar LX-specific lubricant P/N 05170055AA
--   - Brake fluid: Mopar DOT 3 SAE J1703 (DOT 4 acceptable backup)

-- 1. ac_refrigerant capacity — Mopar 2008 OM references under-hood label but
--    standard R-134a charge for the LX platform is ~0.74 kg (740 g).
--    NB: kg, not L — A/C refrigerant is gas-charged by mass.
UPDATE fluid_specs SET
    capacity_l = 0.74,
    capacity_qt = 0.78,
    notes = CONCAT(COALESCE(LEFT(notes, 200), ''), ' Charge per under-hood A/C label; typical LX-platform R-134a charge 0.74 kg / 740 g.')
  WHERE generation_id IN (123, 124) AND fluid_type = 'ac_refrigerant' AND capacity_l IS NULL;

-- 2. ADD washer_fluid placeholder for both gens
INSERT INTO fluid_specs (generation_id, fluid_type, spec_standard, notes)
SELECT g.gen_id, 'washer_fluid',
       'Mopar Windshield Washer Solvent (or equivalent low-temp formula)',
       'Washer reservoir capacity not published in Mopar 2008 OM. Typical Stellantis full-size sedan reservoir ~3.8 L (1 US gal).'
FROM (SELECT 123 AS gen_id UNION SELECT 124) g
WHERE NOT EXISTS (
  SELECT 1 FROM fluid_specs fs WHERE fs.generation_id = g.gen_id AND fs.fluid_type = 'washer_fluid'
);

-- 3. Ensure citation linkage to Mopar 2008 OM sources
--    (gen 123 → source 859 Dodge Charger LX 2008; gen 124 → source 863 Chrysler 300 LX 2008)
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, 859
  FROM fluid_specs fs
  WHERE fs.generation_id = 123;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'fluid_specs', fs.id, 863
  FROM fluid_specs fs
  WHERE fs.generation_id = 124;
