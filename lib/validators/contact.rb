class Validators::Contact

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

  def validate_contact_id
    unless params[:contact_id].present?
      @errors[:contact_id] = 'Не может быть пустым'
    end
  end

  def validate_contact
    contact = Contact.new(params[:contact])
    unless contact.valid?
      @errors[:contact] = contact.errors.to_h
    end
  end

  def validation_objects
    if is_new_order
      [:contact]
    else
      [:contact_id]
    end
  end

  def to_boolean(value)
    value.to_i == 1
  end

end