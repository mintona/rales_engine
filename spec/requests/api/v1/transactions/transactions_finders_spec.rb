require 'rails_helper'

RSpec.describe "Transactions API" do
  describe "finders" do
    describe "single finders" do
      describe "can get one invoice by any attribute:" do
        before :each do
          @transaction = create(:transaction, created_at: "2020-01-30", updated_at: "2020-01-31")
          create_list(:transaction, 2)
        end

        it "id" do
          get "/api/v1/transactions/find?id=#{@transaction.id}"

          invoice = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(invoice['attributes']['id']).to eq(@transaction.id)
        end

        it "result" do
          results = [@transaction.result, @transaction.result.upcase]

          results.each do |result|
            get "/api/v1/transactions/find?result=#{result}"
            invoice = JSON.parse(response.body)['data']
            expect(response).to be_successful
            expect(invoice['attributes']['id']).to eq(@transaction.id)
          end
        end

        it "invoice_id" do
          get "/api/v1/transactions/find?invoice_id=#{@transaction.invoice_id}"

          item_invoice = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(item_invoice['attributes']['id']).to eq(@transaction.id)
        end

        it "credit_card_number" do
          get "/api/v1/transactions/find?credit_card_number=#{@transaction.credit_card_number}"

          item_invoice = JSON.parse(response.body)['data']
          expect(response).to be_successful

          expect(item_invoice['attributes']['id']).to eq(@transaction.id)
        end

        it "created_at" do
          date = @transaction.created_at.to_s

          get "/api/v1/transactions/find?created_at=#{date}"

          invoice = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(invoice['attributes']['id']).to eq(@transaction.id)
        end

        it "updated_at" do
          date = @transaction.updated_at.to_s

          get "/api/v1/transactions/find?updated_at=#{date}"

          invoice = JSON.parse(response.body)['data']

          expect(response).to be_successful
          expect(invoice['attributes']['id']).to eq(@transaction.id)
        end
      end
    end

    describe "multi-finders" do
      describe "return all matches by any attribute" do
        before :each do
          @transaction_1 = create(:transaction, created_at: "19-12-05", updated_at: "20-02-04")
          @transaction_2 = create(:transaction, created_at: "19-12-25", updated_at: "20-03-05")
          @transaction_3 = create(:transaction, created_at: "19-12-25", updated_at: "20-02-04")
          @transaction_4 = create(:transaction, status: "failed", invoice_id: @transaction_3.merchant_id, customer_id: @transaction_3.customer_id, created_at: "20-1-30", updated_at: "20-03-05")
        end

        xit "find all by id" do
          get "/api/v1/transactions/find_all?id=#{@transaction_1.id}"

          expect(response).to be_successful

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(1)

          expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)
        end

        xit "find all by status" do
          get "/api/v1/transactions/find_all?status=#{@transaction_1.status}"

          expect(response).to be_successful

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(3)

          expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)

          status_2 = "failed"

          get "/api/v1/transactions/find_all?status=#{status_2}"

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(1)

          expect(transactions.last['attributes']['id']).to eq(@transaction_4.id)
        end

        xit "find all by merchant_id" do
          get "/api/v1/transactions/find_all?merchant_id=#{@transaction_1.merchant_id}"

          expect(response).to be_successful

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(1)

          expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)

          merchant_id_2 = @transaction_3.merchant_id

          get "/api/v1/transactions/find_all?merchant_id=#{merchant_id_2}"

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(2)

          expect(transactions.first['attributes']['id']).to eq(@transaction_3.id)
          expect(transactions.last['attributes']['id']).to eq(@transaction_4.id)
        end

        xit "find all by customer_id" do
          get "/api/v1/transactions/find_all?customer_id=#{@transaction_1.customer_id}"

          expect(response).to be_successful

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(1)
          expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)

          customer_id_2 = @transaction_3.customer_id

          get "/api/v1/transactions/find_all?customer_id=#{customer_id_2}"

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(2)

          expect(transactions.first['attributes']['id']).to eq(@transaction_3.id)
          expect(transactions.last['attributes']['id']).to eq(@transaction_4.id)
        end

        xit "find all by created_at" do
          date_1 = @transaction_1.created_at

          get "/api/v1/transactions/find_all?created_at=#{date_1}"

          expect(response).to be_successful

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(1)

          expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)

          date_2 = @transaction_2.created_at

          get "/api/v1/transactions/find_all?created_at=#{date_2}"

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(2)

          expect(transactions.first['attributes']['id']).to eq(@transaction_2.id)
          expect(transactions.last['attributes']['id']).to eq(@transaction_3.id)
        end

        xit "find all by updated_at" do
          date_1 = @transaction_1.updated_at

          get "/api/v1/transactions/find_all?updated_at=#{date_1}"

          expect(response).to be_successful

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(2)

          expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)
          expect(transactions.last['attributes']['id']).to eq(@transaction_3.id)

          date_2 = @transaction_2.updated_at

          get "/api/v1/transactions/find_all?updated_at=#{date_2}"

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(2)

          expect(transactions.first['attributes']['id']).to eq(@transaction_2.id)
          expect(transactions.last['attributes']['id']).to eq(@transaction_4.id)
        end
      end
    end

    describe "random" do
      xit "returns a random invoice" do
        transactions = create_list(:transaction, 10)

        get "/api/v1/transactions/random"

        expect(response).to be_successful

        number_of_transactions = JSON.parse(response.body).count
        expect(number_of_transactions).to eq(1)

        random_invoice = JSON.parse(response.body)['data']

        expect(random_invoice['type']).to eq('invoice')
        expect(random_invoice['attributes'].keys).to match_array(['id', 'status', 'merchant_id', 'customer_id'])

        result = transactions.one? { |invoice| invoice.id == random_invoice['attributes']['id'] }
        expect(result).to be(true)
      end
    end
  end
end
