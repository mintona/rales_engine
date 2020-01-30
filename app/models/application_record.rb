class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_one_case_insensitive(search_params = {})
    attribute = search_params.keys.first
    value = search_params[attribute]
    self.where("LOWER(#{attribute}) = ?", value.downcase).first
  end
end
