class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices

  def self.total_revenue_by_date(date)
    invoices = Invoice.joins(:invoice_items, :transactions).select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue").merge(Invoice.created_at(date)).group("invoices.created_at").merge(Transaction.successful).order("revenue desc")
    daily_total = invoices.map { |invoice| invoice.revenue }.sum
  end

  def favorite_customer
    Customer.joins(invoices: :transactions).select("customers.*, count(*)").merge(Invoice.merchant(self.id)).merge(Transaction.successful).group(:id).order("count desc").limit(1).first
  end
end
