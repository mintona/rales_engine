require 'csv'

namespace :import do
  desc "Import Data from CSV Files"

  task merchants: :environment do
    merchants = CSV.read("./db/data/merchants.csv", headers: true, header_converters: :symbol)
    merchants.each do |row|
      Merchant.create(row.to_h)
    end
  end

  task customers: :environment do
    customers = CSV.read("./db/data/customers.csv", headers: true, header_converters: :symbol)
    customers.each do |row|
      Customer.create(row.to_h)
    end
  end

  task items: :environment do
    items = CSV.read("./db/data/items.csv", headers: true, header_converters: :symbol)
    items.each do |row|
      Item.create(row.to_h)
    end
  end

  task invoices: :environment do
    invoices = CSV.read("./db/data/invoices.csv", headers: true, header_converters: :symbol)
    invoices.each do |row|
      Invoice.create(row.to_h)
    end
  end

  task invoice_items: :environment do
    invoice_items = CSV.read("./db/data/invoice_items.csv", headers: true, header_converters: :symbol)
    invoice_items.each do |row|
      InvoiceItem.create(row.to_h)
    end
  end

  task transactions: :environment do
    transactions = CSV.read("./db/data/transactions.csv", headers: true, header_converters: :symbol)
    transactions.each do |row|
      Transaction.create(row.to_h)
    end
  end
end
