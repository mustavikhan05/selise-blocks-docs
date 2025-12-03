# FINAL Implementation Plan: Selise Blocks Documentation Fix

**Date:** 2025-12-04
**Goal:** Fix ALL 55+ issues and create smooth, self-enforcing agent workflow
**Approach:** Hybrid - Tight enforcement + Rich metadata + Specific fixes

---

## Executive Summary

**What We're Doing:**
1. Tight CLAUDE.md (60-70 lines) with blocking checkpoints
2. Rich topics.json metadata (use_cases, triggers, warnings)
3. Merge conflicting workflows into single project-setup.md
4. Fix all 55+ specific technical issues from test
5. Create 3 missing critical recipes
6. Add validation scripts

**Why This Works:**
- Agent reads tight CLAUDE.md every time (not skips)
- Rich metadata makes list_sections useful
- No workflow conflicts (single source of truth)
- Blocking checkpoints enforce tracking files
- Specific fixes prevent all test issues

---

## Part 1: CLAUDE.md Structure (60-70 lines)

**Location:** `/CLAUDE.md`

**Purpose:** Entry point + enforcement + loop + quick reference

### Content:

```markdown
# Selise Blocks - Official MCP Server

This MCP provides documentation + 33 Cloud API tools for Selise Blocks development.

## 🚀 START HERE

**First Time Setup:**
1. Call `mcp__selise__list_sections()`
2. Call `mcp__selise__get_documentation(['project-setup'])`
3. Follow project-setup.md (Phases 0-5)
4. When setup done → Implementation Loop below

---

## 🔁 IMPLEMENTATION LOOP (For Each Task)

### STEP 1: PLAN (BLOCKING)
```bash
# Fetch relevant docs
list_sections → analyze use_cases/triggers
get_documentation([relevant topics])

# Plan task in TASKS.md
echo "## [Task Name]" >> TASKS.md
echo "- [ ] Sub-task 1" >> TASKS.md
echo "- Docs: [list what you read]" >> TASKS.md
```
✋ CHECKPOINT: Task planned in TASKS.md? → NO = STOP, GO BACK

### STEP 2: IMPLEMENT
- Follow recipes from fetched docs
- Reference components from list_sections
- Use Critical Gotchas checklist below
- Update SCRATCHPAD.md as you discover issues/patterns

### STEP 3: DOCUMENT (BLOCKING)
```bash
# Mark task done
sed -i '' 's/\[ \]/\[x\]/' TASKS.md  # Mark subtasks done

# Document learnings
echo "---" >> SCRATCHPAD.md
echo "[$(date)] Completed: [Task Name]" >> SCRATCHPAD.md
echo "- Issue found: [if any]" >> SCRATCHPAD.md
echo "- Solution: [how fixed]" >> SCRATCHPAD.md
```
✋ CHECKPOINT: TASKS.md + SCRATCHPAD.md updated? → NO = STOP, GO BACK

### STEP 4: COMMIT
```bash
git add TASKS.md SCRATCHPAD.md [code files]
git commit -m "Task: [name] - [summary]

