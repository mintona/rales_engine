require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe "methods" do
    describe "#total_revenue_by_date(date)" do
      it "returns the total revenue across all merchants for a given date" do
        merchants = create_list(:merchant, 3)

        merchants.each do |merchant|
          items = create_list(:item, 3, unit_price: 37557, merchant: merchant)
          invoice = create(:invoice, merchant: merchant, created_at: "2012-03-16")
          create(:transaction, invoice: invoice)
          items.each do |item|
            item.invoice_items.create!(quantity: 2, unit_price: item.unit_price, invoice: invoice)
          end
        end
        date = Invoice.first.created_at

        expect(Merchant.total_revenue_by_date(date)).to eq(676026)
      end
    end

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
