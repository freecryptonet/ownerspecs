import { notFound } from "next/navigation";
import Link from "next/link";
import { pageMetadata, faqJsonLd } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { renderMarkdown } from "@/lib/markdown";

type Guide = {
  slug: string;
  title: string;
  description: string;
  body: string;
  faq: Array<[string, string]>;
};

const GUIDES: Guide[] = [
  {
    slug: "5w-20-vs-5w-30",
    title: "5W-20 vs 5W-30: which oil should you actually use?",
    description:
      "5W-20 and 5W-30 differ only at operating temperature, but the OEM-prescribed grade is the safe choice. Here's how to read the SAE viscosity label and when crossing grades affects warranty.",
    body: `## What the numbers mean

SAE J300 viscosity grades are written **XW-YY** where:

- **X** is the cold-cranking viscosity (lower = flows better at start-up).
- **W** stands for "winter" — not "weight."
- **YY** is the kinematic viscosity at 100 °C (operating temperature).

5W-20 and 5W-30 are *identical* at start-up — both rated to flow at −30 °C. The difference is at operating temperature: 5W-30 is thicker.

## Why this matters

Thicker oil at operating temperature means:

- Slightly more film strength under load
- Slightly more pumping work for the engine (≈0.5–1.5% fuel-economy impact)
- Modern engines with variable-valve-timing oil galleries can mis-actuate if viscosity is far from spec

## The rule

**Use the grade in your owner's manual.** Modern engines (especially with VCT, MultiAir, VVT-iE) often have a single approved grade. Crossing grades can:

1. Throw a check-engine light if the VVT actuator doesn't move in spec time.
2. Void the powertrain warranty during the warranty period.
3. Affect fuel economy enough to move the EPA-rated label.

## When 5W-30 is safe in a 5W-20 engine (and vice versa)

The American Petroleum Institute (API) publishes a "viscosity recommendation chart" — older engines from before ~2010 were often spec'd as "5W-20 or 5W-30" depending on climate. For those:

- Hot climates → 5W-30 is fine (thicker oil holds film at higher ambient temp).
- Cold-only climates → 5W-20 starts faster.

For post-2010 engines, **trust the manual, not your gut**.

## Hybrid and electrified caveats

Hybrid engines (Toyota Synergy Drive, Honda i-MMD, Hyundai TMED) often spec 0W-16 or even 0W-8 specifically to reduce parasitic drag during engine-on cycles. These engines are designed around the thinner oil; substituting 5W-30 reduces fuel economy by ~3% and can cause oil-pressure warnings.

## Look up your spec

The fastest answer for *your* car: search by make + generation on the catalogue. Every gen page lists the OEM-prescribed grade, spec standard (API SP, dexos1 Gen3, MB 229.51, etc.), and capacity.`,
    faq: [
      [
        "Can I mix 5W-20 and 5W-30 in an emergency?",
        "Yes. If you're a quart low and only 5W-30 is available for a 5W-20 spec, adding a quart is fine until the next change. Long-term running on the wrong grade is the issue, not topping up.",
      ],
      [
        "Does using 5W-30 in a 5W-20 engine void the warranty?",
        "Yes, during the warranty period if a failure can be traced to viscosity mismatch. The Magnuson-Moss Warranty Act protects you from being forced to use OEM-brand oil, but you must use the OEM-spec'd grade.",
      ],
      [
        "Why do European cars spec different grades like 0W-30 LL-01?",
        "European OEMs use ACEA grades alongside SAE viscosity. The LL-01 / 504 00 / 229.51 numbers refer to additive packages, not viscosity. Always match both.",
      ],
      [
        "What does the donut symbol on the bottle mean?",
        "The API donut shows the SAE viscosity (top), the API service rating (middle, e.g. API SP), and ILSAC GF-6 (bottom) certification. Look for the OEM-spec rating on the label.",
      ],
    ],
  },
  {
    slug: "tpms-light-meaning",
    title: "Why is my TPMS light on, and how do I reset it?",
    description:
      "The TPMS light means one of three things: a low tire, a sensor fault, or a calibration drift. The fix depends on whether your system is direct or indirect.",
    body: `## What TPMS actually measures

Federal law (FMVSS 138) has required tire-pressure monitoring on US vehicles since 2008. There are two implementations:

### Direct TPMS

A small radio-equipped sensor inside each wheel measures pressure (and usually temperature). Reports to the body control module via 315/433 MHz. Most US vehicles since 2008.

- Accurate to ±1 psi
- Battery typically lasts 5-10 years (non-replaceable; new sensor required)
- Affected by extreme cold (sensors can drop offline below −30 °C)

### Indirect TPMS

Uses the ABS wheel-speed sensors. A lower-pressure tire has a slightly smaller rolling diameter, so it rotates faster. The system compares the four wheels' rotation rates.

- Cheaper for OEMs (no per-wheel sensors)
- Less accurate — requires calibration
- Cannot tell you *which* tire is low
- Common on EU models, Tesla, some Hondas/Mazdas

## What "light on" means

| Light pattern | Meaning |
|---|---|
| Steady amber | One or more tires ≥25% below placard pressure |
| Flashing for 60 s, then steady | TPMS *system* malfunction (sensor battery, antenna fault, or calibration needed) |
| Off after pressure restored | All tires within spec |

A flashing light is **not** the same as a steady light. Flashing → service. Steady → check pressures cold.

## Cold pressures

Always set tires when cold (overnight, before driving). Hot pressures from highway driving read 3-5 psi high. Setting to placard when hot leaves you 3-5 psi under spec when the car cools.

## Per-system reset

The reset procedure is canonical per OEM. We list per-gen specifics on every procedure page.

### Direct (most common)

Many modern systems auto-relearn after 10-30 minutes of driving above 25 mph. Some require:

1. Door-handle button-hold (GM, Mopar)
2. Magnet-on-valve-stem activation tool (Ford, older GM)
3. Menu-driven set via head unit (Toyota, Hyundai, BMW)

### Indirect

The reset is a "store new baseline" command. Always:

1. Set all tires to placard pressure cold.
2. Find the TPMS button in the menu/cluster.
3. Hold or click "Set" / "Calibrate" / "Store."
4. Drive 10-30 min at steady highway speed.

## Common mistakes

- Setting to hot pressures (under-spec by 3-5 psi).
- Forgetting the spare (some vehicles monitor it).
- Replacing a sensor without registering it (Mopar wiTECH, Ford IDS, BMW ISTA).
- Trying to reset a flashing light — flashing means system fault, not calibration drift.

## Look up your gen

Per-gen procedures live in the catalogue. Search by make + model.`,
    faq: [
      [
        "Why is my TPMS light on when all my tires are at the right pressure?",
        "Probably a sensor-battery failure (5-10 year life) or a temperature drop. Cold mornings can knock pressures 3-5 psi below the threshold. Top up cold and drive 20 minutes; if it stays on, scan with an OBD-II tool for a low-battery DTC.",
      ],
      [
        "Can I replace a TPMS sensor with an aftermarket one?",
        "Yes, with the right programming tool. Most aftermarket sensors (Schrader EZ-sensor, Autel MX-Sensor) clone the OEM ID after programming. Cost: ~$30 vs $80+ OEM, but requires a TPMS tool to register.",
      ],
      [
        "Will running winter tires affect TPMS?",
        "If your winter set has its own TPMS sensors, you must register the spare-set IDs each swap. Indirect systems need recalibration after a tire swap because rolling-diameter changes shift the baseline.",
      ],
      [
        "What pressure should I actually run?",
        "Use the door-jamb placard, not the sidewall. Sidewall max is the tire's rated limit; placard is what the manufacturer engineered the suspension for. Loaded (passengers + cargo) often raises rear pressure 3-5 psi.",
      ],
    ],
  },
  {
    slug: "brake-fluid-flush",
    title: "When (and why) to flush brake fluid",
    description:
      "Brake fluid is hygroscopic — it absorbs water from the air. After ~24 months it can boil under hard braking, causing pedal fade. Here's the OEM-prescribed interval, the DOT-grade table, and how to test it yourself.",
    body: `## Why brake fluid degrades

Brake fluid (DOT 3, 4, 5.1) is *glycol-ether-based* and hygroscopic — it absorbs water from atmospheric moisture through brake hoses and reservoir vent. Over time:

- Boiling point drops: dry DOT 4 ≈ 230 °C; with 3% water content, ≈ 155 °C.
- Internal corrosion: water + heat = rust on caliper pistons, ABS valves.
- ABS modulator pumps fail: water-contaminated fluid eats the seals over time.

## The OEM-prescribed interval

Most OEMs spec a flush every **24 months**, regardless of mileage. A few outliers:

- Honda/Acura: 36 months (some recent models extended to "as needed" with a moisture test)
- Toyota: 30 months
- Subaru: 30 months
- BMW: 24 months (signaled by CBS)
- Mercedes: 24 months (Service A/B includes it)

If you've never flushed it on a car older than 3 years, do it now.

## DOT grade table

| Grade | Dry boiling pt | Wet boiling pt (3% H₂O) | Typical use |
|---|---|---|---|
| DOT 3 | 205 °C | 140 °C | Most US daily drivers pre-2015 |
| DOT 4 | 230 °C | 155 °C | Most modern cars (incl. EU) |
| DOT 4 LV | 260 °C | 175 °C | VW Group, Audi, Porsche |
| DOT 5.1 | 270 °C | 190 °C | Performance / track use |
| DOT 5 | 260 °C | 180 °C | Silicone-based (military), DO NOT mix |

**Critical:** DOT 3, 4, and 5.1 are inter-mixable (all glycol-based). DOT 5 is silicone-based and **never** mixes with glycol fluids. Mixing destroys ABS seals.

## How to test moisture content

Cheapest tool: a $10 brake-fluid moisture tester pen (Lisle 75450, Mityvac). Dip in the reservoir, read percentage. >3% → flush now.

## Two-person bleed procedure

1. Top up reservoir with fresh DOT 4 (or whatever your manual specifies).
2. Loosest-to-tightest bleed order (typically RR → LR → RF → LF on most US sedans — check your manual).
3. Helper pushes pedal slow; you crack bleeder ¼-turn; close before pedal hits the floor.
4. Repeat until clean fluid runs (3-4 pumps per corner).
5. **Watch the reservoir** — if it runs dry, you've pumped air into the master cylinder, requiring a full pressure-bleed redo.

## Power bleeder (single-person)

A Motive Power Bleeder ($60) pressurizes the reservoir; just crack each bleeder and watch the catch bottle. Faster, no helper needed. Tighten the cap firmly — DOT 4 strips paint.

## Special cases

- **Hybrids/EVs:** Regen braking means the hydraulic system sees less work, but the fluid still degrades chemically. Flush per OEM interval.
- **Mopar wiTECH ABS:** Requires scan-tool-activated bleed sequence for the ABS module after the main bleed.
- **Performance cars / track use:** Annual flush minimum. Consider DOT 4 LV or 5.1 for higher wet boiling point.

## Per-gen specs

Brake-fluid type and flush interval are listed on every gen's [brake-fluid page]. Per-gen torques for bleeder screws are on the [torque page].`,
    faq: [
      [
        "Can I mix DOT 3 and DOT 4 brake fluid?",
        "Yes — both are glycol-based and inter-mixable. You can top up DOT 4 with DOT 3 in an emergency. Never mix with DOT 5 (silicone) — destroys seals.",
      ],
      [
        "How do I know if my brake fluid needs changing?",
        "Three signs: time (>24 months since flush), color (dark amber or murky vs fresh straw-yellow), or a moisture tester reading >3%. A spongy pedal under hard braking is the worst-case symptom.",
      ],
      [
        "Will flushing brake fluid fix a soft pedal?",
        "Sometimes. Air in the lines or moisture-boiling-induced vapor lock both cause a soft pedal. A flush replaces both. But it won't fix a leaking caliper, a failing master cylinder, or worn pads.",
      ],
      [
        "Do EVs need brake-fluid flushes?",
        "Yes. Regen braking reduces friction-brake use, but the fluid still chemically degrades and absorbs moisture. Tesla, Polestar, Rivian all spec brake-fluid inspection every 2 years.",
      ],
    ],
  },
  {
    slug: "coolant-types-explained",
    title: "Coolant types decoded: G12, G13, OAT, HOAT, IAT, FL22",
    description:
      "VW G12+, Toyota SLLC, GM Dex-Cool, Honda Type 2, Mazda FL22 — they're not interchangeable. Here's the technology behind each and which ones can be mixed in an emergency.",
    body: `## The three families

Modern engine coolant is one of three chemistries:

### IAT — Inorganic Additive Technology (legacy green)

Silicate + phosphate inhibitors. Cheap, fast corrosion protection, but additives deplete in 2 years / 30,000 mi. Used on pre-2000s US/JP cars. Color: green.

### OAT — Organic Acid Technology

Long-life additives (2-EHA + sebacate). Lasts 5 years / 150,000 mi. No silicates. Color varies by OEM: GM Dex-Cool (orange), VW G12+ (pink), Toyota SLLC (pink), Hyundai LLC (blue).

### HOAT — Hybrid OAT

OAT + small amount of silicate or nitrite. Lasts 5 years. Compromise for aluminum-block engines that benefit from silicates. Colors: VW G12 (red), Mopar OAT/HOAT (orange/pink).

## OEM coolant cheat-sheet

| Spec | Type | Color | Used by | Compatible with |
|---|---|---|---|---|
| VW G11 | HOAT (with silicate) | Blue-green | Older VW/Audi | G12+ |
| VW G12 | OAT (2-EHA) | Red | VW/Audi/Porsche 2000-2008 | G12+ |
| VW G12+ | OAT (2-EHA + sebacate) | Pink | VW/Audi/Porsche 2008+ | G12, G13 |
| VW G13 | OAT (sebacate, no 2-EHA) | Lilac/purple | VW/Audi/Porsche 2012+ | G12+ |
| Toyota SLLC | OAT (P-OAT) | Pink | Toyota/Lexus 2004+ | Same family only |
| Toyota Red | IAT | Red | Toyota pre-2004 | IAT only |
| Honda Type 2 | OAT | Blue | Honda/Acura 2004+ | Honda Type 2 only |
| GM Dex-Cool | OAT | Orange | GM 1996+ | Dex-Cool only |
| Mopar OAT | HOAT | Orange | FCA 2013+ | Mopar HOAT |
| Mazda FL22 | OAT | Green | Mazda 2002+ | FL22 only |
| Ford Motorcraft Orange | HOAT | Orange | Ford 2002+ | Ford Orange |
| Subaru Super Coolant | OAT | Blue | Subaru 2008+ | Subaru only |
| Hyundai-Kia LLC | OAT | Blue | Hyundai-Kia 2008+ | Hyundai-Kia only |

## The mixing rule

**Within the same family, you can mix freely.** Across families, never.

If you mix OAT with IAT, the silicates precipitate out as gel that clogs the radiator. If you mix Dex-Cool with conventional green, the entire system corrodes within 6 months.

In an emergency (highway shoulder, leaking system), distilled water is safer than the wrong coolant. Top off with water and drain/flush within a week.

## Why the color codes lie

Coolant dye is not standardized. The pink in Toyota SLLC is *not* the same chemistry as the pink in VW G12+. The color is for visibility, not technology identification. **Always check the label.**

## Universal/"all makes" coolants

Products like Prestone All Makes, Zerex G-05, Peak Universal claim cross-OEM compatibility. The fine print: they meet *only* the additive specs the OEM tests for. They don't perfectly replicate the corrosion protection of a true OEM fluid. Fine for older / out-of-warranty cars; not for new BMW / Audi / Porsche where spec compliance affects warranty.

## Distilled water, not tap

If you're mixing 50/50 (most US coolant ships pre-mixed; some EU ships concentrate), use *distilled* water. Tap water has dissolved minerals that precipitate inside the cooling system over time. Sources: ~$1.50/gallon at any grocery store.

## Lifetime coolant — is it real?

OEMs market some HV-coolant loops (Tesla, BMW i4, Volvo XC90 T8) as "lifetime fill." This usually means inspect-only at the documented interval, with full replacement only if pH drops below spec or if a major component is replaced. For ICE cars, "lifetime" is marketing — flush at 100,000-150,000 mi regardless.

## Look up your spec

Every gen page lists the OEM coolant spec, color, and capacity on the [coolant topic page]. The maintenance schedule shows the replace-by interval.`,
    faq: [
      [
        "Can I mix Dex-Cool (orange) with green coolant?",
        "No. Dex-Cool is OAT; green is IAT. Mixing them precipitates silicates as gel and corrodes the radiator. If accidentally mixed, drain and full-flush ASAP. Distilled water is safer in an emergency.",
      ],
      [
        "Are all pink coolants the same?",
        "No. Toyota SLLC pink, VW G12+ pink, and Hyundai LLC pink are all OAT but use different organic acids. Color is OEM-chosen for visibility, not chemistry. Match the spec on the bottle, not the color.",
      ],
      [
        "Is universal coolant safe for my car?",
        "Within the warranty period, no — use OEM-spec. Out of warranty: universal is OK for most older vehicles but not optimal. The cost difference is $10-20 per change; matching OEM spec is worth it.",
      ],
      [
        "How often should I flush coolant?",
        "OAT formulas: every 5 years or 100,000-150,000 mi. IAT (green): 2 years / 30,000 mi. HV coolant loops on EVs/PHEVs: inspect every 2 years, replace only if pH/condition triggers it. Look up your gen's spec on the maintenance schedule page.",
      ],
    ],
  },
  {
    slug: "serpentine-belt-replacement",
    title: "When to replace a serpentine belt (and what fails when it breaks)",
    description:
      "Modern serpentine belts last 60,000-100,000 mi. The replacement window is wide, but the failure mode is catastrophic on engines that share belt + water pump. Here's the inspection method and per-OEM intervals.",
    body: `## What it drives

The serpentine belt (a single multi-rib belt vs the old V-belt era) typically drives:

- Alternator
- Power steering pump (or eHPS if electric)
- A/C compressor
- Water pump (most modern engines)
- Crankshaft balancer pulley (some engines)
- Smog/secondary air pump (some engines)

If the belt snaps mid-drive, all of these stop. On engines where the *water pump* is belt-driven, this is the dangerous combination: no coolant flow → overheat in 1-3 minutes → head gasket failure → engine ruined.

## OEM replacement intervals

| OEM | Interval (normal duty) | Notes |
|---|---|---|
| Honda/Acura | 60,000-100,000 mi | Inspect first, replace by condition |
| Toyota/Lexus | 100,000 mi | Most pre-2010s; modern: inspect |
| Subaru | 60,000 mi | Some models share belt-driven WP |
| GM 4-cyl/V6 | 90,000-100,000 mi | LFY / 1.5T / 2.0T |
| GM V8 (LS-series) | 100,000+ mi | Inspect at 60k |
| Ford EcoBoost | 100,000 mi | Inspect at 75k |
| BMW (most) | Inspect every service | CBS-driven |
| Mercedes | 100,000 mi (no specific interval) | Inspect every 30k |
| Mazda Skyactiv | 60,000 mi | Belt + tensioner combo |
| VW/Audi | 60,000-100,000 mi | Single-rib vs poly-V varies by engine |

## Inspection — how to tell if it's done

Modern EPDM rubber belts don't crack — they *wear* (lose rib depth). A belt with worn ribs slips, especially on the alternator pulley, producing:

1. Squealing on cold start
2. Battery voltage dropping under load
3. Visible rib-edge fraying

OEMs sell **belt-wear gauges** for ~$10 (or use the eyeball-the-rib-shape test). If you can see daylight between the belt and the pulley grooves, it's slipping.

## What also dies with the belt

When you replace a belt, plan to inspect and probably replace:

1. **Tensioner** — the spring-loaded pulley that holds the belt taut. Tensioner bearings are the #1 wear point on engines with 100k+ mi. A loose tensioner causes belt slip even on a fresh belt.
2. **Idler pulley(s)** — sometimes 1-3 idler pulleys. Same bearing wear pattern.
3. **Crank pulley dampener** — a separate replacement on some engines (Subaru, GM LS), but should be inspected for separation.

Cost: belt alone $25-40 OEM; tensioner $80-120; idler $30-60. Total job $150-250 in parts, 1-2 hours labor.

## Don't confuse with timing belt

This is the serpentine (auxiliary) belt — external, visible, drives accessories.

A *timing belt* is internal, drives the camshafts in sync with the crankshaft, and is on a strict OEM-mandated interval (60,000-105,000 mi). Modern engines moved to *timing chains* (no replacement interval) — but if your engine has a timing belt, missing the interval = bent valves + new engine. Check whether yours is belt or chain on the [parts page].

## Catastrophic failure scenarios

The worst case: a 2010s GM 1.5T with a belt-driven water pump and a snapped belt at highway speed. Coolant temp climbs from 200 °F to 260 °F in under 2 minutes. The aluminum head warps before you can pull over. Head gasket job ($1,500+) becomes a full short-block ($4,000+).

The second-worst: a Subaru EJ-series with belt failure on the freeway. Same overheat path, plus the boxer head is dual-aluminum (more expensive to machine).

**The fix:** replace by interval, not by symptom.`,
    faq: [
      [
        "How can I tell if my serpentine belt is the original?",
        "Look for a date code molded into the belt — usually a 4-digit YYWW. If the code is older than 7 years or the belt has been on >80,000 mi, it's near end-of-life regardless of how it looks.",
      ],
      [
        "Can I drive a few more miles on a squealing belt?",
        "Short trips at low speed, yes. Highway driving, no — slip will cook the alternator and overheat the engine on water-pump-driven systems. Replace within a week of first squeal.",
      ],
      [
        "Does an EV have a serpentine belt?",
        "Most pure BEVs (Tesla, Polestar, Lucid) have no serpentine belt — accessories are 12V-driven from the HV battery. Some hybrids (Toyota HSD, Honda IMA) keep a small belt for the A/C compressor on engine-on cycles. Check your gen's parts page.",
      ],
      [
        "Should I replace the tensioner with the belt?",
        "Above 80,000 mi, yes — the tensioner bearing is the limiting factor, and reusing a worn tensioner with a new belt causes the new belt to slip. Below 60,000 mi, inspect (no slop in pulley, smooth bearing rotation) and reuse.",
      ],
    ],
  },
  {
    slug: "severe-duty-vs-normal-duty",
    title: "Severe duty vs normal duty maintenance: when each applies",
    description:
      "Most owners qualify as severe duty without realising it. The trigger list, what gets shortened (and what doesn't), and how to read your specific car's split schedule.",
    body: `## What "severe duty" actually means

The manufacturer's "severe duty" schedule isn't a marketing term — it's a separate schedule in your owner's manual triggered by specific driving conditions. The standard triggers are:

- Trips under 5 mi (8 km), especially in cold weather — the oil never reaches full operating temperature, so fuel dilution and water condensation accumulate
- Stop-and-go traffic for the majority of mileage
- Driving on dusty or unpaved roads
- Towing or heavy hauling above ~50% of rated capacity
- Sustained operation in extreme heat (> 32 °C / 90 °F) or cold (< -18 °C / 0 °F)
- Idling for extended periods (often defined as > 30 minutes per shift)

Most owners genuinely qualify for severe duty even when they don't realise it — short urban commutes are the single most common trigger.

## How much shorter are the intervals?

Typical compressions seen across mainstream brands:

- **Engine oil**: from 7,500 → 5,000 mi  (12,000 → 8,000 km)
- **Transmission fluid**: from 60,000 → 30,000 mi
- **Air filter**: from 30,000 → 15,000 mi
- **Differential / transfer case fluid**: from 60,000 → 30,000 mi
- **Coolant flush**: typically unchanged (chemistry-driven, not load-driven)
- **Brake fluid**: typically unchanged (moisture-absorption-driven)
- **Spark plugs**: typically unchanged

The compressions cluster on items where fuel dilution, soot loading, or thermal cycling drive degradation.

## When the OEM expects severe duty by default

Some manufacturers (Toyota, Honda) explicitly state in the manual that "most" driving qualifies as severe. Others (BMW, Mercedes-Benz, Audi) use a Condition Based Service (CBS) system that calculates the actual interval from on-board sensors rather than splitting normal/severe schedules — your iDrive or COMAND screen will show the remaining mileage to next service.

## A practical heuristic

If any of these is true for at least 30% of your annual mileage, treat your car as severe duty:

1. Average trip distance under 10 mi
2. Below freezing on > 60 days/year at startup
3. Any routine towing
4. Stop-and-go traffic for > 1 hour daily

If none apply, the normal-duty schedule is appropriate.

## Why does the OEM split the schedule at all?

Two reasons. First, advertised maintenance cost (cost-of-ownership figures) uses the normal-duty schedule, so manufacturers have an incentive to keep that interval as long as the engine can tolerate. Second, warranty terms tie to "following the maintenance schedule applicable to your driving conditions" — if you exceed normal-duty intervals while driving severe-duty conditions, a powertrain failure can be denied under warranty.

## Find the exact split for your car

The maintenance schedule page for every generation on ownerspecs.com lists normal-duty and severe-duty mileages side by side, sourced from the OEM owner's manual. The exact compression varies enough between manufacturers that a generic "halve it" rule is wrong as often as right — look up your gen.`,
    faq: [
      [
        "Is severe duty just normal duty with one shorter interval?",
        "No — multiple intervals are typically shortened (oil, transmission fluid, air filter, differentials). The exact list varies per OEM; coolant flush and brake fluid flush usually stay the same because they're driven by chemistry and moisture absorption rather than load.",
      ],
      [
        "Does following severe duty on a car driven normally hurt anything?",
        "No mechanical harm, but you spend more on maintenance than necessary. Some owners default to severe to be conservative; it's a cost decision, not a safety one.",
      ],
      [
        "If I tow once a year on a road trip, am I severe duty?",
        "Not from one trip. The OEM definitions imply sustained or routine exposure. A weekend with a small trailer doesn't move you into severe duty — repeated weekly towing or commercial use does.",
      ],
      [
        "What's the difference between severe duty and 'driving conditions' on European cars?",
        "European OEMs typically use Condition Based Service (CBS) instead of a binary normal/severe split — sensors compute actual oil life, brake pad wear and brake fluid moisture. The CBS schedule effectively replaces the US-style severe schedule.",
      ],
      [
        "Does the dealer override severe duty by default?",
        "Dealer service writers usually default to normal duty unless you state your conditions. If you tow or commute short distances, mention it — they can flag your car for the severe-duty reminder cadence in the DMS.",
      ],
    ],
  },
  {
    slug: "engines-shared-across-vehicles",
    title: "How to find every vehicle that uses your engine",
    description:
      "Modern engines often serve five or more different vehicles. The engine code, oil capacity, spark plug PN and torque values are identical across them — but body, gearbox and final drive aren't. Here's what carries over and what doesn't.",
    body: `## Why engines are shared

A modern internal combustion engine costs hundreds of millions of dollars to design, certify and tool for production. Manufacturers amortise that cost by using the same engine across as many vehicles as possible — sometimes within the same brand (BMW's B58 inline-six powers the 340i, 540i, X3 M40i, X4 M40i, X5 xDrive40i, X6 xDrive40i, X7 xDrive40i, M340i, Z4 M40i, Supra 3.0 and Morgan Plus Six) and sometimes across brands when companies share platforms or supply each other.

The most-shared engines tend to be:

- Mid-displacement four-cylinders that work in compact, mid-size and small-SUV applications (Toyota A25A, Honda L15B, Hyundai G4FJ / Smartstream G2.5)
- Turbocharged inline-sixes used in luxury sedans and SUVs (BMW B58, Mercedes M256)
- V6 truck engines (Ford 2.7 / 3.5 EcoBoost, Toyota 2GR, Stellantis Pentastar)

## What carries over between vehicles with the same engine

Specifications that depend purely on the engine carry over identically:

- **Engine oil capacity** (within a ~0.2 L tolerance for sump variations)
- **Oil viscosity grade** and OEM specification
- **Oil filter part number** (sometimes — depends on accessibility / packaging)
- **Spark plug part number and gap**
- **Spark plug torque**
- **Oil drain plug torque**
- **Coolant capacity** (varies more — depends on radiator and hose routing per vehicle)
- **Air filter dimensions** (the housing is usually shared)
- **Service intervals** for engine-scoped items (spark plug interval, timing belt / chain, valve adjustment)

## What does NOT carry over

Specifications that depend on the chassis or drivetrain do not:

- **Transmission type and fluid** (a 335i runs the ZF 8HP, an N55-equipped M2 runs a DCT or 6MT — different fluid)
- **Drive ratio and differential fluid**
- **Brake rotor / pad sizes**, lug nut torque (depends on wheel and brake package)
- **Tire size and pressure**
- **Battery group, alternator output, fuse layout**

The rule of thumb: anything inside the engine block or in direct contact with engine internals carries over. Anything that connects the engine to the road does not.

## How to look up your engine code

The engine code (e.g. \`N55B30A\`, \`A25A-FKS\`, \`B58B30M0\`) is stamped on the block and usually printed on the owner''s manual identification page. On most modern cars it also shows on the engine bay sticker near the strut tower. Once you have the code, the engine catalogue at \`ownerspecs.com/engines/{code}\` lists every vehicle in our database that uses it, with direct links to each vehicle''s oil capacity, torque values and OEM part numbers.

## Caveats

Same engine code does not always mean identical tune. Manufacturers commonly issue the same physical engine in multiple states of tune — different ECU calibration, intercooler size, exhaust manifold or fuel injectors. The B58 in a 540i and a Supra 3.0 produce different horsepower from the same block. Mechanical service items still carry over; performance numbers do not.

Some engines have minor production-year revisions (different intake camshafts, different oil pump) that change oil capacity by 0.2-0.4 L or shift the spark plug torque. Always cross-check with your specific vehicle's owner manual before relying on a cross-vehicle figure.`,
    faq: [
      [
        "If my BMW 335i and a Z4 sDrive35is both have the N54, are the maintenance schedules the same?",
        "The engine-scoped items (spark plug interval, oil drain interval, valve cover gasket torque, oil filter PN) are identical. The transmission service interval differs — the 335i could be ordered with a 6MT or ZF6HP/ZF7HP/ZF8HP automatic, while the Z4 sDrive35is was DCT-only. Look up each vehicle's transmission fluid page separately.",
      ],
      [
        "How do I find the engine code on my car?",
        "Three places: (1) the owner's manual under 'Identification', (2) the engine bay sticker on or near the strut tower, (3) stamped on the engine block itself (usually on the side of the block visible from above). Some manufacturers use a separate sales designation (e.g. 'TFSI') and a different internal code (e.g. EA888) — the catalogue uses the internal code.",
      ],
      [
        "If the engine is shared with another car, can I buy parts from that car's dealer?",
        "For engine-scoped parts (oil filter, spark plug, air filter, sometimes coolant), yes — they're the same part number from the same supplier. For accessory parts that bolt to the engine (alternator, AC compressor, power steering pump on older cars), the part may differ even though the engine block is shared, because the accessory bracket layout often differs per vehicle. Cross-check the part number, not just the engine code.",
      ],
      [
        "Do tuners use the same map on the same engine in different cars?",
        "No. Even when the engine block is identical, the ECU mapping accounts for the vehicle's transmission, fuel-octane rating in the target market, intake / exhaust restrictions and emissions calibration. A 335i ECU flash will not run correctly on a Z4 sDrive35is even though both have the N54.",
      ],
      [
        "Where does ownerspecs list shared-engine information?",
        "On every engine catalogue page (\`/engines/{code}\`), and as a 'Same engine, other vehicles' section on oil-capacity, coolant, transmission-fluid, torque, parts and maintenance-schedule pages where engine-scoped data is shown.",
      ],
    ],
  },
];

