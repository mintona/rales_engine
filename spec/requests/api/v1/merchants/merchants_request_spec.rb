require 'rails_helper'

describe "Merchants API" do
  describe "record endpoints" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body)['data']

      expect(merchants.count).to eq(3)
      expect(merchants.first.keys).to eq(["id", "type", "attributes", "relationships"])
    end

    it "can get one merchant by its id" do
      id = create(:merchant).id.to_s

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(merchant["id"]).to eq(id)
    end
  end
end
