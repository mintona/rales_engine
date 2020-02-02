require 'rails_helper'

describe "Customers API" do
  describe "record endpoints" do
    it "sends a list of customers" do
      create_list(:customer, 3)

      get '/api/v1/customers'

      expect(response).to be_successful

      customers = JSON.parse(response.body)['data']

      expect(customers.count).to eq(3)
      expect(customers.first.keys).to eq(["id", "type", "attributes"])
      expect(customers.first['attributes'].keys).to match_array(['id', 'first_name', 'last_name'])
    end

    it "can get one customer by its id" do
      customer = create(:customer)

      get "/api/v1/customers/#{customer.id}"

      expect(response).to be_successful

      found_customer = JSON.parse(response.body)['data']

      expect(found_customer['attributes']['id']).to eq(customer.id)
      expect(found_customer['attributes']['first_name']).to eq(customer.first_name)
      expect(found_customer['attributes']['last_name']).to eq(customer.last_name)
    end
  end
end
