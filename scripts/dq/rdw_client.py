"""Thin RDW Socrata client (token + GET with 429 retry). Copied from
scripts/rdw_masses_prototype.py to keep the dq package self-contained."""
import json
import os
import re
import time
import urllib.error
import urllib.parse
import urllib.request

R = "https://opendata.rdw.nl/resource"
KF_ENV = r"F:\projects\kentekenfeiten\.env"


def token():
    if os.environ.get("RDW_APP_TOKEN"):
        return os.environ["RDW_APP_TOKEN"]
    try:
        with open(KF_ENV, encoding="utf-8") as f:
            m = re.search(r"^RDW_APP_TOKEN=(.+)$", f.read(), re.M)
            return m.group(1).strip() if m else None
    except OSError:
        return None


_TOKEN = token()


def soda(ds, params):
    url = f"{R}/{ds}.json?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, headers={"Accept": "application/json"})
    if _TOKEN:
        req.add_header("X-App-Token", _TOKEN)
    for attempt in range(1, 6):
        try:
            with urllib.request.urlopen(req, timeout=60) as res:
                return json.load(res)
        except urllib.error.HTTPError as e:
            if e.code == 429:
                time.sleep(2 * attempt)
                continue
            raise
    raise RuntimeError(f"SODA {ds} kept failing")
