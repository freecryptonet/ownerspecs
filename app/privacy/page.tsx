import Link from "next/link";
import { pageMetadata } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

export const metadata = pageMetadata({
  title: "Privacy Policy",
  description:
    "How ownerspecs handles data: analytics cookies, third-party advertising, what we collect, and your choices.",
  path: "/privacy",
});

export default function PrivacyPage() {
  return (
    <>
      <SiteHeader />
      <div className="shell guide-shell">
        <nav className="crumb">
          <Link href="/">Catalogue</Link>
          <span className="sep">/</span>
          <span>Privacy</span>
        </nav>
        <header className="pagehead">
          <h1>Privacy Policy</h1>
          <p className="sub">Last updated: June 2026</p>
        </header>
        <article className="prose-body">
          <p>
            ownerspecs (&quot;we&quot;, &quot;the site&quot;) respects your
            privacy. This policy explains what data is collected when you visit
            ownerspecs.com and how it is used. We do not require an account and
            do not ask you for personal information to read the site.
          </p>

          <h2>Information we collect</h2>
          <ul>
            <li>
              <strong>Analytics data.</strong> We use Google Analytics to
              understand aggregate traffic (pages viewed, approximate region,
              device type, referrer). This is collected via cookies and similar
              technologies and is processed in aggregate; we do not use it to
              identify individuals.
            </li>
            <li>
              <strong>Server logs.</strong> Our host records standard request
              logs (IP address, user-agent, timestamp) for security and
              reliability. These are retained for a limited period.
            </li>
            <li>
              <strong>Contact messages.</strong> If you email us, we keep your
              message and address only to respond.
            </li>
          </ul>

          <h2>Cookies &amp; advertising</h2>
          <p>
            We use cookies for analytics. We may also display third-party
            advertising; advertising partners (including Google and its
            certified partners) may use cookies or device identifiers to serve
            and measure ads, including personalised ads where permitted. Google&apos;s
            use of advertising cookies is governed by{" "}
            <a href="https://policies.google.com/technologies/partner-sites" rel="noopener nofollow" target="_blank">
              Google&apos;s privacy &amp; terms
            </a>
            . You can opt out of personalised Google advertising via{" "}
            <a href="https://adssettings.google.com" rel="noopener nofollow" target="_blank">
              Google Ad Settings
            </a>{" "}
            and manage cookies in your browser settings or via{" "}
            <a href="https://www.aboutads.info" rel="noopener nofollow" target="_blank">
              aboutads.info
            </a>
            .
          </p>

          <h2>How we use data</h2>
          <p>
            Solely to operate, secure and improve the site, to understand
            aggregate usage, and (if enabled) to fund the site through
            advertising. We do not sell personal data.
          </p>

          <h2>Third-party links</h2>
          <p>
            The site links to other websites (including our sister sites and
            manufacturer resources). We are not responsible for the privacy
            practices of external sites.
          </p>

          <h2>Your choices</h2>
          <p>
            You can block or delete cookies in your browser, opt out of
            personalised ads as above, and use browser/Do-Not-Track controls.
            For requests regarding data we hold about a contact message,{" "}
            <Link href="/contact">contact us</Link>.
          </p>

          <h2>Changes</h2>
          <p>
            We may update this policy; material changes will be reflected by the
            &quot;last updated&quot; date above.
          </p>
        </article>
      </div>
      <SiteFooter />
    </>
  );
}
