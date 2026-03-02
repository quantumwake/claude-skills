Show the architecture and dependency map of services in the workspace.

## Instructions

1. If `$ARGUMENTS` is provided, focus on that specific service and show its upstream/downstream dependencies. Otherwise show the full system overview.

2. For a **full system overview**, scan `{{WORKSPACE_DIR}}` and organize services into layers:
   - **Frontend Layer**: UI projects (React, Vue, etc.)
   - **API Layer**: API gateways and services
   - **Processing Layer**: Background workers, processors
   - **State Management Layer**: Message routing, state persistence
   - **Core Libraries**: Shared SDKs and packages
   - **Infrastructure**: Helm charts, K8s configs, CI/CD
   - **Storage & Data**: Databases, object storage, embeddings

3. For a **specific service** (`$ARGUMENTS`), show:
   - What it depends on (libraries, services it calls)
   - What depends on it (downstream consumers)
   - Its message bus subjects (publish/subscribe) if applicable
   - Its API endpoints (if applicable)
   - How messages flow through it

4. Show the communication patterns:
   - Message bus flow between services
   - HTTP/REST calls between services
   - Database access patterns
   - Shared library dependencies
