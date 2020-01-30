class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  #transactions, through: :invoices
  scope :name_nocase, -> (name) { where("LOWER(name) = ?", name.downcase)}

  def self.highest_revenue(limit)
    joins(invoices: [:invoice_items, :transactions]).select("merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue").group(:id).merge(Transaction.successful).order("revenue DESC").limit(limit)
  end
end
