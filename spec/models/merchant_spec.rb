require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :invoices}
  end

#needs total_revenue_by_date_test
  describe "methods" do
    describe "#favorite_customer" do
      it "returns the customer who has conducted the highest total number of successful transactions" do
        merchant = create(:merchant)
        customer_1 = create(:customer)
        customer_2 = create(:customer)
        customer_3 = create(:customer)

        invoice_1 = create(:invoice, merchant: merchant, customer: customer_1)
        invoice_2 = create(:invoice, merchant: merchant, customer: customer_2)
        invoice_3 = create(:invoice, merchant: merchant, customer: customer_3)

        create_list(:transaction, 1, result: 'success', invoice: invoice_1)
        create_list(:transaction, 10, result: 'failed', invoice: invoice_2)
        create_list(:transaction, 5, result: 'success', invoice: invoice_3)

        expect(merchant.favorite_customer).to eq(customer_3)
      end
    end
  end
end
