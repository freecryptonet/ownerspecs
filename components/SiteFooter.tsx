export function SiteFooter({ reviewDate }: { reviewDate?: string }) {
  return (
    <footer className="site-footer">
      <div className="shell">
        <div className="foot-grid">
          <div>
            <a href="/" className="wordmark">
              ownerspecs
            </a>
            <p>
              Cross-verified vehicle specifications and owner-manual data for
              every car, every generation, every market.
            </p>
            <div style={{ marginTop: "var(--s-3)" }}>
              <span className="market-pill">Global · multi-market</span>
            </div>
          </div>
          <div>
            <h4>Catalogue</h4>
            <ul>
              <li>
                <a href="/">All makes</a>
              </li>
              <li>
                <a href="/engines">Engines</a>
              </li>
              <li>
                <a href="/compare">Compare</a>
              </li>
              <li>
                <a href="/search">Search</a>
              </li>
            </ul>
          </div>
          <div>
            <h4>Owner-manual data</h4>
            <ul>
              <li>
                <a href="/procedures">Procedures</a>
              </li>
              <li>
                <a href="/guides">Guides</a>
              </li>
              <li>
                <a href="/guides/5w-20-vs-5w-30">Oil viscosity</a>
              </li>
              <li>
                <a href="/guides/brake-fluid-flush">Brake fluid</a>
              </li>
            </ul>
          </div>
          <div>
            <h4>Sister sites</h4>
            <ul>
              <li>
                <a href="https://vindecoder.site">vindecoder.site</a>
              </li>
              <li>
                <a href="https://autodtcs.com">autodtcs.com</a>
              </li>
              <li>
                <a href="https://servicereset.net">servicereset.net</a>
              </li>
            </ul>
          </div>
          <div>
            <h4>About</h4>
            <ul>
              <li>
                <a href="/methodology">Methodology</a>
              </li>
              <li>
                <a href="/methodology#provenance-is-exposed">Sources</a>
              </li>
              <li>
                <a href="mailto:contact@ownerspecs.com">Contact</a>
              </li>
            </ul>
          </div>
        </div>
        <div className="foot-bottom">
          <span>© 2026 ownerspecs · v0.1</span>
          {reviewDate && <span>Page last reviewed {reviewDate}</span>}
        </div>
      </div>
    </footer>
  );
}
