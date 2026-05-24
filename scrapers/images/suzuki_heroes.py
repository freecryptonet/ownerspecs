#!/usr/bin/env python3
"""Download 1280px Wikimedia thumbs for the 11 Suzuki gens and emit the migration SQL.

Run on the VPS (writes into public/images/suzuki/<slug>/hero.jpg).
"""
import json
import os
import sys
import urllib.parse
import urllib.request

UA = "ownerspecs-bot/0.1 (+https://ownerspecs.com; contact timgvk@gmail.com)"

PICKS = [
    {
        "gen_id": 321, "slug": "across-ax10-suv-2020-present",
        "file": "Suzuki_Across_(XA50)_Auto_Zuerich_2021_IMG_0436.jpg",
        "artist": "Alexander Migl", "license": "CC BY-SA 4.0",
        "caption": "Suzuki Across (XA50) at Auto Zürich 2021",
    },
    {
        "gen_id": 322, "slug": "baleno-wb-hatchback-2015-2022",
        "file": "2016_Suzuki_Baleno_SZ5_Boosterjet_1.0_Front.jpg",
        "artist": "Makizox", "license": "CC BY-SA 4.0",
        "caption": "2016 Suzuki Baleno SZ5 Boosterjet 1.0",
    },
    {
        "gen_id": 323, "slug": "celerio-lf-hatchback-2014-2017",
        "file": "2017_Suzuki_Celerio_SZ4_Automatic_1.0_Front.jpg",
        "artist": "Vauxford", "license": "CC BY-SA 4.0",
        "caption": "2017 Suzuki Celerio SZ4 Automatic 1.0",
    },
    {
        "gen_id": 324, "slug": "fronx-ytb-suv-2023-present",
        "file": "Suzuki_Fronx_(front).jpg",
        "artist": "Jason Lawrence", "license": "CC BY 2.0",
        "caption": "Suzuki Fronx (YTB) front three-quarter",
    },
    {
        "gen_id": 325, "slug": "ignis-mf-hatchback-2016-present",
        "file": "2017_Suzuki_Ignis_(MF)_GLX_hatchback_(2018-08-20)_01.jpg",
        "artist": "EurovisionNim", "license": "CC BY-SA 4.0",
        "caption": "2017 Suzuki Ignis (MF) GLX hatchback",
    },
    {
        "gen_id": 326, "slug": "jimny-jb64-suv-2018-present",
        "file": "Suzuki_Jimny_XG_(3BA-JB64W-JXGR)_front.jpg",
        "artist": "Tokumeigakarinoaoshima", "license": "CC BY-SA 4.0",
        "caption": "Suzuki Jimny XG (JB64) front",
    },
    {
        "gen_id": 327, "slug": "s-cross-jy-suv-2013-2021",
        "file": "2014_Suzuki_SX4_S-Cross_(JY)_GL_wagon_(2015-07-10)_01.jpg",
        "artist": "OSX", "license": "CC0",
        "caption": "2014 Suzuki SX4 S-Cross (JY) GL wagon",
    },
    {
        "gen_id": 328, "slug": "s-cross-yed-suv-2022-present",
        "file": "2022_Suzuki_S-Cross.jpg",
        "artist": "DavidivardiIL", "license": "CC BY-SA 4.0",
        "caption": "2022 Suzuki S-Cross (YED)",
    },
    {
        "gen_id": 329, "slug": "swace-sx10-wagon-2020-present",
        "file": "Suzuki_Swace_1X7A0433.jpg",
        "artist": "Alexander Migl", "license": "CC BY-SA 4.0",
        "caption": "Suzuki Swace (SX10)",
    },
    {
        "gen_id": 330, "slug": "swift-az-hatchback-2017-2024",
        "file": "2017_Suzuki_Swift_(AZ)_GLX_Turbo_5-door_hatchback_(2017-07-15)_01.jpg",
        "artist": "EurovisionNim", "license": "CC BY-SA 4.0",
        "caption": "2017 Suzuki Swift (AZ) GLX Turbo",
    },
    {
        "gen_id": 331, "slug": "vitara-ly-suv-2015-present",
        "file": "SUZUKI_VITARA_(LY)_China.jpg",
        "artist": "Dinkun Chen", "license": "CC BY-SA 4.0",
        "caption": "Suzuki Vitara (LY)",
    },
]


