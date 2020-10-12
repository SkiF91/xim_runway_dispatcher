class Aircraft < ApplicationRecord
  include AircraftStatus::ModelTrait

  has_many :history, inverse_of: :aircraft, dependent: :delete_all

  validates :name, :status, :last_change, presence: true

  scope :active, -> {
    where(status: AircraftStatus.active_statuses)
  }
  scope :inactive, -> {
    where.not(status: AircraftStatus.active_statuses)
  }
  scope :sorted, -> {
    order(:status, :last_change)
  }
end