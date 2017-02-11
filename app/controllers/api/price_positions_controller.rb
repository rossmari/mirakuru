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

  def index
    position =  PricePosition.find_by(minutes: params[:time].to_i, animators_count: params[:animators_count])
    data =
      if position
        case params[:customer_type].to_i
          when Customer.customer_types[:partner]
            {price: position.partner_price, animator_money: position.partner_salary}
          when Customer.customer_types[:physical]
            {price: position.open_price, animator_money: position.open_salary}
          else
            {price: 0, animator_money: 0}
        end
      else
        {price: 0, animator_money: 0}
      end
    render json: data
  end

end