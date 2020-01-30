### test application record tests here ... testing on one resource is enough.
require 'rails_helper'

describe "Application Record Methods" do
  describe "#find_one_case_insensitive" do
    it "returns one resource based on a attribute:value pair regardless of the case of the attribute" do
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
end
