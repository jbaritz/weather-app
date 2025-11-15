class ApplicationController < ActionController::Base
  include HTTParty
  include ApplicationHelper

  def index
    #just displays the view UI
  end

  def get_forecast
    location = params["location"].strip
    #use free API to get global coordinates of given location
    results = {}
    error = false
    begin
      latitude, longitude = get_coords(location)
      #use National Weather Service api to get data endpoint by coordinates
      forecast_url = get_forecast_endpoint(latitude, longitude)
      #get National Weather Service forecast data for location
      current_data = get_forecast_data(forecast_url)
      results["details"] = current_data["detailedForecast"]
      results["temp"] = current_data["temperature"]
    rescue => e
      error = true
    end
    render json: {forecast: results, error: error}, status: :ok
  end

end
