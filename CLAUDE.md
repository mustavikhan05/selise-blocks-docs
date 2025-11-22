# Component Documentation Workflow

**Adding L3 React Blocks components to topics.json:**

1. Read component from `potential-topics-to-add.md` (one at a time)
2. Read the actual component code from `l3-react-blocks-construct/src/components/[core|ui-kit]/[component].tsx`
3. Analyze code for:
   - Use cases (what problems it solves)
   - Triggers (search terms users might use)
   - Warnings (gotchas, when NOT to use it)
   - Next steps (related components)
4. Add entry to `topics.json` with all required fields
5. Mark component as DONE in `potential-topics-to-add.md`
6. Repeat for next component

**Required fields:** id, title, path, type, priority, required, read_when, use_cases, triggers, file_size_kb

**Optional fields:** warnings (if gotchas exist), next_steps (if related components)

**Skip these fields:** read_order (workflow docs only), replaces (graphql-crud only)

---

**Repo:** https://github.com/mustavikhan05/selise-blocks-docs
