require 'rails_helper'

describe "Items API" do
  describe "business logic" do
    it "returns the top 'x' items ranked by total revenue" do
      create(:item, unit_price: 300)
      create(:item, unit_price: 400)
      item_3 = create(:item, unit_price: 100)
      item_4 = create(:item, unit_price: 600)
      create(:item, unit_price: 200)
      item_6 = create(:item, unit_price: 1000)

      items = Item.all

      items.each do |item|
        invoice = create(:invoice, merchant: item.merchant)
        if item.id == item_6.id
          create(:transaction, result: "failed", invoice: invoice)
        else
          create(:transaction, result: "success", invoice: invoice)
        end
        item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice)
      end

      x = 1
      get "/api/v1/items/most_revenue?quantity=#{x}"

      expect(response).to be_successful
      items = JSON.parse(response.body)['data']
      expect(items.count).to eq(1)
      expect(items.first['attributes']['id']).to eq(item_4.id)

      y = 5
      get "/api/v1/items/most_revenue?quantity=#{y}"

      expect(response).to be_successful
      items = JSON.parse(response.body)['data']
      expect(items.count).to eq(5)
      expect(items.first['attributes']['id']).to eq(item_4.id)
      expect(items.last['attributes']['id']).to eq(item_3.id)
    end

    it "returns the date with the most sales for the given item using the invoice date" do
      #If there are multiple days with equal number of sales, return the most recent day.
      item = create(:item, unit_price: 100)
      invoice_1 = create(:invoice, created_at: "1985-02-04")
      invoice_2 = create(:invoice, created_at: "2020-02-01")
      invoice_3 = create(:invoice, created_at: "2020-01-30")
      invoice_4 = create(:invoice, created_at: "2018-02-04")
      invoice_5 = create(:invoice, created_at: "2021-02-04")

      create(:transaction, invoice: invoice_1)
      create(:transaction, invoice: invoice_2)
      create(:transaction, invoice: invoice_3)
      create(:transaction, invoice: invoice_4)
      create(:transaction, result: 'failed', invoice: invoice_5)

      item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice_1)
      item.invoice_items.create!(quantity: 1, unit_price: item.unit_price, invoice: invoice_2)
      item.invoice_items.create!(quantity: 5, unit_price: item.unit_price, invoice: invoice_3)
      item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice_4)
      item.invoice_items.create!(quantity: 100, unit_price: item.unit_price, invoice: invoice_5)

      get "/api/v1/items/#{item.id}/best_day"

      expect(response).to be_successful

      best_day = JSON.parse(response.body)['data']

      expect(best_day['attributes']['best_day']).to eq("2018-02-04")
    end
  end
end
