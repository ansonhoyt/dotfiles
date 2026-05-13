#!/bin/bash
# PostToolUse hook for Edit/Write - runs shellcheck on edited shell files

FILE_PATH=$(jaq -r '.tool_input.file_path')

[[ -z "$FILE_PATH" ]] && exit 0
[[ -f "$FILE_PATH" ]] || exit 0

# Match shell files: *.sh, known names, or bash shebang (mirrors CI discovery)
case "$FILE_PATH" in
  *.sh) ;;
  *.bashrc|*.bash_profile|*.osx) ;;
  *)
    head -1 "$FILE_PATH" 2>/dev/null | grep -qE '^#!.*\bbash\b' || exit 0
    ;;
esac

OUTPUT=$(shellcheck "$FILE_PATH" 2>&1)
STATUS=$?

if [[ $STATUS -ne 0 ]]; then
  afplay /System/Library/Sounds/Purr.aiff &
  echo "$OUTPUT" >&2
  exit 2
fi
