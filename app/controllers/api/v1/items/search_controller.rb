class Api::V1::Items::SearchController < ApplicationController
  def index
    if search_params[:name] || params[:description]
      render json: ItemSerializer.new(Item.find_all_case_insensitive(search_params))
    else
      render json: ItemSerializer.new(Item.where(search_params))
    end
  end

  def show
    if params[:name] || params[:description]
      render json: ItemSerializer.new(Item.find_one_case_insensitive(search_params))
    else
      render json: ItemSerializer.new(Item.order(:id).find_by(search_params))
    end
  end

  private
    def search_params
      convert_unit_price if params[:unit_price]
      params.permit(:id, :name, :description, :merchant_id, :unit_price, :created_at, :updated_at)
    end

    def convert_unit_price
      if params[:unit_price].include?(".")
        params[:unit_price] = "#{(params[:unit_price].to_f * 100).round}"
      end
    end
end
