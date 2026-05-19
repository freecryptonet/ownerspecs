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
                <a href="/#brands">By manufacturer</a>
              </li>
              <li>
                <a href="/#brands">By body type</a>
              </li>
              <li>
                <a href="/#brands">By fuel</a>
              </li>
              <li>
                <a href="/#brands">By market</a>
              </li>
            </ul>
          </div>
          <div>
            <h4>Data</h4>
            <ul>
              <li>
                <a href="/#owner-manual-data">Fluids</a>
              </li>
              <li>
                <a href="/#owner-manual-data">Maintenance</a>
              </li>
              <li>
                <a href="/#owner-manual-data">Torque</a>
              </li>
              <li>
                <a href="/#owner-manual-data">Electrical</a>
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
                <a href="/#methodology">Methodology</a>
              </li>
              <li>
                <a href="/#methodology">Sources</a>
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
