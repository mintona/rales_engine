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

  end
end
