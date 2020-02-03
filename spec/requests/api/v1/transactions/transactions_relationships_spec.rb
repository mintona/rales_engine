require 'rails_helper'

RSpec.describe "Transactions API" do
  describe "relationships" do
    it "returns the associated invoice" do
      invoice = create(:invoice)
      create_list(:invoice, 2)

      transaction = create(:transaction, invoice: invoice)

      get "/api/v1/transactions/#{transaction.id}/invoice"

      expect(response).to be_successful

      returned_invoice = JSON.parse(response.body)['data']

      expect(returned_invoice["type"]).to eq('invoice')
      expect(returned_invoice["attributes"].keys).to match_array(["id", "customer_id", "merchant_id", "status"])
      expect(returned_invoice['attributes']['id']).to eq(invoice.id)
    end
  end
end
