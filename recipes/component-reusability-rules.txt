# Recipe: Component Import & Reusability Rules

## 🚨 CRITICAL: Import Rules MUST Be Followed

**Breaking these rules causes build errors, runtime errors, and import cycles.**

## The Golden Rule

```
✅ CAN import: ui-kit/* and core/* components
✅ CAN import: Your own module's components
❌ CANNOT import: Other modules' components
```

## Import Path Requirements

### ALWAYS Use @/ Prefix

```typescript
// ✅ CORRECT - @/ prefix for ALL imports
import { Button } from '@/components/ui-kit/button';
import { DataTable } from '@/components/core/data-table';
import { graphqlClient } from '@/lib/graphql-client';
import { useToast } from '@/hooks/use-toast';

// ❌ WRONG - Relative or missing @/ prefix
import { Button } from 'components/ui-kit/button';
import { Button } from '../../components/ui-kit/button';
import { graphqlClient } from 'lib/graphql-client';
```

**Why:**
- @/ is configured as alias to src/ directory
- Prevents path resolution errors
- Consistent across all files

## Component Hierarchy

```
src/
├── components/
│   ├── ui-kit/              # ✅ Import from ANYWHERE
│   │   ├── button
│   │   ├── input
│   │   ├── form
│   │   ├── dialog
│   │   └── ... (34 Shadcn components)
│   │
│   └── core/                # ✅ Import from ANYWHERE
│       ├── data-table
│       ├── confirmation-modal
│       ├── custom-text-editor
│       └── ... (25 custom components)
│
└── modules/                 # ⚠️ RESTRICTED IMPORTS
    ├── inventory/           # ❌ CANNOT import from other modules
    │   └── component/
    ├── todos/
    │   └── component/       # ✅ CAN import ui-kit, core, own components
    └── [your-module]/
        └── component/
```

## What You CAN Import

### 1. UI-Kit Components (Shadcn-based)

```typescript
// ✅ ALWAYS safe to import from ui-kit
import { Button } from '@/components/ui-kit/button';
import { Input } from '@/components/ui-kit/input';
import { Form, FormField, FormItem, FormLabel, FormControl, FormMessage } from '@/components/ui-kit/form';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui-kit/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui-kit/select';
import { Card, CardHeader, CardContent, CardFooter } from '@/components/ui-kit/card';
import { Checkbox } from '@/components/ui-kit/checkbox';
import { RadioGroup, RadioGroupItem } from '@/components/ui-kit/radio-group';
import { Textarea } from '@/components/ui-kit/textarea';
import { Badge } from '@/components/ui-kit/badge';
import { Skeleton } from '@/components/ui-kit/skeleton';
import { toast } from '@/components/ui-kit/use-toast';
```

**All 34 ui-kit components:** See list_sections for full catalog

### 2. Core Components (Custom Selise Components)

```typescript
// ✅ ALWAYS safe to import from core
import { DataTable } from '@/components/core/data-table';
import { ConfirmationModal } from '@/components/core/confirmation-modal';
import { CustomTextEditor } from '@/components/core/custom-text-editor';
import { DateTimePicker } from '@/components/core/date-time-picker';
import { FileUploader } from '@/components/core/file-uploader';
// ... and 20 more core components
```

**All 25 core components:** See list_sections for full catalog

### 3. Your Own Module's Components

```typescript
// Inside src/modules/todos/component/TodoList.tsx
// ✅ CAN import other components from same module
import { TodoItem } from '@/modules/todos/component/TodoItem';
import { TodoForm } from '@/modules/todos/component/TodoForm';
import { useTodos } from '@/modules/todos/hooks/use-todos';
import { TodoService } from '@/modules/todos/services/todo.service';
```

### 4. Hooks (From Anywhere)

```typescript
// ✅ CAN import hooks
import { useToast } from '@/hooks/use-toast';
import { useAuth } from '@/hooks/use-auth';
import { useDebounce } from '@/hooks/use-debounce';
import { useGlobalQuery, useGlobalMutation } from '@/state/query-client/hooks';
```

### 5. Utilities & Lib

```typescript
// ✅ CAN import utilities
import { cn } from '@/lib/utils';
import { graphqlClient } from '@/lib/graphql-client';
import { formatDate } from '@/lib/date-utils';
```

## What You CANNOT Import

### ❌ Other Modules' Components

```typescript
// ❌ FORBIDDEN - Importing from other modules
import { InventoryTable } from '@/modules/inventory/component/InventoryTable';
import { ProductForm } from '@/modules/products/component/ProductForm';
import { UserCard } from '@/modules/users/component/UserCard';

// This will cause:
// - Import cycle errors
// - Build failures
// - Runtime errors
```

