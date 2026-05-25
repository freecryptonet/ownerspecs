-- mig 429: strip leaked scraper UI text from fuses.circuit_name.
-- Pattern: "<real circuit name>View problems with the X fuse..." — cut at "View problems".
-- Also trim any leftover trailing ellipsis/whitespace.

UPDATE fuses
SET circuit_name = TRIM(TRAILING '.' FROM TRIM(SUBSTRING_INDEX(circuit_name, 'View problems', 1)))
WHERE circuit_name LIKE '%View problems%';

-- any remaining standalone trailing "..." not tied to the above
UPDATE fuses
SET circuit_name = TRIM(TRAILING '.' FROM TRIM(circuit_name))
WHERE circuit_name LIKE '%...';

-- blank-out rows that became empty after stripping
UPDATE fuses SET circuit_name = NULL WHERE circuit_name = '';
