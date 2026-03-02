Check dependency versions of shared libraries across all related projects.

## Instructions

1. Scan all project directories under `{{WORKSPACE_DIR}}` for dependency declarations:
   - **Python**: Search `requirements.txt`, `pyproject.toml`, and `setup.py` for shared library version pins
   - **Go**: Search `go.mod` for shared module version references

2. Build a table showing:
   | Project | Library | Version | File |

3. Highlight version mismatches — projects using older versions than the latest.

4. If `$ARGUMENTS` is provided, filter to check only that specific dependency.

5. Report:
   - The latest version found across all projects
   - Which projects are behind
   - Suggested update commands for each outdated project