def http_get(url):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read()


def commons_thumb_url(filename, width=1280):
    """Build a Wikimedia Commons thumb URL.

    The convention: hash MD5(filename) → a/ab, then upload path:
    https://upload.wikimedia.org/wikipedia/commons/a/ab/<file>
    Thumb: ditto /thumb/a/ab/<file>/<W>px-<file>
    For .svg the suffix differs (thumb-name has .png suffix). We deal in .jpg here.
    """
    import hashlib
    name = filename.replace(" ", "_")
    md5 = hashlib.md5(name.encode("utf-8")).hexdigest()
    enc = urllib.parse.quote(name)
    p = f"{md5[0]}/{md5[0:2]}/{enc}"
    return f"https://upload.wikimedia.org/wikipedia/commons/thumb/{p}/{width}px-{enc}"


def jpeg_dims(path):
    """Pure-stdlib JPEG dimensions via SOFn marker scan."""
    with open(path, "rb") as f:
        soi = f.read(2)
        if soi != b"\xff\xd8":
            raise ValueError("not a JPEG")
        while True:
            b = f.read(1)
            if not b:
                raise ValueError("truncated")
            if b != b"\xff":
                continue
            marker = f.read(1)
            while marker == b"\xff":
                marker = f.read(1)
            mb = marker[0]
            if 0xC0 <= mb <= 0xCF and mb not in (0xC4, 0xC8, 0xCC):
                f.read(3)
                h = int.from_bytes(f.read(2), "big")
                w = int.from_bytes(f.read(2), "big")
                return w, h
            else:
                size = int.from_bytes(f.read(2), "big")
                f.read(size - 2)


def main():
    base = sys.argv[1] if len(sys.argv) > 1 else "/home/deploy/ownerspecs/public/images/suzuki"
    today = "2026-05-25"
    rows = []
    for p in PICKS:
        out_dir = os.path.join(base, p["slug"])
        os.makedirs(out_dir, exist_ok=True)
        out_path = os.path.join(out_dir, "hero.jpg")
        url = commons_thumb_url(p["file"], 1280)
        try:
            data = http_get(url)
            with open(out_path, "wb") as f:
                f.write(data)
        except Exception as e:
            print(f"ERR {p['slug']}: {e}", file=sys.stderr)
            continue
        try:
            w, h = jpeg_dims(out_path)
        except Exception as e:
            print(f"ERR dims {p['slug']}: {e}", file=sys.stderr)
            continue
        print(f"OK {p['slug']}: {w}x{h} ({len(data)} bytes)", file=sys.stderr)
        license_url = {
            "CC0": "https://creativecommons.org/publicdomain/zero/1.0/",
            "CC BY 2.0": "https://creativecommons.org/licenses/by/2.0",
            "CC BY-SA 4.0": "https://creativecommons.org/licenses/by-sa/4.0",
        }.get(p["license"], "")
        # SQL-safe quote helper
        def q(s):
            return "'" + s.replace("'", "''") + "'"
        attribution = f"{p['artist']} / Wikimedia Commons, {p['license']}"
        commons_page = "https://commons.wikimedia.org/wiki/File:" + urllib.parse.quote(p["file"].replace(" ", "_"))
        rows.append(
            f"({p['gen_id']}, NULL, NULL, '/images/suzuki/{p['slug']}/hero.jpg', "
            f"'wikimedia', {q(p['license'])}, {q(attribution)}, {q(commons_page)}, "
            f"'{today}', {q(p['caption'])}, '3-4-front', {w}, {h})"
        )
    if rows:
        print("INSERT INTO images")
        print("  (generation_id, trim_id, market_id, url, source, license, attribution, original_url, download_date, caption, position, width, height)")
        print("VALUES")
        for i, r in enumerate(rows):
            print("  " + r + ("," if i < len(rows) - 1 else ";"))


if __name__ == "__main__":
    main()
