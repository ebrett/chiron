# frozen_string_literal: true

require_relative 'lib/chiron/version'

Gem::Specification.new do |spec|
  spec.name = 'chiron'
  spec.version = Chiron::VERSION
  spec.authors = ['Brett McHargue']
  spec.email = ['ebrett@users.noreply.github.com']

  spec.summary = 'Initialize Claude AI workflow for Rails projects'
  spec.description = 'A Ruby gem that sets up Claude AI development workflows, PRD templates, ' \
                     'and journaling system for Rails projects'
  spec.homepage = 'https://github.com/ebrett/chiron'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'colorize', '~> 1.1'
  spec.add_dependency 'thor', '~> 1.3'
  spec.add_dependency 'tty-prompt', '~> 0.23'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'
end
