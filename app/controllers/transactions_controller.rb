class TransactionsController < ApplicationController
  skip_before_action :authenticate_user!,
    only: [:new, :create]
  
  def new
    @product = Product.find_by!(permalink: params[:permalink])
  end

  def pickup
    @sale = Sale.find_by!(guid: params[:guid])
    @product = @sale.product
  end

  def create
    product = Product.find_by!(permalink: params[:permalink])
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        amount: product.price,
        currency: 'usd',
        source: token, 
        description: params[:stripeEmail]
        )
      @sale = product.sales.create!(
        email: params[:stripeEmail],
        stripe_id: charge.id
        )
       redirect_to pickup_url(guid: @sale.guid) #This line redirects to the url where the user picks up their purchase      
    
    rescue Stripe::CardError => e 
      # if stripe gets an error, the rescue method stores the error in a variable and redirects to :new route
      @error = e 
      render :new
    end
  end

  def download
    @sale = Sale.find_by!(guid: params[:guid])

    resp = HTTParty.get(@sale.product.file.url)

    filename = @sale.product.file.url
    send_data resp.body, :filename => File.basename(filename), :content_type => resp.headers['Content-Type']
  end

end
