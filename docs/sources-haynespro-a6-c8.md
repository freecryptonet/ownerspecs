HaynesPro WorkshopData — Audi A6 / -Allroad (4A) 2019 - ...
URL: https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001693
Real modelId: d_319001693
Captured: 2026-05-22 by Claude via Playwright (Tim's authenticated session)

Note: HaynesPro groups A6 sedan + A6 Avant + A6 Allroad all under one
modelId/chassis "4A". Sub-body distinction (sedan vs Avant vs Allroad)
appears one level deeper (per-typeId clickthrough). RS6 is its own line
item in this list (4.0 V8 TFSI biturbo). S6 has BOTH a 2.9 V6 TFSI
petrol AND a 3.0 V6 TDI variant — the EU spec offered both, US only
got the 2.9 TFSI petrol.

Type            Engine code      Capacity   Power     Model Year
35 TDI          DEZD             1968cc     120kW     2019 - 2021
35 TDI          DEZF             1968cc     100kW     2019 - 2021
35 TDI          DTPB             1968cc     120kW     2021 - ...
40 TDI          DFBA             1968cc     150kW     2019 - ...
40 TDI          DESA             1968cc     140kW     2019 - ...
40 TDI          DTPA             1968cc     150kW     2021 - ...
40 TFSI         DKYA             1984cc     140kW     2019 - ...
40 TFSI         DMTC             1984cc     150kW     2021 - ...
45 TDI          DDVE             2967cc     170kW     2019 - 2021
45 TDI          DDVF             2967cc     155kW     2019 - 2019
45 TDI          CVMD             2967cc     183kW     2020 - ...
45 TDI          DMGH             2967cc     180kW     2021 - ...
45 TFSI         DKNA             1984cc     180kW     2019 - 2022
45 TFSI         DLHA             1984cc     180kW     2019 - ...
45 TFSI         DKWB             1984cc     165kW     2019 - ...
45 TFSI         DMTA             1984cc     195kW     2021 - ...
45 TFSI         DPAA             1984cc     195kW     2021 - ...
50 TDI          DDVB             2967cc     210kW     2019 - 2021
50 TDI          DMGA             2967cc     210kW     2021 - ...
50 TFSI e       DLGA+EBCA        1984cc     220kW     2019 - 2021
50 TFSI e       DRYA+EBCA        1984cc     220kW     2021 - ...
55 TFSI         DLZA             2995cc     250kW     2019 - ...
55 TFSI e       DLGA+EBCA        1984cc     270kW     2019 - 2021
55 TFSI e       DRYA+EBCA        1984cc     270kW     2021 - ...

S6 (2.9 V6 TFSI)    DKMB         2894cc     331kW     2019 - ...
S6 (3.0 TDI)        DEWA         2967cc     257kW     2019 - 2021
S6 (3.0 TDI)        DMKD         2967cc     253kW     2021 - ...

RS6 (4.0 V8 TFSI)              DJPB    3996cc    441kW   2019 - 2024  (pre-LCI / standard)
RS6 (4.0 V8)                   DWLA    3996cc    441kW   2023 - ...   (LCI / standard, restated)
RS6 (4.0 V8)                   DYGB    3996cc    441kW   2023 - ...   (LCI / standard)
RS6 Performance (4.0 V8)       DYGA    3996cc    463kW   2023 - ...   (LCI / Performance)

Top categories visible on the modelTypesList header bar:
- ID location
- Jacking points
- Diagnostic connector

NEXT: Drill into a typical typeId (e.g. 45 TFSI DMTA 195 kW) to find:
- Service indicator reset procedure (verify mig 198 SII content)
- DSG 7-speed (DL382) fluid change spec (verify temperature window claim)
- ZF 8HP (0HL) fluid change spec (verify pan + filter assembly claim)
- EPB service mode (verify T45 emergency release claim)
- Jacking points + air suspension service mode

Also: drill into S6 (DKMB, 2.9 V6 TFSI) typeId to identify the specific
sedan-only / Avant-only differences (S6 doesn't get Allroad).

## Fluid + torque capture per S6/RS6 engine variant (mig 201, 2026-05-22)

Lubricants page = `/touch/site/layout/lubricants?typeId=<t_NNN>&groupId=QUICKGUIDES&altView=true`
Adjustment data page = `/touch/site/layout/adjustmentData?typeId=<t_NNN>&groupId=QUICKGUIDES&fromOverview=true`

### DKMB — S6 2.9 V6 TFSI biturbo (typeId t_619017205)
- Engine oil: SAE 0W-30, VW 504 00 — 7.6 L sump (incl. filter), drain 30 Nm
- Coolant: TL-VW 774L (G12EVO) — 10.0 L (NOT G13!)
- Brake fluid: VW 501 14 / DOT 4 — 1.0 L (automatic) / 1.0 L (dual-clutch) / 1.15 L (manual)
- Transmission: ZF 0D5 8-speed automatic — ATF VW G 060 162 A2, initial 8.6 L, refill 3.6-4.0 L
- Transfer box: 0D5 — gear oil SAE 75W-90 VW G 055 145 A2, initial 1.0 L, refill 0.8 L
- Rear differential (torque vectoring) 0D3 — refill 0.95 L
- Rear differential (standard) 0G2 — VW G 060 190 A2, refill 0.85 L
- A/C: R-1234yf 510 ± 15 g, compressor oil ISO 46 VW G 055 535 M2 (Denso) / VW G 052 535 (Sanden), 100 ± 10 ml
- Wheel bolts: 120 Nm
- Engine spec: 2894 cc, 6 cyl, 4 valves/cyl, timing chain, hydraulic valve clearance
- Battery options (per equipment code):
  - J0V: 70 Ah EFB, 420 CCA DIN
  - J0Z: 110 Ah, 520 CCA DIN
  - J2D: 68 Ah AGM, 380 CCA DIN
  - J0P: 105 Ah AGM, 580 CCA DIN

### DEWA — S6 3.0 TDI V6 pre-LCI EU (typeId t_619023125)
- Engine oil: SAE 0W-30, VW 507 00 — 6.1 L sump (incl. filter), drain 30 Nm (renew seal)
- Cooling system, brake fluid, ZF 0D5 8-speed, transfer box, rear diff, A/C: identical to DKMB
- (DMKD = LCI variant of same 3.0 V6 TDI — values assumed identical, not separately captured)

### DJPB — RS6 4.0 V8 TFSI biturbo pre-LCI (typeId t_619028750)
- Engine oil: SAE 0W-40, **VW 511 00** (HIGHER-PERFORMANCE SPEC, not 504.00) — 9.5 L sump (incl. filter), drain 30 Nm
- Coolant: G12EVO — 10.0 L (same as S6)
- Brake fluid: VW 501 14 / DOT 4 — same volumes
- Transmission: ZF 0D6 8-speed (NOT 0D5!) — ATF VW G 060 162 A2, initial 8.6 L, refill 3.6-4.0 L
- Transfer box: 0D6 — gear oil VW G 055 145 A2, initial 1.0 L, refill 0.8 L
- Front differential (open) 0D6 — gear oil VW G 055 145 A2, initial 1.0 L, refill 0.9 L. Filler plug 27 Nm, drain plug 10 Nm (both single-use)
- Rear differential 0DG — gear oil VW G 052 145, 1.0 L initial
- A/C: R-1234yf **575 ± 15 g** (higher than S6), compressor oil 110 ± 10 ml (Denso) / 100 ± 10 ml (Sanden)

### DWLA — RS6 LCI standard (typeId t_619116169) — spot-verified
- Engine oil: SAE 0W-40, VW 511 00 — identical to DJPB
- ZF 0D6 8-speed — identical to DJPB
- Conclusion: DWLA / DYGB / DYGA all share the DJPB fluid spec (same 4.0 V8 TFSI biturbo family, ECU tune varies but lubrication unchanged)

## Critical workshop code clarifications

| Audi marketing | HaynesPro workshop code | Engine family |
|---|---|---|
| ZF 8HP (S6 + A6 V6) | **0D5** | longitudinal MLB 8-speed |
| ZF 8HP (RS6 V8) | **0D6** | longitudinal MLB 8-speed, higher torque variant |
| Torque-vectoring rear diff | **0D3** | S6 |
| Standard rear diff | **0G2** (S6) / **0DG** (RS6) | — |
| Coolant (all C8) | **G12EVO** (TL-VW 774L) | NOT G13 — important correction |
