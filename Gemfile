# You *must* specify versions for each dependency (this is a Hack Club
# convention, not an actual technical requirement)
source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg', '~> 0.18.4'
gem 'puma', '~> 3.0'

gem 'rack-cors', require: 'rack/cors'
gem 'faker', '~> 1.6'
gem 'geocoder', '~> 1.4'
gem 'rest-client', '~> 2.0'
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.1'
gem 'sentry-raven', '~> 2.0', '>= 2.0.2'
gem 'active_model_serializers', '~> 0.10.0'
gem 'concurrent-ruby', require: 'concurrent'

group :development, :test do
  gem 'listen', '~> 3.0.5'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec', '~> 1.0'

  gem 'dotenv-rails', '~> 2.1'
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.7'
  gem 'webmock', '~> 2.1'
  gem 'vcr', '~> 3.0'
  gem 'database_cleaner', '~> 1.5', '>= 1.5.3'

  gem 'shoulda-matchers', '~> 3.1'

  # Use Guard for a great test workflow
  gem 'guard-rspec', '~> 4.7', require: false

  # For creating code coverage reports with Code Climate
  gem 'codeclimate-test-reporter', '~> 0.6.0'

  # Allow formatting rspec test results in junit's format, giving CircleCI
  # better insight into tests
  gem 'rspec_junit_formatter', '~> 0.2.3'

  gem 'rubocop', '~> 0.46.0', require: false
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.3.1'
