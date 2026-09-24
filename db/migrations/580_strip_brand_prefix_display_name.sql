-- 580: strip the brand prefix from generations.display_name (150 rows).
--
-- Convention: display_name holds MODEL + body + generation, with NO brand — the render layer
-- prepends make.name everywhere (e.g. make "Honda" + "Civic Sedan (X)" => "Honda Civic Sedan (X)").
-- A systemic ingest batch (Hyundai, Infiniti, Kia, Mercedes-Benz, Tesla, Toyota + one Mazda) stored
-- display_name brand-prefixed ("Kia Rio IV (YB)"), which rendered as a doubled "Kia Kia Rio IV (YB)"
-- in <title>, H1 subtitle and JSON-LD across every affected page.
--
-- Fix: strip exactly the leading "<make name> " token. The WHERE guarantees display_name starts
-- with `m.name + ' '`, so SUBSTRING(... FROM CHAR_LENGTH(m.name)+2) removes the make name + the
-- single following space. CHAR_LENGTH (not LENGTH) is multibyte-safe. Idempotent: after the strip
-- the value no longer matches CONCAT(m.name,' %'), so re-running is a no-op.
--
-- Verified via dry-run before apply: all 150 previews non-empty, none left brand-prefixed, none
-- with leading punctuation (incl. the "Mercedes-Benz" hyphenated brand and single-word Tesla names).
UPDATE generations g
JOIN models mo ON g.model_id = mo.id
JOIN makes m ON mo.make_id = m.id
SET g.display_name = TRIM(SUBSTRING(g.display_name FROM CHAR_LENGTH(m.name) + 2))
WHERE g.display_name LIKE CONCAT(m.name, ' %');
