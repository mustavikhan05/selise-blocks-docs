# Selise Development Agent Instructions

You are a specialized AI agent for building applications using the Selise Blocks component library. This document provides comprehensive instructions for developing with Selise patterns.

## Project Setup Requirements

### 1. MCP Automated Project Creation (Agent Handles)
**CRITICAL**: Project creation is now automated via MCP tools - follow CLAUDE.md workflow:

```python
# Agent uses MCP to create project automatically
# User only provides: project name, GitHub username, repository name
create_project(
    project_name="UserProvidedName",
    github_username="user123",
    repository_name="task-app"
)

# If local development requested:
create_local_repository(project_name="UserProvidedName")
```

**MCP Handles:**
- Selise Cloud project creation
- GitHub repository integration
- Application domain generation
- Local repository setup via Blocks CLI

### 2. Component Library Access (Automatic)
The MCP-created project automatically includes the Selise Blocks component library.

**Development Workflow:**
1. Agent uses MCP to create project (user provides names only)
2. Agent creates schemas via MCP (`create_schema`, `list_schemas`)
3. Agent builds features using auto-included Selise components
4. Components imported from established paths

**Important**: Agent works in MCP-created Selise React project with component library ready to use.

### 2. Project Detection
A project uses Selise if you find:
- Imports from `modules/*/component/`
- Imports from `@/components/blocks/` or `@/components/ui-kit/`
- `AdvanceDataTable` or `ConfirmationModal` in the codebase
- Selise-style folder structure: `src/modules/[feature-name]/component/`

## Core Development Principles

### The 3-Layer Hierarchy Rule
**Always follow this order when building components:**

1. **Feature Level First** - Check `modules/*/component/` for existing solutions
2. **Block Level Second** - Use `@/components/blocks/` for business patterns
3. **UI Level Last** - Use `@/components/ui-kit/` as the foundation

### Import Decision Matrix

#### ✅ Always Import (Never Recreate)
```typescript
// All UI components
import { Button, Input, Card, Table, Dialog, Badge } from '@/components/ui-kit/*'

// Proven block patterns
import ConfirmationModal from '@/components/blocks/confirmation-modal/confirmation-modal'
import { DataTableColumnHeader } from '@/components/blocks/data-table/data-table-column-header'
import CustomAvatar from '@/components/blocks/custom-avatar/custom-avatar'

// Complete feature solutions (when they fit exactly)
// Note: inventory is REFERENCE-ONLY - study the pattern, build your own
```

#### ❌ Never Import (Create Custom)
```typescript
// Business logic - always feature-specific
// ❌ import { createAdvanceTableColumns } from 'modules/inventory/...'
// ✅ Create: createYourTableColumns

// Forms - always feature-specific
// ❌ import { InventoryForm } from 'modules/inventory/...'
// ✅ Create: YourFeatureForm

// Services/Hooks - always feature-specific
// ❌ import { useInventory } from 'modules/inventory/...'
// ✅ Create: useYourFeature

// CRITICAL: inventory module is REFERENCE-ONLY - study patterns, don't import
```

## Standard Development Patterns

### Data Table Implementation
When building data tables, follow this exact pattern:

```typescript
// 1. Use Core Data Table Component
import { DataTable } from '@/components/core/data-table'

// 2. Use Block Patterns
import { DataTableColumnHeader } from '@/components/blocks/data-table/data-table-column-header'

// 3. Create Custom Business Logic
export const createYourTableColumns = ({ t, onEdit, onDelete }) => [
  {
    accessorKey: 'name',
    header: ({ column }) => <DataTableColumnHeader column={column} title={t('Name')} />,
  },
  {
    id: 'actions',
    cell: ({ row }) => (
      <Button variant="destructive" onClick={() => onDelete(row.original)}>
        Delete
      </Button>
    ),
  },
];

// 4. Implement the Complete Solution
<DataTable
  data={yourData}
  columns={createYourTableColumns({ t, onEdit, onDelete })}
  isLoading={isLoading}
  onPaginationChange={handlePaginationChange}
/>
```

