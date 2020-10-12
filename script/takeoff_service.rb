require_relative '../lib/xrd'

unless ENV['XIM_BUNNY_URL']
  puts "ERROR: RabbitMQ misconfigured."
  exit 1
end
XrdBunny.config = {
  url: ENV['XIM_BUNNY_URL']
}

replier = XrdBunny.replier(Xrd::XIM_BUNNY_QUEUE)

begin
  replier.subscribe do |payload|
    r = Random.rand(10..15)
    puts " * Sleep: #{r}"
    sleep(r)

    r
  end
rescue Interrupt => _
  XrdBunny.stop
end