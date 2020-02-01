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
    describe "#highest_revenue(limit)" do
      it "returns a collection of merchants of a specified number sorted by descending revenue" do
        create_list(:merchant, 5)
        create_list(:item, 5, unit_price: 300, merchant: Merchant.first)
        create_list(:item, 5, unit_price: 400, merchant: Merchant.all[1])
        create_list(:item, 5, unit_price: 100, merchant: Merchant.all[2])
        create_list(:item, 5, unit_price: 600, merchant: Merchant.all[3])
        create_list(:item, 5, unit_price: 200, merchant: Merchant.all[4])

        merchants = Merchant.all
        merchant_1 = Merchant.first
        merchant_2 = Merchant.all[1]
        merchant_3 = Merchant.all[2]
        merchant_4 = Merchant.all[3]
        merchant_5 = Merchant.all[4]

        merchants.each do |merchant|
          invoice = create(:invoice, merchant: merchant)
          create(:transaction, invoice: invoice)
          items = merchant.items
          items.each do |item|
            item.invoice_items.create!(quantity: 10, unit_price: item.unit_price,invoice: invoice)
          end
        end

        merchants = Merchant.highest_revenue(1)
        expect(merchants).to eq([merchant_4])

        merchants = Merchant.highest_revenue(5)
        expect(merchants).to eq([merchant_4, merchant_2, merchant_1, merchant_5, merchant_3])
      end
    end
  end
end
