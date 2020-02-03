class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity, :unit_price
  validates_numericality_of :quantity
  validates_numericality_of :unit_price

  belongs_to :invoice
  belongs_to :item

  scope :item, -> (id) {where("item_id = ?", id)}
end
