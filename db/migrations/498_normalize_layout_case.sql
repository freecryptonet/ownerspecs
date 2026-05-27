-- 498: normalize generations.layout to uppercase (convention: RWD/AWD/FWD).
-- Surfaced while verifying the trims Drive column (mig 497): the gen-level
-- "Layout" row + hero pill rendered lowercase "rwd" on Charger LD. Same fix,
-- different column. Idempotent; UPPER() leaves compound values like "RWD / 4WD"
-- unchanged.
UPDATE generations SET layout = UPPER(layout)
WHERE BINARY layout != UPPER(layout);
