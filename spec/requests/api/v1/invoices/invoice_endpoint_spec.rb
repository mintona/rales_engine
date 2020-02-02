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

    xit "can get one invoice by its id" do
      invoice = create(:invoice)

      get "/api/v1/invoices/#{invoice.id}"

      expect(response).to be_successful

      found_invoice = JSON.parse(response.body)['data']

      expect(found_invoice['attributes']['id']).to eq(invoice.id)
      expect(found_invoice['attributes']['first_name']).to eq(invoice.first_name)
      expect(found_invoice['attributes']['last_name']).to eq(invoice.last_name)
    end
  end
end
