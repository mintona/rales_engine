class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  #invoice_items, through: :invoices
  #transactions, through: :invoices

  def self.highest_revenue(limit)
    select("merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue").joins("INNER JOIN invoices ON invoices.merchant_id = merchants.id INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id INNER JOIN transactions ON transactions.invoice_id = invoices.id").where(transactions: {result: "success"}).group(:id).order("revenue DESC").limit(limit)
  end
end
