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
  cd "$wt_path" || return 1
  [[ -x bin/setup ]] && echo "💡 bin/setup"
}

# Start work on a GitHub issue: open a tmux window with a live hunk diff and
# claude running `/tdd #<issue>`. Creates a worktree unless the chosen branch
# is the one already checked out.
# Usage:
#   tdd <issue>            prompt for branch (default issue-<n>-<slug>) -> worktree
#   tdd <issue> <branch>   worktree on <branch>
#   tdd <issue> <current>  branch == current -> work in place, no worktree
tdd() {
  local num="$1"; shift
  [[ $num =~ ^[0-9]+$ ]] || { echo "Usage: tdd <issue> [branch]"; return 1; }
  [[ -z $TMUX ]]         && { echo "Start tmux first."; return 1; }

  local branch="$1"
  if [[ -z $branch ]]; then
    local slug
    slug="$(gh issue view "$num" --json title -q .title 2>/dev/null \
            | tr '[:upper:]' '[:lower:]' \
            | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g' | cut -c1-50)"
    branch="$(gum input --prompt 'branch: ' --value "issue-${num}-${slug}")" || return 1
    [[ -z $branch ]] && { echo "tdd: no branch"; return 1; }
  fi

  local make_wt=true
  [[ $branch == "$(git branch --show-current)" ]] && make_wt=false

  local pane setup="" branch_q
  printf -v branch_q '%q' "$branch"
  pane=$(tmux new-window -c "$PWD" -P -F '#{pane_id}')
  $make_wt && setup="ga $branch_q && "
  setup+="TDL_MAIN='hunk diff --watch' tdl 'claude \"/tdd #${num}\"'"
  tmux send-keys -t "$pane" "$setup" C-m
}

# Remove worktree and branch from within active worktree directory.
gd() {
  if gum confirm "Remove worktree and branch?"; then
    local cwd branch root worktree

    cwd="$(pwd)"
    worktree="$(basename "$cwd")"

    # split on first `--`
    root="${worktree%%--*}"
    branch="${worktree#*--}"

    # Protect against accidentally nuking a non-worktree directory
    if [[ "$root" != "$worktree" ]]; then
      cd "../$root" || return 1
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
    if [[ -n $path ]]; then
      cd "$path" || return 1
      echo "→ $target"
      return
    fi
  fi

  choice=$(gum filter ${target:+--value "$target"} <<<"$list")
  [[ -z $choice ]] && return 1
  cd "$(awk -F'\t' '{print $2}' <<<"$choice")" || return 1
  echo "→ $(awk -F'\t' '{print $1}' <<<"$choice")"
}
