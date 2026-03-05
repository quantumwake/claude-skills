Generate or update project documentation. Scans the codebase and writes structured docs to a centralized location.

## Invocation

- `/docs` — full scan of current repo, update all applicable categories
- `/docs README` — update only README
- `/docs ARCHITECTURE` — update only that category
- `/docs <repo-name>` — target a specific repo in `{{WORKSPACE_DIR}}`
- `/docs --touched` — generate/update docs for ALL repos modified in the current session

## Output location

```
{{DOCS_DIR}}/<repo-name>/README.md
{{DOCS_DIR}}/<repo-name>/<CATEGORY>.md
{{DOCS_DIR}}/<repo-name>/.last-ref
```

## Workflow

### 1. Determine repo

- If `$ARGUMENTS` matches a directory in `{{WORKSPACE_DIR}}`, use that as the target repo
- Otherwise, use `git rev-parse --show-toplevel` to detect the current repo
- Extract `<repo-name>` as the directory basename

### 1b. Multi-repo mode (`--touched`)

When invoked with `--touched`:

1. Scan the conversation for file paths that were read, created, modified, or deleted
2. For each path: if under `{{WORKSPACE_DIR}}/`, repo name = first directory component after it; otherwise `git rev-parse --show-toplevel` basename; fallback to parent dir name
3. Deduplicate into a list of distinct repo names
4. Run the full docs workflow (steps 2-8) for each repo sequentially
5. Report a combined summary listing all repos and their updated doc files

### 2. Load existing docs

Read all `.md` files in `{{DOCS_DIR}}/<repo-name>/` to understand what's already documented. Preserve any content inside `<!-- manual -->...<!-- /manual -->` markers — these are user-maintained sections that must not be overwritten.

### 3. Check delta

- Read `{{DOCS_DIR}}/<repo-name>/.last-ref` if it exists (contains the git SHA of the last doc sync)
- Run `git log <last-ref>..HEAD --oneline` and `git diff <last-ref>..HEAD --stat` to understand what changed
- If `.last-ref` doesn't exist, treat this as a first run — do a full codebase scan

### 4. Analyze codebase

Scan the project to understand its structure:
- Entry points (main files, index files, app bootstrap)
- Package/module layout
- Configuration files (env, yaml, toml, json)
- Build system (Makefile, Dockerfile, package.json scripts, pyproject.toml)
- API definitions (routes, endpoints, handlers)
- Key source files and their responsibilities

### 5. Determine applicable categories

Generate docs for whichever categories apply to this project:

| Category | When to generate | Content |
|----------|-----------------|---------|
| `README.md` | Always | Overview, purpose, quickstart, project structure |
| `ARCHITECTURE.md` | Multiple packages/modules/services | System design, component relationships, data flow |
| `API.md` | HTTP route definitions found (FastAPI, Gin, Express, etc.) | Endpoints, request/response formats, auth |
| `BUILD.md` | Dockerfile, Makefile, or build config present | Build instructions, dependencies, environment setup |
| `DEPLOYMENT.md` | Helm charts, K8s manifests, infra configs found | Deployment process, environments, configuration |
| `GUIDELINES.md` | CONTRIBUTING.md, linter configs, style conventions found | Coding standards, contribution workflow, conventions |

If `$ARGUMENTS` names a specific category (e.g., `README`, `API`), only update that one.

### 6. Write docs

For each applicable category:
- If the file exists, update it — merge new findings with existing content
- Preserve `<!-- manual -->...<!-- /manual -->` blocks untouched
- If the file doesn't exist, create it from scratch
- Use clear markdown with headers, code blocks, and tables where appropriate
- Be specific — include actual file paths, command examples, and concrete details from the codebase

### 7. Write `.last-ref`

Store the current `HEAD` SHA:
```bash
git rev-parse HEAD > {{DOCS_DIR}}/<repo-name>/.last-ref
```

### 8. Report

Summarize what was created or updated:
```
Updated docs for <repo-name>:
  - README.md (created/updated)
  - ARCHITECTURE.md (created/updated)
  - ...
Location: {{DOCS_DIR}}/<repo-name>/
Delta: <N> commits since last sync
```

For multi-repo mode (`--touched`), report a combined summary:
```
Updated docs for 3 repos:

  alethic-ism-file-source:
    - README.md (created)
    - ARCHITECTURE.md (created)

  alethic-ism-core-go:
    - API.md (updated)

  alethic-ism-vault-api:
    - README.md (updated)
```

## Guidelines

- Write for developers who are new to the project
- Be concrete — reference actual files, functions, and commands
- Keep each doc focused on its category — don't duplicate content across files
- When updating, preserve the document's existing structure where possible
- Omit categories that genuinely don't apply — don't generate empty or speculative docs
