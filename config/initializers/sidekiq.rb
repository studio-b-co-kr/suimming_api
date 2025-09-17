require 'sidekiq/throttled'

options = {
  url: ENV['REDIS_URL'],
  timeout: 5, # Defaults to 1 second
  connect_timeout: 30, # Defaults to 1 second
  reconnect_attempts: 5
}
options = options.tap do |options|
  options[:password] = ENV['REDIS_PASSWORD'] if ENV['REDIS_PASSWORD']
  if ENV['REDIS_SSL'] # actually tls on elasticache
    options[:ssl] = true
    options[:ssl_params] = { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end
end

Sidekiq.configure_client do |config|
  config.redis = options

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

Sidekiq.configure_server do |config|
  config.redis = options

  # if ENV.fetch('IS_SCHEDULER', false)
  #   config.on(:startup) do
  #     Sidekiq.schedule = YAML.load_file(File.expand_path("../scheduler.yml", File.dirname(__FILE__)))
  #     Sidekiq::Scheduler.reload_schedule!
  #   end
  # end

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end
