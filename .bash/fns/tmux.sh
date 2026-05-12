
# Create a tmux layout for dev with editor, ai, and terminal
tml() {
  local current_dir="${PWD}"
  local editor_pane ai_pane
  local ai="${1:-claude}"

  tmux rename-window "$(basename "$current_dir")"

  # Get current pane ID (will become editor pane after splits)
  editor_pane=$(tmux display-message -p '#{pane_id}')

  # Split window vertically - top 90%, bottom 10%
  tmux split-window -v -p 10 -c "$current_dir"

  # Go back to top pane (editor_pane) and split it horizontally
  tmux select-pane -t "$editor_pane"
  tmux split-window -h -p 40 -c "$current_dir"

  # After horizontal split, cursor is in the right pane (new pane)
  # Get its ID and run ai there
  ai_pane=$(tmux display-message -p '#{pane_id}')
  tmux send-keys -t "$ai_pane" "$ai" C-m

  # Run nvim in the left pane
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m

  # Select the nvim pane for focus
  tmux select-pane -t "$editor_pane"
}

