require 'rails_helper'

describe "Application Record Methods" do
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