Completed: [subtasks]
Issues resolved: [if any]"
```

### STEP 5: NEXT TASK → Go to STEP 1

---

## 🔥 CRITICAL GOTCHAS CHECKLIST

### GraphQL (ALWAYS CHECK)
- [ ] Query uses lowercase "get" prefix: `getTodoTasks` NOT `TodoTasks`
- [ ] Mutation format: `insertTodoTask` NOT `createTodoTask`
- [ ] DateTime in ISO format: `new Date().toISOString()`
- [ ] Pagination 1-based: `pageNo: 1` for first page NOT `0`
- [ ] Filter uses `_id` NOT `ItemId`: `filter: { _id: item.ItemId }`
- [ ] Response extraction: `result.data?.getTodoTasks || result.getTodoTasks`

### Imports & Structure (ALWAYS CHECK)
- [ ] ALL imports use `@/` prefix: `@/components/ui-kit/button`
- [ ] Folder: `src/modules/[name]/component/` (singular!)
- [ ] GraphQL client: `@/lib/graphql-client`
- [ ] NO cross-module imports (modules/inventory is reference-only)

### Components (WHEN BUILDING UI)
- [ ] Use DataTable from `@/components/core/data-table`
- [ ] Use ConfirmationModal from `@/components/core/confirmation-modal`
- [ ] Forms use React Hook Form + Zod validation
- [ ] Check list_sections for component availability

### Multi-User Apps (IF APPLICABLE)
- [ ] Simple app: Use IAM itemId directly (no User schema)
- [ ] Complex app: User schema with IAMUserId field (NOT email)

---

## 🚫 NEVER DO

- Skip list_sections before starting task
- Skip updating TASKS.md and SCRATCHPAD.md
- Use uppercase "Get" in queries
- Use ItemId in GraphQL filters
- Import from other modules
- Use email for user lookups

---

## 📖 CONTENT TYPES

**Workflows** (when to read):
- project-setup → Initial setup (Phases 0-5)
- implementation-checklist → Reference during implementation

**Recipes** (fetch as needed):
- graphql-crud → ALWAYS (for data operations)
- react-query-patterns → When creating hooks
- react-hook-form → When building forms
- confirmation-modal → When adding delete confirmations
- iam-business-mapping → Multi-user apps
- schema-design-guide → Before creating schemas
- component-reusability → Before importing components

**Components** (reference only):
- core/* → Available to import (DataTable, ConfirmationModal, etc.)
- ui-kit/* → Available to import (Button, Input, Form, etc.)
- Check list_sections for full catalog

---

## 🔧 TRACKING FILES

- **FEATURELIST.md** - Requirements (update when user changes mind)
- **TASKS.md** - Task breakdown (update EVERY task)
- **SCRATCHPAD.md** - Learnings/issues (update EVERY task)
- **CLOUD.md** - MCP operations (update during setup)

**Rule:** NEVER commit code without updating TASKS.md and SCRATCHPAD.md

---

## 📞 MCP TOOLS AVAILABLE

- `list_sections()` - Discover all topics with metadata
- `get_documentation(topics)` - Fetch specific docs
- 33 Selise Cloud API tools (auth, schemas, IAM, etc.)

**Remember:** ALWAYS call list_sections before each task to find relevant docs/components

---

**End of CLAUDE.md**
```

**Validation:**
- ✅ 60-70 lines (readable)
- ✅ Loop with blocking checkpoints
- ✅ Gotchas checklist (15 items)
- ✅ NEVER DO list
- ✅ Content types explained (workflows, recipes, components)
- ✅ Tracking files enforced

---

## Part 2: topics.json Rich Metadata

**Location:** `/topics.json`

### Changes to Existing Topics

**graphql-crud:**
```json
{
  "id": "graphql-crud",
  "title": "GraphQL CRUD Operations",
  "category": "recipes",
  "priority": "critical",
  "read_order": 5,
  "use_cases": "data,graphql,queries,mutations,crud,errors,debugging,always",
  "triggers": [
    "implementing data operations",
    "GraphQL errors",
    "query not working",
    "field does not exist",
    "unexpected execution error"
  ],
  "warnings": [
    "CRITICAL: Use lowercase 'get' prefix (getTodoTasks NOT TodoTasks)",
    "DateTime must be ISO format: new Date().toISOString()",
    "Pagination is 1-based (pageNo: 1 for first page)",
    "Filter uses _id NOT ItemId",
    "Response needs extraction: result.data?.X || result.X"
  ],
  "file_path": "recipes/graphql-crud.md"
}
```

**react-query-patterns (NEW):**
```json
{
  "id": "react-query-patterns",
  "title": "React Query Hooks Patterns",
  "category": "recipes",
  "priority": "critical",
  "read_order": 6,
  "use_cases": "hooks,react-query,data-fetching,mutations,caching,always",
  "triggers": [
    "creating hooks",
    "implementing queries",
    "implementing mutations",
    "query invalidation"
  ],
  "warnings": [
    "MUST use useGlobalQuery and useGlobalMutation wrappers",
    "Include userId in queryKey for multi-user data isolation"
  ],
  "file_path": "recipes/react-query-patterns.md"
}
```

**schema-design-guide (NEW):**
```json
{
  "id": "schema-design-guide",
  "title": "Schema Design Guide",
  "category": "recipes",
  "priority": "critical",
  "read_order": 3,
  "use_cases": "schemas,database,mongodb,nosql,data-modeling,always",
  "triggers": [
    "before creating schemas",
    "planning data model",
    "designing fields"
  ],
  "warnings": [
    "Auto-generated fields: ItemId, CreatedDate, etc. - DO NOT add manually",
    "Use PascalCase for schema fields",
    "Use _id for MongoDB filtering (NOT ItemId)"
  ],
  "file_path": "recipes/schema-design-guide.md"
}
```

