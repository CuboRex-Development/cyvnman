class StocksController < ApplicationController
  def index
    @stocks = Stock.includes(:part).all
  end

  def edit
    @stock = Stock.find(params[:id])
  end

  def update
    @stock = Stock.find(params[:id])
    if @stock.update(stock_params.merge(updated_by: current_user.username))
      redirect_to stocks_path, notice: "Stock updated successfully"
    else
      flash.now[:alert] = @stock.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def stock_params
    params.require(:stock).permit(:quantity, part_attributes: [:id, :standard_price])
  end  
end
