require 'rails_helper'

describe "Invoice Items API" do
  describe "record endpoints" do
    it "sends a list of invoice_items" do
      create_list(:invoice_item, 3)

      get '/api/v1/invoice_items'

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)['data']

      expect(invoice_items.count).to eq(3)
      expect(invoice_items.first.keys).to eq(["id", "type", "attributes"])
      expect(invoice_items.first['attributes'].keys).to match_array(['id', 'quantity', 'unit_price', 'item_id', 'invoice_id'])
    end

    it "can get one item by its id" do
      invoice_item = create(:invoice_item)
      unit_price = (invoice_item.unit_price / 100.to_f).to_s

      get "/api/v1/invoice_items/#{invoice_item.id}"

      expect(response).to be_successful

      found_invoice_item = JSON.parse(response.body)['data']

      expect(found_invoice_item['attributes']['id']).to eq(invoice_item.id)
      expect(found_invoice_item['attributes']['quantity']).to eq(invoice_item.quantity)
      expect(found_invoice_item['attributes']['item_id']).to eq(invoice_item.item_id)
      expect(found_invoice_item['attributes']['unit_price']).to eq(unit_price)
      expect(found_invoice_item['attributes']['invoice_id']).to eq(invoice_item.invoice_id)
    end
  end
end
