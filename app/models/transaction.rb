class Transaction < ApplicationRecord
  validates_presence_of :credit_card_number, :result
  validates_numericality_of :credit_card_number

  belongs_to :invoice
end
