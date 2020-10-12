require 'bunny'
require 'connection_pool'

class XrdBunny < XrdSingleton
  extend XrdConfig

  def initialize
    raise "Not configured" if self.class.config.nil? || self.class.config.empty?
    connect
  end

  def publish(value, opts={})
    @_exchange.publish(value.to_s, opts)
  end

  def queue(queue_name, opts={})
    @_channel.queue(format_queue_name(queue_name), opts)
  end

  def subscribe(queue, opts={}, &block)
    queue.subscribe(opts, &block)
  end

  def stop
    @_channel.close
    @_connection.close
  end

  def requestor(queue_name)
    XrdBunny::RequestReply::Requestor.new(self, queue_name)
  end

  def replier(queue_name)
    XrdBunny::RequestReply::Replier.new(self, queue_name)
  end

  def format_queue_name(name)
    return name if name.empty?
    "xrd.#{name}"
  end

  private

  def connect
    @_connection = Bunny.new url: self.class.config[:url]
    @_connection.start
    @_channel = @_connection.create_channel
    @_exchange = @_channel.default_exchange
  end

  module RequestReply

    class Requestor
      def initialize(bunny, queue_name)
        @_bunny = bunny
        @_queue_name = @_bunny.format_queue_name(queue_name)
        @_reply_queue = bunny.queue('', exclusive: true)
        @_lock = Mutex.new
        @_condition = ConditionVariable.new
        @_response = nil
        subscribe_reply
      end

      def publish(value)
        @_call_id = SecureRandom.uuid

        puts " * Requestor send: #{value}"
        @_bunny.publish(value,
                        routing_key: @_queue_name,
                        correlation_id: @_call_id,
                        reply_to: @_reply_queue.name)

        @_lock.synchronize { @_condition.wait(@_lock) }

        puts " * Requestor got: #{@_response}"

        @_response
      end

      private

      def subscribe_reply
        @_bunny.subscribe(@_reply_queue) do |_delivery_info, properties, payload|
          if properties[:correlation_id] == @_call_id
            @_response = payload
            @_lock.synchronize { @_condition.signal }
          end
        end
      end
    end

    class Replier
      def initialize(bunny, queue_name)
        @_bunny = bunny
        @_queue = @_bunny.queue(queue_name)
      end

      def subscribe
        @_bunny.subscribe(@_queue, block: true) do |_delivery_info, properties, payload|
          puts " * Replier got: #{payload}"

          res = yield(payload)

          @_bunny.publish(res, routing_key: properties.reply_to, correlation_id: properties.correlation_id)

          puts " * Replier sent: #{res}"
        end
      end
    end
  end
end