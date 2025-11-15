module ApplicationHelper
  
  def get_coords(location_string)
    latitude, longitude, error
    coords = HTTParty.get("https://geocoding-api.open-meteo.com/v1/search?name=#{location}&count=1&language=en&format=json")
    if coords["results"].present?
      latitude, longitude = coords["results"][0]["latitude"], coords["results"][0]["longitude"]
    else
      error = true
    end
    latitude, longitude
  end

  def get_forecast_endpoint(lat,long)
    url = "https://api.weather.gov/points/#{latitude},#{longitude}"
    response = HTTParty.get(url)
    response = JSON.parse(response)
    forecast_url = response["properties"]["forecast"]
  end
    
  end

  def get_forecast_data(forecast_url)
    forecast_data = HTTParty.get(forecast_url)
    forecast_data = JSON.parse(forecast_data)
    current_data = forecast_data["properties"]["periods"][0] 
  end
  
end
