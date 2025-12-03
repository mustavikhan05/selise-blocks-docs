# Comprehensive Plan: Fix All Issues & Streamline Agent Workflow

**Date:** 2025-12-04
**Purpose:** Fix all 20+ documented issues and create a hyper-smooth agent workflow where `list_sections` → `get_documentation` → implement works seamlessly.

---

## Executive Summary

**Goal:** Create a seamless workflow where agents call `list_sections` → analyze metadata → `get_documentation` → implement → repeat, following core workflows without hitting any of the 20+ documented issues.

**Core Problems Identified:**
1. **CLAUDE.md lacks enforcement mechanisms** - Just describes, doesn't guide actively
2. **Workflow conflicts** - Different docs say different things
3. **Missing critical recipes** - Agents forced to explore codebase (15-20 min wasted)
4. **Metadata accuracy issues** - topics.json points to non-existent files (404s)
5. **Path/naming mismatches** - Docs don't match actual codebase
6. **Unclear decision points** - When to do what isn't explicit

**Total Time Wasted in Test:** 75+ minutes on issues that proper docs would prevent

---

## Part 1: Complete CLAUDE.md Rewrite

**Location:** `/CLAUDE.md` (saved in project root by developer before starting)

**Purpose:** This is the ONLY file agents see initially. It must:
- Enforce the workflow with clear decision trees
- Remind about list_sections at every step
- Prevent all 20 documented issues
- Be concise but comprehensive

### Key Sections in New CLAUDE.md

1. **Three-Step Loop** (visible at top)
   ```
   STEP 1: list_sections → Analyze metadata
   STEP 2: get_documentation([topics]) → Read docs
   STEP 3: Implement → Update tracking → Commit
   REPEAT for next task
   ```

2. **Phase 0-5: Initial Project Setup Workflow**
   - Phase 0: Documentation Discovery (call list_sections FIRST)
   - Phase 1: User Requirements (BEFORE authentication!)
   - Phase 2: Authentication & Project Creation (with new/existing decision)
   - Phase 3: Local Repository Setup (MANDATORY, not optional!)
   - Phase 4: Schema Planning (read docs BEFORE creating schemas)
   - Phase 5: Feature Planning & Task Breakdown

3. **Implementation Loop** (for each task)
   - Step 1: Call list_sections, find relevant docs
   - Step 2: Implement following recipes
   - Step 3: Update tracking files, commit

4. **Critical Rules** (never break)
   - Import rules (✅ @/components/ui-kit/, ❌ components/ui/)
   - Folder structure (modules/ not features/, component/ singular)
   - GraphQL naming (lowercase 'get' + schema + 's')
   - Multi-user rules (simple: use IAM itemId directly)

5. **Decision Trees**
   - "Should I create a User schema?"
   - "Which component should I use?"
   - "Do I need to read a recipe?"

6. **Common Pitfalls** (from test results)
   - Pitfall #1: Skipping list_sections
   - Pitfall #2: Wrong import paths
   - Pitfall #3: Email-based user filtering
   - Pitfall #4: Wrong GraphQL naming
   - Pitfall #5: Not updating tracking files
   - Pitfall #6: Importing from other modules
   - Pitfall #7: Using ItemId in filters

7. **Verification Checklist** (before each commit)

8. **MCP Server Quick Reference**

**Full CLAUDE.md content:** See attached appendix or reference message above for complete text.

---

## Part 2: topics.json Metadata Fixes

### Fix #1: Add Missing Critical Topics

**Three new recipes to create:**

```json
{
  "id": "react-query-patterns",
  "category": "recipe",
  "priority": "critical",
  "title": "React Query Hooks & Patterns",
  "path": "recipes/react-query-patterns.md",
  "use_cases": "hooks,react-query,data-fetching,mutations,caching,always",
  "triggers": ["implementing hooks", "creating queries", "creating mutations"],
  "read_when": "before_creating_hooks",
  "warnings": ["Must use useGlobalQuery and useGlobalMutation wrappers"],
  "next_steps": ["graphql-crud"]
}
```

