#!/bin/bash
# Claude Code statusLine script
# Displays: current_dir (git_branch) | model_name

# Read JSON input from stdin
input=$(cat)

# Extract values using jq
model=$(echo "$input" | jq -r '.model.display_name')
dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir')")

# Git branch (if in a git repo)
if git rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    git_info="  $branch"
  fi
fi

# Output with green color for directory
printf "\033[0;32m%s\033[0m%s | %s" "$dir" "$git_info" "$model"
