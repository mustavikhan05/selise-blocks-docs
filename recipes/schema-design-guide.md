# Recipe: Schema Design Guide

## 🚨 CRITICAL: Read BEFORE Creating Any Schema

**This guide covers ALL schema design decisions for Selise Blocks applications.**

## Schema Creation Process

### Step 1: Analyze Features → Data Entities

From FEATURELIST.md, identify what data needs to be stored:

```
Feature: Todo Management
→ Needs: TodoTask entity

Feature: User Profiles
→ Needs: User entity (if data beyond IAM needed)

Feature: Categories/Tags
→ Needs: Category entity
```

### Step 2: Plan Fields for Each Entity

For each entity, determine:
- What information to track?
- What field types?
- What's required vs optional?
- Multi-user: UserId field needed?

### Step 3: Create via MCP

```python
# Create schema
create_schema(
    schema_name="TodoTask",
    project_key="[tenant_id]"
)

# Update fields
update_schema_fields(
    schema_id="[from create response]",
    fields=[...field definitions...]
)

# Finalize
finalize_schema(schema_id="[schema_id]")
```

## Field Types Reference

### String

```python
{
    "name": "Title",
    "type": "String",
    "required": True,
    "maxLength": 200  # Optional
}
```

**Use for:**
- Short text (titles, names, codes)
- Enum values (status, type)
- IDs and references

**Examples:**
- Title, Name, Status, Code, UserId, CategoryId

### Text (Long String)

```python
{
    "name": "Description",
    "type": "String",
    "required": False,
    "maxLength": 5000  # Longer limit for text
}
```

**Use for:**
- Long text (descriptions, notes, comments)
- Rich text content

**Examples:**
- Description, Notes, Comment, Content

### Number

```python
{
    "name": "Price",
    "type": "Number",
    "required": True,
    "min": 0  # Optional
}
```

**Use for:**
- Integers (quantity, count)
- Decimals (price, rating, percentage)

**Examples:**
- Price, Quantity, DisplayOrder, Rating, Stock

### Boolean

```python
{
    "name": "IsActive",
    "type": "Boolean",
    "defaultValue": True
}
```

**Use for:**
- True/false flags
- Status toggles

**Examples:**
- IsActive, IsPublished, IsCompleted, IsFeatured

### DateTime

```python
{
    "name": "DueDate",
    "type": "DateTime",
    "required": False
}
```

**Use for:**
- Dates and times
- Deadlines, schedules

**Examples:**
- DueDate, StartDate, EndDate, PublishedDate

**Important:** Always store in ISO 8601 format: `new Date().toISOString()`

### Array (List)

```python
{
    "name": "Tags",
    "type": "Array",
    "itemType": "String",  # Type of array elements
    "required": False
}
```

**Use for:**
- Lists of values
- Multiple selections

**Examples:**
- Tags, Categories, Permissions, Images

### Object (Nested)

```python
{
    "name": "Address",
    "type": "Object",
    "properties": {
        "Street": {"type": "String"},
        "City": {"type": "String"},
        "ZipCode": {"type": "String"}
    }
}
```

**Use for:**
- Complex nested data
- Related fields grouped together

**Examples:**
- Address, ContactInfo, Metadata

## Auto-Generated Fields (DO NOT ADD!)

Selise Cloud automatically adds these fields to EVERY schema:

```typescript
// 🚨 NEVER add these manually - they're auto-generated!

ItemId: string           // Unique identifier (use for display/references)
CreatedDate: DateTime    // Timestamp when created
ModifiedDate: DateTime   // Timestamp when last updated
CreatedBy: string        // User who created (IAM itemId)
ModifiedBy: string       // User who last modified (IAM itemId)
IsDeleted: boolean       // Soft delete flag
Language: string         // Language/locale
OrganizationIds: Array   // Multi-tenant support
Tags: Array             // Generic tagging
DeletedDate: DateTime    // When soft deleted
```

**Important:**
- ItemId is for queries/display
- Use _id (NOT ItemId) in mutation filters
- ItemId VALUE = MongoDB _id VALUE

## Naming Conventions

### Schema Names

```
✅ CORRECT - PascalCase, singular
- TodoTask (NOT TodoTasks, todo_task, or todoTask)
- User
- Category
- MenuItem

❌ WRONG
- TodoTasks (plural)
- todo_task (snake_case)
- todoTask (camelCase)
```

### Field Names

```
✅ CORRECT - PascalCase for custom fields
- Title
- Description
- DueDate
- UserId
- IsActive

❌ WRONG
- title (lowercase)
- due_date (snake_case)
- dueDate (camelCase)
```

**Exception:** Auto-generated fields use PascalCase (ItemId, CreatedDate, etc.)

