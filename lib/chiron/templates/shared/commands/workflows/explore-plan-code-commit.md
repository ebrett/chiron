# Explore-Plan-Code-Commit Workflow

## Overview

A structured approach to feature development that emphasizes understanding before building, thoughtful planning, and clear documentation of changes.

## The Four Phases

### 1. Explore Phase

**Goal**: Understand the codebase, context, and requirements before making changes.

#### Actions:
- Read relevant files to understand current implementation
- Explore related code and dependencies
- Review existing tests and documentation
- Use conversational Q&A to understand unfamiliar parts of the codebase
- Search for similar implementations or patterns

#### Commands:
```bash
# Find related files
find . -name "*.rb" | grep user
grep -r "authentication" app/

# Understand file structure
ls -la app/models/
head -20 app/models/user.rb
```

#### Questions to Ask:
- What does the current code do?
- How does this feature fit into the existing architecture?
- What patterns are already established?
- Are there similar implementations to reference?
- What are the dependencies and constraints?

### 2. Plan Phase

**Goal**: Create a clear implementation strategy before writing code.

#### Use Extended Thinking
For complex features, use "think" to trigger extended thinking mode:
- Analyze multiple implementation approaches
- Consider edge cases and error scenarios
- Plan the sequence of changes
- Identify potential risks or complications

#### Planning Activities:
- Break down the feature into small, testable chunks
- Identify the files that need changes
- Plan the order of implementation (models → controllers → views)
- Consider backward compatibility
- Plan rollback strategy if needed

#### Documentation:
- Update or create PRD if the scope is significant
- Add notes to development journal
- Create a checklist of implementation steps

### 3. Code Phase

**Goal**: Implement the solution incrementally with frequent validation.

#### Best Practices:
- Start with tests (TDD approach)
- Make small, atomic changes
- Test frequently during development
- Commit early and often with descriptive messages
- Follow established code patterns and conventions

#### Implementation Order:
1. Write failing tests first
2. Implement minimal code to pass tests
3. Refactor while keeping tests green
4. Add edge case handling
5. Update documentation and comments

#### Validation:
- Run tests after each change
- Test in development environment
- Verify edge cases work correctly
- Check for performance implications

### 4. Commit Phase

**Goal**: Document changes clearly and ensure code quality.

#### Pre-Commit Checklist:
- [ ] All tests pass
- [ ] Code follows project style guidelines
- [ ] No debug code or console.logs left behind
- [ ] Documentation updated if needed
- [ ] Performance implications considered
- [ ] Security implications reviewed

#### Commit Message Structure:
```
Type: Brief description

More detailed explanation of what was changed and why.
Include context about the problem being solved.

- Key change 1
- Key change 2
- Key change 3

Closes #issue-number (if applicable)
```

#### Commit Types:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `test`: Adding or updating tests
- `style`: Code style changes (formatting, etc.)

## When to Use This Workflow

### Ideal For:
- New feature development
- Complex bug fixes
- Refactoring existing code
- Working with unfamiliar code
- Cross-cutting changes affecting multiple files

### Not Necessary For:
- Simple typo fixes
- Trivial configuration changes
- Emergency hotfixes (but document afterwards)

## Advanced Techniques

### Subagent Usage
For very complex problems, consider using subagents:
- Create specialized agents for different aspects (backend, frontend, testing)
- Have each agent focus on their specific domain
- Coordinate between agents for integrated solutions

### Incremental Development
- Start with the simplest possible implementation
- Add complexity gradually
- Maintain working code at each step
- Use feature flags for incomplete features

### Documentation as You Go
- Update README files for significant changes
- Add inline comments for complex logic
- Update API documentation
- Keep development journal current

## Common Pitfalls to Avoid

### In Explore Phase:
- Don't skip understanding existing code
- Don't assume you know how things work
- Don't ignore existing patterns and conventions

### In Plan Phase:
- Don't skip planning for complex features
- Don't plan too far ahead (avoid waterfall)
- Don't ignore edge cases in planning

### In Code Phase:
- Don't write all code before testing
- Don't ignore failing tests
- Don't commit broken code
- Don't leave debug code in commits

### In Commit Phase:
- Don't write vague commit messages
- Don't commit multiple unrelated changes together
- Don't skip the pre-commit checklist
- Don't forget to update documentation

## Integration with Other Workflows

This workflow complements:
- **TDD**: The Code phase follows TDD principles
- **PRD Process**: Use PRDs for significant features in the Plan phase
- **Code Review**: Structured commits make reviews easier
- **CI/CD**: Clean commits integrate better with automated pipelines

## Success Metrics

You're using this workflow successfully when:
- You rarely encounter unexpected issues during implementation
- Your commits are focused and well-documented
- Code reviews are faster and more productive
- You can easily explain your changes to others
- You spend less time debugging integration issues