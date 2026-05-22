-- Model bio per herstructureringsplan §3 Niveau 3: the model index page
-- (e.g. /bmw/3-series) needs a short 100-200 word historical / positioning
-- intro to lift it above the "thin hub" SEO penalty. Without it the model
-- page is just a list of generation tiles, ranks poorly for "{Make} {Model}".
--
-- Plain text; ModelView splits on blank lines for paragraphs. NULL = no bio
-- yet, render section is skipped.

SET NAMES utf8mb4;

ALTER TABLE models
  ADD COLUMN bio TEXT NULL AFTER name;
