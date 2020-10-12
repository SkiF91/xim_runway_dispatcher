require 'xrd'

unless ENV['XIM_REDIS_URL']
  abort "ERROR: Redis misconfigured."
end
unless ENV['XIM_BUNNY_URL']
  abort "ERROR: RabbitMQ misconfigured."
end

XrdRedis.config = {
  url: ENV['XIM_REDIS_URL'],
  pool: ENV['XIM_REDIS_POOL'] || ENV["RAILS_MAX_THREADS"] || 1
}

XrdBunny.config = {
  url: ENV['XIM_BUNNY_URL']
}

if !Rails.env.test? && !XrdRedis.ping
  abort "ERROR: Cannot connect to Redis server by url: \"#{XrdRedis.config[:url]}\""
end