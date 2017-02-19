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
    positions.select do |position|
      position.owner == owner
    end
  end

  def character_actors(character)
    Actor.by_character(character)
  end

  def actor_invited?(actor, position)
    !actor_invitation(actor, position).nil?
  end

  def actor_occupied?(actor, position)
    # todo : search only accepted invitations
    # positions for interaction must have same character
    # belongs to another order
    positions = actor.invitations.map{|i| i.position}
                  .select{|p| p.character_id == position.character_id}
                  .reject{|p| p.order_id == order.id}
    positions.each do |occupied_position|
      # x - occupied_position
      # y - position
      # (x.first - y.end) * (y.first - x.end) >= 0
      if (occupied_position.start - position.stop) * (position.start - occupied_position.stop) >= 0
        return true
      end
    end
    false
  end

  def actor_blocked?(actor, position)
    !actor.characters.ids.include?(position.character_id)
  end

  def actor_invitation(actor, position)
    invitations = position.invitations
    invitations.detect{|i| i.actor_id == actor.id}
  end

  def load_position_owners
    @owners = positions.map(&:owner).uniq
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

  def positions
    if order
      order.positions
    else
      []
    end
  end

end