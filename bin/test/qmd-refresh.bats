#!/usr/bin/env bats
# Run: bats bin/test/

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../qmd-refresh"
  export HOME="$BATS_TEST_TMPDIR/home"
  export XDG_CONFIG_HOME="$HOME/.config"
  STUBS="$BATS_TEST_TMPDIR/stubs"
  mkdir -p "$XDG_CONFIG_HOME/qmd" "$STUBS"
  QMD_LOG="$BATS_TEST_TMPDIR/qmd.log"
  export QMD_LOG
  printf '#!/bin/sh\necho "$* $(pwd)" >> "$QMD_LOG"\n' > "$STUBS/qmd"
  chmod +x "$STUBS/qmd"
  export PATH="$STUBS:$PATH"

  VAULT="$BATS_TEST_TMPDIR/my vault"
  mkdir -p "$VAULT/sub"
  echo note > "$VAULT/sub/a.md"
  index "$VAULT"
}

index() {
  printf 'collections:\n  notes:\n    path: "%s"\n' "$1" > "$XDG_CONFIG_HOME/qmd/index.yml"
}

assert_qmd_not_run() {
  if [ -e "$QMD_LOG" ]; then
    echo "qmd ran: $(cat "$QMD_LOG")" >&2
    return 1
  fi
}

@test "refreshes from \$HOME when every collection is available" {
  run "$SCRIPT"
  [ "$status" -eq 0 ]
  [ "$(cat "$QMD_LOG")" = "update $HOME
embed $HOME" ]
}

@test "expands ~ in collection paths" {
  mkdir -p "$HOME/notes"
  # shellcheck disable=SC2088 # the literal ~ is what index.yml contains
  index "~/notes"
  run "$SCRIPT"
  [ "$status" -eq 0 ]
  grep -q '^update ' "$QMD_LOG"
}

@test "exits quietly without an index" {
  rm "$XDG_CONFIG_HOME/qmd/index.yml"
  run "$SCRIPT"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
  assert_qmd_not_run
}

@test "skips while iCloud has evicted a file" {
  touch "$VAULT/sub/.b.md.icloud"
  run "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ $output == *"not downloaded from iCloud"* ]]
  assert_qmd_not_run
}

@test "skips evicted files through a symlinked collection root" {
  ln -s "$VAULT" "$HOME/notes"
  index "$HOME/notes"
  touch "$VAULT/sub/.b.md.icloud"
  run "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ $output == *"not downloaded from iCloud"* ]]
  assert_qmd_not_run
}

@test "refreshes an available symlinked collection root" {
  ln -s "$VAULT" "$HOME/notes"
  index "$HOME/notes"
  run "$SCRIPT"
  [ "$status" -eq 0 ]
  [ "$(cat "$QMD_LOG")" = "update $HOME
embed $HOME" ]
}

@test "skips while a collection folder is missing" {
  index "$BATS_TEST_TMPDIR/gone"
  run "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ $output == *"unavailable"* ]]
  assert_qmd_not_run
}

@test "does not refresh when yq fails" {
  printf '#!/bin/sh\nexit 1\n' > "$STUBS/yq"
  chmod +x "$STUBS/yq"
  run "$SCRIPT"
  [ "$status" -ne 0 ]
  assert_qmd_not_run
}

@test "does not refresh when the placeholder scan fails" {
  mkdir "$VAULT/locked"
  chmod 000 "$VAULT/locked"
  run "$SCRIPT"
  chmod 755 "$VAULT/locked"
  [ "$status" -ne 0 ]
  assert_qmd_not_run
}

@test "stops before embed when update fails" {
  printf '#!/bin/sh\necho "$*" >> "$QMD_LOG"\n[ "$1" = update ] && exit 3\nexit 0\n' > "$STUBS/qmd"
  run "$SCRIPT"
  [ "$status" -eq 3 ]
  [ "$(cat "$QMD_LOG")" = "update" ]
}
