# L3 React Blocks Construct - Component Usage Guide

## Component Hierarchy and Selection Strategy

When building components, follow this hierarchy:

1. **Check `core` folder first** - Built on top of ui-kit with specific use cases
2. **If nothing suitable in core, check `ui-kit`** - Base design components
3. **Build using ui-kit components** - If no exact match exists

### Important Rules:
- **DO NOT reuse components from inside modules** - If you find components inside a module, go to the components folder instead
- **Within the same module** - You can use module components directly
- **Modules are not meant for reuse across different modules**

---

## Core Components

### app-sidebar
**Purpose:** Side bar/menu layout component

**Use Case:** When you need to implement sidebar or menu layouts in your application

---

### base-password-form
**Purpose:** Validated form for passwords

**Use Case:** When you need password input with built-in validation

---

### captcha
**Purpose:** CAPTCHA integration component

**Use Case:** When CAPTCHA verification is needed (supports multiple CAPTCHA providers)

---

### confirmation-modal
**Purpose:** Generic confirmation modal

**Use Case:** For any type of user confirmation prompt or dialog

---

### custom-avatar
**Purpose:** Custom avatar component

**Use Case:** Displaying user avatars with customization options

---

### custom-checkbox
**Purpose:** Custom styled checkbox

**Use Case:** When you need checkbox inputs - use this instead of the basic ui-kit checkbox

---

### custom-pagination-email
**Purpose:** Email-specific pagination design

**Use Case:** Only for email-type designs or related interfaces that need pagination

---

### custom-text-editor
**Purpose:** Frontend text editor

**Use Case:** When you need rich text editing capabilities

---

### data-table
**Purpose:** Advanced data table with pagination, sorting, and column visibility

**Use Case:** For displaying tabular data with:
- Pagination
- Sorting functionality
- Column visibility toggles

---

### dynamic-breadcrumb
**Purpose:** Automatic breadcrumb generation based on URL

**Use Case:** Creating breadcrumbs automatically from the base URL path

---

### error-alert
**Purpose:** Error display component

**Use Case:** Showing error messages to users

---

### guards (In Development Phase)
**Purpose:** Connect with permissions/roles for frontend authorization

**Use Case:** To implement role-based or permission-based access control in the frontend

**Note:** Still in development - defer to next meeting for detailed discussion

---

### language-selector (Defer to Next Meeting)
**Purpose:** Connects to language services with API integration

**Use Case:** Displays available languages (supports 5 languages)

**Note:** Usage with language service integration will be covered in the next meeting

---

## UI-Kit Components

**Purpose:** Provides base designs and foundational UI elements

**Strategy:** If you don't find what you need in `core`, use ui-kit components to build your solution

### Critical UI-Kit Components (Must Reference)

#### card.tsx
**Importance:** Very high - used extensively across the application

**Features:**
- Wrapper and layout component
- Dark mode and light mode support
- Overlay creation
- Used in almost everything

---

#### form, input, label, menubar
**Importance:** Critical - LLM must reference these use cases

**Use Case:** Form handling, input fields, labels, and menu bar implementations

These are the most important ui-kit components and should always be referenced when building forms or menus.

---

## Services Folder

### Reference File
**File:** User service file

**Purpose:** Contains API integration patterns

**API Pattern:** Use GraphQL CRUD recipe (refer to existing documentation)

---

## Modules Folder

**Important:** Defer detailed discussion to next meeting

### Key Rule:
- **DO NOT reuse module components across different modules**
- If you find a component inside `{module}/component`, go to the main `components` folder instead
- Only reuse within the same module

---

## Next Meeting Agenda

### Topics to Cover:

1. **Modules**
   - Detailed walkthrough of module structure
   - When and how to use module-specific components

2. **Language-selector Integration**
   - How to use language-selector with the language service
   - API integration patterns

3. **Authorization Implementation**
   - How to build something with permissions/roles
   - Frontend authorization patterns using guards

---

## Documentation Plan

### Current Scope: Svelte-Style Documentation

**Target:** Write Svelte-like documentation for all components in:
- `ui-kit` folder (all components)
- `core` folder (all components)

**Approach:** Short, concise documentation for each component

---

### Currently Workable

**Documentation will be created for:**
- All `ui-kit` components (except language-selector if present)
- All `core` components (except guards and language-selector)

---

### Deferred Until After Next Meeting

The following will NOT be documented in the current phase:

1. **Guards** (in core folder)
   - Role-based access patterns
   - Permission-based access patterns
   - Guards usage in production

2. **language-selector** (in core/ui-kit folder)
   - How language-selector connects with language service
   - Language service API integration

3. **Modules folder**
   - Module-specific components
   - Module structure and usage patterns

4. **Services folder**
   - Detailed API integration patterns
   - Service implementation examples

---

## Action Items

### Current Tasks:
1. **Write Svelte-style documentation** for all ui-kit and core components
2. **Send documentation** to Saiful Bhai (01964892201)
3. **Get feedback** from Saiful Bhai
4. **Test MCP** with documentation:
   - Internal testing
   - Testing with Saiful Bhai
   - Rezwan Bhai can also test the MCP

### Future Tasks (After Next Meeting):
1. Document modules folder and usage patterns
2. Document language-selector and language service integration
3. Document authorization patterns with roles/permissions
4. Document services folder with detailed examples
5. Check an existing app and try to modify it
6. Modify a construct

---

## Notes
- All components in `core` are built on top of `ui-kit`
- Always check the hierarchy: core → ui-kit → build custom
- GraphQL CRUD patterns should be followed for API integration
- This document will be updated after meetings with additional module and authorization documentation
