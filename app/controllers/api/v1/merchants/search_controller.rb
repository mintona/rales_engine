class Api::V1::Merchants::SearchController < ApplicationController
  def index
    if search_params[:name]
      render json: MerchantSerializer.new(Merchant.name_nocase(search_params[:name]))
    else
      render json: MerchantSerializer.new(Merchant.where(search_params))
    end
  end

  def show
    render json: MerchantSerializer.new(Merchant.find_by(search_params))
  end

  private
    def search_params
      params.permit(:id, :name, :created_at, :updated_at)
    end
end
