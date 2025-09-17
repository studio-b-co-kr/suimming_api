source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0', '>= 8.0.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 7.0.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# file storage
gem 'carrierwave', '~> 3.1.2'
gem 'fog-aws'
gem 'aws-sdk-s3', '~> 1'

# serializer
gem 'active_model_serializers', '~> 0.10.0'

# firebase
gem 'fcm'

# background jobs
gem 'sidekiq', '~> 8.0'
gem 'sidekiq-scheduler'
gem 'sidekiq-unique-jobs'
gem 'sidekiq-throttled'

# auth
gem 'devise'
gem 'devise-jwt', '~> 0.12'

# http client
gem 'http'

# monitoring
gem 'newrelic_rpm'
gem 'health_check'

# Korean i18n module
gem 'ununiga'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 3.0'

group :development, :test do
  gem 'dotenv-rails'
  # debugger
  gem 'pry-rails'
  # rspecs
  gem 'rspec-rails', '~> 8.0'
  gem 'factory_bot_rails'
  gem 'guard-rspec', require: false
  gem 'rspec-json_expectations'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'listen', '~> 3.9'
  gem 'spring', '~> 4.0'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'rename'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
