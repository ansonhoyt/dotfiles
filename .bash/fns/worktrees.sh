# Create a new worktree and branch from within current git directory.
ga() {
  if [[ -z "$1" ]]; then
    echo "Usage: ga [branch name]"
    return 1
  fi

  local branch="$1"
  local root wt_path
  root="$(git worktree list --porcelain | awk '/^worktree / {print $2; exit}')"
  wt_path="${root%/*}/$(basename "$root")--${branch}"

  git worktree add -b "$branch" "$wt_path" || return 1
  mise trust "$wt_path"
  cd "$wt_path"
}

# Remove worktree and branch from within active worktree directory.
gd() {
  if gum confirm "Remove worktree and branch?"; then
    local cwd base branch root worktree

    cwd="$(pwd)"
    worktree="$(basename "$cwd")"

    # split on first `--`
    root="${worktree%%--*}"
    branch="${worktree#*--}"

    # Protect against accidentally nuking a non-worktree directory
    if [[ "$root" != "$worktree" ]]; then
      cd "../$root"
      git worktree remove "$cwd" --force || return 1
      git branch -D "$branch"
    fi
  fi
}

# Switch worktree and directory. Shows picker if no branch given or doesn't match.
# Usage: gw [<branch>]
gw() {
  local target="$1" list choice path

  list=$(git worktree list --porcelain 2>/dev/null | awk '
    /^worktree / { p=$2 }
    /^branch /   { sub("refs/heads/", "", $2); print $2 "\t" p }
    /^detached/  { print "(detached)\t" p }
  ')
  [[ -z $list ]] && { echo "No git worktrees found."; return 1; }

  if [[ -n $target ]]; then
    path=$(awk -v t="$target" -F'\t' '$1==t {print $2; exit}' <<<"$list")
    [[ -n $path ]] && { cd "$path"; return; }
  fi

  choice=$(gum filter ${target:+--value "$target"} <<<"$list")
  [[ -z $choice ]] && return 1
  cd "$(awk -F'\t' '{print $2}' <<<"$choice")"
}
