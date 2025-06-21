# Journal Instructions for Claude Code

This governs how Claude Code should maintain an ongoing development journal for tracking work progress and providing daily catchup summaries.

## Journal Location and Structure

**File**: `docs/development_journal.md`

**Format**: Chronological entries with structured sections for easy scanning and context building.

## When to Update the Journal

Update the journal after completing significant work sessions, specifically:

1. **Bug fixes** - Any bugs identified and resolved
2. **Feature implementations** - New features or enhancements added
3. **Refactoring** - Code improvements or architectural changes  
4. **Infrastructure changes** - CI/CD, testing, or deployment modifications
5. **Important decisions** - Technical choices, architecture decisions, or approach changes
6. **Problem investigations** - Research into issues, even if not fully resolved

## Journal Entry Structure

Each entry should follow this format:

```markdown
## [Date] - [Brief Summary Title]
**Developer(s)**: [Name/Handle] | **Context**: [How work was initiated]

### What Was Done
- Bullet point list of specific actions taken
- Include file names and line numbers where applicable
- Mention any tools, commands, or scripts used

### Why It Was Done  
- Context for the changes
- Problem being solved
- User request or issue being addressed

### Technical Details
- Key code changes made
- Architectural decisions
- Testing approach used
- Any notable implementation details

### Results
- What works now that didn't before
- Test results (passing/failing counts)
- Performance improvements if applicable
- Any remaining issues or follow-up needed

### Next Steps (if applicable)
- Related work that should be done
- Known issues to address
- Improvements to consider

---
```

## Daily Catchup Format

When the user asks for a "catchup" or "where are we":

1. **Read the journal** to understand recent work
2. **Summarize the last 3-5 entries** in a concise format
3. **Highlight current state** of key features/systems
4. **Identify any pending work** or unresolved issues
5. **Suggest logical next steps** based on recent work patterns

## Developer Attribution Guidelines

**For Claude Code entries**:
- Use "Claude Code (with [User])" format 
- Include how work was initiated (user request, bug report, etc.)

**For human developer entries**:
- Use developer's preferred name/handle
- Include context (pair programming, solo work, code review, etc.)

**For collaborative work**:
- List all contributors: "Jane Doe & Claude Code (with Brett)"
- Note the nature of collaboration in context

## Multi-Developer Collaboration Features

### Developer Activity Summary
Maintain a running summary at the top of the journal showing recent contributors:

```markdown
## Recent Contributors (Last 30 Days)
- **[Developer Name]**: [Their focus areas]
- **Claude Code**: [AI-assisted work areas]

## Active Branches & Ownership
- `branch-name`: [Developer(s) working on it]
```

### Conflict Prevention
- **Before starting work**: Check recent journal entries for conflicts
- **Branch coordination**: Note active branches and who's working on what
- **Handoff documentation**: When passing work between developers, include detailed context

## Important Guidelines

1. **Be Specific**: Include file paths, line numbers, method names, and test results
2. **Provide Context**: Explain why changes were needed, not just what was changed
3. **Track Progress**: Show how issues evolve and get resolved over time
4. **Include Failures**: Document what didn't work and why, for future reference
5. **Link Related Work**: Connect entries that build on each other
6. **Keep It Scannable**: Use clear headings and bullet points for quick reading

## Journal Maintenance

- **Update frequency**: After each significant work session
- **Entry length**: Aim for 100-300 words per entry
- **File size**: If journal exceeds 10,000 lines, create monthly archives
- **Cross-references**: Link to related PRs, issues, or documentation

## Automation Triggers

Consider updating the journal when:
- Completing tasks from a task list
- Test suite goes from failing to passing
- Major refactoring (>100 lines changed)
- Before switching branches
- After resolving complex bugs
- When implementing new features

This journal serves as both a development log and a knowledge base for understanding the project's evolution and current state.