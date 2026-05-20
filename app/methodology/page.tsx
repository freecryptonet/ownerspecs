import Link from "next/link";
import { pageMetadata } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";
import { query } from "@/lib/db";

export const metadata = pageMetadata({
  title: "Methodology · ownerspecs",
  description:
    "How ownerspecs sources, verifies, and publishes vehicle specifications. Multi-source verification, OEM-manual provenance, restated-not-verbatim policy (Feist v. Rural), HaynesPro / startmycar / manualslib citation hierarchy.",
  path: "/methodology",
});

export default async function MethodologyPage() {
  const stats = await query<{ k: string; v: number }>(`
    SELECT 'gens' AS k, COUNT(*) AS v FROM generations WHERE is_active=1
    UNION ALL SELECT 'sources', COUNT(*) FROM sources
    UNION ALL SELECT 'public_sources', COUNT(*) FROM sources WHERE is_public=1
    UNION ALL SELECT 'fluid_rows', COUNT(*) FROM fluid_specs
    UNION ALL SELECT 'procs', COUNT(*) FROM procedures
  `);
  const s = Object.fromEntries(stats.map((r) => [r.k, Number(r.v)]));

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900">
      <SiteHeader />
      <main className="mx-auto max-w-3xl px-6 py-12 prose prose-slate prose-headings:font-semibold prose-headings:tracking-tight">
        <nav className="text-xs font-mono text-slate-500 mb-4 not-prose">
          <Link href="/" className="hover:underline">Catalogue</Link> · Methodology
        </nav>
        <h1 className="text-4xl font-semibold tracking-tight">Methodology</h1>
        <p className="text-slate-700">
          ownerspecs is built from owner-manual data. Spec sheets are easy
          to find; what owners actually need — fluid capacities and grades,
          torque numbers, bulb codes, fuse positions, OEM part numbers,
          maintenance intervals, service-reset procedures — is scattered
          across PDFs and behind paywalls. This page documents how the data
          on this site is collected, verified, and published.
        </p>

        <h2>Source hierarchy</h2>
        <ol className="text-slate-700">
          <li><strong>OEM owner manual (PDF)</strong> — Toyota, Honda, BMW, Mercedes, etc. publish official manuals. Highest authority for fluids, intervals, procedures.</li>
          <li><strong>HaynesPro WorkshopData</strong> — paid OEM-equivalent service data. Used internally to cross-check fluids/torques. Citations are kept internal (HaynesPro license).</li>
          <li><strong>manualslib.com</strong> — community archive of owner manuals. Used to cross-verify older / discontinued models where OEM portals have removed PDFs.</li>
          <li><strong>startmycar.com</strong> — community Q&A; used as a tie-breaker on ambiguous procedure variations (e.g. trim-specific maintenance-reset variants).</li>
          <li><strong>Manufacturer press materials</strong> — for engine codes, headline horsepower, transmission designations.</li>
        </ol>

        <h2>Two-source rule</h2>
        <p className="text-slate-700">
          Every public spec row links to ≥2 independent sources via the
          <code>spec_sources</code> table. If only one source is available,
          the field is left blank rather than published as authoritative.
          We currently track {s.sources} sources ({s.public_sources} of which are
          surfaceable on public pages), backing {s.fluid_rows} fluid-spec rows
          and {s.procs} procedure entries across {s.gens} generations.
        </p>

        <h2>Restated, not verbatim (Feist v. Rural)</h2>
        <p className="text-slate-700">
          We restate factual data — capacities, torques, intervals — in our
          own words and tabulations. Per <em>Feist Publications, Inc., v.
          Rural Telephone Service Co.</em> (1991), facts are not copyrightable.
          What <em>is</em> copyrightable is creative expression: paragraph
          wording, custom diagrams, photo selection. So:
        </p>
        <ul className="text-slate-700">
          <li>We never copy paragraphs verbatim from owner manuals or HaynesPro.</li>
          <li>We never reproduce OEM line-art, scanned diagrams, or photo composition.</li>
          <li>Procedure steps are rewritten in our cadence; OEM phrasing is paraphrased.</li>
          <li>Hero images are sourced from Wikimedia Commons (CC BY-SA / CC0) with full attribution, never scraped from competitor sites.</li>
        </ul>

        <h2>Provenance is exposed</h2>
        <p className="text-slate-700">
          Every gen page has a <em>Sources</em> section listing the citations
          backing its data. We mark HaynesPro citations as internal (not
          surfaceable) so the public source list reflects only what an owner
          could independently verify. Click into any gen page and scroll
          to the bottom to see the citation set for that page.
        </p>

        <h2>Per-generation granularity</h2>
        <p className="text-slate-700">
          A 2018 Civic and a 2022 Civic share a model name but have different
          oil capacities, different maintenance-reset procedures, different
          spark plug part numbers. Most competitors collapse these into a
          single "Civic" page. ownerspecs uses per-generation URLs
          (<code>/honda/civic-fe-sedan-2022-2025</code> vs.
          <code>/honda/civic-sedan-x-2016-2021</code>) so the answer you read
          is for the chassis code in your driveway.
        </p>

        <h2>Where data still has gaps</h2>
        <ul className="text-slate-700">
          <li>Trim-level fluid variations: some manufacturers publish different oil capacities for FWD vs AWD trims; we use the most-common trim by default and note variations.</li>
          <li>Regional spec differences (EU vs US): we list market-specific values when documented, but US-spec is the default.</li>
          <li>Diagnostic-tool-required procedures: we mark these as such and link out to <a href="https://autodtcs.com" className="text-sky-700 hover:underline">autodtcs.com</a> for code lookups.</li>
        </ul>

        <h2>Reporting an error</h2>
        <p className="text-slate-700">
          Found a spec you can prove wrong from your own owner manual?
          Open a GitHub issue at{" "}
          <a href="https://github.com/freecryptonet/ownerspecs/issues" className="text-sky-700 hover:underline">
            freecryptonet/ownerspecs
          </a>{" "}
          with the page URL, the field, and a photo of the manual page.
          Corrections ship the same week.
        </p>
      </main>
    </div>
  );
}
