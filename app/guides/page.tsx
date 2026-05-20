import Link from "next/link";
import { pageMetadata } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";

export const metadata = pageMetadata({
  title: "Guides · ownerspecs",
  description:
    "Owner-manual-derived how-to guides for car maintenance: oil viscosity, TPMS, brake fluid, coolant, spark plugs, and more. Restated from OEM manuals — facts only, not opinions.",
  path: "/guides",
});

const GUIDES = [
  {
    slug: "5w-20-vs-5w-30",
    title: "5W-20 vs 5W-30: which oil should you actually use?",
    excerpt:
      "The viscosity number on the bottle isn't a preference — it's an OEM-prescribed spec. Here's how to read it, when crossing grades is safe, and when it voids your warranty.",
  },
  {
    slug: "tpms-light-meaning",
    title: "Why is my TPMS light on, and how do I reset it?",
    excerpt:
      "TPMS lights mean one of three things, and the reset procedure depends on whether your system is direct or indirect. We cover both, with per-make canonical steps.",
  },
  {
    slug: "brake-fluid-flush",
    title: "When (and why) to flush brake fluid",
    excerpt:
      "Brake fluid is hygroscopic. After ~2 years it absorbs enough moisture to cause boiling under hard braking. Here's the DOT-grade table, the flush interval per OEM, and how to test it yourself.",
  },
  {
    slug: "coolant-types-explained",
    title: "Coolant types decoded: G12, G13, OAT, HOAT, IAT, FL22",
    excerpt:
      "VW G12+, Toyota SLLC, GM Dex-Cool, Honda Type 2, Mazda FL22 — they're not interchangeable. Here's the chemistry behind each and which ones can be safely mixed.",
  },
  {
    slug: "serpentine-belt-replacement",
    title: "When to replace a serpentine belt (and what fails when it breaks)",
    excerpt:
      "Modern serpentine belts last 60,000-100,000 mi. The replacement window is wide, but the failure mode is catastrophic on engines with belt-driven water pumps. Inspection method + per-OEM intervals.",
  },
];

export default function GuidesIndex() {
  return (
    <div className="min-h-screen bg-slate-50 text-slate-900">
      <SiteHeader />
      <main className="mx-auto max-w-3xl px-6 py-12">
        <nav className="text-xs font-mono text-slate-500 mb-4">
          <Link href="/" className="hover:underline">Catalogue</Link> · Guides
        </nav>
        <h1 className="text-4xl font-semibold tracking-tight">Guides</h1>
        <p className="mt-3 text-slate-700">
          Owner-manual-derived how-to guides on the topics most owners actually
          ask about. Every guide cross-links to per-gen pages so the answer
          tells you what <em>your</em> car wants, not generic advice.
        </p>

        <section className="mt-10 space-y-6">
          {GUIDES.map((g) => (
            <article key={g.slug} className="rounded-xl border border-slate-200 bg-white p-6">
              <h2 className="text-xl font-semibold">
                <Link href={`/guides/${g.slug}`} className="hover:text-sky-700">
                  {g.title}
                </Link>
              </h2>
              <p className="mt-2 text-sm text-slate-700">{g.excerpt}</p>
              <Link
                href={`/guides/${g.slug}`}
                className="mt-3 inline-block text-sm font-mono text-sky-700 hover:underline"
              >
                Read →
              </Link>
            </article>
          ))}
        </section>
      </main>
    </div>
  );
}