**Why forbidden:**
- Creates tight coupling between modules
- Causes import cycles
- Breaks module independence
- Makes testing difficult

## Proper Patterns for Reusability

### Pattern 1: Extract to Core (For Cross-Module Use)

```typescript
// ❌ WRONG - Importing inventory component
import { PriceDisplay } from '@/modules/inventory/component/PriceDisplay';

// ✅ CORRECT - Extract to core if needed everywhere
// 1. Move PriceDisplay to @/components/core/price-display
// 2. Then import from core
import { PriceDisplay } from '@/components/core/price-display';
```

**When to extract to core:**
- Component needed in 2+ modules
- Component is business-logic agnostic
- Component could be used in any module

### Pattern 2: Duplicate Small Components (For Module-Specific Logic)

```typescript
// If component is small and has module-specific logic
// ✅ CORRECT - Duplicate it in each module

// src/modules/todos/component/StatusBadge.tsx
export const TodoStatusBadge = ({ status }) => {
  // Todo-specific logic
  return <Badge variant={getVariant(status)}>{status}</Badge>;
};

// src/modules/orders/component/StatusBadge.tsx
export const OrderStatusBadge = ({ status }) => {
  // Order-specific logic (different from todos)
  return <Badge variant={getVariant(status)}>{status}</Badge>;
};
```

**When to duplicate:**
- Component < 50 lines
- Has module-specific logic
- Different behavior in different modules

### Pattern 3: Compose with ui-kit/core (Most Common)

```typescript
// ✅ BEST PRACTICE - Compose new components from ui-kit/core

// src/modules/todos/component/TodoCard.tsx
import { Card, CardHeader, CardContent } from '@/components/ui-kit/card';
import { Button } from '@/components/ui-kit/button';
import { Badge } from '@/components/ui-kit/badge';

export const TodoCard = ({ todo }) => {
  return (
    <Card>
      <CardHeader>{todo.Title}</CardHeader>
      <CardContent>
        <p>{todo.Description}</p>
        <Badge>{todo.Status}</Badge>
        <Button>Edit</Button>
      </CardContent>
    </Card>
  );
};
```

**When to compose:**
- Most of the time (90% of cases)
- Creating module-specific UI
- Combining ui-kit primitives with data

## Special Cases

### Forms: ALWAYS Use ui-kit Form Components

```typescript
// ✅ CORRECT - Use ui-kit form components
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Form, FormField, FormItem, FormLabel, FormControl, FormMessage } from '@/components/ui-kit/form';
import { Input } from '@/components/ui-kit/input';
import { Button } from '@/components/ui-kit/button';

// Don't create custom form components - compose from ui-kit
```

### Tables: Use DataTable from Core

```typescript
// ✅ CORRECT - Use DataTable from core
import { DataTable } from '@/components/core/data-table';
import { ColumnDef } from '@tanstack/react-table';

const columns: ColumnDef<Todo>[] = [
  { accessorKey: 'Title', header: 'Title' },
  { accessorKey: 'Status', header: 'Status' },
];

<DataTable columns={columns} data={todos} />
```

### Modals: Use Dialog from ui-kit or ConfirmationModal from Core

```typescript
// For delete confirmations:
import { ConfirmationModal } from '@/components/core/confirmation-modal';

<ConfirmationModal
  isOpen={isOpen}
  onClose={() => setIsOpen(false)}
  onConfirm={handleDelete}
  title="Delete Task"
  message="Are you sure you want to delete this task?"
/>

// For custom modals:
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui-kit/dialog';

<Dialog open={isOpen} onOpenChange={setIsOpen}>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Custom Modal</DialogTitle>
    </DialogHeader>
    {/* Your content */}
  </DialogContent>
</Dialog>
```

## Folder Structure Rules

### Module Structure

```
src/modules/[your-module]/
├── component/           # ✅ Singular "component" (NOT "components")
│   ├── TodoList.tsx
│   ├── TodoForm.tsx
│   └── TodoItem.tsx
├── hooks/
│   └── use-todos.ts
├── services/
│   └── todo.service.ts
├── graphql/
│   ├── queries.ts
│   └── mutations.ts
├── types/
│   └── todo.types.ts
└── index.ts             # Public exports
```

**Important:**
- Folder is `component/` (singular)
- NOT `components/` (plural)
- NOT `Components/` (capitalized)

### Import from Module Index

```typescript
// ✅ CORRECT - Export from module index
// src/modules/todos/index.ts
export { TodoList } from './component/TodoList';
export { useTodos } from './hooks/use-todos';

// Then import from module
import { TodoList, useTodos } from '@/modules/todos';

// ❌ WRONG - Direct import bypassing index
import { TodoList } from '@/modules/todos/component/TodoList';
```

## Reference-Only Pattern (Inventory Module)

