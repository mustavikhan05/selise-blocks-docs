# Recipe: React Query Hooks Patterns

## 🚨 CRITICAL: Use Selise Wrappers, NOT Direct React Query

**ALWAYS use `useGlobalQuery` and `useGlobalMutation` wrappers, NEVER use React Query directly!**

## Import Pattern (MANDATORY)

```typescript
// ✅ CORRECT - Use Selise wrappers
import { useGlobalQuery, useGlobalMutation } from '@/state/query-client/hooks';
import { useQueryClient } from '@tanstack/react-query';
import { useToast } from '@/hooks/use-toast';

// ❌ WRONG - Never use direct React Query imports for queries/mutations
import { useQuery, useMutation } from '@tanstack/react-query';  // FORBIDDEN!
// Note: useQueryClient is OK to import for cache invalidation
```

## Query Hook Template

### Basic List Query

```typescript
// hooks/use-[feature].ts
import { useGlobalQuery } from '@/state/query-client/hooks';
import { getItems } from '../services/[feature].service';

export const useGetItems = (params: {
  pageNo: number;
  pageSize: number;
  filter?: string;
  sort?: string;
}) => {
  return useGlobalQuery({
    queryKey: ['items', params],  // Include params for cache granularity
    queryFn: getItems,
    staleTime: 5 * 60 * 1000,  // 5 minutes - adjust based on data freshness needs
    // Optional: Add enabled condition
    // enabled: params.pageNo > 0,
  });
};
```

### Single Item Query (By ID)

```typescript
export const useGetItemById = (itemId: string) => {
  return useGlobalQuery({
    queryKey: ['item', itemId],
    queryFn: () => getItemById(itemId),
    enabled: !!itemId,  // Only fetch if itemId exists
    staleTime: 5 * 60 * 1000,
  });
};
```

### Multi-User Query (With User Isolation)

```typescript
// 🚨 CRITICAL: Include userId in queryKey for proper cache isolation
import { useAuth } from '@/hooks/use-auth';

export const useGetMyItems = (params: {
  pageNo: number;
  pageSize: number;
}) => {
  const { user } = useAuth();
  const userId = user?.itemId;  // Get from auth context

  return useGlobalQuery({
    queryKey: ['items', userId, params],  // ← userId ensures cache isolation
    queryFn: (context) => {
      // Add userId to filter
      const filter = JSON.stringify({ UserId: userId });
      return getItems({
        ...context,
        queryKey: ['items', { ...params, filter }]
      });
    },
    enabled: !!userId,  // Only fetch if user is authenticated
    staleTime: 5 * 60 * 1000,
  });
};
```

## Mutation Hook Template

### Create Mutation

```typescript
import { useGlobalMutation } from '@/state/query-client/hooks';
import { useQueryClient } from '@tanstack/react-query';
import { useToast } from '@/hooks/use-toast';
import { addItem } from '../services/[feature].service';

export const useAddItem = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useGlobalMutation({
    mutationFn: addItem,
    onSuccess: () => {
      // Invalidate queries to refetch fresh data
      queryClient.invalidateQueries({ queryKey: ['items'] });

      toast({
        title: 'Success',
        description: 'Item added successfully',
      });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.message || 'Failed to add item',
        variant: 'destructive',
      });
    },
  });
};
```

### Update Mutation

```typescript
export const useUpdateItem = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useGlobalMutation({
    mutationFn: updateItem,
    onSuccess: (data, variables) => {
      // Invalidate list queries
      queryClient.invalidateQueries({ queryKey: ['items'] });

      // Invalidate specific item query if updating by ID
      if (variables.itemId) {
        queryClient.invalidateQueries({ queryKey: ['item', variables.itemId] });
      }

      toast({
        title: 'Success',
        description: 'Item updated successfully',
      });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.message || 'Failed to update item',
        variant: 'destructive',
      });
    },
  });
};
```

### Delete Mutation

```typescript
export const useDeleteItem = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useGlobalMutation({
    mutationFn: ({ itemId }: { itemId: string }) => deleteItem(itemId),
    onSuccess: (data, variables) => {
      // Invalidate all item queries
      queryClient.invalidateQueries({ queryKey: ['items'] });
      queryClient.invalidateQueries({ queryKey: ['item', variables.itemId] });

      toast({
        title: 'Success',
        description: 'Item deleted successfully',
      });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.message || 'Failed to delete item',
        variant: 'destructive',
      });
    },
  });
};
```

## Query Invalidation Patterns

### Basic Invalidation (All Items)

```typescript
// Invalidates ALL queries with 'items' key
queryClient.invalidateQueries({ queryKey: ['items'] });

// This will refetch:
// - ['items', { pageNo: 1, pageSize: 10 }]
// - ['items', { pageNo: 2, pageSize: 10 }]
// - ['items', userId, { ... }]
// - etc.
```

