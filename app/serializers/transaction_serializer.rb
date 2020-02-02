class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :result, :invoice_id
  attribute :credit_card_number do |transaction|
    "#{transaction.credit_card_number}"
  end

end