**component-reusability-rules (NEW):**
```json
{
  "id": "component-reusability-rules",
  "title": "Component Import Rules",
  "category": "recipes",
  "priority": "high",
  "read_order": 7,
  "use_cases": "components,imports,architecture,modules,always",
  "triggers": [
    "before importing component",
    "cross-module import error",
    "component not found"
  ],
  "warnings": [
    "FORBIDDEN: Never import from other modules (modules/inventory/*)",
    "REQUIRED: Use @/ prefix for ALL imports"
  ],
  "file_path": "recipes/component-reusability-rules.md"
}
```

**iam-business-mapping:**
```json
{
  "id": "iam-business-mapping",
  "title": "IAM to Business Data Mapping",
  "category": "recipes",
  "priority": "high",
  "read_order": 8,
  "use_cases": "authentication,multi-user,iam,user-management",
  "triggers": [
    "multi-user app",
    "user authentication",
    "before creating User schema"
  ],
  "warnings": [
    "Simple apps: Use IAM itemId directly (NO User schema needed)",
    "Complex apps: User schema with IAMUserId field (NOT email)",
    "NEVER use email as foreign key (can change, performance issues)"
  ],
  "decision_tree": {
    "question": "Do users need data beyond name/email from IAM?",
    "no": "Use IAM itemId directly - no User schema",
    "yes": "Create User schema with IAMUserId reference"
  },
  "file_path": "recipes/iam-to-business-data-mapping.md"
}
```

**project-setup:**
```json
{
  "id": "project-setup",
  "title": "Project Setup - Complete Workflow",
  "category": "workflows",
  "priority": "critical",
  "read_order": 1,
  "use_cases": "setup,initialization,project-creation,always",
  "triggers": [
    "starting new project",
    "first time setup"
  ],
  "warnings": [
    "MUST create local repository (NOT optional)",
    "MUST call set_application_domain after create_project",
    "Ask for requirements BEFORE authentication"
  ],
  "phases": [
    "Phase 0: Documentation Discovery",
    "Phase 1: User Requirements",
    "Phase 2: Authentication & Project",
    "Phase 3: Local Repository",
    "Phase 4: Schema Planning",
    "Phase 5: Implementation Prep"
  ],
  "file_path": "workflows/project-setup.md"
}
```

**permissions-roles (FIXED):**
```json
{
  "id": "permissions-roles",
  "title": "Permissions and Roles",
  "category": "recipes",
  "priority": "medium",
  "read_order": 10,
  "use_cases": "rbac,permissions,roles,admin,access-control",
  "triggers": [
    "role-based access control needed",
    "admin panels",
    "permissions system"
  ],
  "warnings": [
    "NOT needed for simple multi-user apps (where all users equal)",
    "Only needed for role-based access control"
  ],
  "file_path": "recipes/permissions-and-roles.md"
}
```

**Component entries (ALL 59):**
```json
{
  "id": "data-table",
  "title": "Data Table Component",
  "category": "components",
  "subcategory": "core",
  "priority": "high",
  "use_cases": "tables,lists,pagination,data-display",
  "triggers": [
    "displaying list of items",
    "need pagination",
    "need sorting"
  ],
  "file_path": "components/core/data-table.md",
  "status": "reference_only",
  "note": "Documentation not yet available. See component code at /components/core/data-table/ or check list_sections for usage in other modules."
}
```

### New Workflow Entry

**Remove:** user-interaction, feature-planning (merged)

**Add:** workflow (if creating merged file)
```json
{
  "id": "workflow",
  "title": "Complete Development Workflow",
  "category": "workflows",
  "priority": "critical",
  "read_order": 1,
  "use_cases": "workflow,development,process,always",
  "file_path": "workflows/workflow.md"
}
```

**OR keep project-setup (if merging into it)** - Decision: Merge into project-setup.md

---

## Part 3: File Changes

### Phase 1: CRITICAL - CLAUDE.md Rewrite

**File:** `CLAUDE.md`

**Action:** Complete rewrite with structure from Part 1

**Validation:**
- ✅ 60-70 lines
- ✅ Implementation loop with 5 steps
- ✅ Blocking checkpoints (✋ STOP)
- ✅ Critical gotchas (15 items)
- ✅ Content types explained
- ✅ Tracking files enforced

---

### Phase 2: CRITICAL - Merge Workflows into project-setup.md

**File:** `workflows/project-setup.md`

**Action:** Merge user-interaction.md + feature-planning.md content

