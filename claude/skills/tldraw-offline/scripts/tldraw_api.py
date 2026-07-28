#!/usr/bin/env python3
"""Tiny client for the tldraw offline local canvas API.

Locates server.json (cross-platform), reads the per-launch port + token FRESH on
every call (the token rotates per app launch and must not be cached), and wraps
the handful of endpoints an agent needs.

Usage:
    tldraw_api.py docs                     # print the live API readme (GET /)
    tldraw_api.py doc                      # print the focused document id (or "none")
    tldraw_api.py docs-list                # JSON list of open documents
    tldraw_api.py search '<js>'            # run JS against the `api` object, print JSON result
    tldraw_api.py search -f snippet.js     # ...from a file
    tldraw_api.py exec <docId> <file.js>   # run JS against the real Editor in <docId>
    tldraw_api.py exec <docId> -           # ...read the snippet from stdin
    tldraw_api.py shot <docId> [out.png]   # screenshot; copies to out.png if given, prints path

Exit code is non-zero on API errors, and the error payload is printed to stderr.
"""
import json
import os
import shutil
import sys
import urllib.request
import urllib.error


def server_json_path():
    override = os.environ.get("TLDRAW_SERVER_JSON")
    if override:
        return override
    if sys.platform == "darwin":
        return os.path.expanduser("~/Library/Application Support/tldraw/server.json")
    if sys.platform.startswith("win"):
        base = os.environ.get("APPDATA", os.path.expanduser("~/AppData/Roaming"))
        return os.path.join(base, "tldraw", "server.json")
    # linux / other
    base = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
    return os.path.join(base, "tldraw", "server.json")


def creds():
    """Read port + token fresh. Do not cache across calls."""
    p = server_json_path()
    try:
        with open(p) as f:
            d = json.load(f)
    except FileNotFoundError:
        sys.exit(f"server.json not found at {p}\n"
                 "Is 'tldraw offline' running? Launch the app, then retry.")
    return d["port"], d["token"]


def call(method, path, body=None, auth=True):
    port, token = creds()
    url = f"http://127.0.0.1:{port}{path}"
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    if body is not None:
        req.add_header("content-type", "application/json")
    if auth:
        req.add_header("authorization", f"Bearer {token}")
    try:
        with urllib.request.urlopen(req) as r:
            raw = r.read().decode()
    except urllib.error.HTTPError as e:
        sys.stderr.write(e.read().decode() + "\n")
        sys.exit(f"HTTP {e.code} from {method} {path}")
    except urllib.error.URLError as e:
        sys.exit(f"Could not reach the app on port {port}: {e.reason}\n"
                 "Is 'tldraw offline' running?")
    return raw


def search(code):
    raw = call("POST", "/api/search", {"code": code})
    out = json.loads(raw)
    if not out.get("success"):
        sys.stderr.write(raw + "\n")
        sys.exit("search failed")
    return out["result"]


def run_exec(doc_id, code):
    raw = call("POST", f"/api/doc/{doc_id}/exec", {"code": code})
    out = json.loads(raw)
    if not out.get("success"):
        sys.stderr.write(raw + "\n")
        sys.exit("exec failed")
    return out["result"]


def read_snippet(arg):
    if arg == "-":
        return sys.stdin.read()
    with open(arg) as f:
        return f.read()


def main(argv):
    if not argv:
        sys.exit(__doc__)
    cmd = argv[0]

    if cmd == "docs":
        print(call("GET", "/", auth=False))
        return

    if cmd == "doc":
        d = search("const d = await api.getFocusedDoc(); return d ? d.id : null")
        print(d if d else "none")
        return

    if cmd == "docs-list":
        print(json.dumps(search("return await api.getDocs()"), indent=2))
        return

    if cmd == "search":
        if len(argv) >= 3 and argv[1] == "-f":
            code = read_snippet(argv[2])
        elif len(argv) >= 2:
            code = argv[1]
        else:
            sys.exit("usage: search '<js>'  |  search -f <file.js>")
        print(json.dumps(search(code), indent=2))
        return

    if cmd == "exec":
        if len(argv) < 3:
            sys.exit("usage: exec <docId> <file.js|->")
        doc_id, snippet = argv[1], read_snippet(argv[2])
        print(json.dumps(run_exec(doc_id, snippet), indent=2))
        return

    if cmd == "shot":
        if len(argv) < 2:
            sys.exit("usage: shot <docId> [out.png]")
        doc_id = argv[1]
        info = search(f"return await api.getScreenshot({json.dumps(doc_id)})")
        fp = info["filePath"] if isinstance(info, dict) else info
        if len(argv) >= 3:
            shutil.copy(fp, argv[2])
            print(argv[2])
        else:
            print(fp)
        return

    sys.exit(f"unknown command: {cmd}\n{__doc__}")


if __name__ == "__main__":
    main(sys.argv[1:])
