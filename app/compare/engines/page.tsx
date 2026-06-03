import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { boreStrokeDual, displacementDual } from "@/lib/units";

export const metadata: Metadata = {
  title: "Compare engines — displacement, power, oil, specs side-by-side",
  description:
    "Free-form engine comparison: pick any two engines and compare displacement, cylinders, bore × stroke, compression, aspiration, oil capacity and spec side-by-side.",
  alternates: { canonical: "/compare/engines" },
};

type Eng = {
  id: number;
  slug: string;
  code: string;
  display_name: string;
  fuel: string;
  displacement_cc: number | null;
  cylinders: number | null;
  aspiration: string | null;
  valvetrain: string | null;
  bore_mm: string | null;
  stroke_mm: string | null;
  compression: string | null;
  oil_capacity_l: string | null;
  oil_viscosity: string | null;
  oil_spec: string | null;
  app_count: number | null;
};

async function loadEngine(slug: string): Promise<Eng | null> {
  return queryOne<Eng>(
    `SELECT e.id, e.slug, e.code, e.display_name, e.fuel, e.displacement_cc,
            e.cylinders, e.aspiration, e.valvetrain, e.bore_mm, e.stroke_mm, e.compression,
            (SELECT f.capacity_l FROM fluid_specs f WHERE f.engine_id=e.id AND f.fluid_type='engine_oil' AND f.capacity_l IS NOT NULL ORDER BY (f.spec_standard IS NULL), f.id LIMIT 1) AS oil_capacity_l,
            (SELECT f.viscosity FROM fluid_specs f WHERE f.engine_id=e.id AND f.fluid_type='engine_oil' AND f.viscosity IS NOT NULL ORDER BY f.id LIMIT 1) AS oil_viscosity,
            (SELECT f.spec_standard FROM fluid_specs f WHERE f.engine_id=e.id AND f.fluid_type='engine_oil' AND f.spec_standard IS NOT NULL ORDER BY f.id LIMIT 1) AS oil_spec,
            (SELECT COUNT(DISTINCT t.generation_id) FROM trims t WHERE t.engine_id=e.id) AS app_count
     FROM engines e WHERE e.slug = ? LIMIT 1`,
    [slug],
  );
}

type PickRow = { slug: string; code: string; display_name: string; fuel: string; displacement_cc: number | null; make_name: string };

async function loadPicker(): Promise<PickRow[]> {
  return query<PickRow>(
    `SELECT DISTINCT e.slug, e.code, e.display_name, e.fuel, e.displacement_cc, mk.name AS make_name
     FROM engines e
     JOIN trims t ON t.engine_id = e.id
     JOIN generations g ON g.id = t.generation_id AND g.is_active = 1
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE e.slug IS NOT NULL AND e.slug != ''
     ORDER BY mk.name, e.displacement_cc, e.code
     LIMIT 1200`,
  );
}

function nextSlotUrl(slugs: string[], slug: string): string {
  const slots = [slugs[0], slugs[1]];
  if (!slots[0]) slots[0] = slug;
  else if (!slots[1] && slots[0] !== slug) slots[1] = slug;
  else slots[1] = slug; // replace b if both full
  const qs = [slots[0] && `a=${slots[0]}`, slots[1] && `b=${slots[1]}`].filter(Boolean).join("&");
  return `/compare/engines?${qs}`;
}

function row(label: string, vals: (string | null)[]) {
  return (
    <tr>
      <td className="label">{label}</td>
      {vals.map((v, i) => (
        <td key={i} className="cell" style={v ? undefined : { color: "var(--ink-mute)" }}>{v ?? "—"}</td>
      ))}
    </tr>
  );
}

