class WorkerService
  attr_reader :aircraft

  def initialize(value)
    @value = value.to_i
    @aircraft = Aircraft.where(id: @value).first
  end

  def call
    return true if @aircraft.blank? || !@aircraft.status.active? || @aircraft.status.can_send?
    return false unless ChangeStatusService.new(@aircraft).on_take_off!.valid?

    if yield
      ChangeStatusService.new(@aircraft).took_off!
      return true
    end

    false
  end
end