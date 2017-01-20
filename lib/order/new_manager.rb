class Order::NewManager

  attr_reader :order, :customer, :contact

  def initialize
    prepare_order
    prepare_customer
    prepare_contact
  end

  # create new empty order and set default params
  def prepare_order
    @order = Order.new
    @order.is_new_order = false
    @order.is_new_stage = true
    @order.child_birthday = Date.today
    @order.performance_date = Date.today
    @order.performance_time = Time.now
  end

  def prepare_customer
    @customer = Customer.new
  end

  def prepare_contact
    @contact = Contact.new
  end

end