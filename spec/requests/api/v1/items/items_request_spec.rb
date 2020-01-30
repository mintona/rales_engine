require 'rails_helper'

describe "Items API" do
  describe "record endpoints" do
    it "sends a list of items" do
      create_list(:item, 3)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body)['data']

      expect(items.count).to eq(3)
      expect(items.first.keys).to eq(["id", "type", "attributes", "relationships"])
      expect(items.first['attributes'].keys).to match_array(['id', 'name', 'description', 'unit_price', 'merchant_id'])
      expect(items.first['relationships'].keys).to eq(['merchant'])
    end

    it "can get one item by its id" do
      item = create(:item)
      unit_price = (item.unit_price / 100.to_f).to_s

      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful

      found_item = JSON.parse(response.body)['data']

      expect(found_item['attributes']['id']).to eq(item.id)
      expect(found_item['attributes']['name']).to eq(item.name)
      expect(found_item['attributes']['description']).to eq(item.description)
      expect(found_item['attributes']['unit_price']).to eq(unit_price)
      expect(found_item['attributes']['merchant_id']).to eq(item.merchant_id)

      expect(found_item['relationships']).to have_key('merchant')
    end
  end

  describe "single finders" do
    describe "can get one item by any attribute:" do
      before :each do
        @item = create(:item, unit_price: 27409, created_at: "2020-01-30", updated_at: "2020-01-31")
        create_list(:item, 2)
      end

      it "id" do
        get "/api/v1/items/find?id=#{@item.id}"

        item = JSON.parse(response.body)['data']
        expect(response).to be_successful

        expect(item['attributes']['id']).to eq(@item.id)
      end

      it "name" do
        item_1_names = [@item.name, @item.name.upcase, @item.name.downcase]

        item_1_names.each do |name|
          get "/api/v1/items/find?name=#{name}"

          item = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(item['attributes']['id']).to eq(@item.id)
        end
      end

      it "find by description" do
        item_1_descriptions = [@item.description, @item.description.upcase, @item.description.downcase]

        get "/api/v1/items/find?description=#{@item.description}"

        item_1_descriptions.each do |description|
          get "/api/v1/items/find?description=#{description}"

          item = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(item['attributes']['id']).to eq(@item.id)
        end
      end

      it "find by unit_price" do
        unit_price = "274.09"
        get "/api/v1/items/find?unit_price=#{unit_price}"

        item = JSON.parse(response.body)['data']
        expect(response).to be_successful

        expect(item['attributes']['id']).to eq(@item.id)

        get "/api/v1/items/find?unit_price=#{@item.unit_price}"

        item = JSON.parse(response.body)['data']
        expect(response).to be_successful

        expect(item['attributes']['id']).to eq(@item.id)


      end

      xit "created_at" do
        date = @merchant.created_at.to_s

        get "/api/v1/items/find?created_at=#{date}"

        merchant = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(merchant['attributes']['id']).to eq(@merchant.id)
      end

      xit "updated_at" do
        date = @merchant.updated_at.to_s

        get "/api/v1/items/find?updated_at=#{date}"
        merchant = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(merchant['attributes']['id']).to eq(@merchant.id)
      end
    end

  describe "multi-finders" do
    describe "return all matches by any attribute" do
      before :each do
        @merchant_1 = create(:merchant, created_at: "19-12-05", updated_at: "20-02-04")
        @merchant_2 = create(:merchant, created_at: "19-12-25", updated_at: "20-03-05")
        @merchant_3 = create(:merchant, created_at: "19-12-25", updated_at: "20-02-04")
        @merchant_4 = create(:merchant, name: @merchant_3.name, created_at: "20-1-30", updated_at: "20-03-05")
      end

      xit "find all by id" do
        get "/api/v1/items/find_all?id=#{@merchant_1.id}"

        expect(response).to be_successful

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(1)

        expect(items.first['attributes']['id']).to eq(@merchant_1.id)        #expect 1 response
      end

      xit "find all by name" do
        merchant_1_names = [@merchant_1.name, @merchant_1.name.upcase, @merchant_1.name.downcase]

        merchant_1_names.each do |name|
          get "/api/v1/items/find_all?name=#{name}"
          expect(response).to be_successful
          items = JSON.parse(response.body)['data']
          expect(items.count).to eq(1)
          expect(items.first['attributes']['id']).to eq(@merchant_1.id)
        end

        name_2 = @merchant_3.name

        get "/api/v1/items/find_all?name=#{name_2}"

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@merchant_3.id)
        expect(items.last['attributes']['id']).to eq(@merchant_4.id)
      end

      xit "find all by created_at" do
        date_1 = @merchant_1.created_at

        get "/api/v1/items/find_all?created_at=#{date_1}"

        expect(response).to be_successful

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(1)

        expect(items.first['attributes']['id']).to eq(@merchant_1.id)

        date_2 = @merchant_2.created_at

        get "/api/v1/items/find_all?created_at=#{date_2}"

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@merchant_2.id)
        expect(items.last['attributes']['id']).to eq(@merchant_3.id)
      end

      xit "find all by updated_at" do
        date_1 = @merchant_1.updated_at

        get "/api/v1/items/find_all?updated_at=#{date_1}"

        expect(response).to be_successful

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@merchant_1.id)
        expect(items.last['attributes']['id']).to eq(@merchant_3.id)

        date_2 = @merchant_2.updated_at

        get "/api/v1/items/find_all?updated_at=#{date_2}"

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@merchant_2.id)
        expect(items.last['attributes']['id']).to eq(@merchant_4.id)
      end
    end
  end

  describe "random" do
    xit "returns a random merchant" do
      items = create_list(:merchant, 10)

      get "/api/v1/items/random"

      expect(response).to be_successful

      number_of_merchants = JSON.parse(response.body).count
      expect(number_of_merchants).to eq(1)

      random_merchant = JSON.parse(response.body)['data']

      expect(random_merchant['type']).to eq('merchant')
      expect(random_merchant['attributes'].keys).to eq(['id', 'name'])

      result = items.one? { |merchant| merchant.id == random_merchant['attributes']['id'] }
      expect(result).to be(true)

      #stubbed test
      expected_merchant = Merchant.last
      allow(Merchant).to receive(:random).and_return(expected_merchant)

      get "/api/v1/items/random"

      random_merchant_2 = JSON.parse(response.body)['data']

      expect(random_merchant_2['type']).to eq('merchant')
      expect(random_merchant_2['attributes']['id']).to eq(expected_merchant.id)
    end
  end

  describe "relationships" do
    xit "sends a list of items associated with a merchant" do
      merchant = create(:merchant)
      create_list(:item, 3, merchant: merchant)

      get "/api/v1/items/#{merchant.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)['data']

      expect(items.count).to eq(3)

      items.each do |item|
        expect(item["attributes"].keys).to eq(["id", "name", "description", "unit_price", "merchant_id"])
        expect(item["attributes"]["merchant_id"]).to eq(merchant.id)
      end
    end

    xit "sends a list of invoices associated with a merchant" do
      merchant = create(:merchant)
      create_list(:invoice, 3, merchant: merchant)

      get "/api/v1/items/#{merchant.id}/invoices"

      expect(response).to be_successful

      invoices = JSON.parse(response.body)['data']

      expect(invoices.count).to eq(3)

      invoices.each do |invoice|
        expect(invoice["attributes"].keys).to eq(["id", "customer_id", "merchant_id", "status"])
        expect(invoice["attributes"]["merchant_id"]).to eq(merchant.id)
      end
    end
  end

  # describe "business logic" do
  #   it "returns the top 'x' items ranked by total revenue" do
  #     create_list(:merchant, 5)
  #     create_list(:item, 5, unit_price: 300, merchant: Merchant.first)
  #     create_list(:item, 5, unit_price: 400, merchant: Merchant.all[1])
  #     create_list(:item, 5, unit_price: 100, merchant: Merchant.all[2])
  #     create_list(:item, 5, unit_price: 600, merchant: Merchant.all[3])
  #     create_list(:item, 5, unit_price: 200, merchant: Merchant.all[4])
  #
  #     merchants = Merchant.all
  #
  #     merchants.each do |merchant|
  #       invoice = create(:invoice, merchant: merchant)
  #       create(:transaction, invoice: invoice)
  #       items = merchant.items
  #       items.each do |item|
  #         item.invoice_items.create!(quantity: 10, unit_price: item.unit_price,invoice: invoice)
  #       end
  #     end
  #
  #     x = 1
  #     get "/api/v1/merchants/most_revenue?quantity=#{x}"
  #
  #     expect(response).to be_successful
  #     merchants = JSON.parse(response.body)['data']
  #     expect(merchants.count).to eq(1)
  #     expect(merchants.first['attributes']['id']).to eq(Merchant.all[3].id)
  #
  #     y = 5
  #     get "/api/v1/merchants/most_revenue?quantity=#{y}"
  #
  #     expect(response).to be_successful
  #     merchants = JSON.parse(response.body)['data']
  #     expect(merchants.count).to eq(5)
  #     expect(merchants.first['attributes']['id']).to eq(Merchant.all[3].id)
  #     expect(merchants.last['attributes']['id']).to eq(Merchant.all[2].id)
  #     end
  #   end
  #
  #   xit "returns the total revenue for date 'x' across all merchants" do
  #     x = "2012-03-16"
  #     y = "2012-03-07"
  #
  #     get "/api/v1/merchants/revenue?date=#{x}"
  #
  #
  #   end
   end
end
