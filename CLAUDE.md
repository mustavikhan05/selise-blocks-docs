# Selise Blocks - Official MCP Server

This MCP provides documentation + 33 Cloud API tools for Selise Blocks development. Use this for any type of apps the user tries to build.

## 🚀 START HERE

**First Time:** `list_sections()` → `get_documentation(['project-setup'])` → Follow Phases 0-5
**After Setup:** Use Implementation Loop below

---

## 🔁 IMPLEMENTATION LOOP (Every Task)

### STEP 1: PLAN (BLOCKING)
**MANDATORY:** Call `list_sections()` and `get_documentation([topics])` in SAME turn
- Analyze use_cases/triggers → fetch relevant docs
- Write task breakdown to TASKS.md with docs referenced

✋ CHECKPOINT: Task in TASKS.md? → NO = STOP

### STEP 2: IMPLEMENT
- Follow fetched recipes
- Check Critical Gotchas below
- Update SCRATCHPAD.md as you work

### STEP 3: DOCUMENT (BLOCKING)
- Mark tasks done in TASKS.md
- Log learnings in SCRATCHPAD.md with timestamp

✋ CHECKPOINT: TASKS.md + SCRATCHPAD.md updated? → NO = STOP

### STEP 4: COMMIT
Git commit with code + tracking files + summary

### STEP 5: NEXT TASK → STEP 1

---

## 🔥 CRITICAL GOTCHAS (Check Before Commit)

- [ ] GraphQL: lowercase `getTodoTasks`, ISO DateTime, `pageNo: 1`, filter `_id` NOT `ItemId`
- [ ] Imports: ALWAYS `@/` prefix (`@/components/ui-kit/button`)
- [ ] Folder: `src/modules/[name]/component/` (singular!)
- [ ] NO cross-module imports (inventory = reference-only)
- [ ] DataTable from `@/components/core/data-table`
- [ ] ConfirmationModal for ALL confirmations
- [ ] React Hook Form + Zod for forms

---

## 🚫 NEVER DO

- Call `get_documentation` without `list_sections` FIRST (same turn!)
- Skip TASKS.md/SCRATCHPAD.md updates
- Use uppercase "Get" in queries or ItemId in filters
- Import from other modules (inventory = reference-only)

---

## 📖 WHERE TO FIND WHAT

**Workflows:** project-setup, dev-workflow, implementation-checklist
**Recipes:** graphql-crud (always!), react-query-patterns, schema-design-guide, component-reusability-rules, iam-business-mapping, react-hook-form, confirmation-modal-patterns
**Components:** Check `list_sections` for catalog

---

**Repository:** https://github.com/mustavikhan05/selise-blocks-docs
**Last Updated:** 2025-12-04
