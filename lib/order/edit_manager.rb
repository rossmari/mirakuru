class Order::EditManager

  attr_reader :params, :order, :owners, :customer, :contact

  def initialize(params)
    @params = params
  end

  def prepare_params
    load_order
    load_customer
    load_contacts
    load_invitation_owners
  end

  def owner_uniq_invitations(owner)
    result = owner_invitations(owner)
    result.group_by(&:character_id).map{|_character_id, invitations| invitations.first}
  end

  def character_actors(character)
    Actor.by_character(character)
  end

  def actor_invited?(actor, owner, character)
    owner_invitations(owner).select{|i| i.character_id == character.id}.map(&:actor_id).include?(actor.id)
  end

  def load_invitation_owners
    @owners = invitations.map(&:owner).uniq
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

  def invitations
    if @order
      @order.invitations
    else
      []
    end
  end

  def owner_invitations(owner)
    invitations.select do |invitation|
      invitation.owner == owner
    end
  end

end