#!/usr/bin/env bash
# PreToolUse hook: hard-block dangerous git commands.
# Adapted from mattpocock/skills/skills/misc/git-guardrails-claude-code.
#
# Test:
#   ~/.claude/hooks/block_dangerous_git.sh <<< '{"tool_input":{"command":"git push origin main"}}'
#   # → exit 2, BLOCKED message to stderr

set -euo pipefail

COMMAND=$(jaq -r '.tool_input.command // empty')
[ -z "$COMMAND" ] && exit 0

DANGEROUS_PATTERNS=(
  'git push'
  'git reset --hard'
  'git clean -fd'
  'git clean -f'
  'git branch -D'
  'git checkout \.'
  'git restore \.'
  'push --force'
  'reset --hard'
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo >&2 "BLOCKED: '$COMMAND' matches dangerous pattern '$pattern'. The user has prevented you from doing this."
    exit 2
  fi
done

exit 0
