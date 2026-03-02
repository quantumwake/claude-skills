Stage, commit, push, and version bump the current project.

## Instructions

Follow these steps in order. Do NOT add any "Co-Authored-By" lines to commit messages.

### Step 1: Show changed files

Run `git status` to see all modified, added, and untracked files. Present them to the user using AskUserQuestion with `multiSelect: true` so they can pick which files to stage. Group them clearly:
- Modified files
- New/untracked files
- Deleted files

### Step 2: Stage selected files

Run `git add` for each file the user selected. If the user picks "All files", run `git add .`.

### Step 3: Generate commit message

Run `git diff --cached` on the staged changes. Read and analyze the diff to understand what changed. Write a concise, meaningful commit message that summarizes the **why** and **what** — not a line-by-line description. Keep it to 1-3 sentences.

Show the proposed commit message to the user and let them approve or edit it.

### Step 4: Commit

Commit with the approved message. Do NOT append any co-author lines, trailers, or signatures.

```
git commit -m "<message>"
```

### Step 5: Push

Push to the current remote tracking branch:
```
git push
```

If there's no upstream branch set, use `git push -u origin <current-branch>`.

### Step 6: Version bump

Run `make version` to bump the patch version, create the git tag, and push the tag.

If `make version` fails (e.g., no Makefile or no version target), inform the user and skip this step — the commit and push are already done.

## Notes

- If `$ARGUMENTS` is provided, use it as the commit message directly and skip the message generation/approval step (still show the diff summary for context).
- If the working tree is clean (no changes), say so and stop.
- Never add Co-Authored-By or any other trailers to commits.
