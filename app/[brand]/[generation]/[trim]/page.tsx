import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { query, queryOne } from "@/lib/db";
import {
  getGenerationBase,
  getGenerationHero,
  getSourcesFor,
  yearRange,
  reviewDate,
} from "@/lib/generation";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { GenerationTabs } from "@/components/GenerationTabs";
import { VerifyBadge } from "@/components/VerifyBadge";
import { SourcesBlock } from "@/components/SourcesBlock";
import { pageMetadata } from "@/lib/seo";
import {
  mmDual,
  kgDual,
  consumptionDual,
  speedDual,
  boreStrokeDual,
  displacementDual,
} from "@/lib/units";

type Params = { brand: string; generation: string; trim: string };

type Trim = {
  id: number;
  slug: string;
  name: string;
  hp: number | null;
  torque_nm: number | null;
  zero_100_kmh_s: string | null;
  top_speed_kmh: number | null;
  fuel_combined_l_100km: string | null;
  co2_g_km: number | null;
  curb_weight_kg: number | null;
  max_weight_kg: number | null;
  trailer_braked_kg: number | null;
  trailer_unbraked_kg: number | null;
  drive_wheel: string | null;
  tire_size: string | null;
  rim_size: string | null;
  engine_code: string | null;
  engine_display: string | null;
  engine_displacement_cc: number | null;
  engine_aspiration: string | null;
  engine_cylinders: number | null;
  engine_bore_mm: string | null;
  engine_stroke_mm: string | null;
  engine_compression: string | null;
  engine_fuel: string | null;
  engine_valvetrain: string | null;
  transmission_name: string | null;
  market_code: string | null;
};

const SUB_TABS = [
  { key: "overview", label: "Overview" },
  { key: "oil-capacity", label: "Fluids" },
  { key: "maintenance-schedule", label: "Maintenance" },
  { key: "torque", label: "Torque" },
  { key: "electrical", label: "Electrical" },
  { key: "tires", label: "Tires" },
  { key: "procedures", label: "Procedures" },
];

export async function generateStaticParams(): Promise<Params[]> {
  return query<Params>(
    "SELECT mk.slug AS brand, g.slug AS generation, t.slug AS `trim` " +
    "FROM trims t " +
    "JOIN generations g ON g.id = t.generation_id " +
    "JOIN models m      ON m.id = g.model_id " +
    "JOIN makes mk      ON mk.id = m.make_id " +
    "WHERE g.is_active = 1",
  );
}

