# Implementation Checklist

## Before ANY Implementation - Verify Prerequisites

- [ ] **Authenticated with MCP login tool**
  - Credentials verified
  - Authentication status confirmed with `get_auth_status`

- [ ] **Created project with MCP create_project**
  - Project name confirmed with user
  - GitHub repository connected
  - Local repository created (if needed)

- [ ] **Read ALL recipes in llm-docs/recipes/**
  - graphql-crud.md (MANDATORY)
  - confirmation-modal-patterns.md
  - react-hook-form-integration.md
  - iam-to-business-data-mapping.md (if multi-user app)
  - permissions-and-roles.md (if multi-user app)

- [ ] **Understood 3-layer component hierarchy**
  - Feature → Block → UI decision tree clear
  - Know when to use AdvanceDataTable
  - Know when to use ConfirmationModal

- [ ] **Created tracking files**
  - FEATURELIST.md exists with confirmed features
  - TASKS.md exists with broken-down tasks
  - SCRATCHPAD.md ready for notes
  - CLOUD.md ready for MCP operation logs

- [ ] **Created schemas with MCP tools**
  - All entities identified
  - Schemas created via `create_schema`
  - Schema names verified with `list_schemas`
  - Field details confirmed with `get_schema_details`

- [ ] **Documented operations in CLOUD.md**
  - All MCP operations logged
  - Schema names recorded
  - Project configuration documented

## During Implementation - Continuous Checks

- [ ] Update TASKS.md when starting/completing tasks
- [ ] Log decisions and errors in SCRATCHPAD.md
- [ ] Follow recipes for all patterns
- [ ] Use MCP tools to verify schema details before queries
- [ ] Commit frequently with updated tracking files

## Before Committing - Final Verification

- [ ] Used MCP for schema creation?
- [ ] Followed 3-layer hierarchy?
- [ ] Used AdvanceDataTable for tables?
- [ ] Used ConfirmationModal for confirmations?
- [ ] Followed recipes from llm-docs?
- [ ] Updated TASKS.md with completion status?
- [ ] Updated SCRATCHPAD.md with implementation notes?
- [ ] Updated CLOUD.md if schemas/config changed?
