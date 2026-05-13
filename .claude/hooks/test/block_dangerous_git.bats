#!/usr/bin/env bats
# Run: bats .claude/hooks/test/

setup() {
  HOOK="${BATS_TEST_DIRNAME}/../block_dangerous_git.sh"
}

run_hook() {
  run "$HOOK" <<< "$(jaq -n --arg c "$1" '{tool_input:{command:$c}}')"
}

assert_blocked() {
  if [ "$status" -ne 2 ]; then
    echo "expected BLOCK (exit 2), got status=$status output=$output" >&2
    return 1
  fi
  case "$output" in
    *BLOCKED*) ;;
    *) echo "expected BLOCKED message, got: $output" >&2; return 1 ;;
  esac
}

assert_passed() {
  if [ "$status" -ne 0 ]; then
    echo "expected PASS (exit 0), got status=$status output=$output" >&2
    return 1
  fi
}

# --- git: existing patterns ---

@test "git push blocked" {
  run_hook 'git push origin main'
  assert_blocked
}

@test "git reset --hard blocked" {
  run_hook 'git reset --hard HEAD~1'
  assert_blocked
}

@test "git clean -fd blocked" {
  run_hook 'git clean -fd'
  assert_blocked
}

@test "git branch -D blocked" {
  run_hook 'git branch -D feature'
  assert_blocked
}

@test "git checkout . blocked" {
  run_hook 'git checkout .'
  assert_blocked
}

@test "git checkout -- path blocked" {
  run_hook 'git checkout -- file.txt'
  assert_blocked
}

@test "git restore . blocked" {
  run_hook 'git restore .'
  assert_blocked
}

@test "git stash drop blocked" {
  run_hook 'git stash drop'
  assert_blocked
}

@test "git stash clear blocked" {
  run_hook 'git stash clear'
  assert_blocked
}

@test "git status passes" {
  run_hook 'git status'
  assert_passed
}

@test "git log passes" {
  run_hook 'git log --oneline'
  assert_passed
}

@test "git commit passes" {
  run_hook 'git commit -m message'
  assert_passed
}

# --- gh: repo admin ---

@test "gh repo delete blocked" {
  run_hook 'gh repo delete foo/bar'
  assert_blocked
}

@test "gh repo create blocked" {
  run_hook 'gh repo create foo'
  assert_blocked
}

@test "gh repo edit blocked" {
  run_hook 'gh repo edit --visibility public'
  assert_blocked
}

@test "gh repo archive blocked" {
  run_hook 'gh repo archive foo/bar'
  assert_blocked
}

@test "gh repo unarchive blocked" {
  run_hook 'gh repo unarchive foo/bar'
  assert_blocked
}

@test "gh repo rename blocked" {
  run_hook 'gh repo rename newname'
  assert_blocked
}

@test "gh repo transfer blocked" {
  run_hook 'gh repo transfer org/repo newowner'
  assert_blocked
}

@test "gh repo clone passes" {
  run_hook 'gh repo clone foo/bar'
  assert_passed
}

@test "gh repo view passes" {
  run_hook 'gh repo view foo/bar'
  assert_passed
}

@test "gh repo fork passes" {
  run_hook 'gh repo fork foo/bar'
  assert_passed
}

# --- gh: releases ---

@test "gh release create blocked" {
  run_hook 'gh release create v1'
  assert_blocked
}

@test "gh release delete blocked" {
  run_hook 'gh release delete v1'
  assert_blocked
}

@test "gh release edit blocked" {
  run_hook 'gh release edit v1 --draft=false'
  assert_blocked
}

@test "gh release upload blocked" {
  run_hook 'gh release upload v1 asset.zip'
  assert_blocked
}

@test "gh release view passes" {
  run_hook 'gh release view v1'
  assert_passed
}

@test "gh release download passes" {
  run_hook 'gh release download v1'
  assert_passed
}

# --- gh: PRs and issues ---

@test "gh pr merge blocked" {
  run_hook 'gh pr merge 1'
  assert_blocked
}

@test "gh pr close blocked" {
  run_hook 'gh pr close 1'
  assert_blocked
}

@test "gh pr create passes" {
  run_hook 'gh pr create --title x'
  assert_passed
}

@test "gh pr list passes" {
  run_hook 'gh pr list'
  assert_passed
}

@test "gh issue close blocked" {
  run_hook 'gh issue close 1'
  assert_blocked
}

@test "gh issue delete blocked" {
  run_hook 'gh issue delete 1'
  assert_blocked
}

@test "gh issue create passes" {
  run_hook 'gh issue create --title x'
  assert_passed
}

@test "gh issue list passes" {
  run_hook 'gh issue list'
  assert_passed
}

# --- gh: secrets and variables ---

@test "gh secret set blocked" {
  run_hook 'gh secret set MY_KEY'
  assert_blocked
}

@test "gh secret delete blocked" {
  run_hook 'gh secret delete MY_KEY'
  assert_blocked
}

@test "gh secret list passes" {
  run_hook 'gh secret list'
  assert_passed
}

@test "gh variable set blocked" {
  run_hook 'gh variable set V'
  assert_blocked
}

@test "gh variable delete blocked" {
  run_hook 'gh variable delete V'
  assert_blocked
}

# --- gh: ruleset, workflow, cache ---

@test "gh ruleset delete blocked" {
  run_hook 'gh ruleset delete 5'
  assert_blocked
}

@test "gh workflow disable blocked" {
  run_hook 'gh workflow disable deploy.yml'
  assert_blocked
}

@test "gh workflow run blocked" {
  run_hook 'gh workflow run deploy.yml'
  assert_blocked
}

@test "gh workflow enable passes" {
  run_hook 'gh workflow enable deploy.yml'
  assert_passed
}

@test "gh workflow list passes" {
  run_hook 'gh workflow list'
  assert_passed
}

@test "gh cache delete blocked" {
  run_hook 'gh cache delete --all'
  assert_blocked
}

@test "gh cache list passes" {
  run_hook 'gh cache list'
  assert_passed
}

# --- gh: auth and keys ---

@test "gh auth logout blocked" {
  run_hook 'gh auth logout'
  assert_blocked
}

@test "gh auth status passes" {
  run_hook 'gh auth status'
  assert_passed
}

@test "gh ssh-key delete blocked" {
  run_hook 'gh ssh-key delete 1'
  assert_blocked
}

@test "gh gpg-key delete blocked" {
  run_hook 'gh gpg-key delete 1'
  assert_blocked
}

@test "gh ssh-key list passes" {
  run_hook 'gh ssh-key list'
  assert_passed
}

# --- gh: raw API ---

@test "gh api -X DELETE blocked" {
  run_hook 'gh api -X DELETE /repos/foo/bar'
  assert_blocked
}

@test "gh api -XDELETE (no space) blocked" {
  run_hook 'gh api -XDELETE /repos/foo/bar'
  assert_blocked
}

@test "gh api --method=PUT blocked" {
  run_hook 'gh api --method=PUT /repos/foo/bar/subscription'
  assert_blocked
}

@test "gh api --method PATCH blocked" {
  run_hook 'gh api --method PATCH /repos/foo/bar'
  assert_blocked
}

@test "gh api GET passes" {
  run_hook 'gh api repos/foo/bar'
  assert_passed
}

@test "gh api graphql read passes" {
  run_hook 'gh api graphql -f query={viewer{login}}'
  assert_passed
}
