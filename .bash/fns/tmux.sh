# Create a Tmux Dev Layout with editor, ai, and terminal
# Usage: tdl [<c|cx|codex|other_ai>] [<second_ai>]
tdl() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }
  [[ $1 == -h || $1 == --help ]] && { echo "Usage: tdl [<c|cx|codex|other_ai>] [<second_ai>]"; return 0; }

  local current_dir="${PWD}"
  local editor_pane ai_pane ai2_pane
  local ai="${1:-claude}"
  local ai2="$2"

  # Use TMUX_PANE for the pane we're running in (stable even if active window changes)
  editor_pane="$TMUX_PANE"

  # Name the current window after the base directory name
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  # Split window vertically - top 90%, bottom 10% (target editor pane explicitly)
  tmux split-window -v -p 10 -t "$editor_pane" -c "$current_dir"

  # Split editor pane horizontally - AI on right 40% (capture new pane ID directly)
  ai_pane=$(tmux split-window -h -p 40 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  # If second AI provided, split the AI pane vertically
  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  # Run ai in the right pane
  tmux send-keys -t "$ai_pane" "$ai" C-m

  # Run editor in the left pane
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m

  # Select the editor pane for focus
  tmux select-pane -t "$editor_pane"
}

# Create a Tmux Dev Square layout with editor, diff watch, terminal, and AI.
# Usage: tds [<c|cx|codex|other_ai>]
tds() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tds."; return 1; }
  [[ $1 == -h || $1 == --help ]] && { echo "Usage: tds [<c|cx|codex|other_ai>]"; return 0; }

  local ai="${1:-claude}"
  local current_dir="${PWD}"
  local editor_pane diff_pane terminal_pane ai_pane

  editor_pane="$TMUX_PANE"

  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  terminal_pane=$(tmux split-window -v -p 50 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
  diff_pane=$(tmux split-window -h -p 50 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
  ai_pane=$(tmux split-window -h -p 50 -t "$terminal_pane" -c "$current_dir" -P -F '#{pane_id}')

  tmux send-keys -t "$editor_pane" -l "$EDITOR ."
  tmux send-keys -t "$editor_pane" C-m
  tmux send-keys -t "$diff_pane" -l "hunk diff --watch"
  tmux send-keys -t "$diff_pane" C-m
  tmux send-keys -t "$ai_pane" -l "$ai"
  tmux send-keys -t "$ai_pane" C-m

  tmux select-pane -t "$editor_pane"
}

# Create a multi-pane swarm layout with the same command started in each pane (great for AI)
# Usage: tsl <pane_count> [<command>]
tsl() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tsl."; return 1; }
  [[ $1 == -h || $1 == --help ]] && { echo "Usage: tsl <pane_count> [<command>]"; return 0; }
  [[ -z $1 ]] && { echo "Usage: tsl <pane_count> [<command>]"; return 1; }

  local count="$1"
  local cmd="${2:-c}"
  local current_dir="${PWD}"
  local -a panes

  tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"

  panes+=("$TMUX_PANE")

  while (( ${#panes[@]} < count )); do
    local new_pane
    local split_target="${panes[-1]}"
    new_pane=$(tmux split-window -h -t "$split_target" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
  done

  tmux select-layout -t "${panes[0]}" tiled

  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" "$cmd" C-m
  done

  tmux select-pane -t "${panes[0]}"
}
