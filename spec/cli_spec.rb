# frozen_string_literal: true

require 'spec_helper'
require 'chiron/cli'
require 'tmpdir'
require 'fileutils'

RSpec.describe Chiron::CLI do
  let(:cli) { described_class.new }
  let(:test_dir) { Dir.mktmpdir }
  let(:original_dir) { Dir.pwd }

  before do
    Dir.chdir(test_dir)
    # Silence output during tests
    allow($stdout).to receive(:puts)
    allow($stdout).to receive(:print)
  end

  after do
    Dir.chdir(original_dir)
    FileUtils.remove_entry(test_dir)
  end

  describe '#init' do
    context 'with Rails project' do
      before do
        # Create a basic Gemfile to satisfy Rails project check
        File.write('Gemfile', "gem 'rails'")

        # Stub the TTY::Prompt to avoid interactive input
        prompt = instance_double(TTY::Prompt)
        allow(TTY::Prompt).to receive(:new).and_return(prompt)
        allow(prompt).to receive(:ask).and_return('test_project')
      end

      it 'creates the necessary directories' do
        cli.init

        expect(Dir.exist?('.claude')).to be true
        expect(Dir.exist?('.claude/commands')).to be true
        expect(Dir.exist?('tasks')).to be true
        expect(Dir.exist?('docs')).to be true
      end

      it 'creates CLAUDE.md file' do
        cli.init

        expect(File.exist?('CLAUDE.md')).to be true
        expect(File.read('CLAUDE.md')).to include('CLAUDE.md')
      end

      it 'creates development journal' do
        cli.init

        expect(File.exist?('docs/development_journal.md')).to be true
      end
    end

    context 'with Python project' do
      before do
        # Create a requirements.txt to satisfy Python project check
        File.write('requirements.txt', 'pytest\nblack\nflake8')

        # Stub the TTY::Prompt to avoid interactive input
        prompt = instance_double(TTY::Prompt)
        allow(TTY::Prompt).to receive(:new).and_return(prompt)
        allow(prompt).to receive(:ask).and_return('test_project')
      end

      it 'creates the necessary directories' do
        cli.init

        expect(Dir.exist?('.claude')).to be true
        expect(Dir.exist?('.claude/commands')).to be true
        expect(Dir.exist?('tasks')).to be true
        expect(Dir.exist?('docs')).to be true
      end

      it 'creates CLAUDE.md file with Python content' do
        cli.init

        expect(File.exist?('CLAUDE.md')).to be true
        content = File.read('CLAUDE.md')
        expect(content).to include('Python')
        expect(content).to include('pytest')
      end

      it 'creates development journal' do
        cli.init

        expect(File.exist?('docs/development_journal.md')).to be true
      end
    end
  end

  describe '#version' do
    it 'displays the version' do
      expect { cli.version }.to output(/#{Chiron::VERSION}/).to_stdout
    end
  end

  describe '#detect_project_type' do
    it 'detects Rails projects' do
      File.write('Gemfile', "gem 'rails'")
      expect(cli.send(:detect_project_type)).to eq(:rails)
    end

    it 'detects Python projects with requirements.txt' do
      File.write('requirements.txt', 'pytest')
      expect(cli.send(:detect_project_type)).to eq(:python)
    end

    it 'detects Python projects with pyproject.toml' do
      File.write('pyproject.toml', '[tool.poetry]')
      expect(cli.send(:detect_project_type)).to eq(:python)
    end

    it 'returns unknown for unrecognized projects' do
      expect(cli.send(:detect_project_type)).to eq(:unknown)
    end
  end

  describe '#detect_python_framework' do
    it 'detects Django projects' do
      File.write('manage.py', '#!/usr/bin/env python')
      expect(cli.send(:detect_python_framework)).to eq(:django)
    end

    it 'detects FastAPI projects' do
      File.write('requirements.txt', 'fastapi\nuvicorn')
      File.write('main.py', 'from fastapi import FastAPI')
      expect(cli.send(:detect_python_framework)).to eq(:fastapi)
    end

    it 'detects Flask projects' do
      File.write('requirements.txt', 'flask\nwerkzeug')
      File.write('app.py', 'from flask import Flask')
      expect(cli.send(:detect_python_framework)).to eq(:flask)
    end

    it 'returns generic for other Python projects' do
      File.write('requirements.txt', 'requests\npandas')
      File.write('main.py', 'import requests')
      expect(cli.send(:detect_python_framework)).to eq(:generic)
    end
  end

  describe '#python_package_exists?' do
    it 'returns true for requirements.txt' do
      File.write('requirements.txt', 'pytest')
      expect(cli.send(:python_package_exists?)).to be true
    end

    it 'returns true for pyproject.toml' do
      File.write('pyproject.toml', '[tool.poetry]')
      expect(cli.send(:python_package_exists?)).to be true
    end

    it 'returns true for setup.py' do
      File.write('setup.py', 'from setuptools import setup')
      expect(cli.send(:python_package_exists?)).to be true
    end

    it 'returns true for Pipfile' do
      File.write('Pipfile', '[packages]')
      expect(cli.send(:python_package_exists?)).to be true
    end

    it 'returns false when no package file exists' do
      expect(cli.send(:python_package_exists?)).to be false
    end
  end

  describe 'Python project workflows' do
    before do
      File.write('requirements.txt', 'pytest\nblack\nflake8')
      prompt = instance_double(TTY::Prompt)
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:ask).and_return('test_project')
    end

    it 'copies Python-specific workflow templates' do
      cli.init

      expect(File.exist?('.claude/commands/conventions/python.md')).to be true
      expect(File.exist?('.claude/commands/workflows/debug-python.md')).to be true
      expect(File.exist?('.claude/commands/workflows/python-refactor.md')).to be true
      expect(File.exist?('.claude/commands/quality/python-testing.md')).to be true
    end

    it 'creates Python-specific CLAUDE.md' do
      cli.init

      content = File.read('CLAUDE.md')
      expect(content).to include('Python project')
      expect(content).to include('pytest')
      expect(content).to include('black')
      expect(content).to include('flake8')
    end
  end

  describe 'Django project detection' do
    before do
      File.write('manage.py', '#!/usr/bin/env python')
      File.write('requirements.txt', 'django')
      prompt = instance_double(TTY::Prompt)
      allow(TTY::Prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:ask).and_return('test_project')
    end

    it 'detects Django framework and includes Django-specific content' do
      cli.init

      content = File.read('CLAUDE.md')
      expect(content).to include('using Django framework')
      expect(content).to include('python manage.py')
    end
  end
end
