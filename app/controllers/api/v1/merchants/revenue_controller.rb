class Api::V1::Merchants::RevenueController < ApplicationController
  include IntegerToDollarsAndCents
  def index
    render json: MerchantSerializer.new(Merchant.highest_revenue(params[:quantity]))
  end

  def show
    render json: { data: { attributes: { total_revenue: convert_to_dollars(Merchant.total_revenue_by_date(params[:date]))}}}
  end
end
