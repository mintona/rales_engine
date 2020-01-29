require 'rails_helper'

describe "Merchants API" do
  describe "record endpoints" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body)['data']

      expect(merchants.count).to eq(3)
      expect(merchants.first.keys).to eq(["id", "type", "attributes", "relationships"])
    end

    it "can get one merchant by its id" do
      id = create(:merchant).id.to_s

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(merchant["id"]).to eq(id)
    end
  describe "single finders" do
    describe "can get one merchant by any attribute:" do
      before :each do
        @merchant = create(:merchant)
      end

      it "find by id" do
        get "/api/v1/merchants/find?id=#{@merchant.id}"

        merchant = JSON.parse(response.body)['data']
        expect(response).to be_successful

        expect(merchant['attributes']['id']).to eq(@merchant.id)
      end

      it "name" do
        get "/api/v1/merchants/find?name=#{@merchant.name}"

        merchant = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(merchant['attributes']['name']).to eq(@merchant.name)
      end

      xit "created_at" do
        get "/api/v1/merchants/find?created_at=#{@merchant.created_at}"
        merchant = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(merchant['attributes']['name']).to eq(@merchant.name)
      end

      xit "updated_at" do
        get "/api/v1/merchants/find?updated_at=#{@merchant.updated_at}"

      end
    end
  end

  describe "relationships" do
    it "sends a list of items associated with a merchant" do
      merchant = create(:merchant)
      create_list(:item, 3, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)['data']

      expect(items.count).to eq(3)

      items.each do |item|
        expect(item["attributes"].keys).to eq(["id", "name", "description", "unit_price", "merchant_id"])
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

  describe "business logic" do
    it "returns the top x merchants ranked by total revenue" do
      #add data here.

      x = 7
      get "/api/v1/merchants/most_revenue?quantity=#{x}"

      expect(response).to be_successful

      #merchants
      #limit X
      #revenue = invoice_items.unit_price * invoice_items.quantity (invoice_items has invoice_id)
      #invoice_items --> invoice_id
      #invoices --> merchant_id

#i think this works
      # SELECT merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue
      # FROM merchants
      # INNER JOIN invoices ON invoices.merchant_id = merchants.id
      # INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id
      # INNER JOIN transactions ON transactions.invoice_id = invoices.id
      # WHERE transactions.result = 'success'
      # GROUP BY merchants.id
      # ORDER BY revenue DESC
      # LIMIT 7;
      #
      # SELECT merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue
      # FROM merchants
      # INNER JOIN invoices ON invoices.merchant_id = merchants.id
      # INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id
      # INNER JOIN transactions ON transactions.invoice_id = invoices.id
      # WHERE transactions.result = 'success'
      # GROUP BY merchants.id
      # ORDER BY revenue DESC
      # LIMIT 1;

      end
    end
  end
end
#
# rales_engine_development=# SELECT merchants.*, sum(invoice_items.quantity) AS total_sold
# rales_engine_development-# FROM merchants
#
# rales_engine_development-# INNER JOIN items ON items.merchant_id = merchants.id
# rales_engine_development-# INNER JOIN invoice_items ON invoice_items.item_id = items.id
# rales_engine_development-# INNER JOIN transactions ON transactions.invoice_id = invoice_items.invoice_id
# maybe we dont need this one now? rales_engine_development-# INNER JOIN invoices ON invoice_items.invoice_id = invoices.id
