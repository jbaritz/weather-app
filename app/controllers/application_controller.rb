class ApplicationController < ActionController::Base
  include HTTParty
  include ApplicationHelper

  def index
    #just displays the view UI
  end

  def get_forecast
    location = params["location"].strip
    #use free API to get global coordinates of given location   
    error = "" 
    get_coords = HTTParty.get("https://geocoding-api.open-meteo.com/v1/search?name=#{location}&count=10&language=en&format=json")
    if get_coords["results"].present?
      latitude, longitude = get_coords["results"][0]["latitude"], get_coords["results"][0]["longitude"]
    else
      # TODO: handle error
    end
    #use National Weather Service api to get data endpoint by coordinates
    url = "https://api.weather.gov/points/#{latitude},#{longitude}"
    response = HTTParty.get(url)
    response = JSON.parse(response)
    if response["status"] == 404
      # TODO: Return error
    end
    forecast_url = response["properties"]["forecast"]
    #get National Weather Service forecast data for location
    forecast_data = HTTParty.get(forecast_url)
    forecast_data = JSON.parse(forecast_data)
    results = {}
    if forecast_data["status"] == 404
      #TODO handle error
    else
      current_data = forecast_data["properties"]["periods"][0]
      results["details"] = current_data["detailedForecast"]
      results["temp"] = current_data["temperature"]
    end
    render json: {forecast: results, error: error}, status: :ok
  end
end