export function generateStaticParams() {
  return GUIDES.map((g) => ({ slug: g.slug }));
}

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const g = GUIDES.find((x) => x.slug === slug);
  if (!g) return {};
  return pageMetadata({
    title: g.title,
    description: g.description,
    path: `/guides/${g.slug}`,
  });
}

export default async function GuidePage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const g = GUIDES.find((x) => x.slug === slug);
  if (!g) notFound();

  const faq = faqJsonLd(g.faq.map(([q, a]) => ({ q, a })));
  const article = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: g.title,
    description: g.description,
    url: `https://ownerspecs.com/guides/${g.slug}`,
    publisher: {
      "@type": "Organization",
      name: "ownerspecs",
      url: "https://ownerspecs.com",
    },
    inLanguage: "en",
  };

  return (
    <>
      <SiteHeader />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(article) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faq) }} />
      <div className="shell guide-shell">
        <nav className="crumb">
          <Link href="/">Catalogue</Link>
          <span className="sep">/</span>
          <Link href="/guides">Guides</Link>
          <span className="sep">/</span>
          <span>{g.title}</span>
        </nav>
        <header className="pagehead">
          <h1>{g.title}</h1>
          <p className="sub">{g.description}</p>
        </header>

        <article
          className="prose-body"
          dangerouslySetInnerHTML={{ __html: renderMarkdown(g.body) }}
        />

        <section className="faq-block">
          <h2 className="section-h">FAQ</h2>
          <dl className="faq-list">
            {g.faq.map(([q, a]) => (
              <div key={q} className="faq-item">
                <dt>{q}</dt>
                <dd>{a}</dd>
              </div>
            ))}
          </dl>
        </section>

        <p className="guide-footnote">
          Looking for your car&apos;s specific number? Search by{" "}
          <Link href="/">make / model</Link> or{" "}
          <Link href="/search">use the catalogue search</Link>.
        </p>
      </div>
      <SiteFooter />
    </>
  );
}
