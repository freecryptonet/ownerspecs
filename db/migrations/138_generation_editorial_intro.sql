-- Add editorial_intro to generations for the 100-300 word E-E-A-T overview
-- shown on each gen-page (herstructureringsplan §3 Niveau 4 #2). Plain text;
-- the gen-page renders it as paragraphs split on blank lines so authors can
-- compose multi-paragraph intros without HTML. NULL means no intro yet — the
-- section is skipped on render.

SET NAMES utf8mb4;

ALTER TABLE generations
  ADD COLUMN editorial_intro TEXT NULL AFTER platform;
