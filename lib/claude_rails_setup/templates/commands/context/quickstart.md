# Quick Start Context

Use this command to quickly get up to speed with the current project state.

## Steps

1. **Read Project Documentation**
   - READ: CLAUDE.md
   - READ: README.md (if different from CLAUDE.md)

2. **Check Current Status**
   ```bash
   git status
   git log --oneline -5
   git branch --show-current
   ```

3. **Review Recent Work**
   - READ: docs/development_journal.md (last 3 entries)
   - Check for active tasks in /tasks/ directory

4. **Quick Test Status**
   ```bash
   bin/rspec --fail-fast
   ```

5. **Check Code Quality**
   ```bash
   bin/rubocop --format simple | tail -20
   ```

## Output Summary

After running these steps, provide a concise summary:
- Current branch and its purpose
- Recent work completed
- Any failing tests or quality issues
- Active tasks or PRDs
- Suggested next steps

## Usage

This is ideal for:
- Starting a new work session
- After switching branches
- When returning to a project after time away
- Before pair programming sessions