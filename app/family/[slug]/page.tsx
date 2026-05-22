import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { pageMetadata } from "@/lib/seo";

type Params = { slug: string };

type FamilyGen = {
  id: number;
  model_slug: string;
  model_name: string;
  make_slug: string;
  make_name: string;
  slug: string;
  codename: string | null;
  display_name: string;
  body_type: string;
  start_year: number;
  end_year: number | null;
  length_mm: number | null;
  width_mm: number | null;
  height_mm: number | null;
  wheelbase_mm: number | null;
  cargo_l: number | null;
  fuel_tank_l: string | null;
  trim_count: number;
  hero_url: string | null;
};

type FamilyMeta = {
  family_slug: string;
  family_label: string;
};

async function getFamily(slug: string): Promise<{ meta: FamilyMeta; gens: FamilyGen[] } | null> {
  const meta = await queryOne<FamilyMeta>(
    `SELECT family_slug, family_label
     FROM generations
     WHERE family_slug = ?
     LIMIT 1`,
    [slug],
  );
  if (!meta) return null;

  const gens = await query<FamilyGen>(
    `SELECT
       g.id,
       m.slug AS model_slug, m.name AS model_name,
       mk.slug AS make_slug, mk.name AS make_name,
       g.slug, g.codename, g.display_name, g.body_type,
       g.start_year, g.end_year,
       g.length_mm, g.width_mm, g.height_mm, g.wheelbase_mm,
       g.cargo_l, g.fuel_tank_l,
       (SELECT COUNT(*) FROM trims t WHERE t.generation_id = g.id) AS trim_count,
       (SELECT url FROM images i WHERE i.generation_id = g.id AND i.trim_id IS NULL AND i.position = 'hero' LIMIT 1) AS hero_url
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes  mk ON mk.id = m.make_id
     WHERE g.family_slug = ?
     ORDER BY g.start_year, m.slug, g.body_type`,
    [slug],
  );
  return { meta, gens };
}

