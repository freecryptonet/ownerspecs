import Link from "next/link";
import { pageMetadata } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

export const metadata = pageMetadata({
  title: "Contact",
  description:
    "Contact ownerspecs — report a spec error, suggest a vehicle, or send a partnership enquiry.",
  path: "/contact",
});

export default function ContactPage() {
  return (
    <>
      <SiteHeader />
      <div className="shell guide-shell">
        <nav className="crumb">
          <Link href="/">Catalogue</Link>
          <span className="sep">/</span>
          <span>Contact</span>
        </nav>
        <header className="pagehead">
          <h1>Contact</h1>
          <p className="sub">
            We read everything — corrections especially.
          </p>
        </header>
        <article className="prose-body">
          <h2>Email</h2>
          <p>
            General enquiries, corrections and partnerships:{" "}
            <a href="mailto:contact@ownerspecs.com">contact@ownerspecs.com</a>
          </p>

          <h2>Reporting a spec error</h2>
          <p>
            Found a value you can prove wrong from your own owner manual? That&apos;s
            the most valuable message you can send. Please include:
          </p>
          <ul>
            <li>The page URL (e.g. the exact generation and topic page).</li>
            <li>The field and the value you believe is wrong.</li>
            <li>The correct value and where it&apos;s from (a photo of the manual page is ideal).</li>
          </ul>
          <p>
            You can also open an issue on our public repository at{" "}
            <a href="https://github.com/freecryptonet/ownerspecs/issues" rel="noopener" target="_blank">
              github.com/freecryptonet/ownerspecs
            </a>
            . Verified corrections are typically shipped the same week.
          </p>

          <h2>Suggest a vehicle</h2>
          <p>
            Missing a model or generation you&apos;d like covered? Email the make,
            model and year range and we&apos;ll prioritise it.
          </p>

          <h2>More</h2>
          <p>
            See <Link href="/about">About</Link> for what we do and{" "}
            <Link href="/methodology">Methodology</Link> for how the data is
            sourced and verified.
          </p>
        </article>
      </div>
      <SiteFooter />
    </>
  );
}
