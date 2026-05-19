export function SiteHeader() {
  return (
    <header className="site-header">
      <div className="site-header-inner">
        <a href="/" className="wordmark">
          ownerspecs
        </a>
        <nav className="nav-primary">
          <a href="/" className="active">
            Catalogue
          </a>
          <a href="/#owner-manual-data">Maintenance</a>
          <a href="/#owner-manual-data">Fluids</a>
          <a href="/compare">Compare</a>
          <a href="/#methodology">Methodology</a>
        </nav>
        <div className="search-bar">
          <svg
            width="13"
            height="13"
            viewBox="0 0 16 16"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.6"
          >
            <circle cx="7" cy="7" r="5" />
            <path d="m11 11 3 3" />
          </svg>
          <input placeholder="Make, model, VIN or part number" />
          <span className="kbd">⌘ K</span>
        </div>
      </div>
    </header>
  );
}
