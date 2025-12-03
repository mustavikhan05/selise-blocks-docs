# Project Setup - Complete Workflow

**Purpose:** One-time initial setup from blank project to ready-to-implement

**Read When:** Starting new Selise Blocks project

---

## Phase 0: Documentation Discovery (MANDATORY FIRST)

⚠️ **DO THIS BEFORE ANYTHING ELSE**

1. Call `list_sections()`
2. Call `get_documentation(['project-setup', 'schema-design-guide'])`
3. Read this document completely

✋ CHECKPOINT: Docs read? → YES = Proceed to Phase 1

---

## Phase 1: User Requirements (BEFORE AUTHENTICATION!)

⚠️ **CRITICAL: Ask for requirements BEFORE asking for credentials**

### 1.1: Create Tracking Files

```bash
touch FEATURELIST.md TASKS.md SCRATCHPAD.md CLOUD.md
```

### 1.2: Ask User Questions

**Initial Response Template:**
```
I'll help you build [what they asked for]. Let me understand your requirements to create the best solution for you.

Let me ask a few questions to ensure I build exactly what you need:
```

**🚨 CRITICAL: Multi-User Detection (Ask FIRST)**

1. **User Accounts**: "Will multiple people use this app with separate accounts?"
2. **Data Ownership**: "Should each user only see their own data?"
3. **Access Levels**: "Do you need different user types (admin, manager, regular user)?"
4. **User Management**: "Will there be user registration and login?"

**If ANY answer indicates multiple users → MULTI-USER APP**
- Note: "This is a multi-user app - I'll read additional recipes"
- Will need iam-business-mapping recipe

**Universal Questions (Always Ask):**
1. "What are the main features you need?"
2. "What information needs to be tracked?" (determines schemas)
3. "What would you like to name your project?"
4. "What's your GitHub username?"
5. "What would you like to name the repository?"

### 1.3: Document Requirements

Write all answers to FEATURELIST.md:
```markdown
# Feature List - [Project Name]

## Project Details
- Name: [from user]
- Description: [what app does]
- GitHub: [username/repo]

## Core Features
- Feature 1
- Feature 2
- Feature 3

## Multi-User Architecture
[Simple: IAM itemId directly | Complex: User schema with IAMUserId | Single: N/A]

## Data Models Needed
- Schema 1: [entity name] - [what data]
- Schema 2: [entity name] - [what data]
```

### 1.4: User Confirmation

Present summary and ask:
```
Based on our discussion, here's what I'll build for you:

**[App Name]**

Core Features:
• Feature 1 with details
• Feature 2 with details
• Feature 3 with details

Technical Approach:
• Modern responsive web application
• Secure authentication
• Real-time data updates
• Professional UI/UX

Shall I proceed with building this? (You can still request changes as we go)
```

✋ CHECKPOINT: User confirmed? → NO = Revise requirements, YES = Phase 2

---

## Phase 2: Authentication & Project Creation

### 2.1: Get Credentials

**Now** ask for credentials (after user confirmed):
- Email for Selise Cloud
- Password for Selise Cloud

### 2.2: Authenticate

```python
login(username="email", password="password")
```

### 2.3: Decision Point - New or Existing Project?

**Ask user:** "Is this a NEW project or adding to EXISTING Selise project?"

#### Option A: NEW Project

```python
# Create project
result = create_project(
    project_name="[from user]",
    repo_name="username/repo",
    repo_link="https://github.com/username/repo",
    repo_id="Any",
    is_production=False
)

# MANDATORY: Set application domain
set_application_domain(
    domain=result.domain,
    tenant_id=result.tenant_id,
    project_name="[from user]"
)
```

#### Option B: EXISTING Project

```python
# List projects
projects = get_projects()

# Show user list, ask which one
selected = [user chooses]

# Set domain
set_application_domain(
    domain=selected.domain,
    tenant_id=selected.tenant_id,
    project_name=selected.name
)
```

### 2.4: Document in CLOUD.md

```markdown
# Cloud Operations Log

## Project Created
- Date: [timestamp]
- Project: [name]
- Tenant ID: [id]
- Domain: [url]
```

✋ CHECKPOINT: Project created AND set_application_domain called? → YES = Phase 3

---

## Phase 3: Local Repository Setup

⚠️ **THIS IS MANDATORY - NOT OPTIONAL!**

**Why REQUIRED:**
- Cannot build frontend without it
- All React code lives here
- GraphQL client configured here
- Cannot run `bun run dev` without it

### 3.1: Check Blocks CLI

```python
check_blocks_cli()
```

### 3.2: Install if Needed

```python
# If not installed:
install_blocks_cli()
```

### 3.3: Create Local Repository

```python
create_local_repository(
    repository_name="[project name]"
)
```

### 3.4: Verify Setup

```bash
cd [project-name]
bun run dev
```

Should see dev server running.

✋ CHECKPOINT: Can run `bun run dev`? → YES = Phase 4

---

## Phase 4: Schema Planning

### 4.1: Read Schema Design Guide

```python
get_documentation(['schema-design-guide'])
```

### 4.2: Analyze Features → Schemas

For each feature in FEATURELIST.md:
- What data does it need?
- What fields?
- Multi-user: Add UserId field

**Example:**
```
Feature: Todo Management
→ Schema: TodoTask
  - Title (String, required)
  - Description (String)
  - Status (String, default: "pending")
  - DueDate (DateTime)
  - UserId (String, required)  # For multi-user
```

