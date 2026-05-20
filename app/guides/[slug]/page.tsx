import { notFound } from "next/navigation";
import Link from "next/link";
import { pageMetadata, faqJsonLd } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";
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
];

export function generateStaticParams() {
  return GUIDES.map((g) => ({ slug: g.slug }));
}

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const g = GUIDES.find((x) => x.slug === slug);
  if (!g) return {};
  return pageMetadata({
    title: `${g.title} · ownerspecs`,
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
    <div className="min-h-screen bg-slate-50 text-slate-900">
      <SiteHeader />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(article) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faq) }} />
      <main className="mx-auto max-w-3xl px-6 py-12">
        <nav className="text-xs font-mono text-slate-500 mb-4">
          <Link href="/" className="hover:underline">Catalogue</Link>
          {" · "}
          <Link href="/guides" className="hover:underline">Guides</Link>
          {" · "}
          <span className="text-slate-700">{g.slug}</span>
        </nav>
        <h1 className="text-4xl font-semibold tracking-tight">{g.title}</h1>
        <p className="mt-3 text-slate-700">{g.description}</p>

        <article className="prose prose-slate mt-8 max-w-none prose-headings:font-semibold prose-headings:tracking-tight prose-h2:mt-10 prose-h2:text-2xl prose-h3:mt-6 prose-h3:text-lg prose-p:text-slate-700 prose-li:text-slate-700 prose-table:text-sm">
          <div dangerouslySetInnerHTML={{ __html: renderMarkdown(g.body) }} />
        </article>

        <section className="mt-12 rounded-xl border border-slate-200 bg-white p-6">
          <h2 className="text-lg font-semibold">FAQ</h2>
          <dl className="mt-4 space-y-4">
            {g.faq.map(([q, a]) => (
              <div key={q}>
                <dt className="font-semibold text-slate-900">{q}</dt>
                <dd className="mt-1 text-sm text-slate-700">{a}</dd>
              </div>
            ))}
          </dl>
        </section>

        <p className="mt-10 text-sm text-slate-500">
          Looking for your car's specific number? Search by{" "}
          <Link href="/" className="text-sky-700 hover:underline">make / model</Link>
          {" "}or{" "}
          <Link href="/search" className="text-sky-700 hover:underline">use the catalogue search</Link>.
        </p>
      </main>
    </div>
  );
}
