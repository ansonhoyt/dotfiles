#!/usr/bin/env bats
# Exercise bootstrap's browse setup without running the rest of bootstrap.

bats_require_minimum_version 1.5.0

# shellcheck disable=SC2329 # mise is exported to the bootstrap subprocess
setup() {
  export LOG="$BATS_TEST_TMPDIR/commands.log"
  export BOOTSTRAP="$BATS_TEST_DIRNAME/../../bootstrap.sh"
  mise() {
    printf '%s\n' "$*" >> "$LOG"
    if [[ $* == *'mcp get browse' ]]; then
      return "${SERVER_EXISTS:-1}"
    fi
  }
  export -f mise
}

configure_browse() {
  # Run the actual setup block, including its shell error handling.
  bash -e -o pipefail -c "$(sed -n '/^echo "Configuring mise-managed browse/ , /^# Start pitchfork/ p' "$BOOTSTRAP")"
}

@test "browse setup registers missing servers through mise, never the self-installer" {
  run configure_browse
  [ "$status" -eq 0 ]
  grep -Fx 'exec -- claude mcp add browse --scope user --env OPENCODE_BROWSER_AUTO_UPDATE=notify -- mise exec -- browse mcp' "$LOG"
  grep -Fx 'exec -- codex mcp add browse --env OPENCODE_BROWSER_AUTO_UPDATE=notify -- mise exec -- browse mcp' "$LOG"
  run ! grep -q 'browse install' "$LOG"
  [ "$(wc -l < "$LOG")" -eq 4 ]
}

@test "browse setup preserves existing servers on repeated runs" {
  export SERVER_EXISTS=0
  run configure_browse
  [ "$status" -eq 0 ]
  run ! grep -q 'mcp add' "$LOG"
  [ "$(wc -l < "$LOG")" -eq 2 ]
}
