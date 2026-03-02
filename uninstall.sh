#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "  Claude Skills Uninstaller"
echo "  ========================="
echo ""

removed=0

for src in "$SCRIPT_DIR/commands/"*.md; do
    [[ -f "$src" ]] || continue
    name="$(basename "$src")"
    dest="$COMMANDS_DIR/$name"

    if [[ -f "$dest" ]]; then
        rm "$dest"
        echo -e "  ${GREEN}[removed]${NC} $name"
        ((removed++))
    fi
done

echo ""
echo -e "  Removed $removed command(s) from $COMMANDS_DIR"
echo ""
echo -e "  ${YELLOW}Note:${NC} CLAUDE.md was not modified. Remove the '# Session Logging'"
echo "  section from ~/.claude/CLAUDE.md manually if desired."
echo ""
