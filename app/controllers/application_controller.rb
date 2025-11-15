class ApplicationController < ActionController::Base
  include HTTParty
  include ApplicationHelper

  def index
    #just displays the UI
  end

  def get_forecast
    location = params["location"].strip
    from_cache = true
    error = false
    results = {}
    begin
      stored_data = Rails.cache.read(location)
      if stored_data.present?
        results = stored_data
      else
        from_cache = false
        results[:details], results[:temp] = get_forecast_by_location(location)
        Rails.cache.write(location, results, expires_in: 30.minutes) if location.to_i != 0  #only cache if location string is a ZIP code
      end
    rescue
      error = true
    end
    render json: {forecast: results, error: error, cached: from_cache}, status: :ok
  end

end
