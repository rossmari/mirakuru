class Api::CostumePricePositionsController < ApplicationController

  def update
    @position = CostumePricePosition.find(params[:id])
    @position.update(update_params)
    render json: {status: 200}
  end

  def update_params
    params.require(:costume_price_position).permit(:partner, :open, :exclusive)
  end

end