## Multi-User Schema Patterns

### Simple Multi-User (UserId Field)

**When:** Users need to see only their own data

```python
# Add UserId field to business entities
fields = [
    {"name": "Title", "type": "String", "required": True},
    {"name": "Status", "type": "String"},
    {"name": "UserId", "type": "String", "required": True},  # ← User reference
]

# In GraphQL filter:
filter = JSON.stringify({ UserId: currentUser.itemId });
```

**Use for:**
- Todo apps (user sees own tasks)
- Personal notes, bookmarks
- Individual profiles

### Complex Multi-User (Separate User Schema)

**When:** Users need data beyond name/email from IAM

```python
# Create User schema
create_schema(schema_name="User")
fields = [
    {"name": "IAMUserId", "type": "String", "required": True},  # ← Reference to IAM
    {"name": "Bio", "type": "String"},
    {"name": "Avatar", "type": "String"},
    {"name": "Preferences", "type": "Object"},
]

# Link business entities to User
TodoTask_fields = [
    {"name": "UserId", "type": "String"},  # ← References User.ItemId
]
```

**Use for:**
- Social apps (user profiles, followers)
- Apps with extended user data
- Public user pages

### Decision Tree

```
Do users need data beyond name/email from IAM?
├─ NO → Use IAM itemId directly (simple pattern)
│        Add UserId field to business entities
│        Filter by UserId: { UserId: iamItemId }
│
└─ YES → Create User schema (complex pattern)
         Add IAMUserId field to User schema
         Reference User.ItemId in business entities
         NEVER use email as foreign key
```

## Common Schema Patterns

### Basic CRUD Entity

```python
# Example: TodoTask
fields = [
    {"name": "Title", "type": "String", "required": True, "maxLength": 200},
    {"name": "Description", "type": "String", "maxLength": 1000},
    {"name": "Status", "type": "String", "defaultValue": "pending"},
    {"name": "DueDate", "type": "DateTime"},
    {"name": "UserId", "type": "String", "required": True},  # Multi-user
]
```

### Category/Taxonomy Entity

```python
# Example: Category
fields = [
    {"name": "Name", "type": "String", "required": True, "maxLength": 100},
    {"name": "Description", "type": "String"},
    {"name": "Color", "type": "String"},  # For UI display
    {"name": "DisplayOrder", "type": "Number", "defaultValue": 0},
    {"name": "IsActive", "type": "Boolean", "defaultValue": True},
    {"name": "UserId", "type": "String"},  # If user-specific categories
]
```

### Reference Entity (Join Table)

```python
# Example: TaskCategory (Many-to-Many)
fields = [
    {"name": "TaskId", "type": "String", "required": True},
    {"name": "CategoryId", "type": "String", "required": True},
]

# Query pattern for "tasks in category X":
filter = JSON.stringify({ CategoryId: "category-id-here" });
# Returns all TaskCategory records → extract TaskId values → query tasks
```

### Settings/Config Entity

```python
# Example: UserSettings
fields = [
    {"name": "UserId", "type": "String", "required": True},
    {"name": "Theme", "type": "String", "defaultValue": "light"},
    {"name": "Notifications", "type": "Boolean", "defaultValue": True},
    {"name": "Preferences", "type": "Object"},  # Nested settings
]

# Usually one record per user
# Query by UserId to get settings
```

## Schema Validation Rules

### Required Fields

```python
# Mark critical fields as required
{"name": "Title", "type": "String", "required": True}

# Optional fields
{"name": "Description", "type": "String", "required": False}
```

### Default Values

```python
# Set sensible defaults
{"name": "Status", "type": "String", "defaultValue": "pending"}
{"name": "IsActive", "type": "Boolean", "defaultValue": True}
{"name": "DisplayOrder", "type": "Number", "defaultValue": 0}
```

### Max Length (Strings)

```python
# Prevent overly long inputs
{"name": "Title", "type": "String", "maxLength": 200}
{"name": "Description", "type": "String", "maxLength": 5000}
{"name": "Code", "type": "String", "maxLength": 50}
```

### Min/Max (Numbers)

```python
# Prevent invalid ranges
{"name": "Price", "type": "Number", "min": 0}
{"name": "Quantity", "type": "Number", "min": 0, "max": 9999}
{"name": "Rating", "type": "Number", "min": 0, "max": 5}
```

## MongoDB Considerations

### NoSQL = No JOINs

```
❌ WRONG - Thinking in SQL
"I need a foreign key relationship between Tasks and Categories"
"I'll JOIN tasks with categories to get category names"

✅ CORRECT - NoSQL approach
Option 1: Store CategoryId in Task, query Category separately
Option 2: Embed category data in Task (denormalization)
Option 3: Use TaskCategory join table + 2 queries
```

