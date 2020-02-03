require 'rails_helper'

describe "Items API" do
  describe "record endpoints" do
    it "sends a list of items" do
      create_list(:item, 3)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body)['data']

      expect(items.count).to eq(3)
      expect(items.first.keys).to eq(["id", "type", "attributes", "relationships"])
      expect(items.first['attributes'].keys).to match_array(['id', 'name', 'description', 'unit_price', 'merchant_id'])
      expect(items.first['relationships'].keys).to eq(['merchant'])
    end

    it "can get one item by its id" do
      item = create(:item)
      unit_price = (item.unit_price / 100.to_f).to_s

      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful

      found_item = JSON.parse(response.body)['data']

      expect(found_item['attributes']['id']).to eq(item.id)
      expect(found_item['attributes']['name']).to eq(item.name)
      expect(found_item['attributes']['description']).to eq(item.description)
      expect(found_item['attributes']['unit_price']).to eq(unit_price)
      expect(found_item['attributes']['merchant_id']).to eq(item.merchant_id)

      expect(found_item['relationships']).to have_key('merchant')
    end
  end
end 
