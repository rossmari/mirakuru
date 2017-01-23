class Api::OrdersController < ApplicationController

  def validate
    errors = {order: {}}
    contact_validator = Order::Validators::Contact.new(order_params)
    contact_validator.validate
    errors[:order].merge!(contact_validator.errors)

    customer_validator = Order::Validators::Customer.new(order_params)
    customer_validator.validate
    errors[:order].merge!(customer_validator.errors)
    # customer_constructor.process!
    # order_params = customer_constructor.cut_params
    # stage_constructor = OrderStageConstructor.new(order_params)
    # stage_constructor.process!
    # order_params = stage_constructor.cut_params
    # invitation_params = order_params.delete(:invitations)
    # @order = Order.new(order_params)
    # @order.contact = customer_constructor.contact
    # @order.customer = customer_constructor.customer
    # @order.stage = stage_constructor.stage
    # @order.save
    # invitations_constructor = OrderInvitationsConstructor.new(invitation_params, @order)
    # invitations_constructor.process!
    render json: { errors: ErrorsSerializer.new(errors).serialize }
  end

  def serialize_errors

  end

  def order_params
    params.require(:order).permit!
  end

end