class Api::OrdersController < ApplicationController

  def validate
    errors = {order: {}}
    contact_validator = Validators::Contact.new(contact_params)
    contact_validator.validate
    errors[:order].merge!(contact_validator.errors)

    customer_validator = Validators::Customer.new(customer_params)
    customer_validator.validate
    errors[:order].merge!(customer_validator.errors)

    stage_validator = Validators::Stage.new(stage_params)
    stage_validator.validate
    errors[:order].merge!(stage_validator.errors)

    order = Order.new(order_params)
    order.valid?
    errors[:order].merge!(order.errors.to_h)

    if invitations_params
      # invitations_validator = Validators::Invitation.new(invitations_params, order_params.include?('id'), nil)
      # invitations_validator.validate
      # errors[:order].merge!(invitations_validator.errors)
    else
      # errors[:order][:invitations] = 'Нужно выбрать персонажа или представление'
    end

    render json: { errors: ErrorsSerializer.new(errors).serialize }
  end

  def customer_params
    params.require(:order).permit(:is_new_order, :customer_id, customer: [:name, :customer_type])
  end

  def contact_params
    params.require(:order).permit(:is_new_order, :contact_id, contact: [:value, :notice])
  end

  def stage_params
    params.require(:order).permit(:is_new_stage, :stage_id,
                                  stage: [:district, :street, :house, :apartment, :description])
  end

  def order_params
    params.require(:order).permit(:id, :source, :child_name, :child_notice, :child_birthday,
                                  :guests_age_from, :guests_age_to, :performance_date,
                                  :performance_time, :performance_duration, :partner_money,
                                  :exclude_additional_expense, :exclude_additional_outcome, :partner_payed,
                                  :additional_expense, :order_calculations_notice)

  end

  def invitations_params
    if params[:order].keys.include?('invitations')
      params.require(:order).require(:invitations).permit!
    end
  end

end