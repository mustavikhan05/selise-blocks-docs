# Common Pitfalls to Avoid

## DON'Ts - Critical Anti-Patterns

1. **DON'T** look for existing domains - always create new project

2. **DON'T** create schemas manually - use MCP tools

3. **DON'T** skip reading recipes before implementation

4. **DON'T** create custom components when Selise components exist

5. **DON'T** use Apollo Client - use graphqlClient from recipes

6. **DON'T** bypass the 3-layer component hierarchy

7. **DON'T** copy GraphQL patterns from inventory - use recipes/graphql-crud.md

8. **DON'T** use `ItemId` for filtering - use `_id`

9. **DON'T** forget to update tracking files (TASKS.md, SCRATCHPAD.md, CLOUD.md)

10. **DON'T** commit without updating TASKS.md status

## Why These Matter

- **Inventory patterns are wrong** - They exist for folder structure reference only
- **MCP tools are mandatory** - Manual schema creation causes sync issues
- **Recipes are canonical** - They contain the correct patterns for Selise Cloud
- **Component hierarchy prevents drift** - Always start from Feature level
- **Tracking files prevent context loss** - Essential for long development sessions
