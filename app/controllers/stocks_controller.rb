class StocksController < ApplicationController

  def search
    # checking if the text box has input
    if params[:stock].present?
      # calling the new_lookup method in the model with the params hash
      @stock = Stock.new_lookup(params[:stock])
      # if stock successfully saved then render the partial
      if @stock
        respond_to do |format|
          format.js { render partial: 'users/result' }
        end
      else
        flash[:alert] = "Please enter a valid symbol"
        redirect_to my_portfolio_path
      end
    else
      flash[:alert] = "Please enter a symbol to search"
      redirect_to my_portfolio_path
    end
  end

  def update
    @stocks = Stock.all
    @stocks.each do |stock|
      Stock.update_price(stock.ticker)
    end
    redirect_to my_portfolio_path
  end
end
