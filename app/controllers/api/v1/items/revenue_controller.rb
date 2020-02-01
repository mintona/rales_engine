class Api::V1::Items::RevenueController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.highest_revenue(params[:quantity]))
  end

  def show
    item = Item.find(params[:item_id])
    render json: { data: {attributes: {best_day: item.best_day}}}
    # render json: ItemSerializer.new(Item.find(params[:item_id]))
  end
end
