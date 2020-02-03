require "rails_helper"

RSpec.describe "Merchants API" do
  describe "relationships" do
    it "sends a list of items associated with a merchant" do
      merchant = create(:merchant)
      create_list(:item, 3, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)['data']

      expect(items.count).to eq(3)

      items.each do |item|
        expect(item["attributes"].keys).to match_array(["id", "name", "description", "unit_price", "merchant_id"])
        expect(item["attributes"]["merchant_id"]).to eq(merchant.id)
      end
    end

    it "sends a list of invoices associated with a merchant" do
      merchant = create(:merchant)
      create_list(:invoice, 3, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/invoices"

      expect(response).to be_successful

      invoices = JSON.parse(response.body)['data']

      expect(invoices.count).to eq(3)

      invoices.each do |invoice|
        expect(invoice["attributes"].keys).to eq(["id", "customer_id", "merchant_id", "status"])
        expect(invoice["attributes"]["merchant_id"]).to eq(merchant.id)
      end
    end
  end
end