```json
{
  "id": "schema-design-guide",
  "category": "workflow",
  "priority": "critical",
  "title": "Schema Design Guide for MongoDB/Selise",
  "path": "workflows/schema-design-guide.md",
  "use_cases": "schemas,mongodb,nosql,database-design,always",
  "triggers": ["before creating schemas", "planning data model"],
  "read_when": "before_creating_schemas",
  "warnings": ["Selise uses MongoDB - no foreign keys or JOINs!"],
  "next_steps": ["graphql-crud", "iam-business-mapping"]
}
```

```json
{
  "id": "import-path-guide",
  "category": "workflow",
  "priority": "critical",
  "title": "Import Paths & Module Boundaries",
  "path": "workflows/import-path-guide.md",
  "use_cases": "imports,paths,modules,architecture,always",
  "triggers": ["starting implementation", "importing components"],
  "read_when": "before_first_import",
  "warnings": ["Use @/ prefix! Import from ui-kit not ui! Never import from other modules!"],
  "next_steps": ["architecture-patterns"]
}
```

### Fix #2: Remove/Mark Non-Existent Topics

```json
{
  "id": "data-table",
  "status": "undocumented",  // ADD THIS FIELD
  "priority": "low",         // CHANGE from "critical"
  "warnings": ["Documentation not yet available - use ui-kit Table components instead"],
  "fallback": "ui-kit/table"
}
```

### Fix #3: Update Existing Topics with Better Metadata

**graphql-crud:**
- Add "always" to use_cases
- Update warnings with specific gotchas:
  - "CRITICAL: Use lowercase 'get' prefix (getCategorys not getCategories)!"
  - "Use _id in filters not ItemId!"
  - "Convert null to '' for optional fields!"
- Add critical_patterns object with patterns

**iam-business-mapping:**
- Update warnings: "ONLY create User schema if you have ADDITIONAL business data!"
- Add decision_tree object

**user-interaction:**
- Update warnings: "Ask for requirements BEFORE authenticating!"
- Add critical_order field

### Fix #4: Add Workflow Ordering Metadata

```json
{
  "workflows": {
    "project_setup_order": [
      "user-interaction",
      "project-setup",
      "schema-design-guide",
      "graphql-crud",
      "iam-business-mapping",
      "feature-planning",
      "implementation-checklist"
    ],
    "implementation_loop": [
      "Call list_sections → analyze use_cases",
      "Call get_documentation([relevant topics])",
      "Implement following recipes",
      "Update tracking files",
      "Commit",
      "Repeat"
    ]
  }
}
```

---

## Part 3: Documentation Fixes (By Issue Number)

### Issues #1, #4, #10: Workflow Ordering Conflicts

**Fix: Rewrite project-setup.md with explicit phases**

Add clear phases with checkpoints:
- Phase 0: Read Documentation First (MANDATORY)
- Phase 1: User Requirements (BEFORE AUTHENTICATION!)
- Phase 2: Authentication
- Phase 3: Project & Local Setup
- Phase 4: Schema Planning & Creation
- Phase 5: Feature Planning

Each phase has:
- ⚠️ STOP warnings
- Clear prerequisites
- **CHECKPOINT** questions
- Explicit "→ Proceed to Phase X" instructions

### Issue #2: Authentication Timing

**Fix: Add to user-interaction.md**

```markdown
## ⚠️ CRITICAL: Authentication Timing

**NEVER ask for credentials until AFTER:**
1. ✓ User confirmed project name
2. ✓ User confirmed features
3. ✓ User confirmed GitHub repo
4. ✓ Tracking files created
5. ✓ FEATURELIST.md populated
6. ✓ User confirmed: "Does this match your vision?"

**THEN and ONLY THEN ask for credentials**

**Why this order matters:**
- User might change their mind about features
- Credentials might expire if collected too early
- Tracking files document what user wants BEFORE cloud setup
```

### Issue #3: MCP Tool Parameters

**Fix: Update project-setup.md with correct parameters**

Show exact format:
```python
create_project(
    project_name="UserProvidedName",
    repo_name="username/repo",
    repo_link="https://github.com/username/repo",
    repo_id="Any",
    is_production=false
)

# MANDATORY next step:
set_application_domain(
    domain="domain_from_response",
    tenant_id="tenant_id_from_response",
    project_name="UserProvidedName"
)

# Then create local repo:
create_local_repository(repository_name="UserProvidedName")
```

