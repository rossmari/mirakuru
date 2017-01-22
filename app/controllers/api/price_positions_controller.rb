class Api::PricePositionsController < ApplicationController

  def update
    @position = PricePosition.find(params[:id])
    @position.update(update_params)
    render json: {status: 200}
  end

  def update_params
    params.require(:price_position).permit(:partner_salary, :open_salary, :exclusive_salary,
                                           :partner_price, :open_price, :exclusive_price)
  end

end