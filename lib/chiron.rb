# frozen_string_literal: true

require_relative 'chiron/version'
require_relative 'chiron/cli'

module Chiron
  class Error < StandardError; end

  def self.root
    File.expand_path('..', __dir__)
  end

  def self.templates_path
    File.join(root, 'lib', 'chiron', 'templates')
  end
end
