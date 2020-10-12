class CancelService
  def initialize(aircraft)
    @aircraft = aircraft
  end

  def call
    if @aircraft.status.can_cancel?
      if del_from_redis
        ChangeStatusService.new(@aircraft).standby!
      end
    end

    @aircraft
  end

  private

  def del_from_redis
    q = XrdRedis.queue(Xrd::XIM_RUNWAY_QUEUE)
    !!q.del(@aircraft.id)
  end
end