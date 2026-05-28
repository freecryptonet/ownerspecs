-- mig 515 — manual_inventory: track the converted markdown next to each PDF.
--
-- After scripts/convert_manuals.py runs, each PDF has a sibling .md file with
-- <!--PAGE n--> markers. Storing the relative path + a section_map JSON lets
-- the manual-query helper jump straight to the relevant page range instead of
-- grepping a 600-page document.
--
-- section_map shape (populated by scripts/detect_sections.py):
--   {
--     "fluids":       {"start": 412, "end": 419},
--     "torques":      {"start": 562, "end": 581},
--     "maintenance":  {"start": 95,  "end": 108},
--     "fuses":        {"start": 401, "end": 417},
--     "bulbs":        {"start": 389, "end": 398},
--     "tire_pressures": {"start": 451, "end": 453},
--     "specifications": {"start": 595, "end": 612}
--   }
-- Missing keys = section not detected. Page numbers are 1-based, inclusive.

SET NAMES utf8mb4;

ALTER TABLE manual_inventory
  ADD COLUMN md_path        VARCHAR(512) NULL AFTER file_path,
  ADD COLUMN md_converted_at DATETIME NULL AFTER md_path,
  ADD COLUMN md_converter   VARCHAR(48) NULL AFTER md_converted_at,
  ADD COLUMN section_map    JSON NULL AFTER md_converter;
