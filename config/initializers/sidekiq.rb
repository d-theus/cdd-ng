Sidekiq.configure_server do |config|
  fail 'No redis queue hostname specified' unless ENV['QUEUE_HOSTNAME']
  fail 'No redis queue port specified' unless ENV['QUEUE_PORT']
  fail 'No redis queue db specified' unless ENV['QUEUE_DBNO']
  config.redis = { url: "redis://#{Rails.env.production? ? ENV['QUEUE_HOSTNAME'] : 'localhost' }:#{ENV['QUEUE_PORT']}/#{ENV['QUEUE_DBNO']}" }
end

Sidekiq.configure_client do |config|
  fail 'No redis queue hostname specified' unless ENV['QUEUE_HOSTNAME']
  fail 'No redis queue port specified' unless ENV['QUEUE_PORT']
  fail 'No redis queue db specified' unless ENV['QUEUE_DBNO']
  config.redis = { url: "redis://#{Rails.env.production? ? ENV['QUEUE_HOSTNAME'] : 'localhost' }:#{ENV['QUEUE_PORT']}/#{ENV['QUEUE_DBNO']}" }
end
