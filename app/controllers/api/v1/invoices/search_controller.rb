class Api::V1::Invoices::SearchController < ApplicationController
  def index
    if search_params[:status]
      render json: InvoiceSerializer.new(Invoice.find_all_case_insensitive(search_params))
    else
      render json: InvoiceSerializer.new(Invoice.order(:id).where(search_params))
    end
  end

  def show
    if params[:status]
      render json: InvoiceSerializer.new(Invoice.find_one_case_insensitive(search_params))
    else
      render json: InvoiceSerializer.new(Invoice.order(:id).find_by(search_params))
    end
  end

  private
    def search_params
      params.permit(:id, :status, :merchant_id, :customer_id, :created_at, :updated_at)
    end
end
