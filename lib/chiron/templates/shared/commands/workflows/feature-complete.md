# Feature Completion Checklist

Use this checklist when you believe a feature is complete to ensure nothing is missed.

## Pre-Completion Review

### 1. Task Verification
- [ ] All tasks from `tasks-*.md` are marked complete
- [ ] No blocked tasks remain unresolved
- [ ] All subtasks have been implemented

### 2. Code Quality
- [ ] All tests are passing (`bin/rspec`)
- [ ] RuboCop violations addressed (`bin/rubocop`)
- [ ] No commented-out code without explanation
- [ ] No debugging statements left in code

### 3. Test Coverage
- [ ] Unit tests for all models
- [ ] Request specs for all controllers
- [ ] System tests for user workflows
- [ ] Edge cases tested
- [ ] Error conditions handled

### 4. Documentation
- [ ] Code comments for complex logic
- [ ] README updated if needed
- [ ] API documentation if applicable
- [ ] CLAUDE.md updated for workflow changes

### 5. Performance
- [ ] Database queries optimized (no N+1)
- [ ] Appropriate indexes added
- [ ] Caching implemented where beneficial
- [ ] Background jobs for slow operations

### 6. Security
- [ ] Authorization checks in place
- [ ] Strong parameters used
- [ ] No sensitive data exposed
- [ ] Security scan passed (`bin/brakeman`)

## Feature-Specific Checks

### Frontend Features
- [ ] Responsive design verified
- [ ] Accessibility requirements met
- [ ] Cross-browser testing done
- [ ] Loading states implemented
- [ ] Error states handled gracefully

### API Features
- [ ] Versioning implemented
- [ ] Rate limiting considered
- [ ] Documentation generated
- [ ] Integration tests written
- [ ] Error responses standardized

### Background Jobs
- [ ] Idempotency ensured
- [ ] Retry logic implemented
- [ ] Failure notifications set up
- [ ] Performance monitored
- [ ] Dead letter queue configured

## Final Steps

### 1. Development Journal
Add comprehensive entry including:
- Summary of implementation
- Key decisions made
- Challenges overcome
- Performance metrics
- Lessons learned

### 2. Pull Request
Create PR with:
- Reference to original PRD
- Summary of changes
- Screenshots/demos if UI changes
- Testing instructions
- Deployment notes

### 3. Knowledge Transfer
- [ ] Document any gotchas
- [ ] Update team wiki if needed
- [ ] Schedule demo if significant feature
- [ ] Plan monitoring strategy

## Post-Completion

### Monitoring Plan
- Key metrics to track
- Error rate thresholds
- Performance benchmarks
- User feedback channels

### Follow-up Tasks
- Performance optimization opportunities
- Additional features to consider
- Technical debt to address
- Documentation improvements

## Success Criteria Verification

Review the original PRD and verify:
- All functional requirements implemented
- Success metrics achievable
- Acceptance criteria met
- Non-goals respected

## Sign-off Template

```markdown
## Feature Complete: [Feature Name]

**PRD Reference**: prd-[feature-name].md
**Tasks Reference**: tasks-prd-[feature-name].md

### Verification
- ✅ All tasks completed
- ✅ Tests passing: [X examples, 0 failures]
- ✅ Code quality verified
- ✅ Documentation updated
- ✅ Security review passed

### Metrics
- Test coverage: X%
- Performance: Xms average response
- Code changes: +X -Y lines

### Notes
[Any important notes for deployment or future work]

**Developer**: [Name]
**Date**: [YYYY-MM-DD]
```

Remember: "Done" means deployed, documented, and monitored!