# frozen_string_literal: true

require 'spec_helper'
require 'chiron/project_config'

RSpec.describe Chiron::ProjectConfig do
  describe 'Rails configuration' do
    let(:config) { described_class.new(:rails) }

    it 'sets Rails-specific tools' do
      expect(config.type).to eq(:rails)
      expect(config.test_runner).to eq('bin/rspec')
      expect(config.linter).to eq('bin/rubocop')
      expect(config.formatter).to eq('bin/rubocop --autocorrect')
    end

    it 'returns Rails package file' do
      expect(config.package_file).to eq('Gemfile')
    end

    it 'returns Rails install command' do
      expect(config.install_command).to eq('bundle install')
    end

    it 'returns framework name' do
      expect(config.framework_name).to eq('Rails')
    end
  end

  describe 'Python configuration' do
    let(:config) { described_class.new(:python) }

    it 'sets Python-specific tools' do
      expect(config.type).to eq(:python)
      expect(config.test_runner).to eq('pytest')
      expect(config.linter).to eq('flake8')
      expect(config.formatter).to eq('black')
    end

    it 'returns Python package file' do
      expect(config.package_file).to eq('requirements.txt')
    end

    it 'returns Python install command' do
      expect(config.install_command).to eq('pip install -r requirements.txt')
    end

    it 'returns framework name' do
      expect(config.framework_name).to eq('Python')
    end
  end

  describe 'Django configuration' do
    let(:config) { described_class.new(:python, :django) }

    it 'sets Django framework' do
      expect(config.framework).to eq(:django)
    end

    it 'returns Django framework name' do
      expect(config.framework_name).to eq('Django')
    end
  end

  describe 'FastAPI configuration' do
    let(:config) { described_class.new(:python, :fastapi) }

    it 'sets FastAPI framework' do
      expect(config.framework).to eq(:fastapi)
    end

    it 'returns FastAPI framework name' do
      expect(config.framework_name).to eq('FastAPI')
    end
  end

  describe 'Flask configuration' do
    let(:config) { described_class.new(:python, :flask) }

    it 'sets Flask framework' do
      expect(config.framework).to eq(:flask)
    end

    it 'returns Flask framework name' do
      expect(config.framework_name).to eq('Flask')
    end
  end

  describe 'command generation' do
    let(:rails_config) { described_class.new(:rails) }
    let(:python_config) { described_class.new(:python) }

    it 'generates test commands' do
      expect(rails_config.test_command).to eq('bin/rspec')
      expect(rails_config.test_command('spec/models/user_spec.rb')).to eq('bin/rspec spec/models/user_spec.rb')

      expect(python_config.test_command).to eq('pytest')
      expect(python_config.test_command('tests/test_user.py')).to eq('pytest tests/test_user.py')
    end

    it 'generates format commands' do
      expect(rails_config.format_command).to eq('bin/rubocop --autocorrect')
      expect(rails_config.format_command('app/models/user.rb')).to eq('bin/rubocop --autocorrect app/models/user.rb')

      expect(python_config.format_command).to eq('black .')
      expect(python_config.format_command('src/user.py')).to eq('black src/user.py')
    end

    it 'generates lint commands' do
      expect(rails_config.lint_command).to eq('bin/rubocop')
      expect(rails_config.lint_command('app/models/user.rb')).to eq('bin/rubocop app/models/user.rb')

      expect(python_config.lint_command).to eq('flake8')
      expect(python_config.lint_command('src/user.py')).to eq('flake8 src/user.py')
    end
  end
end
