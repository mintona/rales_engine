class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  #transactions, through: :invoices

  def self.total_revenue_by_date(date)
    invoices = Invoice.joins(:invoice_items, :transactions).select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue").where("DATE(invoices.created_at) = '#{date}'").group("invoices.created_at").merge(Transaction.successful).order("revenue desc")
    revenues = invoices.map { |invoice| invoice.revenue }
    daily_total = revenues.sum
    "#{daily_total/100.to_f}"
  end
end