### Specific Invalidation (Single Item)

```typescript
// Invalidates only queries for this specific item
queryClient.invalidateQueries({ queryKey: ['item', itemId] });
```

### Multi-User Invalidation (User-Specific)

```typescript
// 🚨 CRITICAL: For multi-user apps, invalidate user-specific queries
const { user } = useAuth();
const userId = user?.itemId;

// Invalidate only this user's data
queryClient.invalidateQueries({ queryKey: ['items', userId] });

// This will NOT invalidate other users' cached data
```

### Exact Match Invalidation

```typescript
// Invalidates ONLY the exact query key match
queryClient.invalidateQueries({
  queryKey: ['items', { pageNo: 1, pageSize: 10 }],
  exact: true,
});
```

## Error Handling Patterns

### Standard Error Handling

```typescript
export const useAddItem = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useGlobalMutation({
    mutationFn: addItem,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['items'] });
      toast({ title: 'Item added successfully' });
    },
    onError: (error: any) => {
      // Extract error message
      const message = error.message ||
                      error.response?.data?.message ||
                      'Failed to add item';

      toast({
        title: 'Error',
        description: message,
        variant: 'destructive',
      });

      // Optional: Log to error tracking service
      console.error('Add item error:', error);
    },
  });
};
```

### GraphQL-Specific Error Handling

```typescript
onError: (error: any) => {
  // GraphQL errors come in specific format
  let message = 'An error occurred';

  if (error.graphQLErrors?.length > 0) {
    message = error.graphQLErrors[0].message;
  } else if (error.networkError) {
    message = 'Network error - please check your connection';
  } else if (error.message) {
    message = error.message;
  }

  toast({
    title: 'Error',
    description: message,
    variant: 'destructive',
  });
}
```

### Validation Error Handling

```typescript
onError: (error: any) => {
  // Check for validation errors
  if (error.code === 'VALIDATION_ERROR') {
    const fields = error.fields || {};
    Object.keys(fields).forEach(field => {
      toast({
        title: `Validation Error: ${field}`,
        description: fields[field],
        variant: 'destructive',
      });
    });
  } else {
    toast({
      title: 'Error',
      description: error.message || 'Operation failed',
      variant: 'destructive',
    });
  }
}
```

## Advanced Patterns

### Optimistic Updates

```typescript
export const useUpdateItem = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useGlobalMutation({
    mutationFn: updateItem,
    onMutate: async (variables) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: ['items'] });

      // Snapshot previous value
      const previousItems = queryClient.getQueryData(['items']);

      // Optimistically update
      queryClient.setQueryData(['items'], (old: any) => {
        return {
          ...old,
          items: old.items.map((item: any) =>
            item.ItemId === variables.itemId
              ? { ...item, ...variables.input }
              : item
          ),
        };
      });

      // Return context with snapshot
      return { previousItems };
    },
    onError: (error, variables, context) => {
      // Rollback on error
      if (context?.previousItems) {
        queryClient.setQueryData(['items'], context.previousItems);
      }
      toast({
        title: 'Error',
        description: 'Update failed - changes reverted',
        variant: 'destructive',
      });
    },
    onSettled: () => {
      // Always refetch after error or success
      queryClient.invalidateQueries({ queryKey: ['items'] });
    },
  });
};
```

### Dependent Queries

```typescript
// Query 2 depends on Query 1's result
export const useItemDetails = (categoryId: string) => {
  // First query: get category
  const { data: category } = useGetCategoryById(categoryId);

  // Second query: get items in category (depends on first)
  return useGlobalQuery({
    queryKey: ['items', 'by-category', categoryId],
    queryFn: () => getItemsByCategory(categoryId),
    enabled: !!category,  // Only run if category exists
  });
};
```

### Infinite Query (Pagination)

```typescript
import { useInfiniteQuery } from '@tanstack/react-query';

// Note: For infinite queries, you CAN use useInfiniteQuery directly
// (useGlobalInfiniteQuery doesn't exist yet)
export const useInfiniteItems = () => {
  return useInfiniteQuery({
    queryKey: ['items', 'infinite'],
    queryFn: ({ pageParam = 1 }) => {
      return getItems({
        queryKey: ['items', { pageNo: pageParam, pageSize: 20 }]
      });
    },
    getNextPageParam: (lastPage: any) => {
      return lastPage.hasNextPage
        ? (lastPage.pageNo || 0) + 1
        : undefined;
    },
    initialPageParam: 1,
  });
};
```

## Common Mistakes & Solutions

### ❌ MISTAKE 1: Using React Query Directly

