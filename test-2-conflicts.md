# Documentation Conflicts and Overlaps Analysis

## Analysis Date
2025-12-03

## Potential Conflicts Found in list_sections

### 1. **Sidebar Components - Multiple Options**
- **app-sidebar** (components/core/app-sidebar.md)
  - Priority: high
  - Use case: "sidebar,navigation,app-layout,collapsible-sidebar,responsive-sidebar,menu-navigation,mobile-sidebar,categorized-menu"

- **sidebar** (components/ui-kit/sidebar.md)
  - Priority: high
  - Use case: "sidebar,side-menu,navigation-sidebar,basic-sidebar,collapsible-sidebar"
  - Warning: "Use app-sidebar from core for full featured sidebar layouts with theme support"

**Conflict:** Two sidebar options with overlapping use cases. The warning suggests app-sidebar is preferred, but both have "high" priority which could be confusing.

---

### 2. **Avatar Components - Duplication**
- **custom-avatar** (components/core/custom-avatar.md)
  - Priority: low
  - Use case: "avatar,user-avatar,profile-picture,user-display,initials,fallback-avatar,circular-avatar"

- **avatar** (components/ui-kit/avatar.md)
  - Priority: medium
  - Use case: "avatar,profile-picture,user-image,basic-avatar,radix-avatar"
  - Warning: "Use custom-avatar from core for grid backgrounds and more features"

**Conflict:** Two avatar components with nearly identical use cases. custom-avatar has LOWER priority (low) but is recommended in the warning. Priority mismatch.

---

### 3. **Breadcrumb Components - Duplication**
- **dynamic-breadcrumb** (components/core/dynamic-breadcrumb.md)
  - Priority: medium
  - Use case: "breadcrumb,navigation,url-breadcrumb,dynamic-breadcrumb,path-navigation,auto-breadcrumb"

- **breadcrumb** (components/ui-kit/breadcrumb.md)
  - Priority: medium
  - Use case: "breadcrumb,navigation,trail,basic-breadcrumb,manual-breadcrumb"
  - Warning: "Use dynamic-breadcrumb from core for URL-based automatic breadcrumbs"

**Conflict:** Both have "breadcrumb,navigation" in use cases. Need clearer distinction in triggers. When would someone choose basic over dynamic?

---

### 4. **Checkbox Components - Duplication**
- **custom-checkbox** (components/core/custom-checkbox.md)
  - Priority: high
  - Use case: "checkbox,form-checkbox,selection,styled-checkbox,custom-checkbox,form-input"

- **checkbox** (components/ui-kit/checkbox.md)
  - Priority: medium
  - Use case: "checkbox,basic-checkbox,toggle,radix-checkbox"
  - Warning: "Use custom-checkbox from core for form inputs instead"

**Conflict:** Overlapping "checkbox" use case. Warning suggests custom-checkbox for forms, but when to use basic checkbox?

---

### 5. **Table Components - Duplication**
- **data-table** (components/core/data-table.md)
  - Priority: critical
  - Use case: "table,data-table,pagination,sorting,filtering,column-visibility,expandable-rows,mobile-table,tanstack-table,data-grid"

- **table** (components/ui-kit/table.md)
  - Priority: high
  - Use case: "table,basic-table,grid,data-grid"
  - Warning: "Use data-table from core for advanced tables with pagination/sorting/filtering"

**Conflict:** Both have "table" and "data-grid" in use cases. When to use basic table? No clear guidance.

---

### 6. **Password Strength Checker - Two Variants**
- **password-strength-checker** (components/core/password-strength-checker.md)
  - Priority: medium
  - Use case: "password-strength,strength-meter,password-validation,password-requirements,password-checker"

- **shared-password-strength-checker** (components/core/shared-password-strength-checker.md)
  - Priority: low
  - Use case: "shared-password-strength,password-change,password-validation,exclude-current-password"

**Conflict:** Both check password strength. "shared" variant has overlapping "password-validation" use case. Unclear when to use which.

---

### 7. **Confirmation Modal - Duplicate Entries**
- **confirmation-modal** (recipes/confirmation-modal-patterns.txt)
  - Type: recipe
  - Priority: high
  - Use case: "confirmations,modals,delete-operations,destructive-actions,async-operations"