**New Structure:**
```markdown
# Project Setup - Complete Workflow

**Purpose:** One-time initial setup from blank project to ready-to-implement

**Read When:** Starting new Selise Blocks project

---

## Phase 0: Documentation Discovery (MANDATORY FIRST)

⚠️ **DO THIS BEFORE ANYTHING ELSE**

1. Call `mcp__selise__list_sections()`
2. Call `mcp__selise__get_documentation(['project-setup', 'schema-design-guide'])`
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

[Content from user-interaction.md - question templates]

**Question 1: Project Name**
"What do you want to name this project?"

**Question 2: App Description**
"What does this app do? (1-2 sentences)"

**Question 3: Core Features**
"What are the main features? (list 3-5)"

**Question 4: Multi-User Detection**
"Will multiple users use this app?"
→ YES: "Will users have different roles/permissions?"
  → YES: Need permissions-roles recipe
  → NO: Simple multi-user (IAM itemId directly)
→ NO: Single-user app

**Question 5: Data Types**
"What data will users create/manage?" (e.g., todos, products, posts)

**Question 6: GitHub Repository**
"GitHub username/repo? (e.g., username/my-app)"

### 1.3: Document Requirements

Write all answers to FEATURELIST.md:
```markdown
# Feature List - [Project Name]

## Project Details
- Name: [from Q1]
- Description: [from Q2]
- GitHub: [from Q6]

## Core Features
[from Q3 - bullet list]

## Multi-User Architecture
[from Q4 - simple/complex/single]

## Data Models
[from Q5 - schemas needed]
```

### 1.4: User Confirmation

Ask: "Based on these requirements, shall I proceed with setup?"

✋ CHECKPOINT: User confirmed? → NO = Revise requirements, YES = Phase 2

---

## Phase 2: Authentication & Project Creation

### 2.1: Get Credentials

**Now** ask for credentials (after user confirmed):
- Email for Selise Cloud
- Password for Selise Cloud
- Confirm GitHub username

### 2.2: Authenticate

```bash
mcp__selise__login(username="email", password="pass")
```

### 2.3: Decision Point - New or Existing Project?

**Ask user:** "Is this a NEW project or adding to EXISTING Selise project?"

#### Option A: NEW Project

```bash
# Create project
result = mcp__selise__create_project(
    project_name="[from user]",
    repo_name="username/repo",
    repo_link="https://github.com/username/repo",
    repo_id="Any",
    is_production=false
)

# MANDATORY: Set application domain
mcp__selise__set_application_domain(
    domain=result.domain,
    tenant_id=result.tenant_id,
    project_name="[from user]"
)
```

#### Option B: EXISTING Project

```bash
# List projects
projects = mcp__selise__get_projects()

# Show user list, ask which one
selected = [user chooses]

