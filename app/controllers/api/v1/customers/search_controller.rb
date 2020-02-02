class Api::V1::Customers::SearchController < ApplicationController
  def index
    if search_params[:name]
      render json: CustomerSerializer.new(Customer.find_all_case_insensitive(search_params))
    else
      render json: CustomerSerializer.new(Customer.where(search_params))
    end
  end

  def show
    if search_params[:name]
      render json: CustomerSerializer.new(Customer.find_one_case_insensitive(search_params))
    else
      render json: CustomerSerializer.new(Customer.find_by(search_params))
    end
  end

  private
    def search_params
      params.permit(:id, :first_name, :last_name, :created_at, :updated_at)
    end
end
