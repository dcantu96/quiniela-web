Sidekiq.configure_server do |config|   
  config.redis = { url: Rails.env.production? ? ENV['REDIS_URL'] : 'redis://127.0.0.1:7372/0', network_timeout: 5 } 
end

Sidekiq.configure_client do |config|   
  config.redis = { url: Rails.env.production? ? ENV['REDIS_URL'] : 'redis://127.0.0.1:7372/0', network_timeout: 5 } 
end