### Confirmation Dialogs
**Always use ConfirmationModal - never create custom confirmation dialogs:**

```typescript
import ConfirmationModal from '@/components/blocks/confirmation-modal/confirmation-modal'

const [deleteModal, setDeleteModal] = useState({ open: false, item: null });

<ConfirmationModal
  open={deleteModal.open}
  onOpenChange={(open) => setDeleteModal({ open, item: null })}
  title="Delete Item"
  description={`Are you sure you want to delete "${deleteModal.item?.name}"? This action cannot be undone.`}
  onConfirm={handleDelete}
/>
```

### Form Development
Use React Hook Form with Zod validation:

```typescript
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { Form, FormField, FormItem, FormLabel, FormControl, FormMessage } from '@/components/ui-kit/form'
import { Input } from '@/components/ui-kit/input'
import { Button } from '@/components/ui-kit/button'

const schema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
});

const form = useForm({
  resolver: zodResolver(schema),
});

<Form {...form}>
  <FormField
    control={form.control}
    name="name"
    render={({ field }) => (
      <FormItem>
        <FormLabel>Name</FormLabel>
        <FormControl>
          <Input {...field} />
        </FormControl>
        <FormMessage />
      </FormItem>
    )}
  />
</Form>
```

## Feature Development Workflow

### 1. Data Layer Setup
```typescript
// types/your-feature.types.ts
export interface YourDataItem {
  id: string;
  name: string;
  // ... other fields
}

// services/your-feature.service.ts  
export const getData = async (params) => {
  return graphqlClient.query({
    query: YOUR_QUERY,
    variables: { input: params },
  });
};

// hooks/use-your-feature.ts
export const useGetData = (params) => {
  return useGlobalQuery({
    queryKey: ['your-data', params],
    queryFn: getData,
  });
};
```

### 2. Component Implementation
```typescript
// components/your-main-component.tsx
export function YourMainComponent() {
  const { data, isLoading } = useGetData(params);
  
  return (
    <AdvanceDataTable
      data={data || []}
      columns={yourColumns}
      isLoading={isLoading}
    />
  );
}
```

### 3. Page Integration
```typescript
// pages/your-feature/your-feature.tsx
export function YourFeaturePage() {
  return (
    <div className="container mx-auto py-6">
      <YourMainComponent />
    </div>
  );
}
```

## State Management Patterns

### React Query Integration
```typescript
import { useGlobalQuery, useGlobalMutation } from 'state/query-client/hooks'
import { useToast } from 'hooks/use-toast'

// Queries
const { data, isLoading, error } = useGlobalQuery({
  queryKey: ['data', params],
  queryFn: serviceFunction,
  staleTime: 5 * 60 * 1000,
});

// Mutations
const { mutate, isPending } = useGlobalMutation({
  mutationFn: mutationFunction,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['data'] });
    toast({ title: 'Success' });
  },
});
```

### Local State Patterns
```typescript
// UI state
const [isOpen, setIsOpen] = useState(false);
const [selectedItems, setSelectedItems] = useState([]);

// Form state (use React Hook Form)
const form = useForm({ resolver: zodResolver(schema) });

// Modal state
const [modal, setModal] = useState({ open: false, item: null });
```

## Error Handling & Loading States

### Standard Error Patterns
```typescript
const { data, isLoading, error } = useGetData(params);

if (error) {
  return <div>Error loading data: {error.message}</div>;
}

<AdvanceDataTable
  data={data || []}
  isLoading={isLoading}
  error={error}
/>
```

### Loading States
```typescript
// Buttons
<Button loading={isPending}>
  {isPending ? 'Saving...' : 'Save'}
</Button>

// Tables
<AdvanceDataTable
  data={data}
  isLoading={isLoading}
/>

// Forms
<form onSubmit={form.handleSubmit(onSubmit)}>
  {/* form fields */}
  <Button type="submit" loading={form.formState.isSubmitting}>
    Submit
  </Button>
</form>
```

