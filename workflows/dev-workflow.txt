# Development Workflow

**FOLLOW THE VIBECODING EXPERIENCE FLOW FIRST!**

After completing project setup, continue with implementation using this workflow.

## Continuous Update Cycle

```
┌─────────────────────────────────────────────────┐
│  Pick Task → Update Status → Implement → Test   │
│      ↓            ↓             ↓          ↓     │
│  TASKS.md    TASKS.md      SCRATCHPAD   Code    │
│   [ ]→[🔄]      [🔄]          Notes              │
│      ↓            ↓             ↓          ↓     │
│   Commit → Update Status → Next Task → Repeat   │
│              TASKS.md [x]                        │
│            FEATURELIST.md                        │
└─────────────────────────────────────────────────┘
```

## Implementation Process (Using Your Tracking Files)

### Step 1: Work from TASKS.md (WITH CONTINUOUS UPDATES)

**Update Frequency:**

**TASKS.md** - Update IMMEDIATELY when:
- Starting a task: `[ ]` → `[🔄]`
- Completing a task: `[🔄]` → `[x]`
- Discovering sub-tasks: Add below parent task
- Encountering blockers: Add `[⚠️]` and note in SCRATCHPAD.md

**SCRATCHPAD.md** - Update CONTINUOUSLY:
- Every decision made
- Every error encountered and fix
- Every insight or pattern discovered
- Format: `[timestamp] Topic: Details`

**FEATURELIST.md** - Update when:
- Feature completed: Mark `[x]`
- Scope changes: Document what changed
- New feature discovered: Add to backlog

**CLOUD.md** - Update when:
- Schema modified
- New MCP operations performed
- Configuration changes made

### Step 2: Frontend Implementation

- Follow recipes from llm-docs/recipes/
- Use 3-layer hierarchy: Feature → Block → UI
- Reference graphql-crud.md for data operations (with MCP schema names from CLOUD.md)
- Update TASKS.md as you complete each component

### Step 3: Testing & Quality

- Use existing test patterns
- Run linting and type checking
- Test all CRUD operations
- Mark testing tasks complete in TASKS.md

### Step 4: Sidebar Management (CRITICAL)

**🚨 SIDEBAR RULES:**

1. **DEFAULT = NO SIDEBAR** - Hide/remove unless TASKS.md explicitly requires navigation
2. **Check TASKS.md first** - Only add sidebar if tasks mention "navigation", "menu", or "sidebar"
3. **Remove ALL template items** - No inventory, IAM, invoices, or "design only" labels
4. **If sidebar needed (per TASKS.md)**:
   ```typescript
   // Start with empty array - remove ALL defaults
   const sidebarItems = [];

   // Only add items that match user's actual features
   // Example for task management app (if TASKS.md requires navigation):
   const sidebarItems = [
     { label: 'Dashboard', path: '/dashboard', icon: 'home' },
     { label: 'Tasks', path: '/tasks', icon: 'list' },
     { label: 'Settings', path: '/settings', icon: 'settings' }
   ];
   ```
5. **Remove "design only" label** - Delete any placeholder text/labels

**Implementation approach:**
- First check: Does TASKS.md have a task for navigation/sidebar?
- If NO: Remove AppSidebar component entirely
- If YES: Empty the default items, add only what's needed

### Step 5: Git Workflow (COMMIT FREQUENTLY WITH UPDATED TRACKING)

**Commit Frequency: After EVERY completed task or sub-task**

```bash
# Branch for each feature
git checkout -b feature/[task-name]

# BEFORE EVERY COMMIT - Update tracking files:
# 1. Update TASKS.md - mark current task [x]
# 2. Update SCRATCHPAD.md - add implementation notes
# 3. Update FEATURELIST.md - if feature complete
# 4. Update CLOUD.md - if schemas/config changed

# Then commit:
git add .
git diff --staged  # Review ALL changes including tracking files

# Compliance checklist:
# - Used MCP for schema creation?
# - Followed 3-layer hierarchy?
# - Used AdvanceDataTable for tables?
# - Used ConfirmationModal for confirmations?
# - Followed recipes from llm-docs?
# - Updated TASKS.md with completion status?

git commit -m "feat: implement [task] using MCP and Selise patterns

- Completed: [specific features from FEATURELIST.md]
- Updated: TASKS.md, SCRATCHPAD.md status
- References: [relevant schemas from CLOUD.md]"

git checkout main
git merge feature/[task-name]
```

## Quick Start Commands

```bash
# After MCP project creation
cd [project-name]
npm install
npm start

# Development
npm run lint       # Check code quality
npm test           # Run tests
npm run build      # Production build
```