### References vs Embedded Data

**References (Normalized):**
```python
# Task references Category by ID
fields = [
    {"name": "CategoryId", "type": "String"},  # ← Reference
]

# Query Category separately:
category = await getCategoryById(task.CategoryId);
```

**Pros:** Updates to category affect all tasks
**Cons:** Requires 2 queries

**Embedded (Denormalized):**
```python
# Task embeds category data
fields = [
    {"name": "CategoryId", "type": "String"},
    {"name": "CategoryName", "type": "String"},  # ← Embedded
    {"name": "CategoryColor", "type": "String"},  # ← Embedded
]
```

**Pros:** Single query, faster
**Cons:** Must update all tasks if category changes

**When to use:**
- References: Data changes frequently (user profiles, prices)
- Embedded: Data rarely changes (country codes, static categories)

## Common Mistakes

### ❌ MISTAKE 1: Adding Auto-Generated Fields

```python
# ❌ WRONG
fields = [
    {"name": "ItemId", "type": "String"},  # Auto-generated!
    {"name": "CreatedDate", "type": "DateTime"},  # Auto-generated!
    {"name": "Title", "type": "String"},
]

# ✅ CORRECT - Only add custom fields
fields = [
    {"name": "Title", "type": "String"},
    {"name": "Description", "type": "String"},
]
```

### ❌ MISTAKE 2: Using Email as Foreign Key

```python
# ❌ WRONG - Email can change!
{"name": "UserEmail", "type": "String"}  # What if email changes?

# ✅ CORRECT - Use IAM itemId or User.ItemId
{"name": "UserId", "type": "String"}  # Immutable reference
```

### ❌ MISTAKE 3: Wrong Naming Convention

```python
# ❌ WRONG
schema_name = "todo_tasks"  # snake_case
fields = [{"name": "title", "type": "String"}]  # lowercase

# ✅ CORRECT
schema_name = "TodoTask"  # PascalCase singular
fields = [{"name": "Title", "type": "String"}]  # PascalCase
```

### ❌ MISTAKE 4: Not Planning for Multi-User

```python
# ❌ WRONG - No user isolation
fields = [
    {"name": "Title", "type": "String"},
    # Missing UserId field!
]

# ✅ CORRECT - Add UserId for user isolation
fields = [
    {"name": "Title", "type": "String"},
    {"name": "UserId", "type": "String", "required": True},
]
```

## Complete Schema Example

```python
# Feature: Todo App with Categories

# Schema 1: TodoTask
create_schema(schema_name="TodoTask")
update_schema_fields(
    schema_id="[id]",
    fields=[
        # Core fields
        {"name": "Title", "type": "String", "required": True, "maxLength": 200},
        {"name": "Description", "type": "String", "maxLength": 1000},

        # Status/dates
        {"name": "Status", "type": "String", "defaultValue": "pending"},
        {"name": "DueDate", "type": "DateTime"},
        {"name": "CompletedDate", "type": "DateTime"},

        # References
        {"name": "UserId", "type": "String", "required": True},
        {"name": "CategoryId", "type": "String"},

        # Flags
        {"name": "IsPriority", "type": "Boolean", "defaultValue": False},
    ]
)

# Schema 2: Category
create_schema(schema_name="Category")
update_schema_fields(
    schema_id="[id]",
    fields=[
        {"name": "Name", "type": "String", "required": True, "maxLength": 100},
        {"name": "Color", "type": "String", "defaultValue": "#3b82f6"},
        {"name": "DisplayOrder", "type": "Number", "defaultValue": 0},
        {"name": "UserId", "type": "String", "required": True},
        {"name": "IsActive", "type": "Boolean", "defaultValue": True},
    ]
)

# Auto-generated for both:
# - ItemId, CreatedDate, ModifiedDate
# - CreatedBy, ModifiedBy
# - IsDeleted, DeletedDate
# - Language, OrganizationIds, Tags
```

## Summary Checklist

Before creating schema, verify:
- [ ] Schema name is PascalCase singular (TodoTask NOT TodoTasks)
- [ ] Field names are PascalCase (Title NOT title)
- [ ] NOT including auto-generated fields (ItemId, CreatedDate, etc.)
- [ ] Using appropriate field types (String, Number, Boolean, DateTime, Array, Object)
- [ ] Required fields marked correctly
- [ ] Default values set where appropriate
- [ ] Max/min constraints for validation
- [ ] UserId field added for multi-user apps
- [ ] NOT using Email as foreign key
- [ ] Using references (IDs) instead of thinking in JOINs
- [ ] Documented in CLOUD.md before creation
- [ ] User confirmed schema structure

**Remember:** Once created, schemas are hard to modify - plan carefully!
