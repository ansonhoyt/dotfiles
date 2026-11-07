#!/usr/bin/env bats
# Run: bats .bash/fns/test/

bats_require_minimum_version 1.5.0

# shellcheck disable=SC2329 # stubs below are called by the functions under test
setup() {
  # Isolate from the user's git config (signing, hooks, default branch).
  export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
  export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
  export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com

  source "${BATS_TEST_DIRNAME}/../worktrees.sh"

  # Stub interactive and external tools.
  gum() {
    case "$1" in
      confirm) return "${GUM_CONFIRM_STATUS:-0}" ;;
      input)
        shift
        while [[ $# -gt 0 ]]; do
          [[ $1 == --value ]] && { printf '%s\n' "$2"; return; }
          shift
        done
        ;;
    esac
  }
  gh() {
    [[ -n ${GH_TITLE:-} ]] || return 1
    printf '%s\n' "$GH_TITLE"
  }
  mise() { :; }

  # A path with spaces exercises the porcelain parsing.
  REPO="${BATS_TEST_TMPDIR}/my projects/repo"
  mkdir -p "$REPO"
  git -C "$REPO" init -q -b main
  git -C "$REPO" commit -q --allow-empty -m init
  cd "$REPO" || return
  ROOT="$(git rev-parse --show-toplevel)" # symlink-resolved, as git reports it
}

@test "_worktree_issue_branch defaults to <n>-<slug>" {
  GH_TITLE="Fix: Crash on   Save!!" run _worktree_issue_branch 12
  [ "$output" = "12-fix-crash-on-save" ]
}

@test "_worktree_issue_branch truncates long slugs without a trailing dash" {
  GH_TITLE="$(printf 'word %.0s' {1..20})" run _worktree_issue_branch 12
  [ "${#output}" -le 53 ]
  [[ $output != *- ]]
}

@test "_worktree_issue_branch prompts with no default when lookup fails" {
  run --separate-stderr _worktree_issue_branch 12
  [ -z "$output" ]
  [[ $stderr == *"No branch name from issue #12"* ]]
}

@test "_worktree_issue_branch prompts with no default when the title has no slug" {
  GH_TITLE="🚀 ✨" run --separate-stderr _worktree_issue_branch 12
  [ -z "$output" ]
  [[ $stderr == *"No branch name from issue #12"* ]]
}

@test "ga creates a sibling worktree under a path with spaces" {
  ga feature/x
  [ "$PWD" = "${ROOT%/*}/repo--feature/x" ]
  [ "$(git branch --show-current)" = "feature/x" ]
}

@test "ga <issue-number> names the branch from the issue" {
  GH_TITLE="Add login"
  ga 7
  [ "$(git branch --show-current)" = "7-add-login" ]
}

@test "gd removes a worktree whose branch contains a slash" {
  ga feature/x
  wt="$PWD"
  gd
  [ ! -d "$wt" ]
  [ "$PWD" = "$ROOT" ]
  run git -C "$REPO" rev-parse --verify -q refs/heads/feature/x
  [ "$status" -ne 0 ]
}

@test "gd keeps everything when not confirmed" {
  ga topic
  wt="$PWD"
  GUM_CONFIRM_STATUS=1 gd
  [ -d "$wt" ]
  git -C "$REPO" rev-parse --verify -q refs/heads/topic
}

@test "gd refuses to remove the main worktree" {
  run gd
  [ "$status" -ne 0 ]
  [[ $output == *"main worktree"* ]]
  [ -d "$REPO/.git" ]
}

@test "gd refuses to remove a detached worktree" {
  git worktree add -q --detach "${ROOT}--detached"
  cd "${ROOT}--detached"
  run gd
  [ "$status" -ne 0 ]
  [[ $output == *"detached"* ]]
  [ -d "${ROOT}--detached" ]
}

@test "gd fails outside a git repository" {
  cd "$BATS_TEST_TMPDIR"
  run gd
  [ "$status" -ne 0 ]
  [[ $output == *"not inside a git worktree"* ]]
}

@test "gw switches to a worktree under a path with spaces" {
  git worktree add -q -b other "${ROOT}--other"
  gw other
  [ "$PWD" = "${ROOT}--other" ]
}
