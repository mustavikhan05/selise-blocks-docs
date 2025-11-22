# Potential Topics to Add to topics.json

## Workflow: Adding Components to topics.json

1. Read component from list below (one at a time)
2. Read actual component code from `l3-react-blocks-construct/src/components/[core|ui-kit]/[component].tsx`
3. Analyze code for use cases, triggers, warnings, next steps
4. Add entry to `topics.json` with all required fields
5. Mark component as ✅ DONE below
6. Repeat for next component

**Progress: 59/59 components added** ✅ Core Complete | ✅ UI-Kit Complete

---

## Current topics.json Structure

### Root Level Fields:
- `version`
- `base_url`
- `last_updated`
- `description`
- `topics` (array)
- `usage_notes`
- `workflow_summary`
- `multi_user_detection`

### Per Topic Required Fields:
1. `id` - Unique identifier (e.g., "custom-checkbox")
2. `title` - Display name (e.g., "Custom Checkbox Component")
3. `path` - Path to doc file (e.g., "components/core/custom-checkbox.md")
4. `type` - Type of topic (workflow/recipe/catalog/component)
5. `priority` - critical/high/medium/low
6. `required` - true/false/"conditional"
7. `read_when` - When this doc should be read
8. `use_cases` - Comma-separated keywords for discovery
9. `triggers` - Array of keywords that trigger reading this
10. `file_size_kb` - Size of documentation file

### Per Topic Optional Fields:
- `read_order` - Only for critical workflow docs
- `warnings` - Only if there are gotchas/anti-patterns
- `next_steps` - Related topics to read next
- `replaces` - Only for docs that replace old patterns

---

## Immediate Priority: Core & UI-Kit Component Topics

### Template for Component Topics

```json
{
  "id": "component-name",
  "title": "Component Display Name",
  "path": "components/core/component-name.md",
  "type": "component",
  "priority": "high",
  "required": false,
  "read_when": "When you need [specific use case]",
  "use_cases": "keyword1,keyword2,keyword3",
  "triggers": ["trigger1", "trigger2", "trigger3"],
  "warnings": ["Only if critical gotchas exist"],
  "next_steps": ["related-component-id"],
  "file_size_kb": 3
}
```

### Core Components to Add (from l3-react-blocks-construct)

1. ✅ **app-sidebar**
2. ✅ **base-password-form**
3. ✅ **captcha**
4. ✅ **confirmation-modal**
5. ✅ **custom-avatar**
6. ✅ **custom-checkbox**
7. ✅ **custom-pagination-email**
8. ✅ **custom-text-editor**
9. ✅ **data-table**
10. ✅ **divider**
11. ✅ **dynamic-breadcrumb**
12. ✅ **error-alert**
13. ✅ **extension-banner**
14. ✅ **loading-overlay**
15. ✅ **logo-section**
16. ✅ **menu-icon**
17. ✅ **menu-selection**
18. ✅ **notification**
19. ✅ **otp-input**
20. ✅ **password-input**
21. ✅ **password-strength-checker**
22. ✅ **phone-input**
23. ✅ **profile-menu**
24. ✅ **shared-password-strength-checker**
25. ✅ **sidebar-menu-item**

### UI-Kit Components to Add

26. ✅ **accordion**
    - Type: component
    - Priority: medium
    - Use cases: accordion,collapsible,expandable,faq,collapse-panel
    - Triggers: ["accordion", "collapsible", "expandable", "faq"]

27. ✅ **alert-dialog**
    - Type: component
    - Priority: high
    - Use cases: alert,dialog,alert-dialog,modal,warning-dialog
    - Triggers: ["alert dialog", "alert", "warning dialog"]

28. ✅ **avatar**
    - Type: component
    - Priority: medium
    - Use cases: avatar,profile-picture,user-image,basic-avatar
    - Triggers: ["avatar", "profile picture"]
    - Warnings: ["Use custom-avatar from core for more features"]

29. ✅ **badge**
    - Type: component
    - Priority: medium
    - Use cases: badge,label,tag,status-badge,notification-badge
    - Triggers: ["badge", "tag", "label", "status"]

