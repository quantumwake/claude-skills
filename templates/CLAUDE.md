# Session Logging

Automatically maintain a session diary as you work. This is not optional — it's part of how you operate.

## When to log

Write a diary entry whenever:
- You finish exploring or investigating something
- You make code changes, config changes, or architectural decisions
- Something is decided, rejected, or left open
- A meaningful chunk of work is completed (don't wait until the end)

Do NOT wait for the user to ask. Log as you go — multiple entries per session are expected.

## Where to log

All session logs go to a central docs repo, organized by repo name:

```
{{KNOWLEDGE_DIR}}/sessions/<repo-name>/YYYY-MM-DD.md
```

### Repo detection

Before writing a log entry, identify ALL repos touched since the last log:

1. Collect every file path read, created, modified, or deleted in this work chunk
2. For each path: if under `{{WORKSPACE_DIR}}/`, repo name = first directory component after it; otherwise `git rev-parse --show-toplevel` basename; fallback to parent dir name
3. Deduplicate into a set. Designate one as **primary** (most significant changes), rest as **secondary**

### Single-repo work (most common)

Write to `{{KNOWLEDGE_DIR}}/sessions/<repo>/YYYY-MM-DD.md` as usual:

1. Create the directory if it doesn't exist
2. **Append** to the file if it already exists — never overwrite

### Multi-repo work

Full entry → primary repo's session file. For each secondary repo, append a cross-reference stub:

```markdown
## [HH:MM] <same topic>

> Cross-repo work — primary log in [`<primary-repo>`](../<primary-repo>/YYYY-MM-DD.md)

**Changes in this repo**:
- <1-3 bullets listing only what changed in THIS repo>

---
```

## Entry format

```markdown
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
- What was dismissed and why (prevents future agents from re-exploring dead ends)

**Recommendations**:
- Ideas not yet acted on (seeds for future work)

**Open items**:
- Unresolved questions, blockers

---
```

## Index

After writing an entry, update `{{KNOWLEDGE_DIR}}/sessions/INDEX.md` with a one-line summary row:

```markdown
| Date | Repo | Topic | Summary |
```

For multi-repo work, add one row per repo. Primary row gets full summary. Secondary rows: `<brief note> (primary: <primary-repo>)`

This is the global index across all repos — one place to see everything.

## Guidelines

- Write for a future reader (human or agent) with zero context
- Bullet points over paragraphs — keep it scannable
- Use concrete file paths, versions, commit hashes
- Capture rejected ideas and reasoning — that's the most valuable part
- Omit sections that don't apply (e.g., skip "Changes" if nothing was modified)
- Don't log trivial exchanges (greetings, typo fixes, quick questions)
- Working across repos → full entry under primary repo, cross-reference stubs under each secondary repo
- Cross-reference stubs should list only what changed in THAT repo, not the full story
