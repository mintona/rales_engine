require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "validations" do
    it {should validate_presence_of :first_name}
    it {should validate_presence_of :last_name}
  end

  describe "relationships" do
    it {should have_many :invoices}
  end

  describe "methods" do
    describe "#favorite_merchant" do
      it "returns the merchant where the customer has conducted the most successful transactions" do
        customer = create(:customer)
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        merchant_1_items = create_list(:item, 3, unit_price: 100, merchant: merchant_1)
        merchant_2_items = create_list(:item, 4, unit_price: 100, merchant: merchant_2)

        merchant_1_items.each do |item|
          invoice = create(:invoice, merchant: item.merchant, customer: customer)
          create(:transaction, result: "success", invoice: invoice)
          item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice)
        end

        merchant_2_items.each do |item|
          invoice = create(:invoice, merchant: item.merchant, customer: customer)
          create(:transaction, result: "failed", invoice: invoice)
          item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice)
        end

        expect(customer.favorite_merchant).to eq(merchant_1)
      end
    end
  end
end
