require_relative '../config/environment'

worker = XrdRedis.queue_worker(Xrd::XIM_RUNWAY_QUEUE)
requestor = XrdBunny.requestor(Xrd::XIM_BUNNY_QUEUE)

begin
  worker.do_work do |value|
    ws = WorkerService.new(value)
    res = ws.call do
      ActionCable.server.broadcast 'aircrafts', { aircraft: ws.aircraft, history: ws.aircraft.history.last }
      res = requestor.publish(value)
      res.to_i > 0
    end

    if res
      ActionCable.server.broadcast 'aircrafts', { aircraft: ws.aircraft, history: ws.aircraft.history.last }
    else
      puts " * Errors: #{ws.aircraft.errors.full_messages}"
    end

    true
  end
rescue Interrupt => _
  XrdBunny.stop
end