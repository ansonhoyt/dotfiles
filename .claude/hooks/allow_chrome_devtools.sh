#!/usr/bin/env bash
# PreToolUse hook for Chrome DevTools MCP
#
# Policy:
#   allow:
#     - navigate_page / new_page only if URL targets localhost / 127.0.0.1
#     - read-only: list_*, get_*, take_*, lighthouse, performance_*, emulate, resize
#     - interaction: click, fill, fill_form, evaluate_script,
#       wait_for, hover, press_key, type_text
#       (safe because select_page is gated — can't switch away from localhost)
#   ask:
#     - navigate_page / new_page to non-localhost URLs
#     - tab/session: select_page, close_page, upload_file, drag, handle_dialog
#     - any future tools not in the allow list
#   fall through: non-chrome-devtools tools
#
# Tool names look like: mcp__plugin_chrome-devtools-mcp_chrome-devtools__<tool>

set -euo pipefail

die() { echo >&2 "$@"; exit 2; }

command -v jaq &>/dev/null || die "allow_chrome_devtools.sh: jaq not found in PATH"

exec jaq '
  def decide($d): {hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:$d}};
  def tool: .tool_name | ltrimstr("mcp__plugin_chrome-devtools-mcp_chrome-devtools__");

  # ignore non-chrome-devtools tools
  if (.tool_name | test("^mcp__plugin_chrome-devtools-mcp_chrome-devtools__") | not)
  then empty

  # navigation: localhost only
  elif (tool | test("^(navigate_page|new_page)$")) then
    if (.tool_input.url // "" | test("^https?://(localhost|127\\.0\\.0\\.1)(:|/|$)"))
    then decide("allow")
    else decide("ask")
    end

  # read-only + interaction tools
  elif (tool | test("^(list_|get_|take_|performance_|lighthouse_audit|emulate|resize_page|click|fill|fill_form|evaluate_script|wait_for|hover|press_key|type_text)")) then
    decide("allow")

  # everything else (select_page, close_page, upload_file, etc.)
  else decide("ask")
  end'
