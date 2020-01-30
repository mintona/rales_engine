class Transaction < ApplicationRecord
  validates_presence_of :credit_card_number, :result
  validates_numericality_of :credit_card_number

  belongs_to :invoice
  #scope :successful, -> { where(result: 'success')}
  #scope is same as class method and then can bring into another model w/ .merge
end
