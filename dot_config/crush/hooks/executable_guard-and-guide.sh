#!/usr/bin/env bash
# Wrapper to run guard-and-guide with Crush's tool names.
# Crush uses lowercase tool names (bash, view, write, edit, multiedit)
# while guard-and-guide with --agent claude-code expects (Bash, Read, Write, Edit).
# This script maps Crush names to Claude Code names before passing stdin.
set -euo pipefail

if ! command -v guard-and-guide &>/dev/null; then
    echo "[guard-and-guide] WARNING: guard-and-guide not installed." >&2
    exit 0
fi

INPUT=$(cat)

MAPPED=$(echo "$INPUT" | jq -r '
  .tool_name as $name |
  ($name | {
    "bash": "Bash",
    "view": "Read",
    "write": "Write",
    "edit": "Edit",
    "multiedit": "Edit"
  }[.] // $name) as $mapped |
  .tool_name = $mapped
')

echo "$MAPPED" | guard-and-guide --agent claude-code