30. ✅ **breadcrumb**
    - Type: component
    - Priority: medium
    - Use cases: breadcrumb,navigation,trail,basic-breadcrumb
    - Triggers: ["breadcrumb", "navigation trail"]
    - Warnings: ["Use dynamic-breadcrumb from core for URL-based breadcrumbs"]

31. ✅ **button**
    - Type: component
    - Priority: critical
    - Use cases: button,action,cta,click,submit,primary-button,secondary-button
    - Triggers: ["button", "submit", "action", "cta"]

32. ✅ **calendar**
    - Type: component
    - Priority: medium
    - Use cases: calendar,date-picker,date-selection,schedule
    - Triggers: ["calendar", "date picker", "date selection"]

33. ✅ **card**
    - Type: component
    - Priority: critical
    - Use cases: card,wrapper,layout,container,dark-mode,light-mode,overlay,panel
    - Triggers: ["card", "wrapper", "container", "layout", "panel"]
    - Warnings: ["Critical component - supports dark/light mode, overlays, used everywhere"]

34. ✅ **chart**
    - Type: component
    - Priority: medium
    - Use cases: chart,graph,visualization,data-visualization,analytics
    - Triggers: ["chart", "graph", "visualization", "analytics"]

35. ✅ **checkbox**
    - Type: component
    - Priority: medium
    - Use cases: checkbox,basic-checkbox,toggle
    - Triggers: ["checkbox", "toggle"]
    - Warnings: ["Use custom-checkbox from core for form inputs instead"]

36. ✅ **collapsible**
    - Type: component
    - Priority: medium
    - Use cases: collapsible,expandable,collapse,expand,toggle-content
    - Triggers: ["collapsible", "expandable", "collapse", "expand"]

37. ✅ **command**
    - Type: component
    - Priority: low
    - Use cases: command,command-palette,search,quick-actions
    - Triggers: ["command", "command palette", "quick search"]

38. ✅ **dialog**
    - Type: component
    - Priority: high
    - Use cases: dialog,modal,popup,overlay-dialog
    - Triggers: ["dialog", "modal", "popup"]

39. ✅ **dropdown-menu**
    - Type: component
    - Priority: high
    - Use cases: dropdown,menu,dropdown-menu,context-menu,select-menu
    - Triggers: ["dropdown", "dropdown menu", "context menu"]

40. ✅ **form**
    - Type: component
    - Priority: critical
    - Use cases: form,form-handling,react-hook-form,validation,form-wrapper
    - Triggers: ["form", "form handling", "form wrapper"]
    - Next steps: ["react-hook-form"]

41. ✅ **input**
    - Type: component
    - Priority: critical
    - Use cases: input,text-input,form-input,user-input,text-field
    - Triggers: ["input", "text input", "form field", "text field"]

42. ✅ **label**
    - Type: component
    - Priority: critical
    - Use cases: label,form-label,input-label,field-label
    - Triggers: ["label", "form label", "field label"]

43. ✅ **menubar**
    - Type: component
    - Priority: high
    - Use cases: menubar,menu,navigation-menu,top-menu,menu-bar
    - Triggers: ["menubar", "menu bar", "navigation menu"]

44. ✅ **popover**
    - Type: component
    - Priority: medium
    - Use cases: popover,tooltip,popup,floating-content
    - Triggers: ["popover", "popup", "floating"]

45. ✅ **radio-group**
    - Type: component
    - Priority: medium
    - Use cases: radio,radio-button,radio-group,option-selector
    - Triggers: ["radio", "radio button", "radio group"]

46. ✅ **scroll-area**
    - Type: component
    - Priority: medium
    - Use cases: scroll,scroll-area,scrollable,custom-scroll
    - Triggers: ["scroll", "scrollable", "scroll area"]

47. ✅ **select**
    - Type: component
    - Priority: high
    - Use cases: select,dropdown,select-menu,option-picker,combobox
    - Triggers: ["select", "dropdown", "option picker"]

