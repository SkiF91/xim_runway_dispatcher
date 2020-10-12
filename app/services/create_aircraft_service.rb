class CreateAircraftService
  def call
    now = Time.now

    a = Aircraft.new(
      name: generate_name,
      status: AircraftStatus::ST_DEFAULT,
      last_change: now,
      history: [History.new(status: AircraftStatus::ST_DEFAULT, created_at: now)]
    )
    if a.save
      ActionCable.server.broadcast 'aircrafts', @aircraft
    end
    a
  end

  private

  # just some humanization no more
  def generate_name
    "AC-#{(Aircraft.last.try(:id) || 1) + Random.rand(1000)}"
  end
end