require 'rails_helper' 
RSpec.describe ApplicationController, type: :controller do 

  describe 'POST #get_forecast' do 
    context 'with valid location: name' do
      it 'retrieves data for Denver' do 
        post :get_forecast, :params => { location: "Denver"}
        expect(response.status).to eq(200)
        expect(response.content_type).to eq "application/json; charset=utf-8"
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["forecast"]["temp"]).to be_instance_of(Integer)
      end 
    end
  describe 'POST #get_forecast' do 
    context 'with valid location: zip code' do
      it 'retrieves data for 78747' do 
        post :get_forecast, :params => { location: "78747"}
        expect(response.status).to eq(200)
        expect(response.content_type).to eq "blop"
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["forecast"]["temp"]).to be_instance_of(Integer)
      end 
    end
  end
  describe 'POST #get_forecast' do 
    it 'returns error for invalid location string' do
        post :get_forecast, :params => { location: "kjfksjlfs"}
        expect(response.status).to eq(200)
        expect(response.content_type).to eq "application/json; charset=utf-8"
        parsed_body = JSON.parse(response.body)    
        expect(parsed_body["error"]).to be true  
    end 
  end
    #  context 'with invalid location: zip code' do
    #     it 'retrieves data for 78747 from cache' do 
    #       post :get_forecast, :params => { location: "78747"}
    #       expect(response.status).to eq(200)
    #       expect(response.content_type).to eq "application/json; charset=utf-8"
    #       parsed_body = JSON.parse(response.body)
    #       expect(parsed_body["forecast"]["temp"]).to be_instance_of(Integer)
    #       expect(parsed_body["cached"]).to be true
    #     end
      
    #   end 
    # end
  end 

end 