Manually write or update a session diary entry. Note: logging also happens automatically (see CLAUDE.md), but you can use this skill to force a log entry or add a specific note.

## Repo Detection

All logs are centralized in:
```
{{KNOWLEDGE_DIR}}/sessions/<repo-name>/YYYY-MM-DD.md
```

Before writing, identify ALL repos touched in the current session:

1. Collect every file path read, created, modified, or deleted
2. For each path: if under `{{WORKSPACE_DIR}}/`, repo name = first directory component after it; otherwise `git rev-parse --show-toplevel` basename; fallback to parent dir name
3. Deduplicate into a set. Designate one as **primary** (most significant changes), rest as **secondary**
4. Create directories if they don't exist

## Instructions

### When invoked with arguments

If `$ARGUMENTS` is provided, treat it as a log entry to append to today's session file. Summarize it concisely and append under the appropriate section.

### When invoked without arguments

Review the current conversation so far and generate a summary entry capturing everything discussed. Append it to today's session file.

## Multi-Repo Workflow

When multiple repos are touched:

- **Primary entry**: Write the full log to the primary repo's session file. Include all repos in the Context line: `**Context**: my-app (primary), core-lib, api-server`
- **Cross-reference entries**: For each secondary repo, append a stub:

```markdown
## [HH:MM] <same topic>

> Cross-repo work — primary log in [`<primary-repo>`](../<primary-repo>/YYYY-MM-DD.md)

**Changes in this repo**:
- <1-3 bullets listing only what changed in THIS repo>

---
```

- **Index**: Add one row per repo per topic. Primary row gets full summary. Secondary rows: `<brief note> (primary: <primary-repo>)`

When only one repo is touched, write a single full entry as usual.

## Session file format

Each day gets one file: `YYYY-MM-DD.md`. **Append** new entries — never overwrite.

```markdown
# Session Log — YYYY-MM-DD

## [HH:MM] Topic

**Context**: Repo, language, key files involved

**Goal**: What we set out to do

**Explored**:
- Findings with file paths

**Changes**:
- What was modified, with paths

**Decisions**:
- What was decided and why

**Rejected alternatives**:
- What was dismissed and why

**Recommendations**:
- Ideas not yet acted on (seeds for future work)

**Open items**:
- Unresolved questions, blockers

---
```

## Index

After writing, update `{{KNOWLEDGE_DIR}}/sessions/INDEX.md`:

```markdown
| Date | Repo | Topic | Summary |
```

## Guidelines

- Write for a future reader with zero context
- Bullet points, concrete file paths, versions
- Capture rejected ideas — prevents duplicate exploration
- Omit sections that don't apply
