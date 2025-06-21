# Chiron

A Ruby gem that initializes Claude AI development workflows, PRD templates, and journaling system for Rails projects. Named after the wise centaur who mentored heroes, Chiron helps you quickly set up a structured development process that integrates seamlessly with Claude Code.

## Features

- 🚀 **Quick Setup**: Initialize Claude workflow with one command
- 📋 **PRD Workflow**: Structured Product Requirements Document creation
- ✅ **Task Management**: Generate and track implementation tasks
- 📓 **Development Journal**: Track progress and maintain project history
- 🔄 **Migration Tool**: Easy migration from `.cursor` to `.claude` structure
- 🎯 **Quality Checks**: Pre-commit checklists and TDD workflows
- 🛠️ **Customizable**: Adapt workflows to your team's needs

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chiron'
```

And then execute:
```bash
bundle install
```

Or install it yourself as:
```bash
gem install chiron
```

## Usage

### Initialize Claude Workflow

In your Rails project root:

```bash
chiron init
```

This will:
- Create `.claude/commands/` directory with workflow templates
- Generate `CLAUDE.md` with project-specific configuration
- Set up `tasks/` directory for PRDs and task lists
- Initialize development journal in `docs/`
- Update `.gitignore` appropriately

### Command Options

```bash
# Initialize with options
chiron init --project-name="MyApp" --with-viewcomponents

# Migrate from .cursor to .claude
chiron migrate-cursor

# Add specific workflow
chiron add-workflow test-driven

# Update workflows to latest version
chiron update

# Check setup health
chiron doctor
```

## Workflow Structure

After initialization, you'll have:

```
your-rails-app/
├── .claude/
│   ├── commands/
│   │   ├── workflows/      # Development workflows
│   │   │   ├── create-prd.md
│   │   │   ├── generate-tasks.md
│   │   │   └── process-tasks.md
│   │   ├── conventions/    # Language/framework rules
│   │   │   └── rails.md
│   │   ├── context/        # Context commands
│   │   │   ├── quickstart.md
│   │   │   └── catchup.md
│   │   ├── journal/        # Journal management
│   │   │   ├── instructions.md
│   │   │   └── template.md
│   │   └── quality/        # Quality assurance
│   │       ├── pre-commit.md
│   │       └── test-driven.md
│   └── settings.json       # Claude permissions
├── CLAUDE.md              # Project-specific Claude instructions
├── tasks/                 # PRDs and task lists
└── docs/
    └── development_journal.md
```

## Key Workflows

### 1. Creating a PRD
When starting a new feature, Claude will:
- Ask clarifying questions
- Generate a structured PRD
- Save it as `tasks/prd-[feature-name].md`

### 2. Generating Tasks
From a PRD, Claude will:
- Create high-level tasks
- Break them into subtasks
- Save as `tasks/tasks-prd-[feature-name].md`

### 3. Development Journal
Claude maintains a journal with:
- Daily work summaries
- Technical decisions
- Bug fixes and features
- Multi-developer collaboration tracking

### 4. Quality Checks
Before committing:
- Run the pre-commit checklist
- Follow TDD workflow
- Update documentation

## Example Claude Commands

After setup, you can tell Claude:

- "Create a PRD for user authentication"
- "Generate tasks from prd-user-auth.md"
- "Catchup" (for project status)
- "Update the journal"
- "Run pre-commit checks"

## Customization

All templates are customizable. After initialization:
1. Edit files in `.claude/commands/` to match your workflow
2. Modify `CLAUDE.md` for project-specific instructions
3. Add custom workflows as needed

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ebrett/chiron.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).