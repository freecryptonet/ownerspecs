-- mig 473: strip marketing/displacement decoration from engines.code so the code
-- column holds the real manufacturer engine code (asset integrity + E-E-A-T).
-- Only `code` changes; the frozen /engines/<slug> URLs are untouched (mig 389).
-- Each target code was collision-checked — none already exist, so no UNIQUE clash
-- and no duplicate-row merge is involved here (those are handled separately).
--
-- The real code was already present in the row's code/display_name; this removes
-- the "4.4 V8" / "6.2 ... SC" / "Pentastar / " decoration around it.

UPDATE engines SET code = 'S63'        WHERE id = 188 AND code = 'S63 4.4 V8';
UPDATE engines SET code = 'N63'        WHERE id = 189 AND code = 'N63 4.4 V8';
UPDATE engines SET code = 'M176'       WHERE id = 194 AND code = 'M176 V8';
UPDATE engines SET code = 'M177'       WHERE id = 190 AND code = 'M177 V8';
UPDATE engines SET code = 'LT4'        WHERE id = 170 AND code = '6.2 LT4 SC';
UPDATE engines SET code = 'L3B'        WHERE id = 197 AND code = '2.7 TurboMax';
UPDATE engines SET code = 'ESG'        WHERE id = 167 AND code = 'ESG 6.4 HEMI 392';
UPDATE engines SET code = 'EWB'        WHERE id = 168 AND code = 'EWB 6.2 Hellcat SC';
UPDATE engines SET code = 'ESF'        WHERE id = 214 AND code = 'ESF 6.1 SRT8';
UPDATE engines SET code = 'EER'        WHERE id = 212 AND code = '2.7 EER';
UPDATE engines SET code = 'EGG'        WHERE id = 213 AND code = '3.5 EGG';
UPDATE engines SET code = 'M20A-FXS'   WHERE id = 178 AND code = 'M20A-FXS hybrid';
UPDATE engines SET code = 'EZB / EZH'  WHERE id = 166 AND code = 'EZB/EZH 5.7 HEMI';
UPDATE engines SET code = 'ERC'        WHERE id = 59  AND code = 'Pentastar / ERC';
UPDATE engines SET code = 'ERG'        WHERE id = 58  AND code = 'Pentastar / ERG';
