class Order::ActorsManager

  attr_accessor :order, :positions

  def initialize(order_id)
    preload_order(order_id)
  end

  #
  # is actor available for selected position
  #
  def actor_free?(actor, position)
    !(actor_occupied?(actor, position) || actor_blocked?(actor, position))
  end

  #
  # actor is not suitable for this character
  #
  def actor_blocked?(actor, position)
    !actor.characters.ids.include?(position.character_id)
  end

  #
  # actor occupied for other performance
  #
  def actor_occupied?(actor, position)
    # search only accepted invitations
    statuses = [Invitation.statuses[:accepted], Invitation.statuses[:assigned]]
    positions = actor.invitations.where(status: statuses).map{|i| i.position}
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

  #
  # does actor has invitations ?
  #
  def actor_invited?(actor, position)
    !actor_invitation(actor, position).nil?
  end

  def actor_invitation(actor, position)
    invitations = position.invitations
    invitations.detect{|i| i.actor_id == actor.id}
  end

  private

  def character_actors(character)
    Actor.by_character(character)
  end

  def preload_order(order_id)
    if order_id
      @order = Order.find_by(id: order_id)
    else
      @order = nil
    end
  end

end
