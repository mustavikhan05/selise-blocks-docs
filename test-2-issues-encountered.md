# Documentation Issues Encountered During Todo App Build

## Build Session: 2025-12-03

This document tracks real issues encountered while following Selise Blocks documentation to build a todo app.

---

## Issue Log

### Issue #1: Starting Point Unclear
**Time:** [Start of build]
**Doc Reference:** project-setup.md Step 1

**What happened:**
According to project-setup.md:
> ### 1. FIRST: Read Documentation (Before talking to user)
> - Read `workflows/user-interaction.md`
> - Read `workflows/feature-planning.md`
> - Read `agent-instructions/selise-development-agent.md`

But we already read the docs. Now following step 2, but user-interaction.md says:
> ### 1. Create Tracking Files Immediately

**Confusion:** Should I create tracking files before or after reading all docs? The workflow says read first, but user-interaction says create files immediately.

**Resolution:** Creating tracking files first (seems most practical), then will gather requirements from user.

**Suggestion:** Docs should have ONE clear starting point. Either:
- "Create tracking files immediately, then read relevant docs"
- OR "Read these docs first, then create tracking files in step 2"

---

### Issue #2: Authentication Timing Unclear
**Time:** Beginning of build
**Doc Reference:** project-setup.md Step 3
**Severity:** Clarification Needed

**What happened:**
Need to authenticate with MCP, but unclear when to ask user for credentials.

**Doc says:**
> **Authentication Flow** (Ask one by one if NOT IN user-info.txt):

**Reality:**
There's no user-info.txt file mentioned anywhere before this. Should we create one? Where? What format?

**Workaround/Resolution:**
Will ask user directly for credentials now.

**Suggestion:**
Either explain user-info.txt file earlier, or just say "Ask user for these credentials:"

---

### Issue #3: create_project Tool Parameters Don't Match Docs
**Time:** After authentication, creating project
**Doc Reference:** project-setup.md Step 3
**Severity:** Major - Documentation Error

**What happened:**
The docs show simplified `create_project` parameters, but actual MCP tool requires different structure.

**Doc says:**
```python
create_project(
    project_name="UserProvidedName",
    github_username="from_step_1",
    repository_name="from_step_1"
)
```

**Reality:**
Actual MCP tool signature:
```python
create_project(
    project_name: str,
    repo_name: str,        # Format: "username/repo"
    repo_link: str,        # Full URL: "https://github.com/username/repo"
    repo_id: str,          # Not documented - used "Any"
    is_production: bool    # Not shown in docs
)
```

**Workaround/Resolution:**
- Used `repo_name="mustavikhan05/test-2"` (username/repo format)
- Used `repo_link="https://github.com/mustavikhan05/test-2"` (full URL)
- Used `repo_id="Any"` (found in tool description, not explained)
- Set `is_production=false` (not mentioned in docs)

**Result:** ✅ Success! Project created with:
- Tenant ID: D3DD4321327C4D709CE288348E407BFA
- Domain: https://dynera-bhbjq.seliseblocks.com

**Suggestion:**
Update docs to show actual create_project parameters. Explain what repo_id is and where to get it.

---

### Issue #4: Workflow Skipped User Interaction Step
**Time:** After project creation, before schema
**Doc Reference:** project-setup.md Step 2, user-interaction.md
**Severity:** Critical - Process Violation

**What happened:**
I jumped straight from authentication → project creation → tracking files WITHOUT following the user interaction workflow first.

**Doc says (project-setup.md Step 2):**
> ### 2. User Interaction & Requirements Gathering
> - Follow patterns from `user-interaction.md`
> - Create tracking files: `FEATURELIST.md`, `TASKS.md`, `SCRATCHPAD.md`, `CLOUD.md`
> - Ask clarifying questions about features
> - Document everything in FEATURELIST.md
> - Create tasks.md
> - Get user confirmation before proceeding

**Doc also says (user-interaction.md):**
> ## Initial Contact Protocol
> When user requests any application, follow this exact flow:
> ### 1. Create Tracking Files Immediately
> ### 2. Initial Response Template
> "I'll help you build [what they asked for]. Let me understand your requirements..."
> - Then ASK questions using the templates

**Reality:**
I created the project and tracking files, then filled in FEATURELIST.md with assumptions BEFORE asking the user anything. Only asked at the very end.

**What I should have done:**
1. Create empty tracking files
2. Ask user the questions from user-interaction.md templates:
   - "What are the main features you need?"
   - "Who will be using this application?"
   - "Do you need user authentication/login?"
   - "Should data persist between sessions?"
   - For todo app: "Should tasks have categories, tags, or projects?"
   - "Do you need due dates and reminders?"
   - etc.
3. THEN document their answers in FEATURELIST.md
4. Get confirmation
5. THEN create project and schemas

**Impact:**
I pre-filled FEATURELIST.md with my assumptions instead of gathering actual requirements. This could lead to building the wrong thing.

**Suggestion:**
Make the workflow MORE explicit:
- Step 1: Create EMPTY tracking files
- Step 2: ASK USER (use templates from user-interaction.md)
- Step 3: DOCUMENT answers in FEATURELIST.md
- Step 4: GET CONFIRMATION
- Step 5: Create project and schemas

