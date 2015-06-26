class TransactionsController < ApplicationController
  skip_before_action: :authenticate_user!,
    only: [:new, :create]
  
  def new
    @product = Product.find_by!(permalink: params[:permalink])
  end

  def pickup
    @sale = Sale.find_by!(guid: params[:guid])
    @product = @sale.product
  end

  def create
  end
end
