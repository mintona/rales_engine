class Api::V1::Merchants::CustomersController < ApplicationController
  def show
    # require "pry"; binding.pry
    merchant = Merchant.find(params[:merchant_id])
    # customer = Customer.joins(invoices: :transactions).select("customers.id, count(*)").where("invoices.merchant_id = #{merchant.id}").merge(Transaction.successful).group(:id).order("count desc").limit(1).first
    customer = Customer.joins(invoices: :transactions).select("customers.*, count(*)").where("invoices.merchant_id = #{merchant.id}").merge(Transaction.successful).group(:id).order("count desc").limit(1).first
    render json: CustomerSerializer.new(customer)
    # render json: CustomerSerializer.new(Merchant.find(params[:merchant_id]).favorite_customer)
  end
end
