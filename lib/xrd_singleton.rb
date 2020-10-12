require 'singleton'

class XrdSingleton
  include ::Singleton

  class << self
    def method_missing(method, *args, &block)
      if block.nil?
        instance.send(method, *args)
      else
        instance.send(method, *args, &block)
      end
    end
  end
end