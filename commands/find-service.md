Find which service handles a specific feature, endpoint, function, or concept.

## Instructions

1. Take `$ARGUMENTS` as the search query (e.g., "template creation", "NATS routing", "embedding storage", "user auth", an API endpoint path, a function name, or an error message).

2. Search across all projects in `{{WORKSPACE_DIR}}`:
   - Search source code files (`.py`, `.go`, `.ts`, `.tsx`, `.js`) for the query
   - Search API route definitions (FastAPI routes, Gin routes)
   - Search NATS subject patterns
   - Search Dockerfile and K8s manifests if relevant

3. For each match, report:
   - **Project**: Which project
   - **File**: The file path
   - **Context**: The surrounding code showing how it's used
   - **Role**: Whether this project defines, consumes, or routes the feature

4. Organize results by relevance:
   - Primary implementor (the service that owns the feature)
   - Consumers (services that call or depend on it)
   - Configuration (Helm values, K8s manifests referencing it)

5. If the search is broad, suggest more specific queries to narrow down.
