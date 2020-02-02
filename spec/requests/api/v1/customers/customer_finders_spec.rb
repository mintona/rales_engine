require 'rails_helper'

RSpec.describe "Customers API" do
  describe "finders" do
    describe "single finders" do
      describe "can get one item by any attribute:" do
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

        xit "created_at" do
          date = @customer.created_at.to_s

          get "/api/v1/customers/find?created_at=#{date}"

          customer = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(customer['attributes']['id']).to eq(@customer.id)
        end

        xit "updated_at" do
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
          @item_1 = create(:item, created_at: "19-12-05", updated_at: "20-02-04")
          @item_2 = create(:item, created_at: "19-12-25", updated_at: "20-03-05")
          @item_3 = create(:item, merchant: @item_2.merchant, created_at: "19-12-25", updated_at: "20-02-04")
          @item_4 = create(:item, name: @item_3.name, description: @item_3.description, created_at: "20-1-30", updated_at: "20-03-05")
        end

        xit "find all by id" do
          get "/api/v1/customers/find_all?id=#{@item_1.id}"

          expect(response).to be_successful

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(1)

          expect(customers.first['attributes']['id']).to eq(@item_1.id)
        end

        xit "find all by merchant_id" do
          get "/api/v1/customers/find_all?merchant_id=#{@item_1.merchant_id}"

          expect(response).to be_successful

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(1)

          expect(customers.first['attributes']['id']).to eq(@item_1.id)

          get "/api/v1/customers/find_all?merchant_id=#{@item_2.merchant_id}"

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@item_2.id)
          expect(customers.last['attributes']['id']).to eq(@item_3.id)
        end

        xit "find all by name" do
          item_1_names = [@item_1.name, @item_1.name.upcase, @item_1.name.downcase]

          item_1_names.each do |name|
            get "/api/v1/customers/find_all?name=#{name}"
            expect(response).to be_successful
            customers = JSON.parse(response.body)['data']
            expect(customers.count).to eq(1)
            expect(customers.first['attributes']['id']).to eq(@item_1.id)
          end

          name_2 = @item_3.name

          get "/api/v1/customers/find_all?name=#{name_2}"

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@item_3.id)
          expect(customers.last['attributes']['id']).to eq(@item_4.id)
        end

        xit "find all by description" do
          item_1_descriptions = [@item_1.description, @item_1.description.upcase, @item_1.description.downcase]

          item_1_descriptions.each do |description|
            get "/api/v1/customers/find_all?description=#{description}"
            expect(response).to be_successful
            customers = JSON.parse(response.body)['data']
            expect(customers.count).to eq(1)
            expect(customers.first['attributes']['id']).to eq(@item_1.id)
          end

          description_2 = @item_3.description

          get "/api/v1/customers/find_all?description=#{description_2}"

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@item_3.id)
          expect(customers.last['attributes']['id']).to eq(@item_4.id)
        end

        xit "find all by created_at" do
          date_1 = @item_1.created_at

          get "/api/v1/customers/find_all?created_at=#{date_1}"

          expect(response).to be_successful

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(1)

          expect(customers.first['attributes']['id']).to eq(@item_1.id)

          date_2 = @item_2.created_at

          get "/api/v1/customers/find_all?created_at=#{date_2}"

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@item_2.id)
          expect(customers.last['attributes']['id']).to eq(@item_3.id)
        end

        xit "find all by updated_at" do
          date_1 = @item_1.updated_at

          get "/api/v1/customers/find_all?updated_at=#{date_1}"

          expect(response).to be_successful

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@item_1.id)
          expect(customers.last['attributes']['id']).to eq(@item_3.id)

          date_2 = @item_2.updated_at

          get "/api/v1/customers/find_all?updated_at=#{date_2}"

          customers = JSON.parse(response.body)['data']

          expect(customers.count).to eq(2)

          expect(customers.first['attributes']['id']).to eq(@item_2.id)
          expect(customers.last['attributes']['id']).to eq(@item_4.id)
        end
      end
    end

    describe "random" do
      xit "returns a random item" do
        customers = create_list(:item, 10)

        get "/api/v1/customers/random"

        expect(response).to be_successful

        number_of_items = JSON.parse(response.body).count
        expect(number_of_items).to eq(1)

        random_item = JSON.parse(response.body)['data']

        expect(random_item['type']).to eq('item')
        expect(random_item['attributes'].keys).to match_array(['id', 'name', 'description', 'unit_price', 'merchant_id'])

        # could test the range instead?
        result = customers.one? { |item| item.id == random_item['attributes']['id'] }
        expect(result).to be(true)
      end
      end
    end
  end
end
