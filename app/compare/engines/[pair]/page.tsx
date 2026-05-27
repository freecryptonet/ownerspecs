import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { pageMetadata, faqJsonLd } from "@/lib/seo";
import { displacementDual, boreStrokeDual } from "@/lib/units";
import { ENGINE_PAIRS, splitEnginePair } from "@/lib/engineCompare";

type Params = { pair: string };

type Engine = {
  id: number;
  code: string;
  slug: string;
  display_name: string;
  displacement_cc: number | null;
  fuel: string;
  aspiration: string | null;
  valvetrain: string | null;
  cylinders: number | null;
  bore_mm: string | null;
  stroke_mm: string | null;
  compression: string | null;
};

type Output = {
  min_hp: number | null;
  max_hp: number | null;
  min_t: number | null;
  max_t: number | null;
  trim_count: number;
};

type Application = {
  brand_slug: string;
  brand_name: string;
  model_name: string;
  gen_slug: string;
  gen_display: string;
  start_year: number;
  end_year: number | null;
};

async function getEngine(slug: string): Promise<Engine | null> {
  return queryOne<Engine>(
    `SELECT id, code, slug, display_name, displacement_cc, fuel, aspiration,
            valvetrain, cylinders, bore_mm, stroke_mm, compression
     FROM engines WHERE slug = ? LIMIT 1`,
    [slug],
  );
}

async function getOutput(engineId: number): Promise<Output> {
  const row = await queryOne<Output>(
    `SELECT MIN(hp) AS min_hp, MAX(hp) AS max_hp,
            MIN(torque_nm) AS min_t, MAX(torque_nm) AS max_t,
            COUNT(*) AS trim_count
     FROM trims WHERE engine_id = ?`,
    [engineId],
  );
  return row ?? { min_hp: null, max_hp: null, min_t: null, max_t: null, trim_count: 0 };
}

async function getApplications(engineId: number): Promise<Application[]> {
  return query<Application>(
    `SELECT DISTINCT mk.slug AS brand_slug, mk.name AS brand_name, m.name AS model_name,
            g.slug AS gen_slug, g.display_name AS gen_display, g.start_year, g.end_year
     FROM trims t
     JOIN generations g ON g.id = t.generation_id
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE t.engine_id = ? AND g.is_active = 1
     ORDER BY g.start_year`,
    [engineId],
  );
}

const num = (v: string | number | null | undefined): number | null => {
  if (v == null) return null;
  const n = typeof v === "string" ? parseFloat(v) : v;
  return isFinite(n) ? n : null;
};

const hpRange = (o: Output): string =>
  o.min_hp != null && o.max_hp != null
    ? o.min_hp === o.max_hp ? `${o.min_hp} hp` : `${o.min_hp}–${o.max_hp} hp`
    : "—";
const tqRange = (o: Output): string =>
  o.min_t != null && o.max_t != null
    ? o.min_t === o.max_t ? `${o.min_t} N·m` : `${o.min_t}–${o.max_t} N·m`
    : "—";

