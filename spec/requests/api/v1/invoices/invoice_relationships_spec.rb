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

    it "returns a collection of associated items" do
      invoice = create(:invoice)
      items_set_1 = create_list(:item, 3)
      items_set_2 = create_list(:item, 3)

      items_set_1.each do |item|
        create(:invoice_item, item: item, invoice: invoice)
      end

      get "/api/v1/invoices/#{invoice.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)['data']

      expect(items.count).to eq(3)

      items.each do |item|
        expect(item['attributes'].keys).to match_array(['id', 'name', 'description', 'unit_price', 'merchant_id'])
        expect(item["type"]).to eq('item')
      end

      expect(items.first['attributes']['id']).to eq(Item.first.id)
      expect(items[1]['attributes']['id']).to eq(Item.all[1].id)
      expect(items.last['attributes']['id']).to eq(Item.all[2].id)
    end

    it "returns the associated customer" do
      create_list(:customer, 3)
      customer = Customer.first
      invoice = create(:invoice, customer: customer)

      get "/api/v1/invoices/#{invoice.id}/customer"

      expect(response).to be_successful

      found_customer = JSON.parse(response.body)['data']

      expect(found_customer['attributes'].keys).to match_array(['id', 'first_name', 'last_name'])
      expect(found_customer["type"]).to eq('customer')


      expect(found_customer['attributes']['id']).to eq(customer.id)
    end

    it "returns the associated merchant" do
      create_list(:merchant, 3)
      merchant = Merchant.first
      invoice = create(:invoice, merchant: merchant)

      get "/api/v1/invoices/#{invoice.id}/merchant"

      expect(response).to be_successful

      found_merchant = JSON.parse(response.body)['data']

      expect(found_merchant['attributes'].keys).to match_array(['id', 'name'])
      expect(found_merchant["type"]).to eq('merchant')


      expect(found_merchant['attributes']['id']).to eq(merchant.id)
    end
  end
end