The current docs mention this but don't enforce the order clearly enough.

**Why I skipped it:**
1. **Workflow conflict:** project-setup.md shows numbered steps where Step 3 is "Project Setup (After user confirms features)" but Step 3 also shows the authentication code BEFORE any user interaction examples
2. **I had credentials already:** Since user provided credentials upfront, I jumped to authentication
3. **Order ambiguity:** Docs say "read docs first" but also "create files immediately" - I interpreted this as "do setup first, ask later"
4. **Missing app name question:** No explicit step says "ask user for app name" - the docs just say "Get project name from user" in Step 3, AFTER authentication variables are shown

**What confused me:**
- Step 1: Read docs ✓
- Step 2: Says "User Interaction & Requirements Gathering" BUT immediately lists "Create tracking files" first
- Step 3: Shows authentication code with variables like `project_name="UserProvidedName"` without saying "STOP - Ask user for name first"
- The workflow numbering makes it seem like authentication IS part of step 3, not something that comes after full requirements gathering

**Project name issue:**
I used "test-2" from the GitHub repo name you provided, but I never asked:
- "What would you like to name your project/app?"
- "What should we call this application?"

---

### Issue #5: Project Name Not Explicitly Requested
**Time:** Before project creation
**Doc Reference:** project-setup.md Step 3
**Severity:** Minor - UX Issue

**What happened:**
I used "test-2" from the GitHub repo name without asking user what they want to name the application.

**Doc says:**
> **Get project name from user**

This appears as a single line in Step 3, easy to miss or interpret as "use the repo name"

**Reality:**
User never got asked: "What would you like to name your todo app?"
Could have been "MyTodoApp", "TaskManager", "DailyTodos", etc.

**Workaround/Resolution:**
Used "test-2" from GitHub repo name

**Suggestion:**
Add to "Project Setup Questions (For New Projects)" in user-interaction.md:
- "What would you like to name your project?" (e.g., "TaskManager", "InventoryApp")
- Make it question #1 before GitHub questions

---

### Issue #6: No Workflow for Existing Projects
**Time:** During workflow analysis
**Doc Reference:** project-setup.md
**Severity:** Major - Missing Documentation

**What happened:**
All docs assume creating a NEW project. No guidance for using existing Selise Cloud projects.

**Doc says:**
> # ALWAYS create new project - don't look for existing domains

**Reality:**
Real-world scenarios include:
- Using an existing project for a new feature
- Multiple developers working on same project
- Testing in existing dev environments
- Adding features to deployed apps

**Missing Documentation:**
Need two distinct workflows:

**New Project Workflow:**
1. Requirements → Confirmation → Auth → Create Project → Schemas

**Existing Project Workflow:**
1. Requirements → Confirmation → Auth → List Projects → Select Project → Set Domain → Update Schemas

**Suggestion:**
Add decision point: "New project or existing project?"
- If new: Follow current docs
- If existing: Show how to use get_projects, set_application_domain, and work within existing tenant

---

### Issue #7: No Schema Design/Planning Documentation
**Time:** Before creating schemas
**Doc Reference:** project-setup.md, feature-planning.md, graphql-crud.md
**Severity:** Major - Missing Documentation

**What happened:**
About to create schemas but there's no documentation on:
- How to design schemas for Selise/MongoDB
- What field types are available
- NoSQL best practices
- Schema relationships in MongoDB
- What fields are auto-generated
- Required vs optional field guidelines

**What docs say:**
- project-setup.md Step 4: Just says "Create schemas using MCP" with a simple example
- graphql-crud.md: Has a section "Selise Uses MongoDB (NoSQL)" that mentions:
  - "No foreign keys or JOINs - use references via _id fields"
  - "No relational patterns - this is document-based storage"
  - "Relationships handled in application layer, not database"
  - Shows NoSQL pattern example but that's it
- feature-planning.md: Shows schema analysis but no design guidelines

**What's missing:**
1. **Available field types** - String, Number, Boolean, DateTime... what else?
2. **Field naming conventions** - camelCase? snake_case?
3. **Auto-generated fields** - Does Selise auto-add: ItemId, CreatedDate, CreatedBy, etc.?
4. **Required fields** - How to mark fields as required?
5. **Unique constraints** - How to make email unique?
6. **References** - Best practice for userId references?
7. **Schema validation** - Any validation at schema level?
8. **Array fields** - Can we have array of strings for tags?

**Current approach:**
Making educated guesses based on:
- graphql-crud.md mention of MongoDB
- Standard MongoDB field types
- Example in project-setup.md

**Suggestion:**
Add comprehensive "Schema Design Guide" doc covering:
- Available field types and constraints
- Auto-generated Selise fields
- NoSQL relationship patterns
- Multi-user schema patterns
- Common schema examples (User, Task, Product, etc.)

---

### Issue #8: Local Repository Setup Completely Skipped
**Time:** After project creation, before schema creation
**Doc Reference:** project-setup.md Step 3, TASKS.md checklist
**Severity:** Critical - Missing Critical Step

**What happened:**
I created the Selise Cloud project but never set up the local repository. We have no actual codebase to work with!

