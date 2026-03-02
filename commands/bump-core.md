Bump shared library dependency versions across consuming projects.

## Instructions

1. Parse `$ARGUMENTS` to determine:
   - Which library to bump (name or "all")
   - Target version: if specified, use that version
   - If no version specified, find the latest version from the source project's `pyproject.toml` or `go.mod`

2. Find the latest version by checking the source project under `{{WORKSPACE_DIR}}`.

3. Scan all projects under `{{WORKSPACE_DIR}}` and update version pins in:
   - `requirements.txt`: Update version pin lines
   - `pyproject.toml`: Update version pins in `[project.dependencies]`
   - `go.mod`: Update module version (then run `go mod tidy`)

4. Before making changes:
   - Show a summary of what will be changed (project, old version, new version, file)
   - Ask for confirmation before proceeding

5. After updating, list all modified files so the user can review and commit.
