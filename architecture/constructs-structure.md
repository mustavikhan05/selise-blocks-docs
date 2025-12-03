# Selise Constructs Directory Structure Analysis

**Purpose**: Complete catalog of what's available in Selise Constructs for building real projects

**Date**: November 2, 2025

---

## Top-Level Directory Structure

```
selise-constructs/src/
├── components/          # UI Components (3-layer hierarchy)
├── modules/             # Complete feature modules (formerly "features/")
├── hooks/               # Reusable React hooks
├── lib/                 # Core utilities and clients
├── state/               # State management (Zustand + React Query)
├── utils/               # Helper functions
├── config/              # Configuration files
├── constant/            # Constants and configuration
├── providers/           # Context providers
├── pages/               # Page-level components
├── i18n/                # Internationalization
├── styles/              # Global styles
├── types/               # TypeScript type definitions
├── models/              # Data models
└── stories/             # Storybook stories
```

---

## 1. Components (`src/components/`)

### Layer 3: UI Components (`src/@/components/ui-kit/`)

**34 foundation components** - Most generic, shadcn-based:

```
accordion.tsx          label.tsx
alert-dialog.tsx       menubar.tsx
avatar.tsx             popover.tsx
badge.tsx              radio-group.tsx
breadcrumb.tsx         scroll-area.tsx
button.tsx             select.tsx
calendar.tsx           separator.tsx
card.tsx               sheet.tsx
chart.tsx              sidebar.tsx
checkbox.tsx           skeleton.tsx
collapsible.tsx        slider.tsx
command.tsx            switch.tsx
dialog.tsx             table.tsx
dropdown-menu.tsx      tabs.tsx
form.tsx               textarea.tsx
input.tsx              toast.tsx
toaster.tsx            tooltip.tsx
```

**Usage**: Always import these for basic UI primitives
```typescript
import { Button, Input, Card, Table } from '@/components/ui-kit/*'
```

---

### Layer 2: Block Components (`src/components/blocks/`)

**Business patterns and compound components**:

```
base-password-form/         # Password input with validation
confirmation-modal/         # Delete confirmations, etc.
custom-avatar/             # Avatar with fallbacks
custom-pagination-email/   # Email-style pagination
custom-text-editor/        # Rich text editor
data-table/                # Advanced table components
error-alert/               # Error display
gurads/                    # Route guards
  ├── permission-guard/
  ├── role-guard/
  └── combined-guard/
language-selector/         # Language switching
layout/                    # Layout components
  ├── app-sidebar.tsx
  └── sidebar-menu-Item.tsx
menu-icon/                 # Icon management
sidebar/                   # Sidebar components
u-profile-menu/            # User profile menu
```

**Key Block Components**:

#### ConfirmationModal
```typescript
import ConfirmationModal from 'components/blocks/confirmation-modal/confirmation-modal'

<ConfirmationModal
  open={isOpen}
  onOpenChange={setIsOpen}
  title="Delete Item"
  description="Are you sure?"
  onConfirm={handleDelete}
/>
```

#### DataTable Components
```typescript
import { DataTableColumnHeader } from 'components/blocks/data-table/data-table-column-header'
import { DataTablePagination } from 'components/blocks/data-table/data-table-pagination'
import { DataTableFacetedFilter } from 'components/blocks/data-table/data-table-faceted-filter'
```

#### Route Guards
```typescript
import { PermissionGuard } from 'components/blocks/gurads/permission-guard'
import { RoleGuard } from 'components/blocks/gurads/role-guard'
import { CombinedGuard } from 'components/blocks/gurads/combined-guard'
```

---

### Layer 3: Core Components (`src/components/core/`)

**Specialized input components**:

```
dynamic-breadcrumb/              # Dynamic breadcrumb navigation
loading-overlay.tsx              # Loading states
otp-input/                       # OTP input fields
password-strength-checker.tsx    # Password validation UI
phone-input/                     # International phone inputs
u-password-input/                # Enhanced password input
uCheckbox/                       # Custom checkbox
```

---

## 2. Features (`src/modules/`)

**Complete, production-ready feature modules** (16 features):

```
activity-log-v1/        # Activity logging (version 1)
activity-log-v2/        # Activity logging (version 2)
auth/                   # Authentication system
big-calendar/           # Calendar/scheduling
captcha/                # CAPTCHA integration
chat/                   # Real-time chat
dashboard/              # Dashboard components
email/                  # Email management
file-manager/           # File upload/management
finance/                # Financial features
iam/                    # Identity & Access Management
inventory/              # Inventory management ⭐
invoices/               # Invoice management
notification/           # Notification system
profile/                # User profiles
task-manager/           # Task/project management
```

### Feature Structure (Inventory Example)

Each feature follows the same pattern:

