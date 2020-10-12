class AircraftsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'aircrafts'
  end
end