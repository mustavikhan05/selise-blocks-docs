# Architecture & Patterns

## Core Stack

- **Framework**: React TypeScript with Selise Blocks
- **State**: TanStack Query (server) + Zustand (client)
- **Forms**: React Hook Form + Zod validation
- **Styling**: Tailwind CSS
- **GraphQL**: Use recipes/graphql-crud.md (NOT inventory patterns!)

## Feature Structure (MUST FOLLOW)

**Directory Structure - Follow inventory pattern:**
```
src/modules/[feature-name]/
├── components/         # Feature-specific components
├── graphql/           # Queries and mutations (if using GraphQL)
├── hooks/             # Feature-specific hooks
├── services/          # API calls and business logic
├── types/             # TypeScript interfaces
└── index.ts           # Public exports
```

**⚠️ CRITICAL: Inventory is for STRUCTURE ONLY, not data operations!**
- Use `src/modules/inventory/` as template for folder structure
- NEVER copy inventory's GraphQL patterns - they're different
- For data operations, ONLY follow `recipes/graphql-crud.md`

## Component Hierarchy (3-Layer Rule)

```
1. Feature Components (src/modules/*/component/)
2. Block Components (src/components/blocks/)
3. UI Components (src/@/components/ui-kit/)
```

## Critical Patterns from Recipes

### GraphQL Operations (from graphql-crud.md - NOT inventory!)

**🚨 CRITICAL QUIRKS - MUST KNOW:**
- **ALWAYS get schema names from MCP first** using `list_schemas()` and `get_schema_details()`
- **Query fields**: Schema name + single 's' (TodoTask → TodoTasks)
- **Mutations**: operation + schema name (insertTodoTask, updateTodoTask)
- **Input types**: SchemaName + Operation + Input (TodoTaskInsertInput)
- ALWAYS use MongoDB filter: `JSON.stringify({_id: "123"})`
- Use `_id` field for filtering, NEVER `ItemId`
- NEVER use Apollo Client - use `graphqlClient` from `lib/graphql-client`
- Response: `result.[SchemaName]s.items` (no 'data' wrapper)
- **MANDATORY**: Use MCP to verify exact schema names before implementing

### Data Tables (from data-table-with-crud-operations.md)

- ALWAYS use AdvanceDataTable component
- Never create custom table implementations
- Follow the column definition patterns

### Forms (from react-hook-form-integration.md)

- Use React Hook Form with Zod schemas
- Follow validation patterns from recipe
- Use Form components from UI layer

### Confirmations (from confirmation-modal-patterns.md)

- ALWAYS use ConfirmationModal
- Never use browser confirm() or AlertDialog
- Follow async confirmation pattern

### Multi-User Apps (from iam-to-business-data-mapping.md & permissions-and-roles.md)

**🚨 CRITICAL for apps with multiple users:**
- **IAM Bridging**: Use business record provisioning to bridge IAM users to domain data
- **Data Isolation**: Filter all queries by business record ID - users only see their data
- **Role-Based Access**: Use `useUserRole()` hook for permissions and UI control
- **MCP Role Setup**: MUST create roles in Selise Cloud via MCP before implementing
- **Security Pattern**: Apply filtering at service layer, not component layer
- **User Provisioning**: Auto-create business records on first login

## Priority Documentation

When conflicts arise, follow this priority:
1. **MCP tool usage** (MCP section in workflows)
2. **Recipes** (llm-docs/recipes/)
3. **Component hierarchy** (llm-docs/component-catalog/)
4. **General patterns** (other docs)

Remember: MCP automation takes precedence over manual processes. Always use MCP tools for project setup, authentication, and schema management.
