#!/bin/bash
# PostToolUse hook for Edit/Write - runs markdownlint on edited markdown files

FILE_PATH=$(jaq -r '.tool_input.file_path')

# Exit if no file path
[[ -z "$FILE_PATH" ]] && exit 0

# Only process markdown files
if [[ ! "$FILE_PATH" =~ \.(md|markdown)$ ]]; then
  exit 0
fi

# Get file modification time before linting
BEFORE_MTIME=$(stat -f %m "$FILE_PATH" 2>/dev/null)

# Run markdownlint (project configs override --config automatically)
npx markdownlint-cli2 --config ~/.claude/.markdownlint.jsonc --fix "$FILE_PATH" >/dev/null 2>&1

# Get file modification time after linting
AFTER_MTIME=$(stat -f %m "$FILE_PATH" 2>/dev/null)

# Play sound (in background) if file was modified
if [[ "$BEFORE_MTIME" != "$AFTER_MTIME" ]]; then
  afplay /System/Library/Sounds/Purr.aiff &
fi
