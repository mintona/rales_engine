require 'rails_helper'

RSpec.describe "Customers API" do
  describe "relationships" do
    it "returns a collection of associated invoices" do
      customer = create(:customer)
      create_list(:invoice, 3, customer: customer)

      get "/api/v1/customers/#{customer.id}/invoices"

      expect(response).to be_successful

      invoices = JSON.parse(response.body)['data']

      expect(invoices.count).to eq(3)

      invoices.each do |invoice|
        expect(invoice["attributes"].keys).to match_array(["id", "merchant_id", "customer_id", "status"])
        expect(invoice["attributes"]["customer_id"]).to eq(customer.id)
      end
    end

    it "returns a collection of associated transactions" do
      customer = create(:customer)
      invoice = create(:invoice, customer: customer)
      transactions = create_list(:transaction, 3, invoice: invoice)

      get "/api/v1/customers/#{customer.id}/transactions"

      expect(response).to be_successful

      transactions = JSON.parse(response.body)['data']

      expect(transactions.count).to eq(3)

      transactions.each do |transaction|
        expect(transaction["attributes"].keys).to match_array(["id", "credit_card_number", "result", "invoice_id"])
        expect(transaction["type"]).to eq('transaction')
      end

      expect(transactions.first['attributes']['credit_card_number']).to eq(Transaction.first.credit_card_number.to_s)
    end
  end
end
