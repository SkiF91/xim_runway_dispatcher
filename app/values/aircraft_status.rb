class AircraftStatus
  STATUSES = {

    0 => { name: :on_take_off, active: true, can_cancel: false, can_send: false },
    1 => { name: :waiting, active: true, can_cancel: true, can_send: false },
    2 => { name: :standby, active: true, can_cancel: false, can_send: true },
    3 => { name: :took_off, active: false, can_cancel: false, can_send: false }

  }.freeze

  ST_DEFAULT = 2

  def self.humanized_statuses
    @_h_statuses = STATUSES.inject({}) { |res, (k, v)| res[v[:name]] = k; res }.freeze
  end

  def self.active_statuses
    @_a_statuses = STATUSES.inject([]) { |res, (k, v)| res << k if v[:active]; res }
  end

  def self.can_cancel_statuses
    @_c_statuses = STATUSES.inject([]) { |res, (k, v)| res << k if v[:can_cancel]; res }
  end

  def initialize(status)
    if STATUSES[status].blank?
      if (st = self.class.humanized_statuses[status.to_s.to_sym]).blank?
        raise ArgumentError, "Unknown status: #{status.inspect}. Available statuses: #{STATUSES.keys.join(', ')}"
      else
        status = st
      end
    end

    @_status = status
  end

  def id
    @_status
  end

  def name
    STATUSES[@_status][:name]
  end

  def active?
    STATUSES[@_status][:active]
  end

  def can_cancel?
    STATUSES[@_status][:can_cancel]
  end

  def can_send?
    STATUSES[@_status][:can_send]
  end

  def caption
    I18n.t("status_#{self.name}")
  end

  def ==(other)
    self.eql?(other)
  end

  def eql?(other)
    @_status == other || self.name.to_s == other.to_s
  end

  def to_s
    "#{@_status.to_s} - #{self.name}"
  end

  def as_json
    STATUSES[@_status].merge(id: @_status, caption: self.caption).as_json
  end

  module ModelTrait
    def self.included(base)
      base.class_eval do
        validates :status, inclusion: { in: AircraftStatus::STATUSES.keys }, allow_nil: false
      end
    end

    def status
      @status ||= AircraftStatus.new(read_attribute(:status))
    end

    def status=(value)
      @status = AircraftStatus.new(value)
      super(@status.id)
    end
  end
end