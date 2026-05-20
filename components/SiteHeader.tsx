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
          <a href="/procedures">Procedures</a>
          <a href="/engines">Engines</a>
          <a href="/compare">Compare</a>
          <a href="/methodology">Methodology</a>
        </nav>
        <form action="/search" method="get" className="search-bar" role="search">
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
          <input
            id="site-search"
            name="q"
            type="search"
            autoComplete="off"
            placeholder="Make, model, VIN or part number"
            aria-label="Search ownerspecs catalogue"
          />
          <span className="kbd">⌘ K</span>
        </form>
      </div>
      <script
        dangerouslySetInnerHTML={{
          __html: `(function(){var go=function(e){if((e.metaKey||e.ctrlKey)&&e.key==='k'){e.preventDefault();var i=document.getElementById('site-search');if(i){i.focus();i.select();}}};document.addEventListener('keydown',go);})();`,
        }}
      />
    </header>
  );
}