48. ✅ **separator**
    - Type: component
    - Priority: low
    - Use cases: separator,divider,line,hr,horizontal-rule
    - Triggers: ["separator", "divider", "horizontal line"]

49. ✅ **sheet**
    - Type: component
    - Priority: medium
    - Use cases: sheet,drawer,slide-over,side-panel,sliding-panel
    - Triggers: ["sheet", "drawer", "slide over", "side panel"]

50. ✅ **sidebar**
    - Type: component
    - Priority: high
    - Use cases: sidebar,side-menu,navigation-sidebar,basic-sidebar
    - Triggers: ["sidebar", "side menu"]
    - Warnings: ["Use app-sidebar from core for full sidebar layouts"]

51. ✅ **skeleton**
    - Type: component
    - Priority: medium
    - Use cases: skeleton,loading-skeleton,placeholder,shimmer,loading-state
    - Triggers: ["skeleton", "loading skeleton", "placeholder", "shimmer"]

52. ✅ **slider**
    - Type: component
    - Priority: medium
    - Use cases: slider,range,range-slider,input-slider
    - Triggers: ["slider", "range", "range input"]

53. ✅ **switch**
    - Type: component
    - Priority: medium
    - Use cases: switch,toggle,toggle-switch,on-off
    - Triggers: ["switch", "toggle", "toggle switch"]

54. ✅ **table**
    - Type: component
    - Priority: high
    - Use cases: table,basic-table,grid,data-grid
    - Triggers: ["table", "grid"]
    - Warnings: ["Use data-table from core for advanced tables with pagination/sorting"]

55. ✅ **tabs**
    - Type: component
    - Priority: high
    - Use cases: tabs,tab-panel,tabbed-interface,navigation-tabs
    - Triggers: ["tabs", "tab panel", "tabbed"]

56. ✅ **textarea**
    - Type: component
    - Priority: high
    - Use cases: textarea,text-area,multiline-input,long-text
    - Triggers: ["textarea", "text area", "multiline", "long text"]

57. ✅ **toast**
    - Type: component
    - Priority: high
    - Use cases: toast,notification,snackbar,alert,message
    - Triggers: ["toast", "snackbar", "notification message"]

58. ✅ **toaster**
    - Type: component
    - Priority: medium
    - Use cases: toaster,toast-container,notification-container
    - Triggers: ["toaster", "toast container"]

59. ✅ **tooltip**
    - Type: component
    - Priority: medium
    - Use cases: tooltip,hint,help-text,hover-info
    - Triggers: ["tooltip", "hint", "help text", "hover"]

---

## Future Additions (After Next Meeting)

### Deferred Components (EXCLUDED from current scope)

**guards** (role-guard, permission-guard, combined-guard)
- Status: DEFERRED
- Reason: In development, waiting for next meeting
- Use cases: guards,authorization,role-based,permission-based

**language-selector**
- Status: DEFERRED
- Reason: Waiting for language service integration details
- Use cases: language,i18n,translation,multilingual

---

## Summary

**Total Components to Document:**
- Core: 25 components
- UI-Kit: 34 components
- **Total: 59 components**

**Deferred: 2 components** (guards, language-selector)

### Future Root-Level Sections

- `component_discovery` - Similar to multi_user_detection but for components
- `l3_blocks_metadata` - Metadata about construct structure

### Future Topic Fields

- `import_path` - Where to import from (core/ui-kit/modules)
- `shadcn_equivalent` - Map to shadcn component name
- `dependencies` - Required components
- `status` - "stable"/"deferred"/"in-development"
- `examples` - Links to example files
- `related_components` - List of related component IDs

---

## Implementation Notes

- All component topics set `required: false` (components are used when needed)
- Only add `warnings` if there are critical gotchas
- Only add `next_steps` if there are clear related components
- Skip `read_order` (only for workflow docs)
- Skip `replaces` (only for graphql-crud)
- Focus on `use_cases` and `triggers` for discoverability
- New type: `"component"` for all component docs
