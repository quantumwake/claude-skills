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

1. Determine the current repo name from `git rev-parse --show-toplevel` (just the directory name, e.g., `my-project`)
2. If not in a git repo, use the current directory name
3. Write to `{{KNOWLEDGE_DIR}}/sessions/<repo-name>/YYYY-MM-DD.md`
4. Create the directory if it doesn't exist
5. **Append** to the file if it already exists — never overwrite

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

This is the global index across all repos — one place to see everything.

## Guidelines

- Write for a future reader (human or agent) with zero context
- Bullet points over paragraphs — keep it scannable
- Use concrete file paths, versions, commit hashes
- Capture rejected ideas and reasoning — that's the most valuable part
- Omit sections that don't apply (e.g., skip "Changes" if nothing was modified)
- Don't log trivial exchanges (greetings, typo fixes, quick questions)
