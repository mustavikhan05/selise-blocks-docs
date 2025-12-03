# Selise Blocks - Official MCP Server

This MCP provides documentation + 33 Cloud API tools for Selise Blocks development.

## 🚀 START HERE

**First Time Setup:**
1. Call `list_sections()`
2. Call `get_documentation(['project-setup'])`
3. Follow project-setup.md (Phases 0-5)
4. When setup done → Implementation Loop below

---

## 🔁 IMPLEMENTATION LOOP (For Each Task)

### STEP 1: PLAN (BLOCKING)
- Call `list_sections()` → analyze use_cases/triggers
- Call `get_documentation([relevant topics])`
- Write task breakdown to TASKS.md with docs referenced

✋ CHECKPOINT: Task planned in TASKS.md? → NO = STOP, GO BACK

### STEP 2: IMPLEMENT
- Follow recipes from fetched docs
- Reference components from list_sections
- Use Critical Gotchas checklist below
- Update SCRATCHPAD.md as you discover issues/patterns

### STEP 3: DOCUMENT (BLOCKING)
- Mark subtasks done in TASKS.md
- Document learnings/issues in SCRATCHPAD.md with timestamp

✋ CHECKPOINT: TASKS.md + SCRATCHPAD.md updated? → NO = STOP, GO BACK

### STEP 4: COMMIT
- Commit code + tracking files together
- Include task summary in commit message

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
- dev-workflow → Continuous development cycle (after setup)
- implementation-checklist → Pre-flight checklist before coding

**Recipes** (fetch as needed):
- graphql-crud → ALWAYS (for data operations)
- react-query-patterns → When creating hooks
- react-hook-form → When building forms
- confirmation-modal → When adding delete confirmations
- iam-business-mapping → Multi-user apps
- schema-design-guide → Before creating schemas
- component-reusability-rules → Before importing components

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
- 33 Selise Cloud API tools (auth, schemas, IAM, MFA, SSO, CAPTCHA, etc.)

**Remember:** ALWAYS call list_sections before each task to find relevant docs/components

---

**Repository:** https://github.com/mustavikhan05/selise-blocks-docs
**Last Updated:** 2025-12-04
