#!/usr/bin/env python3
"""Export a Google Doc. Select a doc by searching, URL, or ID."""

import argparse
import json
import os
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path

MIME_TYPES = {
    "md": "text/markdown",
    "txt": "text/plain",
    "pdf": "application/pdf",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "epub": "application/epub+zip",
    "html": "application/zip",
    "odt": "application/vnd.oasis.opendocument.text",
    "rtf": "application/rtf",
}

_xdg = os.environ.get("XDG_CONFIG_HOME")
CONFIG_DIR = (Path(_xdg) if _xdg else Path.home() / ".config") / "gdoc-export"
CREDENTIALS_FILE = CONFIG_DIR / "credentials.json"


def load_credentials():
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    os.environ["GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE"] = str(CREDENTIALS_FILE)
    if not CREDENTIALS_FILE.is_file():
        print("No credentials found. Run:", file=sys.stderr)
        print("  gws auth login --readonly --services drive,docs", file=sys.stderr)
        print(f"  gws auth export --unmasked > {CREDENTIALS_FILE}", file=sys.stderr)
        sys.exit(2)


def run(cmd, *, input=None, check=True):
    """Run a non-interactive command, capturing stdout and stderr."""
    return subprocess.run(cmd, input=input, capture_output=True, text=True, check=check)


def run_tty(cmd, *, input=None, check=True):
    """Run a TUI command with terminal access, capturing only stdout."""
    kw = {"stdout": subprocess.PIPE, "text": True, "check": check}
    if input is not None:
        return subprocess.run(cmd, input=input, **kw)
    with open("/dev/tty") as tty:
        return subprocess.run(cmd, stdin=tty, **kw)


def has_tty():
    try:
        open("/dev/tty").close()
        return True
    except OSError:
        return False


def doc_name(doc_id):
    params = json.dumps({"fileId": doc_id, "fields": "name"})
    try:
        result = run(["gws", "drive", "files", "get", "--params", params])
        return json.loads(result.stdout)["name"]
    except (subprocess.CalledProcessError, json.JSONDecodeError, KeyError):
        return None


def format_date(iso_ts):
    try:
        dt = datetime.fromisoformat(iso_ts)
        return dt.strftime("%b %-d, %Y")
    except ValueError:
        return iso_ts


def search_and_pick(initial_query=""):
    """Interactive search-and-pick loop. Returns a doc ID or exits."""
    interactive = has_tty()
    query = initial_query
    while True:
        if not query:
            if not interactive:
                sys.exit("--query required without a TTY")
            result = run_tty(["gum", "input", "--placeholder", "Search Google Docs..."], check=False)
            query = result.stdout.strip()
            if not query:
                sys.exit(0)

        # Drive query: escape \ and ' inside the single-quoted string.
        # https://developers.google.com/drive/api/guides/ref-search-terms
        escaped = query.translate(str.maketrans({"\\": r"\\", "'": r"\'"}))
        params = json.dumps({
            "q": f"name contains '{escaped}'",
            "fields": "files(id,name,modifiedTime)",
            "orderBy": "modifiedTime desc",
        })
        search_cmd = ["gws", "drive", "files", "list", "--params", params]
        if interactive:
            result = run_tty([
                "gum", "spin", "--spinner", "dot", "--title", "Searching...",
                "--show-stdout", "--", *search_cmd,
            ])
        else:
            result = run(search_cmd)
        try:
            files = json.loads(result.stdout).get("files", [])
        except json.JSONDecodeError:
            files = []

        if not files:
            msg = f"No docs matching '{query}'"
            if not interactive:
                sys.exit(msg)
            print(msg, file=sys.stderr)
            query = ""
            continue

        if len(files) == 1:
            return files[0]["id"]

        if not interactive:
            names = "\n".join(f"  {f['name']}" for f in files)
            sys.exit(f"Multiple matches for '{query}':\n{names}\nRefine query or pass --id.")

        labels = [
            f"{f['name']}  \033[2m({format_date(f['modifiedTime'])})\033[0m\t{f['id']}"
            for f in files
        ]
        selected = run_tty(
            ["gum", "choose", "--no-strip-ansi", "--label-delimiter", "\t",
             "--header", "Export which doc?"],
            input="\n".join(labels),
            check=False,
        )
        if selected.returncode != 0 or not selected.stdout.strip():
            query = ""
            continue

        return selected.stdout.strip().rsplit("\t", 1)[-1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    source = parser.add_mutually_exclusive_group()
    source.add_argument("-q", "--query", metavar="TERM", help="Search Google Docs by name")
    source.add_argument("--url", help="Google Docs URL (extracts doc ID)")
    source.add_argument("--id", dest="doc_id", help="Google Docs document ID")
    parser.add_argument(
        "-f", "--format", default="md", choices=MIME_TYPES,
        help="Export format (default: md)",
    )
    parser.add_argument("-o", "--output", help="Output filename (default: 'Doc Title.{fmt}')")
    parser.add_argument("--force", action="store_true", help="Overwrite output file without prompting")
    args = parser.parse_args()

    load_credentials()

    mime = MIME_TYPES[args.format]
    doc_id = args.doc_id

    if args.url:
        if m := re.search(r"/d/([^/]+)", args.url):
            doc_id = m.group(1)
        else:
            parser.error(f"Could not extract doc ID from URL: {args.url}")

    if not doc_id:
        doc_id = search_and_pick(args.query or "")

    name = doc_name(doc_id)
    output = args.output
    if not output:
        ext = "html.zip" if args.format == "html" else args.format
        output = f"{name or doc_id}.{ext}"

    if Path(output).exists() and not args.force:
        if not has_tty():
            sys.exit(f"{output} exists; pass --force to overwrite")
        result = run_tty(["gum", "confirm", f"Overwrite {output}?"], check=False)
        if result.returncode != 0:
            sys.exit(0)

    params = json.dumps({"fileId": doc_id, "mimeType": mime})
    run(["gws", "drive", "files", "export", "--params", params, "--output", output])

    url = f"https://docs.google.com/document/d/{doc_id}/edit"
    title = name or doc_id
    if sys.stderr.isatty():
        title = f"\033]8;;{url}\033\\{title}\033]8;;\033\\"
    print(f'✅ Exported "{title}" to {output}', file=sys.stderr)
    print(url)


if __name__ == "__main__":
    main()