- **confirmation-modal** (components/core/confirmation-modal.md)
  - Type: component
  - Priority: high
  - Use case: "confirmation,modal,dialog,destructive-actions,user-confirmation,delete-confirmation,alert-dialog"

**Conflict:** SAME ID "confirmation-modal" for both recipe and component! Overlapping use cases like "destructive-actions". Which should be fetched first?

---

### 8. **GraphQL CRUD vs Architecture Patterns**
- **graphql-crud** (recipes/graphql-crud.txt)
  - Priority: critical
  - Warning: "NEVER use inventory patterns for data operations!"
  - Replaces: "inventory feature data patterns"

- **architecture-patterns** (architecture/patterns.txt)
  - Priority: high
  - Warning: "Inventory is STRUCTURE ONLY - never copy data patterns"

**Potential Conflict:** Both mention inventory patterns with strong warnings. Could be confusing if not read together. Are the warnings consistent?

---

### 9. **Alert Dialog vs Confirmation Modal**
- **alert-dialog** (components/ui-kit/alert-dialog.md)
  - Priority: high
  - Use case: "alert,dialog,alert-dialog,modal,warning-dialog,confirmation,destructive-action"

- **confirmation-modal** (components/core/confirmation-modal.md)
  - Priority: high
  - Use case: "confirmation,modal,dialog,destructive-actions,user-confirmation,delete-confirmation,alert-dialog"

**Conflict:** Massive overlap - both mention "alert-dialog", "confirmation", "destructive-action", "modal", "dialog". When to use which?

---

### 10. **Constructs Structure - Unclear Purpose**
- **constructs-structure** (component-catalog/constructs-structure.txt)
  - Priority: very high
  - Read when: "when building the frontend and everything else, always read this this"
  - Warning: "This is reference only - use these components and reusable code as often as possible. dont copy inventory directly"

**Conflict:** Says "very high" priority and "always read this" but then says "reference only". Is this critical to read or just nice-to-have? Confusing guidance.

---

## Priority Conflicts

### Components with conflicting priority levels:
1. **custom-avatar (low)** recommended over **avatar (medium)** - priority seems backwards
2. **constructs-structure (very high)** but marked as "reference only" - is it critical or not?
3. Multiple "critical" items (15 total) - are they all equally critical?

---

## Use Case Overlap Summary

Components sharing identical/similar use case keywords:
- **sidebar**: app-sidebar, sidebar
- **avatar**: custom-avatar, avatar
- **breadcrumb**: dynamic-breadcrumb, breadcrumb
- **checkbox**: custom-checkbox, checkbox
- **table/data-grid**: data-table, table
- **password-strength**: password-strength-checker, shared-password-strength-checker
- **confirmation/destructive-actions**: confirmation-modal (recipe), confirmation-modal (component), alert-dialog

---

## Duplicate IDs
- **confirmation-modal** appears twice (recipe + component) with same ID

---

## Recommendations for Improvement

1. **Remove duplicate use_cases** - If two components have same keywords, one is redundant or needs better differentiation
2. **Fix priority inversions** - Recommended components should have higher priority
3. **Resolve duplicate IDs** - confirmation-modal needs unique IDs
4. **Clarify "basic" vs "advanced"** - When should basic components be used if advanced ones exist?
5. **Consistent warnings** - All UI kit components should point to Core alternatives if they exist
6. **Reduce "critical" count** - Too many critical items dilutes the meaning

---

## Questions for Testing

1. What happens if I try to fetch "confirmation-modal" - which one comes back?
2. If use_cases overlap, how does the agent choose which component to use?
3. Are the warnings in graphql-crud and architecture-patterns consistent?

---

# PART 2: Conflicts Found Within Documentation Content

## Analysis of Retrieved Documentation

### 11. **Project Setup vs User Interaction - Workflow Ordering Conflict**

**project-setup.md:**
> ### 1. FIRST: Read Documentation (Before talking to user)
> - Read `workflows/user-interaction.md`
> - Read `workflows/feature-planning.md`
> - Read `agent-instructions/selise-development-agent.md`

