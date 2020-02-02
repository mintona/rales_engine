require 'rails_helper'

RSpec.describe "Invoices API" do
  describe "relationships" do
    it "returns a collection of associated transactions" do
      invoice = create(:invoice)
      transactions = create_list(:transaction, 3, invoice: invoice)

      get "/api/v1/invoices/#{invoice.id}/transactions"

      expect(response).to be_successful

      transactions = JSON.parse(response.body)['data']

      expect(transactions.count).to eq(3)

      transactions.each do |transaction|
        expect(transaction["attributes"].keys).to match_array(["id", "credit_card_number", "result", "invoice_id"])
        expect(transaction["type"]).to eq('transaction')
      end

      expect(transactions.first['attributes']['credit_card_number']).to eq(Transaction.first.credit_card_number.to_s)
    end

    it "returns a collection of associated invoice_items" do
      invoice = create(:invoice)
      create_list(:invoice_item, 3, invoice: invoice)

      get "/api/v1/invoices/#{invoice.id}/invoice_items"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)['data']

      expect(invoice_items.count).to eq(3)

      invoice_items.each do |invoice_item|
        expect(invoice_item["attributes"].keys).to match_array(["id", "quantity", "unit_price", "item_id", "invoice_id"])
        expect(invoice_item["attributes"]["invoice_id"]).to eq(invoice.id)
      end
    end

    it "returns a collection of associated items" do
      invoice = create(:invoice)
      items = create_list(:item, 3)
      items.each do |item|
        create(:invoice_item, item: item)
      end

      get "/api/v1/invoices/#{invoice.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)['data']

      expect(items.count).to eq(3)

      items.each do |item|
        expect(item['attributes'].keys).to match_array(['id', 'name', 'description', 'unit_price', 'merchant_id'])
        expect(item["type"]).to eq('item')
      end

      expect(items.first['attributes']['id']).to eq(Item.first.id)
    end

  end
end
