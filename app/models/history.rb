class History < ApplicationRecord
  include AircraftStatus::ModelTrait

  belongs_to :aircraft, inverse_of: :history

  validates :status, :created_at, presence: true

  scope :sorted, -> {
    order(:aircraft_id, :created_at)
  }
end