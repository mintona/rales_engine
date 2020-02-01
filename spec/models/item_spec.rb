require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  describe "methods" do
    describe "best_day" do
      it "returns teh date with the most sales for the given item using the invoice date" do
        # If there are multiple days with equal number of sales, return the most recent day.
        item = create(:item, unit_price: 100)
        invoice_1 = create(:invoice, created_at: "1985-02-04")
        invoice_2 = create(:invoice, created_at: "2020-02-01")
        invoice_3 = create(:invoice, created_at: "2020-01-30")
        invoice_4 = create(:invoice, created_at: "2018-02-04")
        invoice_5 = create(:invoice, created_at: "2021-02-04")

        create(:transaction, invoice: invoice_1)
        create(:transaction, invoice: invoice_2)
        create(:transaction, invoice: invoice_3)
        create(:transaction, invoice: invoice_4)
        create(:transaction, result: 'failed', invoice: invoice_5)

        item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice_1)
        item.invoice_items.create!(quantity: 1, unit_price: item.unit_price, invoice: invoice_2)
        item.invoice_items.create!(quantity: 5, unit_price: item.unit_price, invoice: invoice_3)
        item.invoice_items.create!(quantity: 10, unit_price: item.unit_price, invoice: invoice_4)
        item.invoice_items.create!(quantity: 100, unit_price: item.unit_price, invoice: invoice_5)

        expect(item.best_day).to eq("2018-02-04")
      end
    end
  end
end
