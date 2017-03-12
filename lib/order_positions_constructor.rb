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
      close_unselected_invitations(position_params)
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

  def close_unselected_invitations(params)
    position = Position.find_by(character_id: params[:character_id], order_id: order_instance.id)
    return unless position
    selected_actor_ids = params[:actors].select{|_key, data| to_bool(data[:checked])}.keys
    invitations = Invitation.where(position_id: position.id).where.not(actor_id: selected_actor_ids)
    invitations.each do |i|
      i.fire_events!(:close) if i.status != 'closed'
    end
  end

  def update_position(params)
    position = Position.find_by(character_id: params[:character_id], order_id: order_instance.id)
    d = order_instance.performance_date
    params[:start] = create_date_time(d, Time.parse(params[:start]))
    params[:stop] = create_date_time(d, Time.parse(params[:stop]))
    params[:fixed_start] = to_bool(params[:fixed_start])
    params[:fixed_stop] = to_bool(params[:fixed_stop])
    params[:payed] = to_bool(params[:payed])
    params[:animator_payed] = to_bool(params[:animator_payed])
    if position
      position.update_attributes(params)
    else
      position = Position.new(params)
      position.order = order_instance
      position.save!
    end
    position
  end

  # create DateTime from Date and Time with
  # correct Time Zone
  def create_date_time(d, t)
    DateTime.new.in_time_zone(Time.zone).change(year: d.year, month: d.month, day: d.day, hour: t.hour, min: t.min, sec: t.sec)
  end

  def to_bool(param)
    param == '1'
  end

end
