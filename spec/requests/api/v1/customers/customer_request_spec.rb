require 'rails_helper'

describe "Customers API" do
  describe "record endpoints" do
    it "sends a list of customers" do
      create_list(:customer, 3)

      get '/api/v1/customers'

      expect(response).to be_successful

      customers = JSON.parse(response.body)['data']

      expect(customers.count).to eq(3)
      expect(customers.first.keys).to eq(["id", "type", "attributes", "relationships"])
      expect(customers.first['attributes'].keys).to match_array(['id', 'first_name', 'last_name'])
      # expect(customers.first['relationships'].keys).to eq(['merchant'])
    end

    xit "can get one customer by its id" do
      customer = create(:customer)
      unit_price = (customer.unit_price / 100.to_f).to_s

      get "/api/v1/customers/#{customer.id}"

      expect(response).to be_successful

      found_customer = JSON.parse(response.body)['data']

      expect(found_customer['attributes']['id']).to eq(customer.id)
      expect(found_customer['attributes']['name']).to eq(customer.name)
      expect(found_customer['attributes']['description']).to eq(customer.description)
      expect(found_customer['attributes']['unit_price']).to eq(unit_price)
      expect(found_customer['attributes']['merchant_id']).to eq(customer.merchant_id)

      expect(found_customer['relationships']).to have_key('merchant')
    end
  end
end
