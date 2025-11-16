require 'rails_helper'

RSpec.describe LocationData, type: :model do
  it "creates Location object" do
    location = LocationData.new("Denver")
    expect(location.location).to eq "Denver"
    expect(location.error).to be false
    expect(location.from_cache).to be true
  end

  describe "#get_coords" do
    it "gets coordinates for location by city name" do
      location = LocationData.new("Denver")
      expect(location.get_coords).to eq([39.73915,-104.9847])
    end
  end

  describe "#get_forecast_endpoint" do
    it "gets endpoint for forecast data by coordinates" do
      location = LocationData.new("Denver")
      location.latitude = "39.73915"
      location.longitude = "-104.9847"
      expect(location.get_forecast_endpoint).to eq("https://api.weather.gov/gridpoints/BOU/63,61/forecast/hourly")
    end  
  end

  describe "#get_forecast_data" do
    it "gets current weather data" do
      location = LocationData.new("Denver")
      location.forecast_url = "https://api.weather.gov/gridpoints/BOU/63,61/forecast/hourly"
      expect(location.get_forecast_data["temperature"]).to be_instance_of(Integer)
      expect(location.get_forecast_data["shortForecast"]).to be_instance_of(String)
    end  
  end

  describe "#get_forecast_by_location" do
    it "assign all required values to Location object" do
      location = LocationData.new("Denver")
      location.get_forecast_by_location
      expect(location.latitude).to eq 39.73915
      expect(location.longitude).to eq -104.9847
      expect(location.forecast_url).to eq("https://api.weather.gov/gridpoints/BOU/63,61/forecast/hourly")
      expect(location.temperature).to be_instance_of(Integer)
      expect(location.details).to be_instance_of(String)
    end
  end
end
