#!/usr/bin/env python3
"""Search Wikimedia Commons for car-hero candidates and download the best match.

Usage:
    python3 wikimedia.py search "<query>"
    python3 wikimedia.py download <commons-url> <out-path>

The search step is read-only; download writes the binary to disk.
"""
import argparse
import json
import os
import re
import sys
import urllib.parse
import urllib.request

UA = "ownerspecs-bot/0.1 (+https://ownerspecs.com; contact timgvk@gmail.com)"
GOOD_LICENSES = {
    "CC0", "Public domain",
    "CC BY 2.0", "CC BY 3.0", "CC BY 4.0",
    "CC BY-SA 2.0", "CC BY-SA 3.0", "CC BY-SA 4.0",
}


def http_get(url: str, timeout: int = 20) -> bytes:
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read()


def strip_html(s: str) -> str:
    return re.sub(r"<[^>]+>", "", s or "").strip()


def score_image(title: str, w: int, h: int) -> int:
    tl = title.lower()
    # Hard filters: skip clearly non-hero
    if any(
        k in tl
        for k in [
            "police", "taxi", "fire", "ambulance", "funeral",
            "wreck", "crash", "damage", "burn", "rust",
            "interior", "engine", "trunk", "dash", "rear",
            "tail", "wheel", "close-up", "closeup",
            "logo", "badge", "emblem", "headlight", "taillight",
        ]
    ):
        return -1
    score = w
    if "front" in tl:
        score += 10000
    if "3/4" in tl or "3-4" in tl:
        score += 5000
    if "sedan" in tl or "saloon" in tl:
        score += 2000
    return score


def search(query: str, limit: int = 20) -> list[dict]:
    """Search file namespace by title content."""
    url = (
        "https://commons.wikimedia.org/w/api.php"
        f"?action=query&generator=search"
        f"&gsrsearch={urllib.parse.quote(query)}"
        f"&gsrnamespace=6&gsrlimit={limit}"
        f"&prop=imageinfo&iiprop=url%7Cextmetadata%7Csize&format=json"
    )
    data = json.loads(http_get(url))
    pages = data.get("query", {}).get("pages", {})
    results = []
    for _pid, page in pages.items():
        info = (page.get("imageinfo") or [{}])[0]
        if not info:
            continue
        em = info.get("extmetadata", {})
        lic = em.get("LicenseShortName", {}).get("value", "")
        if lic not in GOOD_LICENSES:
            continue
        w = info.get("width", 0)
        h = info.get("height", 0)
        if w < 1500:
            continue
        ar = w / max(h, 1)
        if ar < 1.2 or ar > 2.8:
            continue
        title = page.get("title", "")
        score = score_image(title, w, h)
        if score < 0:
            continue
        results.append(
            {
                "score": score,
                "title": title,
                "license": lic,
                "artist": strip_html(em.get("Artist", {}).get("value", "?")),
                "url": info.get("url", ""),
                "width": w,
                "height": h,
                "license_url": em.get("LicenseUrl", {}).get("value", ""),
                "credit": strip_html(em.get("Credit", {}).get("value", "")),
            }
        )
    results.sort(key=lambda r: r["score"], reverse=True)
    return results


def download(src_url: str, out_path: str) -> int:
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    data = http_get(src_url)
    with open(out_path, "wb") as f:
        f.write(data)
    return len(data)


def main() -> None:
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sp = sub.add_parser("search")
    sp.add_argument("query")
    sp.add_argument("--limit", type=int, default=20)
    sp.add_argument("--top", type=int, default=5)
    dl = sub.add_parser("download")
    dl.add_argument("src")
    dl.add_argument("out")
    args = ap.parse_args()

    if args.cmd == "search":
        results = search(args.query, limit=args.limit)
        print(json.dumps(results[: args.top], indent=2))
    elif args.cmd == "download":
        n = download(args.src, args.out)
        print(f"wrote {n} bytes to {args.out}")


if __name__ == "__main__":
    main()
