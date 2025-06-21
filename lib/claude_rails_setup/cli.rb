# frozen_string_literal: true

require 'thor'
require 'tty-prompt'
require 'colorize'
require 'fileutils'
require 'erb'
require 'date'

module ClaudeRailsSetup
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'init', 'Initialize Claude workflow in current Rails project'
    option :project_name, type: :string, desc: 'Project name for CLAUDE.md'
    option :with_oauth, type: :boolean, default: false, desc: 'Include OAuth workflow examples'
    option :with_viewcomponents, type: :boolean, default: false, desc: 'Include ViewComponent rules'
    option :skip_journal, type: :boolean, default: false, desc: 'Skip development journal setup'
    def init
      say '🤖 Initializing Claude Rails Setup...'.colorize(:blue)

      @prompt = TTY::Prompt.new
      @project_name = options[:project_name] || prompt_for_project_name

      check_rails_project
      create_directories
      copy_templates
      update_gitignore

      say "\n✨ Claude workflow initialized successfully!".colorize(:green)
      say "\nNext steps:".colorize(:yellow)
      say '  1. Review and customize CLAUDE.md for your project'
      say '  2. Check .claude/commands/ for available workflows'
      say "  3. Run 'claude' to start using Claude with your new setup"
    end

    desc 'migrate-cursor', 'Migrate from .cursor to .claude structure'
    def migrate_cursor
      say '🔄 Migrating from .cursor to .claude...'.colorize(:blue)

      unless Dir.exist?('.cursor/rules')
        error 'No .cursor/rules directory found!'
        exit 1
      end

      create_directories
      migrate_rules

      if @prompt.yes?('Remove .cursor directory after migration?')
        FileUtils.rm_rf('.cursor')
        say '✅ .cursor directory removed'.colorize(:green)
      end

      say "\n✨ Migration completed!".colorize(:green)
    end

    desc 'add-workflow WORKFLOW', 'Add a specific workflow to your setup'
    def add_workflow(workflow_name)
      available_workflows = Dir.glob(File.join(templates_path, 'commands/**/*.md'))
                               .map { |f| File.basename(f, '.md') }

      unless available_workflows.include?(workflow_name)
        error "Unknown workflow: #{workflow_name}"
        say "Available workflows: #{available_workflows.join(', ')}"
        exit 1
      end

      copy_workflow(workflow_name)
      say "✅ Added #{workflow_name} workflow".colorize(:green)
    end

    desc 'update', 'Update Claude workflows to latest version'
    def update
      say '🔄 Updating Claude workflows...'.colorize(:blue)

      # Backup current commands
      if Dir.exist?('.claude/commands')
        backup_dir = ".claude/commands.backup.#{Time.now.strftime('%Y%m%d%H%M%S')}"
        FileUtils.cp_r('.claude/commands', backup_dir)
        say "📦 Backed up current commands to #{backup_dir}".colorize(:yellow)
      end

      copy_templates(update: true)
      say "\n✨ Workflows updated!".colorize(:green)
    end

    desc 'doctor', 'Check Claude setup health'
    def doctor
      say '🏥 Running Claude setup diagnostics...'.colorize(:blue)

      checks = {
        'Rails project' => Dir.exist?('app') && File.exist?('Gemfile'),
        'CLAUDE.md exists' => File.exist?('CLAUDE.md'),
        '.claude directory' => Dir.exist?('.claude'),
        '.claude/commands' => Dir.exist?('.claude/commands'),
        'Development journal' => File.exist?('docs/development_journal.md'),
        'Tasks directory' => Dir.exist?('tasks'),
        '.gitignore entry' => begin
          File.read('.gitignore').include?('.claude/')
        rescue StandardError
          false
        end
      }

      checks.each do |check, result|
        status = result ? '✅'.colorize(:green) : '❌'.colorize(:red)
        say "#{status} #{check}"
      end

      if checks.values.all?
        say "\n✨ All checks passed!".colorize(:green)
      else
        say "\n⚠️  Some checks failed. Run 'claude-rails init' to fix.".colorize(:yellow)
      end
    end

    desc 'version', 'Show version'
    def version
      say ClaudeRailsSetup::VERSION
    end

    private

    def prompt_for_project_name
      @prompt.ask("What's your project name?") do |q|
        q.required true
        q.default File.basename(Dir.pwd)
      end
    end

    def check_rails_project
      return if File.exist?('Gemfile') && File.read('Gemfile').include?('rails')

      error "This doesn't appear to be a Rails project!"
      exit 1
    end

    def create_directories
      dirs = [
        '.claude/commands/workflows',
        '.claude/commands/conventions',
        '.claude/commands/context',
        '.claude/commands/journal',
        '.claude/commands/quality',
        'tasks',
        'docs'
      ]

      dirs.each do |dir|
        FileUtils.mkdir_p(dir)
        say "📁 Created #{dir}".colorize(:light_blue) unless Dir.exist?(dir)
      end
    end

    def copy_templates(update: false)
      # Copy CLAUDE.md template
      unless update
        template_path = File.join(templates_path, 'CLAUDE.md.erb')
        if File.exist?(template_path)
          content = ERB.new(File.read(template_path)).result(binding)
          File.write('CLAUDE.md', content)
          say '📄 Created CLAUDE.md'.colorize(:light_blue)
        end
      end

      # Copy command templates
      copy_commands

      # Copy settings.json
      settings_path = File.join(templates_path, 'claude/settings.json')
      if File.exist?(settings_path) && !File.exist?('.claude/settings.json')
        FileUtils.cp(settings_path, '.claude/settings.json')
        say '⚙️  Created .claude/settings.json'.colorize(:light_blue)
      end

      # Initialize development journal
      return if options[:skip_journal] || File.exist?('docs/development_journal.md')

      create_development_journal
    end

    def copy_commands
      commands_dir = File.join(templates_path, 'commands')
      return unless Dir.exist?(commands_dir)

      Dir.glob(File.join(commands_dir, '**/*.md')).each do |file|
        relative_path = file.sub("#{commands_dir}/", '')
        target_path = File.join('.claude/commands', relative_path)

        FileUtils.mkdir_p(File.dirname(target_path))
        FileUtils.cp(file, target_path)
        say "📋 Copied #{relative_path}".colorize(:light_blue)
      end
    end

    def create_development_journal
      journal_template = File.join(templates_path, 'development_journal.md.erb')
      return unless File.exist?(journal_template)

      content = ERB.new(File.read(journal_template)).result(binding)
      File.write('docs/development_journal.md', content)
      say '📓 Created development journal'.colorize(:light_blue)
    end

    def update_gitignore
      gitignore_path = '.gitignore'
      return unless File.exist?(gitignore_path)

      gitignore_content = File.read(gitignore_path)

      return if gitignore_content.include?('.claude/')

      File.open(gitignore_path, 'a') do |f|
        f.puts "\n# Claude Code settings (but allow commands directory)"
        f.puts '.claude/*'
        f.puts '!.claude/commands/'
      end
      say '📝 Updated .gitignore'.colorize(:light_blue)
    end

    def migrate_rules
      Dir.glob('.cursor/rules/*.mdc').each do |rule_file|
        filename = File.basename(rule_file, '.mdc')

        # Map cursor rules to claude command structure
        target_dir = case filename
                     when 'create-prd', 'generate-tasks', 'process-task-list'
                       '.claude/commands/workflows'
                     when 'rails', 'view_component'
                       '.claude/commands/conventions'
                     when 'test-driven'
                       '.claude/commands/quality'
                     else
                       '.claude/commands/workflows'
                     end

        target_path = File.join(target_dir, "#{filename}.md")

        # Copy and transform the content
        content = File.read(rule_file)
        # Remove cursor-specific frontmatter
        content = content.sub(/---.*?---/m, '').strip

        File.write(target_path, content)
        say "📋 Migrated #{filename}".colorize(:light_blue)
      end
    end

    def templates_path
      ClaudeRailsSetup.templates_path
    end

    def error(message)
      say "❌ #{message}".colorize(:red)
    end
  end
end
