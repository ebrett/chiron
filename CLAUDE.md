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

## Important Reminders

- Always run tests before committing
- Use semantic commit messages
- Update the development journal for significant changes
- Follow the pre-commit checklist in `.claude/commands/quality/pre-commit.md`
- Update CHANGELOG.md for notable changes
- Test gem building and installation locally before releasing