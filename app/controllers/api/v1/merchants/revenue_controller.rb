class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.highest_revenue(params[:quantity]))
  end

  def show
    date = params[:date]
      # invoices = Invoice.joins(:invoice_items, :transactions).select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue").where("DATE(invoices.created_at) = '#{date}'").group("invoices.created_at").merge(Transaction.successful).order("revenue desc")
      # revenues = invoices.map { |invoice| invoice.revenue }
      # daily_total = revenues.sum
      # "#{daily_total/100.to_f}"
require "pry"; binding.pry
    render json: MerchantRevenueSerializer.new(Merchant.total_revenue_by_date(date))
    # render json: { data: { attributes: { total_revenue: Merchant.total_revenue_by_date(date)}}}
  end
end
