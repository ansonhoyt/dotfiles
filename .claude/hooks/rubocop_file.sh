#!/bin/bash
# PostToolUse hook for Edit/Write - runs rubocop on edited file only

FILE_PATH=$(jaq -r '.tool_input.file_path')

# Exit if no file path
[[ -z "$FILE_PATH" ]] && exit 0

# Run rubocop on the edited file
OUTPUT=$(rubocop --autocorrect-all --enable-pending-cops --only-recognized-file-types "$FILE_PATH" 2>&1)

# Play sound only if rubocop made corrections
if echo "$OUTPUT" | grep -q "corrected"; then
  afplay /System/Library/Sounds/Purr.aiff
fi
