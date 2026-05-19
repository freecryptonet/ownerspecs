/** Minimal markdown → HTML converter for procedure body_md content.
 *  Handles: ## h2, ### h3, paragraphs, **bold**, `code`, - / * unordered lists,
 *  1. ordered lists, blank-line paragraph breaks. No deps. */
export function renderMarkdown(md: string): string {
  const lines = md.replace(/\r\n/g, "\n").split("\n");
  const out: string[] = [];
  let inUl = false;
  let inOl = false;
  let paraBuf: string[] = [];

  const flushPara = () => {
    if (paraBuf.length) {
      out.push(`<p>${inline(paraBuf.join(" ").trim())}</p>`);
      paraBuf = [];
    }
  };
  const closeLists = () => {
    if (inUl) { out.push("</ul>"); inUl = false; }
    if (inOl) { out.push("</ol>"); inOl = false; }
  };

  for (const raw of lines) {
    const line = raw.trimEnd();
    if (!line.trim()) { flushPara(); closeLists(); continue; }

    if (line.startsWith("### ")) {
      flushPara(); closeLists();
      out.push(`<h3>${inline(line.slice(4))}</h3>`); continue;
    }
    if (line.startsWith("## ")) {
      flushPara(); closeLists();
      out.push(`<h2>${inline(line.slice(3))}</h2>`); continue;
    }
    const olm = line.match(/^\s*(\d+)\.\s+(.+)$/);
    if (olm) {
      flushPara();
      if (!inOl) { closeLists(); out.push("<ol>"); inOl = true; }
      out.push(`<li>${inline(olm[2])}</li>`); continue;
    }
    const ulm = line.match(/^\s*[-*]\s+(.+)$/);
    if (ulm) {
      flushPara();
      if (!inUl) { closeLists(); out.push("<ul>"); inUl = true; }
      out.push(`<li>${inline(ulm[1])}</li>`); continue;
    }
    closeLists();
    paraBuf.push(line);
  }
  flushPara(); closeLists();
  return out.join("\n");
}

function inline(s: string): string {
  return escape(s)
    .replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>")
    .replace(/`([^`]+)`/g, "<code>$1</code>");
}

function escape(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}
