# Claude Skills

Portable [Claude Code](https://docs.anthropic.com/en/docs/claude-code) slash commands that work across machines.

## Quick Setup

```bash
git clone <your-repo-url> ~/claude-skills
cd ~/claude-skills
chmod +x install.sh
./install.sh
```

The installer will prompt you for two paths:

| Variable | What it is | Example |
|----------|-----------|---------|
| `SESSION_DIR` | Where `/log` writes session diaries | `~/docs/sessions` |
| `WORKSPACE_DIR` | Root directory containing your projects | `~/Development/myorg` |

These are saved to `.env` (gitignored) so re-running the installer is instant.

## What Gets Installed

Commands are copied to `~/.claude/commands/` with your paths substituted in:

| Command | Description |
|---------|-------------|
| `/log` | Write session diary entries (auto or manual) |
| `/ship` | Stage, commit, push, and version bump |
| `/build` | Auto-detect and build any project (Go, Python, Node) |
| `/test` | Auto-detect and run tests (go test, pytest, vitest) |
| `/docker-build` | Build Docker images with common patterns |
| `/dep-check` | Check shared library versions across projects |
| `/bump-core` | Bump shared library versions across consumers |
| `/find-service` | Search which service handles a feature |
| `/service-map` | Show architecture and dependency map |

The installer also optionally appends session logging instructions to `~/.claude/CLAUDE.md`, which makes Claude automatically log as it works (not just when you run `/log`).

## Updating

After pulling new changes:

```bash
cd ~/claude-skills
./install.sh
```

Only changed commands are overwritten. Unchanged ones are skipped.

## Uninstalling

```bash
cd ~/claude-skills
./uninstall.sh
```

Removes installed commands from `~/.claude/commands/`. Does not touch `CLAUDE.md`.

## Customizing

**Add a new command:** Create a `.md` file in `commands/`. Use `{{SESSION_DIR}}` and `{{WORKSPACE_DIR}}` as placeholders — they're replaced during install.

**Edit an existing command:** Modify the file in `commands/`, then re-run `./install.sh`.

**Machine-specific paths:** Each machine gets its own `.env` (gitignored). Same commands, different paths.

## Structure

```
claude-skills/
├── commands/           # Slash command templates
│   ├── log.md          # /log - session diary
│   ├── build.md        # /build - project builder
│   ├── ship.md         # /ship - commit & push
│   ├── test.md         # /test - test runner
│   ├── docker-build.md # /docker-build
│   ├── dep-check.md    # /dep-check
│   ├── bump-core.md    # /bump-core
│   ├── find-service.md # /find-service
│   └── service-map.md  # /service-map
├── templates/
│   └── CLAUDE.md       # Session logging instructions for ~/.claude/CLAUDE.md
├── install.sh          # Install commands to ~/.claude/commands/
├── uninstall.sh        # Remove installed commands
├── .env.example        # Template for machine-specific paths
└── .env                # Your local paths (gitignored)
```
