require 'rails_helper' 

RSpec.describe ApplicationHelper, type: :helper do
  describe "#get_coords" do
    it "gets coordinates for location by city name" do
      location_string = "Denver"
      expect(helper.get_coords(location_string)).to eq([39.73915,-104.9847])
    end
  end

  describe "#get_forecast_endpoint" do
    it "gets endpoint for forecast data by coordinates" do
      lat = "39.73915"
      long = "-104.9847"
      expect(helper.get_forecast_endpoint(lat,long)).to eq("https://api.weather.gov/gridpoints/BOU/63,61/forecast/hourly")
    end  
  end

  describe "#get_forecast_data" do
    it "gets current weather data" do
      data_endpoint = "https://api.weather.gov/gridpoints/BOU/63,61/forecast/hourly"
      expect(helper.get_forecast_data(data_endpoint)["temperature"]).to be_instance_of(Integer)
    end  
  end

end