class Api::V1::Transactions::SearchController < ApplicationController
  def index
    if search_params[:result]
      render json: TransactionSerializer.new(Transaction.find_all_case_insensitive(search_params))
    else
      render json: TransactionSerializer.new(Transaction.order(:id).where(search_params))
    end
  end

  def show
    if params[:result]
      render json: TransactionSerializer.new(Transaction.find_one_case_insensitive(search_params))
    else
      render json: TransactionSerializer.new(Transaction.order(:id).find_by(search_params))
    end
  end

  private
    def search_params
      params.permit(:id, :result, :credit_card_number, :invoice_id, :created_at, :updated_at)
    end
end
