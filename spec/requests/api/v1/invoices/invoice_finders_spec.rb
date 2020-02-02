require 'rails_helper'

RSpec.describe "Invoice API" do
  describe "finders" do
    describe "single finders" do
      describe "can get one invoice by any attribute:" do
        before :each do
          @invoice = create(:invoice, created_at: "2020-01-30", updated_at: "2020-01-31")
          create_list(:invoice, 2)
        end

        it "id" do
          get "/api/v1/invoices/find?id=#{@invoice.id}"

          invoice = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(invoice['attributes']['id']).to eq(@invoice.id)
        end

        it "status" do
          statuses = [@invoice.status, @invoice.status.upcase]

          statuses.each do |status|
            get "/api/v1/invoices/find?status=#{status}"
            invoice = JSON.parse(response.body)['data']
            expect(response).to be_successful
            expect(invoice['attributes']['id']).to eq(@invoice.id)
          end
        end

        it "merchant_id" do
          get "/api/v1/invoices/find?merchant_id=#{@invoice.merchant_id}"

          item_invoice = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(item_invoice['attributes']['id']).to eq(@invoice.id)
        end

        it "customer_id" do
          get "/api/v1/invoices/find?customer_id=#{@invoice.customer_id}"

          item_invoice = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(item_invoice['attributes']['id']).to eq(@invoice.id)
        end

        it "created_at" do
          date = @invoice.created_at.to_s

          get "/api/v1/invoices/find?created_at=#{date}"

          invoice = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(invoice['attributes']['id']).to eq(@invoice.id)
        end

        it "updated_at" do
          date = @invoice.updated_at.to_s

          get "/api/v1/invoices/find?updated_at=#{date}"

          invoice = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(invoice['attributes']['id']).to eq(@invoice.id)
        end
      end
    end

    describe "multi-finders" do
      describe "return all matches by any attribute" do
        before :each do
          @invoice_1 = create(:invoice, created_at: "19-12-05", updated_at: "20-02-04")
          @invoice_2 = create(:invoice, created_at: "19-12-25", updated_at: "20-03-05")
          @invoice_3 = create(:invoice, created_at: "19-12-25", updated_at: "20-02-04")
          @invoice_4 = create(:invoice, status: "failed", merchant_id: @invoice_3.merchant_id, customer_id: @invoice_3.customer_id, created_at: "20-1-30", updated_at: "20-03-05")
        end

        it "find all by id" do
          get "/api/v1/invoices/find_all?id=#{@invoice_1.id}"

          expect(response).to be_successful

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(1)

          expect(invoices.first['attributes']['id']).to eq(@invoice_1.id)
        end

        it "find all by status" do
          get "/api/v1/invoices/find_all?status=#{@invoice_1.status}"

          expect(response).to be_successful

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(3)

          expect(invoices.first['attributes']['id']).to eq(@invoice_1.id)

          status_2 = "failed"

          get "/api/v1/invoices/find_all?status=#{status_2}"

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(1)

          expect(invoices.last['attributes']['id']).to eq(@invoice_4.id)
        end

        it "find all by merchant_id" do
          get "/api/v1/invoices/find_all?merchant_id=#{@invoice_1.merchant_id}"

          expect(response).to be_successful

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(1)

          expect(invoices.first['attributes']['id']).to eq(@invoice_1.id)

          merchant_id_2 = @invoice_3.merchant_id

          get "/api/v1/invoices/find_all?merchant_id=#{merchant_id_2}"

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(2)

          expect(invoices.first['attributes']['id']).to eq(@invoice_3.id)
          expect(invoices.last['attributes']['id']).to eq(@invoice_4.id)
        end

        it "find all by customer_id" do
          get "/api/v1/invoices/find_all?customer_id=#{@invoice_1.customer_id}"

          expect(response).to be_successful

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(1)
          expect(invoices.first['attributes']['id']).to eq(@invoice_1.id)

          customer_id_2 = @invoice_3.customer_id

          get "/api/v1/invoices/find_all?customer_id=#{customer_id_2}"

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(2)

          expect(invoices.first['attributes']['id']).to eq(@invoice_3.id)
          expect(invoices.last['attributes']['id']).to eq(@invoice_4.id)
        end

        it "find all by created_at" do
          date_1 = @invoice_1.created_at

          get "/api/v1/invoices/find_all?created_at=#{date_1}"

          expect(response).to be_successful

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(1)

          expect(invoices.first['attributes']['id']).to eq(@invoice_1.id)

          date_2 = @invoice_2.created_at

          get "/api/v1/invoices/find_all?created_at=#{date_2}"

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(2)

          expect(invoices.first['attributes']['id']).to eq(@invoice_2.id)
          expect(invoices.last['attributes']['id']).to eq(@invoice_3.id)
        end

        it "find all by updated_at" do
          date_1 = @invoice_1.updated_at

          get "/api/v1/invoices/find_all?updated_at=#{date_1}"

          expect(response).to be_successful

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(2)

          expect(invoices.first['attributes']['id']).to eq(@invoice_1.id)
          expect(invoices.last['attributes']['id']).to eq(@invoice_3.id)

          date_2 = @invoice_2.updated_at

          get "/api/v1/invoices/find_all?updated_at=#{date_2}"

          invoices = JSON.parse(response.body)['data']

          expect(invoices.count).to eq(2)

          expect(invoices.first['attributes']['id']).to eq(@invoice_2.id)
          expect(invoices.last['attributes']['id']).to eq(@invoice_4.id)
        end
      end
    end

    describe "random" do
      xit "returns a random invoice" do
        invoices = create_list(:invoice, 10)

        get "/api/v1/invoices/random"

        expect(response).to be_successful

        number_of_invoices = JSON.parse(response.body).count
        expect(number_of_invoices).to eq(1)

        random_invoice = JSON.parse(response.body)['data']

        expect(random_invoice['type']).to eq('invoice')
        expect(random_invoice['attributes'].keys).to match_array(['id', 'invoice_id', 'item_id', 'quantity', 'unit_price'])

        result = invoices.one? { |invoice| invoice.id == random_invoice['attributes']['id'] }
        expect(result).to be(true)
      end
    end
  end
end
