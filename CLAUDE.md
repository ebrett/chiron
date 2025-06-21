# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

test_project is a Rails 8.0.2 application. [Add your project description here]

## Development Commands

**Important**: Always use binstubs instead of `bundle exec` for better performance and consistency.

```bash
# Setup
bundle install
bin/rails db:create db:migrate db:seed

# Development server
bin/rails server
# or with Procfile for concurrent processes
bin/dev

# Testing
bin/rspec                            # Run all tests
bin/rspec spec/models/               # Run specific test directory
bin/rspec spec/models/user_spec.rb   # Run single test file

# Code quality
bin/rubocop                          # Linting
bin/rubocop --autocorrect            # Auto-fix correctable violations
bin/brakeman                         # Security scanning
```

## Architecture Overview

### Key Models & Relationships
[Document your main models and their relationships]

### Core Services
[List your service objects and their purposes]

### Controllers Structure
[Describe your controller organization]

## Technical Stack

- **Framework**: Rails 8.0.2 with Hotwire (Turbo + Stimulus)
- **Database**: PostgreSQL with Active Record
- **Frontend**: TailwindCSS, Stimulus controllers

- **Testing**: RSpec with FactoryBot
- **Background Jobs**: [Your job processor]
- **Authorization**: [Your authorization system]

## Environment Variables

Required for development:
```
# Add your required environment variables here
```

## Rails Conventions

- Standard Rails naming conventions (snake_case)
- RuboCop for code style enforcement
- Follow Rails best practices and idioms

## Development Patterns

### Component Architecture
- Use ViewComponent for reusable UI elements (located in `app/components/`)
- Follow Rails conventions with Hotwire for reactive interfaces
- Utilize Stimulus controllers for JavaScript interactions

### PRD Workflow
- Use `.claude/commands/workflows/create-prd.md` for structured feature development
- PRDs should be saved in `/tasks/` directory as `prd-[feature-name].md`
- Follow the clarifying questions process before implementation

### Code Quality
- RuboCop for consistent styling
- Brakeman for security scanning
- Comprehensive test coverage with RSpec

## Testing Standards

- Write tests before implementation (TDD)
- Maintain high test coverage
- Use FactoryBot for test data
- Follow RSpec best practices

## Important Reminders

- Always run tests before committing
- Use semantic commit messages
- Update the development journal for significant changes
- Follow the pre-commit checklist in `.claude/commands/quality/pre-commit.md`