**What docs say:**
project-setup.md Step 3 says:
```python
# If user wants local setup:
create_local_repository(project_name="UserProvidedName")
```

And there are MCP tools:
- `check_blocks_cli` - Check if CLI installed
- `install_blocks_cli` - Install instructions
- `create_local_repository` - Create local repo

**Why I skipped it:**
1. **Not emphasized enough** - Shown as "if user wants" makes it seem optional
2. **No explicit prompt** - Docs don't say "STOP - Do you want local setup?"
3. **Workflow unclear** - Should this happen before or after schemas?
4. **Assumed cloud-only** - Thought we'd just use Selise Cloud without local code
5. **ZERO mentions in other critical docs:**
   - implementation-checklist.md: No mention of local setup
   - feature-planning.md: Talks about `src/features/` structure but never says "create local repo first"
   - graphql-crud.md: Shows file paths but no "create repo first"
   - user-interaction.md: No mention at all
   - All implementation docs assume you already have a codebase!

**Reality:**
You CAN'T actually build the frontend without local repository! The entire implementation requires:
- Local React project
- GraphQL client setup
- Component files
- Service files
- Build tools

**What should happen:**
After project creation:
1. Ask: "Do you want to set up local development environment?"
2. Check if Blocks CLI installed: `check_blocks_cli()`
3. If not: Show install instructions: `install_blocks_cli()`
4. Create local repo: `create_local_repository()`
5. Document in SCRATCHPAD.md

**Current state:**
- ✅ Selise Cloud project exists
- ❌ No local codebase
- ❌ Can't implement anything yet
- ❌ No way to build frontend

**Suggestion:**
1. Make local setup NON-OPTIONAL in docs (you need it to build!)
2. Add explicit step: "Setting up local development environment"
3. Show full CLI workflow before any implementation steps
4. Make it clear: Cloud project = backend, Local repo = frontend code

---

### Issue #9: set_application_domain Prerequisite Not Documented
**Time:** During local repository creation
**Doc Reference:** project-setup.md Step 3
**Severity:** Minor - Missing Information

**What happened:**
Called `create_local_repository` but got error: "Missing tenant ID or application domain. Please run get_projects or set_application_domain first."

**Doc says:**
```python
# If user wants local setup:
create_local_repository(project_name="UserProvidedName")
```

**Reality:**
Must call `set_application_domain` BEFORE `create_local_repository`:
```python
# Step 1: Set context (NOT in docs)
set_application_domain(
    domain="https://dynera-bhbjq.seliseblocks.com",
    tenant_id="D3DD4321327C4D709CE288348E407BFA",
    project_name="test-2"
)

# Step 2: Then create repo
create_local_repository(repository_name="test-2")
```

**Workaround/Resolution:**
Called `set_application_domain` first, then `create_local_repository` worked.

**Result:** ✅ Success! Repository created at `/Users/mustavikhan/Developer/selise/selise/test-2`

**Suggestion:**
Update docs to show the prerequisite step:
1. After create_project, call set_application_domain
2. Then call create_local_repository

---

### Issue #10: Implementation Checklist Not Emphasized in project-setup
**Time:** After local repo creation, before schema creation
**Doc Reference:** project-setup.md vs implementation-checklist.md
**Severity:** Major - Process Gap

**What happened:**
After creating local repository, I was about to create schemas. But implementation-checklist.md says I must:
- Read ALL recipes FIRST (graphql-crud, iam-business-mapping, etc.)
- THEN create schemas

**Doc says (project-setup.md Step 4):**
```python
# Step 4: Backend Setup
create_schema(schema_name="YourEntity")
```

**Reality (implementation-checklist.md):**
```markdown
## Before ANY Implementation - Verify Prerequisites

- [ ] Read ALL recipes in llm-docs/recipes/
  - graphql-crud.md (MANDATORY)
  - iam-to-business-data-mapping.md (if multi-user app)

- [ ] Created schemas with MCP tools
```

**Why I almost skipped it:**
1. project-setup.md jumps straight to schema creation
2. No mention of "read implementation-checklist first"
3. No link to recipes before schema step
4. Implementation-checklist exists but isn't in the critical path

**Correct flow should be:**
1. Create project and local repo
2. **READ implementation-checklist.md**
3. **READ required recipes**
4. Create schemas (with knowledge from recipes)
5. Implement features

**Suggestion:**
Add to project-setup.md Step 4:
```markdown
### Step 4: Pre-Implementation (REQUIRED)
**STOP! Before creating schemas, read:**
- implementation-checklist.md
- graphql-crud.md
- iam-business-mapping.md (if multi-user)
```

---

### Issue #11: implementation-checklist Says "Read ALL Recipes" Upfront
**Time:** After local repo creation, before schema creation
**Doc Reference:** implementation-checklist.md
**Severity:** Major - Wrong Guidance

**What happened:**
implementation-checklist says:
```markdown
- [ ] Read ALL recipes in llm-docs/recipes/
  - graphql-crud.md (MANDATORY)
  - confirmation-modal-patterns.md
  - react-hook-form-integration.md
  - iam-to-business-data-mapping.md (if multi-user app)
  - permissions-and-roles.md (if multi-user app)
```

