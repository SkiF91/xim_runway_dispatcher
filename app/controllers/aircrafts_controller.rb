class AircraftsController < ApplicationController
  before_action :find_aircraft, except: [:index, :create]
  before_action :action_service, only: [:to_runway, :cancel]

  def index
    if params[:history]
      aircrafts = Aircraft.inactive
    else
      aircrafts = Aircraft.active
    end

    render json: aircrafts.sorted
  end

  def create
    if (a = CreateAircraftService.new.call).errors.blank?
      render json: a
    else
      render json: a.errors, status: :unprocessable_entity
    end
  end

  def history
    render json: @aircraft.history.sorted
  end

  def to_runway; end

  def cancel; end

  private

  def action_service
    aircraft = "#{action_name.camelize}Service".constantize.new(@aircraft).call

    if aircraft.errors.present?
      render json: aircraft.errors, status: :unprocessable_entity
    else
      render json: { aircraft: aircraft, history: aircraft.history.last }
    end
  end

  def find_aircraft
    @aircraft = Aircraft.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
    false
  end
end
