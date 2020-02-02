require 'rails_helper'

RSpec.describe "Customers API" do
  describe "finders" do
    describe "single finders" do
      describe "can get one customer by any attribute:" do
        before :each do
          @customer = create(:customer, created_at: "2020-01-30", updated_at: "2020-01-31")
          create_list(:customer, 2)
        end

        it "id" do
          get "/api/v1/customers/find?id=#{@customer.id}"

          customer = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(customer['attributes']['id']).to eq(@customer.id)
        end

        it "first_name" do
          customer_1_names = [@customer.first_name, @customer.first_name.upcase, @customer.first_name.downcase]

          customer_1_names.each do |first_name|
            get "/api/v1/customers/find?first_name=#{first_name}"

            customer = JSON.parse(response.body)['data']

            expect(response).to be_successful
            expect(customer['attributes']['id']).to eq(@customer.id)
          end
        end

        it "find by last_name" do
          customer_1_last_names = [@customer.last_name, @customer.last_name.upcase, @customer.last_name.downcase]

          get "/api/v1/customers/find?last_name=#{@customer.last_name}"

          customer_1_last_names.each do |last_name|
            get "/api/v1/customers/find?last_name=#{last_name}"

            customer = JSON.parse(response.body)['data']

            expect(response).to be_successful
            expect(customer['attributes']['id']).to eq(@customer.id)
          end
        end

        it "created_at" do
          date = @customer.created_at.to_s

          get "/api/v1/customers/find?created_at=#{date}"

          customer = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(customer['attributes']['id']).to eq(@customer.id)
        end

        it "updated_at" do
          date = @customer.updated_at.to_s

          get "/api/v1/customers/find?updated_at=#{date}"

          customer = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(customer['attributes']['id']).to eq(@customer.id)
        end
      end

    describe "multi-finders" do
      describe "return all matches by any attribute" do
        before :each do
          @customer_1 = create(:customer, created_at: "19-12-05", updated_at: "20-02-04")
          @customer_2 = create(:customer, created_at: "19-12-25", updated_at: "20-03-05")
          @customer_3 = create(:customer, created_at: "19-12-25", updated_at: "20-02-04")
          @customer_4 = create(:customer, first_name: @customer_3.first_name, last_name: @customer_3.last_name, created_at: "20-1-30", updated_at: "20-03-05")
        end

        it "find all by id" do
          get "/api/v1/customers/find_all?id=#{@customer_1.id}"

          expect(response).to be_successful

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(1)

          expect(customers.first['attributes']['id']).to eq(@customer_1.id)
        end

        it "find all by first_name" do
          customer_1_first_names = [@customer_1.first_name, @customer_1.first_name.upcase, @customer_1.first_name.downcase]

          customer_1_first_names.each do |first_name|
            get "/api/v1/customers/find_all?first_name=#{first_name}"
            expect(response).to be_successful
            customers = JSON.parse(response.body)['data']
            expect(customers.count).to eq(1)
            expect(customers.first['attributes']['id']).to eq(@customer_1.id)
          end

          name_2 = @customer_3.first_name

          get "/api/v1/customers/find_all?first_name=#{name_2}"

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@customer_3.id)
          expect(customers.last['attributes']['id']).to eq(@customer_4.id)
        end

        it "find all by last_name" do
          customer_1_last_names = [@customer_1.last_name, @customer_1.last_name.upcase, @customer_1.last_name.downcase]

          customer_1_last_names.each do |last_name|
            get "/api/v1/customers/find_all?last_name=#{last_name}"
            expect(response).to be_successful
            customers = JSON.parse(response.body)['data']
            expect(customers.count).to eq(1)
            expect(customers.first['attributes']['id']).to eq(@customer_1.id)
          end

          last_name_2 = @customer_3.last_name

          get "/api/v1/customers/find_all?last_name=#{last_name_2}"

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@customer_3.id)
          expect(customers.last['attributes']['id']).to eq(@customer_4.id)
        end

        it "find all by created_at" do
          date_1 = @customer_1.created_at

          get "/api/v1/customers/find_all?created_at=#{date_1}"

          expect(response).to be_successful

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(1)

          expect(customers.first['attributes']['id']).to eq(@customer_1.id)

          date_2 = @customer_2.created_at

          get "/api/v1/customers/find_all?created_at=#{date_2}"

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@customer_2.id)
          expect(customers.last['attributes']['id']).to eq(@customer_3.id)
        end

        it "find all by updated_at" do
          date_1 = @customer_1.updated_at

          get "/api/v1/customers/find_all?updated_at=#{date_1}"

          expect(response).to be_successful

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@customer_1.id)
          expect(customers.last['attributes']['id']).to eq(@customer_3.id)

          date_2 = @customer_2.updated_at

          get "/api/v1/customers/find_all?updated_at=#{date_2}"

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@customer_2.id)
          expect(customers.last['attributes']['id']).to eq(@customer_4.id)
        end
      end
    end

    describe "random" do
      it "returns a random customer" do
        customers = create_list(:customer, 10)

        get "/api/v1/customers/random"

        expect(response).to be_successful

        number_of_customers = JSON.parse(response.body).count
        expect(number_of_customers).to eq(1)

        random_customer = JSON.parse(response.body)['data']

        expect(random_customer['type']).to eq('customer')
        expect(random_customer['attributes'].keys).to match_array(['id', 'first_name', 'last_name'])

        # could test the range instead?
        result = customers.one? { |customer| customer.id == random_customer['attributes']['id'] }
        expect(result).to be(true)
      end
      end
    end
  end
end
