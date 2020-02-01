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
end
