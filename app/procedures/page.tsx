import Link from "next/link";
import { query } from "@/lib/db";
import { pageMetadata } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

type ProcRow = {
  procedure_type: string;
  cnt: number;
};

const TYPE_LABEL: Record<string, string> = {
  oil_life_reset: "Oil Life / Maintenance Minder reset",
  service_reminder_reset: "Service reminder reset",
  maintenance_reminder_reset: "Maintenance reminder reset",
  cbs_reset: "Condition-Based Service (CBS) reset",
  tpms_relearn: "TPMS relearn / calibration",
  battery_disconnect_order: "Battery disconnect (correct order)",
  jump_start: "Jump-start procedure",
  brake_pad_replacement: "Brake pad replacement",
  air_filter_replacement: "Engine air filter replacement",
  cabin_filter_replacement: "Cabin air filter replacement",
  serpentine_belt: "Serpentine belt replacement",
};

const TYPE_GROUP: Record<string, string> = {
  oil_life_reset: "Service resets",
  service_reminder_reset: "Service resets",
  maintenance_reminder_reset: "Service resets",
  cbs_reset: "Service resets",
  tpms_relearn: "Calibrations",
  battery_disconnect_order: "Battery & electrical",
  jump_start: "Roadside",
  brake_pad_replacement: "Brake service",
  air_filter_replacement: "Filters",
  cabin_filter_replacement: "Filters",
  serpentine_belt: "Drive belt",
};

export const metadata = pageMetadata({
  title: "Procedures",
  description:
    "Owner-manual-derived how-to procedures across every nameplate we cover: service resets, TPMS relearn, battery disconnect order, jump-start. Step-by-step, brand-specific, structured with HowTo schema.",
  path: "/procedures",
});

export default async function ProceduresIndex() {
  const rows = await query<ProcRow>(`
    SELECT procedure_type, COUNT(*) AS cnt
    FROM procedures
    GROUP BY procedure_type
    ORDER BY cnt DESC
  `);

  const grouped = new Map<string, ProcRow[]>();
  for (const r of rows) {
    const grp = TYPE_GROUP[r.procedure_type] || "Other";
    if (!grouped.has(grp)) grouped.set(grp, []);
    grouped.get(grp)!.push(r);
  }

  const total = rows.reduce((s, r) => s + Number(r.cnt), 0);

  return (
    <>
      <SiteHeader />
      <div className="shell">
        <nav className="crumb">
          <Link href="/">Catalogue</Link>
          <span className="sep">/</span>
          <span>Procedures</span>
        </nav>
        <header className="pagehead">
          <h1>Procedures</h1>
          <p className="sub">
            {total} owner-method procedures across every nameplate we cover.
            Restated from OEM owner manuals and workshop service-manual
            references. Each procedure ships with tools required,
            common mistakes, and JSON-LD HowTo schema.
          </p>
        </header>

        <section className="proc-grid">
          {Array.from(grouped.entries()).map(([group, items]) => (
            <div key={group} className="proc-card">
              <h2 className="section-h">{group}</h2>
              <ul>
                {items.map((r) => (
                  <li key={r.procedure_type}>
                    <span>{TYPE_LABEL[r.procedure_type] || r.procedure_type}</span>
                    <span className="num">{r.cnt} gens</span>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </section>

        <section className="proc-howto">
          <h2 className="section-h">How to use this</h2>
          <ol>
            <li>
              Find your generation:{" "}
              <Link href="/">catalogue</Link> or{" "}
              <Link href="/search">search</Link>.
            </li>
            <li>Open the gen page and use the Procedures tab.</li>
            <li>Each procedure detail lists tools, ordered steps, and common mistakes.</li>
          </ol>
        </section>

        <section className="proc-howto">
          <h2 className="section-h">Why these are different</h2>
          <p>
            Auto-data.net and ultimatespecs.com publish trim specs but no
            owner-method procedures. We restate the steps from the original OEM
            owner manual (Feist v. Rural: facts only, no verbatim text), then
            mark the source. The point is not the steps — every Haynes book
            has steps — it&apos;s that the steps are per-gen specific: a Honda
            HR-V 2023 maintenance reset is different from a HR-V 2018.
          </p>
        </section>
      </div>
      <SiteFooter />
    </>
  );
}
