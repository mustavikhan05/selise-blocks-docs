# Recipe: Adding Internationalization (i18n) to New Pages in Selise Blocks

## Overview

This recipe provides a step-by-step guide for adding internationalization support to new pages in a Selise Blocks application. It covers creating translation modules, adding translation keys, and integrating them into your page components.

---

## Prerequisites

Before starting, ensure:
1. You have a Selise Blocks project set up
2. You have Selise Cloud credentials (email/password)
3. The MCP server is connected

---

## Step 1: Authenticate and Set Project Context

```
1. mcp__selise__login(username, password)
2. mcp__selise__set_application_domain(domain, tenant_id, project_name)
```

---

## Step 2: Get Available Languages

```
mcp__selise__get_languages()
```

This returns the configured languages for your project. Common culture codes:
- `en-US` - English (United States)
- `de-DE` - German (Germany)
- `bn-BD` - Bengali (Bangladesh)
- `fr-FR` - French (France)

**Save these culture codes - you'll need them for translations.**

---

## Step 3: Create a Translation Module for Your Page

Name the module after your page/feature (lowercase, use underscores only):

```
mcp__selise__create_new_module(module_name="your_page_module")
```

**Save the returned `module_id` - you'll need it for adding keys.**

---

## Step 4: Identify UI Elements That Need Translation

Scan your page component for all user-facing text:

| Element Type | Examples | Key Naming Pattern |
|--------------|----------|-------------------|
| **Button Text** | Submit, Cancel, Save | `SUBMIT`, `CANCEL`, `SAVE` |
| **Form Labels** | Email, Password, Name | `EMAIL`, `PASSWORD`, `NAME` |
| **Placeholders** | "Enter your email" | `ENTER_YOUR_EMAIL` |
| **Page Titles** | "User Profile" | `USER_PROFILE` |
| **Section Headers** | "General Info" | `GENERAL_INFO` |
| **Error Messages** | "Field is required" | `FIELD_REQUIRED` |
| **Status Labels** | Active, Inactive | `ACTIVE`, `INACTIVE` |
| **Tooltips/Hints** | "Click to submit" | `CLICK_TO_SUBMIT` |
| **Confirmation Text** | "Are you sure?" | `ARE_YOU_SURE` |
| **Success Messages** | "Saved successfully" | `SAVED_SUCCESSFULLY` |

**Key Naming Convention: UPPERCASE_WITH_UNDERSCORES (SCREAMING_SNAKE_CASE)**

---

## Step 5: Add Translation Keys

For each UI text element, call:

```
mcp__selise__save_translation_key(
  key_name="YOUR_KEY_NAME",
  module_id="<module_id_from_step_3>",
  translations=[
    {"value": "English text", "culture": "en-US"},
    {"value": "German text", "culture": "de-DE"},
    {"value": "Bengali text", "culture": "bn-BD"}
  ]
)
```

**Include ALL languages from Step 2 in each translation.**

---

## Step 6: Register the Module in Route Map

Edit `src/i18n/route-module-map.ts`:

```typescript
export const routeModuleMap: Record<string, string[]> = {
  '/your-page-route': ['common', 'your_page_module'],  // Add this line
  // ... existing routes
};
```

**Always include 'common' first, then your page-specific module.**

---

## Step 7: Use Translations in Your Component

```typescript
import { useTranslation } from 'react-i18next';

export function YourPage() {
  const { t } = useTranslation();

  return (
    <div>
      <h1>{t('PAGE_TITLE')}</h1>
      <form>
        <label>{t('EMAIL')}</label>
        <input placeholder={t('ENTER_YOUR_EMAIL')} />
        <button>{t('SUBMIT')}</button>
      </form>
    </div>
  );
}
```

---

## Step 8: Test Your Translations

1. Hard refresh the page (Cmd+Shift+R / Ctrl+Shift+R)
2. Verify all text displays correctly
3. Switch languages using the language selector to test all translations

---

## Complete Example

### Scenario: Adding i18n to a Contact Form Page

**Page Route:** `/contact`
**Module Name:** `contact_module`

#### 1. Get Languages
```
Languages: en-US, de-DE, bn-BD
```

#### 2. Create Module
```
mcp__selise__create_new_module(module_name="contact_module")
→ Returns module_id: "abc123-xyz"
```

#### 3. Add Translation Keys
```
// Page Title
mcp__selise__save_translation_key(
  key_name="CONTACT_US",
  module_id="abc123-xyz",
  translations=[
    {"value": "Contact Us", "culture": "en-US"},
    {"value": "Kontaktiere uns", "culture": "de-DE"},
    {"value": "যোগাযোগ করুন", "culture": "bn-BD"}
  ]
)

// Form Labels
mcp__selise__save_translation_key(
  key_name="YOUR_NAME",
  module_id="abc123-xyz",
  translations=[
    {"value": "Your Name", "culture": "en-US"},
    {"value": "Ihr Name", "culture": "de-DE"},
    {"value": "আপনার নাম", "culture": "bn-BD"}
  ]
)

// ... repeat for MESSAGE, SEND_MESSAGE, etc.
```

#### 4. Update Route Map
```typescript
// src/i18n/route-module-map.ts
export const routeModuleMap: Record<string, string[]> = {
  '/contact': ['common', 'contact_module'],
  // ...
};
```

#### 5. Use in Component
```typescript
// src/modules/contact/component/contact-page.tsx
import { useTranslation } from 'react-i18next';

export function ContactPage() {
  const { t } = useTranslation();

  return (
    <main>
      <h1>{t('CONTACT_US')}</h1>
      <form>
        <label>{t('YOUR_NAME')}</label>
        <input placeholder={t('ENTER_YOUR_NAME')} />

        <label>{t('MESSAGE')}</label>
        <textarea placeholder={t('ENTER_YOUR_MESSAGE')} />

        <button>{t('SEND_MESSAGE')}</button>
      </form>
    </main>
  );
}
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Key shows instead of translation | Check route-module-map includes your module |
| Key created in Selise Cloud not working | Press the **Publish Changes** button in Selise Cloud after adding keys |
| Translation not updating | Hard refresh (Cmd+Shift+R) to clear cache |
| API returns old data | Wait ~30 seconds for API cache to update |
| Module not found | Verify module was created successfully |

---

## Files to Modify

1. **`src/i18n/route-module-map.ts`** - Register your module for the route
2. **Your page component** - Import `useTranslation` and use `t()` function
3. **Selise Cloud** - Create module and keys via MCP tools

---

## Summary Checklist

- [ ] Authenticate with Selise Cloud
- [ ] Get available languages
- [ ] Create translation module (named after page)
- [ ] Identify all UI text needing translation
- [ ] Add translation keys with all language values
- [ ] Register module in route-module-map.ts
- [ ] Use `t('KEY')` in component
- [ ] Test all languages
