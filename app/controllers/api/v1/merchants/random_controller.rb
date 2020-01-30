class Api::V1::Merchants::RandomController < ApplicationController
  def show
    merchant = Merchant.order(Arel.sql('random()')).limit(1)

    render json: MerchantSerializer.new(merchant)
  end
end
