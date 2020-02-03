require 'rails_helper'

describe "Transactions API" do
  describe "record endpoints" do
    it "sends a list of transactions" do
      create_list(:transaction, 3)

      get '/api/v1/transactions'

      expect(response).to be_successful

      transactions = JSON.parse(response.body)['data']

      expect(transactions.count).to eq(3)
      expect(transactions.first.keys).to eq(["id", "type", "attributes"])
      expect(transactions.first['attributes'].keys).to match_array(['id', 'credit_card_number', 'invoice_id', 'result'])
      expect(transactions.first['type']).to eq('transaction')
    end

    it "can get one item by its id" do
      transaction = create(:transaction)

      get "/api/v1/transactions/#{transaction.id}"

      expect(response).to be_successful

      found_transaction = JSON.parse(response.body)['data']

      expect(found_transaction['attributes']['id']).to eq(transaction.id)
      expect(found_transaction['attributes']['credit_card_number']).to eq(transaction.credit_card_number.to_s)
      expect(found_transaction['attributes']['invoice_id']).to eq(transaction.invoice_id)
      expect(found_transaction['attributes']['result']).to eq(transaction.result)
    end
  end
end
