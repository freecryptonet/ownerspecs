import Link from "next/link";
import { pageMetadata } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

export const metadata = pageMetadata({
  title: "Terms of Use",
  description:
    "Terms governing use of ownerspecs.com — reference-only specifications, no warranty, intellectual property, and external links.",
  path: "/terms",
});

export default function TermsPage() {
  return (
    <>
      <SiteHeader />
      <div className="shell guide-shell">
        <nav className="crumb">
          <Link href="/">Catalogue</Link>
          <span className="sep">/</span>
          <span>Terms</span>
        </nav>
        <header className="pagehead">
          <h1>Terms of Use</h1>
          <p className="sub">Last updated: June 2026</p>
        </header>
        <article className="prose-body">
          <p>
            By using ownerspecs.com you agree to these terms. If you do not
            agree, please do not use the site.
          </p>

          <h2>Reference information only — verify before relying</h2>
          <p>
            The specifications, capacities, torque values, intervals and
            procedures on this site are provided for general reference. Vehicle
            data varies by model year, market, trim and running production
            changes, and sources can contain errors.{" "}
            <strong>
              Always confirm critical values against your vehicle&apos;s own owner
              manual or a manufacturer-authorised workshop manual before
              performing any work.
            </strong>{" "}
            Incorrect torque, fluid grade or procedure can cause injury or
            damage. You are responsible for your own safety and for work
            performed on your vehicle.
          </p>

          <h2>No warranty</h2>
          <p>
            The site is provided &quot;as is&quot;, without warranties of any
            kind, express or implied, including accuracy, completeness or
            fitness for a particular purpose. To the maximum extent permitted by
            law, ownerspecs is not liable for any loss or damage arising from
            use of, or reliance on, the information provided.
          </p>

          <h2>Intellectual property</h2>
          <p>
            Specifications are facts and are not themselves owned by anyone (see
            our <Link href="/methodology">methodology</Link>). The compilation,
            wording, tables, design and original guides on this site are
            ownerspecs&apos; intellectual property. You may reference and link to
            our pages; bulk copying or scraping of the compiled database is not
            permitted.
          </p>

          <h2>Trademarks</h2>
          <p>
            Vehicle makes, models and engine codes are trademarks of their
            respective owners and are used here for identification and reference
            only. ownerspecs is not affiliated with, endorsed by, or sponsored
            by any vehicle manufacturer.
          </p>

          <h2>External links &amp; advertising</h2>
          <p>
            The site links to third-party resources and may display third-party
            advertising. We are not responsible for the content, accuracy or
            practices of external sites or advertisers.
          </p>

          <h2>Contact</h2>
          <p>
            Questions about these terms? <Link href="/contact">Contact us</Link>.
          </p>
        </article>
      </div>
      <SiteFooter />
    </>
  );
}
