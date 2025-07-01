# Processing Task Lists

## Goal

To systematically work through task lists created from PRDs, ensuring proper implementation, testing, and documentation.

## Process

1. **Load Task List:** Read the relevant `tasks-*.md` file
2. **Review Parent Tasks:** Understand the overall implementation plan
3. **Select Next Task:** Choose the next uncompleted task in logical order
4. **Mark In Progress:** Update task checkbox to indicate work has started
5. **Implement:** Write code following TDD principles
6. **Test:** Ensure all tests pass
7. **Quality Check:** Run RuboCop and fix violations
8. **Mark Complete:** Update task checkbox when done
9. **Journal Entry:** Add development journal entry for significant work
10. **Repeat:** Continue with next task

## Task Status Indicators

- `[ ]` - Not started
- `[~]` - In progress (manually update)
- `[x]` - Completed
- `[!]` - Blocked (add note explaining blockage)

## Best Practices

### Before Starting a Task
- Review related PRD section
- Check for dependencies on other tasks
- Ensure test environment is ready
- Pull latest changes from main branch

### During Implementation
- Write tests first (TDD)
- Commit frequently with clear messages
- Update task status as you work
- Note any discoveries or issues

### After Completing a Task
- Run full test suite
- Check code quality with RuboCop
- Update task list with completion
- Add journal entry if significant
- Consider creating follow-up tasks

## Common Patterns

### Feature Implementation
1. Create model/migration
2. Write model specs
3. Implement model logic
4. Create controller
5. Write request specs
6. Implement controller actions
7. Create views/components
8. Add system tests
9. Style with TailwindCSS
10. Add Stimulus controllers

### Bug Fixes
1. Reproduce the issue
2. Write failing test
3. Implement fix
4. Verify test passes
5. Check for regressions
6. Update documentation

## Task Dependencies

When tasks have dependencies:
- Note dependency in task description
- Complete prerequisite tasks first
- Update dependent tasks if scope changes
- Communicate blockers in journal

## Progress Tracking

- Update task status immediately
- Add time estimates and actuals
- Note any scope changes
- Track blockers and resolutions
- Regular status updates in journal