**Reality:**
You don't need ALL recipes upfront. You need them when implementing that feature:
- graphql-crud → Before schemas (understand data model)
- iam-business-mapping → Before schemas (multi-user apps only)
- confirmation-modal → When implementing delete
- react-hook-form → When implementing forms
- permissions-roles → Only if you need role-based access (not just multi-user!)

**Why this is wrong:**
1. Wastes time reading docs you don't need yet
2. Information overload - hard to remember everything
3. Some recipes might not be needed at all for your app
4. list_sections metadata is smarter with conditional requirements

**Suggestion:**
Change to: "Read recipes as needed during implementation. Check list_sections metadata to find relevant docs for your features."

---


### Issue #12: graphql-crud Recipe Says curl is MANDATORY But Unclear When/Why
**Time:** After schema creation, before implementation
**Doc Reference:** graphql-crud.md
**Severity:** Major - Confusing Guidance

**What happened:**
graphql-crud recipe has entire section "Testing with curl Requests (MANDATORY Safety Check)" that says:

> **🚨 CRITICAL: Always test your GraphQL operations with curl BEFORE implementing in code!**

**Reality:**
- curl is for testing GraphQL QUERIES and MUTATIONS, not schemas
- Schemas are already created via MCP
- The recipe makes it sound like you MUST curl before ANY implementation
- But you cant curl until you have data and queries to test
- Creates confusion about workflow order

**What confused me:**
1. Recipe says curl is "MANDATORY" with 🚨 warnings
2. Placed right after schema naming sections
3. But curl needs actual queries/mutations which come during implementation
4. Cant test empty schemas with curl

**Correct understanding:**
- Schemas are created via MCP (done)
- curl is for testing your GraphQL operations DURING implementation
- Not mandatory BEFORE starting implementation
- Optional safety check when building queries/mutations

**Suggestion:**
1. Move curl section later in recipe (after implementation examples)
2. Change "MANDATORY BEFORE implementing" to "RECOMMENDED during implementation"
3. Clarify: "Use curl to test each query/mutation as you build them"
4. Or make it clear its optional

---



### Issue #13: Docs Say "features" But Actual Codebase Uses "modules"
**Time:** Starting implementation
**Doc Reference:** architecture-patterns.md, constructs-structure.md
**Severity:** Major - Wrong Path

**What happened:**
All documentation says to create features in `src/features/[feature-name]/` but the actual generated project uses `src/modules/`.

**Docs say:**
```
src/features/[feature-name]/
├── components/
├── graphql/
├── hooks/
├── services/
└── types/
```

**Reality in generated project:**
```
src/modules/[module-name]/
├── component/        (singular!)
├── graphql/
├── hooks/
├── pages/           (not in docs!)
├── services/
└── types/
```

**Additional discrepancies:**
- Docs: `components/` (plural)
- Reality: `component/` (singular)
- Docs: No `pages/` folder mentioned
- Reality: Has `pages/` folder

**Impact:**
Following docs exactly would create wrong folder structure that doesnt match the generated project.

**Suggestion:**
1. Update all docs to use `modules` not `features`
2. Clarify `component` vs `components` (singular)
3. Document the `pages/` folder purpose

---

### Issue #14: No React Query Hooks Recipe - Had to Explore Codebase Extensively
**Time:** Starting hooks implementation
**Doc Reference:** list_sections (missing recipe), constructs-structure.md
**Severity:** Major - Missing Critical Documentation

**What happened:**
Need to create React hooks for todos module. Called list_sections but there's no recipe for hooks/React Query patterns. Had to extensively explore codebase to understand patterns.

**What docs provided:**
- `constructs-structure.md` - Basic pattern but minimal details:
  ```typescript
  export const useYourData = (params) => {
    return useGlobalQuery({
      queryKey: ['your-data', params],
      queryFn: getYourData,
    });
  };
  ```

**What was missing - needed new recipe: `react-query-patterns.md`**

Should cover:

1. **Complete hook templates with all required code:**
   ```typescript
   // Query hook template
   export const useGetYourData = (params: YourParams & { userId: string }) => {
     const { toast } = useToast();
     const { t } = useTranslation();

     return useGlobalQuery({
       queryKey: ['your-data', params],
       queryFn: async ({ queryKey }) => getYourData({ queryKey }),
       staleTime: 5 * 60 * 1000,    // When to mark stale
       gcTime: 10 * 60 * 1000,       // Cache time
       retry: 2,
       retryDelay: (attempt) => Math.min(attempt * 1000, 3000),
       onError: (error) => {
         toast({ variant: 'destructive', title: t('ERROR'), description: t('MSG') });
       }
     });
   };

   // Mutation hook template
   export const useCreateYourData = () => {
     const queryClient = useQueryClient();
     const { toast } = useToast();
     const { handleError } = useErrorHandler();
     const { t } = useTranslation();

     return useGlobalMutation({
       mutationFn: (input: YourInput) => createYourData(input),
       onSuccess: () => {
         queryClient.invalidateQueries({
           predicate: (query) => query.queryKey[0] === 'your-data'
         });
         toast({ variant: 'success', title: t('SUCCESS') });
       },
       onError: (error) => handleError(error)
     });
   };
   ```

