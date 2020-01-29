FactoryBot.define do
  factory :invoice do
    status { "shipped" }
    customer
  end
end
