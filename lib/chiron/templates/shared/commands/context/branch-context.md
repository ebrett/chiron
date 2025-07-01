# Branch Context Command

Use this command when switching branches, starting new work, or when Claude needs to understand the current branch context.

## Purpose

Provides comprehensive branch information to maintain context across Claude sessions, especially important when:
- Switching between branches
- Starting a new Claude session on an existing branch
- Collaborating with others on feature branches
- Resuming work after time away

## Process

### 1. **Current Branch Status**
```bash
git branch --show-current
git status --porcelain
git log --oneline -5
```

### 2. **Branch Information**
```bash
# Show branch creation point
git merge-base main HEAD

# Show commits unique to this branch
git log --oneline main..HEAD

# Show files changed in this branch
git diff --name-only main...HEAD
```

### 3. **Branch Purpose Discovery**
Check for:
- **Tasks Directory**: Look for related PRD files in `/tasks/`
- **Development Journal**: Search for branch-related entries
- **Commit Messages**: Analyze recent commits for context
- **Pull Request**: Check if PR exists for this branch

### 4. **Work Context**
```bash
# Check for uncommitted work
git diff --stat

# Check for untracked files
git ls-files --others --exclude-standard

# Check for stashed changes
git stash list
```

## Output Format

Provide a structured summary:

### Branch Overview
- **Name**: Current branch name
- **Type**: feature/bugfix/hotfix/experiment
- **Base**: Branch point from main/develop
- **Age**: How long since branch creation
- **Status**: ahead/behind/up-to-date with base

### Current Work
- **Purpose**: What this branch is implementing
- **Progress**: Completed vs remaining work
- **Files Modified**: Key files changed
- **Tests**: Test status and coverage

### Context for Claude
- **Related PRD**: Link to requirements document
- **Dependencies**: Other branches or external dependencies
- **Blockers**: Known issues or waiting items
- **Next Steps**: Immediate tasks to continue

## Example Response

```
🌿 **Branch Context: feature/python-support**

**Overview:**
- Type: Feature branch
- Created: 3 days ago from main
- Status: 15 commits ahead of main
- Purpose: Add comprehensive Python project support to Chiron

**Current State:**
- 📁 Files changed: 25 files (mostly new Python templates)
- ✅ Tests: 41 examples, all passing
- 📝 Documentation: README and CHANGELOG updated
- 🚀 Status: Ready for merge

**Work Completed:**
- ✅ Python project detection (Django, FastAPI, Flask)
- ✅ ProjectConfig class for language abstraction
- ✅ Python workflow templates created
- ✅ Comprehensive test coverage added

**Context for Claude:**
- PRD: Located at tasks/prd-python-support.md
- Dependencies: None
- Blockers: None
- Next: Final review and merge to main

**Recommended Actions:**
1. Run final test suite
2. Update version number for release
3. Create pull request for review
```

## Command Variations

### Quick Branch Info
```bash
# Just the essentials
git branch --show-current && git status --short && git log --oneline -3
```

### Detailed Branch Analysis
```bash
# Comprehensive branch analysis
git log --graph --oneline --all -10
git diff --stat main...HEAD
```

### Branch Comparison
```bash
# Compare with main branch
git log --left-right --graph --cherry-pick --oneline main...HEAD
```

## Integration with Other Commands

### Use with Quickstart
- Automatically called when starting work session
- Provides branch context before task planning

### Use with Catchup
- Shows branch progress in relation to project goals
- Identifies if branch work aligns with current priorities

### Use before PRs
- Ensures all branch work is documented
- Confirms branch is ready for review

## Tips for Effective Branch Tracking

### Branch Naming
- Use prefixes: `feature/`, `bugfix/`, `hotfix/`, `experiment/`
- Include ticket numbers: `feature/PROJ-123-user-auth`
- Be descriptive: `feature/python-project-support`

### Commit Messages
- Reference related issues or PRDs
- Use conventional commits format
- Include context for future sessions

### Documentation
- Update journal when creating branches
- Link branches to PRDs or task lists
- Note collaboration context

### Session Continuity
- Run this command at session start
- Update when switching branches
- Use before major commits or pushes

## Automation Opportunities

Consider adding git hooks to:
- Auto-update journal on branch creation
- Prompt for branch purpose on first commit
- Remind about documentation updates
- Check for related PRD files

This command ensures Claude always has full context about your current branch and work progress, making sessions more productive and reducing ramp-up time.