### Issue #5: Project Name Not Requested

**Fix: Add to user-interaction.md**

Make "Project Name" Question #1 (ask FIRST)

### Issue #6: No Workflow for Existing Projects

**Fix: Add decision point to project-setup.md Phase 2**

```markdown
**DECISION POINT: Ask user:**
"Is this a NEW project or adding features to EXISTING?"

### Option A: NEW Project
[create_project workflow]

### Option B: EXISTING Project
[get_projects, set_application_domain workflow]
```

### Issue #7: No Schema Design Guide

**Fix: CREATE NEW FILE: workflows/schema-design-guide.md**

Contents:
- Available Field Types (String, Number, Boolean, DateTime, Array, Object)
- Auto-Generated Fields (ItemId, CreatedDate, etc. - don't add manually!)
- Field Constraints (required, unique patterns)
- Naming Conventions (PascalCase for schemas and fields)
- NoSQL Relationship Patterns (references via ItemId)
- Multi-User Schema Patterns (simple vs complex)
- Common Schema Examples (E-commerce, Task Management)
- Validation guidance

### Issue #8: Local Repository Setup Skipped

**Fix: Update project-setup.md Phase 3**

```markdown
## Phase 3: Local Repository Setup

⚠️ **THIS IS MANDATORY - NOT OPTIONAL!**

**Why you MUST create local repository:**
- You CANNOT build frontend without it
- All React code lives here
- GraphQL client setup is here
- Cannot run npm start without it

[Show check_blocks_cli, install_blocks_cli, create_local_repository steps]

⚠️ **CHECKPOINT: Local repo created? YES → Proceed to Phase 4**
```

### Issue #9: set_application_domain Prerequisite

**Fix: Covered in Issue #3 fix** (show it in correct order)

### Issues #11, #12: Implementation Checklist Wrong Guidance

**Fix: Rewrite implementation-checklist.md**

```markdown
# Implementation Checklist

⚠️ **DO NOT read all recipes upfront! Use list_sections.**

## Before Starting ANY Task

1. **Call list_sections**
2. **Call get_documentation([relevant_topics])**
3. **Mandatory Baseline Knowledge:**
   - ✅ MUST read before ANY implementation:
     - graphql-crud.md (ALWAYS)
     - import-path-guide.md (ALWAYS)
   - ✅ Read ONLY IF building multi-user app:
     - iam-business-mapping.md
   - ✅ Read WHEN implementing specific features:
     - confirmation-modal → When adding delete
     - react-hook-form → When building forms
     - react-query-patterns → When creating hooks

## Testing Guidelines

**curl testing is OPTIONAL** (not mandatory before starting)
- Use it during implementation to test queries
- Helpful for debugging
```

### Issue #13: Docs Say "features" But Actual Uses "modules"

**Fix: Global search-replace in ALL .md files**

```bash
"src/features/" → "src/modules/"
"features/" → "modules/"
"components/" → "component/" (in module subfolder context)
```

Add to import-path-guide.md:
```markdown
## Correct Folder Structure

src/
├── modules/              ← NOT "features"!
│   └── [your-module]/
│       ├── component/    ← Singular, NOT "components"!
│       ├── pages/        ← Module-specific pages
│       ├── graphql/
│       ├── hooks/
│       ├── services/
│       └── types/
```

### Issue #14: No React Query Hooks Recipe

**Fix: CREATE NEW FILE: recipes/react-query-patterns.md**

Contents:
- Complete hook templates (Query + Mutation)
- Required imports
- Query invalidation patterns (exact key, predicate, multiple related)
- Error handling approaches
- Data isolation for multi-user apps
- Standard configurations
- Real examples for CRUD operations
- Usage in components

### Issue #15: Not Updating Tracking Files

**Fix: Already covered in CLAUDE.md** - Tracking File Update Rules section with clear guidelines

### Issues #16, #19: Module Import Boundaries

**Fix: CREATE NEW FILE: workflows/import-path-guide.md**

Contents:
```markdown
## Import Rules

✅ **ALLOWED:**
- @/components/ui-kit/* (always OK)
- @/components/core/* (always OK)
- ../services/your.service (own module)

❌ **FORBIDDEN:**
- components/ui/* (wrong path - no @/, wrong folder)
- @/modules/inventory/... (never import from other modules!)
- @/features/... (we use modules not features)
```

**Also fix:** Update all component docs - remove module imports from examples

### Issue #17: IAM-Business Mapping Inefficient

**Fix: Rewrite iam-business-mapping.md intro**

Start with decision tree:
```markdown
# IAM-to-Business-Data Mapping Recipe

## Decision Tree: Do You Need a User Schema?

Is this a multi-user app?
├─ NO → Skip this recipe
└─ YES → Do users need data beyond name/email?
    ├─ NO (Simple: todo, notes)
    │   └─ ✅ Use IAM itemId directly - NO User schema!
    │      - Benefits: 1 query, no duplicate data
    │
    └─ YES (Complex: e-commerce, CRM)
        └─ ✅ Create User schema for ADDITIONAL data
           - Profile, subscription, team, etc.
           - Reference by IAM itemId, NOT email!

## Pattern 1: Simple Multi-User (90% of apps)
[Direct IAM itemId filtering - 1 query, fast]

## Pattern 2: Complex Multi-User (Only when needed)
[User schema with business data - still use IAM itemId]
```

### Issue #18: Wrong Import Paths

**Fix: Global search-replace in ALL .md files**

```bash
"components/ui/" → "@/components/ui-kit/"
"'components/ui/" → "'@/components/ui-kit/"
"from 'components/ui" → "from '@/components/ui-kit"
```

Add note to EVERY recipe:
```markdown
⚠️ **CRITICAL: Import paths in Selise Blocks**

ALL imports MUST use @/ prefix:
✅ import { Button } from '@/components/ui-kit/button'
❌ import { Button } from 'components/ui/button'
```

### Issue #20: list_sections Returns Missing Docs

**Fix: Create validation script + update topics.json**

**CREATE: scripts/validate-topics.js**
```javascript
// Validates all topics in topics.json have corresponding docs
// Exits with error if any missing
```

**Fix topics.json:**
- Mark data-table as "undocumented" with fallback
- Or remove until documented
- Run validation before every commit

---

## Part 4: Implementation Roadmap

### Phase 1: Immediate Critical Fixes (Day 1)

**Priority: Blocking agent workflow**

1. **Update CLAUDE.md** (1-2 hours)
   - Replace with comprehensive version
   - Test: Agent can follow Phase 0-5

2. **Fix Import Paths** (30 min)
   - Global search-replace in all .md files

3. **Add Missing Critical Recipes** (4-6 hours)
   - Create react-query-patterns.md
   - Create schema-design-guide.md
   - Create import-path-guide.md
   - Add to topics.json

4. **Fix graphql-crud.md** (1 hour)
   - Add critical warnings
   - Add null→'' conversion
   - Emphasize lowercase 'get' prefix

**Day 1 Total: ~7-10 hours**

### Phase 2: Workflow Fixes (Day 2)

**Priority: Prevent workflow confusion**

1. **Rewrite project-setup.md** (2-3 hours)
   - Add Phases 0-5 with checkpoints

2. **Update user-interaction.md** (1 hour)
   - Add project name as Question #1
   - Add authentication timing warnings

3. **Update feature-planning.md** (30 min)
   - Clarify update frequency

4. **Rewrite implementation-checklist.md** (1 hour)
   - Remove "read ALL recipes"
   - Add "call list_sections first"

**Day 2 Total: ~5-6 hours**

### Phase 3: topics.json Accuracy (Day 2-3)

**Priority: Ensure metadata drives workflow**

1. **Update Existing Topics** (2-3 hours)
   - Add critical_patterns, decision_tree
   - Add "always" to use_cases
   - Update warnings

2. **Add New Topics** (1 hour)
   - react-query-patterns
   - schema-design-guide
   - import-path-guide

3. **Remove/Mark Undocumented** (30 min)
   - Mark data-table
   - Remove 404 topics

4. **Add Workflow Metadata** (1 hour)
   - project_setup_order
   - implementation_loop

**Day 2-3 Total: ~5-6 hours**

### Phase 4: Recipe Rewrites (Day 3-4)

**Priority: Fix architectural guidance**

1. **Rewrite iam-business-mapping.md** (2 hours)
   - Decision tree first
   - Pattern 1: Simple (most apps)
   - Pattern 2: Complex (when needed)

2. **Update confirmation-modal-patterns.md** (30 min)
   - Fix import paths

3. **Update react-hook-form.md** (1 hour)
   - Add null→'' pattern

**Day 3-4 Total: ~4 hours**

### Phase 5: Validation & Testing (Day 4-5)

**Priority: Ensure fixes work**

1. **Create Validation Scripts** (2 hours)
   - validate-topics.js
   - validate-imports.js
   - validate-graphql.js

2. **Run Test Builds** (4 hours)
   - Todo app (simple multi-user)
   - E-commerce app (complex multi-user)
   - Document any remaining issues

3. **Create Quickstart Guide** (2 hours)
   - workflows/quickstart.md
   - Todo app example
   - E-commerce example
   - SaaS example

**Day 4-5 Total: ~8 hours**

### Phase 6: Continuous Improvement (Ongoing)

1. **Add Component Documentation**
   - Document data-table
   - Document all core components

2. **Add More Recipes**
   - File upload patterns
   - Real-time patterns
   - Advanced permissions

3. **Monitoring**
   - Track agent issues
   - Update CLAUDE.md
   - Refine metadata

---

## Part 5: Success Metrics

### Agent Metrics
- ✅ Agent calls list_sections at least 3x per project
- ✅ Agent gets correct docs on first try (no 404s)
- ✅ Agent follows Phase 0-5 without skipping
- ✅ Agent updates tracking files after each task
- ✅ Zero import errors on first build
- ✅ Zero GraphQL naming errors
- ✅ Agent never imports from other modules
- ✅ Local repo created before implementation

### Time Metrics
- ✅ Todo app built in < 30 min (vs 75 min with issues)
- ✅ No time spent exploring codebase
- ✅ No time debugging import paths
- ✅ No time debugging GraphQL naming

### Quality Metrics
- ✅ All imports use @/ prefix
- ✅ All GraphQL uses lowercase 'get' prefix
- ✅ Multi-user apps use IAM itemId directly (simple)
- ✅ Tracking files updated continuously
- ✅ Git commits after every task

---

## Part 6: Quick Reference Cards

### Card 1: The Three-Step Loop
```
1. list_sections → analyze use_cases → find relevant docs
2. get_documentation([topics]) → read completely
3. Implement → update tracking → commit → repeat
```

### Card 2: Import Cheat Sheet
```typescript
// ✅ ALWAYS use @/ prefix
import { X } from '@/components/ui-kit/...'
import { Y } from '@/components/core/...'
import { Z } from '@/modules/your-module/...'

// ❌ NEVER
import from 'components/...'  // Missing @/
import from 'components/ui/...'  // Wrong folder
import from '@/modules/other-module/...'  // Cross-module
```

### Card 3: GraphQL Cheat Sheet
```typescript
// Naming: lowercase 'get' + SchemaName + 's'
query { getCategorys(...) }  // NOT getCategories!

// Response: NO 'data' wrapper
const items = result.getCategorys.items

// Filter: Use _id with ItemId VALUE
const filter = JSON.stringify({ _id: item.ItemId })
```

### Card 4: Multi-User Decision
```
Simple app (todo, notes)?
→ Use IAM itemId directly
→ { UserId: iamUser.itemId }

Complex app (billing, teams)?
→ Create User schema
→ Store IAM itemId as reference
→ { IAMUserId: iamUser.itemId }
```

---

## Summary: The Complete Fix Plan

**Total Effort:** ~4-5 days (30-40 hours)

**Deliverables:**
1. ✅ New CLAUDE.md (comprehensive, enforcing)
2. ✅ Updated topics.json (accurate metadata)
3. ✅ 3 new critical recipes (react-query, schema-design, import-guide)
4. ✅ 4 rewritten workflows (project-setup, user-interaction, implementation-checklist, iam-mapping)
5. ✅ Global path fixes (all docs updated)
6. ✅ Validation scripts (prevent regressions)
7. ✅ Test builds (todo + e-commerce)

**Result:**
- Agent workflow is hyper-smooth
- list_sections → get_documentation → implement loop is seamless
- All 20 documented issues are prevented
- Zero time wasted on exploration or debugging
- Agent builds apps 2-3x faster
- Quality is consistent and high

**The workflow becomes:**
```
Developer: Saves CLAUDE.md to project root
Agent: Reads CLAUDE.md
Agent: list_sections → Sees project-setup, user-interaction
Agent: get_documentation(['project-setup', 'user-interaction'])
Agent: Follows Phase 0-5 exactly
Agent: For each task: list_sections → get_documentation → implement
Agent: Builds app perfectly, first time, fast
Developer: Ships product
```

---

## Appendix A: Issue Mapping

| Issue # | Category | Fix Location | Priority |
|---------|----------|--------------|----------|
| #1 | Workflow ordering | project-setup.md rewrite | Critical |
| #2 | Auth timing | user-interaction.md | Critical |
| #3 | MCP params | project-setup.md | High |
| #4 | Workflow skip | project-setup.md rewrite | Critical |
| #5 | No project name | user-interaction.md | Medium |
| #6 | No existing workflow | project-setup.md | High |
| #7 | No schema guide | NEW: schema-design-guide.md | Critical |
| #8 | Local repo skipped | project-setup.md Phase 3 | Critical |
| #9 | set_domain prereq | project-setup.md | Medium |
| #10 | Checklist not emphasized | project-setup.md | High |
| #11 | Read ALL recipes | implementation-checklist.md | High |
| #12 | curl MANDATORY | implementation-checklist.md | Medium |
| #13 | features vs modules | Global search-replace | High |
| #14 | No hooks recipe | NEW: react-query-patterns.md | Critical |
| #15 | Not updating tracking | CLAUDE.md | High |
| #16 | Modules not usable | NEW: import-path-guide.md | High |
| #17 | IAM inefficient | iam-business-mapping.md | High |
| #18 | Wrong import paths | Global search-replace | Critical |
| #19 | Module imports | import-path-guide.md | High |
| #20 | list_sections 404 | topics.json + validation | Critical |
| #22-25 | Runtime issues | graphql-crud.md updates | High |

**Total Issues:** 25
**New Files Needed:** 3 (react-query-patterns, schema-design-guide, import-path-guide)
**Rewrites Needed:** 4 (project-setup, user-interaction, implementation-checklist, iam-business-mapping)
**Global Fixes:** 2 (import paths, folder names)

---

## Appendix B: File Checklist

### Files to Create
- [ ] workflows/schema-design-guide.md
- [ ] workflows/import-path-guide.md
- [ ] recipes/react-query-patterns.md
- [ ] scripts/validate-topics.js
- [ ] scripts/validate-imports.js
- [ ] scripts/validate-graphql.js
- [ ] workflows/quickstart.md (optional)

### Files to Rewrite
- [ ] CLAUDE.md (complete rewrite)
- [ ] workflows/project-setup.md (add Phases 0-5)
- [ ] workflows/user-interaction.md (add timing, project name)
- [ ] workflows/implementation-checklist.md (remove "read ALL")
- [ ] recipes/iam-business-mapping.md (add decision tree, patterns)

### Files to Update
- [ ] topics.json (add 3 new, update metadata, mark undocumented)
- [ ] recipes/graphql-crud.md (add warnings, null→'')
- [ ] recipes/confirmation-modal-patterns.md (fix imports)
- [ ] recipes/react-hook-form-integration.md (add null pattern)
- [ ] All component docs (remove module imports)

### Global Operations
- [ ] Search-replace: `components/ui/` → `@/components/ui-kit/`
- [ ] Search-replace: `features/` → `modules/`
- [ ] Search-replace: `components/` → `component/` (in module context)
- [ ] Add @/ prefix to all import examples

---

**End of Comprehensive Fix Plan**
**Ready for Implementation**
