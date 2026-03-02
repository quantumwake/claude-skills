Build a Docker image for the project in the current directory (or the project specified by $ARGUMENTS).

## Instructions

1. If `$ARGUMENTS` is provided, treat it as a project path/name. Look for the project in the current directory, parent directory, or `{{WORKSPACE_DIR}}`.

2. Find the Dockerfile:
   - Check for `Dockerfile` in the project root
   - Check for `Dockerfile` in `bootstrap/` or `build/` subdirectories
   - If multiple Dockerfiles exist, list them and ask which to use

3. Determine the image name:
   - Use the project directory name (e.g., `my-service`)
   - Tag with `local-dev` by default unless a specific tag is provided in arguments

4. Run the Docker build:
   ```
   docker build -t <image-name>:local-dev -f <Dockerfile-path> .
   ```

5. Common patterns:
   - **Python services**: Python 3.12 Alpine with UV package manager
   - **Go services**: Multi-stage builds (builder + distroless/alpine)
   - **React UIs**: Node 20 Alpine build stage + Nginx serving stage, with build args for environment (`BUILD_TARGET`)

6. If the build fails:
   - Check if there are build args needed (e.g., `BUILD_TARGET=dev` for UI projects)
   - Check if local dependencies need to be built first
   - Report the error with suggested fixes

7. After success, report the image name, tag, and size.
