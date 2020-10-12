require 'redis'
require 'connection_pool'
require 'monitor'

class XrdRedis < XrdSingleton
  extend XrdConfig

  def initialize
    raise "Not configured" if self.class.config.empty?
    @_pool = make_pool
    @_queue_mutex = Monitor.new
    @queues = {}
  end

  def ping
    @_pool && @_pool.with do |redis|
      redis.ping
    end
  end

  def queue(name)
    @_queue_mutex.synchronize { @queues[name] ||= Queue.new(self, name) }
  end

  def queue_worker(queue_name)
    XrdRedis::QueueWorker.new(self, queue_name)
  end

  def method_missing(method, *args)
    @_pool && @_pool.with do |redis|
      if block_given?
        redis.send(method, *args) do |*a|
          yield(*a)
        end
      else
        redis.send(method, *args)
      end
    end
  end

  private

  def make_pool
    ConnectionPool.new(size: self.class.config[:pool]) do
      ::Redis.new url: self.class.config[:url]
    end
  end

  class Queue
    attr_reader :queue_name

    def initialize(redis, name)
      @_redis = redis
      @queue_name = name
      @_queue_name = "_#{name}"
    end

    def push(value)
      @_redis.lpush self.queue_name, value
    end

    def pop
      @_redis.brpop self.queue_name
    end

    def safe_pop
      @_redis.brpoplpush(self.queue_name, @_queue_name)
    end

    def commit(value)
      @_redis.lrem @_queue_name, 0, value
    end

    def reject(value)
      self.del(value)
      self.push(value)
    end

    def clear
      @_redis.del self.queue_name
      @_redis.del @_queue_name
    end

    def del(value)
      @_redis.lrem self.queue_name, 0, value
      @_redis.lrem @_queue_name, 0, value
    end

    def restore
      while (value = @_redis.lpop(@_queue_name))
        @_redis.rpush(self.queue_name, value)
      end
    end
  end

  class QueueWorker
    def initialize(redis, queue_name)
      @_redis = redis
      @_redis_queue = queue_name
      @_queue = @_redis.queue(@_redis_queue)
      @_queue.restore
    end

    def do_work
      loop do
        value = @_queue.safe_pop

        if value.present?
          puts " * QueueWorker value: #{value}"

          res = yield(value)

          if res
            @_queue.commit(value)
          else
            @_queue.reject(value)
          end
        end
      end
    end
  end
end