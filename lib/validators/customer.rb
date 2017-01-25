class Validators::Customer

  attr_accessor :is_new_order, :params, :errors

  def initialize(params)
    @params = params
    @is_new_order = to_boolean(params[:is_new_order])
    @errors = {}
  end

  def validate
    objects = validation_objects
    objects.each do |object|
      self.send("validate_#{object}")
    end
  end

  private

  def validate_customer_id
    unless params[:customer_id].present?
      @errors[:customer_id] = 'Не может быть пустым'
    end
  end

  def validate_customer
    local_params = params[:customer]
    customer = Customer.new(name: local_params[:name], customer_type: local_params[:customer_type].to_i)
    unless customer.valid?
      @errors[:customer] = customer.errors.to_h
    end
  end

  def validation_objects
    if is_new_order
      [:customer]
    else
      [:customer_id]
    end
  end

  def to_boolean(value)
    value.to_i == 1
  end

end