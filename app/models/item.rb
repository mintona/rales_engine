class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  # scope :find_all_case_insensitive, lambda { |attribute, value| where("LOWER(#{attribute}) = ?", value.downcase)}
  # scope :find_one_case_insensitive, lambda { |attribute, value| find_by("LOWER(#{attribute}) = ?", value.downcase)}
  # scope :find_all_case_insensitive, -> (attribute, value) { where("LOWER(#{attribute}) = ?", value.downcase)}
  # scope :find_all_by_name_case_insensitive, -> (name) { where("LOWER(name) = ?", name.downcase)}
  # scope :find_by_name_case_insensitive, -> (name) { find_by("LOWER(name) = ?", name.downcase)}

end
