Manually write or update a session diary entry. Note: logging also happens automatically (see CLAUDE.md), but you can use this skill to force a log entry or add a specific note.

## Location

All logs are centralized in:
```
{{KNOWLEDGE_DIR}}/sessions/<repo-name>/YYYY-MM-DD.md
```

Determine `<repo-name>` from `git rev-parse --show-toplevel` (just the directory name). Create the directory if it doesn't exist.

## Instructions

### When invoked with arguments

If `$ARGUMENTS` is provided, treat it as a log entry to append to today's session file. Summarize it concisely and append under the appropriate section.

### When invoked without arguments

Review the current conversation so far and generate a summary entry capturing everything discussed. Append it to today's session file.

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
