class Order::EditManager

  attr_reader :params, :order, :owners, :customer, :contact

  def initialize(params)
    @params = params
  end

  def prepare_params
    load_order
    load_customer
    load_contacts
    load_position_owners
  end

  def owner_positions(owner)
    order.positions.select do |position|
      position.owner == owner
    end
  end

  def load_position_owners
    @owners = order.positions.map(&:owner).uniq
  end

  def load_order
    @order = Order.find(params[:id])
    # prepare order attributes for edit
    @order.is_new_order = false
    @order.is_new_stage = false
  end

  def load_customer
    @customer = @order.customer
  end

  def load_contacts
    # selected contact
    @contact = @order.contact
  end

end