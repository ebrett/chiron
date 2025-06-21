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

  describe '#version' do
    it 'displays the version' do
      expect { cli.version }.to output(/#{Chiron::VERSION}/).to_stdout
    end
  end
end
