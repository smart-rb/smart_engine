# frozen_string_literal: true

require_relative 'lib/smart_core/engine/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6')

  spec.name     = 'smart_engine'
  spec.version  = SmartCore::Engine::VERSION
  spec.authors  = ['Rustam Ibragimov']
  spec.email    = ['iamdaiver@gmail.com']
  spec.homepage = 'https://github.com/smart-rb/smart_engine'
  spec.license  = 'MIT'

  spec.summary = <<~GEM_SUMMARY
    SmartCore Engine - a generic subset of SmartCore's functionality.
  GEM_SUMMARY

  spec.description = <<~GEM_DESCRIPTION
    SmartCore Engine - a set of core functionality shared beetwen a series of SmartCore gems.
  GEM_DESCRIPTION

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] =
    'https://github.com/smart-rb/smart_engine'
  spec.metadata['changelog_uri'] =
    'https://github.com/smart-rb/smart_engine/blob/master/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rbs',   '~> 1.0.5'
  spec.add_development_dependency 'steep', '~> 0.41.0'

  spec.add_development_dependency 'bundler',          '~> 2.2'
  spec.add_development_dependency 'rake',             '~> 13.0'
  spec.add_development_dependency 'rspec',            '~> 3.10'
  spec.add_development_dependency 'armitage-rubocop', '~> 1.7'
  spec.add_development_dependency 'simplecov',        '~> 0.21'
  spec.add_development_dependency 'pry',              '~> 0.13'
end
