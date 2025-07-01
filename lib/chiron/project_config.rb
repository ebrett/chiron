# frozen_string_literal: true

module Chiron
  class ProjectConfig
    attr_reader :type, :test_runner, :linter, :formatter, :framework

    def initialize(project_type, framework = nil)
      @type = project_type
      @framework = framework

      case project_type
      when :rails
        @test_runner = 'bin/rspec'
        @linter = 'bin/rubocop'
        @formatter = 'bin/rubocop --autocorrect'
      when :python
        @test_runner = 'pytest'
        @linter = 'flake8'
        @formatter = 'black'
      end
    end

    def framework_name
      case @framework
      when :django
        'Django'
      when :fastapi
        'FastAPI'
      when :flask
        'Flask'
      else
        @type.to_s.capitalize
      end
    end

    def test_command(file = nil)
      case @type
      when :rails
        file ? "#{@test_runner} #{file}" : @test_runner
      when :python
        file ? "#{@test_runner} #{file}" : @test_runner
      end
    end

    def format_command(file = nil)
      case @type
      when :rails
        file ? "#{@formatter} #{file}" : @formatter
      when :python
        file ? "#{@formatter} #{file}" : "#{@formatter} ."
      end
    end

    def lint_command(file = nil)
      case @type
      when :rails
        file ? "#{@linter} #{file}" : @linter
      when :python
        file ? "#{@linter} #{file}" : @linter
      end
    end

    def package_file
      case @type
      when :rails
        'Gemfile'
      when :python
        if File.exist?('pyproject.toml')
          'pyproject.toml'
        elsif File.exist?('Pipfile')
          'Pipfile'
        elsif File.exist?('setup.py')
          'setup.py'
        else
          'requirements.txt'
        end
      end
    end

    def install_command
      case @type
      when :rails
        'bundle install'
      when :python
        if File.exist?('Pipfile')
          'pipenv install'
        elsif File.exist?('pyproject.toml') && File.read('pyproject.toml').include?('[tool.poetry]')
          'poetry install'
        else
          'pip install -r requirements.txt'
        end
      end
    end
  end
end
