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
      lat, long = get_coords["results"][0]["latitude"], get_coords["results"][0]["longitude"]
    else
      #handle error
    end
    #use National Weather Service api to get data endpoint by coordinates
    url = "https://api.weather.gov/points/#{latitude},#{longitude}"
    response = HTTParty.get(url)
    response = JSON.parse(response)
    if response["status"] == 404
      #return error
    end
    forecast_url = response["properties"]["forecast"]
    #get National Weather Service forecast data for location
    response = HTTParty.get(forecast_url)
    response = JSON.parse(response)
    forecast = {}
    if response["status"] == 404
      #TODO handle error
    else
      forecast_data = response["property"]["periods"][0]
      forecast["details"] = forecast_data["detailedForecast"]
      forecast["temp"] = forecast_data["temperature"]
    end
    render json: {forecast: forecast, error: error}, status: :ok
  end
end
