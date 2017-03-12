class Validators::Positions

  attr_accessor :params, :errors, :order_instance,
                :is_new_order

  def initialize(params, is_new_order, order_instance)
    @params = params
    @errors = {positions: {}}
    @order_instance = order_instance
    @is_new_order = is_new_order
  end

  def validate
    return unless params.present?

    params.each do |key, position_params|
      actors = position_params.delete(:actors)
      if actors.select{ |_id, data| data[:checked] == '1' }.empty?
        @errors[:positions][key] = {}
        @errors[:positions][key][:actors] = 'Необходимо выбрать актеров'
      end

      position =
        if is_new_order
          position = find_position(position_params)
          position.assign_attributes(position_params)
        else
          new_position(position_params)
        end

      unless position.valid?
        @errors[:positions][key] ||= {}
        @errors[:positions][key].merge!(position.errors.to_h)
      end

    end
  end

  def new_position(params)
    Position.new(params)
  end

  def find_position(params)
    Position.find_by(order_id: order_instance.id,
                       owner_id: params[:owner_id],
                       owner_class: params[:owner_class])
  end

  def to_bool(param)
    param == '1'
  end

end
