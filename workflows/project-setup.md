# Project Setup Workflow (MCP-First)

## Vibecoding Experience Flow (MUST FOLLOW IN ORDER)

**When User Wants to Create Any Webapp/Website:**

### 1. FIRST: Read Documentation (Before talking to user)
- Read `workflows/user-interaction.md`
- Read `workflows/feature-planning.md`
- Read `agent-instructions/selise-development-agent.md`

### 2. User Interaction & Requirements Gathering
- Follow patterns from `user-interaction.md`
- Create tracking files: `FEATURELIST.md`, `TASKS.md`, `SCRATCHPAD.md`, `CLOUD.md`
- Ask clarifying questions about features
- Document everything in FEATURELIST.md
- Create tasks.md
- Get user confirmation before proceeding

### 3. Project Setup (After user confirms features)

**Get project name from user**

**Authentication Flow** (Ask one by one if NOT IN user-info.txt):
```
- Username/email for Selise Blocks
- Password for Selise Blocks
- GitHub username
- GitHub repository name to connect
```

**Project Creation Flow:**
```python
# ALWAYS create new project - don't look for existing domains
create_project(
    project_name="UserProvidedName",
    github_username="from_step_1",
    repository_name="from_step_1"
)

# If user wants local setup:
create_local_repository(project_name="UserProvidedName")
```

### 4. Feature Planning & Schema Design (AFTER user confirmation)

- Read `workflows/feature-planning.md` again in full
- **IF MULTI-USER APP**: Read `iam-to-business-data-mapping.md` and `permissions-and-roles.md`
- Break down confirmed features into technical requirements in Tasks.md
- Analyze what schemas are needed based on FEATURELIST.md
- **For multi-user apps**: Plan business record bridging and user data isolation
- Document schema plan in CLOUD.md and ask the user if they are okay if not keep talking to the user to confirm the schemas

**Create schemas using MCP:**
```python
# For each entity the app needs:
create_schema(
    schema_name="Tasks",
    fields=[
        {"name": "title", "type": "String", "required": True},
        {"name": "status", "type": "String", "required": True}
    ]
)
```

- Document all MCP operations and results in CLOUD.md
- **CONTINUE TO STEP 5 BELOW** - Do not stop here!
- Move to the next steps as listed here, follow this strictly
- **After schemas are created, proceed immediately to Implementation Process (Step 5)**

## Multi-User App Decision Tree

```
Does the app have ANY of these characteristics?
├── Multiple user accounts with different data? ────────────────┐
├── Admin vs regular user access levels? ──────────────────────┤
├── Users should only see "their own" data? ───────────────────┤  YES → Multi-User App
├── Role-based permissions (admin, manager, user)? ────────────┤  READ: iam-to-business + permissions recipes
├── User profiles or account management? ───────────────────────┤
├── Different UI based on user type? ──────────────────────────┘
│
NO → Single-User App (skip multi-user recipes)
```

**Multi-User App Keywords to Watch For:**
- "users", "roles", "admin", "permissions", "accounts", "login", "authentication"
- "only see their own", "different access", "user management", "multi-tenant"
- "manager can see", "admin controls", "user profiles", "role-based"

## Available MCP Tools

**Authentication (Required First):**
- `login`: Authenticate with Selise Blocks API (ask for username, password, GitHub username, repo name)
- `get_auth_status`: Check authentication status

**Project Management:**
- `create_project`: Create new Selise Cloud project (ALWAYS use for new projects)
- `get_projects`: List existing projects
- `create_local_repository`: Create local repository after cloud project

**Schema Management:**
- `create_schema`: Create new schemas in Selise Cloud
- `list_schemas`: List all schemas
- `get_schema_details`: Get schema field information
- `update_schema_fields`: Update existing schema fields
- `finalize_schema`: Finalize schema changes

**Other Tools:**
- `activate_social_login`: Enable social authentication
- `get_authentication_config`: Check auth configuration
- `get_global_state`: Get current system state
