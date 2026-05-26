-- 488: enrich EZB 5.7 HEMI internals + align 300 LX coolant to its OM
--
-- EZB bore/stroke/compression verified across engine-specs.net + Wikipedia +
-- onallcylinders (9.6:1, 99.5 x 90.9 mm, 5654 cc, OHV/MDS). The 2008 Chrysler 300
-- LX OM confirmed the EZB fluid data already in the DB (oil 6.6 L 5W-20 MS-6395;
-- coolant 13.9 L HOAT std; plug REC14MCC4 @ 1.1 mm). OM lacks bore/stroke/
-- compression, so those come from cross-checked research.

UPDATE engines SET bore_mm = 99.5, stroke_mm = 90.9, compression = 9.60
WHERE id = 2048 AND code = 'EZB';

-- 300 LX (gen 124) coolant was 13.8 L; the 2008 300 LX OM states 13.9 L (std duty).
UPDATE fluid_specs SET capacity_l = 13.9, capacity_qt = 14.7 WHERE id = 1618;
