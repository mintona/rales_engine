class ItemBestDaySerializer
  include FastJsonapi::ObjectSerializer

  set_type :item
  attributes :best_day
end
