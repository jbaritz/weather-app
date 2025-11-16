module ApplicationHelper
  
  def get_forecast_by_location(location_string)
    latitude, longitude = get_coords(location_string)
    #use National Weather Service api to get data endpoint by coordinates
    forecast_url = get_forecast_endpoint(latitude, longitude)
    #get National Weather Service forecast data for location
    current_weather = get_forecast_data(forecast_url)
    #return data as array to be mapped to results object
    details_string = "#{current_weather["shortForecast"]}, #{current_weather["probabilityOfPrecipitation"]["value"]}% chance of precipitation"
    [details_string, current_weather["temperature"]]
  end

  def get_coords(location)
    coords = HTTParty.get("https://geocoding-api.open-meteo.com/v1/search?name=#{location}&count=1&language=en&format=json")
    latitude, longitude = coords["results"][0]["latitude"], coords["results"][0]["longitude"]
  end

  def get_forecast_endpoint(latitude, longitude)
    url = "https://api.weather.gov/points/#{latitude},#{longitude}"
    response = HTTParty.get(url)
    response = JSON.parse(response)
    forecast_url = response["properties"]["forecastHourly"]
  end

  def get_forecast_data(forecast_url)
    forecast_data = HTTParty.get(forecast_url)
    forecast_data = JSON.parse(forecast_data)
    current_weather = forecast_data["properties"]["periods"][0]
  end

end
