class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
  has_many :items #should this be here?
end