```typescript
// ❌ WRONG
import { useQuery, useMutation } from '@tanstack/react-query';

const { data } = useQuery({ queryKey: ['items'], queryFn: getItems });
```

```typescript
// ✅ CORRECT
import { useGlobalQuery, useGlobalMutation } from '@/state/query-client/hooks';

const { data } = useGlobalQuery({ queryKey: ['items'], queryFn: getItems });
```

### ❌ MISTAKE 2: Not Including UserId in Multi-User Apps

```typescript
// ❌ WRONG - Cache shared across all users!
queryKey: ['items', params]

// ✅ CORRECT - Cache isolated per user
queryKey: ['items', userId, params]
```

### ❌ MISTAKE 3: Forgetting Query Invalidation

```typescript
// ❌ WRONG - Data doesn't refresh after mutation
onSuccess: () => {
  toast({ title: 'Success' });
  // Missing: queryClient.invalidateQueries
}

// ✅ CORRECT
onSuccess: () => {
  queryClient.invalidateQueries({ queryKey: ['items'] });
  toast({ title: 'Success' });
}
```

### ❌ MISTAKE 4: Wrong StaleTime

```typescript
// ❌ TOO SHORT - Refetches too often, poor performance
staleTime: 0,  // Refetches on every component mount

// ❌ TOO LONG - Stale data shown to user
staleTime: Infinity,  // Never refetches automatically

// ✅ CORRECT - Balance freshness vs performance
staleTime: 5 * 60 * 1000,  // 5 minutes for most data
staleTime: 1 * 60 * 1000,  // 1 minute for frequently changing data
staleTime: 30 * 60 * 1000, // 30 minutes for rarely changing data
```

## Complete Hook Example

```typescript
// hooks/use-tasks.ts
import { useGlobalQuery, useGlobalMutation } from '@/state/query-client/hooks';
import { useQueryClient } from '@tanstack/react-query';
import { useToast } from '@/hooks/use-toast';
import { useAuth } from '@/hooks/use-auth';
import {
  getTasks,
  getTaskById,
  addTask,
  updateTask,
  deleteTask,
} from '../services/task.service';

// List query with user isolation
export const useGetTasks = (params: { pageNo: number; pageSize: number }) => {
  const { user } = useAuth();
  const userId = user?.itemId;

  return useGlobalQuery({
    queryKey: ['tasks', userId, params],
    queryFn: (context) => {
      const filter = JSON.stringify({ UserId: userId });
      return getTasks({
        ...context,
        queryKey: ['tasks', { ...params, filter }],
      });
    },
    enabled: !!userId,
    staleTime: 5 * 60 * 1000,
  });
};

// Single task query
export const useGetTask = (taskId: string) => {
  return useGlobalQuery({
    queryKey: ['task', taskId],
    queryFn: () => getTaskById(taskId),
    enabled: !!taskId,
  });
};

// Add task mutation
export const useAddTask = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { user } = useAuth();

  return useGlobalMutation({
    mutationFn: addTask,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['tasks', user?.itemId] });
      toast({ title: 'Task added successfully' });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.message || 'Failed to add task',
        variant: 'destructive',
      });
    },
  });
};

// Update task mutation
export const useUpdateTask = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { user } = useAuth();

  return useGlobalMutation({
    mutationFn: updateTask,
    onSuccess: (data, variables) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', user?.itemId] });
      if (variables.itemId) {
        queryClient.invalidateQueries({ queryKey: ['task', variables.itemId] });
      }
      toast({ title: 'Task updated successfully' });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.message || 'Failed to update task',
        variant: 'destructive',
      });
    },
  });
};

// Delete task mutation
export const useDeleteTask = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { user } = useAuth();

  return useGlobalMutation({
    mutationFn: ({ taskId }: { taskId: string }) => deleteTask(taskId),
    onSuccess: (data, variables) => {
      queryClient.invalidateQueries({ queryKey: ['tasks', user?.itemId] });
      queryClient.invalidateQueries({ queryKey: ['task', variables.taskId] });
      toast({ title: 'Task deleted successfully' });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.message || 'Failed to delete task',
        variant: 'destructive',
      });
    },
  });
};
```

## Summary

**Key Rules:**
1. ✅ ALWAYS use `useGlobalQuery` and `useGlobalMutation` (NEVER direct React Query)
2. ✅ Include `userId` in queryKey for multi-user apps
3. ✅ Invalidate queries after mutations with `queryClient.invalidateQueries`
4. ✅ Use appropriate `staleTime` (5 minutes default)
5. ✅ Handle errors with toast notifications
6. ✅ Use `enabled` flag for conditional queries
7. ✅ Import from `@/state/query-client/hooks` (with @/ prefix)

**Remember:** These patterns ensure proper caching, user isolation, and error handling across all Selise Blocks applications.
