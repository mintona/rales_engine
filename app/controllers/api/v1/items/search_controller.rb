class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name]
      attribute = search_params.keys.first
      value = search_params[attribute]

      render json: ItemSerializer.new(Item.find_one_case_insensitive(attribute, value))
    else
      render json: ItemSerializer.new(Item.find_by(search_params))
    end
  end

  private
    def search_params
      params.permit(:id, :name, :description, :unit_price, :created_at, :updated_at)
    end
end
