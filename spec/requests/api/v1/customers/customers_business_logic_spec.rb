require 'rails_helper'

describe 'Customers API' do
  describe "business logic" do
    it "returns a merchant where the customer has conducted the most successful transactions" do
      customer = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_1_items = create_list(:item, 3, unit_price: 100, merchant: merchant_1)
      merchant_2_items = create_list(:item, 4, unit_price: 100, merchant: merchant_2)

      merchant_1_items.each do |item|
        invoice = create(:invoice, merchant: item.merchant, customer: customer)
        create(:transaction, result: "success", invoice: invoice)
        item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice)
      end

      merchant_2_items.each do |item|
        invoice = create(:invoice, merchant: item.merchant, customer: customer)
        create(:transaction, result: "failed", invoice: invoice)
        item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice)
      end

      get "/api/v1/customers/#{customer.id}/favorite_merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body)['data']

      expect(merchant['type']).to eq('merchant')
      expect(merchant['attributes']['id']).to eq(merchant_1.id)
    end
   end
end