export async function generateStaticParams(): Promise<Params[]> {
  return ENGINE_PAIRS.map(([a, b]) => ({ pair: `${a}-vs-${b}` }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { pair } = await params;
  const split = splitEnginePair(pair);
  if (!split) return { title: "Not found" };
  const [eA, eB] = await Promise.all([getEngine(split[0]), getEngine(split[1])]);
  if (!eA || !eB) return { title: "Not found" };
  return pageMetadata({
    title: `${eA.code} vs ${eB.code} — engine specs compared`,
    description: `${eA.code} vs ${eB.code}: displacement, bore and stroke, compression ratio, valvetrain, power and torque compared side by side, plus the models each engine powers.`,
    path: `/compare/engines/${pair}`,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { pair } = await params;
  const split = splitEnginePair(pair);
  if (!split) notFound();
  const [eA, eB] = await Promise.all([getEngine(split[0]), getEngine(split[1])]);
  if (!eA || !eB) notFound();

  const [oA, oB, aA, aB] = await Promise.all([
    getOutput(eA.id),
    getOutput(eB.id),
    getApplications(eA.id),
    getApplications(eB.id),
  ]);

  // Key differences (computed from data) — the answer content + SEO body.
  const diffs: string[] = [];
  const dA = num(eA.displacement_cc), dB = num(eB.displacement_cc);
  if (dA != null && dB != null && dA !== dB) {
    const [big, small] = dA > dB ? [eA, eB] : [eB, eA];
    diffs.push(`The ${big.code} displaces ${big.displacement_cc} cm³ — ${Math.abs(dA - dB)} cm³ more than the ${small.code} (${small.displacement_cc} cm³).`);
  }
  const bA = num(eA.bore_mm), bB = num(eB.bore_mm), sA = num(eA.stroke_mm), sB = num(eB.stroke_mm);
  if (bA != null && bB != null && sA != null && sB != null) {
    if (bA === bB && sA !== sB) {
      const longer = sA > sB ? eA : eB;
      diffs.push(`Both share a ${bA} mm bore; the ${longer.code}'s longer ${Math.max(sA, sB)} mm stroke (vs ${Math.min(sA, sB)} mm) accounts for the extra capacity — a more undersquare, torque-biased design.`);
    }
  }
  const cA = num(eA.compression), cB = num(eB.compression);
  if (cA != null && cB != null && cA !== cB) {
    const [hi, lo] = cA > cB ? [eA, eB] : [eB, eA];
    diffs.push(`The ${hi.code} runs a higher ${cA > cB ? cA : cB}:1 compression ratio (vs ${cA > cB ? cB : cA}:1) — a more performance-oriented tune.`);
  }
  if (oA.max_hp != null && oB.max_hp != null && oA.max_hp !== oB.max_hp) {
    const [hi, hiO, lo, loO] = oA.max_hp > oB.max_hp ? [eA, oA, eB, oB] : [eB, oB, eA, oA];
    diffs.push(`In the cars we list, the ${hi.code} peaks at ${hiO.max_hp} hp${hiO.max_t ? ` / ${hiO.max_t} N·m` : ""}, against ${loO.max_hp} hp${loO.max_t ? ` / ${loO.max_t} N·m` : ""} for the ${lo.code}.`);
  }

  const faqs: Array<{ q: string; a: string }> = [];
  if (oA.max_hp != null && oB.max_hp != null) {
    const [hi, hiO, lo, loO] = oA.max_hp >= oB.max_hp ? [eA, oA, eB, oB] : [eB, oB, eA, oA];
    faqs.push({
      q: `Which is more powerful, the ${eA.code} or the ${eB.code}?`,
      a: `The ${hi.code} makes up to ${hiO.max_hp} hp, compared with ${loO.max_hp} hp for the ${lo.code} in the applications listed here.`,
    });
  }
  if (dA != null && dB != null) {
    faqs.push({
      q: `What's the difference between the ${eA.code} and ${eB.code}?`,
      a: `The ${eA.code} is a ${eA.displacement_cc} cm³ ${eA.cylinders ?? ""}-cylinder${eA.valvetrain ? ` ${eA.valvetrain}` : ""} engine; the ${eB.code} is ${eB.displacement_cc} cm³. ${diffs[1] ?? ""}`.trim(),
    });
  }

  const yr = (s: number, e: number | null) => (e ? `${s}–${e}` : `${s}–present`);

  const Card = ({ e, o, apps }: { e: Engine; o: Output; apps: Application[] }) => (
    <div style={{ border: "1px solid var(--rule)", background: "var(--bg-alt)", padding: "16px 18px" }}>
      <div style={{ fontFamily: "var(--font-mono)", fontSize: 22, fontWeight: 600 }}>
        <a href={`/engines/${e.slug}`} style={{ color: "var(--ink)" }}>{e.code}</a>
      </div>
      <div style={{ fontSize: 13, color: "var(--ink-soft)", marginTop: 2 }}>{e.display_name}</div>
      <div style={{ fontFamily: "var(--font-mono)", fontSize: 12, color: "var(--ink-mute)", marginTop: 8 }}>
        {e.displacement_cc ? `${(e.displacement_cc / 1000).toFixed(1)} L` : "—"} · {hpRange(o)} · {tqRange(o)}
      </div>
      <div style={{ fontSize: 12, color: "var(--ink-mute)", marginTop: 8 }}>
        {apps.length > 0 ? `Powers ${apps.length} generation${apps.length === 1 ? "" : "s"} in our catalogue` : "No catalogue applications yet"}
      </div>
    </div>
  );

  const cmpRow = (label: string, a: React.ReactNode, b: React.ReactNode) => (
    <tr>
      <th style={{ width: "30%" }}>{label}</th>
      <td><strong>{a}</strong></td>
      <td><strong>{b}</strong></td>
    </tr>
  );

  const AppList = ({ apps }: { apps: Application[] }) => (
    apps.length === 0 ? <span style={{ color: "var(--ink-mute)" }}>—</span> : (
      <ul style={{ listStyle: "none", padding: 0, margin: 0 }}>
        {apps.map((ap) => (
          <li key={ap.gen_slug} style={{ padding: "4px 0" }}>
            <a href={`/${ap.brand_slug}/${ap.gen_slug}`} style={{ color: "var(--ink)" }}>
              {ap.brand_name} {ap.model_name} {ap.gen_display}
            </a>
            <span style={{ fontFamily: "var(--font-mono)", fontSize: 12, color: "var(--ink-mute)" }}> · {yr(ap.start_year, ap.end_year)}</span>
          </li>
        ))}
      </ul>
    )
  );

  return (
    <>
      <SiteHeader />
      {faqs.length >= 2 && (
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd(faqs)) }} />
      )}

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <a href="/engines">Engines</a><span className="sep">/</span>
          <span>{eA.code} vs {eB.code}</span>
        </nav>
        <div className="pagehead">
          <h1>{eA.code} vs {eB.code}</h1>
          <div className="sub">
            <span>{eA.display_name}</span>
            <span className="pip"></span>
            <span>{eB.display_name}</span>
          </div>
        </div>
      </div>

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16 }}>
            <Card e={eA} o={oA} apps={aA} />
            <Card e={eB} o={oB} apps={aB} />
          </div>
        </section>

        {diffs.length > 0 && (
          <section>
            <h2 className="section-h">Key differences</h2>
            <ul style={{ margin: 0, paddingLeft: 18, lineHeight: 1.6, fontSize: 14, color: "var(--ink-soft)" }}>
              {diffs.map((d, i) => <li key={i} style={{ marginBottom: 6 }}>{d}</li>)}
            </ul>
          </section>
        )}

        <section>
          <h2 className="section-h">Engine internals</h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr><th></th><th>{eA.code}</th><th>{eB.code}</th></tr>
            </thead>
            <tbody>
              {cmpRow("Displacement", displacementDual(eA.displacement_cc), displacementDual(eB.displacement_cc))}
              {cmpRow("Bore × stroke", boreStrokeDual(eA.bore_mm, eA.stroke_mm), boreStrokeDual(eB.bore_mm, eB.stroke_mm))}
              {cmpRow("Compression ratio", eA.compression ? `${eA.compression}:1` : "—", eB.compression ? `${eB.compression}:1` : "—")}
              {cmpRow("Cylinders", eA.cylinders ?? "—", eB.cylinders ?? "—")}
              {cmpRow("Valvetrain", eA.valvetrain ?? "—", eB.valvetrain ?? "—")}
              {cmpRow("Aspiration", eA.aspiration ?? "—", eB.aspiration ?? "—")}
              {cmpRow("Fuel", eA.fuel, eB.fuel)}
            </tbody>
          </table>
        </section>

        <section>
          <h2 className="section-h">Output (across listed applications)</h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr><th></th><th>{eA.code}</th><th>{eB.code}</th></tr>
            </thead>
            <tbody>
              {cmpRow("Power", hpRange(oA), hpRange(oB))}
              {cmpRow("Torque", tqRange(oA), tqRange(oB))}
            </tbody>
          </table>
        </section>

        <section>
          <h2 className="section-h">Where each engine is used</h2>
          <table className="spec-table">
            <thead style={{ background: "var(--bg-alt)" }}>
              <tr><th style={{ width: "50%" }}>{eA.code}</th><th style={{ width: "50%" }}>{eB.code}</th></tr>
            </thead>
            <tbody>
              <tr>
                <td style={{ verticalAlign: "top" }}><AppList apps={aA} /></td>
                <td style={{ verticalAlign: "top" }}><AppList apps={aB} /></td>
              </tr>
            </tbody>
          </table>
        </section>

        {faqs.length > 0 && (
          <section>
            <h2 className="section-h">Frequently asked</h2>
            <dl>
              {faqs.map((f) => (
                <div key={f.q} style={{ borderTop: "1px solid var(--rule)", padding: "14px 0" }}>
                  <dt style={{ fontWeight: 600, fontSize: 14, marginBottom: 4 }}>{f.q}</dt>
                  <dd style={{ margin: 0, color: "var(--ink-soft)", fontSize: 13, lineHeight: 1.55 }}>{f.a}</dd>
                </div>
              ))}
            </dl>
          </section>
        )}

        <section>
          <h2 className="section-h">Full engine pages</h2>
          <ul style={{ listStyle: "none", padding: 0, margin: 0, display: "grid", gridTemplateColumns: "repeat(2, 1fr)", gap: 8 }}>
            <li><a href={`/engines/${eA.slug}`} style={{ display: "block", padding: "12px 16px", border: "1px solid var(--rule)", color: "var(--ink)" }}><strong>{eA.code}</strong> — full specs, oil capacity, applications</a></li>
            <li><a href={`/engines/${eB.slug}`} style={{ display: "block", padding: "12px 16px", border: "1px solid var(--rule)", color: "var(--ink)" }}><strong>{eB.code}</strong> — full specs, oil capacity, applications</a></li>
          </ul>
        </section>
      </main>

      <SiteFooter reviewDate={new Date().toISOString().slice(0, 10)} />
    </>
  );
}
