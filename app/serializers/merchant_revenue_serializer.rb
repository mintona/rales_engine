class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :total_revenue_by_date
end