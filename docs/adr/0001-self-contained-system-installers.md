# ADR 0001: system/ daemon installers stay self-contained

Status: accepted (2026-07-07)

## Context

`system/<name>/` dirs each hold a root LaunchDaemon: plist + install.sh +
uninstall.sh. logi-switch and maxfiles share a ~3-line launchd dance
(`install` root:wheel plist → `bootout || true` → `bootstrap`). An
architecture review proposed extracting it into a shared `system/lib.sh`
adapter; it was implemented and reverted same day.

## Decision

Each daemon's scripts stay self-contained. The duplicated launchd dance is
accepted. New daemons copy `system/maxfiles/` as the template.

## Consequences

- Copying a `system/<name>/` dir to another machine works standalone — no
  `source ../lib.sh` path dependency. Valuable for sudo system scripts.
- The shared code is ~3 stable lines (launchctl API); the sourcing wiring
  (SRC resolve + shellcheck directive + source) cost as many lines as it
  saved, and net LOC went up. Deletion test failed: removing the lib did
  not concentrate complexity anywhere.
- Future reviews: do not re-suggest a shared system/ helper lib unless the
  per-daemon boilerplate grows well beyond the 3-line dance (e.g. logging,
  arch detection, validation appear in 3+ copies).
