require_relative 'xrd_singleton'
require_relative 'xrd_config'
require_relative 'xrd_redis'
require_relative 'xrd_bunny'

class Xrd
  XIM_RUNWAY_QUEUE = 'runway'
  XIM_BUNNY_QUEUE = 'xrd'
end