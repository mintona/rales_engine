require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)['data']

    expect(merchants.count).to eq(3)
    expect(merchants.first.keys).to eq(["id", "type", "attributes"])
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id.to_s

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)['data']

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  describe "can get one merchant by any attribute:" do
    before :each do
      @merchant = create(:merchant)
    end

    it "find by id" do
      get "/api/v1/merchants/find?id=#{@merchant.id}"

      merchant = JSON.parse(response.body)['data']
      expect(response).to be_successful

      expect(merchant['attributes']['id']).to eq(@merchant.id)
    end

    it "name" do
      get "/api/v1/merchants/find?name=#{@merchant.name}"

      merchant = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(merchant['attributes']['name']).to eq(@merchant.name)
    end

    xit "created_at" do
      get "/api/v1/merchants/find?created_at=#{@merchant.created_at}"
      merchant = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(merchant['attributes']['name']).to eq(@merchant.name)
    end

    xit "updated_at" do
      get "/api/v1/merchants/find?updated_at=#{@merchant.updated_at}"

    end
  end
end
