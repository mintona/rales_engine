class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_one_case_insensitive(search_params = {})
    attribute = search_params.keys.first
    value = search_params[attribute]
    self.find_by("LOWER(#{attribute}) = ?", value.downcase)
  end

  def self.find_all_case_insensitive(search_params = {})
    attribute = search_params.keys.first
    value = search_params[attribute]
    self.where("LOWER(#{attribute}) = ?", value.downcase)
  end

  def self.random
    self.order(Arel.sql('random()')).limit(1).first
  end

  def self.highest_revenue(limit)
    self.joins(invoices: [:invoice_items, :transactions]).select("#{self.name.pluralize}.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue").group(:id).merge(Transaction.successful).order("revenue DESC").limit(limit)
  end
end
