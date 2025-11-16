class LocationData

  attr_accessor :location, :latitude, :longitude, :forecast_url, :temperature, :details, :from_cache, :error

  def initialize(location)
    self.location = location
    self.error = false
    self.from_cache = true
  end

  def get_forecast_by_location
    #get geo coordinates for given location string from API
    get_coords
    #use National Weather Service API to get data endpoint by coordinates
    get_forecast_endpoint
    #get National Weather Service API forecast data for location
    current_weather = get_forecast_data
    #return data as array to be mapped to results object
    self.details = "#{current_weather["shortForecast"]}, #{current_weather["probabilityOfPrecipitation"]["value"]}% chance of precipitation"
    self.temperature = current_weather["temperature"]
  end

  def get_coords
    #get coordinates for given city name or ZIP code, which is necessary for retrieving forecast data from NWS API
    coords = HTTParty.get("https://geocoding-api.open-meteo.com/v1/search?name=#{self.location}&count=1&language=en&format=json")
    self.latitude, self.longitude = coords["results"][0]["latitude"], coords["results"][0]["longitude"]
  end

  def get_forecast_endpoint
    #using provided coordinates, get NWS API endpoint string to be used to retrieve forecast data
    url = "https://api.weather.gov/points/#{self.latitude},#{self.longitude}"
    response = HTTParty.get(url)
    response = JSON.parse(response)
    self.forecast_url = response["properties"]["forecastHourly"]
  end

  def get_forecast_data
    #use NWS API endpoint to get current weather data for location
    forecast_data = HTTParty.get(self.forecast_url)
    forecast_data = JSON.parse(forecast_data)
    #return most recent weather info
    forecast_data["properties"]["periods"][0]
  end

  
end
