-- 501: normalize tire_size spacing. Dominant format is "255/40 R18" (space before
-- the R, 801 rows); ~66 rows used the no-space form "255/40R18"/"255/40ZR18"
-- (incl. 6 P-prefixed). Insert a space between the section/aspect digit and the
-- (Z)R rim marker. Already-spaced sizes and non-radial spares (e.g. "T155/90 D16")
-- are untouched. P-prefix preserved (P-metric is a real designation).
UPDATE tire_pressures
SET tire_size = REGEXP_REPLACE(tire_size, '([0-9])(Z?R[0-9])', '\\1 \\2')
WHERE tire_size REGEXP '[0-9]Z?R[0-9]';
