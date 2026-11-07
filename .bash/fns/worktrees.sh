# Prompt for a GitHub issue's branch name, defaulting to <n>-<slug>.
_worktree_issue_branch() {
  local num="$1" title slug=""
  if title="$(gh issue view "$num" --json title -q .title 2>/dev/null)"; then
    slug="$(printf '%s\n' "$title" \
      | tr '[:upper:]' '[:lower:]' \
      | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g' \
      | cut -c1-50 \
      | sed 's/-$//')"
  fi
  if [[ -z $slug ]]; then
    echo "No branch name from issue #${num}. Enter one or cancel." >&2
    gum input --prompt 'branch: ' --placeholder "$num"
  else
    gum input --prompt 'branch: ' --value "${num}-${slug}"
  fi
}

# Create a new worktree and branch from within current git directory.
# Usage: ga <branch|issue-number>
ga() {
  if [[ -z "$1" ]]; then
    echo "Usage: ga <branch|issue-number>"
    return 1
  fi

  local branch="$1"
  if [[ $branch =~ ^[0-9]+$ ]]; then
    branch="$(_worktree_issue_branch "$branch")" || return 1
    [[ -z $branch ]] && { echo "ga: no branch"; return 1; }
  fi

  local root wt_path
  root="$(git worktree list --porcelain | awk '/^worktree / { print substr($0, 10); exit }')"
  wt_path="${root%/*}/$(basename "$root")--${branch}"

  git worktree add -b "$branch" "$wt_path" || return 1
  mise trust "$wt_path"
  cd "$wt_path" || return 1
  if [[ -x bin/setup ]]; then echo "💡 bin/setup"; fi
}

# Start work on a GitHub issue: open a tmux window with a live hunk diff and
# claude running `/tdd #<issue>`. Creates a worktree unless the chosen branch
# is the one already checked out.
# Usage:
#   tdd <issue>            prompt for branch (default <n>-<slug>) -> worktree
#   tdd <issue> <branch>   worktree on <branch>
#   tdd <issue> <current>  branch == current -> work in place, no worktree
tdd() {
  local num="$1"; shift
  [[ $num =~ ^[0-9]+$ ]] || { echo "Usage: tdd <issue> [branch]"; return 1; }
  [[ -z $TMUX ]]         && { echo "Start tmux first."; return 1; }

  local branch="$1"
  if [[ -z $branch ]]; then
    branch="$(_worktree_issue_branch "$num")" || return 1
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
  local cwd branch root worktree

  cwd="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "gd: not inside a git worktree" >&2
    return 1
  }
  branch="$(git branch --show-current)"
  root="$(git worktree list --porcelain | awk '/^worktree / { print substr($0, 10); exit }')"
  [[ $cwd != "$root" ]] || { echo "gd: refusing to remove the main worktree" >&2; return 1; }
  [[ -n $branch ]] || { echo "gd: refusing to remove a detached worktree" >&2; return 1; }

  worktree="$(basename "$cwd")"
  if gum confirm "Remove worktree '$worktree' and branch '$branch'?"; then
    cd "$root" || return 1
    git worktree remove "$cwd" --force || return 1
    git branch -D "$branch"
  fi
}

# Switch worktree and directory. Shows picker if no branch given or doesn't match.
# Usage: gw [<branch>]
gw() {
  local target="$1" list choice path

  list=$(git worktree list --porcelain 2>/dev/null | awk '
    /^worktree / { p=substr($0, 10) }
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
