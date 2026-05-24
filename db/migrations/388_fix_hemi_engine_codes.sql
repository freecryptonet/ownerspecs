-- mig 388: set real FCA engine sales codes on the HEMI / SRT8 engines (flagged by Tim)
--
-- Engines 166/167/168/214 had descriptive labels in the `code` field, not the actual
-- FCA sales codes. Verified against the Mopar LX FSM body code plate (p5): the LX
-- platform lists EER (2.7), EGG (3.5), ESF (6.1 SRT8), EZB (5.7 HEMI).
--
-- Codes applied:
--   - 5.7L HEMI: EZB (2005-2008 MDS) → EZH (2009+ Eagle VVT). Engine 166 spans both
--     eras across many gens, so code notes both.
--   - 6.1L SRT8: ESF (Tim confirmed; FSM p5 verified)
--   - 6.4L 392 Apache: ESG
--   - 6.2L Hellcat Supercharged: EWB

UPDATE engines SET
    code = 'EZB/EZH 5.7 HEMI',
    display_name = 'Chrysler 5.7L HEMI V8 (EZB 2005-08 MDS / EZH 2009+ Eagle VVT)'
  WHERE id = 166;

UPDATE engines SET
    code = 'ESF 6.1 SRT8',
    display_name = 'Chrysler 6.1L SRT8 HEMI V8 (ESF, 425 hp)'
  WHERE id = 214;

UPDATE engines SET
    code = 'ESG 6.4 HEMI 392',
    display_name = 'Chrysler 6.4L 392 HEMI V8 (ESG Apache)'
  WHERE id = 167;

UPDATE engines SET
    code = 'EWB 6.2 Hellcat SC',
    display_name = 'Chrysler 6.2L Supercharged HEMI V8 (EWB Hellcat)'
  WHERE id = 168;