**BUT ALSO says:**
> ### 2. User Interaction & Requirements Gathering
> - Follow patterns from `user-interaction.md`

**user-interaction.md:**
> ## Initial Contact Protocol
> When user requests any application, follow this exact flow:
> ### 1. Create Tracking Files Immediately

**Conflict:** project-setup says "read docs BEFORE talking to user" but user-interaction says "create tracking files IMMEDIATELY when user requests". Which comes first?

---

### 12. **MCP Project Creation - When to Execute**

**project-setup.md Step 3:**
> **Project Creation Flow:**
> ```python
> # ALWAYS create new project - don't look for existing domains
> create_project(...)
> ```

**user-interaction.md:**
> ### After Confirmation - Project & Schema Setup
> ```
> [Internal Process - Never mention to user:]
> 1. Execute MCP project creation (if new project needed)
> ```

**Conflict:** project-setup says "ALWAYS create new project" but user-interaction says "if new project needed". When exactly should project creation happen?

---

### 13. **Schema Confirmation - Contradictory Instructions**

**project-setup.md Step 4:**
> - Document schema plan in CLOUD.md and ask the user if they are okay if not keep talking to the user to confirm the schemas

**user-interaction.md:**
> #### Schema Confirmation with User
> After documenting schemas in CLOUD.md, **ALWAYS get user confirmation**:

**feature-planning.md:**
> ### Step 0: Schema Analysis & CLOUD.md Setup (FIRST)
> After user confirmation, analyze ALL features to determine backend requirements

**Conflict:** Different docs say "after user confirmation" vs "ask user if they are okay". Also, when does schema analysis happen - before or after user confirms features?

---

### 14. **Tracking Files Creation - Multiple Conflicting Times**

**user-interaction.md:**
> ### 1. Create Tracking Files Immediately
> ```bash
> touch FEATURELIST.md TASKS.md SCRATCHPAD.md CLOUD.md
> ```

**project-setup.md Step 2:**
> - Create tracking files: `FEATURELIST.md`, `TASKS.md`, `SCRATCHPAD.md`, `CLOUD.md`

