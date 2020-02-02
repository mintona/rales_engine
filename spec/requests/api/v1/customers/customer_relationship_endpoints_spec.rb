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

    xit "returns a collection of associated transactions" do
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
