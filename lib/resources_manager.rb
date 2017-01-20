class ResourcesManager

  attr_reader :actors, :characters, :objects

  def initialize
    @actors = get_actors.to_json
    @characters = get_characters.to_json
    @objects = get_objects.to_json
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
    Actor.all.map do |actor|
      actor_invitations = Invitation.accepted.where(actor_id: actor.id).where('start > ?', DateTime.now)
      [actor.id, actor_invitations.map{|i| {start: i.start, stop: i.stop}}]
    end.to_h
  end

  def get_characters
    Character.all.map do |character|
      {
        name: Order::Objects::Presenter.object_name(character),
        id: character.id
      }
    end
  end

  def get_objects
    objects = Order::Objects::Aggregator.aggregate
    Order::Objects::CollectionPresenter.present_collection(objects)
  end

end