Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{Rails.configuration.queue[:host]}:#{Rails.configuration.queue[:port]}/#{Rails.configuration.queue[:db]}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{Rails.configuration.queue[:host]}:#{Rails.configuration.queue[:port]}/#{Rails.configuration.queue[:db]}" }
end
