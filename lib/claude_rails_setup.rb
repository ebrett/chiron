# frozen_string_literal: true

require_relative 'claude_rails_setup/version'
require_relative 'claude_rails_setup/cli'

module ClaudeRailsSetup
  class Error < StandardError; end

  def self.root
    File.expand_path('..', __dir__)
  end

  def self.templates_path
    File.join(root, 'lib', 'claude_rails_setup', 'templates')
  end
end
