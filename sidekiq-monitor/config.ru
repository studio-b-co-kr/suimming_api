require 'sidekiq'

options = { url: ENV['JOBS_REDIS_URL'] }.tap{ |options| options[:password] = ENV['JOBS_REDIS_PASSWORD'] if ENV['JOBS_REDIS_PASSWORD'] }

Sidekiq.configure_client do |config|
  config.redis = options
end

require 'sidekiq/web'
require 'sidekiq-scheduler/web'
require 'sidekiq_unique_jobs'
require 'sidekiq_unique_jobs/web'
run Sidekiq::Web