function EnginePicker({ rows, slugs }: { rows: PickRow[]; slugs: string[] }) {
  const byMake = rows.reduce<Record<string, PickRow[]>>((a, r) => { (a[r.make_name] = a[r.make_name] || []).push(r); return a; }, {});
  return (
    <section style={{ paddingTop: "var(--s-5)" }}>
      <h2 className="section-h">{slugs.length ? "Add another engine" : "Pick engines to compare"}<span className="count">{rows.length}</span></h2>
      <p style={{ fontSize: 13, color: "var(--ink-soft)", marginBottom: 16, maxWidth: "62ch" }}>
        Click any two engines to put their displacement, cylinders, bore × stroke, compression, aspiration and oil spec side-by-side.
      </p>
      {Object.entries(byMake).map(([make, list]) => (
        <div key={make} style={{ marginBottom: "var(--s-5)" }}>
          <h3 style={{ fontSize: 12, fontWeight: 600, color: "var(--ink-soft)", textTransform: "uppercase", letterSpacing: "0.06em", margin: "0 0 6px" }}>{make}</h3>
          <ul style={{ listStyle: "none", display: "flex", flexWrap: "wrap", gap: 6, padding: 0, margin: 0 }}>
            {list.map((r) => (
              <li key={r.slug}>
                <a href={nextSlotUrl(slugs, r.slug)} style={{ display: "inline-block", padding: "5px 10px", border: "1px solid var(--rule)", fontFamily: "var(--font-mono)", fontSize: 12, color: slugs.includes(r.slug) ? "var(--accent)" : "var(--ink)", background: slugs.includes(r.slug) ? "var(--bg-alt)" : undefined }}>
                  {r.code}{r.displacement_cc ? ` · ${(r.displacement_cc / 1000).toFixed(1)}L` : ""}
                </a>
              </li>
            ))}
          </ul>
        </div>
      ))}
    </section>
  );
}

export default async function CompareEnginesPage({ searchParams }: { searchParams: Promise<{ a?: string; b?: string }> }) {
  const { a, b } = await searchParams;
  const slugs = [a, b].filter((x): x is string => !!x);
  const picker = await loadPicker();
  const engines = (await Promise.all(slugs.map(loadEngine))).filter((e): e is Eng => e !== null);

  return (
    <>
      <SiteHeader />
      <main className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a><span className="sep">/</span>
          <a href="/engines">Engines</a><span className="sep">/</span>
          <span>Compare</span>
        </nav>
        <div className="pagehead">
          <h1>Compare engines</h1>
          <div className="sub">
            <span>{engines.length >= 2 ? engines.map((e) => e.code).join(" vs ") : "Pick any two engines"}</span>
            <span className="pip"></span>
            <span>{picker.length} engines indexed</span>
          </div>
        </div>

        {engines.length >= 1 && (
          <table className="compare-table" style={{ marginTop: "var(--s-4)" }}>
            <thead>
              <tr>
                <td className="label"></td>
                {engines.map((e) => (
                  <td key={e.id} style={{ fontWeight: 700, padding: "10px 12px" }}>
                    <a href={`/engines/${e.slug}`} style={{ color: "var(--ink)" }}>{e.code}</a>
                  </td>
                ))}
              </tr>
            </thead>
            <tbody>
              <tr className="cat-row"><td colSpan={engines.length + 1}>Engine</td></tr>
              {row("Name", engines.map((e) => e.display_name))}
              {row("Displacement", engines.map((e) => displacementDual(e.displacement_cc)))}
              {row("Cylinders", engines.map((e) => e.cylinders != null ? String(e.cylinders) : null))}
              {row("Fuel", engines.map((e) => e.fuel))}
              {row("Aspiration", engines.map((e) => e.aspiration))}
              {row("Valvetrain", engines.map((e) => e.valvetrain))}
              {row("Bore × stroke", engines.map((e) => e.bore_mm && e.stroke_mm ? boreStrokeDual(e.bore_mm, e.stroke_mm) : null))}
              {row("Compression", engines.map((e) => e.compression ? `${e.compression} : 1` : null))}
              <tr className="cat-row"><td colSpan={engines.length + 1}>Engine oil</td></tr>
              {row("Capacity", engines.map((e) => e.oil_capacity_l ? `${Number(e.oil_capacity_l).toFixed(1)} L` : null))}
              {row("Viscosity", engines.map((e) => e.oil_viscosity))}
              {row("Spec", engines.map((e) => e.oil_spec))}
              {row("Used in", engines.map((e) => e.app_count ? `${e.app_count} generation${e.app_count !== 1 ? "s" : ""}` : null))}
            </tbody>
          </table>
        )}

        {slugs.length >= 2 && (
          <p style={{ marginTop: 12, fontSize: 13 }}>
            <a className="link" href="/compare/engines">Start over</a>
          </p>
        )}

        {slugs.length < 2 && <EnginePicker rows={picker} slugs={slugs} />}
      </main>
      <SiteFooter />
    </>
  );
}
