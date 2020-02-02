require 'rails_helper'

RSpec.describe "Invoice Items API" do
  describe "relationships" do
    it "returns the associated invoice" do
      invoice = create(:invoice)
      create_list(:invoice, 2)

      invoice_item = create(:invoice_item, invoice: invoice)

      get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)['data']

      expect(invoice["type"]).to eq('invoice')
      expect(invoice["attributes"].keys).to match_array(["id", "credit_card_number", "result", "invoice_id"])
      expect(invoice['attributes']['id']).to eq(invoice.id)
      # expect(transactions.first['attributes']['credit_card_number']).to eq(Transaction.first.credit_card_number.to_s)
    end

    xit "returns the associated item" do
      # invoice_item = create(:invoice_item)
      # create_list(:invoice_item, 3, invoice_item: invoice_item)

      get "/api/v1/invoice_items/#{invoice_item.id}/item"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)['data']

      expect(invoice_items.count).to eq(3)

      invoice_items.each do |invoice_item|
        expect(invoice_item["attributes"].keys).to match_array(["id", "quantity", "unit_price", "item_id", "invoice_id"])
        expect(invoice_item["attributes"]["invoice_id"]).to eq(invoice_item.id)
      end
    end
  end
end
