-- Fill displacement_cc for 6 engines that the scraper left null.
-- Values are OEM-published headline displacements rounded to cc.

SET NAMES utf8mb4;

UPDATE engines SET displacement_cc = 3471 WHERE code = 'J35Y5'   AND displacement_cc IS NULL; -- Honda 3.5L V6 (J-series)
UPDATE engines SET displacement_cc = 1996 WHERE code = 'K20C6'   AND displacement_cc IS NULL; -- Honda 2.0L turbo (FK8/FL5 Type R variant)
UPDATE engines SET displacement_cc = 5328 WHERE code = 'L82'     AND displacement_cc IS NULL; -- GM 5.3L V8 (LT-series direct injection)
UPDATE engines SET displacement_cc = 5328 WHERE code = 'L84'     AND displacement_cc IS NULL; -- GM 5.3L V8 (DFM/cylinder deactivation)
UPDATE engines SET displacement_cc = 6162 WHERE code = 'L87'     AND displacement_cc IS NULL; -- GM 6.2L V8 (LT-series)
UPDATE engines SET displacement_cc = 4395 WHERE code = 'N63B44D' AND displacement_cc IS NULL; -- BMW 4.4L V8 twin-turbo (X5 M50i / X7 M50i)

SELECT 'Engine displacements filled' AS status,
       (SELECT COUNT(*) FROM engines WHERE displacement_cc IS NULL) AS still_null;
