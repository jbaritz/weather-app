class ApplicationController < ActionController::Base
  include HTTParty

  def index
    #just displays the UI
  end

  def get_forecast
    location_string = params["location"].strip
    location = LocationData.new(location_string)
    begin
      #check if data for given location exists in cache and return cache data if present
      stored_data = Rails.cache.read(location_string)
      if stored_data.present?
        location.details, location.temperature = stored_data[:details], stored_data[:temperature]
      else
        location.from_cache = false
        location.get_forecast_by_location
        Rails.cache.write(location.location, {details: location.details, temperature: location.temperature}, expires_in: 30.minutes) if location_string.to_i != 0  #only save to cache if location string is a ZIP code
      end
    rescue
      location.error = true
    end
    render json: {forecast: location, error: location.error}, status: :ok
  end

end
