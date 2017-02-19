class ResourcesManager

  attr_reader :actors, :characters, :objects,
              :stages, :customers

  def initialize
    @actors = get_actors.to_json
    @characters = get_characters.to_json
    @objects = get_objects.to_json
    @stages = get_stages.to_json
    @customers = get_customers.to_json
  end

  def get_customers
    Customer.all.map do |customer|
      {
        name: customer.name,
        id: customer.id,
        type: Customer.customer_types[customer.customer_type]
      }
    end
  end

  def get_actors
    invitations = actors_invitations
    Actor.all.map do |actor|
      {
        name: actor.name,
        id: actor.id,
        characters: actor.characters.map(&:id),
        invitations: invitations[actor.id]
      }
    end
  end

  def actors_invitations
    statuses = [Invitation.statuses[:assigned], Invitation.statuses[:accepted]]
    position_ids = Position.where('start > ?', DateTime.now).ids

    Actor.all.map do |actor|
      invitations = Invitation.where(actor_id: actor.id, status: statuses, position_id: position_ids)
      [actor.id, invitations.map{|i| {start: i.position.start, stop: i.position.stop}}]
    end.to_h
  end

  def get_characters
    invitations = characters_invitations
    Character.all.map do |character|
      {
        name: Order::Objects::Presenter.object_name(character),
        id: character.id,
        invitations: invitations[character.id]
      }
    end
  end

  def characters_invitations
    positions = Position.where('start > ?', DateTime.now)
    # complex logic - do we need this ?
    # positions = positions.select do |position|
    #   (position.invitations.map(&:status) & %w(assigned accepted)).any?
    # end

    result = {}
    positions.each do |position|
      result[position.character_id] ||= []
      result[position.character_id] <<
        {
          start: position.start.in_time_zone(Time.zone),
          stop: position.stop.in_time_zone(Time.zone),
          order_id: position.order_id
        }
    end
    result
  end


  def get_stages
    Stage.all.map do |stage|
      {
        description: stage.description,
        id: stage.id,
        name: stage.name,
        customers: stage.customers.ids
      }
    end
  end

  def get_objects
    objects = Order::Objects::Aggregator.aggregate
    Order::Objects::CollectionPresenter.present_collection(objects)
  end

end