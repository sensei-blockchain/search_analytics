require 'sidekiq/web'
unless Rails.env.development?
  Sidekiq.configure_client do |config|
    config.redis = { url: Figaro.env.REDIS_URL, size: 2, password: Figaro.env.REDIS_PASSWORD }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: Figaro.env.REDIS_URL, size: 20, password: Figaro.env.REDIS_PASSWORD }
  end
end
