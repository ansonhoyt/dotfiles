#!/usr/bin/env bats
# Run: bats .bash/test/

setup() {
  export HOME="$BATS_TEST_TMPDIR/home"
  mkdir -p "$HOME/.bash"
  cp "$BATS_TEST_DIRNAME/../../.bashrc" "$HOME/.bashrc"
  cp "$BATS_TEST_DIRNAME/../env.sh" "$BATS_TEST_DIRNAME/../android.sh" "$HOME/.bash/"

  # Exercise real environment setup without starting interactive tools.
  for module in options aliases completions functions prompt init; do
    printf ':\n' > "$HOME/.bash/$module.sh"
  done
  BASH_BIN="$(command -v bash)"
}

assert_environment() {
  [ "$status" -eq 0 ]
  [[ $output == *"EDITOR=vim"* || $output == *"EDITOR=nvim"* ]]
  [[ $output == *"ANDROID_HOME=$HOME/Library/Android/sdk"* ]]
  [[ $output == *"SSH_AUTH_SOCK=$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"* ]]
  [[ $output == *"PATH=$HOME/bin:$HOME/.local/bin:/usr/bin:/bin:"* ]]
}

@test "interactive non-login shell initializes an uninherited environment" {
  run env -i HOME="$HOME" PATH=/usr/bin:/bin TERM=dumb \
    "$BASH_BIN" --noprofile --rcfile "$HOME/.bashrc" -ic \
    'printf "EDITOR=%s\nANDROID_HOME=%s\nSSH_AUTH_SOCK=%s\nPATH=%s\n" "$EDITOR" "$ANDROID_HOME" "$SSH_AUTH_SOCK" "$PATH"'
  assert_environment
}

@test "interactive login shell does not load the environment twice" {
  # .bash_profile sources env/android before .bashrc. Skip machine-specific
  # Homebrew/mise initialization, retaining Bash's actual login-shell flag.
  run env -i HOME="$HOME" PATH=/usr/bin:/bin TERM=dumb \
    "$BASH_BIN" --noprofile --norc -lic '
      source ~/.bash/env.sh
      source ~/.bash/android.sh
      before=$PATH
      source ~/.bashrc
      [[ $PATH == "$before" ]] || exit 1
      printf "EDITOR=%s\nANDROID_HOME=%s\nSSH_AUTH_SOCK=%s\nPATH=%s\n" "$EDITOR" "$ANDROID_HOME" "$SSH_AUTH_SOCK" "$PATH"
    '
  assert_environment
}

@test "non-interactive bashrc still returns without changing the environment" {
  run env -i HOME="$HOME" PATH=/usr/bin:/bin \
    "$BASH_BIN" --noprofile --norc -c '
      source ~/.bashrc
      [[ $PATH == /usr/bin:/bin && -z ${EDITOR:-} && -z ${ANDROID_HOME:-} && -z ${SSH_AUTH_SOCK:-} ]]
    '
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
