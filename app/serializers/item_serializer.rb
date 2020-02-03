class ItemSerializer
  include FastJsonapi::ObjectSerializer

  extend IntegerToDollarsAndCents

  belongs_to :merchant

  attributes :id, :name, :description, :merchant_id

  attribute :unit_price do |item|
    convert_to_dollars(item.unit_price)
  end
end
