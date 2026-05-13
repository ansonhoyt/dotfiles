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
  # git
  'git push'
  'git reset .*--hard'
  # -f anywhere in flag cluster, or --force
  'git clean .*(-[[:alpha:]]*f|--force)'
  # -D anywhere in flag cluster, or --delete + --force
  'git branch .*(-[[:alpha:]]*D|--delete .*--force|--force .*--delete)'
  # git checkout [<ref>] .
  'git checkout .*\.( |$)'
  # git checkout [<ref>] -- <path>
  'git checkout .*-- '
  'git restore .*\.( |$)'
  'git stash (drop|clear)'

  # gh
  'gh repo (create|delete|edit|archive|unarchive|transfer|rename)'
  'gh release (create|delete|edit|upload)'
  'gh pr (merge|close)'
  'gh issue (close|delete)'
  'gh secret (set|delete)'
  'gh variable (set|delete)'
  'gh ruleset delete'
  'gh workflow (disable|run)'
  'gh cache delete'
  'gh auth logout'
  'gh (ssh-key|gpg-key) delete'
  # POST omitted: GraphQL reads use POST. Higher-level subcommands above
  # cover most write endpoints; remaining gap is acceptable.
  'gh api .*(-X|--method)[= ]*(DELETE|PUT|PATCH)'
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo >&2 "BLOCKED: '$COMMAND' matches dangerous pattern '$pattern'. The user has prevented you from doing this."
    exit 2
  fi
done

exit 0
