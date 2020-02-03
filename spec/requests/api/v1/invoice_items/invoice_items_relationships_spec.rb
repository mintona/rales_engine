require 'rails_helper'

RSpec.describe "Invoice Items API" do
  describe "relationships" do
    it "returns the associated invoice" do
      invoice = create(:invoice)
      create_list(:invoice, 2)

      invoice_item = create(:invoice_item, invoice: invoice)

      get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

      expect(response).to be_successful

      returned_invoice = JSON.parse(response.body)['data']

      expect(returned_invoice["type"]).to eq('invoice')
      expect(returned_invoice["attributes"].keys).to match_array(["id", "customer_id", "merchant_id", "status"])
      expect(returned_invoice['attributes']['id']).to eq(invoice.id)
    end

    it "returns the associated item" do
      item = create(:item)
      create_list(:item, 2)
      invoice_item = create(:invoice_item, item: item)

      get "/api/v1/invoice_items/#{invoice_item.id}/item"

      expect(response).to be_successful

      returned_item = JSON.parse(response.body)['data']

      expect(returned_item["type"]).to eq('item')
      expect(returned_item["attributes"].keys).to match_array(["id", "description", "merchant_id", "name", "unit_price"])
      expect(returned_item["attributes"]["id"]).to eq(item.id)
    end
  end
end