### 4.3: Document in CLOUD.md

```markdown
## Schemas Planned

### TodoTask
- Title: String (required, max 200)
- Description: String
- Status: String (default "pending")
- DueDate: DateTime
- UserId: String (required)

Auto-generated: ItemId, CreatedDate, ModifiedDate, CreatedBy, ModifiedBy, IsDeleted
```

### 4.4: User Schema Decision

**Ask:** "Do users need data beyond name/email from IAM?"

→ **NO**: Use IAM itemId directly (RECOMMENDED for simple apps)
  - No User schema needed
  - Use IAM itemId in business records (UserId = IAM itemId)

→ **YES**: Create User schema with IAMUserId field
  - User schema with IAMUserId reference
  - NEVER use email as foreign key

Read `iam-business-mapping` recipe for details.

### 4.5: Show User Schema Plan & Get Confirmation

**Present to user:**
```
I've documented the schema plan. Here are the entities I'll create:

**TodoTask Entity**
- Title (String): Task title
- Description (String): Task details
- Status (String): pending/completed
- DueDate (DateTime): Due date
- UserId (String): Reference to user who owns this task

Does this schema structure look good to you, or would you like any changes?
```

**Wait for user confirmation before creating schemas.**

### 4.6: Create Schemas via MCP

```python
# For each schema:
create_schema(
    schema_name="TodoTask",
    project_key="[tenant_id]"
)

# Get schema ID from response
schema_id = result.schema_id

# Update fields
update_schema_fields(
    schema_id=schema_id,
    fields=[
        {"name": "Title", "type": "String", "required": True},
        {"name": "Description", "type": "String"},
        {"name": "Status", "type": "String", "defaultValue": "pending"},
        {"name": "DueDate", "type": "DateTime"},
        {"name": "UserId", "type": "String", "required": True}
    ]
)

# Finalize
finalize_schema(schema_id=schema_id)

# Document in CLOUD.md
```

Update CLOUD.md:
```markdown
## Schema Created: TodoTask
- Date: [timestamp]
- Schema ID: [id]
- Status: Active
```

✋ CHECKPOINT: All schemas created and documented in CLOUD.md? → YES = Phase 5

---

## Phase 5: Implementation Preparation

Setup complete! Now ready for implementation.

### 5.1: Read Implementation Docs

```python
get_documentation([
    'graphql-crud',
    'react-query-patterns',
    'component-reusability-rules'
])
```

### 5.2: Update TASKS.md

Break features into tasks:
```markdown
# Implementation Tasks

## Todo Feature

### Backend Integration
- [ ] Create GraphQL queries (getTodoTasks)
- [ ] Create GraphQL mutations (insertTodoTask, updateTodoTask, deleteTodoTask)
- [ ] Create service layer
- [ ] Create React Query hooks

### UI Components
- [ ] Create todo list page with DataTable
- [ ] Create add/edit todo form with React Hook Form
- [ ] Add delete confirmation with ConfirmationModal
- [ ] Add to routing

### Testing
- [ ] Test CRUD operations
- [ ] Verify multi-user isolation (if applicable)

Docs to reference:
- graphql-crud.md
- react-query-patterns.md
```

### 5.3: Begin Implementation Loop

Return to CLAUDE.md → Implementation Loop

✋ CHECKPOINT: Ready to implement? → YES = Use CLAUDE.md loop for each task

---

## Multi-User App Decision Tree

```
Does the app have ANY of these characteristics?
├── Multiple user accounts with different data? ────────────────┐
├── Admin vs regular user access levels? ──────────────────────┤
├── Users should only see "their own" data? ───────────────────┤  YES → Multi-User App
├── Role-based permissions (admin, manager, user)? ────────────┤  READ: iam-business-mapping
├── User profiles or account management? ───────────────────────┤
├── Different UI based on user type? ──────────────────────────┘
│
NO → Single-User App (skip multi-user recipes)
```

**Multi-User App Keywords:**
- "users", "roles", "admin", "permissions", "accounts", "login"
- "only see their own", "different access", "user management"
- "manager can see", "admin controls", "user profiles"

---

## Available MCP Tools Reference

**Authentication:**
- `login` - Authenticate with Selise Cloud
- `get_auth_status` - Check authentication status

**Project Management:**
- `create_project` - Create new Selise Cloud project
- `get_projects` - List existing projects
- `set_application_domain` - MANDATORY after create_project
- `create_local_repository` - Create local dev environment
- `check_blocks_cli` - Check if CLI installed
- `install_blocks_cli` - Install CLI if needed

**Schema Management:**
- `create_schema` - Create new schema
- `list_schemas` - List all schemas
- `get_schema` - Get schema details
- `update_schema_fields` - Update schema fields
- `finalize_schema` - Finalize schema changes

**IAM (Multi-User Apps):**
- `list_roles` - List roles
- `create_role` - Create new role
- `list_permissions` - List permissions
- `create_permission` - Create new permission
- `set_role_permissions` - Assign permissions to role

**Other:**
- `activate_social_login` - Enable social auth
- `enable_email_mfa` - Enable email MFA
- `enable_authenticator_mfa` - Enable authenticator MFA
- `save_captcha_config` - Configure CAPTCHA
- `get_global_state` - Get current system state

---

**End of project-setup.md - Return to CLAUDE.md for implementation loop**
