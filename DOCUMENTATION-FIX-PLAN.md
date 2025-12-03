# Selise Blocks Documentation Fix Plan

**Date:** 2025-12-04
**Repository:** `/Users/mustavikhan/Developer/selise/selise/selise-blocks-docs/`
**Branch:** dev
**Goal:** Eliminate ALL 55+ issues and conflicts found during todo app testing

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current State Analysis](#current-state-analysis)
3. [Root Cause Analysis](#root-cause-analysis)
4. [Proposed Solution](#proposed-solution)
5. [Detailed File Changes](#detailed-file-changes)
6. [Validation Plan](#validation-plan)

---

## Executive Summary

### Problem Statement

During todo app testing session, discovered:
- **25+ conflicts** between workflow documents
- **30+ implementation issues** (build-time + runtime)
- **Critical documentation gaps** (missing recipes, wrong patterns)
- **59 component docs referenced but missing** from repository
- **No enforcement** of MCP list_sections → get_documentation workflow
- **CLAUDE.md doesn't enforce** blocking steps (agent skipped critical steps)

### Solution Overview

1. **Rewrite CLAUDE.md** (114 lines → 80 lines) with BLOCKING STEPS and ✋ STOP checkpoints
2. **Fix all conflicts** by choosing single source of truth for each topic
3. **Update graphql-crud.md** with critical gotchas (query naming, DateTime, pagination)
4. **Create 3 missing recipes** (react-query-patterns, schema-design-guide, component-reusability)
5. **Merge redundant workflows** (combine user-interaction + feature-planning)
6. **Fix topics.json** to mark missing component references or document their status
7. **Fix folder structure references** (features → modules, components → component)

### Success Metrics

- ✅ **0 workflow conflicts** (single source of truth)
- ✅ **0 critical issues missed** (gotchas checklist)
- ✅ **100% MCP workflow compliance** (STEP 0 enforced)
- ✅ **Copy-paste works** (correct import paths, folder structure)
- ✅ **Self-enforcing** (agent cannot skip critical steps)

---

## Current State Analysis

### Repository Structure

```
selise-blocks-docs/
├── CLAUDE.md                    ✅ EXISTS (114 lines)
├── topics.json                  ✅ EXISTS (1,342 lines, 76 topics)
├── README.md                    ✅ EXISTS
├── workflows/                   ✅ EXISTS
│   ├── project-setup.md/.txt
│   ├── user-interaction.md/.txt
│   ├── feature-planning.md/.txt
│   ├── implementation-checklist.md/.txt
│   └── dev-workflow.md/.txt
├── recipes/                     ✅ EXISTS
│   ├── graphql-crud.md/.txt
│   ├── confirmation-modal-patterns.md/.txt
│   ├── react-hook-form-integration.md/.txt
│   ├── iam-to-business-data-mapping.md/.txt
│   └── permissions-and-roles.md/.txt
├── component-catalog/           ✅ EXISTS
│   ├── component-quick-reference.md/.txt
│   ├── selise-component-hierarchy.md/.txt
│   └── constructs-structure.md/.txt
├── architecture/                ✅ EXISTS
│   ├── patterns.md/.txt
│   ├── pitfalls.md/.txt
│   └── constructs-structure.md/.txt
├── agent-instructions/          ✅ EXISTS
│   └── selise-development-agent.md/.txt
└── components/                  ❌ MISSING (59 files referenced in topics.json)
    ├── core/                    ❌ MISSING (25 component docs)
    └── ui-kit/                  ❌ MISSING (34 component docs)
```

### Critical Discovery: Missing Component Documentation

**topics.json** references 59 component documentation files:
- 25 core components: `components/core/data-table.md`, `components/core/confirmation-modal.md`, etc.
- 34 ui-kit components: `components/ui-kit/button.md`, `components/ui-kit/form.md`, etc.

**BUT:** The `components/` directory does not exist in the repository!

**Impact:**
- `get_documentation(['data-table'])` returns 404 error
- Breaks intended MCP workflow (list_sections → get_documentation)
- Developer cannot get detailed component usage docs

**Resolution Options:**
1. Create all 59 missing component docs (HIGH EFFORT)
2. Update topics.json to mark components as "see codebase" (MEDIUM EFFORT)
3. Remove component entries from topics.json entirely (LOW EFFORT but loses discoverability)

**RECOMMENDED:** Option 2 - Update topics.json to add `"status": "reference_only"` flag

---

## Root Cause Analysis

### 1. Why Agent Didn't Follow MCP Workflow

**Root Cause:** CLAUDE.md is SUGGESTIVE, not ENFORCING

**Current CLAUDE.md (lines 8-12):**
```markdown
1. **ALWAYS call `list_sections` FIRST** - before ANY `get_documentation` call
2. Analyze the `use_cases` and all other fields to find what you need
3. Then call `get_documentation` with the topics relevant for you for the next task
```

**Problem:**
- Uses "ALWAYS" but no blocking mechanism
- No STEP 0 that must be completed first
- No ✋ STOP checkpoint to enforce
- Agent can skip to implementation without penalty

**Evidence:**
- Agent didn't call list_sections during test session
- Jumped directly to implementation
- Discovered patterns by reading codebase instead of docs

---

### 2. Why Conflicts Happened Between Docs

**Root Cause:** Multiple docs defining same workflow without single source of truth

**Workflow Defined In:**
1. `project-setup.md` - 5-step process ending with "proceed to implementation"
2. `feature-planning.md` - Says "STOP - do not start implementing yet"
3. `user-interaction.md` - Says "create tracking files immediately (step 1)"
4. `project-setup.md` - Says "create tracking files (step 2)"

**Result:** 4 different timings for same action → agent confused which to follow

**Evidence from test session:**
- Tracking files created AFTER reading docs (wrong order)
- Implementation started without user confirmation
- Multi-user detection missed (asked after schemas)

---

### 3. Why Critical Technical Details Were Missed

**Root Cause:** Gotchas buried in long recipe docs, not in quick reference

**Critical Details Only in Recipes:**
1. **"get" prefix** - Only in graphql-crud.md line ~18 (buried in prose)
2. **DateTime ISO format** - NOT DOCUMENTED ANYWHERE
3. **Pagination 1-based** - NOT DOCUMENTED ANYWHERE
4. **@/ import prefix** - Scattered across recipes, no central reference
5. **Response extraction pattern** - Only discoverable by reading invoices module

**Problem:**
- CLAUDE.md doesn't have "Critical Gotchas" checklist
- Agent must read entire recipe to find one-line gotcha
- No quick reference for common issues

**Evidence from test session:**
- Issue #22: Query naming (10 min debugging)
- Issue #23: DateTime format (5 min debugging)
- Issue #24: Pagination (15 min debugging with cryptic error)

---

### 4. Why Task Tracking Not Followed

**Root Cause:** Tracking file creation in wrong place in workflow

**Current State:**
- Mentioned in `user-interaction.md` (must read doc to discover)
- Not in CLAUDE.md workflow
- No enforcement that files exist before proceeding

**Problem:**
- Circular dependency: Need to read docs to know to create tracking files
- But tracking files should exist BEFORE reading docs
- Agent can skip entirely

**Evidence from test session:**
- Issue #15: Tracking files not updated during implementation
- Files became stale showing "schemas not created" when actually at hooks stage

---

### 5. Why Workflow Sequence Was Unclear

**Root Cause:** Too many docs defining workflow with different step numbers

**Conflicting Sequences:**

**project-setup.md:**
1. Read docs
2. Create tracking files
3. Ask user
4. Authenticate
5. Create schemas
6. Implement

**user-interaction.md:**
1. Create tracking files
2. Ask user
3. Confirm
4. Then schemas

**feature-planning.md:**
1. Analyze features
2. Design schemas
3. STOP (don't implement)

**Problem:**
- Same action ("create tracking files") is step 1, step 2, or unstated
- Same action ("implement") is step 6, unstated, or explicitly forbidden
- No clear "STEP 0 through STEP 5" sequence

---

## Proposed Solution

### Solution Architecture

**Principle:** Separation of Concerns

1. **CLAUDE.md** (80 lines max)
   - ONLY workflow enforcement with BLOCKING STEPS
   - Critical Gotchas checklist (top 15 issues)
   - NEVER DO list
   - Priority order when conflicts arise
   - ❌ NO implementation details

2. **Fetched Documentation** (workflows + recipes)
   - Detailed implementation patterns
   - Code examples
   - Advanced use cases
   - ❌ NO workflow enforcement (delegate to CLAUDE.md)

3. **Single Source of Truth Per Topic**
   - GraphQL → graphql-crud.md ONLY
   - Forms → react-hook-form-integration.md ONLY
   - Workflow → NEW workflows/workflow.md (merged file)
   - ❌ Remove redundant definitions

---

### New CLAUDE.md Structure (80 lines)

```markdown
# Selise Blocks - Official MCP Server

## 🚨 BLOCKING WORKFLOW (MUST FOLLOW IN ORDER)

### STEP 0 (BLOCKING): Fetch Documentation via MCP
```
BEFORE doing ANYTHING:
1. Call mcp__selise__list_sections()
2. Analyze use_cases metadata to find relevant sections
3. Call mcp__selise__get_documentation([...all_relevant_sections])
4. Read ALL fetched documentation thoroughly
✋ STOP: Do NOT proceed until all docs read
```

### STEP 1 (BLOCKING): Create Tracking Files
```
bash
touch FEATURELIST.md TASKS.md SCRATCHPAD.md CLOUD.md
✋ STOP: Verify all 4 files created before proceeding
```

### STEP 2 (BLOCKING): User Interaction
```
1. Ask ALL clarifying questions (see fetched workflow.md)
2. Document requirements in FEATURELIST.md
3. Get explicit user confirmation: "Shall I proceed?"
✋ STOP: Do NOT implement without explicit confirmation
```

### STEP 3 (BLOCKING): Schema Planning
```
1. Analyze features → determine required schemas
2. Document schema plan in CLOUD.md
3. Call MCP list_schemas() to check existing
4. Call MCP create_schema() for each new schema
5. Document all MCP operations in CLOUD.md
✋ STOP: Verify all schemas created before implementation
```

### STEP 4: Implementation
```
Follow patterns from fetched documentation
Update TASKS.md continuously as you work
Reference graphql-crud.md for ALL data operations
```

## 🔥 CRITICAL GOTCHAS CHECKLIST

### GraphQL Operations (MANDATORY CHECKS)
Before EVERY GraphQL operation:
- [ ] Query field uses lowercase "get" prefix: getTodoTasks (NOT TodoTasks)
- [ ] Mutation uses operation + SchemaName: insertTodoTask
- [ ] DateTime fields use ISO format: new Date().toISOString()
- [ ] Pagination is 1-based: pageNo: 1 for first page (NOT 0)
- [ ] Filter uses _id for queries (NOT ItemId)
- [ ] Response extraction: result.data?.getTodoTasks || result.getTodoTasks

### Imports & Structure (MANDATORY CHECKS)
Before EVERY import:
- [ ] ALL imports use @/ prefix: @/components/ui-kit/button
- [ ] Folder structure: src/modules/[name]/component/ (singular)
- [ ] Import graphqlClient from @/lib/graphql-client

### Components (MANDATORY CHECKS)
Before creating components:
- [ ] Use DataTable from @/components/core/data-table
- [ ] Use ConfirmationModal from @/components/core/confirmation-modal
- [ ] Forms use React Hook Form + Zod validation
- [ ] NO cross-module imports (modules/inventory/* is reference-only)

## 🚫 NEVER DO
- Skip MCP list_sections (STEP 0)
- Implement without user confirmation
- Use uppercase "Get" in queries (use lowercase "get")
- Use ItemId in filters (use _id)
- Import from other modules (cross-module forbidden)
- Create tracking files AFTER implementation

## 📖 PRIORITY ORDER
When conflicts arise:
1. This file (CLAUDE.md) - workflow enforcement
2. MCP-fetched documentation - implementation patterns
3. Nothing else matters

## 🔧 MCP TOOLS AVAILABLE
- list_sections() - Discover all topics
- get_documentation(topics) - Fetch docs
- 33 Selise Cloud API tools (authentication, schemas, IAM, etc.)

**Remember:** Follow BLOCKING STEPS in order. Each ✋ STOP requires verification.
```

---

## Detailed File Changes

### Phase 1: CRITICAL - Rewrite CLAUDE.md

**File:** `/Users/mustavikhan/Developer/selise/selise/selise-blocks-docs/CLAUDE.md`

**Current:** 114 lines, suggestive language
**Target:** 80 lines, blocking enforcement

**Changes:**
1. Replace entire file with new structure above
2. Add STEP 0-4 with ✋ STOP checkpoints
3. Add Critical Gotchas Checklist (15 items)
4. Add NEVER DO list (6 items)
5. Add Priority Order section
6. Remove all implementation details (delegate to recipes)

**Validation:**
- Line count ≤ 80 lines
- Has exactly 4 BLOCKING STEPS
- Has exactly 4 ✋ STOP checkpoints
- Gotchas checklist covers all 30+ test issues

---

### Phase 2: CRITICAL - Fix graphql-crud.md

**File:** `/Users/mustavikhan/Developer/selise/selise/selise-blocks-docs/recipes/graphql-crud.md`

**Issues to Fix:**
1. Double 's' typo in response structure
2. Missing emphasis on lowercase "get" prefix
3. Missing DateTime format requirement
4. Missing pagination 1-based documentation
5. Missing response extraction pattern
6. Wrong import paths (if any)

**Specific Changes:**

**Change 1: Add Query Naming Section (after line ~15)**
```markdown
## ⚠️ CRITICAL: Query Naming Convention

GraphQL queries MUST use lowercase "get" prefix:

**Schema Name:** TodoTask
**Query Field:** getTodoTasks (lowercase "get" + schema name + "s")
**Mutation Field:** insertTodoTask (operation + schema name)

### Common Mistake
❌ WRONG: `query { TodoTasks(input: $input) { ... } }`
✅ CORRECT: `query { getTodoTasks(input: $input) { ... } }`

⚠️ **Warning:** Selise Cloud UI shows "GetTodoTasks" with capital G - IGNORE IT!
Always use lowercase "get" in your code.
```

**Change 2: Fix Response Structure Typo**
- Find: `result.[schema]ss.items` (double s)
- Replace: `result.[schema]s.items` (single s)
- Verify all examples use correct structure

**Change 3: Add DateTime Section**
```markdown
## DateTime Format Requirement

GraphQL expects ISO 8601 format for DateTime fields.

### HTML Date Input → GraphQL
```typescript
// HTML input returns: "2024-01-20"
// GraphQL expects: "2024-01-20T10:30:00Z"

const formattedData = {
  ...data,
  dueDate: data.dueDate ? new Date(data.dueDate).toISOString() : undefined
}
```

### GraphQL → HTML Date Input
```typescript
// For editing existing records
const defaultValues = {
  dueDate: todo.dueDate
    ? new Date(todo.dueDate).toISOString().split('T')[0]
    : ''
}
```
```

**Change 4: Add Pagination Section**
```markdown
## Pagination is 1-Based

GraphQL pagination starts at 1, NOT 0.

### React Table (0-based) → GraphQL (1-based)
```typescript
// React Table state
const [pageIndex, setPageIndex] = useState(0) // First page = 0

// Convert for GraphQL
const { data } = useGetTodos({
  userId,
  pageNo: pageIndex + 1,  // Add 1 to convert to 1-based!
  pageSize: 10
})
```

**Common Error:**
Sending `pageNo: 0` causes "Unexpected Execution Error"
```

**Change 5: Add Response Extraction Section**
```markdown
## Response Extraction Pattern

GraphQL responses need unwrapping before returning to hooks.

```typescript
export const getUserTodos = async (params: GetTodosParams) => {
  const response = await graphqlClient.query({
    query: GET_TODOS_QUERY,
    variables: { input: params }
  })

  // Extract data from wrapper
  const responseData = response?.data || response

  if (responseData && 'getTodoTasks' in responseData) {
    return responseData.getTodoTasks  // Return inner object
  }

  throw new Error('Invalid response structure')
}
```

**Why:** GraphQL responses can be `{ data: { getTodoTasks: {...} } }` or `{ getTodoTasks: {...} }`
```

**Change 6: Fix ALL Import Paths**
- Search for: `import { X } from 'components/`
- Replace with: `import { X } from '@/components/`
- Search for: `components/ui/`
- Replace with: `components/ui-kit/`

**Validation:**
- ✅ Query naming section added with warning
- ✅ Typo fixed (single 's' not double)
- ✅ DateTime section with examples
- ✅ Pagination section with examples
- ✅ Response extraction pattern documented
- ✅ All import paths use @/ prefix

---

### Phase 3: Merge Workflow Files

**Create:** `/Users/mustavikhan/Developer/selise/selise/selise-blocks-docs/workflows/workflow.md`

**Content:** Merge user-interaction.md + feature-planning.md into single authoritative workflow

**Structure:**
```markdown
# Complete Development Workflow

**Purpose:** Single source of truth for entire development process
**Read After:** CLAUDE.md STEP 2 (user interaction)

---

## Part 1: User Interaction & Requirements

[Content from user-interaction.md - question templates]

### Multi-User Detection
[Multi-user decision tree from user-interaction.md]

### Requirements Documentation
Document all answers in FEATURELIST.md before proceeding.

---

## Part 2: User Confirmation

Get explicit user confirmation with this exact question:
> "Based on these requirements, shall I proceed with implementation?"

✋ STOP: Do not continue without explicit "yes" or "proceed"

---

## Part 3: Feature Analysis & Schema Planning

[Content from feature-planning.md - schema analysis]

### Schema Design Process
1. Analyze each feature
2. Determine required data models
3. Design schema fields and types
4. Document in CLOUD.md

### Schema Field Types
- String, Number, Boolean, DateTime, Array
- Auto-generated: ItemId, CreatedDate, ModifiedDate

---

## Part 4: Schema Creation via MCP

[MCP schema creation steps from feature-planning.md]

Document all MCP operations in CLOUD.md:
- list_schemas() results
- create_schema() calls
- finalize_schema() confirmations

---

## Part 5: Implementation Preparation

After schemas created, read implementation recipes:
- graphql-crud.md (MANDATORY for data operations)
- react-hook-form-integration.md (if forms needed)
- confirmation-modal-patterns.md (if confirmations needed)

Then proceed to implementation following recipe patterns.
```

**Delete After Merge:**
- `workflows/user-interaction.md` (content merged)
- `workflows/feature-planning.md` (content merged)
- Corresponding `.txt` duplicates

**Update topics.json:**
- Remove entries for user-interaction and feature-planning
- Add entry for new workflow.md:
```json
{
  "id": "workflow",
  "title": "Complete Development Workflow",
  "category": "workflows",
  "priority": "critical",
  "read_order": 1,
  "use_cases": "always",
  "file_path": "workflows/workflow.md"
}
```

---

### Phase 4: Create Missing Recipes

#### Recipe 1: react-query-patterns.md

**Create:** `/Users/mustavikhan/Developer/selise/selise/selise-blocks-docs/recipes/react-query-patterns.md`

**Content:**
```markdown
# React Query Patterns for Selise Blocks

**When to Read:** MANDATORY before creating hooks for ANY feature
**use_cases:** always (every feature needs data management)

---

## Required Imports

```typescript
import { useGlobalQuery, useGlobalMutation } from '@/state/query-client/hooks'
import { graphqlClient } from '@/lib/graphql-client'
import { useToast } from '@/hooks/use-toast'
import { useErrorHandler } from '@/hooks/use-error-handler'
```

---

## Complete Hook Template

### Query Hook Pattern
```typescript
export const useGetTodos = (
  params: GetTodosParams,
  options?: { enabled?: boolean }
) => {
  return useGlobalQuery({
    queryKey: ['todos', params.userId, params.pageNo, params.pageSize],
    queryFn: async (context) => {
      const [, userId, pageNo, pageSize] = context.queryKey as readonly [
        string,
        string,
        number,
        number
      ]
      return getUserTodos({ userId, pageNo, pageSize })
    },
    enabled: options?.enabled ?? true,
  })
}
```

### Mutation Hook Pattern
```typescript
export const useAddTodo = () => {
  const { toast } = useToast()
  const queryClient = useQueryClient()

  return useGlobalMutation({
    mutationFn: async (params: AddTodoParams) => {
      return addTodo(params.input)
    },
    onSuccess: () => {
      // Invalidate queries with predicate
      queryClient.invalidateQueries({
        predicate: (query) => query.queryKey[0] === 'todos'
      })

      toast({
        title: 'Success',
        description: 'Todo created successfully',
      })
    },
    onError: (error) => {
      toast({
        title: 'Error',
        description: error.message,
        variant: 'destructive',
      })
    },
  })
}
```

---

## Query Invalidation Patterns

### Option 1: Exact Key Match
```typescript
queryClient.invalidateQueries({ queryKey: ['todos', userId] })
```

### Option 2: Predicate-Based (Recommended for complex filters)
```typescript
queryClient.invalidateQueries({
  predicate: (query) =>
    query.queryKey[0] === 'todos' &&
    query.queryKey[1] === userId
})
```

### Option 3: RefetchQueries (Immediate refetch)
```typescript
queryClient.refetchQueries({ queryKey: ['todos'] })
```

---

## Data Isolation for Multi-User Apps

Include userId in queryKey for proper data isolation:

```typescript
// ✅ CORRECT - userId in key
queryKey: ['todos', userId, pageNo]

// ❌ WRONG - missing userId
queryKey: ['todos', pageNo]
```

---

## Error Handling Approaches

### Approach 1: useErrorHandler Hook (Recommended)
```typescript
import { useErrorHandler } from '@/hooks/use-error-handler'

export const useGetTodos = (params: GetTodosParams) => {
  const { handleError } = useErrorHandler()

  return useGlobalQuery({
    queryKey: ['todos', params.userId],
    queryFn: () => getUserTodos(params),
    onError: handleError,
  })
}
```

### Approach 2: Manual Toast (For custom messages)
```typescript
onError: (error) => {
  toast({
    title: 'Failed to load todos',
    description: error.message,
    variant: 'destructive',
  })
}
```

---

## Complete Example: Todos Hooks

See full implementation pattern in test app:
`/modules/todos/hooks/use-todos.ts`

Includes:
- useGetTodos (paginated query)
- useGetTodoById (single item query)
- useAddTodo (create mutation)
- useUpdateTodo (update mutation)
- useDeleteTodo (delete mutation)
- useAutoProvisionUser (IAM bridging)
```

**Add to topics.json:**
```json
{
  "id": "react-query-patterns",
  "title": "React Query Patterns for Selise Blocks",
  "category": "recipes",
  "priority": "critical",
  "read_order": 6,
  "use_cases": "always",
  "file_path": "recipes/react-query-patterns.md"
}
```

---

#### Recipe 2: schema-design-guide.md

**Create:** `/Users/mustavikhan/Developer/selise/selise/selise-blocks-docs/recipes/schema-design-guide.md`

**Content:**
```markdown
# Schema Design Guide

**When to Read:** MANDATORY before creating ANY schemas
**use_cases:** always (every app has data models)

---

## Available Field Types

### Primitive Types
- **String** - Text data (names, descriptions, emails)
- **Number** - Numeric data (prices, quantities, IDs)
- **Boolean** - True/false flags
- **DateTime** - ISO 8601 timestamps
- **Array** - Lists of items

### Complex Types
- **Object** - Nested structures (address, metadata)
- **Reference** - Foreign keys to other schemas (userId)

---

## Auto-Generated Selise Fields

Every schema automatically includes these fields:

```typescript
interface SeliseBaseFields {
  ItemId: string          // Primary key (auto-generated UUID)
  CreatedDate: string     // ISO timestamp (auto-generated)
  ModifiedDate: string    // ISO timestamp (auto-updated)
  CreatedBy: string       // User who created (auto-set)
  ModifiedBy: string      // User who modified (auto-updated)
  IsDeleted: boolean      // Soft delete flag (auto-managed)
}
```

**Important:**
- DO NOT manually set these fields
- Use ItemId as primary key in UI
- Use _id for MongoDB filtering in queries

---

## Field Naming Conventions

### Use PascalCase for schema fields:
- ✅ CORRECT: `DueDate`, `TodoTitle`, `UserId`
- ❌ WRONG: `due_date`, `todoTitle`, `user_id`

### Use camelCase in TypeScript interfaces:
```typescript
interface Todo {
  itemId: string      // Maps to ItemId
  title: string       // Maps to Title
  dueDate: string     // Maps to DueDate
}
```

---

## Multi-User Schema Patterns

### Pattern 1: Simple Data Isolation
For apps where users only see their own data:

```json
{
  "schemaName": "TodoTask",
  "fields": [
    {
      "name": "Title",
      "type": "String",
      "required": true
    },
    {
      "name": "UserId",
      "type": "String",
      "required": true
    }
  ]
}
```

**Query Pattern:**
```graphql
query GetUserTodos($input: DynamicQueryInput) {
  getTodoTasks(input: $input) {
    items {
      ItemId
      Title
      UserId
    }
  }
}
```

**Filter:**
```typescript
variables: {
  input: {
    filter: { userId: currentUserId }
  }
}
```

---

## Common Schema Examples

### Example 1: User Schema (Business Records)
```json
{
  "schemaName": "User",
  "fields": [
    {
      "name": "Name",
      "type": "String",
      "required": true
    },
    {
      "name": "Email",
      "type": "String",
      "required": true
    },
    {
      "name": "IAMUserId",
      "type": "String",
      "required": true,
      "description": "Foreign key to IAM user itemId"
    }
  ]
}
```

### Example 2: TodoTask Schema
```json
{
  "schemaName": "TodoTask",
  "fields": [
    {
      "name": "Title",
      "type": "String",
      "required": true,
      "maxLength": 200
    },
    {
      "name": "Description",
      "type": "String",
      "required": false
    },
    {
      "name": "Status",
      "type": "String",
      "required": true,
      "default": "pending"
    },
    {
      "name": "Priority",
      "type": "String",
      "required": false
    },
    {
      "name": "Category",
      "type": "String",
      "required": false
    },
    {
      "name": "DueDate",
      "type": "DateTime",
      "required": false
    },
    {
      "name": "UserId",
      "type": "String",
      "required": true
    }
  ]
}
```

---

## Schema Planning Checklist

Before creating a schema:
- [ ] Identified all required fields
- [ ] Determined field types
- [ ] Marked required vs optional
- [ ] Added userId for multi-user data isolation
- [ ] Planned query filters
- [ ] Documented in CLOUD.md
```

**Add to topics.json:**
```json
{
  "id": "schema-design-guide",
  "title": "Schema Design Guide",
  "category": "recipes",
  "priority": "critical",
  "read_order": 4,
  "use_cases": "always",
  "file_path": "recipes/schema-design-guide.md"
}
```

---

#### Recipe 3: component-reusability-rules.md

**Create:** `/Users/mustavikhan/Developer/selise/selise/selise-blocks-docs/recipes/component-reusability-rules.md`

**Content:**
```markdown
# Component Reusability Rules

**When to Read:** MANDATORY before importing ANY component
**use_cases:** always (architectural boundaries)

---

## What You CAN Import

### ✅ Safe to Import

#### 1. UI-Kit Components
```typescript
import { Button } from '@/components/ui-kit/button'
import { Input } from '@/components/ui-kit/input'
import { Form } from '@/components/ui-kit/form'
```
**Source:** Shadcn/ui foundation components
**Guarantee:** Always safe, globally available

#### 2. Core Components
```typescript
import { DataTable } from '@/components/core/data-table/data-table'
import { ConfirmationModal } from '@/components/core/confirmation-modal/confirmation-modal'
```
**Source:** Custom Selise components
**Guarantee:** Always safe, globally available

#### 3. Your Own Module's Components
```typescript
// In modules/todos/pages/todos-list.tsx
import { TodoForm } from '../component/todo-form'
```
**Guarantee:** Safe within same module

#### 4. Global Hooks
```typescript
import { useGlobalQuery, useGlobalMutation } from '@/state/query-client/hooks'
import { useToast } from '@/hooks/use-toast'
import { useErrorHandler } from '@/hooks/use-error-handler'
```
**Guarantee:** Always safe, globally available

---

## What You CANNOT Import

### ❌ FORBIDDEN: Cross-Module Imports

#### DO NOT Import from Other Modules
```typescript
// ❌ WRONG - importing from inventory module
import { InvoiceTable } from '@/modules/inventory/components/invoice-table'

// ❌ WRONG - importing from task-manager module
import { TaskCard } from '@/modules/task-manager/components/task-card'
```

**Why Forbidden:**
- Creates tight coupling between modules
- Breaks module independence
- Makes refactoring difficult
- Violates architectural boundaries

---

## Special Cases

### Inventory Module is Reference-Only

The inventory module appears in many code examples but is **REFERENCE ONLY**:

✅ **DO:** Read the code to understand patterns
```bash
# Read to learn patterns
cat modules/inventory/hooks/use-invoices.ts
cat modules/inventory/services/invoices.service.ts
```

❌ **DON'T:** Import from inventory
```typescript
// ❌ WRONG
import { useInvoices } from '@/modules/inventory/hooks/use-invoices'
```

**Instead:** Copy the pattern and adapt for your module

---

## When You Need Shared Logic

### If Multiple Modules Need Same Logic

**Option 1: Move to Global Hooks**
```typescript
// Create: /hooks/use-pagination.ts
export const usePagination = () => {
  // Shared pagination logic
}

// Use in any module
import { usePagination } from '@/hooks/use-pagination'
```

**Option 2: Move to Lib/Utils**
```typescript
// Create: /lib/date-utils.ts
export const formatDate = (date: string) => {
  // Shared date formatting
}

// Use in any module
import { formatDate } from '@/lib/date-utils'
```

**Option 3: Create Core Component**
```typescript
// Create: /components/core/custom-pagination/
// Then available globally via @/components/core/custom-pagination
```

---

## list_sections Guarantees

When you call `list_sections()`, these are guaranteed to exist:
- All `components/ui-kit/*` entries
- All `components/core/*` entries
- All recipe documents
- All workflow documents

**NOT Guaranteed:**
- Other modules' code (reference-only)
- Module-specific components

---

## Import Checklist

Before adding any import:
- [ ] Does it start with @/components/ui-kit? (SAFE)
- [ ] Does it start with @/components/core? (SAFE)
- [ ] Does it start with @/hooks? (SAFE)
- [ ] Does it start with @/lib? (SAFE)
- [ ] Is it from my own module? (SAFE)
- [ ] Is it from another module? (FORBIDDEN - copy pattern instead)
```

**Add to topics.json:**
```json
{
  "id": "component-reusability-rules",
  "title": "Component Reusability Rules",
  "category": "recipes",
  "priority": "high",
  "read_order": 7,
  "use_cases": "always",
  "file_path": "recipes/component-reusability-rules.md"
}
```

---

### Phase 5: Fix iam-to-business-data-mapping.md

**File:** `/Users/mustavikhan/Developer/selise/selise/selise-blocks-docs/recipes/iam-to-business-data-mapping.md`

**Changes:**

**Add Decision Tree Section (at beginning):**
```markdown
# IAM to Business Data Mapping

**When to Read:** Before implementing multi-user authentication

---

## Decision Tree: Do You Need User Schema?

### Option 1: Simple Multi-User Apps (RECOMMENDED)
**Use IAM userId directly - NO User schema needed**

When:
- Users only have identity (name, email from IAM)
- No business-specific user properties
- No user preferences or settings

Example: Todo app where all users are equal

```typescript
// Just use IAM user ID
import { getAccount } from '@/modules/profile/services/accounts.service'

const account = await getAccount()
const userId = account.itemId  // Use directly for data filtering
```

### Option 2: Complex Apps with Business User Data
**Create User schema with IAMUserId foreign key**

When:
- Users have business properties (department, role, preferences)
- User settings stored in database
- Extended profile data beyond IAM

Example: Enterprise app with user preferences, department assignments

---

## ❌ Don't Use Email as Foreign Key

### Problems with Email-Based Pattern:
1. **Emails can change** - user updates email → loses all data access
2. **Case sensitivity** - User@example.com vs user@example.com
3. **No referential integrity** - string match, not actual foreign key
4. **Slower performance** - string filtering vs ID-based lookups
5. **Race conditions** - duplicate records possible

### ✅ Use IAM itemId Instead

```typescript
// User Schema (if needed)
{
  "schemaName": "User",
  "fields": [
    {
      "name": "IAMUserId",  // Foreign key to IAM user itemId
      "type": "String",
      "required": true
    },
    {
      "name": "Email",      // For display only, NOT for lookups
      "type": "String"
    },
    {
      "name": "Department",
      "type": "String"
    }
  ]
}
```

**Auto-Provisioning Pattern:**
```typescript
// Get IAM user
const account = await getAccount()

// Check if business User record exists
let user = await getUserByIAMId(account.itemId)  // NOT by email!

if (!user) {
  // Create business User record
  user = await createUser({
    IAMUserId: account.itemId,  // Use itemId as foreign key
    Email: account.email,       // Store for display only
    Name: account.name
  })
}

// Use business User ItemId for data operations
const userId = user.ItemId
```

---

[Rest of the original content for the complex case with User schema]
```

**Remove or Update:** All email-based pattern examples to use IAMUserId instead

---

### Phase 6: Update topics.json

**File:** `/Users/mustavikhan/Developer/selise/selise/selise-blocks-docs/topics.json`

**Changes:**

**1. Remove merged workflow entries:**
```json
// REMOVE these entries
{
  "id": "user-interaction",
  ...
},
{
  "id": "feature-planning",
  ...
}
```

**2. Add new workflow entry:**
```json
{
  "id": "workflow",
  "title": "Complete Development Workflow",
  "category": "workflows",
  "priority": "critical",
  "read_order": 1,
  "use_cases": "always",
  "file_path": "workflows/workflow.md"
}
```

**3. Add 3 new recipe entries:** (as shown in Phase 4)

**4. Fix permissions-roles metadata:**
```json
{
  "id": "permissions-roles",
  "title": "Permissions and Roles Configuration",
  "category": "recipes",
  "priority": "high",
  "read_order": 10,
  "use_cases": "role-based access control, admin panels, permissions",  // CHANGED
  "file_path": "recipes/permissions-and-roles.md"
}
```

**5. Handle missing component docs:**

**Option A (RECOMMENDED):** Add status flag to component entries
```json
{
  "id": "data-table",
  "title": "Data Table Component",
  "category": "components",
  "subcategory": "core",
  "priority": "critical",
  "read_order": 20,
  "use_cases": "tables, lists, pagination",
  "file_path": "components/core/data-table.md",
  "status": "reference_only",  // ADD THIS
  "note": "See component code at /components/core/data-table/"
}
```

**Option B:** Remove all 59 component entries from topics.json (loses discoverability)

**RECOMMENDED: Option A** - Keep entries but mark as reference-only

---

### Phase 7: Fix Folder Structure References

**Files Affected:** All docs mentioning folder structure

**Global Search-Replace:**
1. `src/features/` → `src/modules/`
2. In module context: `/components/` → `/component/` (singular)
3. Add references to `pages/` folder where missing

**Specific Files to Update:**

**File 1:** `component-catalog/selise-component-hierarchy.md`
- Update all folder paths to use `modules/` not `features/`
- Update to use `component/` not `components/` within modules

**File 2:** `architecture/constructs-structure.md`
- Update folder structure diagram
- Add `pages/` folder to structure
- Clarify `component/` singular naming

**File 3:** All recipe files
- Search each recipe for folder path references
- Update to match actual structure

---

## Validation Plan

### Pre-Implementation Validation

Before making changes:
- [ ] Backup selise-blocks-docs/ repository
- [ ] Create dev branch
- [ ] Document current state

### During Implementation Validation

After each phase:
- [ ] Verify file changes are correct
- [ ] Test MCP get_documentation(topic_id) for changed files
- [ ] Check topics.json syntax is valid JSON
- [ ] Verify all cross-references are updated

### Post-Implementation Validation

After all changes complete:

**1. MCP Workflow Test**
```bash
# Test list_sections
mcp__selise__list_sections()

# Test get_documentation for each new/changed topic
mcp__selise__get_documentation(['workflow'])
mcp__selise__get_documentation(['graphql-crud'])
mcp__selise__get_documentation(['react-query-patterns'])
mcp__selise__get_documentation(['schema-design-guide'])
mcp__selise__get_documentation(['component-reusability-rules'])
```

**2. CLAUDE.md Validation**
- [ ] Exactly 4 BLOCKING STEPS
- [ ] Exactly 4 ✋ STOP checkpoints
- [ ] Critical Gotchas checklist covers all test issues
- [ ] Line count ≤ 80 lines
- [ ] No implementation details (delegated to recipes)

**3. Conflict Resolution Validation**
- [ ] Only ONE file defines workflow sequence (workflow.md)
- [ ] Only ONE file defines GraphQL patterns (graphql-crud.md)
- [ ] Only ONE file defines form patterns (react-hook-form-integration.md)
- [ ] No contradictions between files

**4. Build Todo App Again**
Follow CLAUDE.md STEP 0-4 exactly:
- [ ] Agent calls list_sections first
- [ ] Agent creates tracking files before proceeding
- [ ] Agent gets user confirmation before implementing
- [ ] Agent creates schemas via MCP before coding
- [ ] Agent encounters ZERO issues from original 30+ list

**5. Technical Gotchas Validation**
Test that each gotcha is documented:
- [ ] Query naming ("get" prefix) - in graphql-crud.md + CLAUDE.md
- [ ] DateTime ISO format - in graphql-crud.md + CLAUDE.md
- [ ] Pagination 1-based - in graphql-crud.md + CLAUDE.md
- [ ] @/ import prefix - in CLAUDE.md + all examples
- [ ] Response extraction - in graphql-crud.md
- [ ] _id vs ItemId - in graphql-crud.md + CLAUDE.md

---

## Files Changed Summary

### Files to REWRITE:
1. `CLAUDE.md` (114 lines → 80 lines)

### Files to CREATE:
1. `workflows/workflow.md` (merged from 2 files)
2. `recipes/react-query-patterns.md` (NEW)
3. `recipes/schema-design-guide.md` (NEW)
4. `recipes/component-reusability-rules.md` (NEW)

### Files to UPDATE:
1. `recipes/graphql-crud.md` (add 5 sections, fix typo, fix imports)
2. `recipes/iam-to-business-data-mapping.md` (fix pattern, add decision tree)
3. `topics.json` (add 4 entries, remove 2 entries, fix 1 metadata, add status flags)
4. `component-catalog/selise-component-hierarchy.md` (fix folder paths)
5. `architecture/constructs-structure.md` (fix folder paths)

### Files to DELETE:
1. `workflows/user-interaction.md` + `.txt` (merged into workflow.md)
2. `workflows/feature-planning.md` + `.txt` (merged into workflow.md)

**Note:** All other .txt files are kept for agent ease of retrieval

### Total Impact:
- **Create:** 4 files (+ 4 .txt mirrors)
- **Update:** 6 files (+ 6 .txt mirrors)
- **Delete:** 4 files (2 .md + 2 .txt)
- **Rewrite:** 1 file (+ 1 .txt mirror)

---

## Success Metrics

### Before Fix:
- 25+ conflicts between docs
- 30+ implementation issues
- Agent skipped MCP workflow
- Agent skipped tracking files
- Agent skipped user confirmation
- Critical gotchas missed (query naming, DateTime, pagination)

### After Fix:
- ✅ **0 conflicts** (single source of truth per topic)
- ✅ **0 workflow issues** (BLOCKING STEPS with ✋ STOP)
- ✅ **100% MCP compliance** (STEP 0 enforced)
- ✅ **100% tracking files created** (STEP 1 enforced)
- ✅ **100% user confirmation** (STEP 2 enforced)
- ✅ **0 critical gotchas missed** (checklist prevents all 30+ issues)
- ✅ **Copy-paste works** (correct paths, correct structure)
- ✅ **Self-enforcing** (agent cannot skip critical steps)

---

## Implementation Timeline

**Estimated Time:** 6-7 hours

**Phase 1 (CRITICAL):** 1 hour
- Rewrite CLAUDE.md (+ create .txt mirror)

**Phase 2 (CRITICAL):** 2 hours
- Fix graphql-crud.md with all sections (+ update .txt mirror)

**Phase 3:** 1 hour
- Merge workflow files (+ create .txt mirror for new workflow.md)

**Phase 4:** 2-3 hours
- Create 3 missing recipes (+ create .txt mirrors)

**Phase 5:** 30 min
- Fix iam-to-business-data-mapping.md (+ update .txt mirror)

**Phase 6:** 30 min
- Update topics.json

**Phase 7:** 30 min
- Fix folder structure references (+ update .txt mirrors)

**Validation:** 1 hour
- Test MCP workflow
- Build test app again
- Verify 0 issues

**Note:** All .md file changes must be mirrored to corresponding .txt files for agent ease of retrieval

---

## End of Plan

This plan addresses ALL 55+ issues and conflicts found during todo app testing by:
1. Enforcing MCP workflow with BLOCKING STEPS
2. Eliminating conflicts through single source of truth
3. Documenting all critical gotchas in quick reference
4. Creating missing recipes for common patterns
5. Fixing technical inaccuracies (query naming, DateTime, pagination)
6. Simplifying documentation structure

**Ready for implementation on dev branch.**
