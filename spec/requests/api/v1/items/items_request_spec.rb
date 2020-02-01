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

      it "merchant_id" do
        get "/api/v1/items/find?merchant_id=#{@item.merchant_id}"

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

      it "created_at" do
        date = @item.created_at.to_s

        get "/api/v1/items/find?created_at=#{date}"

        item = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(item['attributes']['id']).to eq(@item.id)
      end

      it "updated_at" do
        date = @item.updated_at.to_s

        get "/api/v1/items/find?updated_at=#{date}"

        item = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(item['attributes']['id']).to eq(@item.id)
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

      it "find all by id" do
        get "/api/v1/items/find_all?id=#{@item_1.id}"

        expect(response).to be_successful

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(1)

        expect(items.first['attributes']['id']).to eq(@item_1.id)
      end

      it "find all by merchant_id" do
        get "/api/v1/items/find_all?merchant_id=#{@item_1.merchant_id}"

        expect(response).to be_successful

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(1)

        expect(items.first['attributes']['id']).to eq(@item_1.id)

        get "/api/v1/items/find_all?merchant_id=#{@item_2.merchant_id}"

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@item_2.id)
        expect(items.last['attributes']['id']).to eq(@item_3.id)
      end

      it "find all by name" do
        item_1_names = [@item_1.name, @item_1.name.upcase, @item_1.name.downcase]

        item_1_names.each do |name|
          get "/api/v1/items/find_all?name=#{name}"
          expect(response).to be_successful
          items = JSON.parse(response.body)['data']
          expect(items.count).to eq(1)
          expect(items.first['attributes']['id']).to eq(@item_1.id)
        end

        name_2 = @item_3.name

        get "/api/v1/items/find_all?name=#{name_2}"

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@item_3.id)
        expect(items.last['attributes']['id']).to eq(@item_4.id)
      end

      it "find all by description" do
        item_1_descriptions = [@item_1.description, @item_1.description.upcase, @item_1.description.downcase]

        item_1_descriptions.each do |description|
          get "/api/v1/items/find_all?description=#{description}"
          expect(response).to be_successful
          items = JSON.parse(response.body)['data']
          expect(items.count).to eq(1)
          expect(items.first['attributes']['id']).to eq(@item_1.id)
        end

        description_2 = @item_3.description

        get "/api/v1/items/find_all?description=#{description_2}"

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@item_3.id)
        expect(items.last['attributes']['id']).to eq(@item_4.id)
      end

      it "find all by created_at" do
        date_1 = @item_1.created_at

        get "/api/v1/items/find_all?created_at=#{date_1}"

        expect(response).to be_successful

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(1)

        expect(items.first['attributes']['id']).to eq(@item_1.id)

        date_2 = @item_2.created_at

        get "/api/v1/items/find_all?created_at=#{date_2}"

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@item_2.id)
        expect(items.last['attributes']['id']).to eq(@item_3.id)
      end

      it "find all by updated_at" do
        date_1 = @item_1.updated_at

        get "/api/v1/items/find_all?updated_at=#{date_1}"

        expect(response).to be_successful

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@item_1.id)
        expect(items.last['attributes']['id']).to eq(@item_3.id)

        date_2 = @item_2.updated_at

        get "/api/v1/items/find_all?updated_at=#{date_2}"

        items = JSON.parse(response.body)['data']

        expect(items.count).to eq(2)

        expect(items.first['attributes']['id']).to eq(@item_2.id)
        expect(items.last['attributes']['id']).to eq(@item_4.id)
      end
    end
  end

  describe "random" do
    it "returns a random item" do
      items = create_list(:item, 10)

      get "/api/v1/items/random"

      expect(response).to be_successful

      number_of_items = JSON.parse(response.body).count
      expect(number_of_items).to eq(1)

      random_item = JSON.parse(response.body)['data']

      expect(random_item['type']).to eq('item')
      expect(random_item['attributes'].keys).to match_array(['id', 'name', 'description', 'unit_price', 'merchant_id'])

      # could test the range instead?
      result = items.one? { |item| item.id == random_item['attributes']['id'] }
      expect(result).to be(true)

    end
  end

  describe "relationships" do
    it "returns a collection of associated invoice items" do
      item = create(:item)
      create_list(:invoice_item, 3, item: item)

      get "/api/v1/items/#{item.id}/invoice_items"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)['data']

      expect(invoice_items.count).to eq(3)

      invoice_items.each do |invoice_item|
        expect(invoice_item["attributes"].keys).to match_array(["id", "quantity", "item_id", "unit_price", "invoice_id"])
        expect(invoice_item["attributes"]["item_id"]).to eq(item.id)
      end
    end

    it "returns the associated merchant" do
      merchant = create(:merchant)
      merchant_2 = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      returned_merchant = JSON.parse(response.body)['data']

      expect(returned_merchant['type']).to eq('merchant')
      expect(returned_merchant["attributes"].keys).to eq(["id", "name"])
      expect(returned_merchant["attributes"]["id"]).to eq(merchant.id)
      expect(returned_merchant["attributes"]["name"]).to eq(merchant.name)
    end
  end

  describe "business logic" do
    it "returns the top 'x' items ranked by total revenue" do
      # GET /api/v1/items/most_revenue?quantity=x returns the top x items ranked by total revenue generated
      # create_list(:merchant, 5)
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
        # items = merchant.items
        # items.each do |item|
          item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice)
        # end
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
    end

    xit "returns the total revenue for date 'x' across all merchants" do
      # GET /api/v1/items/:id/best_day returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.
      x = "2012-03-16"
      y = "2012-03-07"

      get "/api/v1/merchants/revenue?date=#{x}"


    end
   end
end
