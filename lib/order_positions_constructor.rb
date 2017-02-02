class OrderPositionsConstructor

  attr_accessor :params, :positions, :order_instance

  def initialize(params, order_instance)
    @params = params
    @order_instance = order_instance
  end

  def process!
    create_positions
  end

  private

  def create_positions
    return unless params.present?

    params.each do |_key, position_params|
      actors = position_params.delete(:actors) || []
      position = update_position(position_params)
      actors.each do |actor_id, params|
        next unless to_bool(params['checked'])

        invitation = Invitation.find_by(position_id: position.id, actor_id: actor_id)
        if invitation
          invitation.update(corrector: params['corrector'].to_f)
        else
          # new invitation
          invitation = Invitation.new(position_id: position.id, actor_id: actor_id, corrector: params['corrector'].to_f)
          invitation.save!
        end
      end
    end
  end

  def update_position(params)
    position = Position.find_by(character_id: params[:character_id], order_id: order_instance.id)
    if position
      position.update_attributes(params)
    else
      position = Position.new(params)
      position.order = order_instance
      position.save!
    end
    position
  end

  def to_bool(param)
    param == '1'
  end

end
