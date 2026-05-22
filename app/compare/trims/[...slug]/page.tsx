import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { pageMetadata } from "@/lib/seo";
import { displacementDual, boreStrokeDual, kgDual, speedDual, consumptionDual } from "@/lib/units";

// Trim-vs-trim comparison route per herstructureringsplan §5. Long-tail SEO
// gold: "320i vs 320d", "M3 vs M4", "330i vs 330e". Data is auto-generated
// from existing trim/engine/fluid rows — no editorial copy needed.
//
// URL: /compare/trims/{brand}/{gen-slug}/{trim-slug}/vs/{brand}/{gen-slug}/{trim-slug}
//
// generateStaticParams emits every SAME-GEN trim pair (high-intent: visitors
// comparing two engines in the same lineup). Cross-gen pairs (320i F30 vs
// 320i G20) come from a curated list. Cross-brand cross-trim pairs are out
// of scope here — gen-vs-gen at /compare/[pair] already handles those.

type Slug = { slug: string[] };

type TrimRow = {
  trim_id: number;
  trim_slug: string;
  trim_name: string;
  hp: number | null;
  torque_nm: number | null;
  zero_100_kmh_s: string | null;
  top_speed_kmh: number | null;
  fuel_combined_l_100km: string | null;
  co2_g_km: number | null;
  curb_weight_kg: number | null;
  drive_wheel: string | null;
  tire_size: string | null;
  engine_id: number | null;
  engine_code: string | null;
  engine_display: string | null;
  engine_displacement_cc: number | null;
  engine_aspiration: string | null;
  engine_cylinders: number | null;
  engine_bore_mm: string | null;
  engine_stroke_mm: string | null;
  engine_compression: string | null;
  engine_fuel: string | null;
  transmission_name: string | null;
  brand_slug: string;
  brand_name: string;
  model_name: string;
  gen_id: number;
  gen_slug: string;
  gen_display: string;
  gen_start: number;
  gen_end: number | null;
  hero_url: string | null;
};

type FluidLite = {
  fluid_type: string;
  capacity_l: string | null;
  capacity_qt: string | null;
  viscosity: string | null;
  spec_standard: string | null;
};

// Curated cross-gen high-intent pairs. Each entry is a (brand, gen-slug, trim-slug)
// for each side. Same-gen pairs are auto-enumerated by generateStaticParams.
const CROSS_GEN_PAIRS: Array<{
  a: { brand: string; gen: string; trim: string };
  b: { brand: string; gen: string; trim: string };
}> = [
  // populated as data lands; left empty until specific trim slugs are known
];

function pathYears(start: number, end: number | null): string {
  return end ? `${start}–${end}` : `${start}–present`;
}

async function getTrim(
  brand: string,
  gen: string,
  trim: string,
): Promise<TrimRow | null> {
  return queryOne<TrimRow>(
    `SELECT
       t.id AS trim_id, t.slug AS trim_slug, t.name AS trim_name,
       t.hp, t.torque_nm, t.zero_100_kmh_s, t.top_speed_kmh,
       t.fuel_combined_l_100km, t.co2_g_km, t.curb_weight_kg,
       t.drive_wheel, t.tire_size,
       t.engine_id,
       e.code AS engine_code, e.display_name AS engine_display,
       e.displacement_cc AS engine_displacement_cc,
       e.aspiration AS engine_aspiration, e.cylinders AS engine_cylinders,
       e.bore_mm AS engine_bore_mm, e.stroke_mm AS engine_stroke_mm,
       e.compression AS engine_compression, e.fuel AS engine_fuel,
       tr.display_name AS transmission_name,
       mk.slug AS brand_slug, mk.name AS brand_name, mdl.name AS model_name,
       g.id AS gen_id, g.slug AS gen_slug, g.display_name AS gen_display,
       g.start_year AS gen_start, g.end_year AS gen_end,
       (SELECT url FROM images WHERE generation_id = g.id LIMIT 1) AS hero_url
     FROM trims t
     JOIN generations g    ON g.id  = t.generation_id
     JOIN models mdl        ON mdl.id = g.model_id
     JOIN makes mk          ON mk.id  = mdl.make_id
     LEFT JOIN engines e        ON e.id  = t.engine_id
     LEFT JOIN transmissions tr ON tr.id = t.transmission_id
     WHERE mk.slug = ? AND g.slug = ? AND t.slug = ? AND g.is_active = 1
     LIMIT 1`,
    [brand, gen, trim],
  );
}