export async function generateStaticParams(): Promise<Params[]> {
  const rows = await query<{ family_slug: string }>(
    `SELECT DISTINCT family_slug FROM generations WHERE family_slug IS NOT NULL`,
  );
  return rows.map((r) => ({ slug: r.family_slug }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { slug } = await params;
  const f = await getFamily(slug);
  if (!f) return { title: "Not found" };
  const yrs = `${Math.min(...f.gens.map((g) => g.start_year))}-${
    f.gens.every((g) => g.end_year) ? Math.max(...f.gens.map((g) => g.end_year ?? 0)) : "present"
  }`;
  return pageMetadata({
    title: `${f.meta.family_label} — generations, trims, differences · ownerspecs`,
    description: `Side-by-side comparison of every ${f.meta.family_label} variant (${yrs}). Identify your exact generation, body, and trim before looking up oil, coolant, torque or service specs.`,
    path: `/family/${slug}`,
  });
}

function yearRange(start: number, end: number | null): string {
  return end ? `${start} – ${end}` : `${start} – present`;
}

export default async function FamilyPage({ params }: { params: Promise<Params> }) {
  const { slug } = await params;
  const f = await getFamily(slug);
  if (!f) notFound();

  // Determine if any gen is BEV vs ICE — useful disambiguator for G60-family
  const hasBev = f.gens.some((g) => g.model_slug.startsWith("i"));
  const hasIce = f.gens.some((g) => !g.model_slug.startsWith("i"));

  return (
    <>
      <SiteHeader />
      <main className="container" style={{ maxWidth: 1080, margin: "0 auto", padding: "32px 20px" }}>
        <nav style={{ fontSize: 13, color: "var(--ink-soft)", marginBottom: 8 }}>
          <a href="/" style={{ color: "inherit" }}>Catalogue</a>
          {" › "}
          <a href={`/${f.gens[0].make_slug}`} style={{ color: "inherit" }}>{f.gens[0].make_name}</a>
          {" › Family"}
        </nav>

        <h1 style={{ fontSize: 32, fontWeight: 600, lineHeight: 1.2, marginBottom: 6 }}>
          {f.meta.family_label}
        </h1>
        <p style={{ color: "var(--ink-soft)", marginBottom: 24, maxWidth: 720 }}>
          {f.gens.length} generations on the same chassis platform. Identify your exact build below, then click through to the dedicated generation page for oil, coolant, torque, electrical and procedure data.
        </p>

        {(hasBev && hasIce) && (
          <div style={{
            border: "1px solid var(--rule)",
            borderRadius: 8,
            padding: "12px 16px",
            background: "var(--surface-soft, #fafafa)",
            marginBottom: 24,
            fontSize: 14,
          }}>
            <strong>Which one is mine?</strong>
            <ul style={{ margin: "6px 0 0 18px", padding: 0 }}>
              <li>Combustion or plug-in hybrid (has a fuel filler) → pick the <strong>5 Series</strong> entry below</li>
              <li>Fully electric (charge port only, no exhaust) → pick the <strong>i5</strong> entry below</li>
            </ul>
          </div>
        )}

        <table className="family-table" style={{ width: "100%", borderCollapse: "collapse", marginBottom: 32 }}>
          <thead>
            <tr style={{ borderBottom: "2px solid var(--rule)", textAlign: "left", fontSize: 13 }}>
              <th style={{ padding: "8px 12px" }}>Generation</th>
              <th style={{ padding: "8px 12px" }}>Body</th>
              <th style={{ padding: "8px 12px" }}>Years</th>
              <th style={{ padding: "8px 12px", textAlign: "right" }}>Length</th>
              <th style={{ padding: "8px 12px", textAlign: "right" }}>Cargo</th>
              <th style={{ padding: "8px 12px", textAlign: "right" }}>Trims</th>
              <th style={{ padding: "8px 12px" }}></th>
            </tr>
          </thead>
          <tbody>
            {f.gens.map((g) => (
              <tr key={g.id} style={{ borderBottom: "1px solid var(--rule)" }}>
                <td style={{ padding: "10px 12px" }}>
                  <div style={{ fontWeight: 500 }}>{g.make_name} {g.model_name} {g.codename || g.display_name}</div>
                  <div style={{ fontSize: 11, color: "var(--ink-soft)", textTransform: "uppercase", letterSpacing: 0.4 }}>
                    {g.codename}
                  </div>
                </td>
                <td style={{ padding: "10px 12px", fontSize: 14 }}>{g.body_type}</td>
                <td style={{ padding: "10px 12px", fontSize: 14 }}>{yearRange(g.start_year, g.end_year)}</td>
                <td style={{ padding: "10px 12px", textAlign: "right", fontSize: 14, fontVariantNumeric: "tabular-nums" }}>
                  {g.length_mm ? `${g.length_mm} mm` : "—"}
                </td>
                <td style={{ padding: "10px 12px", textAlign: "right", fontSize: 14, fontVariantNumeric: "tabular-nums" }}>
                  {g.cargo_l ? `${g.cargo_l} L` : "—"}
                </td>
                <td style={{ padding: "10px 12px", textAlign: "right", fontSize: 14, fontVariantNumeric: "tabular-nums" }}>
                  {g.trim_count}
                </td>
                <td style={{ padding: "10px 12px", textAlign: "right" }}>
                  <a
                    href={`/${g.make_slug}/${g.slug}`}
                    style={{
                      fontSize: 13,
                      padding: "4px 10px",
                      border: "1px solid var(--rule)",
                      borderRadius: 4,
                      textDecoration: "none",
                      color: "inherit",
                    }}
                  >
                    Open →
                  </a>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        <p style={{ fontSize: 13, color: "var(--ink-soft)" }}>
          <em>Note:</em> generations on the same chassis platform usually share major service items (engine oil spec, coolant type, transmission, EPB hardware) but body-specific items differ — cargo capacity, tire pressures with full load, jack points and bulb counts. Pick your exact generation and body above to get the right numbers.
        </p>
      </main>
      <SiteFooter />
    </>
  );
}
