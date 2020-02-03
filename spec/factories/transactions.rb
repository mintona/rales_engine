FactoryBot.define do
  factory :transaction do
    credit_card_number { 4444555566668888 }
    credit_card_expiration_date { "MyString" }
    result { "success" }
    invoice
  end
end
