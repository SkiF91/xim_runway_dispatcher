require 'xrd_redis'

class ToRunwayService
  def initialize(aircraft)
    @aircraft = aircraft
  end

  def call
    if @aircraft.status.can_send?
      if ChangeStatusService.new(@aircraft).waiting!.valid?
        push_to_redis
      end
    end

    @aircraft
  end

  private

  def push_to_redis
    q = XrdRedis.queue(Xrd::XIM_RUNWAY_QUEUE)
    q.push(@aircraft.id)
  end
end