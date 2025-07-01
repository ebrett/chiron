# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Chiron is a Ruby gem that initializes Claude AI development workflows, PRD templates, and journaling system for Rails projects. Named after the wise centaur who mentored heroes, Chiron helps developers set up structured development processes that integrate seamlessly with Claude Code.

## Development Commands

**Important**: Always use bundle exec for consistency in gem development.

```bash
# Setup
bundle install

# Testing
bundle exec rspec                    # Run all tests
bundle exec rspec spec/cli_spec.rb   # Run specific test file

# Code quality
bundle exec rubocop                  # Linting
bundle exec rubocop --autocorrect    # Auto-fix correctable violations

# Gem development
gem build chiron.gemspec            # Build gem
gem install chiron-*.gem            # Install locally
```

## Architecture Overview

### Core Classes
- `Chiron::CLI` - Thor-based command line interface
- `Chiron::VERSION` - Gem version constant

### Key Features
- Template copying system for Claude workflows
- ERB template processing for customizable files
- Interactive project setup with TTY::Prompt
- Migration support from .cursor to .claude structure

## Technical Stack

- **Framework**: Ruby gem with Thor CLI framework
- **Dependencies**: 
  - `thor` - Command line interface framework
  - `tty-prompt` - Interactive command line prompts
  - `colorize` - Terminal output coloring
- **Testing**: RSpec with comprehensive test coverage
- **Code Quality**: RuboCop for style enforcement
- **CI/CD**: GitHub Actions for Ruby 3.0-3.3

## Gem Structure

```
lib/
├── chiron.rb                    # Main entry point
└── chiron/
    ├── version.rb              # Version constant
    ├── cli.rb                  # CLI implementation
    └── templates/              # Template files for Rails projects
        ├── CLAUDE.md.erb       # Rails project CLAUDE.md template
        ├── claude/settings.json
        ├── commands/           # Workflow command templates
        └── development_journal.md.erb
```

## Development Patterns

### CLI Commands
- `init` - Initialize Claude workflow in Rails project
- `migrate-cursor` - Migrate from .cursor to .claude structure
- `add-workflow` - Add specific workflow templates
- `update` - Update workflows to latest version
- `doctor` - Health check for Claude setup
- `version` - Display gem version

### Template System
- ERB templates with project-specific variables
- Modular command structure (workflows, conventions, context, journal, quality)
- Customizable file copying with conditional logic

### PRD Workflow
- Use `.claude/commands/workflows/create-prd.md` for structured feature development
- PRDs should be saved in `/tasks/` directory as `prd-[feature-name].md`
- Follow the clarifying questions process before implementation

### Code Quality
- RuboCop for consistent styling
- Comprehensive test coverage with RSpec
- GitHub Actions CI for multi-Ruby version testing

## Testing Standards

- Write tests before implementation (TDD)
- Maintain high test coverage
- Mock file system operations in tests
- Test CLI commands with temporary directories
- Follow RSpec best practices

## Branch Management and Claude Sessions

### Branch Naming Conventions
- `feature/[description]` - New functionality (e.g., `feature/python-support`)
- `bugfix/[description]` - Bug fixes (e.g., `bugfix/template-loading`)
- `hotfix/[description]` - Urgent production fixes
- `experiment/[description]` - Exploratory work

### Claude Session Continuity
- **Starting Sessions**: Always run `/quickstart` to get current context
- **Branch Work**: Use `/branch-context` when working on feature branches
- **Progress Tracking**: Update development journal for significant changes
- **Branch Switching**: Document current state before switching branches

### Development Journal Usage
- Include branch name in all journal entries
- Update "Active Branches & Ownership" section when creating/merging branches
- Link journal entries to related PRD files
- Document architectural decisions and reasoning

### Branch Workflow
1. Create branch from updated main: `git checkout -b feature/description`
2. Document branch purpose in development journal
3. Make initial empty commit with context
4. Develop with frequent commits and journal updates
5. Use `/catchup` and `/branch-context` for status updates
6. Complete pre-commit checklist before merging

## Important Reminders

- Always run tests before committing
- Use semantic commit messages with branch context
- Update the development journal for significant changes
- Follow the pre-commit checklist in `.claude/commands/quality/pre-commit.md`
- Use branch management workflows for feature development
- Update CHANGELOG.md for notable changes
- Test gem building and installation locally before releasing