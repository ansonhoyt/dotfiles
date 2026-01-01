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
#   # → {"decision":"allow"}
#
#   ~/.claude/hooks/allow_commands.sh <<< '{"tool_input":{"command":"rails db:migrate"}}'
#   # → {"decision":"ask"}
#
#   ~/.claude/hooks/allow_commands.sh <<< '{"tool_input":{"command":"rm -rf /"}}'
#   # → (no output, falls through to normal permissions)

set -euo pipefail

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
  'brew (list|info|leaves|doctor|config|search)'
  # Git read-only
  'git (blame|check-ignore|config get|diff|grep|log|ls-files|show|status)'
  # Utilities (read-only)
  '(date|diff|echo|file|grep|head|jaq|jq|ls|pwd|rg|stat|tail|test|tree|type|uname|wc|which)( |$)'
  # File utilities (read-only)
  '(cat|basename|dirname|realpath|readlink|du|df|nl|tr|cut|column|printenv)( |$)'
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
   else (if test($ask) then {decision:"ask"}
   else (if test($allow) then {decision:"allow"}
   else empty end) end) end'
