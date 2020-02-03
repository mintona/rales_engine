class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :merchant
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  scope :customer, -> (id) {where("customer_id = ?", id)}
  scope :merchant, -> (id) {where("merchant_id = ?", id)}
  scope :created_at, -> (date) {where("DATE(invoices.created_at) = ?", date)}
end
