class ItemBestDaySerializer
  include FastJsonapi::ObjectSerializer

  set_type :item

  attributes :best_day do |item|
    item.best_day.strftime('%Y-%m-%d')
  end
end
