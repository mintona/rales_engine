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
          @transaction_1 = create(:transaction, result: "success", credit_card_number: 1234567898745632, created_at: "19-12-05", updated_at: "20-02-04")
          @transaction_2 = create(:transaction, result: "success", created_at: "19-12-25", updated_at: "20-03-05")
          @transaction_3 = create(:transaction, result: "failed", credit_card_number: 4444555566667777, created_at: "19-12-25", updated_at: "20-02-04")
          @transaction_4 = create(:transaction, result: "failed", invoice_id: @transaction_3.invoice_id, credit_card_number: @transaction_3.credit_card_number, created_at: "20-1-30", updated_at: "20-03-05")
        end

        it "find all by id" do
          get "/api/v1/transactions/find_all?id=#{@transaction_1.id}"

          expect(response).to be_successful

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(1)

          expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)
        end

        it "find all by result" do
          transaction_1_results = [@transaction_1.result.upcase, @transaction_1.result]

          transaction_1_results.each do |result|
            get "/api/v1/transactions/find_all?result=#{result}"
            expect(response).to be_successful
            transactions = JSON.parse(response.body)['data']
            expect(transactions.count).to eq(2)
            expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)
            expect(transactions.last['attributes']['id']).to eq(@transaction_2.id)
          end

          result_2 = "FAILED"

          get "/api/v1/transactions/find_all?result=#{result_2}"

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(2)

          expect(transactions.first['attributes']['id']).to eq(@transaction_3.id)
          expect(transactions.last['attributes']['id']).to eq(@transaction_4.id)
        end

        it "find all by invoice_id" do
          get "/api/v1/transactions/find_all?invoice_id=#{@transaction_1.invoice_id}"

          expect(response).to be_successful

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(1)

          expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)

          invoice_id_2 = @transaction_3.invoice_id

          get "/api/v1/transactions/find_all?invoice_id=#{invoice_id_2}"

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(2)

          expect(transactions.first['attributes']['id']).to eq(@transaction_3.id)
          expect(transactions.last['attributes']['id']).to eq(@transaction_4.id)
        end

        it "find all by credit_card_number" do
          get "/api/v1/transactions/find_all?credit_card_number=#{@transaction_1.credit_card_number}"

          expect(response).to be_successful

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(1)
          expect(transactions.first['attributes']['id']).to eq(@transaction_1.id)

          credit_card_number_2 = @transaction_3.credit_card_number

          get "/api/v1/transactions/find_all?credit_card_number=#{credit_card_number_2}"

          transactions = JSON.parse(response.body)['data']

          expect(transactions.count).to eq(2)

          expect(transactions.first['attributes']['id']).to eq(@transaction_3.id)
          expect(transactions.last['attributes']['id']).to eq(@transaction_4.id)
        end

        it "find all by created_at" do
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

        it "find all by updated_at" do
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
      it "returns a random invoice" do
        transactions = create_list(:transaction, 10)

        get "/api/v1/transactions/random"

        expect(response).to be_successful

        number_of_transactions = JSON.parse(response.body).count
        expect(number_of_transactions).to eq(1)

        random_invoice = JSON.parse(response.body)['data']

        expect(random_invoice['type']).to eq('transaction')
        expect(random_invoice['attributes'].keys).to match_array(['id', 'result', 'credit_card_number', 'invoice_id'])

        result = transactions.one? { |invoice| invoice.id == random_invoice['attributes']['id'] }
        expect(result).to be(true)
      end
    end
  end
end
