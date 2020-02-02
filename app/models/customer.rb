class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices
  has_many :transactions, through: :invoices
  
  def favorite_merchant
    Merchant.joins(invoices: :transactions).select('merchants.*, count(*)').group(:id).merge(Transaction.successful).merge(Invoice.customer(self.id)).order('count desc').limit(1).first
  end
end
