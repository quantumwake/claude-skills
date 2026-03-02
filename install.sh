#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
ENV_FILE="$SCRIPT_DIR/.env"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[info]${NC}  $1"; }
ok()    { echo -e "${GREEN}[ok]${NC}    $1"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $1"; }
err()   { echo -e "${RED}[error]${NC} $1"; }

echo ""
echo "  Claude Skills Installer"
echo "  ========================"
echo ""

# --- Step 1: Load or create .env ---

if [[ ! -f "$ENV_FILE" ]]; then
    info "No .env file found. Let's configure your paths."
    echo ""

    # Session directory
    read -rp "  Session log directory (e.g., /home/you/docs/sessions): " SESSION_DIR
    while [[ -z "$SESSION_DIR" ]]; do
        echo "  Session directory is required (this is where /log writes diary entries)."
        read -rp "  Session log directory: " SESSION_DIR
    done
    # Expand ~ if used
    SESSION_DIR="${SESSION_DIR/#\~/$HOME}"

    # Workspace directory
    read -rp "  Workspace directory (e.g., /home/you/Development/myorg): " WORKSPACE_DIR
    if [[ -z "$WORKSPACE_DIR" ]]; then
        WORKSPACE_DIR="$HOME/Development"
        warn "Defaulting workspace to $WORKSPACE_DIR"
    fi
    WORKSPACE_DIR="${WORKSPACE_DIR/#\~/$HOME}"

    # Write .env
    cat > "$ENV_FILE" <<EOF
SESSION_DIR=$SESSION_DIR
WORKSPACE_DIR=$WORKSPACE_DIR
EOF
    ok "Created .env with your paths"
    echo ""
else
    info "Loading existing .env"
fi

# shellcheck source=/dev/null
source "$ENV_FILE"

# Validate required vars
if [[ -z "${SESSION_DIR:-}" ]]; then
    err "SESSION_DIR is not set in .env"
    exit 1
fi

if [[ -z "${WORKSPACE_DIR:-}" ]]; then
    err "WORKSPACE_DIR is not set in .env"
    exit 1
fi

info "SESSION_DIR   = $SESSION_DIR"
info "WORKSPACE_DIR = $WORKSPACE_DIR"
echo ""

# --- Step 2: Create session directory if needed ---

if [[ ! -d "$SESSION_DIR" ]]; then
    mkdir -p "$SESSION_DIR"
    ok "Created session directory: $SESSION_DIR"
fi

# --- Step 3: Install commands ---

mkdir -p "$COMMANDS_DIR"

installed=0
skipped=0

for src in "$SCRIPT_DIR/commands/"*.md; do
    [[ -f "$src" ]] || continue
    name="$(basename "$src")"
    dest="$COMMANDS_DIR/$name"

    # Process template variables
    processed=$(sed \
        -e "s|{{SESSION_DIR}}|$SESSION_DIR|g" \
        -e "s|{{WORKSPACE_DIR}}|$WORKSPACE_DIR|g" \
        "$src")

    # Check if destination exists and is different
    if [[ -f "$dest" ]]; then
        existing=$(cat "$dest")
        if [[ "$processed" == "$existing" ]]; then
            ((skipped++))
            continue
        fi
        warn "Overwriting existing command: $name"
    fi

    echo "$processed" > "$dest"
    ok "Installed $name"
    ((installed++))
done

echo ""
info "Commands: $installed installed, $skipped unchanged"

# --- Step 4: Install CLAUDE.md (session logging instructions) ---

echo ""
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

install_claude_md() {
    local processed
    processed=$(sed \
        -e "s|{{SESSION_DIR}}|$SESSION_DIR|g" \
        -e "s|{{WORKSPACE_DIR}}|$WORKSPACE_DIR|g" \
        "$SCRIPT_DIR/templates/CLAUDE.md")

    if [[ -f "$CLAUDE_MD" ]]; then
        # Check if our session logging section already exists
        if grep -q "# Session Logging" "$CLAUDE_MD" 2>/dev/null; then
            info "CLAUDE.md already contains session logging instructions — skipping"
            info "To update, remove the '# Session Logging' section from $CLAUDE_MD and re-run install"
            return
        fi

        # Append to existing CLAUDE.md
        echo "" >> "$CLAUDE_MD"
        echo "$processed" >> "$CLAUDE_MD"
        ok "Appended session logging instructions to existing CLAUDE.md"
    else
        echo "$processed" > "$CLAUDE_MD"
        ok "Created CLAUDE.md with session logging instructions"
    fi
}

read -rp "  Install session logging instructions to ~/.claude/CLAUDE.md? [Y/n] " yn
case "${yn:-Y}" in
    [Yy]*|"") install_claude_md ;;
    *) info "Skipped CLAUDE.md installation" ;;
esac

# --- Step 5: Create session index if needed ---

INDEX_FILE="$SESSION_DIR/INDEX.md"
if [[ ! -f "$INDEX_FILE" ]]; then
    cat > "$INDEX_FILE" <<'EOF'
# Session Index

| Date | Repo | Topic | Summary |
|------|------|-------|---------|
EOF
    ok "Created session index at $INDEX_FILE"
fi

# --- Done ---

echo ""
echo "  ========================"
echo -e "  ${GREEN}Installation complete!${NC}"
echo ""
echo "  Available commands:"
for src in "$SCRIPT_DIR/commands/"*.md; do
    [[ -f "$src" ]] || continue
    name="$(basename "$src" .md)"
    desc=$(head -1 "$src")
    echo "    /$name  —  $desc"
done
echo ""
echo "  Run 'claude' and use /log, /build, /test, /ship, etc."
echo ""