2. **Required imports section:**
   ```typescript
   import { useGlobalQuery, useGlobalMutation } from 'state/query-client/hooks';
   import { useQueryClient } from '@tanstack/react-query';
   import { useToast } from 'hooks/use-toast';
   import { useErrorHandler } from 'hooks/use-error-handler';
   import { useTranslation } from 'react-i18next';
   ```

3. **Query invalidation patterns:**
   - Exact key: `queryClient.invalidateQueries({ queryKey: ['your-data'] })`
   - Predicate: `queryClient.invalidateQueries({ predicate: (q) => q.queryKey[0] === 'your-data' })`
   - Refetch: `queryClient.refetchQueries({ predicate: ..., type: 'active' })`
   - Multiple related: When to invalidate multiple query keys

4. **Error handling approaches:**
   - When to use `handleError` vs manual toast
   - How useGlobalQuery vs useGlobalMutation handle errors differently
   - Global error handling already built in

5. **Data isolation for multi-user apps:**
   - How to pass userId through queryKey: `queryKey: ['todos', { userId, pageNo, pageSize }]`
   - Why userId filtering happens at SERVICE layer, not in hooks
   - Security: userId in mutation filters

6. **Standard configurations:**
   - Default: `retry: 2, staleTime: 5min, gcTime: 10min, refetchOnWindowFocus: false`
   - When to deviate
   - Performance considerations

7. **Real examples for common operations:**
   - List query with pagination
   - Single item query by ID
   - Create mutation
   - Update mutation with partial data
   - Delete mutation (soft vs hard delete)

**What I had to do instead:**
1. Called `list_sections` - no hooks recipe found
2. Read `constructs-structure` - only basic pattern
3. Spawned Plan agent to explore actual codebase
4. Agent read 5+ files:
   - `/src/state/query-client/hooks.tsx` (base wrappers)
   - `/src/modules/invoices/hooks/use-invoices.ts` (example)
   - `/src/modules/task-manager/hooks/use-task-manager.ts` (example)
   - `/src/hooks/use-error-handler.ts` (error patterns)
   - `/src/modules/todos/services/todos.service.ts` (userId isolation)
5. Compiled patterns from multiple sources
6. Created mental model of correct approach

**Time wasted:**
~15-20 minutes exploring instead of immediate implementation

**Ideal flow should have been:**
1. User: "implement hooks"
2. Call `list_sections`, find `react-query-patterns` recipe
3. Call `get_documentation(['react-query-patterns'])`
4. Have complete templates, imports, patterns, examples
5. Implement immediately - no exploration needed

