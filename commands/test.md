Run tests for the project in the current directory (or the project specified by $ARGUMENTS).

## Instructions

1. If `$ARGUMENTS` is provided, treat it as a project path/name or as test filter arguments:
   - If it matches a project name, cd to that project in `{{WORKSPACE_DIR}}`
   - If it looks like a test filter (e.g., `test_filter.py`, `-k test_base`), pass it to the test runner

2. Detect the test framework:
   - `go.mod` → Run `go test ./...` (use `-v` for verbose)
   - `pyproject.toml` or `setup.cfg` with pytest config → Run `pytest`
   - `requirements.txt` with pytest → Run `pytest`
   - `tests/` or `test/` directory with Python files → Run `pytest`
   - `package.json` with `test` script → Run `npm test`
   - `package.json` with vitest → Run `npx vitest run`

3. Special handling:
   - **Go projects with testcontainers**: Warn that Docker must be running
   - **Python projects**: Check if a virtualenv exists (`.venv/`) and activate it first
   - **React/Vite projects**: Use `vitest run` (not watch mode)

4. If tests fail:
   - Show the failing test names and error messages
   - Analyze the failures and suggest fixes
   - Distinguish between test bugs vs actual code bugs

5. Report a summary: total tests, passed, failed, skipped, and duration.
