require 'rails_helper'

describe "Items API" do
  describe "relationships" do
    it "returns a collection of associated invoice items" do
      item = create(:item)
      create_list(:invoice_item, 3, item: item)

      get "/api/v1/items/#{item.id}/invoice_items"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)['data']

      expect(invoice_items.count).to eq(3)

      invoice_items.each do |invoice_item|
        expect(invoice_item["attributes"].keys).to match_array(["id", "quantity", "item_id", "unit_price", "invoice_id"])
        expect(invoice_item["attributes"]["item_id"]).to eq(item.id)
      end
    end

    it "returns the associated merchant" do
      merchant = create(:merchant)
      merchant_2 = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      returned_merchant = JSON.parse(response.body)['data']

      expect(returned_merchant['type']).to eq('merchant')
      expect(returned_merchant["attributes"].keys).to eq(["id", "name"])
      expect(returned_merchant["attributes"]["id"]).to eq(merchant.id)
      expect(returned_merchant["attributes"]["name"]).to eq(merchant.name)
    end
  end
end 
