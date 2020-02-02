require 'rails_helper'

RSpec.describe "Invoice Items API" do
  describe "finders" do
    describe "single finders" do
      describe "can get one invoice_item by any attribute:" do
        before :each do
          @invoice_item = create(:invoice_item, unit_price: 27409, quantity: 100, created_at: "2020-01-30", updated_at: "2020-01-31")
          create_list(:invoice_item, 2)
        end

        it "id" do
          get "/api/v1/invoice_items/find?id=#{@invoice_item.id}"

          invoice_item = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(invoice_item['attributes']['id']).to eq(@invoice_item.id)
        end

        it "quantity" do
          get "/api/v1/invoice_items/find?quantity=#{@invoice_item.quantity}"

          invoice_item = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(invoice_item['attributes']['id']).to eq(@invoice_item.id)
        end

        it "unit_price" do
          unit_price = "274.09"
          get "/api/v1/invoice_items/find?unit_price=#{unit_price}"

          item_invoice = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(item_invoice['attributes']['id']).to eq(@invoice_item.id)
        end

        it "invoice_id" do
          get "/api/v1/invoice_items/find?invoice_id=#{@invoice_item.invoice_id}"

          item_invoice = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(item_invoice['attributes']['id']).to eq(@invoice_item.id)
        end

        it "created_at" do
          date = @invoice_item.created_at.to_s

          get "/api/v1/invoice_items/find?created_at=#{date}"

          invoice_item = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(invoice_item['attributes']['id']).to eq(@invoice_item.id)
        end

        it "updated_at" do
          date = @invoice_item.updated_at.to_s

          get "/api/v1/invoice_items/find?updated_at=#{date}"

          invoice_item = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(invoice_item['attributes']['id']).to eq(@invoice_item.id)
        end
      end

    describe "multi-finders" do
      describe "return all matches by any attribute" do
        before :each do
          @invoice_item_1 = create(:invoice_item, created_at: "19-12-05", updated_at: "20-02-04")
          @invoice_item_2 = create(:invoice_item, created_at: "19-12-25", updated_at: "20-03-05")
          @invoice_item_3 = create(:invoice_item, created_at: "19-12-25", updated_at: "20-02-04")
          @invoice_item_4 = create(:invoice_item, invoice: @invoice_item_3.invoice, quantity: @invoice_item_3.quantity, unit_price: @invoice_item_3.unit_price, created_at: "20-1-30", updated_at: "20-03-05")
        end

        it "find all by id" do
          get "/api/v1/invoice_items/find_all?id=#{@invoice_item_1.id}"

          expect(response).to be_successful

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(1)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_1.id)
        end

        it "find all by quantity" do
          get "/api/v1/invoice_items/find_all?quantity=#{@invoice_item_1.quantity}"

          expect(response).to be_successful

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(1)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_1.id)

          quantity_2 = @invoice_item_3.quantity

          get "/api/v1/invoice_items/find_all?quantity=#{quantity_2}"

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(2)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_3.id)
          expect(invoice_items.last['attributes']['id']).to eq(@invoice_item_4.id)
        end

        it "find all by unit_price" do
          get "/api/v1/invoice_items/find_all?unit_price=#{@invoice_item_1.unit_price}"

          expect(response).to be_successful

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(1)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_1.id)

          quantity_2 = @invoice_item_3.unit_price

          get "/api/v1/invoice_items/find_all?unit_price=#{quantity_2}"

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(2)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_3.id)
          expect(invoice_items.last['attributes']['id']).to eq(@invoice_item_4.id)
        end

        it "find all by invoice_id" do
          get "/api/v1/invoice_items/find_all?invoice_id=#{@invoice_item_1.invoice_id}"
          expect(response).to be_successful
          invoice_items = JSON.parse(response.body)['data']
          expect(invoice_items.count).to eq(1)
          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_1.id)


          invoice_id_2 = @invoice_item_3.invoice_id

          get "/api/v1/invoice_items/find_all?invoice_id=#{invoice_id_2}"

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(2)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_3.id)
          expect(invoice_items.last['attributes']['id']).to eq(@invoice_item_4.id)
        end

        it "find all by created_at" do
          date_1 = @invoice_item_1.created_at

          get "/api/v1/invoice_items/find_all?created_at=#{date_1}"

          expect(response).to be_successful

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(1)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_1.id)

          date_2 = @invoice_item_2.created_at

          get "/api/v1/invoice_items/find_all?created_at=#{date_2}"

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(2)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_2.id)
          expect(invoice_items.last['attributes']['id']).to eq(@invoice_item_3.id)
        end

        it "find all by updated_at" do
          date_1 = @invoice_item_1.updated_at

          get "/api/v1/invoice_items/find_all?updated_at=#{date_1}"

          expect(response).to be_successful

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(2)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_1.id)
          expect(invoice_items.last['attributes']['id']).to eq(@invoice_item_3.id)

          date_2 = @invoice_item_2.updated_at

          get "/api/v1/invoice_items/find_all?updated_at=#{date_2}"

          invoice_items = JSON.parse(response.body)['data']

          expect(invoice_items.count).to eq(2)

          expect(invoice_items.first['attributes']['id']).to eq(@invoice_item_2.id)
          expect(invoice_items.last['attributes']['id']).to eq(@invoice_item_4.id)
        end
      end
    end

    describe "random" do
      it "returns a random invoice_item" do
        invoice_items = create_list(:invoice_item, 10)

        get "/api/v1/invoice_items/random"

        expect(response).to be_successful

        number_of_invoice_items = JSON.parse(response.body).count
        expect(number_of_invoice_items).to eq(1)

        random_invoice_item = JSON.parse(response.body)['data']

        expect(random_invoice_item['type']).to eq('invoice_item')
        expect(random_invoice_item['attributes'].keys).to match_array(['id', 'invoice_id', 'item_id', 'quantity', 'unit_price'])

        # could test the range instead?
        result = invoice_items.one? { |invoice_item| invoice_item.id == random_invoice_item['attributes']['id'] }
        expect(result).to be(true)
      end
      end
    end
  end
end
