class OrderCustomerConstructor

  attr_accessor :is_new_order, :params

  def initialize(params)
    @params = params
    @is_new_order = to_boolean(params[:is_new_order])
    @contact = nil
    @customer = nil
  end

  def process!
    process_contact
    process_customer
    save
  end

  private

  def save
    if is_new_order
      @customer.save!
      @contact.customer_id = @customer.id
      @contact.save!
    else
      true
    end
  end

  def process_contact
    @contact =
      if is_new_order
        Contact.new(params[:contact])
      else
        Contact.find(params[:contact_id])
      end
  end

  def process_customer
    @customer =
      if is_new_order
        c_params = params[:customer]
        Customer.new(
          {
            customer_type: c_params[:customer_type].to_i,
            name: c_params[:name]
          }
        )
      else
        Customer.find(params[:customer_id])
      end
  end

  def to_boolean(value)
    value.to_i == 1
  end

end