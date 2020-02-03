require 'rails_helper'

describe "Merchants API" do
  describe "business logic" do
    it "returns the top 'x' merchants ranked by total revenue" do
      create_list(:merchant, 5)
      create_list(:item, 5, unit_price: 300, merchant: Merchant.first)
      create_list(:item, 5, unit_price: 400, merchant: Merchant.all[1])
      create_list(:item, 5, unit_price: 100, merchant: Merchant.all[2])
      create_list(:item, 5, unit_price: 600, merchant: Merchant.all[3])
      create_list(:item, 5, unit_price: 200, merchant: Merchant.all[4])

      merchants = Merchant.all

      merchants.each do |merchant|
        invoice = create(:invoice, merchant: merchant)
        create(:transaction, invoice: invoice)
        items = merchant.items
        items.each do |item|
          item.invoice_items.create!(quantity: 10, unit_price: item.unit_price,invoice: invoice)
        end
      end

      x = 1
      get "/api/v1/merchants/most_revenue?quantity=#{x}"

      expect(response).to be_successful
      merchants = JSON.parse(response.body)['data']
      expect(merchants.count).to eq(1)
      expect(merchants.first['attributes']['id']).to eq(Merchant.all[3].id)

      y = 5
      get "/api/v1/merchants/most_revenue?quantity=#{y}"

      expect(response).to be_successful
      merchants = JSON.parse(response.body)['data']
      expect(merchants.count).to eq(5)
      expect(merchants.first['attributes']['id']).to eq(Merchant.all[3].id)
      expect(merchants.last['attributes']['id']).to eq(Merchant.all[2].id)
    end

    it "returns the total revenue for date 'x' across all merchants" do
      merchants = create_list(:merchant, 3)

      merchants.each do |merchant|
        items = create_list(:item, 3, unit_price: 37557, merchant: merchant)
        invoice = create(:invoice, merchant: merchant, created_at: "2012-03-16")
        create(:transaction, invoice: invoice)
        items.each do |item|
          item.invoice_items.create!(quantity: 2, unit_price: item.unit_price, invoice: invoice)
        end
      end

      day_1 = Invoice.first.created_at

      get "/api/v1/merchants/revenue?date=#{day_1}"

      expect(response).to be_successful

      date_1_total_revenue = JSON.parse(body)['data']

      expect(date_1_total_revenue['attributes']['total_revenue']).to eq("6760.26")
    end

    it "returns the customer who has conducted the hightest total number of successful transactions" do
      merchant = create(:merchant)
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)

      invoice_1 = create(:invoice, merchant: merchant, customer: customer_1)
      invoice_2 = create(:invoice, merchant: merchant, customer: customer_2)
      invoice_3 = create(:invoice, merchant: merchant, customer: customer_3)

      create_list(:transaction, 1, result: 'success', invoice: invoice_1)
      create_list(:transaction, 10, result: 'failed', invoice: invoice_2)
      create_list(:transaction, 5, result: 'success', invoice: invoice_3)

      get "/api/v1/merchants/#{merchant.id}/favorite_customer"

      expect(response).to be_successful

      customer = JSON.parse(response.body)['data']

      expect(customer['type']).to eq('customer')
      expect(customer['attributes']['id']).to eq(customer_3.id)
      expect(customer['attributes']['first_name']).to eq(customer_3.first_name)
      expect(customer['attributes']['last_name']).to eq(customer_3.last_name)
    end
  end
end
