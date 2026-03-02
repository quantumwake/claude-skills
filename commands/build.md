Build the project in the current directory (or the project specified by $ARGUMENTS).

## Instructions

1. Detect the project type by checking for these files in order:
   - `go.mod` → Go project
   - `pyproject.toml` → Python project (use `uv build` if uv.lock exists, otherwise `pip install -e .`)
   - `setup.py` → Python project (use `pip install -e .`)
   - `requirements.txt` → Python project (use `pip install -r requirements.txt`)
   - `package.json` → Node/TypeScript project (use `npm install && npm run build`)

2. If `$ARGUMENTS` is provided, treat it as a project path or name:
   - If it's a full path, use it directly
   - If it's a project name, look for it in the parent directory or in `{{WORKSPACE_DIR}}`

3. Run the appropriate build command and report the result.

4. If the build fails, analyze the error and suggest fixes. Common issues:
   - Missing dependencies (suggest install commands)
   - Version conflicts
   - Missing environment variables
   - Go module issues (suggest `go mod tidy`)

5. After a successful build, briefly confirm what was built and any artifacts produced.
