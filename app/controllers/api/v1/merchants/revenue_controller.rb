class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.highest_revenue(params[:quantity]))
  end

  def show
    date = params[:date]
    # total_revenue = Merchant.total_revenue_by_date(date)
    # render json: MerchantRevenueSerializer.new(Merchant.total_revenue(date))
    render json: { data: { attributes: { total_revenue: Merchant.total_revenue_by_date(date)}}}
  end
end