**Impact:**
- Slows down development significantly
- Risk of missing patterns (what if I didn't explore thoroughly?)
- Inconsistent implementations across projects
- New developers would struggle even more

**Suggestion:**
Create `recipes/react-query-patterns.md` with:
- Hook creation templates (query + mutation)
- All required imports
- Query invalidation strategies
- Error handling patterns
- Data isolation for multi-user apps
- Standard configurations
- Real-world examples for CRUD operations
- When to use useGlobalQuery vs useQuery directly
- Performance best practices

This should be a **CRITICAL** priority recipe since hooks are required for every feature.

---

### Issue #15: Not Updating Tracking Files During Implementation - Workflow Not Clear or Enforced
**Time:** During hooks implementation (Issue #14 discovery)
**Doc Reference:** feature-planning.md, dev-workflow.md
**Severity:** Critical - Core Workflow Violation

**What happened:**
Have been implementing the todo app (schemas, services, hooks) but NEVER updated FEATURELIST.md, TASKS.md, or SCRATCHPAD.md after initial creation. This violates the documented workflow.

**What docs say:**

**feature-planning.md:**
> **When to Update FEATURELIST.md:**
> - ✅ Task completion: When all TASKS.md items for a feature are complete
> - ✅ Scope changes: When user adds/removes/modifies features
> - ✅ Feature discovery: When implementation reveals new requirements

> **Update tracking files continuously**

**dev-workflow.md:**
> **TASKS.md** - Update IMMEDIATELY when:
> - Starting a task: `[ ]` → `[🔄]`
> - Completing a task: `[🔄]` → `[x]`
> - Discovering sub-tasks: Add below parent task
> - Encountering blockers: Add `[⚠️]` and note in SCRATCHPAD.md

> **SCRATCHPAD.md** - Update CONTINUOUSLY:
> - Every decision made
> - Every error encountered and fix
> - Every insight or pattern discovered
> - Format: `[timestamp] Topic: Details`

> **Commit after EVERY task completion**

**Reality - What I actually did:**
1. Created tracking files initially (FEATURELIST.md, TASKS.md, SCRATCHPAD.md, CLOUD.md)
2. Then NEVER updated them during implementation
3. Completed 14 tasks but tracking files still show initial state
4. Used TodoWrite tool instead (which is good) but didn't update the .md files
5. No commits made yet (violates "commit after EVERY task completion")

**Why I didn't update them:**
1. **Not emphasized in CLAUDE.md** - Our session notes don't mention updating tracking files
2. **Docs are in get_documentation** - Had to be reminded to read them
3. **No enforcement** - Nothing stops me from skipping updates
4. **TodoWrite tool exists** - I used that instead of .md files
5. **Unclear relationship** - How do TodoWrite and tracking .md files relate?
6. **Workflow not in immediate context** - Docs are fetched, not in CLAUDE.md

**What should happen:**
CLAUDE.md should include a **"Continuous Update Workflow"** section that's ALWAYS visible:

```markdown
## Continuous Update Workflow (MANDATORY)

**After EVERY task:**
1. Update TASKS.md: `[ ]` → `[🔄]` when starting, `[🔄]` → `[x]` when done
2. Update SCRATCHPAD.md: Add notes with `[timestamp] What you did`
3. git add all changes (code + tracking files)
4. git commit with descriptive message
5. Move to next task

**After EVERY feature complete:**
1. Update FEATURELIST.md: Mark feature `[x]`
2. Update CLOUD.md: If schemas/config changed
3. Review all related TASKS.md items are `[x]`
4. Major commit with feature summary

**Never skip these - they're your source of truth!**
```

**Impact:**
- Can't track what was actually done vs what was planned
- No git commit history (violates workflow)
- Tracking files are stale and useless
- Can't demonstrate following the workflow properly
- Defeats purpose of testing if workflow is correct

**Suggestion:**
1. Add "Continuous Update Workflow" section to CLAUDE.md template
2. Make it visible without fetching docs
3. Clarify relationship between TodoWrite tool and tracking .md files
4. Add enforcement reminder: "Have you updated tracking files?" after each task
5. Make git commit workflow clearer - when exactly to commit
6. Consider: Should I use TodoWrite OR tracking .md files, or BOTH?

**Next steps:**
1. Document this issue
2. Update CLAUDE.md with workflow reminder
3. Actually update all tracking files NOW with current progress
4. Make git commits for completed work

---

### Issue #16: Can't Assume Existing Modules Are Usable - Only Use Documented Components
**Time:** Starting todo list page implementation
**Doc Reference:** component-quick-reference.md, list_sections metadata
**Severity:** Critical - Architecture Guidance Missing

**What happened:**
About to build todo list page. Documentation mentions `AdvanceDataTable` from inventory module. Assumed I should use it since it exists in the codebase at `src/modules/inventory/component/advance-data-table/`.

**User feedback:**
"don't consider stuff in modules usable. only the components docs returns or we have guidance for."

**The problem:**
1. **Modules exist in codebase** (inventory, invoices, task-manager, etc.)
2. **Documentation references them** (component-quick-reference says "use AdvanceDataTable from inventory")
3. **But we can't just import from any module** - only use what docs explicitly tell us to use
4. **Unclear boundary:** What's safe to use vs what's internal/example code?

**What docs say:**

**component-quick-reference.md:**
```typescript
// Feature Components (Try First)
import { AdvanceDataTable } from 'features/inventory/component/advance-data-table/advance-data-table';
```

This makes it seem like inventory is a COMPONENT to use, not just a reference implementation.

**constructs-structure.md** (from previous context):
> This is reference only - use these components and reusable code as often as possible. don't copy inventory directly

This creates confusion: "use these components" vs "don't use inventory directly"

**The confusion:**
- If inventory AdvanceDataTable is documented in component-quick-reference, why can't I use it?
- Is inventory a:
  - ✅ **Component library** I should import from?
  - ❌ **Example/reference** I should NOT import from?
  - ✅ **Pattern to copy** but not import?

**What should be clear:**

**Option 1: Inventory IS a reusable component library**
- Document: "Import AdvanceDataTable from inventory module - it's a shared component"
- Make it clear inventory is a feature AND a component library
- Show proper import path

**Option 2: Inventory is ONLY a reference implementation**
- Document: "DON'T import from other modules"
- "Use component-catalog docs to find ui-kit components only"
- "Inventory shows patterns, but implement your own components"
- Update component-quick-reference to NOT show inventory imports

**What I need to know:**
1. Can I import AdvanceDataTable from inventory module? YES or NO?
2. If YES: What's the correct import path? (docs say `features/` but actual is `modules/`)
3. If NO: What SHOULD I use for data tables?
   - Build from scratch with ui-kit Table components?
   - Copy AdvanceDataTable into my todos module?
   - Use a different documented component?

**Current state:**
- Documentation says use AdvanceDataTable
- But it's in inventory module
- User says don't use modules unless documented
- AdvanceDataTable IS documented in component-quick-reference
- So... can I use it or not?

**Impact:**
- Blocks implementation - can't proceed without knowing what components are allowed
- Confusion about module boundaries and reusability
- Risk of wrong architecture decisions
- Unclear what list_sections/get_documentation should return for components

**Suggestion:**
Add clear guidance doc: **"Component Reusability Rules"**

Should cover:
1. **What you CAN import:**
   - `components/ui/*` - UI kit (always OK)
   - `components/core/*` - Block components (always OK)
   - `modules/[module-name]/components/*` - ??? (clarify this!)

2. **What you CANNOT import:**
   - Other feature's business logic
   - Other feature's services
   - Other feature's types (unless shared)

3. **Special cases:**
   - Is inventory/AdvanceDataTable reusable? YES/NO
   - If YES, document it in components/core or blocks
   - If NO, remove from component-quick-reference

4. **list_sections behavior:**
   - Should only return components that are safe to use
   - Or clearly mark: "Reference Only - Do Not Import"

**Next steps:**
1. Get clarification: Can I use AdvanceDataTable from inventory?
2. If yes: Use it with correct import path
3. If no: Find alternative documented component or build from ui-kit
4. Update tracking with decision

**Resolution:**
User confirmed: **DO NOT use components from other modules**. Only use what list_sections/get_documentation explicitly provides or guides to use.

---

### Issue #17: IAM-to-Business Mapping Approach is Inefficient
**Time:** During user provisioning implementation
**Doc Reference:** iam-business-mapping.md recipe
**Severity:** Major - Performance and Architecture Issue

**What happened:**
Implemented user provisioning following the iam-business-mapping recipe exactly. But the approach seems inefficient and has major problems.

**What the recipe says to do:**
1. On first login, auto-provision a User record in your business schema
2. Use email as the bridge between IAM user and business User record
3. Query business User by email every time you need userId
4. Filter all todos by userId reference

**The implementation pattern from recipe:**
```typescript
// Get IAM user info
const iamUser = await getIAMUserInfo(); // email, name

// Check if business User record exists
const existingUser = await queryUserByEmail(iamUser.email);

// If not, create it
if (!existingUser) {
  await createUserRecord({
    email: iamUser.email,
    name: iamUser.name
  });
}

// Now query again to get the userId
const user = await queryUserByEmail(iamUser.email);
const userId = user._id;

// Use userId to filter todos
const todos = await getTodos({ userId });
```

**Why this is inefficient:**

1. **Extra query on EVERY request:**
   - Every time user loads their todos, you query User schema by email FIRST
   - Then query Todos by userId
   - That's 2 database queries instead of 1
   - If you have 10 features, that's 11 queries (1 for user + 10 for features)

2. **Email lookup is slower than ID lookup:**
   - MongoDB is optimized for _id lookups
   - Email lookups require index scan or full table scan
   - No performance benefit vs using IAM userId directly

3. **Unnecessary business User schema:**
   - The User schema only stores email and name
   - Both already available from IAM
   - It's duplicate data with no additional business value
   - Only reason to have it: to get a userId to filter by

4. **Data duplication:**
   - Email stored in IAM
   - Email stored in User schema
   - If user changes email in IAM, business schema is stale
   - Need sync mechanism

**Better approach - Use IAM userId directly:**

```typescript
// Get IAM user info (already authenticated)
const iamUser = getAuthenticatedUser(); // has userId from IAM

// Filter todos directly by IAM userId
const todos = await getTodos({
  userId: iamUser.id  // IAM user ID
});

// Schema design:
// Todos schema: { title, status, userId (IAM user ID reference) }
// NO separate User schema needed!
```

**Benefits:**
- 1 query instead of 2+ queries
- Faster (direct _id lookup)
- No duplicate data
- No sync issues
- Simpler architecture
- IAM userId is globally unique already

**When you DO need a business User schema:**
- User has additional business properties: role, subscription, preferences, settings
- User-to-user relationships: friends, followers, teams
- User profile data: bio, avatar, timezone, etc.

**For simple multi-user apps (like todo):**
- You DON'T need User schema
- Just use IAM userId directly
- Store userId reference in business entities (Todos, Tasks, etc.)

**What recipe should say:**

**Option 1: Simple apps (no User schema needed)**
```typescript
// Just use IAM userId directly
const todos = await getTodos({ userId: iamUser.id });
```

**Option 2: Complex apps (User schema with business data)**
```typescript
// User schema stores: role, subscription, preferences, etc.
// Still reference by IAM userId, not email!
const user = await getUserByIAMId(iamUser.id); // 1 query
const todos = await getTodos({ userId: user._id });
```

**Impact:**
- Performance degradation on every request
- Unnecessary complexity in simple apps
- Teaches inefficient patterns
- Extra database queries = higher costs

**Suggestion:**
Rewrite iam-business-mapping recipe to:
1. Explain when you DON'T need a business User schema (most simple apps)
2. Show how to use IAM userId directly for filtering
3. Only introduce User schema when there's actual business data to store
4. If using User schema, reference by IAM userId, not email
5. Clarify: email bridging is for DISPLAY, not for querying

---

### Issue #18: Documentation Says "components/ui" But Actual Folder is "components/ui-kit"
**Time:** Starting component implementation
**Doc Reference:** component-quick-reference.md, all component docs
**Severity:** Major - Wrong Import Paths

**What happened:**
All documentation shows imports from `components/ui/*` but the actual folder in the generated project is `components/ui-kit/`.

**What docs say everywhere:**
```typescript
import { Button } from 'components/ui/button';
import { Input } from 'components/ui/input';
import { Card, CardContent } from 'components/ui/card';
import { Table, TableBody } from 'components/ui/table';
```

**Reality in actual codebase:**
```typescript
import { Button } from 'components/ui-kit/button';
import { Input } from 'components/ui-kit/input';
import { Card, CardContent } from 'components/ui-kit/card';
import { Table, TableBody } from 'components/ui-kit/table';
```

**Where this appears:**
- component-quick-reference.md (all examples)
- All component documentation from list_sections
- CLAUDE.md examples
- All recipes that show component imports

**Impact:**
- Every single import path in docs is wrong
- Copy-paste from docs = import errors
- Have to manually fix every import
- Confusing for developers following docs

**Additional confusion:**
Is it:
- `components/ui/` (as docs say) ❌
- `components/ui-kit/` (actual folder) ✅
- Both exist? (need to check)
- Alias configured somewhere?

**Suggestion:**
1. Search-replace all docs: `components/ui/` → `components/ui-kit/`
2. Or rename folder: `components/ui-kit/` → `components/ui/`
3. Check if path alias exists that makes both work
4. Be consistent across all documentation

---

### Issue #19: Don't Import from Other Modules - Make This Clear in Docs
**Time:** Starting todo list implementation
**Doc Reference:** component-quick-reference.md, architecture docs
**Severity:** Critical - Architecture Boundary Violation

**What happened:**
Documentation shows importing from other modules (inventory, invoices) but user clarified we should NOT do this.

**What docs show:**
```typescript
// Feature Components (Try First)
import { AdvanceDataTable } from 'features/inventory/component/advance-data-table/advance-data-table';
import { AdvancedTableColumnsToolbar } from 'features/inventory/component/advance-table-columns-toolbar/advance-table-columns-toolbar';
```

This makes it seem like cross-module imports are encouraged.

**User clarification:**
"avoid using modules. only the components docs returns or we have guidance for."

**Reality:**
- DON'T import from other modules (inventory, invoices, task-manager, etc.)
- ONLY use components from:
  - `components/ui-kit/*` - UI foundation
  - `components/core/*` - Block components
  - What list_sections explicitly returns as usable components

**Why cross-module imports are bad:**
1. **Tight coupling** - Your module depends on inventory module
2. **Breaking changes** - If inventory changes, your module breaks
3. **Deployment issues** - Need inventory code even if not using inventory feature
4. **Bundle size** - Importing unused module code
5. **Module boundaries** - Each module should be independent

**What should be documented:**

**Module Import Rules:**

✅ **ALLOWED:**
```typescript
// UI Kit (always OK)
import { Button } from 'components/ui-kit/button';

// Core/Block components (always OK)
import { ConfirmationModal } from 'components/core/confirmation-modal';

// Your own module's code
import { TodoService } from '../services/todos.service';
```

❌ **NOT ALLOWED:**
```typescript
// Other modules' components
import { AdvanceDataTable } from 'modules/inventory/component/advance-data-table';

// Other modules' services
import { InventoryService } from 'modules/inventory/services';

// Other modules' types
import { InventoryItem } from 'modules/inventory/types';
```

**What to do instead:**
- Use ui-kit and core components
- If you need complex component (like AdvanceDataTable), either:
  - Copy the pattern to your module
  - Request it be moved to components/core for reuse
  - Build from ui-kit primitives

**Impact:**
- Component-quick-reference.md teaches wrong pattern
- Developers will create tightly coupled modules
- Architecture violations
- Hard to maintain and test

**Suggestion:**
1. Remove all cross-module imports from component-quick-reference
2. Only show imports from `components/ui-kit/` and `components/core/`
3. Add "Module Boundaries" section to architecture docs
4. Clarify: inventory is REFERENCE ONLY, don't import from it
5. Update constructs-structure.md to emphasize this
6. Make list_sections only return truly reusable components

---

### Issue #20: list_sections Returns data-table Component But Documentation File Missing (404)
**Time:** Trying to get data-table documentation
**Doc Reference:** list_sections metadata, get_documentation
**Severity:** Critical - Missing Documentation

**What happened:**
Called `list_sections` which returned `data-table` component as available with "critical" priority.

Then called `get_documentation(['data-table'])` but got 404 error:
```
Failed to fetch content: Client error '404 Not Found' for url
'https://raw.githubusercontent.com/mustavikhan05/selise-blocks-docs/master/components/core/data-table.md'
```

**Reality:**
- list_sections says data-table exists and is "critical" priority  
- The actual component files exist in the codebase at `components/core/data-table/`
- But the documentation file doesn't exist on GitHub
- Can't get documentation on how to use it

**Impact:**
- Can't follow "list_sections → get_documentation" workflow
- Component exists but no usage guide
- Have to reverse-engineer from code instead of following docs
- Breaks the intended documentation discovery flow

**What should happen:**
If list_sections returns a component, get_documentation MUST be able to fetch it. Either:
1. Create the missing data-table.md file
2. Remove data-table from list_sections if docs don't exist  
3. Mark it as "undocumented" in list_sections metadata

**Files that DO exist in codebase:**
- `/components/core/data-table/data-table.tsx` ✅
- `/components/core/data-table/data-table-pagination.tsx` ✅
- `/components/core/data-table/data-table-column-header.tsx` ✅
- `/components/core/data-table/data-table-view-options.tsx` ✅
- `/components/core/data-table/data-table-faceted-filter.tsx` ✅
- `/components/core/data-table/data-table-date-filter.tsx` ✅

**Current workaround:**
Will read the actual TypeScript files to understand usage patterns.

**Suggestion:**
1. Add data-table.md documentation file
2. Or update list_sections to mark components without docs
3. Add validation: list_sections shouldn't return topics where docs don't exist

---