```
modules/inventory/
├── component/                    # Feature-specific components (SINGULAR!)
│   ├── advance-data-table/      # Complete table system (REFERENCE-ONLY)
│   └── advance-table-columns-toolbar/
├── graphql/                     # GraphQL operations
│   ├── queries.ts
│   └── mutations.ts
├── hooks/                       # Feature-specific hooks
│   └── use-inventory.ts
├── services/                    # API/business logic
│   └── inventory.service.ts
├── types/                       # TypeScript types
│   └── inventory.types.ts
└── index.ts                     # Public exports
```

**Key Pattern from Inventory Service**:

```typescript
// src/modules/inventory/services/inventory.service.ts
import { graphqlClient } from 'lib/graphql-client';

export const getInventory = async (context: {
  queryKey: [string, { pageNo: number; pageSize: number }];
}) => {
  const [, { pageNo, pageSize }] = context.queryKey;
  return graphqlClient.query({
    query: GET_INVENTORY_QUERY,
    variables: {
      input: {
        filter: '{}',
        sort: '{}',
        pageNo,
        pageSize,
      },
    },
  });
};

export const addInventoryItem = async (params) => {
  return graphqlClient.mutate({
    query: INSERT_INVENTORY_ITEM_MUTATION,
    variables: params,
  });
};
```

---

## 3. Hooks (`src/hooks/`)

**12 reusable React hooks**:

```typescript
use-auth.ts                  // Authentication state
use-device-capabilities.ts   // Device detection
use-error-handler.ts         // Global error handling
use-filtered-menu.ts         // Sidebar filtering
use-language-switcher.ts     // i18n language switching
use-media-query.ts           // Responsive breakpoints
use-mobile.tsx               // Mobile detection
use-permissions.ts           // Permission checking
use-popover-width.ts         // Popover positioning
use-resend-otp.ts            // OTP resending
use-toast.ts                 // Toast notifications ⭐
use-view-mode.tsx            // View mode switching
```

### Key Hook: `useToast`

```typescript
// src/hooks/use-toast.ts
import { useToast } from 'hooks/use-toast';

const { toast } = useToast();

toast({
  title: 'Success',
  description: 'Item created successfully',
  variant: 'default', // or 'destructive'
});
```

**Features**:
- Toast limit: 1 at a time
- Auto-dismiss: 10 seconds
- Update/dismiss capabilities
- Supports actions

---

## 4. Lib (`src/lib/`)

**Core utilities and API clients**:

```
api/                          # API utilities
custom-date-formatter.ts      # Date formatting
graphql-client.ts            # GraphQL client ⭐
https.ts                     # HTTP client
mobile-responsiveness.ts     # Mobile utils
utils.ts                     # General utilities
```

### GraphQL Client

```typescript
// src/lib/graphql-client.ts
import { graphqlClient } from 'lib/graphql-client';

// Query
const data = await graphqlClient.query({
  query: YOUR_QUERY,
  variables: { input: {...} }
});

// Mutation
const result = await graphqlClient.mutate({
  query: YOUR_MUTATION,
  variables: { input: {...} }
});
```

**Key details**:
- Automatic authentication headers
- Error handling with GraphQL errors
- Environment-based configuration
- Uses project short key from env

### Utils

```typescript
// src/lib/utils.ts
import { cn } from 'lib/utils';

// Tailwind class merging
<div className={cn('base-class', condition && 'conditional-class')} />
```

---

## 5. State Management (`src/state/`)

### React Query (`src/state/query-client/`)

```
hooks.tsx                # Global query/mutation hooks ⭐
index.tsx                # Query client setup
```

**Global hooks with error handling**:

```typescript
// src/state/query-client/hooks.tsx
import { useGlobalQuery, useGlobalMutation } from 'state/query-client/hooks';

// Query with automatic error handling
const { data, isLoading } = useGlobalQuery({
  queryKey: ['inventory', { pageNo: 1, pageSize: 10 }],
  queryFn: getInventory,
});

// Mutation with automatic session expiration handling
const { mutate, isPending } = useGlobalMutation({
  mutationFn: addInventoryItem,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['inventory'] });
  },
});
```

**Features**:
- Automatic session expiration handling
- Global error toast notifications
- Redirect to login on invalid refresh token
- Validation error handling

### Zustand Store (`src/state/store/`)

```
auth/                    # Authentication store
```

---

## 6. Utils (`src/utils/`)

```
custom-date.ts              # Date utilities
custom-date.spec.ts         # Tests
project-key.ts              # Project key management
sanitizer.js                # Input sanitization
sidebar-utils.ts            # Sidebar helpers
uuid.js                     # UUID generation
validation/                 # Validation utilities
```

---

## 7. Config (`src/config/`)

```typescript
api.ts                      // API configuration
roles-permissions.ts        // RBAC configuration
```

**API Config Pattern**:
```typescript
// src/config/api.ts
const API_CONFIG = {
  baseUrl: process.env.REACT_APP_API_BASE_URL,
  blocksKey: process.env.REACT_APP_BLOCKS_KEY,
  // ...
};
```

---

## 8. Constants (`src/constant/`)

