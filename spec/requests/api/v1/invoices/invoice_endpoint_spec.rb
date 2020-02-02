require 'rails_helper'

describe "Invoices API" do
  describe "record endpoints" do
    it "sends a list of invoices" do
      create_list(:invoice, 3)

      get '/api/v1/invoices'

      expect(response).to be_successful

      invoices = JSON.parse(response.body)['data']

      expect(invoices.count).to eq(3)
      expect(invoices.first.keys).to eq(["id", "type", "attributes"])
      expect(invoices.first['type']).to eq('invoice')
      expect(invoices.first['attributes'].keys).to match_array(['id', 'status', 'merchant_id', 'customer_id'])
    end

    it "can get one invoice by its id" do
      create_list(:invoice, 3)
      invoice = Invoice.first

      get "/api/v1/invoices/#{invoice.id}"

      expect(response).to be_successful

      found_invoice = JSON.parse(response.body)['data']

      expect(found_invoice['attributes']['id']).to eq(invoice.id)
      expect(found_invoice['attributes']['merchant_id']).to eq(invoice.merchant_id)
      expect(found_invoice['attributes']['customer_id']).to eq(invoice.customer_id)
      expect(found_invoice['attributes']['status']).to eq(invoice.status)
    end
  end
end