```typescript
// 🚨 CRITICAL: Inventory module is REFERENCE-ONLY

// ❌ CANNOT import from inventory
import { InventoryTable } from '@/modules/inventory/component/InventoryTable';

// ✅ CAN read inventory code as reference
// 1. Open src/modules/inventory/component/InventoryTable.tsx
// 2. Study the patterns
// 3. Implement similar pattern in YOUR module
// 4. Use same ui-kit/core components
```

**Inventory is for:**
- Learning patterns
- Understanding structure
- Seeing examples
- NOT for importing

## Common Mistakes

### ❌ MISTAKE 1: Cross-Module Import

```typescript
// ❌ WRONG
import { ProductCard } from '@/modules/products/component/ProductCard';

// ✅ CORRECT - Extract to core if truly reusable
import { ProductCard } from '@/components/core/product-card';

// OR compose your own
import { Card } from '@/components/ui-kit/card';
const MyProductCard = () => <Card>...</Card>;
```

### ❌ MISTAKE 2: Missing @/ Prefix

```typescript
// ❌ WRONG
import { Button } from 'components/ui-kit/button';
import { DataTable } from 'components/core/data-table';

// ✅ CORRECT
import { Button } from '@/components/ui-kit/button';
import { DataTable } from '@/components/core/data-table';
```

### ❌ MISTAKE 3: Wrong Folder Name

```typescript
// ❌ WRONG
src/modules/todos/components/  // Plural!
src/modules/todos/Components/  // Capitalized!

// ✅ CORRECT
src/modules/todos/component/  // Singular, lowercase!
```

### ❌ MISTAKE 4: Importing Inventory Components

```typescript
// ❌ WRONG - Inventory is reference-only!
import { InventoryTable } from '@/modules/inventory/component/InventoryTable';
import { InventoryForm } from '@/modules/inventory/component/InventoryForm';

// ✅ CORRECT - Read inventory code, implement your own
// Open inventory files as reference
// Copy patterns, NOT components
// Use same ui-kit/core primitives
```

## Complete Example: Building a New Module

```typescript
// src/modules/todos/component/TodoList.tsx

// ✅ CORRECT imports
import { DataTable } from '@/components/core/data-table';  // Core component
import { ConfirmationModal } from '@/components/core/confirmation-modal';  // Core component
import { Button } from '@/components/ui-kit/button';  // UI-kit component
import { Badge } from '@/components/ui-kit/badge';  // UI-kit component
import { ColumnDef } from '@tanstack/react-table';  // External library
import { useGetTodos, useDeleteTodo } from '@/modules/todos/hooks/use-todos';  // Own hooks
import { TodoForm } from '@/modules/todos/component/TodoForm';  // Own component

// ❌ NO imports from other modules
// import { InventoryTable } from '@/modules/inventory/...';  // FORBIDDEN!

export const TodoList = () => {
  const { data, isLoading } = useGetTodos({ pageNo: 1, pageSize: 10 });
  const deleteMutation = useDeleteTodo();

  const columns: ColumnDef<Todo>[] = [
    {
      accessorKey: 'Title',
      header: 'Title',
    },
    {
      accessorKey: 'Status',
      header: 'Status',
      cell: ({ row }) => <Badge>{row.original.Status}</Badge>,
    },
    {
      id: 'actions',
      cell: ({ row }) => (
        <Button
          variant="destructive"
          onClick={() => deleteMutation.mutate({ itemId: row.original.ItemId })}
        >
          Delete
        </Button>
      ),
    },
  ];

  return <DataTable columns={columns} data={data?.items || []} />;
};
```

## Decision Tree: Where Should Component Live?

```
Is this component needed across 2+ modules?
├─ YES → Extract to @/components/core/
│        (Make it module-agnostic)
│
└─ NO → Keep in @/modules/[your-module]/component/
         (Module-specific component)

Does this component exist in ui-kit?
├─ YES → Use from @/components/ui-kit/
│
└─ NO → Build by composing ui-kit primitives

Is this similar to inventory module code?
├─ YES → Reference inventory code, implement similar in YOUR module
│        (Don't import from inventory!)
│
└─ NO → Build using patterns from this guide
```

## Summary Checklist

Before importing a component:
- [ ] Using @/ prefix for ALL imports
- [ ] NOT importing from other modules (modules/*)
- [ ] CAN import from ui-kit/* and core/*
- [ ] CAN import from own module
- [ ] Module folder named `component/` (singular)
- [ ] Inventory is reference-only (no imports)
- [ ] Forms use ui-kit Form components
- [ ] Tables use DataTable from core
- [ ] Modals use Dialog (ui-kit) or ConfirmationModal (core)
- [ ] Checked list_sections for available components

**Remember:** When in doubt, compose from ui-kit/core instead of cross-module imports!
