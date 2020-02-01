require 'rails_helper'

describe "Application Record Methods" do
  describe "#random" do
    it "returns one random resource" do
      create_list(:merchant, 10)
      merchants = Merchant.all
      merchant = merchants.random

      expect(merchant.class).to eq(Merchant)

      merchant_ids = Merchant.select(:id).pluck(:id)

      expect(merchant_ids.include?(merchant.id)).to eq(true)
    end
  end

  describe "#highest_revenue(limit)" do
    it "returns a collection of the resource of a specified number sorted by descending revenue" do
      # failed transations are not included in revenue calculations
      create_list(:merchant, 6)
      create_list(:item, 5, unit_price: 300, merchant: Merchant.first)
      create_list(:item, 5, unit_price: 400, merchant: Merchant.all[1])
      create_list(:item, 5, unit_price: 100, merchant: Merchant.all[2])
      create_list(:item, 5, unit_price: 600, merchant: Merchant.all[3])
      create_list(:item, 5, unit_price: 200, merchant: Merchant.all[4])
      create_list(:item, 5, unit_price: 200, merchant: Merchant.all[5])

      merchants = Merchant.all
      merchant_1 = Merchant.first
      merchant_2 = Merchant.all[1]
      merchant_3 = Merchant.all[2]
      merchant_4 = Merchant.all[3]
      merchant_5 = Merchant.all[4]
      merchant_6 = Merchant.all[5]

      merchants.each do |merchant|
        invoice = create(:invoice, merchant: merchant)
        if merchant.id == merchant_6.id
          create(:transaction, result: "failed", invoice: invoice)
        else
          create(:transaction, invoice: invoice)
        end
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

  describe "#find_one_case_insensitive" do
    it "returns one resource based on an attribute:value pair regardless of the case of the value" do
      create_list(:item, 3)
      item_1 = Item.first

      item_1_names = [item_1.name, item_1.name.upcase, item_1.name.downcase]

      items = item_1_names.map do |name|
        search_params = {name: name}
        item = Item.find_one_case_insensitive(search_params)
      end

      result = items.all? { |item| item == item_1 }

      expect(result).to eq(true)
    end
  end

  describe "#find_all_case_insensitive" do
    it "returns all resource based on an attribute:value pair regardless of the case of the value" do
      merchant_1 = create(:merchant, name: "MERCHANT name")
      merchant_2 = create(:merchant, name: "merchant NAME")
      merchant_3 = create(:merchant)

      merchant_names = [merchant_1.name, merchant_1.name.upcase, merchant_1.name.downcase]

      search_params = {name: merchant_1.name}

      found_merchants = Merchant.find_all_case_insensitive(search_params)

      expect(found_merchants).to match_array([merchant_1, merchant_2])
    end
  end
end
