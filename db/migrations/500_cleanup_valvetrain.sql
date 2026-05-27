-- 500: clean up freeform engines.valvetrain. Normalizes mechanical formatting
-- (comma/dash separators -> space, valve-count "Nv"->"NV", "N Valves"->"NV",
-- VALVETRONIC->Valvetronic, TIVCT->Ti-VCT) while preserving genuine tech tokens
-- and meaningful hyphens (VVT-i, Dual-VTC, D-VVT-iW, Double-VANOS, D-4S, Ti-VCT).
-- Unmapped values pass through unchanged (ELSE).

UPDATE engines SET valvetrain = CASE BINARY valvetrain
    WHEN '16 Valves'                          THEN '16V'
    WHEN '24 Valves'                          THEN '24V'
    WHEN 'DOHC - Dual VVT-i'                  THEN 'DOHC Dual VVT-i'
    WHEN 'DOHC 12v VTEC'                      THEN 'DOHC 12V VTEC'
    WHEN 'DOHC 16v'                           THEN 'DOHC 16V'
    WHEN 'DOHC 16v Atkinson · Dual VVT-i'     THEN 'DOHC 16V Atkinson · Dual VVT-i'
    WHEN 'DOHC 16v Dual VVT-iE · D-4S DI+PI'  THEN 'DOHC 16V Dual VVT-iE · D-4S DI+PI'
    WHEN 'DOHC 16v i-VTEC'                    THEN 'DOHC 16V i-VTEC'
    WHEN 'DOHC 24v Dual VVT-iW · D-4S'        THEN 'DOHC 24V Dual VVT-iW · D-4S'
    WHEN 'DOHC-CVVT'                          THEN 'DOHC CVVT'
    WHEN 'DOHC, CVTCS'                        THEN 'DOHC CVTCS'
    WHEN 'DOHC, CVVT'                         THEN 'DOHC CVVT'
    WHEN 'DOHC, D-VVT-iW'                     THEN 'DOHC D-VVT-iW'
    WHEN 'DOHC, Dual CVVT'                    THEN 'DOHC Dual CVVT'
    WHEN 'DOHC, Dual VVT-i'                   THEN 'DOHC Dual VVT-i'
    WHEN 'DOHC, Dual-VTC'                     THEN 'DOHC Dual-VTC'
    WHEN 'DOHC, i-VTEC'                       THEN 'DOHC i-VTEC'
    WHEN 'DOHC, TIVCT'                        THEN 'DOHC Ti-VCT'
    WHEN 'DOHC, VALVETRONIC'                  THEN 'DOHC Valvetronic'
    WHEN 'DOHC, VTEC'                         THEN 'DOHC VTEC'
    WHEN 'DOHC, VTEC EVTC'                    THEN 'DOHC VTEC EVTC'
    WHEN 'DOHC, VVT'                          THEN 'DOHC VVT'
    WHEN 'Double-VANOS, VALVETRONIC'          THEN 'Double-VANOS Valvetronic'
    WHEN 'OHV 16v'                            THEN 'OHV 16V'
    WHEN 'OHV, VVT DI'                        THEN 'OHV VVT DI'
    WHEN 'SOHC 24v'                           THEN 'SOHC 24V'
    WHEN 'SOHC, i-VTEC'                       THEN 'SOHC i-VTEC'
    WHEN 'VALVETRONIC'                        THEN 'Valvetronic'
    ELSE valvetrain END
WHERE valvetrain IS NOT NULL;

-- An electric motor has no valvetrain — was wrongly tagged "permanent-magnet synchronous".
UPDATE engines SET valvetrain = NULL
WHERE BINARY valvetrain = 'permanent-magnet synchronous';