## Common Implementation Tasks

### "Build a data management interface"
1. Use `AdvanceDataTable` for the main table
2. Create custom columns with `DataTableColumnHeader`
3. Add CRUD buttons in action column
4. Use `ConfirmationModal` for delete operations
5. Create forms with React Hook Form + Zod
6. Implement React Query hooks for data operations

### "Add authentication/authorization"
1. Check existing auth patterns in `modules/auth/`
2. Use `PermissionGuard` if available in blocks
3. Follow existing authentication flows
4. Use standard form patterns for login/signup

### "Create a dashboard"
1. Use `Card` components for sections
2. Check for existing dashboard patterns in features
3. Use appropriate charts/visualizations
4. Follow grid layout patterns

### "Build a file management interface"
1. Check `modules/file-manager/` for existing patterns
2. Use `CustomAvatar` for profile pictures
3. Handle file uploads with proper validation
4. Use standard progress indicators

## Integration with Selise Cloud (MCP Ready)

Selise Cloud MCP server is now available:
- **ALWAYS use MCP** for schema management (`create_schema`, `list_schemas`)
- **ALWAYS use MCP** for project creation (`create_project`) 
- **Use MCP** for authentication setup (`activate_social_login`)
- **Follow MCP patterns** documented in CLAUDE.md

Implementation:
- Use MCP tools for backend setup
- Use GraphQL endpoints for data operations
- **Follow graphql-crud.md recipe** for data operations (NOT inventory patterns!)

## TypeScript Best Practices

### Interface Definitions
```typescript
// Always define proper interfaces
interface ComponentProps {
  data: DataItem[];
  onAction: (item: DataItem) => void;
  isLoading?: boolean;
}

// Use generic types for reusable components
interface TableProps<T> {
  data: T[];
  columns: ColumnDef<T>[];
}
```

### Import Organization
```typescript
// 1. External libraries
import React, { useState, useCallback } from 'react'
import { useForm } from 'react-hook-form'

// 2. Block level imports
import ConfirmationModal from '@/components/blocks/confirmation-modal/confirmation-modal'

// 3. UI level imports
import { Button, Input, Card } from '@/components/ui-kit/*'

// 4. Core components
import { DataTable } from '@/components/core/data-table'

// 5. Local imports (within your module)
import { useYourFeature } from '../hooks/use-your-feature'
import { YourDataItem } from '../types/your-feature.types'

// NEVER import from other modules (modules/inventory/* is REFERENCE-ONLY)
```

## Quality Guidelines

### Code Quality
- Use TypeScript strictly - no `any` types
- Follow existing naming conventions
- Use proper error boundaries
- Implement loading states consistently
- Add proper accessibility attributes

### Component Quality
- Make components reusable when appropriate
- Export reusable components in feature `index.ts`
- Follow single responsibility principle
- Use composition over inheritance

### Testing
- Write unit tests for business logic
- Test component interactions
- Test error states
- Follow existing testing patterns

## Decision Points

### "Should I create a new component?"
1. Check if existing feature components solve this
2. Check if block components provide the pattern
3. Only create custom if business logic is unique
4. Always export if potentially reusable

### "Should I use this existing component?"
1. If it's from UI layer → Always use
2. If it's from Block layer → Use if it fits your pattern
3. If it's from Feature layer → Use only if it solves your exact problem
4. If it's business logic → Never import, create custom

### "How do I handle this complex requirement?"
1. Study existing similar implementations in other features
2. Break down into smaller, manageable components
3. Use established patterns from inventory/invoices features
4. Follow the 3-layer hierarchy

Remember: The goal is to build consistent, maintainable applications that leverage Selise's powerful component ecosystem while following established architectural patterns.