async function getFluidsForTrim(
  genId: number,
  engineId: number | null,
): Promise<Map<string, FluidLite>> {
  const rows = await query<FluidLite & { engine_id: number | null }>(
    `SELECT fluid_type, engine_id, capacity_l, capacity_qt, viscosity, spec_standard
     FROM fluid_specs
     WHERE generation_id = ?
       AND (engine_id = ? OR engine_id IS NULL)
       AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_cvt','transmission_dct','brake','ac_refrigerant')`,
    [genId, engineId ?? 0],
  );
  // Prefer engine-scoped row when both engine-specific and gen-wide exist.
  const map = new Map<string, FluidLite>();
  for (const r of rows) {
    const existing = map.get(r.fluid_type);
    if (!existing || (existing.viscosity == null && r.viscosity != null) || r.engine_id != null) {
      map.set(r.fluid_type, r);
    }
  }
  return map;
}

function parseSlug(slug: string[]): {
  a: { brand: string; gen: string; trim: string };
  b: { brand: string; gen: string; trim: string };
} | null {
  // Expected: [brandA, genA, trimA, "vs", brandB, genB, trimB]
  const vsIdx = slug.indexOf("vs");
  if (vsIdx !== 3) return null;
  if (slug.length !== 7) return null;
  return {
    a: { brand: slug[0], gen: slug[1], trim: slug[2] },
    b: { brand: slug[4], gen: slug[5], trim: slug[6] },
  };
}

function pairPath(a: { brand: string; gen: string; trim: string }, b: typeof a): string {
  return `/compare/trims/${a.brand}/${a.gen}/${a.trim}/vs/${b.brand}/${b.gen}/${b.trim}`;
}

export async function generateStaticParams(): Promise<Slug[]> {
  // Same-gen trim pairs: every (gen, trim_a, trim_b) where trim_a.hp < trim_b.hp
  // (lower-HP first for canonical ordering, avoids both directions of the same pair).
  const pairs = await query<{
    brand: string;
    gen: string;
    trim_a: string;
    trim_b: string;
  }>(
    `SELECT mk.slug AS brand, g.slug AS gen, ta.slug AS trim_a, tb.slug AS trim_b
     FROM trims ta
     JOIN trims tb       ON tb.generation_id = ta.generation_id AND tb.id > ta.id
     JOIN generations g  ON g.id = ta.generation_id
     JOIN models mdl     ON mdl.id = g.model_id
     JOIN makes mk       ON mk.id = mdl.make_id
     WHERE g.is_active = 1
       AND ta.hp IS NOT NULL AND tb.hp IS NOT NULL`,
  );
  const params: Slug[] = pairs.map((p) => ({
    slug: [p.brand, p.gen, p.trim_a, "vs", p.brand, p.gen, p.trim_b],
  }));
  for (const cg of CROSS_GEN_PAIRS) {
    params.push({
      slug: [cg.a.brand, cg.a.gen, cg.a.trim, "vs", cg.b.brand, cg.b.gen, cg.b.trim],
    });
  }
  return params;
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Slug>;
}): Promise<Metadata> {
  const { slug } = await params;
  const parsed = parseSlug(slug);
  if (!parsed) return { title: "Not found" };
  const [tA, tB] = await Promise.all([
    getTrim(parsed.a.brand, parsed.a.gen, parsed.a.trim),
    getTrim(parsed.b.brand, parsed.b.gen, parsed.b.trim),
  ]);
  if (!tA || !tB) return { title: "Not found" };
  const titleA = `${tA.brand_name} ${tA.gen_display} ${tA.trim_name}`;
  const titleB = `${tB.brand_name} ${tB.gen_display} ${tB.trim_name}`;
  return pageMetadata({
    title: `${titleA} vs ${titleB} — Side-by-side specs`,
    description: `Detailed comparison of the ${titleA} (${pathYears(tA.gen_start, tA.gen_end)}) and ${titleB} (${pathYears(tB.gen_start, tB.gen_end)}). Engine, performance, fluids, weight, transmission and drivetrain — auto-generated from cross-verified sources.`,
    path: pairPath(parsed.a, parsed.b),
    heroPath: tA.hero_url ?? tB.hero_url,
  });
}

