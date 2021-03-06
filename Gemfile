source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'metadata-json-lint'
  gem "puppet"
  gem 'puppetlabs_spec_helper'
  gem 'rake'
  gem 'rspec-core', '< 3.2.0' if RUBY_VERSION < '1.9'
  gem 'rspec-puppet'
  gem 'rspec-puppet-facts'
  gem 'rubocop', if RUBY_VERSION < '2.0.0' or Gem::Version.new((ENV['PUPPET_GEM_VERSION'] || '3.8.0').split(' ').last) < Gem::Version.new('4.0.0') then '< 0.42.0' end
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console', if RUBY_VERSION < '2.0.0' then '< 0.4.0' end

  gem 'puppet-lint-absolute_classname-check'
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check'
  gem 'puppet-lint-leading_zero-check'
  gem 'puppet-lint-resource_reference_syntax'
  gem 'puppet-lint-trailing_comma-check'
  gem 'puppet-lint-unquoted_string-check'
  gem 'puppet-lint-version_comparison-check'

  gem 'json_pure', '<= 2.0.1' if RUBY_VERSION < '2.0.0'
end

group :development do
  gem 'guard-rake' if RUBY_VERSION >= '2.2.5' # per dependency https://rubygems.org/gems/ruby_dep
  gem 'puppet-blacksmith'
  gem 'travis'      if RUBY_VERSION >= '2.1.0'
  gem 'travis-lint' if RUBY_VERSION >= '2.1.0'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-puppet_install_helper'
  gem 'beaker-rspec'
end
