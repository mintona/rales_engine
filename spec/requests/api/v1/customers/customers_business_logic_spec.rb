require 'rails_helper'

describe 'Customers API' do
  describe "business logic" do
     # GET /api/v1/customers/:id/favorite_merchant: returns a merchant where the customer has conducted the most successful transactions
    it "returns a merchant where the customer has conducted the most successful transactions" do
      customer = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_1_items = create_list(:item, 3, unit_price: 100, merchant: merchant_1)
      merchant_2_items = create_list(:item, 4, unit_price: 100, merchant: merchant_2)
      #
      # create(:item, unit_price: 300)
      # create(:item, unit_price: 400)
      # item_3 = create(:item, unit_price: 100)
      # item_4 = create(:item, unit_price: 600)
      # create(:item, unit_price: 200)
      # item_6 = create(:item, unit_price: 1000)
      #
      # items = Item.all

      merchant_1_items.each do |item|
        invoice = create(:invoice, merchant: item.merchant)
        create(:transaction, result: "success", invoice: invoice)
        item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice)
      end

      merchant_2_items.each do |item|
        invoice = create(:invoice, merchant: item.merchant)
        create(:transaction, result: "failed", invoice: invoice)
        item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice)
      end

      get "/api/v1/customers/:id/favorite_merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body)['data']

      # expect(items.count).to eq(1)
      expect(merchant['type']).to eq('merchant')
      expect(merchant['attributes']['id']).to eq(merchant_1.id)

      # y = 5
      # get "/api/v1/items/most_revenue?quantity=#{y}"
      #
      # expect(response).to be_successful
      # items = JSON.parse(response.body)['data']
      # expect(items.count).to eq(5)
      # expect(items.first['attributes']['id']).to eq(item_4.id)
      # expect(items.last['attributes']['id']).to eq(item_3.id)
    end
   end
end