export default async function Page({ params }: { params: Promise<Slug> }) {
  const { slug } = await params;
  const parsed = parseSlug(slug);
  if (!parsed) notFound();
  const [tA, tB] = await Promise.all([
    getTrim(parsed.a.brand, parsed.a.gen, parsed.a.trim),
    getTrim(parsed.b.brand, parsed.b.gen, parsed.b.trim),
  ]);
  if (!tA || !tB) notFound();

  const [fA, fB] = await Promise.all([
    getFluidsForTrim(tA.gen_id, tA.engine_id),
    getFluidsForTrim(tB.gen_id, tB.engine_id),
  ]);

  const fmtCap = (l: string | null, qt: string | null): string => {
    if (!l && !qt) return "—";
    if (l && qt) return `${Number(qt).toFixed(1)} qt · ${Number(l).toFixed(1)} L`;
    if (l) return `${Number(l).toFixed(1)} L`;
    return `${Number(qt).toFixed(1)} qt`;
  };

  const oilA = fA.get("engine_oil");
  const oilB = fB.get("engine_oil");
  const coolA = fA.get("coolant");
  const coolB = fB.get("coolant");
  const transA = ["transmission_at", "transmission_mt", "transmission_cvt", "transmission_dct"]
    .map((k) => fA.get(k))
    .find(Boolean);
  const transB = ["transmission_at", "transmission_mt", "transmission_cvt", "transmission_dct"]
    .map((k) => fB.get(k))
    .find(Boolean);

  const Card = ({ t }: { t: TrimRow }) => (
    <div style={{ border: "1px solid var(--rule)", background: "var(--bg-alt)" }}>
      {t.hero_url && (
        <div style={{ aspectRatio: "16 / 9", overflow: "hidden" }}>
          <img
            src={t.hero_url}
            alt={`${t.brand_name} ${t.gen_display} ${t.trim_name}`}
            style={{ width: "100%", height: "100%", objectFit: "cover" }}
          />
        </div>
      )}
      <div style={{ padding: "14px 18px" }}>
        <div
          style={{
            fontSize: 11,
            fontWeight: 600,
            letterSpacing: "0.08em",
            textTransform: "uppercase",
            color: "var(--ink-soft)",
          }}
        >
          {t.brand_name} · {t.model_name}
        </div>
        <h3 style={{ fontSize: 18, fontWeight: 600, marginTop: 4 }}>
          <a
            href={`/${t.brand_slug}/${t.gen_slug}/${t.trim_slug}`}
            style={{ color: "var(--ink)" }}
          >
            {t.gen_display} {t.trim_name}
          </a>
        </h3>
        <div
          style={{
            fontFamily: "var(--font-mono)",
            fontSize: 12,
            color: "var(--ink-mute)",
            marginTop: 2,
          }}
        >
          {pathYears(t.gen_start, t.gen_end)}
          {t.engine_code ? ` · ${t.engine_code}` : ""}
          {t.transmission_name ? ` · ${t.transmission_name}` : ""}
        </div>
      </div>
    </div>
  );

  const Row = ({
    label,
    a,
    b,
  }: {
    label: string;
    a: React.ReactNode;
    b: React.ReactNode;
  }) => (
    <tr>
      <th style={{ width: "26%", textAlign: "left" }}>{label}</th>
      <td><strong>{a}</strong></td>
      <td><strong>{b}</strong></td>
    </tr>
  );

  return (
    <>
      <SiteHeader />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a>
          <span className="sep">/</span>
          <a href="/compare">Compare</a>
          <span className="sep">/</span>
          <span>
            {tA.trim_name} vs {tB.trim_name}
          </span>
        </nav>

        <div className="pagehead">
          <h1>
            {tA.brand_name} {tA.gen_display} {tA.trim_name} <span style={{ color: "var(--ink-mute)" }}>vs</span>{" "}
            {tB.brand_name} {tB.gen_display} {tB.trim_name}
          </h1>
          <div className="sub">
            <span>Side-by-side specifications</span>
            <span className="pip"></span>
            <span>Cross-verified data</span>
          </div>
        </div>
      </div>

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16 }}>
            <Card t={tA} />
            <Card t={tB} />
          </div>
        </section>

        <section>
          <h2 className="section-h">Performance</h2>
          <table className="spec-table">
            <tbody>
              <Row label="Horsepower" a={tA.hp ? `${tA.hp} hp` : "—"} b={tB.hp ? `${tB.hp} hp` : "—"} />
              <Row
                label="Torque"
                a={tA.torque_nm ? `${tA.torque_nm} N·m` : "—"}
                b={tB.torque_nm ? `${tB.torque_nm} N·m` : "—"}
              />
              <Row
                label="0–100 km/h"
                a={tA.zero_100_kmh_s ? `${tA.zero_100_kmh_s} s` : "—"}
                b={tB.zero_100_kmh_s ? `${tB.zero_100_kmh_s} s` : "—"}
              />
              <Row
                label="Top speed"
                a={tA.top_speed_kmh ? speedDual(tA.top_speed_kmh) : "—"}
                b={tB.top_speed_kmh ? speedDual(tB.top_speed_kmh) : "—"}
              />
              <Row
                label="Fuel (combined)"
                a={tA.fuel_combined_l_100km ? consumptionDual(tA.fuel_combined_l_100km) : "—"}
                b={tB.fuel_combined_l_100km ? consumptionDual(tB.fuel_combined_l_100km) : "—"}
              />
              <Row
                label="CO₂ emissions"
                a={tA.co2_g_km ? `${tA.co2_g_km} g/km` : "—"}
                b={tB.co2_g_km ? `${tB.co2_g_km} g/km` : "—"}
              />
              <Row
                label="Curb weight"
                a={tA.curb_weight_kg ? kgDual(tA.curb_weight_kg) : "—"}
                b={tB.curb_weight_kg ? kgDual(tB.curb_weight_kg) : "—"}
              />
            </tbody>
          </table>
        </section>

        <section>
          <h2 className="section-h">Engine</h2>
          <table className="spec-table">
            <tbody>
              <Row
                label="Engine code"
                a={tA.engine_code ?? "—"}
                b={tB.engine_code ?? "—"}
              />
              <Row
                label="Displacement"
                a={tA.engine_displacement_cc ? displacementDual(tA.engine_displacement_cc) : "—"}
                b={tB.engine_displacement_cc ? displacementDual(tB.engine_displacement_cc) : "—"}
              />
              <Row
                label="Cylinders"
                a={tA.engine_cylinders ? `${tA.engine_cylinders} · ${tA.engine_fuel ?? "—"}` : "—"}
                b={tB.engine_cylinders ? `${tB.engine_cylinders} · ${tB.engine_fuel ?? "—"}` : "—"}
              />
              <Row
                label="Aspiration"
                a={tA.engine_aspiration ?? "—"}
                b={tB.engine_aspiration ?? "—"}
              />
              <Row
                label="Bore × stroke"
                a={
                  tA.engine_bore_mm && tA.engine_stroke_mm
                    ? boreStrokeDual(tA.engine_bore_mm, tA.engine_stroke_mm)
                    : "—"
                }
                b={
                  tB.engine_bore_mm && tB.engine_stroke_mm
                    ? boreStrokeDual(tB.engine_bore_mm, tB.engine_stroke_mm)
                    : "—"
                }
              />
              <Row
                label="Compression"
                a={tA.engine_compression ? `${tA.engine_compression} : 1` : "—"}
                b={tB.engine_compression ? `${tB.engine_compression} : 1` : "—"}
              />
            </tbody>
          </table>
        </section>

        <section>
          <h2 className="section-h">Drivetrain</h2>
          <table className="spec-table">
            <tbody>
              <Row
                label="Transmission"
                a={tA.transmission_name ?? "—"}
                b={tB.transmission_name ?? "—"}
              />
              <Row
                label="Drive"
                a={tA.drive_wheel ?? "—"}
                b={tB.drive_wheel ?? "—"}
              />
              <Row
                label="OE tire size"
                a={tA.tire_size ?? "—"}
                b={tB.tire_size ?? "—"}
              />
            </tbody>
          </table>
        </section>

        {(oilA || oilB || coolA || coolB || transA || transB) && (
          <section>
            <h2 className="section-h">Fluids</h2>
            <table className="spec-table">
              <tbody>
                <Row
                  label="Engine oil capacity"
                  a={oilA ? fmtCap(oilA.capacity_l, oilA.capacity_qt) : "—"}
                  b={oilB ? fmtCap(oilB.capacity_l, oilB.capacity_qt) : "—"}
                />
                <Row
                  label="Engine oil viscosity"
                  a={oilA?.viscosity ?? "—"}
                  b={oilB?.viscosity ?? "—"}
                />
                <Row
                  label="Engine oil spec"
                  a={oilA?.spec_standard ?? "—"}
                  b={oilB?.spec_standard ?? "—"}
                />
                <Row
                  label="Coolant capacity"
                  a={coolA ? fmtCap(coolA.capacity_l, coolA.capacity_qt) : "—"}
                  b={coolB ? fmtCap(coolB.capacity_l, coolB.capacity_qt) : "—"}
                />
                <Row
                  label="Transmission fluid"
                  a={transA ? fmtCap(transA.capacity_l, transA.capacity_qt) : "—"}
                  b={transB ? fmtCap(transB.capacity_l, transB.capacity_qt) : "—"}
                />
              </tbody>
            </table>
          </section>
        )}

        <section>
          <h2 className="section-h">Full spec sheets</h2>
          <p className="muted" style={{ fontSize: 13, marginBottom: 8 }}>
            For everything beyond this comparison (torque values, OEM part numbers,
            maintenance schedule, tire pressures), see each trim&apos;s dedicated page.
          </p>
          <ul
            style={{
              listStyle: "none",
              padding: 0,
              margin: 0,
              display: "grid",
              gridTemplateColumns: "1fr 1fr",
              gap: 8,
            }}
          >
            <li style={{ border: "1px solid var(--rule)" }}>
              <a
                href={`/${tA.brand_slug}/${tA.gen_slug}/${tA.trim_slug}`}
                style={{ display: "block", padding: "12px 16px", color: "var(--ink)" }}
              >
                <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)" }}>
                  {tA.brand_name}
                </div>
                <div style={{ fontWeight: 500 }}>{tA.gen_display} {tA.trim_name}</div>
                <div className="muted" style={{ fontSize: 12, marginTop: 2 }}>
                  Full spec sheet →
                </div>
              </a>
            </li>
            <li style={{ border: "1px solid var(--rule)" }}>
              <a
                href={`/${tB.brand_slug}/${tB.gen_slug}/${tB.trim_slug}`}
                style={{ display: "block", padding: "12px 16px", color: "var(--ink)" }}
              >
                <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", color: "var(--ink-soft)" }}>
                  {tB.brand_name}
                </div>
                <div style={{ fontWeight: 500 }}>{tB.gen_display} {tB.trim_name}</div>
                <div className="muted" style={{ fontSize: 12, marginTop: 2 }}>
                  Full spec sheet →
                </div>
              </a>
            </li>
          </ul>
        </section>
      </main>

      <SiteFooter />
    </>
  );
}
