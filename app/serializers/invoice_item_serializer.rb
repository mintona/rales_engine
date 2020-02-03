class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer

  extend IntegerToDollarsAndCents

  attributes :id, :quantity, :item_id, :invoice_id

  attribute :unit_price do |invoice_item|
    convert_to_dollars(invoice_item.unit_price)
  end
end
