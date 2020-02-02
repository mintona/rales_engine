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
      #add assertion for relationship?
    end

    it "can get one merchant by its id" do
      id = create(:merchant).id.to_s

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(merchant["id"]).to eq(id)
    end
  end

  describe "single finders" do
    describe "can get one merchant by any attribute:" do
      before :each do
        @merchant = create(:merchant, created_at: "2020-01-30", updated_at: "2020-01-31")
        create_list(:merchant, 2)
      end

      it "find by id" do
        get "/api/v1/merchants/find?id=#{@merchant.id}"

        merchant = JSON.parse(response.body)['data']
        expect(response).to be_successful

        expect(merchant['attributes']['id']).to eq(@merchant.id)
      end

      it "name" do
        merchant_1_names = [@merchant.name, @merchant.name.upcase, @merchant.name.downcase]

        merchant_1_names.each do |name|
          get "/api/v1/merchants/find?name=#{name}"

          merchant = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(merchant['attributes']['id']).to eq(@merchant.id)
        end
      end

      it "created_at" do
        date = @merchant.created_at.to_s

        get "/api/v1/merchants/find?created_at=#{date}"

        merchant = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(merchant['attributes']['id']).to eq(@merchant.id)
      end

      it "updated_at" do
        date = @merchant.updated_at.to_s

        get "/api/v1/merchants/find?updated_at=#{date}"
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

      it "find all by id" do
        get "/api/v1/merchants/find_all?id=#{@merchant_1.id}"

        expect(response).to be_successful

        merchants = JSON.parse(response.body)['data']

        expect(merchants.count).to eq(1)

        expect(merchants.first['attributes']['id']).to eq(@merchant_1.id)        #expect 1 response
      end

      it "find all by name" do
        merchant_1_names = [@merchant_1.name, @merchant_1.name.upcase, @merchant_1.name.downcase]

        merchant_1_names.each do |name|
          get "/api/v1/merchants/find_all?name=#{name}"
          expect(response).to be_successful
          merchants = JSON.parse(response.body)['data']
          expect(merchants.count).to eq(1)
          expect(merchants.first['attributes']['id']).to eq(@merchant_1.id)
        end

        name_2 = @merchant_3.name

        get "/api/v1/merchants/find_all?name=#{name_2}"

        merchants = JSON.parse(response.body)['data']

        expect(merchants.count).to eq(2)

        expect(merchants.first['attributes']['id']).to eq(@merchant_3.id)
        expect(merchants.last['attributes']['id']).to eq(@merchant_4.id)
      end

      it "find all by created_at" do
        date_1 = @merchant_1.created_at

        get "/api/v1/merchants/find_all?created_at=#{date_1}"

        expect(response).to be_successful

        merchants = JSON.parse(response.body)['data']

        expect(merchants.count).to eq(1)

        expect(merchants.first['attributes']['id']).to eq(@merchant_1.id)

        date_2 = @merchant_2.created_at

        get "/api/v1/merchants/find_all?created_at=#{date_2}"

        merchants = JSON.parse(response.body)['data']

        expect(merchants.count).to eq(2)

        expect(merchants.first['attributes']['id']).to eq(@merchant_2.id)
        expect(merchants.last['attributes']['id']).to eq(@merchant_3.id)
      end

      it "find all by updated_at" do
        date_1 = @merchant_1.updated_at

        get "/api/v1/merchants/find_all?updated_at=#{date_1}"

        expect(response).to be_successful

        merchants = JSON.parse(response.body)['data']

        expect(merchants.count).to eq(2)

        expect(merchants.first['attributes']['id']).to eq(@merchant_1.id)
        expect(merchants.last['attributes']['id']).to eq(@merchant_3.id)

        date_2 = @merchant_2.updated_at

        get "/api/v1/merchants/find_all?updated_at=#{date_2}"

        merchants = JSON.parse(response.body)['data']

        expect(merchants.count).to eq(2)

        expect(merchants.first['attributes']['id']).to eq(@merchant_2.id)
        expect(merchants.last['attributes']['id']).to eq(@merchant_4.id)
      end
    end
  end

  describe "random" do
    it "returns a random merchant" do
      merchants = create_list(:merchant, 10)

      get "/api/v1/merchants/random"

      expect(response).to be_successful

      number_of_merchants = JSON.parse(response.body).count
      expect(number_of_merchants).to eq(1)

      random_merchant = JSON.parse(response.body)['data']

      expect(random_merchant['type']).to eq('merchant')
      expect(random_merchant['attributes'].keys).to eq(['id', 'name'])

      result = merchants.one? { |merchant| merchant.id == random_merchant['attributes']['id'] }
      expect(result).to be(true)
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
        expect(item["attributes"].keys).to match_array(["id", "name", "description", "unit_price", "merchant_id"])
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
end
end 
