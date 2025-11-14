class ApplicationController < ActionController::Base
  include HttParty

  def index
    #just displays the view UI
  end

  def get_forecast
    location = params["location"].strip
    #use free API to get global coordinates of given location    
    get_coords = HTTParty.get("https://geocoding-api.open-meteo.com/v1/search?name=#{location}&count=10&language=en&format=json")
    if get_coords["results"].present?
      lat, long = get_coords["results"][0]["latitude"], get_coords["results"][0]["longitude"]
    else
      #handle error
    end
    #look up weather info by coordinates
    url = "https://api.weather.gov/points/#{latitude},#{longitude}"
    response = HTTParty.get(url)
    #response.body, response.code, response.message, response.headers.inspect
  end
end
