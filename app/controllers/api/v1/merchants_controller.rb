class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def most_revenue
    limit = params[:quantity]
    # merchants = Merchant.select("merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue").joins("INNER JOIN invoices ON invoices.merchant_id = merchants.id INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id INNER JOIN transactions ON transactions.invoice_id = invoices.id").where(transactions: {result: "success"}).group(:id).order("revenue DESC").limit(limit)
    merchants = Merchant.highest_revenue(limit)

    render json: MerchantSerializer.new(merchants)
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

  # private
  #request.query_params
  #   def find_params
  #     params.permit(:id, :name, :updated_at, :created_at)
  #   end
end
