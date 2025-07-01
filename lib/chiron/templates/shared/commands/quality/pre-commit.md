# Pre-Commit Checklist

Run these commands in sequence before committing code changes.

## Required Steps

### 1. Code Quality
```bash
bin/rubocop --autocorrect
```
- Fix all auto-correctable violations
- Review remaining violations
- Document any acceptable violations

### 2. Test Suite
```bash
bin/rspec
```
- Ensure all tests pass
- If tests fail, fix them before proceeding
- Add new tests for new functionality

### 3. Security Check
```bash
bin/brakeman
```
- Review any security warnings
- Address critical issues immediately
- Document false positives

### 4. Review Changes
```bash
git diff --cached
```
- Verify all changes are intentional
- Check for debugging code
- Ensure no sensitive data is included

### 5. Update Documentation
- Update CLAUDE.md if workflow changes
- Add/update code comments if complex logic
- Update README if user-facing changes

### 6. Development Journal
For significant work:
- Add entry to docs/development_journal.md
- Include what, why, and results
- Note any follow-up tasks

## Quick Command
```bash
# Run all checks at once
bin/rubocop --autocorrect && bin/rspec && bin/brakeman && git diff --cached
```

## Commit Message Format
```
type: Brief description (max 50 chars)

Longer explanation if needed. Wrap at 72 characters.
Explain what and why, not how.

- Bullet points for multiple changes
- Reference issue numbers: Fixes #123
- Reference PRD if applicable: Implements prd-feature-name

Co-authored-by: Name <email> (if pair programming)
```

### Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, missing semicolons, etc)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding missing tests
- `chore`: Changes to build process or auxiliary tools

## Warning Signs to Check

Before committing, ensure you haven't:
- Left debugging statements (puts, console.log, binding.pry)
- Included commented-out code without explanation
- Added TODO comments without creating issues
- Modified tests just to make them pass
- Included hardcoded values that should be configurable
- Forgotten to add new files to git

## Final Verification
```bash
git status
```
- All intended files are staged
- No untracked files forgotten
- Working directory is clean (or intentionally not)