export async function generateMetadata({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const { brand, generation, trim } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) return { title: "Not found" };

  const trimRow = await queryOne<Trim>(
    `SELECT t.id, t.slug, t.name, t.hp, t.torque_nm, t.zero_100_kmh_s, t.top_speed_kmh, t.fuel_combined_l_100km
     FROM trims t WHERE t.generation_id = ? AND t.slug = ? LIMIT 1`,
    [base.gen.id, trim],
  );
  if (!trimRow) return { title: "Not found" };

  const yrs = yearRange(base.gen.start_year, base.gen.end_year);
  const heroPath = await getGenerationHero(base.gen.id);

  return pageMetadata({
    title: `${base.make.name} ${base.gen.display_name} ${trimRow.name} ${yrs} — Specifications`,
    description: `Specifications for the ${base.make.name} ${base.gen.display_name} ${trimRow.name} (${yrs}). ${trimRow.hp ? `${trimRow.hp} hp,` : ""} ${trimRow.zero_100_kmh_s ? `${trimRow.zero_100_kmh_s}s 0-100 km/h,` : ""} ${trimRow.fuel_combined_l_100km ? `${trimRow.fuel_combined_l_100km} L/100km combined.` : ""} Cross-verified spec sheet.`,
    path: `/${base.make.slug}/${base.gen.slug}/${trimRow.slug}`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation, trim } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) notFound();
  const { make, model, gen } = base;

  const trimRow = await queryOne<Trim>(
    `SELECT
       t.id, t.slug, t.name, t.hp, t.torque_nm, t.zero_100_kmh_s, t.top_speed_kmh,
       t.fuel_combined_l_100km, t.co2_g_km, t.curb_weight_kg, t.max_weight_kg,
       t.trailer_braked_kg, t.trailer_unbraked_kg, t.drive_wheel, t.tire_size, t.rim_size,
       e.code AS engine_code, e.display_name AS engine_display, e.displacement_cc AS engine_displacement_cc,
       e.aspiration AS engine_aspiration, e.cylinders AS engine_cylinders,
       e.bore_mm AS engine_bore_mm, e.stroke_mm AS engine_stroke_mm, e.compression AS engine_compression,
       e.fuel AS engine_fuel, e.valvetrain AS engine_valvetrain,
       tr.display_name AS transmission_name,
       mk2.code AS market_code
     FROM trims t
     LEFT JOIN engines e        ON e.id  = t.engine_id
     LEFT JOIN transmissions tr ON tr.id = t.transmission_id
     LEFT JOIN markets mk2      ON mk2.id = t.market_id
     WHERE t.generation_id = ? AND t.slug = ? LIMIT 1`,
    [gen.id, trim],
  );
  if (!trimRow) notFound();

  const siblings = await query<{ slug: string; name: string }>(
    `SELECT slug, name FROM trims
     WHERE generation_id = ? AND slug != ?
     ORDER BY hp DESC, name LIMIT 12`,
    [gen.id, trim],
  );

  const sources = await getSourcesFor(gen.id, "trims");
  const rev = reviewDate(sources);
  const yrs = yearRange(gen.start_year, gen.end_year);

  const heroImage = await queryOne<{
    url: string;
    caption: string | null;
    attribution: string | null;
    original_url: string | null;
    width: number | null;
    height: number | null;
  }>(
    `SELECT url, caption, attribution, original_url, width, height
     FROM images WHERE generation_id = ?
     ORDER BY (position = '3-4-front') DESC, trim_id IS NULL, id
     LIMIT 1`,
    [gen.id],
  );

  return (
    <>
      <SiteHeader />

      <div className="shell">
        <nav className="crumb">
          <a href="/">Catalogue</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}`}>{make.name}</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}/${model.slug}`}>{model.name}</a>
          <span className="sep">/</span>
          <a href={`/${make.slug}/${gen.slug}`}>{gen.display_name} · {yrs}</a>
          <span className="sep">/</span>
          <span>{trimRow.name}</span>
        </nav>

        <div className="pagehead">
          <h1>{make.name} {gen.display_name} {trimRow.name}</h1>
          <div className="sub">
            <span>{yrs}</span>
            <span className="pip"></span>
            {trimRow.hp && <><span>{trimRow.hp} hp</span><span className="pip"></span></>}
            {trimRow.engine_code && <><span>{trimRow.engine_code}</span><span className="pip"></span></>}
            <span>{trimRow.transmission_name ?? "—"}</span>
            {trimRow.drive_wheel && <><span className="pip"></span><span>{trimRow.drive_wheel}</span></>}
          </div>
          <VerifyBadge
            sourceCount={sources.length}
            reviewDate={rev}
            scope="across"
          />
        </div>
      </div>

      <GenerationTabs
        brand={make.slug}
        generation={gen.slug}
        active="overview"
      />

      <main className="shell">
        <section style={{ paddingTop: "var(--s-5)" }}>
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "1fr 1fr",
              gap: 24,
            }}
          >
            <div>
              {heroImage ? (
                <img
                  src={heroImage.url}
                  alt={heroImage.caption ?? `${make.name} ${gen.display_name} ${trimRow.name}`}
                  style={{ width: "100%", display: "block", border: "1px solid var(--rule)" }}
                />
              ) : null}
              {heroImage?.attribution && (
                <p style={{ fontSize: 11, color: "var(--ink-mute)", marginTop: 4 }}>
                  Photo: {heroImage.attribution} — generation reference; this trim shown for context.
                </p>
              )}
            </div>

            <table className="ib-table">
              <caption>Trim identity</caption>
              <tbody>
                <tr><th>Trim</th><td className="alt">{trimRow.name}</td></tr>
                {trimRow.engine_code && <tr><th>Engine code</th><td>{trimRow.engine_code}</td></tr>}
                {trimRow.engine_display && <tr><th>Engine</th><td className="alt">{trimRow.engine_display}</td></tr>}
                {trimRow.transmission_name && <tr><th>Transmission</th><td>{trimRow.transmission_name}</td></tr>}
                {trimRow.drive_wheel && <tr><th>Drive</th><td className="alt">{trimRow.drive_wheel}</td></tr>}
                {trimRow.market_code && <tr><th>Market</th><td>{trimRow.market_code}</td></tr>}
                <tr><th>Generation</th><td className="alt">{gen.display_name} ({yrs})</td></tr>
              </tbody>
            </table>
          </div>
        </section>

        {/* PERFORMANCE */}
        <section>
          <h2 className="section-h">Performance</h2>
          <table className="spec-table">
            <tbody>
              {trimRow.hp && <tr><th>Horsepower</th><td>{trimRow.hp} hp</td></tr>}
              {trimRow.torque_nm && <tr><th>Torque</th><td>{trimRow.torque_nm} N·m · {Math.round(trimRow.torque_nm * 0.737562)} lb·ft</td></tr>}
              {trimRow.zero_100_kmh_s && <tr><th>0-100 km/h (0-62 mph)</th><td>{trimRow.zero_100_kmh_s} s</td></tr>}
              {trimRow.top_speed_kmh && <tr><th>Top speed</th><td>{speedDual(trimRow.top_speed_kmh)}</td></tr>}
              {trimRow.fuel_combined_l_100km && <tr><th>Fuel (combined)</th><td>{consumptionDual(trimRow.fuel_combined_l_100km)}</td></tr>}
              {trimRow.co2_g_km && <tr><th>CO₂ emissions</th><td>{trimRow.co2_g_km} g/km · WLTP combined</td></tr>}
            </tbody>
          </table>
        </section>

        {/* ENGINE */}
        {trimRow.engine_displacement_cc && (
          <section>
            <h2 className="section-h">Engine — {trimRow.engine_display ?? trimRow.engine_code}</h2>
            <table className="spec-table">
              <tbody>
                <tr><th>Displacement</th><td>{displacementDual(trimRow.engine_displacement_cc)}</td></tr>
                {trimRow.engine_bore_mm && trimRow.engine_stroke_mm && (
                  <tr><th>Bore × stroke</th><td>{boreStrokeDual(trimRow.engine_bore_mm, trimRow.engine_stroke_mm)}</td></tr>
                )}
                {trimRow.engine_compression && <tr><th>Compression</th><td>{trimRow.engine_compression} : 1</td></tr>}
                {trimRow.engine_aspiration && <tr><th>Aspiration</th><td>{trimRow.engine_aspiration}</td></tr>}
                {trimRow.engine_valvetrain && <tr><th>Valvetrain</th><td>{trimRow.engine_valvetrain}</td></tr>}
                {trimRow.engine_cylinders && (
                  <tr><th>Cylinders</th><td>{trimRow.engine_cylinders} · {trimRow.engine_fuel ?? "—"}</td></tr>
                )}
              </tbody>
            </table>
          </section>
        )}

        {/* WEIGHT + TOWING */}
        {(trimRow.curb_weight_kg || trimRow.trailer_braked_kg) && (
          <section>
            <h2 className="section-h">Weight &amp; towing</h2>
            <table className="spec-table">
              <tbody>
                {trimRow.curb_weight_kg && <tr><th>Curb weight</th><td>{kgDual(trimRow.curb_weight_kg)}</td></tr>}
                {trimRow.max_weight_kg && <tr><th>Max gross weight</th><td>{kgDual(trimRow.max_weight_kg)}</td></tr>}
                {trimRow.trailer_braked_kg && <tr><th>Trailer (braked)</th><td>{kgDual(trimRow.trailer_braked_kg)}</td></tr>}
                {trimRow.trailer_unbraked_kg && <tr><th>Trailer (unbraked)</th><td>{kgDual(trimRow.trailer_unbraked_kg)}</td></tr>}
              </tbody>
            </table>
          </section>
        )}

        {/* WHEELS */}
        {(trimRow.tire_size || trimRow.rim_size) && (
          <section>
            <h2 className="section-h">Wheels &amp; tires</h2>
            <table className="spec-table">
              <tbody>
                {trimRow.tire_size && <tr><th>OE tire size</th><td>{trimRow.tire_size}</td></tr>}
                {trimRow.rim_size && <tr><th>OE rim size</th><td>{trimRow.rim_size}</td></tr>}
              </tbody>
            </table>
          </section>
        )}

        {/* RELATED TRIMS */}
        {siblings.length > 0 && (
          <section>
            <h2 className="section-h">
              Other {make.name} {gen.display_name} trims
              <span className="count">{siblings.length}</span>
            </h2>
            <ul
              style={{
                listStyle: "none",
                padding: 0,
                margin: 0,
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(240px, 1fr))",
                gap: 8,
                border: "1px solid var(--rule)",
              }}
            >
              {siblings.map((s) => (
                <li
                  key={s.slug}
                  style={{
                    borderRight: "1px solid var(--rule)",
                    borderBottom: "1px solid var(--rule)",
                  }}
                >
                  <a
                    href={`/${make.slug}/${gen.slug}/${s.slug}`}
                    style={{
                      display: "block",
                      padding: "10px 14px",
                      fontSize: 13,
                      color: "var(--ink)",
                    }}
                  >
                    {s.name}
                  </a>
                </li>
              ))}
            </ul>
          </section>
        )}

        {/* GEN SUB-PAGES */}
        <section>
          <h2 className="section-h">{gen.display_name} owner-manual data</h2>
          <ul
            style={{
              listStyle: "none",
              padding: 0,
              margin: 0,
              display: "grid",
              gridTemplateColumns: "repeat(auto-fill, minmax(220px, 1fr))",
              gap: 8,
              border: "1px solid var(--rule)",
            }}
          >
            {SUB_TABS.slice(1).map((t) => (
              <li
                key={t.key}
                style={{
                  borderRight: "1px solid var(--rule)",
                  borderBottom: "1px solid var(--rule)",
                }}
              >
                <a
                  href={`/${make.slug}/${gen.slug}/${t.key}`}
                  style={{
                    display: "block",
                    padding: "10px 14px",
                    fontSize: 13,
                    color: "var(--ink)",
                  }}
                >
                  {t.label}
                </a>
              </li>
            ))}
          </ul>
        </section>

        <SourcesBlock sources={sources} />
      </main>

      <SiteFooter reviewDate={rev} />
    </>
  );
}
