source 'https://rubygems.org'

# Specify your gem's dependencies in cluster-discovery.gemspec
gemspec

group :development do
  gem 'yard', '~> 0.8'
  gem 'thor', '~> 0.19.1'
  gem 'thor-scmversion', '= 1.7.0'

  group :guard do
    gem 'guard', '~> 2.13'
    gem 'guard-rspec', '~> 4.6'
    gem 'guard-rubocop', '~> 1.2'
    gem 'terminal-notifier-guard', '~> 1.6'
  end
end

group :development, :test do
  gem 'rubocop', '~> 0.34'
  gem 'simplecov', '~> 0.11'
  gem 'vcr', '~> 3.0'
  gem 'webmock', '~> 1.22'
  gem 'rspec', '~> 3.4'
  gem 'httparty', '~> 0.13'
end
