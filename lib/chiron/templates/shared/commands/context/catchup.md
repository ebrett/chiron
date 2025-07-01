# Catchup Command

Use this when the user asks "catchup", "where are we", or wants a project status update.

## Process

1. **Read Development Journal**
   ```
   READ: docs/development_journal.md
   ```
   Focus on the last 3-5 entries

2. **Check Active Work**
   - List files in /tasks/ directory
   - Identify incomplete tasks
   - Note any blocked items

3. **Review Current Branch**
   ```bash
   git branch --show-current
   git status --short
   git log --oneline -5
   ```

4. **Get Branch Context**
   - Run `/branch-context` command for detailed branch information
   - Check branch purpose and progress
   - Review commits unique to this branch

5. **Test Status**
   ```bash
   bin/rspec --format progress | tail -5
   ```

## Summary Format

Provide a structured summary:

### Recent Progress
- Last 3 significant accomplishments
- Who worked on what (from journal)
- Key problems solved

### Current State
- Active branch and purpose
- Pending changes
- Test suite status
- Any known issues

### Next Steps
- Immediate tasks to complete
- Blocked items needing attention
- Suggested priorities

## Example Response

```
Here's where we are:

**Recent Work:**
- Fixed authentication modal bugs (3 critical issues resolved)
- Implemented Phase 1 of in-kind donation form
- Set up real-time OAuth status monitoring

**Current State:**
- Branch: feature/treasury_forms (working on treasury reimbursement features)
- All tests passing (247 examples, 0 failures)
- No uncommitted changes

**Next Steps:**
1. Complete remaining tasks for treasury forms (3 tasks pending)
2. Address RuboCop warnings in recent changes
3. Update documentation for new features
```

## Tips

- Be concise but comprehensive
- Highlight blockers or issues
- Include contributor attribution
- Suggest logical next actions
- Reference specific files/lines when relevant