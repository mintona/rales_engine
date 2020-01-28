class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

#come back to this to finish created_at and updated_at
  def find
    if params[:id]
      render json: MerchantSerializer.new(Merchant.find_by(id: params[:id]))
    elsif params[:name]
      render json: MerchantSerializer.new(Merchant.find_by(name: params[:name]))
    # elsif params[:created_at]
    #   render json: MerchantSerializer.new(Merchant.find_by(created_at: params[:created_at].in_time_zone))
    end
  end
end
