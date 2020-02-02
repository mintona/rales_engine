class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :quantity, :item_id, :invoice_id

  attribute :unit_price do |invoice_item|
    "#{invoice_item.unit_price/100.to_f}"
  end
end