```typescript
auth-public-routes.ts       // Public route list
auth.ts                     // Auth constants
dynamic-breadcrumb-title.ts // Breadcrumb config
sidebar-menu.ts             // Sidebar menu config ⭐
sso.ts                      // SSO configuration
```

### Sidebar Menu Configuration

```typescript
// src/constant/sidebar-menu.ts
import { MenuItem } from 'models/sidebar';

const createMenuItem = (
  id: string,
  name: string,
  path: string,
  icon?: string,
  options = {}
): MenuItem => ({
  id, name, path, icon, ...options
});

export const menuItems: MenuItem[] = [
  createMenuItem('dashboard', 'DASHBOARD', '/dashboard', 'LayoutDashboard'),
  createMenuItem('inventory', 'INVENTORY', '/inventory', 'Store', {
    isIntegrated: true
  }),
  // ... more items
];
```

**Menu Item Options**:
- `isIntegrated`: Feature is fully integrated
- `permissions`: Array of required permissions
- `roles`: Required user roles
- `hidden`: Hide from sidebar
- `children`: Nested menu items

---

## 9. Pages (`src/pages/`)

**Page-level components for routing**:

```
activity-log-v1/
activity-log-v2/
auth/                    # Login, register, etc.
calendar/
chat/
email/
error/                   # 404, 503, etc.
file-manager/
finance/
help/
inventory/
invoices/
main/
profile/
services/
task-manager/
```

---

## 10. Providers (`src/providers/`)

Context providers for global state

---

## 11. i18n (`src/i18n/`)

Internationalization setup and translations

---

## 12. Styles (`src/styles/`)

```
theme/                   # Theme configuration
```

Global styles and Tailwind configuration

---

## 13. Types (`src/types/`)

Shared TypeScript type definitions

---

## 14. Models (`src/models/`)

Data models and interfaces

---

## What Can Be Used in Real Projects?

### ✅ Always Use (Foundation)

1. **All UI Components** (`@/components/ui-kit/`) - shadcn-based primitives
2. **GraphQL Client** (`lib/graphql-client.ts`) - For all data operations
3. **Global Query/Mutation Hooks** (`state/query-client/hooks.tsx`) - Error handling
4. **Toast Hook** (`hooks/use-toast.ts`) - Notifications
5. **Utils** (`lib/utils.ts`) - Class name merging

### ✅ Use When Needed (Blocks)

1. **ConfirmationModal** - All confirmations
2. **DataTable Components** - Table headers, pagination
3. **Route Guards** - Permission/role-based access
4. **CustomAvatar** - User avatars

### ✅ Reference for Patterns (Features)

1. **Inventory Feature** - Complete CRUD example
2. **IAM Feature** - User management patterns
3. **File Manager** - File upload patterns
4. **Auth Feature** - Authentication flows

**DO NOT copy feature code directly** - use as reference for structure

### ✅ Customize for Your App

1. **Sidebar Menu** (`constant/sidebar-menu.ts`) - Replace with your routes
2. **Config** (`config/api.ts`) - Your API endpoints
3. **Routes** (`pages/`) - Your page structure

---

## Key Patterns to Follow

### 1. Feature Structure
```
modules/your-feature/
├── component/           # Feature components (Layer 1) - SINGULAR!
├── graphql/            # queries.ts + mutations.ts
├── hooks/              # use-your-feature.ts
├── services/           # your-feature.service.ts
├── types/              # your-feature.types.ts
└── index.ts            # Exports
```

### 2. Service Pattern
```typescript
export const getYourData = async (context) => {
  const [, { pageNo, pageSize }] = context.queryKey;
  return graphqlClient.query({
    query: YOUR_QUERY,
    variables: { input: { filter: '{}', pageNo, pageSize } }
  });
};
```

### 3. Hook Pattern
```typescript
export const useYourData = (params) => {
  return useGlobalQuery({
    queryKey: ['your-data', params],
    queryFn: getYourData,
  });
};
```

### 4. Component Pattern
```typescript
// NOTE: inventory is REFERENCE-ONLY - study pattern, build your own
// Use DataTable from @/components/core/data-table instead
import { DataTable } from '@/components/core/data-table'
import { DataTableColumnHeader } from '@/components/blocks/data-table'
import { Button } from '@/components/ui-kit/button'

// Create columns
const columns = [
  {
    accessorKey: 'name',
    header: ({ column }) => <DataTableColumnHeader column={column} title="Name" />
  }
];

// Use table
<DataTable data={data} columns={columns} isLoading={isLoading} />
```

---

## Summary

**Selise Constructs provides**:
- 34 UI components (shadcn-based)
- 13 block components (business patterns)
- 16 complete features (reference implementations)
- 12 reusable hooks
- Global state management (Zustand + React Query)
- GraphQL client with error handling
- i18n support
- Route guards and permissions
- Toast notifications
- Form components

**For a new project, you can**:
1. Use all UI and block components directly
2. Copy the feature structure pattern
3. Reference feature implementations for complex patterns
4. Customize sidebar, routes, and config
5. Build on the GraphQL client and state management
