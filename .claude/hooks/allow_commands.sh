#!/usr/bin/env bash
# PreToolUse hook for Bash command permissions
# Mirrors .gemini/policies/{allow,ask}.toml
#
# Decisions:
#   - "ask" patterns → prompt user
#   - "allow" patterns → auto-approve
#   - no match → silent exit (normal permissions apply)
#
# Performance: ~10ms (bash arrays + jaq)
#
# Test:
#   ~/.claude/hooks/allow_commands.sh <<< '{"tool_input":{"command":"git status"}}'
#   # → {"permissionDecision":"allow"}
#
#   ~/.claude/hooks/allow_commands.sh <<< '{"tool_input":{"command":"rails db:migrate"}}'
#   # → {"permissionDecision":"ask"}
#
#   ~/.claude/hooks/allow_commands.sh <<< '{"tool_input":{"command":"rm -rf /"}}'
#   # → (no output, falls through to normal permissions)

set -euo pipefail

# exit 2 + stderr = blocking error shown to Claude
die() { echo >&2 "$@"; exit 2; }

command -v jaq &>/dev/null || die "allow_commands.sh: jaq not found in PATH"

# ============================================================
# PATTERN LISTS - edit these as needed
# ============================================================

ask=(
  # Database commands need confirmation
  '(bundle exec |bin/)?(rails|rake) db:'
  # Commands with dangerous flags (safe forms in allow below)
  'find .*-(delete|exec|execdir|fprint|fprintf|fls|ok|okdir)'
  'fd .*( -x| --exec| -X| --exec-batch)'
  'sort .*(-o |--output)'
  'git branch .*(-(d|D|m|M)|--delete|--move|--force)'
)

allow=(
  # Ruby/Rails: standalone, binstubs, or bundle exec
  '(bundle exec |bin/)?(brakeman|bundler-audit|rspec|rubocop|rake|rails|ruby -Itest)'
  # Bundle read-only
  'bundle (config|show|outdated|platform|help|check|doctor|version)'
  # Gem read-only
  'gem (help|list|env|open|outdated|specification|stale|which)'
  # Yarn read-only
  'yarn (list|why|info|versions|config list)'
  # Homebrew read-only
  'brew (list|info|leaves|doctor|config|search|help)'
  # Git read-only
  'git (blame|check-ignore|config get|diff|grep|log|ls-files|show|status)'
  # GitHub CLI (read-only + bounded mutations)
  'gh (issue|pr|repo) (view|list|status|diff|checks)'
  'gh issue (edit|develop)'
  'gh pr create'
  # Utilities (read-only)
  '(col|column|cut|date|diff|echo|grep|head|jaq|jq|man|nl|pgrep|printenv|ps|rg|tail|test|tr|uname|wc)( |$)'
  # File/path utilities (read-only)
  '(basename|cat|df|dirname|du|file|ls|pwd|readlink|realpath|stat|tree|type|which)( |$)'
  # Directory management
  'mkdir( |$)'
  # Commands with dangerous flags (ask patterns above block unsafe forms)
  '(find|fd|sort|git branch)( |$)'
  # Shell introspection (read-only forms only)
  'complete -p$'
  'command -v$'
  'env$'
)

# ============================================================
# ENGINE
# ============================================================

# Combine arrays into regex: ^(pattern1|pattern2|...)
join() { local IFS='|'; echo "^($*)"; }

exec jaq -c \
  --arg ask "$(join "${ask[@]}")" \
  --arg allow "$(join "${allow[@]}")" \
  '.tool_input.command // empty |
   if . == "" then empty
   else (if test($ask) then {permissionDecision:"ask"}
   else (if test($allow) then {permissionDecision:"allow"}
   else empty end) end) end'