# Set domain
mcp__selise__set_application_domain(
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

```bash
mcp__selise__check_blocks_cli()
```

### 3.2: Install if Needed

```bash
# If not installed:
mcp__selise__install_blocks_cli()
```

### 3.3: Create Local Repository

```bash
mcp__selise__create_local_repository(
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

[Content from feature-planning.md]

### 4.1: Read Schema Design Guide

```bash
mcp__selise__get_documentation(['schema-design-guide'])
```

### 4.2: Analyze Features → Schemas

For each feature in FEATURELIST.md:
- What data does it need?
- What fields?
- Multi-user: Add UserId field

Example:
```
Feature: Todo Management
→ Schema: TodoTask
  - Title (String, required)
  - Description (String)
  - Status (String, default: "pending")
  - DueDate (DateTime)
  - UserId (String, required) # For multi-user
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

[Decision tree from iam-business-mapping]

**Ask:** "Do users need data beyond name/email from IAM?"

→ NO: Use IAM itemId directly (RECOMMENDED for simple apps)
→ YES: Create User schema with IAMUserId field

### 4.5: Create Schemas via MCP

```bash
# For each schema:
mcp__selise__create_schema(
    schema_name="TodoTask",
    fields=[...]
)

# Document in CLOUD.md:
echo "## Schema Created: TodoTask" >> CLOUD.md
echo "- Date: $(date)" >> CLOUD.md
echo "- Schema ID: [id]" >> CLOUD.md
```

✋ CHECKPOINT: All schemas created and documented in CLOUD.md? → YES = Phase 5

---

## Phase 5: Implementation Preparation

Setup complete! Now ready for implementation.

### 5.1: Read Implementation Docs

```bash
mcp__selise__get_documentation([
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
- [ ] Create GraphQL queries/mutations
- [ ] Create service layer
- [ ] Create React Query hooks
- [ ] Create UI components
- [ ] Create todo list page
- [ ] Add to routing

Docs to reference:
- graphql-crud.md
- react-query-patterns.md
```

### 5.3: Begin Implementation Loop

Return to CLAUDE.md → Implementation Loop

✋ CHECKPOINT: Ready to implement? → YES = Use CLAUDE.md loop for each task

---

**End of project-setup.md**
```

**Delete After Merge:**
- `workflows/user-interaction.md` + `.txt`
- `workflows/feature-planning.md` + `.txt`

**Update topics.json:**
- Remove user-interaction entry
- Remove feature-planning entry
- Keep project-setup entry (updated with merged content)

---

### Phase 3: Fix graphql-crud.md

**File:** `recipes/graphql-crud.md`

**Changes:** (Same as DOCUMENTATION-FIX-PLAN Phase 2)

1. Add Query Naming section with warnings
2. Fix response structure typo (double s)
3. Add DateTime format section
4. Add Pagination 1-based section
5. Add Response extraction section
6. Fix all import paths (@/ prefix)

---

### Phase 4: Create 3 New Recipes

#### 1. react-query-patterns.md

**File:** `recipes/react-query-patterns.md`

**Content:** Complete hook templates, invalidation patterns, error handling
(Same as DOCUMENTATION-FIX-PLAN Phase 4)

#### 2. schema-design-guide.md

**File:** `recipes/schema-design-guide.md`

**Content:** Field types, auto-generated fields, naming conventions, examples
(Same as DOCUMENTATION-FIX-PLAN Phase 4)

#### 3. component-reusability-rules.md

**File:** `recipes/component-reusability-rules.md`

**Content:** Import rules, what you CAN/CANNOT import, special cases
(Same as DOCUMENTATION-FIX-PLAN Phase 4)

---

### Phase 5: Fix iam-to-business-data-mapping.md

**File:** `recipes/iam-to-business-data-mapping.md`

**Changes:**
- Add decision tree at beginning
- Show simple pattern (use IAM itemId directly)
- Show complex pattern (User schema with IAMUserId)
- Warn against email-based pattern

---

### Phase 6: Fix Folder Structure References

**Global Search-Replace in ALL .md files:**
- `src/features/` → `src/modules/`
- `/components/` → `/component/` (in module context)
- `components/ui/` → `@/components/ui-kit/`

**Specific Files:**
- `component-catalog/selise-component-hierarchy.md`
- `architecture/constructs-structure.md`
- All recipe files

---

### Phase 7: Update topics.json

**File:** `topics.json`

**Changes:**
1. Add rich metadata to existing topics (use_cases, triggers, warnings)
2. Add 3 new recipe entries
3. Remove user-interaction and feature-planning entries (merged)
4. Fix permissions-roles metadata
5. Add status: "reference_only" to all 59 component entries

---

### Phase 8: Validation Scripts (OPTIONAL but RECOMMENDED)

**Create:** `scripts/validate-topics.js`

```javascript
// Validates all topics in topics.json have corresponding files
const fs = require('fs');
const topics = JSON.parse(fs.readFileSync('topics.json'));

let errors = 0;

topics.forEach(topic => {
  if (topic.status === 'reference_only') {
    console.log(`✓ ${topic.id} - marked as reference_only`);
    return;
  }

  const filePath = topic.file_path;
  const mdExists = fs.existsSync(filePath);
  const txtExists = fs.existsSync(filePath.replace('.md', '.txt'));

  if (!mdExists || !txtExists) {
    console.error(`✗ ${topic.id} - missing files (md: ${mdExists}, txt: ${txtExists})`);
    errors++;
  } else {
    console.log(`✓ ${topic.id}`);
  }
});

if (errors > 0) {
  console.error(`\n${errors} topics have missing files`);
  process.exit(1);
} else {
  console.log('\n✓ All topics validated');
}
```

**Add to package.json:**
```json
{
  "scripts": {
    "validate-docs": "node scripts/validate-topics.js"
  }
}
```

---

## Part 4: Implementation Checklist

### Day 1: Core Enforcement (CRITICAL)

- [ ] Rewrite CLAUDE.md (Part 1 structure)
- [ ] Create .txt mirror of CLAUDE.md
- [ ] Test: Read CLAUDE.md - is it clear?

### Day 2: Workflow Merge (CRITICAL)

- [ ] Merge user-interaction + feature-planning into project-setup.md
- [ ] Create .txt mirror
- [ ] Delete old workflow files
- [ ] Update topics.json (remove 2, keep project-setup)

### Day 3: GraphQL Fixes (HIGH PRIORITY)

- [ ] Fix graphql-crud.md (5 sections)
- [ ] Update .txt mirror
- [ ] Test: Do examples work?

### Day 4: New Recipes (HIGH PRIORITY)

- [ ] Create react-query-patterns.md + .txt
- [ ] Create schema-design-guide.md + .txt
- [ ] Create component-reusability-rules.md + .txt
- [ ] Add 3 entries to topics.json

### Day 5: Metadata Enrichment (MEDIUM)

- [ ] Add rich metadata to topics.json (use_cases, triggers, warnings)
- [ ] Add status flags to component entries
- [ ] Fix permissions-roles metadata
- [ ] Validate JSON syntax

### Day 6: Global Fixes (MEDIUM)

- [ ] Global search-replace: folder structure
- [ ] Global search-replace: import paths
- [ ] Update all .txt mirrors
- [ ] Fix iam-business-mapping.md

### Day 7: Validation & Testing (RECOMMENDED)

- [ ] Create validate-topics.js script
- [ ] Run validation, fix any 404s
- [ ] Test MCP: list_sections
- [ ] Test MCP: get_documentation for each new/changed file
- [ ] Build test app following new CLAUDE.md
- [ ] Verify 0 issues from original 55+ list

---

## Part 5: Success Metrics

### Before Fix:
- 25+ workflow conflicts
- 30+ implementation issues
- Agent skipped list_sections
- Agent skipped tracking files
- Agent skipped user confirmation
- Critical gotchas missed

### After Fix:
- ✅ 0 conflicts (project-setup.md is single source)
- ✅ 0 workflow issues (blocking checkpoints)
- ✅ list_sections useful (rich metadata)
- ✅ Tracking files enforced (✋ STOP checkpoints)
- ✅ User confirmation enforced (Phase 1.4)
- ✅ All gotchas in CLAUDE.md checklist

---

## Part 6: Files Summary

### Files to CREATE:
1. `recipes/react-query-patterns.md` + `.txt`
2. `recipes/schema-design-guide.md` + `.txt`
3. `recipes/component-reusability-rules.md` + `.txt`
4. `scripts/validate-topics.js` (optional)

### Files to REWRITE:
1. `CLAUDE.md` (114 → 60-70 lines) + update `.txt`
2. `workflows/project-setup.md` (merge user-interaction + feature-planning) + update `.txt`

### Files to UPDATE:
1. `recipes/graphql-crud.md` (add 5 sections) + `.txt`
2. `recipes/iam-to-business-data-mapping.md` (decision tree) + `.txt`
3. `topics.json` (rich metadata, new entries, remove 2)
4. `component-catalog/selise-component-hierarchy.md` (folder paths) + `.txt`
5. `architecture/constructs-structure.md` (folder paths) + `.txt`

### Files to DELETE:
1. `workflows/user-interaction.md` + `.txt`
2. `workflows/feature-planning.md` + `.txt`

### Total Impact:
- Create: 4 files (+ 4 .txt mirrors)
- Rewrite: 2 files (+ 2 .txt mirrors)
- Update: 5 files (+ 5 .txt mirrors)
- Delete: 4 files (2 .md + 2 .txt)

---

## Part 7: Key Decisions Made

1. ✅ **CLAUDE.md = Tight (60-70 lines)** with loop + checkpoints
2. ✅ **Workflows = Merged** (user-interaction + feature-planning → project-setup.md)
3. ✅ **topics.json = Rich** (use_cases, triggers, warnings)
4. ✅ **Components = Reference-only** (mark in topics.json, not documented yet)
5. ✅ **Tracking = Enforced** (✋ STOP checkpoints in loop)
6. ✅ **3 New Recipes** (react-query, schema-design, component-reusability)
7. ✅ **Validation Script** (optional but recommended)
8. ✅ **.txt mirrors maintained** (for agent ease of retrieval)

---

## End of Final Plan

This plan combines the best of both approaches:
- **From COMPREHENSIVE:** Rich metadata, Phases 0-5, validation scripts
- **From DOCUMENTATION-FIX:** Tight CLAUDE.md, specific fixes, surgical precision
- **From Discussion:** Blocking checkpoints, enforcement, clear loop

**Result:** Smooth, self-enforcing workflow that prevents all 55+ test issues.

**Ready for implementation on dev branch.**
