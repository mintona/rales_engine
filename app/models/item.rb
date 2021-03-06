class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def best_day
    Invoice.joins(:invoice_items, :transactions).select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue").merge(InvoiceItem.item(self.id)).group(:id).merge(Transaction.successful).order("revenue DESC, invoices.created_at DESC").limit(1).first.created_at
  end
end
