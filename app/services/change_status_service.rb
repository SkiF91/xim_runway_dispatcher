class ChangeStatusService
  AircraftStatus.humanized_statuses.keys.each do |key|
    define_method "#{key}!" do
      Aircraft.transaction do
        @aircraft.status = key
        @aircraft.history << History.new(status: key, created_at: Time.now)

        raise ActiveRecord::Rollback unless @aircraft.save
      end

      @aircraft
    end
  end

  def initialize(aircraft)
    @aircraft = aircraft
  end
end