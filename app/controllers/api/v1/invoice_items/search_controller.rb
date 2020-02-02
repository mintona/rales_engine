class Api::V1::InvoiceItems::SearchController < ApplicationController
  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.order(:id).where(search_params))
  end

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.order(:id).find_by(search_params))
  end

  private
    def search_params
      convert_unit_price if params[:unit_price]
      params.permit(:id, :quantity, :item_id, :invoice_id, :unit_price, :created_at, :updated_at)
    end

    def convert_unit_price
      if params[:unit_price].include?(".")
        params[:unit_price] = "#{(params[:unit_price].to_f * 100).round}"
      end
    end
end