**feature-planning.md:**
> ## Required Files Structure
> (Shows structure but doesn't say WHEN to create)

**Conflict:** user-interaction says create "immediately", project-setup mentions it in step 2 (after reading docs), feature-planning doesn't specify timing. When exactly?

---

### 15. **GraphQL Naming Pattern Confusion**

**graphql-crud.md:**
> ### 1. Correct Schema Name Pattern (Updated)
> ```typescript
> // Schema: "TodoTask" → Query field: "TodoTasks" (schema name + single 's')
> ```

**LATER in same doc:**
> ### 3. Response Structure
> ```typescript
> // Access: result.[schema]ss.items (note the double s)
> ```

**Conflict:** First says "single 's'" then says "double s". Which is it? Is it `result.TodoTasks.items` or `result.TodoTaskss.items`?

---

### 16. **Implementation Start - Conflicting Instructions**

**project-setup.md Step 4:**
> - **CONTINUE TO STEP 5 BELOW** - Do not stop here!
> - Move to the next steps as listed here, follow this strictly
> - **After schemas are created, proceed immediately to Implementation Process (Step 5)**

**feature-planning.md:**
> ## CRITICAL: After Tasks.md Creation
> ### Continue to Implementation (CLAUDE.md Step 5)
> Once TASKS.md is populated with technical tasks:
> 1. **STOP** - Do not start implementing yet
> 2. **Return to CLAUDE.md step 5**: "Implementation Process"

**Conflict:** project-setup says "proceed immediately" but feature-planning says "STOP - Do not start implementing yet". Which is it?

---

### 17. **Multi-User App Detection - When to Ask**

**project-setup.md:**
> ## Multi-User App Decision Tree
> (Shows decision tree but doesn't say when to evaluate it)

**user-interaction.md:**
> ### 🚨 CRITICAL: Multi-User Detection (Ask FIRST)
> **BEFORE diving into features, determine if this is a multi-user app:**

**Conflict:** user-interaction says ask FIRST (before features) but project-setup workflow has this after user confirmation. When exactly?

---

### 18. **Inventory Feature Reference - Contradictory Warnings**

**graphql-crud.md:**
> ## 🚨 CRITICAL: This is the ONLY Source for Data Operations
> **NEVER look at inventory feature for data operations - it uses different patterns!**

**architecture-patterns.md:**
> **⚠️ CRITICAL: Inventory is for STRUCTURE ONLY, not data operations!**
> - Use `src/features/inventory/` as template for folder structure
> - NEVER copy inventory's GraphQL patterns - they're different

**feature-planning.md:**
> ### Step 1: Analyze Feature Requirements
> (No warning about inventory at all)

**component-hierarchy.md:**
> ### Layer 1: Feature Components (src/features/*/components/)
> **AdvanceDataTable** - Complete table system
> ```typescript
> // Path: features/inventory/component/advance-data-table/advance-data-table.tsx
> ```

**Conflict:** Some docs say "NEVER look at inventory for data" but component-hierarchy literally points to inventory components to use. Then feature-planning doesn't mention this warning at all. Confusing!

---

### 19. **TASKS.md Update Frequency - Conflicting Guidance**

**feature-planning.md:**
> ### Status Indicators
> - Update status immediately: `[ ]` → `[🔄]` → `[x]`

**ALSO in feature-planning.md:**
> ### Commit & Update Rhythm
> ```bash
> # EVERY TASK COMPLETION:
> 1. Update TASKS.md: [🔄] → [x]
> ```

**dev-workflow (mentioned in implementation-checklist next_steps):**
> (Not loaded but referenced for continuous updates)

**Conflict:** Says "immediately" but also says "every task completion". Should you update when starting (→ 🔄) or only when completing (→ x)?

---

### 20. **Authentication Flow - Login vs Project Creation Order**

**project-setup.md Step 3:**
> **Authentication Flow** (Ask one by one if NOT IN user-info.txt):
> - Username/email for Selise Blocks
> - Password for Selise Blocks
> - GitHub username
> - GitHub repository name to connect

**THEN:**
> **Project Creation Flow:**
> ```python
> create_project(...)
> ```

**implementation-checklist.md:**
> ## Before ANY Implementation - Verify Prerequisites
> - [ ] **Authenticated with MCP login tool**
> - [ ] **Created project with MCP create_project**

**Conflict:** project-setup shows auth details THEN project creation, but implementation-checklist lists them as separate prerequisites without clear ordering. Does login happen before or during project creation?

---

### 21. **Schema Verification - MCP Tool Usage Inconsistency**

**graphql-crud.md:**
> ### MANDATORY: Verify Schema Types Before Writing Queries
> Before writing ANY GraphQL queries or services:
> 1. **Check CLOUD.md** for documented schemas
> 2. **Call MCP tool** to get real field types:
>    ```python
>    get_schema_details(schema_name="YourSchema")
>    ```

**BUT ALSO in graphql-crud.md:**
> ## Testing Schema Names with MCP
> **MANDATORY: Always verify schema names with MCP before implementing:**
> ```python
> # List all schemas first
> list_schemas()
> # Get schema details for the exact name
> get_schema_details(schema_name="TodoTask")
> ```

**project-setup.md:**
> **Schema Management:**
> - `list_schemas`: List all schemas
> - `get_schema_details`: Get schema field information

**Conflict:** One section says check CLOUD.md FIRST, another says use MCP FIRST. Should you check the file or call the tool first?

---

### 22. **curl Testing - Mandatory vs Optional**

**graphql-crud.md:**
> ## Testing with curl Requests (MANDATORY Safety Check)
> **🚨 CRITICAL: Always test your GraphQL operations with curl BEFORE implementing in code!**

**BUT ALSO:**
> ### curl Testing Workflow
> **For each schema you create:**

**Conflict:** Says "MANDATORY" and "ALWAYS" but then describes it as a workflow for "each schema you create" which implies it's a per-schema choice, not mandatory for all operations. Is this truly required or best practice?

---

### 23. **Response Structure Documentation Error**

**graphql-crud.md Section 3:**
> ### 3. Response Structure
> ```typescript
> // graphqlClient returns data directly (no 'data' wrapper):
> const result = await graphqlClient.query({...});
> // Access: result.[schema]ss.items (note the double s)
> ```

**Step 4: Service Functions:**
> ```typescript
> // Check if found (schema name + 's')
> const queryFieldName = `${schemaName}s`; // e.g., "TodoTasks"
> if (result?.[queryFieldName]?.items?.length > 0) {
> ```

**Common Gotchas #4:**
> ```typescript
> // ❌ WRONG - graphqlClient doesn't wrap in 'data'
> const items = result.data.TodoTasks.items;
>
> // ✅ CORRECT - Direct access with proper field name
> const items = result.TodoTasks.items;
> ```

**Conflict:** Section 3 says "double s" (`result.[schema]ss.items`) but examples show single s (`result.TodoTasks.items`). Which is correct?

---

### 24. **ConfirmationModal - Two Entries Confirmed**

As expected from list_sections analysis, fetching "confirmation-modal" returned the **recipe** version:
- Topic: "confirmation-modal"
- Type: "recipe"
- Title: "Confirmation Modal Patterns Recipe"

This confirms the duplicate ID issue. The component documentation was not returned even though it also has ID "confirmation-modal".

---

### 25. **FEATURELIST.md Update Triggers - Vague**

**feature-planning.md:**
> ### 1. FEATURELIST.md - Source of Truth (UPDATE TRIGGERS)
> **When to Update FEATURELIST.md:**
> - ✅ **Task completion**: When all TASKS.md items for a feature are complete
> - ✅ **Scope changes**: When user adds/removes/modifies features
> - ✅ **Feature discovery**: When implementation reveals new requirements

**Conflict:** "Task completion" says update when "all tasks complete" but also says update during "feature discovery" during implementation. So should you update continuously or only when complete? Mixed signals.

---

### 26. **React Hook Form - Output Truncated**

The react-hook-form documentation was **truncated** in the response. This is a data issue - users may not get complete form implementation guidance if the doc is too large.

**Issue:** Token limit hit during documentation fetch, meaning not all patterns/recipes were fully delivered.

---

## Summary of Content-Level Conflicts

### Critical Issues:
1. **Workflow ordering confusion** - Multiple docs give different step orders
2. **Contradictory "stop" vs "continue"** instructions for implementation start
3. **GraphQL response structure error** - "double s" vs "single s" typo
4. **Multi-user detection timing** - Before features or after confirmation?
5. **Schema verification** - CLOUD.md first or MCP first?
6. **Tracking files creation** - Immediate or after reading docs?

### Moderate Issues:
7. **Authentication order** unclear with project creation
8. **curl testing** - Mandatory or recommended?
9. **Inventory warnings** inconsistent across docs
10. **TASKS.md update frequency** - Continuous or at milestones?
11. **FEATURELIST.md updates** - When exactly?

### Documentation Quality Issues:
12. **confirmation-modal duplicate ID** - Only recipe returned, component doc inaccessible
13. **react-hook-form truncated** - Output exceeded token limit
14. **CLOUD.md population process** - Mentioned but not fully documented in retrieved sections

---

## Recommendations for Documentation Improvements

### High Priority Fixes:
1. **Fix GraphQL response structure docs** - Remove "double s" typo, clarify it's single 's'
2. **Unify workflow ordering** - Create single authoritative workflow sequence
3. **Resolve duplicate IDs** - Rename confirmation-modal component to confirmation-modal-component
4. **Clarify implementation start** - One doc says proceed, another says STOP
5. **Multi-user detection placement** - Define exact moment in workflow

### Medium Priority:
6. Split large docs (react-hook-form) to avoid truncation
7. Create workflow flowchart showing exact sequence of steps
8. Consolidate all inventory warnings into one clear section
9. Define "mandatory" vs "recommended" clearly for curl testing

### Low Priority:
10. Add visual diagrams for decision trees
11. Cross-reference related sections more clearly
12. Add timestamps/version info to each doc

---

# PART 3: Real-World Usage Issues (Live Test)

## Issues Found During Actual Todo App Build

### 27. **Authentication Before Requirements - Workflow Order Violation**

**What happened in practice:**
When following project-setup.md, I:
1. Read docs
2. Got user credentials
3. Authenticated immediately
4. Created project
5. Created tracking files with assumptions
6. THEN asked user about features (too late!)

**Why this happened:**
- project-setup.md Step 3 shows authentication code examples immediately
- Having credentials made authentication feel like "next step"
- "User Interaction" is Step 2 but authentication code appears in Step 3
- Workflow implies: auth → project → then ask questions
- But should be: ask questions → get confirmation → THEN auth → project

**Correct flow should be:**
1. User says "I want to build X"
2. Create EMPTY tracking files
3. Ask ALL questions from user-interaction.md
4. Document answers in FEATURELIST.md
5. Get user confirmation
6. Ask for credentials
7. Authenticate
8. Create project
9. Create schemas

**Impact:** Built project before knowing what features user actually wants!

---

### 28. **App Name Never Requested**

**What happened:**
Used "test-2" from GitHub repo name without asking user what to name the app.

**Why:**
- project-setup.md says "Get project name from user" as a single line
- Easy to interpret as "use the repo name"
- No question template in user-interaction.md for project name
- Project setup questions start with GitHub info, not app name

**Should have asked:**
"What would you like to name your todo application?"
(Could have been: TaskMaster, MyTodos, DailyTasks, etc.)

---

### 29. **No Workflow for Existing Projects**

**Issue:**
All documentation assumes you're creating a NEW Selise Cloud project. There's no workflow for:
- Using an existing project
- Adding features to existing project
- When to create new project vs use existing

**Current docs:**
project-setup.md says:
> # ALWAYS create new project - don't look for existing domains

This is too rigid. Need two workflows:

**Workflow A: New Project**
1. Ask requirements
2. Get confirmation
3. Ask for project name (new)
4. Get credentials
5. Authenticate
6. Create project via MCP
7. Create schemas

**Workflow B: Existing Project**
1. Ask requirements
2. Get confirmation
3. Ask which existing project to use (show list)
4. Get credentials
5. Authenticate
6. Set application domain to existing project
7. Create/update schemas in that project

**Suggestion:**
Add a decision point at the start:
- "Is this a new project or adding to an existing one?"
- Then branch to appropriate workflow

---

### 30. **list_sections vs implementation-checklist - Recipe Requirements Conflict**

**list_sections metadata:**
```json
{
  "id": "permissions-roles",
  "required": "conditional",
  "read_when": "MANDATORY for multi-user apps - MUST create roles via MCP first"
}
```

**implementation-checklist.md:**
```markdown
- [ ] Read ALL recipes in llm-docs/recipes/
  - permissions-and-roles.md (if multi-user app)
```

**Conflict:**
- list_sections says: permissions-roles is "MANDATORY for multi-user apps"
- Reality: It should be "MANDATORY for role-based access control"
- Multi-user apps don't always need roles (e.g., todos where all users are equal)
- implementation-checklist hardcodes a list instead of using list_sections metadata

**Impact:**
- Forces reading unnecessary docs
- list_sections metadata is smarter (conditional based on features) but implementation-checklist ignores it
- Two sources of truth disagree on what's required

**Suggestion:**
1. Fix list_sections: Change permissions-roles to "MANDATORY for role-based access control, not just multi-user"
2. Fix implementation-checklist: Remove hardcoded list, say "Check list_sections metadata for required docs"

---

### 31. **implementation-checklist "Read ALL Recipes" vs On-Demand Reading**

**implementation-checklist.md:**
```markdown
- [ ] Read ALL recipes in llm-docs/recipes/
  - graphql-crud.md (MANDATORY)
  - confirmation-modal-patterns.md
  - react-hook-form-integration.md
  - iam-to-business-data-mapping.md (if multi-user app)
  - permissions-and-roles.md (if multi-user app)
```

**list_sections metadata approach:**
- Read recipes when implementing that feature
- Use `read_when` and `triggers` to determine what you need
- More efficient, less information overload

**Conflict:**
- implementation-checklist says read ALL upfront
- But some recipes might never be needed for your app
- Causes information overload
- list_sections has better approach with conditional reading

**Suggestion:**
Change implementation-checklist to: "Read recipes as needed. Use list_sections to find relevant docs for your features."

---
