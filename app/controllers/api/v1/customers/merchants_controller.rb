class Api::V1::Customers::MerchantsController < ApplicationController
  def show
    customer = Customer.find(params[:customer_id])

    render json: MerchantSerializer.new(customer.favorite_merchant)
  end
end
