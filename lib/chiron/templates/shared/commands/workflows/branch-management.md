# Branch Management Workflow

Comprehensive workflow for creating, switching, and managing Git branches in Claude Code sessions.

## Creating New Branches

### 1. **Pre-Branch Planning**
Before creating a branch, ensure:
- [ ] Clear understanding of the feature/fix purpose
- [ ] Related PRD exists (if for new feature)
- [ ] No existing branch covers the same work
- [ ] Clean working directory on current branch

### 2. **Branch Creation Process**
```bash
# Ensure you're on the base branch (usually main)
git checkout main
git pull origin main

# Create and switch to new branch
git checkout -b [type]/[descriptive-name]

# Examples:
git checkout -b feature/user-authentication
git checkout -b bugfix/login-validation
git checkout -b hotfix/security-patch
git checkout -b experiment/new-ui-approach
```

### 3. **Branch Documentation**
Immediately after creating a branch:

#### Update Development Journal
Add to the "Active Branches & Ownership" section:
```markdown
- `feature/user-authentication`: [Your Name] - Implement user login/signup system - [Created 2025-07-01]
  - **PRD**: tasks/prd-user-authentication.md
  - **Dependencies**: None
  - **Timeline**: 1 week
```

#### Create Initial Commit
```bash
# Create a planning commit to establish branch purpose
git commit --allow-empty -m "Start feature/user-authentication

Initial branch creation for implementing user authentication system.

Related PRD: tasks/prd-user-authentication.md
Estimated timeline: 1 week
Dependencies: None"
```

## Branch Switching Workflow

### 1. **Before Switching Away**
```bash
# Save current work
git add .
git commit -m "WIP: [describe current state]" 
# OR
git stash push -m "Work in progress: [description]"

# Update journal with progress
# Run catchup command to document current state
```

### 2. **Switching to Different Branch**
```bash
# Switch to target branch
git checkout [target-branch]

# Get branch context (use branch-context command)
# Update Claude with current branch state
```

### 3. **After Switching**
- [ ] Run `/branch-context` command to orient Claude
- [ ] Review recent commits and current state
- [ ] Check for any merge conflicts or issues
- [ ] Resume work from where you left off

## Branch Maintenance

### 1. **Regular Synchronization**
```bash
# Keep feature branch updated with main
git checkout main
git pull origin main
git checkout [your-branch]
git merge main
# OR for cleaner history:
git rebase main
```

### 2. **Progress Tracking**
Update development journal regularly:
- When completing major milestones
- When encountering significant challenges
- When changing approach or design
- Before long breaks in development

### 3. **Pre-Merge Checklist**
Before merging or creating PR:
- [ ] All tests passing
- [ ] Code quality checks pass
- [ ] Documentation updated
- [ ] Journal entry completed
- [ ] Branch purpose fully achieved
- [ ] No debug code or temporary changes

## Claude Session Continuity

### Starting New Session
When beginning a Claude session:
1. Run `/quickstart` command
2. Run `/branch-context` command
3. Review recent journal entries
4. Check current task status

### During Development
- Use `/catchup` to summarize progress
- Update journal for significant changes
- Create meaningful commit messages
- Reference related PRDs or issues

### Ending Session
Before ending a Claude session:
1. Commit or stash current work
2. Update journal with progress
3. Note any blockers or next steps
4. Create TODO items if applicable

## Branch Types and Naming

### Feature Branches
```bash
feature/[short-description]
feature/user-authentication
feature/payment-integration
feature/admin-dashboard
```
- For new functionality
- Usually based on PRDs
- Timeline: days to weeks

### Bugfix Branches
```bash
bugfix/[issue-description]
bugfix/login-validation
bugfix/email-formatting
bugfix/mobile-layout
```
- For fixing existing functionality
- Should include issue reproduction
- Timeline: hours to days

### Hotfix Branches
```bash
hotfix/[urgent-issue]
hotfix/security-patch
hotfix/production-error
hotfix/data-corruption
```
- For urgent production fixes
- Fast-tracked through review
- Timeline: hours

### Experiment Branches
```bash
experiment/[exploration-area]
experiment/new-ui-framework
experiment/performance-optimization
experiment/alternative-approach
```
- For trying new approaches
- May not be merged
- Timeline: varies

## Collaboration Patterns

### Multiple Developers
- Update journal with developer assignments
- Use PR descriptions to communicate context
- Reference branch dependencies clearly
- Coordinate merge timing

### Code Reviews
- Include branch context in PR description
- Reference related journal entries
- Explain design decisions made during development
- Link to relevant PRD sections

### Handoffs
When transferring work to another developer:
1. Complete journal entry for current state
2. Commit all work with clear messages
3. Document any known issues or blockers
4. Update branch ownership in journal

## Troubleshooting Common Issues

### Lost Context
If Claude loses branch context:
1. Run `/branch-context` command
2. Review recent commits: `git log --oneline -10`
3. Check journal for recent entries
4. Summarize current work state

### Merge Conflicts
```bash
# Resolve conflicts step by step
git status                    # See conflicted files
git diff                      # Review conflicts
# Edit files to resolve conflicts
git add [resolved-files]
git commit -m "Resolve merge conflicts"
```

### Stale Branches
For branches behind main:
```bash
git checkout [your-branch]
git fetch origin
git merge origin/main
# OR for cleaner history:
git rebase origin/main
```

## Best Practices Summary

### Branch Creation
- Always create from updated main/develop
- Use descriptive, consistent naming
- Document purpose immediately
- Create empty initial commit with context

### Development
- Commit frequently with meaningful messages
- Update journal for significant progress
- Keep branches focused on single purpose
- Sync with main regularly

### Claude Integration
- Use context commands at session start
- Maintain journal throughout development
- Reference branch work in commits
- Document decisions and rationale

### Cleanup
- Delete merged branches promptly
- Archive experiment branches with notes
- Update journal when closing branches
- Remove stale branch references

This workflow ensures branch work is well-documented, trackable across Claude sessions, and maintains clear development history.