import Link from "next/link";
import { query } from "@/lib/db";
import { pageMetadata } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";

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
  title: "Procedures · ownerspecs",
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
    <div className="min-h-screen bg-slate-50 text-slate-900">
      <SiteHeader />
      <main className="mx-auto max-w-5xl px-6 py-12">
        <nav className="text-xs font-mono text-slate-500 mb-4">
          <Link href="/" className="hover:underline">Catalogue</Link> · Procedures
        </nav>
        <h1 className="text-4xl font-semibold tracking-tight">Procedures</h1>
        <p className="mt-3 text-slate-700 max-w-3xl">
          {total} owner-method procedures across every nameplate we cover.
          Restated from OEM owner manuals and Haynes Pro / startmycar /
          manualslib references. Each procedure ships with{" "}
          <strong>tools required</strong>, <strong>common mistakes</strong>,
          and JSON-LD HowTo schema — so the answer is also a Google Rich Result.
        </p>

        <section className="mt-10 grid grid-cols-1 md:grid-cols-2 gap-6">
          {Array.from(grouped.entries()).map(([group, items]) => (
            <div key={group} className="rounded-xl border border-slate-200 bg-white p-6">
              <h2 className="text-lg font-semibold text-slate-900">{group}</h2>
              <ul className="mt-4 space-y-2 text-sm">
                {items.map((r) => (
                  <li key={r.procedure_type} className="flex justify-between border-b border-slate-100 py-1.5">
                    <span className="text-slate-800">
                      {TYPE_LABEL[r.procedure_type] || r.procedure_type}
                    </span>
                    <span className="font-mono text-slate-500">{r.cnt} gens</span>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </section>

        <section className="mt-10 rounded-xl border border-slate-200 bg-white p-6">
          <h2 className="text-lg font-semibold">How to use this</h2>
          <ol className="mt-3 space-y-2 text-sm text-slate-700 list-decimal pl-6">
            <li>Find your generation: <Link href="/" className="text-sky-700 hover:underline">catalogue</Link> or <Link href="/search" className="text-sky-700 hover:underline">search</Link>.</li>
            <li>Open the gen page · scroll to <em>Procedures</em> or use the top tab.</li>
            <li>Each procedure detail lists tools, ordered steps, and common mistakes.</li>
          </ol>
        </section>

        <section className="mt-10 rounded-xl border border-slate-200 bg-white p-6">
          <h2 className="text-lg font-semibold">Why these are different</h2>
          <p className="mt-2 text-sm text-slate-700">
            Auto-data.net and ultimatespecs.com publish trim specs but no
            owner-method procedures. We restate the steps from the original
            OEM owner manual (Feist v. Rural: facts only, no verbatim text),
            then mark the source. The point is not the steps — every Haynes
            book has steps — it&apos;s that the steps are <em>per-gen specific</em>:
            a Honda HR-V 2023 maintenance reset is different from a HR-V 2018.
          </p>
        </section>
      </main>
    </div>
  );
}
